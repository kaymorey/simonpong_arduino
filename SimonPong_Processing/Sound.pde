class Sound {
    AudioPlayer player;

    Sound(Minim minim, String file)
    {
        player = minim.loadFile(file, 2048);
    }
}