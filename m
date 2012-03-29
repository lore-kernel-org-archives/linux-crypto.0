From: Dale Amon <amon@vnl.com>
Subject: Re: Status of aes in Debian/Ubuntu? (UNCLASSIFIED)
Date: Thu, 29 Mar 2012 23:53:33 +0100
Message-ID: <20120329225333.GU10584@vnl.com>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
 <20120328190322.GA16113@greengrey.org>
 <20120328204234.GD10584@vnl.com>
 <4F737F41.1090309@redhat.com>
 <20120328213305.GG10584@vnl.com>
 <7540e2c9ee52.4f740894@us.army.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, Dale Amon <amon@vnl.com>,
	linux-crypto@vger.kernel.org,
	"C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>,
	Ryan Corder <ryanc@greengrey.org>
To: "roosa, william MAJ RES" <william-roosa@us.army.mil>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grendel.xisp.net ([96.255.255.193]:58661 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760168Ab2C2WyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 18:54:06 -0400
Content-Disposition: inline
In-Reply-To: <7540e2c9ee52.4f740894@us.army.mil>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Just thought it might be useful for someone else
in the future if I feed back the results of some
of my tests.

The first test is the set up of a dm-crypt based
loop back partition:

	# Create a file for our little 30GB test disk
	dd if=/dev/zero of=other.ext4 count=60M

	# Connect it as a loop back.
	losetup /dev/loop0 other.ext4

	# Do a badblocks check that leaves random data on
	# the 'underlying' media.
	badblocks -c 10240 -s -w -t random -v /dev/loop0

	# Generate the partition table and create a single
	# partition
	cfdisk /dev/loop0

	# We will need kpartx to make the partition accessible
	apt-get install kpartx
	kpartx -a -v /dev/loop0
	ls -alF /dev/mapper

	# Now make it a crypt partition and give it a password
	cryptsetup --verbose --verify-passphrase luksFormat /dev/mapper/loop0p1
	WARNING!
	========
	This will overwrite data on /dev/mapper/loop0p1 irrevocably.
	Are you sure? (Type uppercase yes): YES
	Enter LUKS passphrase: 
	Verify passphrase: 
	Command successful.

	# Do the partition crypto set up and give it a device name:
	cryptsetup luksOpen /dev/mapper/loop0p1 junk1
	Enter passphrase for /dev/mapper/loop0p1: 

	# Now put a file system on it, create a mount point and
	# mount it.
	 mkfs.ext4 /dev/mapper/junk1 -m 0.0 -L "WhoIsJohnGalt"
	 mkdir /junk1
	 mount /dev/mapper/junk1 /junk1

The remaining puzzle bits here are the issue of how to make
this work off of /etc/fstab, if that is possible. I also am
going to see if the resulting file backed crypto disk is
directly mountable on a VM as well. 

In addition, I still also want to take a look at what it takes
to make loop-aes work. I was more involved with the cryptoloop
guys way back when and AFAIK, it's dead and gone.

Any suggestions about the fstab issues are welcome.
