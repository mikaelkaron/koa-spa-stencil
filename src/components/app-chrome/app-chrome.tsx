import { h, Component, ComponentInterface } from '@stencil/core';
import { IconLoader } from '../icons';

@Component({
  tag: 'app-chrome',
  styleUrl: 'app-chrome.scss',
  shadow: true
})
export class AppChrome implements ComponentInterface {
  render() {
    return <IconLoader width='50vw' height='50vh' />
  }
}
