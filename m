From: Dale Amon <amon@vnl.com>
Subject: Re: Status of aes in Debian/Ubuntu?
Date: Wed, 28 Mar 2012 21:42:35 +0100
Message-ID: <20120328204234.GD10584@vnl.com>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
 <20120328190322.GA16113@greengrey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>,
	Dale Amon <amon@vnl.com>, linux-crypto@vger.kernel.org,
	"roosa, william MAJ RES" <william-roosa@us.army.mil>
To: Ryan Corder <ryanc@greengrey.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grendel.xisp.net ([96.255.255.193]:51850 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758014Ab2C1Um4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 16:42:56 -0400
Content-Disposition: inline
In-Reply-To: <20120328190322.GA16113@greengrey.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 28, 2012 at 12:03:22PM -0700, Ryan Corder wrote:
> Full disk encryption with LUKS is actually pretty easy, and I do have the full
> process written down.  I've been looking for a reason to actually type it out
> for later use...I'll do that later today and then send it on for reference.

Nothing so complicated... I've been through this
at the arcane level a decade ago. What I was looking for 
was the status of doing the following:


	apt-get install <listofpackages>

	dd if=/dev/zero of=mynew.ext4 count=30G
	losetup -e aes256 /dev/loop0 mynew.ext
	password: <type in the magic phrase>

		go out for coffee

	mkfs.ext4 /dev/loop0 -m 0.0 -L "WhoIsJohnGalt"
        mount -t ext4 /dev/loop0 /mnt

The kernel is an out of the box Ubuntu 3.0.0-17-generic-pae.

The losetup man page on Ubuntu host shows:

   -e encryption
      Enable data encryption. Following encryption types are recognized:
              NONE   Use no encryption (default).
              XOR    Use a simple XOR encryption.
              AES128 AES
                Use 128 bit AES encryption. Passphrase is hashed with 
		SHA-256 by default.
              AES192 Use 192 bit AES encryption. Passphrase is hashed
		with SHA-384 by default.
              AES256 Use 256 bit AES encryption. Passphrase is hashed
		with SHA-512 by default.
              twofish128 twofish160 twofish192 twofish256
              blowfish128 blowfish160 blowfish192 blowfish256
              serpent128 serpent192 serpent256 mars128 mars192
              mars256 rc6-128 rc6-192 rc6-256 tripleDES
                 These encryption types are available if they are
		 enabled in kernel configuration or corresponding
		 modules have been loaded to kernel.

However if you look in 

	/lib/modules/3.0.0-17-generic-pae/kernel/crypto/

there seems to be everything under the sun except AES.

Now it used to be the case that AES was pretty much the default.
I know Jaari pushed it really hard. In any case, I found a
package to load:


 *** Opt universe loop-aes-sou 3.3a-2      3.3a-2      source for loop-AES encryption modules                                                                             
 *** Opt universe loop-aes-tes 3.3a-2      3.3a-2      test suite for loop-AES encryption modules
 *** Opt universe loop-aes-uti 2.16.2-2ubu 2.16.2-2ubu Tools for mounting and manipulating filesystems

I duly installed them. This put a do it yourself package
into /usr/src/:
	loop-aes.tar.bz2

Now, reading

	/usr/share/doc/loop-aes-source/README.Debian

I see the following options:

Quick start
-----------

  $ apt-get install loop-aes-utils

  for Debian kernels
    $ m-a auto-install loop-aes

  for custom kernels
    $ cd /usr/src
    $ tar -xjf loop-aes.tar.bz2
    $ cd /path/to/kernel
    $ make-kpkg modules_image
    $ dpkg -i /usr/src/loop-aes*.deb

Building loop-AES with module-assistant
---------------------------------------

  module-assistant makes it very easy to build loop-AES packages
  for both Debian kernels and custom kernels. It is also the 
  recommended way to build loop-AES on Debian systems.
  
  The below command builds and installs a loop-AES module package
  for the currently running kernel:

    # module-assistant auto-install loop-aes


So, using that command while sitting in /usr/src:

   module-assistant auto-install loop-aes

   It runs for awhile 
	# module-assistant auto-install loop-aes
	Updated infos about 1 packages
	Getting source for kernel version: 3.0.0-17-generic-pae
	apt-get install linux-headers-3.0.0-17-generic-pae 
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	linux-headers-3.0.0-17-generic-pae is already the newest version.
	0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
	apt-get install build-essential 
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	build-essential is already the newest version.
	0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.

  And then gives me three different panels to read:

   Bad luck, the kernel headers for the target kernel version could
   not be found and you did not specify other valid kernel headers
   to use. 

   However, you can install the header files for your kernel which
   are provided by the linux-headers-3.0.0-17-generic-pae package.
   For most modules packages, these files are perfectly sufficient
   without having the original kernel source.
   To install the package, run the PREPARE command from the main
   menu, or on the command line:
              module-assistant prepare

   Package loop-aes-source was not built successfully, see
   /var/cache/modass/loop-aes-source*buildlog* for details!

  and that log has the following relevant text:

   make[3]: Entering directory `/KdevRoot/src/linux-headers-3.0.0-17-generic-pae'
   make[4]: *** No rule to make target `/KdevRoot/src/modules/loop-aes/tmp-d-kbuild/patched-loop.c', needed by `/KdevRoot/src/modules/loop-aes/tmp-d-kbuild/patched-loop.o'.  Stop.

So does anyone have a suggestion as to where I have 
gone wrong? It's been over half a decade since I've
gone through this and even longer since I was doing
the magic dance with patching and building my own 
losetup, mount, etc...
