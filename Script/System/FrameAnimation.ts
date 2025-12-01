// @preview-file off clear
import { Content, Path, Sprite, sleep, Node, App, Cache, CacheResourceType, wait, thread, Opacity } from 'Dora';

const frameLoading = new Map<string, boolean>;

export function preloadFrame(folder: string) {
	frameLoading.set(folder, true);
	thread(() => {
		const files = Content.getAllFiles(folder).filter(f => {
			const ext = Path.getExt(f);
			return ext === 'png' || ext === 'jpg';
		}).sort();
		Cache.loadAsync(files.map(f => Path(folder, f)));
		frameLoading.delete(folder);
	});
}

export function playFrame(folder: string, duration: number, loop: boolean, x: number, y: number, scale: number): Node.Type {
	const node = Node();
	node.x = x;
	node.y = y;
	node.scaleX = node.scaleY = scale;
	node.onCleanup(() => {
		thread(() => {
			sleep(0.5);
			collectgarbage();
			Cache.removeUnused();
		});
	});
	node.perform(Opacity(0.3, 0, 1));
	const files = Content.getAllFiles(folder).filter(f => {
		const ext = Path.getExt(f);
		return ext === 'png' || ext === 'jpg';
	}).sort();
	const interval = math.max(1.0 / App.targetFPS, duration / files.length);
	let lastSprite: null | Sprite.Type = null;
	const animation = () => {
		if (frameLoading.get(folder)) {
			wait(() => !frameLoading.get(folder));
		} else if (!frameLoading.has(folder)) {
			frameLoading.set(folder, true);
			Cache.loadAsync(files.map(f => Path(folder, f)));
			frameLoading.delete(folder);
		}
		for (let f of files) {
			if (lastSprite) {
				lastSprite.removeFromParent();
			}
			lastSprite = Sprite(Path(folder, f));
			lastSprite?.addTo(node);
			sleep(interval);
		}
		return false;
	};
	if (loop) {
		node.loop(animation);
	} else {
		node.once(animation);
	}
	return node;
};
