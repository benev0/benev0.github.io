let storageResult = localStorage.getItem('DarkModePreferred');
var preferDark  = JSON.parse(storageResult ? storageResult : 'null');
if (preferDark === null) {
  preferDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
}
if (preferDark === null) {
  preferDark = false;
}
document.documentElement.dataset.appliedMode = preferDark ? 'dark' : 'light';
