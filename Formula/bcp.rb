require 'formula'

class Bcp < Formula

  version '0.0.1'
  homepage 'https://github.com/jwilberding/bcp'
  url 'https://github.com/jwilberding/bcp/archive/v0.0.1.zip'
  sha1 '88f7da87f44ec7321bbe2814e03d51624857be75'

  def install

    system "make"
    bin.install('bcp')
    (prefix+'bash_utils.sh').write bash_utils

  end

  def bash_utils; <<-EOS.undent
    # zip directory to /tmp and bcp it
    bcpdir() {

      [ "$#" -gt 0 ] || { echo "The path is required!"; return; }

      curr_time=`date +%s`
      file=/tmp/files_$curr_time.zip

      if [[ -d $1 ]]; then

        # dir
        cd $1
        zip -r -9 $2 $file .

      elif [[ -f $1 ]]; then

        # single file
        file_dir=`dirname $1`
        file_name=`basename $1`
        cd $file_dir
        zip -r -9 $2 $file $file_name

      else
        echo "$1 is not valid!"
        exit 1
      fi

      bcp $file
      rm $file
      cd -

    }

    # zip file/directory with password to /tmp and bcp it
    bcppass() {

      [ "$#" -gt 0 ] || { echo "The path is required!"; return; }
      bcpdir $1 -e

    }
    EOS
  end

  def caveats; <<-EOS.undent

      bcp was installed to:
        #{opt_prefix}

      To make file availabe for copying:
        bcp filename

      To receive the file:
        bcp

      If you also want
        bcpdir: to send directories
        bcppass: to send files/directories protected with password

      add the following to your ~/.bash_profile
        source #{opt_prefix}/bash_utils.sh

    EOS
  end

  def test
    system "bcp"
  end

end
