export type InputEvent<T extends Element> = {
  target: T;
} & UIEvent;

export const dataProps = (data: Record<string, any>) =>
  Object.keys(data).reduce((d, k) => ({ ...d, [`data-${k}`]: data[k] }), {});
