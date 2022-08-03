<?php

namespace App\Http\Controllers;

use App\Models\Image;
use Faker\Core\File;
use Illuminate\Http\File as HttpFile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File as FacadesFile;
use Illuminate\Validation\Rules\ImageFile;

class ImageController extends Controller
{
    public function addImage(Request $request)
    {
        $path = $request->file('imagejun')->store('images');
        Image::create([
            'url' => $path,
            'title' => $request['title']
        ]);
    }

    public function getImages()
    {
        return response([
            'images' => DB::table('images')->get()
        ]);
    }
    public function image($fileName)
    {
        return response()->file(storage_path('app/images/' . $fileName));
    }
}
