import { Routes } from '@angular/router';
import { InfoComponent } from './info/info.component';
import { BlogComponent } from './blog/blog.component';
import { NoPageComponent } from './no-page/no-page.component';
import { BlogContentComponent } from './blog-content/blog-content.component';
import { SettingsComponent } from './settings/settings.component';

export const routes: Routes = [
        { path: '', component: InfoComponent, title: 'info', data:{navBar:true, routerLinkOptions:{exact:true}}},
        { path: 'blog', component: BlogComponent, title: 'blog', data:{navBar:true, routerLinkOptions:{exact:false}}, children: [
                { path: ':name', component: BlogContentComponent, title: 'blog'},
        ]},
        { path: 'settings', component: SettingsComponent, title: 'settings', data:{navBar:true, routerLinkOptions:{exact:true}}},
        { path: '**', pathMatch: 'full',  component: NoPageComponent, data:{navBar:false, routerLinkOptions:{exact:true}}},
];
