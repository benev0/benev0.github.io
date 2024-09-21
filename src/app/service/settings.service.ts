import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SettingsService {
  private isDarkMode = false;
  public isDarkModeSubject = new BehaviorSubject(false);

  constructor() {
    // redundant check (see index.html)
    let storageResult = localStorage.getItem('DarkModePreferred');
    let storageValue  = JSON.parse(storageResult ? storageResult : 'null');

    if (storageValue !== null) {
      this.isDarkMode = storageValue;
      this.isDarkModeSubject.next(this.isDarkMode);
      this.changeMode();
      return;
    }

    this.tryCheckPreferenceDarkMode();
  }

  private tryCheckPreferenceDarkMode() : void {
    this.isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    this.isDarkModeSubject.next(this.isDarkMode);
    this.changeMode();
  }

  private changeMode() : void {
    let bodyStyles = document.body.style;
    document.documentElement.dataset['appliedMode'] = this.isDarkMode ? 'dark' : 'light';
    localStorage.setItem('DarkModePreferred', JSON.stringify(this.isDarkMode));
  }

  public toggleDarkMode() : void {
    this.isDarkMode = !this.isDarkMode;
    this.isDarkModeSubject.next(this.isDarkMode);
    this.changeMode();
  }
}
