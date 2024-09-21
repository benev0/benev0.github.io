import { Component } from '@angular/core';
import { SettingsService } from '../service/settings.service';

@Component({
  selector: 'app-settings',
  standalone: true,
  imports: [],
  templateUrl: './settings.component.html',
  styleUrl: './settings.component.css'
})
export class SettingsComponent {
  constructor(private SettingsService : SettingsService) {}

  toggleDarkMode() : void {
    this.SettingsService.toggleDarkMode()
  }
}
