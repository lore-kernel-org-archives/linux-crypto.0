From: Markus Huehnerbein <silencer@gmx.ch>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Thu, 30 Aug 2007 20:25:53 +0200
Message-ID: <46D70BB1.907@gmx.ch>
References: <46D579AB.5040304@gmx.ch> <20070829141549.GD24782@Chamillionaire.breakpoint.cc> <46D585B5.9090607@gmx.ch> <20070829162200.GE24782@Chamillionaire.breakpoint.cc> <46D5D716.4040903@gmx.ch> <20070830090128.GA29936@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51236 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932316AbXH3SZ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 14:25:56 -0400
In-Reply-To: <20070830090128.GA29936@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> device-mapper: table: 254:1: crypt: Error initializing ESSIV hash
> This error message should only come up if dm was not able to allocate
> the hash in kernel so may miss SHA256 support.
By the output of lsmod the sha256 module is loaded. But anyway, I think
in order to benefit from the geode the only way is to use md5, as there
is no other digest that provides a 128-bit value - execpt maybe tiger.

>>
>> Preparing the Volume with:
>> 	cryptsetup -c aes-cbc-essiv:md5 -y -s 128 luksFormat /dev/hda2
>> works fine ("Command successful" and no errors in the syslog) but when I
>> try to open the device
>> 	cryptsetup luksOpen /dev/hda2 devdmcryptluks
>> I get "Command failed." after entering the (correct) password. I also
>> tried "luksOpen" with the same arguments as "luksFormat" but the same -
>> "Command failed." without any trace in the syslog...
> 
> That should have work. Does it work with the generic aes driver instead
> of geode?

Yes, with the generic driver luksFormat as well as luksOpen works fine.

I thought that the problem is maybe related with the use of LUKS / the
Master-Key created by the PBKDF2, so I tried cryptsetup without LUKS as
follows (with the "geode_aes" module loaded):
	cryptsetup -y -c aes -h md5 -s 128 create devdmcrypt /dev/hda2
-No errors, neither in syslog nor in the output
-Checking the output of "dmsetup ls":
	devdmcrypt      (254, 0)
-Creating ext2 filesystem
	mkfs.ext2 /dev/mapper/devdmcrypt
-Trying to mount /dev/mapper/devdmcrypt fails with "wrong fs type..."
and syslog error: "VFS: Can't find an ext2 filesystem on dev dm-0"

I'm not sure whether the problems are linked to each other or not but
maybe it could be of interesst.

--Markus
