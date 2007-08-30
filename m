From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Thu, 30 Aug 2007 11:01:28 +0200
Message-ID: <20070830090128.GA29936@Chamillionaire.breakpoint.cc>
References: <46D579AB.5040304@gmx.ch> <20070829141549.GD24782@Chamillionaire.breakpoint.cc> <46D585B5.9090607@gmx.ch> <20070829162200.GE24782@Chamillionaire.breakpoint.cc> <46D5D716.4040903@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Markus Huehnerbein <silencer@gmx.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36919 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbXH3JBd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 05:01:33 -0400
Content-Disposition: inline
In-Reply-To: <46D5D716.4040903@gmx.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Markus Huehnerbein | 2007-08-29 22:29:10 [+0200]:

>Yes, again you're right, if I use a hash with 256 bit I get the
>following syslog errors:
>
>device-mapper: table: 254:1: crypt: Error initializing ESSIV hash
This error message should only come up if dm was not able to allocate
the hash in kernel so may miss SHA256 support.

>device-mapper: ioctl: error adding target to table
>device-mapper: ioctl: device doesn't appear to be in the dev hash table.


>Unfortunately there is no support for sha128 in the Kernel so I tried
well there is no sha128. I was probabaly thinking of sha1 but that one
generates 160 bit long signatures.

>md5 as md5 also generates a 128 bit value.
>
>Preparing the Volume with:
>	cryptsetup -c aes-cbc-essiv:md5 -y -s 128 luksFormat /dev/hda2
>works fine ("Command successful" and no errors in the syslog) but when I
>try to open the device
>	cryptsetup luksOpen /dev/hda2 devdmcryptluks
>I get "Command failed." after entering the (correct) password. I also
>tried "luksOpen" with the same arguments as "luksFormat" but the same -
>"Command failed." without any trace in the syslog...

That should have work. Does it work with the generic aes driver instead
of geode?

>Markus

Sebastian
