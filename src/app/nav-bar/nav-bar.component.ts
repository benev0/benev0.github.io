import { Component } from '@angular/core';

import { routes } from '../app.routes';
import { RouterModule } from '@angular/router';
import { NoPageComponent } from '../no-page/no-page.component';

@Component({
  selector: 'app-nav-bar',
  standalone: true,
  imports: [
    RouterModule
  ],
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css'
})
export class NavBarComponent {
  routes = routes.filter((route) => {
    return route.data !== undefined && route.data!["navBar"];
  });
}
