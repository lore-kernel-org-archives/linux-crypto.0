From: Markus Huehnerbein <silencer@gmx.ch>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 22:29:10 +0200
Message-ID: <46D5D716.4040903@gmx.ch>
References: <46D579AB.5040304@gmx.ch> <20070829141549.GD24782@Chamillionaire.breakpoint.cc> <46D585B5.9090607@gmx.ch> <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755553AbXH2U3N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 16:29:13 -0400
In-Reply-To: <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Sebastian Siewior wrote:
> * Markus Huehnerbein | 2007-08-29 16:41:57 [+0200]:
> 
>> Thanks a lot! I confirm that it works with "-s 128" and also if "-s" is
>> skipped! But if I try to use cryptsetup with ESSIV (cryptsetup -c
>> aes-cbc-essiv:sha256 -y -s 128 luksFormat /dev/hda2) I get the same
> what about sha128 instead?
> 
>> error. If the "geode-aes" does not support essiv why is this task not
>> performed by another algorithm in the cryptoAPI?
> Actually it is. geode does not support keys != 128 bit. ESSIV uses as
> key the output of sha256 what is 256. Check dmesg please. If my theory
> is correct than you should see in dmesg or somewhere:
> "Failed to set key for ESSIV cipher"
> Is it?

Yes, again you're right, if I use a hash with 256 bit I get the
following syslog errors:

device-mapper: table: 254:1: crypt: Error initializing ESSIV hash
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.

Unfortunately there is no support for sha128 in the Kernel so I tried
md5 as md5 also generates a 128 bit value.

Preparing the Volume with:
	cryptsetup -c aes-cbc-essiv:md5 -y -s 128 luksFormat /dev/hda2
works fine ("Command successful" and no errors in the syslog) but when I
try to open the device
	cryptsetup luksOpen /dev/hda2 devdmcryptluks
I get "Command failed." after entering the (correct) password. I also
tried "luksOpen" with the same arguments as "luksFormat" but the same -
"Command failed." without any trace in the syslog...

> 
>> Thanks,
>> Markus
> 
> Sebastian
> 
Thanks again,
Markus
