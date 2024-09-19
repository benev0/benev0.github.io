import { Routes } from '@angular/router';
import { InfoComponent } from './info/info.component';
import { BlogComponent } from './blog/blog.component';
import { NoPageComponent } from './no-page/no-page.component';
import { BlogContentComponent } from './blog-content/blog-content.component';

export const routes: Routes = [
        { path: '', component: InfoComponent, title: 'info', data:{"navBar":true}},
        { path: 'blog', component: BlogComponent, title: 'blog', data:{"navBar":true}, children: [
                { path: ':name', component: BlogContentComponent, title: 'blog'},
        ]},
        { path: '**', pathMatch: 'full',  component: NoPageComponent, data:{"navBar":false}},
];
