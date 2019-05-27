# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      artist_check
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      song_check
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: "Artist not found"
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id]
      check_song_and_artist
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  def artist_check
    if @artist.nil?
      redirect_to artists_path, alert: "Artist not found"
    else
      @songs = @artist.songs
    end
  end

  def song_check
    redirect_to redirect, alert: "Song not found" if @song.nil?
  end

  def check_song_and_artist
    @artist = Artist.find_by(id: params[:artist_id])
    if @artist.nil?
      redirect_to artists_path, alert: "Artist not found"
    else
      @song = @artist.songs.find_by(id: params[:id])
      song_check
    end
  end

  def redirect
    artist_songs_path(@artist)
  end

private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end
