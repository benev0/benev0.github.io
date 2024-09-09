export interface BlogEntry {
        title: string;
        blurb: string;

        author: string;
        authorLink: string | undefined;
        published: Date | undefined;
}
