From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Date: Tue, 1 Sep 2009 23:11:55 +0200
Message-ID: <20090901211155.GA13979@Chamillionaire.breakpoint.cc>
References: <20090825195852.1dfacb6c.celejar@gmail.com> <20090827095516.6817be1e.randy.dunlap@oracle.com> <20090827183500.GC24973@resivo.wgnet.de> <20090827123401.86cd4319.randy.dunlap@oracle.com> <20090828080056.GA3204@Chamillionaire.breakpoint.cc> <20090830153722.GA28497@Chamillionaire.breakpoint.cc> <20090831155200.GD7678@resivo.wgnet.de> <20090831211639.GA4675@Chamillionaire.breakpoint.cc> <20090901005120.GB22049@resivo.wgnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Celejar <celejar@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, 541835@bugs.debian.org,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Jonas Meurer <jonas@freesources.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43261 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZIAVL6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Sep 2009 17:11:58 -0400
Content-Disposition: inline
In-Reply-To: <20090901005120.GB22049@resivo.wgnet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Jonas Meurer | 2009-09-01 02:51:20 [+0200]:

>as you already discovered, that's because the initramfs hook script for
>cryptroot adds some crypto modules manually in debian. currently these
>are dm-mod, dm-crypt, cbc, aes, sha256 and all the modules they depend
>on.

You could add something like
|for dev in $rootdev $resumedevs; do
|       info="$(cryptsetup luksDump $rootdev)"
|       if [ $? -ne 0]; then
|               # Partition is now encrypted
|               continue
|       fi
|       cipher="$(cryptsetup luksDump /dev/md1 |grep "Cipher name:" | \
|            sed 's@^Cipher name:\s\+@@')"
|       add_crypto_modules $cipher
|       mode="$(cryptsetup luksDump /dev/md1 |grep "Cipher name:")"
|       echo "$mode" | sed \
|               -e 's@^Cipher name:\s\+@@') \
|               -e 's@-@ @' \
|               -e 's@:@ @'
|       # mode is now "<block_mode> <IV_mode> <hash>"
|       blk_mode=$(echo $mode | awk '{print $1}'
|       hash=$(echo $mode | awk '{print $3})'
|       add_crypto_modules $blk_mode
|       add_crypto_modules $hash
|done       
instead of hardcoding cbc, aes & sha256

>> So this brings me to the following question: Why are you so picky and you
>> don't take all of the modules? sh 2.6.30-1 on various debian archs:
>> du -sh              x86_64  i386  powerpc  s390x   mips(r5k-ip32)
>> crypto              720K    636K  1.1M     804K    968K
>> arch/<arch>/crypto  72K     36K   0        92K     0
>> driver/crypto       32K     60K   60K      0       52K
>> Total               824K    732K  1.2M     896K    1020
>> 
>> So all modules together have an average footprint of 941.0K. This isn't
>> that much. There is no size limit on initrd unless you are on a system
>> with has 32MiB or something like that :)
>> With *all* those crypto modules which are selected and built you are
>> able to cover all corner cases.
>> I took a look at hooks/cryptroot and really and only a few modules are
>> included. Right now you don't include HW cipher e.g. VIA's padlock or
>> AMD's geode. If you don't load those module while openning the root
>> partition (the first request), then the module is never loaded / used.
>> The other unhandled case are non default ciphers like xts(aes) which one
>> might use. The brand new aes implementation aesni-intel is also not be
>> considered. Most modules have _generic in their name if there is
>> another implementation available and <name>-arch if there is an assembly
>> variant but I would prefer that this does not become part of an ABI
>> where one can rely on.
>> 
>> Would it be okay for you to change the way the crypto modules are picked
>> and include the full set?
>
>i don't like the idea to add _all_ crypto modules into the initramfs per
>default. the size of crypto and arch/<arch>/crypto will keep on growing
>for kernels which do have ship all available modules for ciphers and
>implementations. i think that the initramfs should be a _minimal_
>system, and detecting the required crypto modules should be possible.
Why is a minimal initramsfs here a good thing here? 1 MiB isn't that
huge and with gzip it does not grow much. Here is an example on my amd64
with current initramfs as of 2.6.30-1-amd64:
picky       : 10511917 bytes / 11 MiB
full crypto : 10729154 bytes / 11 MiB / + 2.1%

So. On AMD64 we are talking here about 200KiB or 2% of the whole image
size.
If arch/*/crypto grows than just because there is more support and this
is a good thing not bad.

>alternative crypto cipher and blockcipher modules are already detected
>if required, as information about these are available from the cryptroot
>configuration (either luks header or cmdline options given to cryptsetup).
ah so my little script was not required. What about d-i? AFAIK that one
runs from initramfs and relies on modules which are selected here. Isn't
this the case?

>i added cryptomgr, chainiv and krng to the list of required modules in
>/usr/share/initramfs-tools/hooks/cryptroot for now.
And in .32 you have work again because you need eseqiv.

>still i see the point that this solution has it's drawbacks. modules for
>crypto hardware and cipher implementations not following the convention to
>call modules <cipher>_generic and <cipher>-alias aren't detected by the
>current system.
exactly. Plus runtime dependency.

>i guess the best solution would be to improve the module dependency
>system. cipher meta-modules like 'aes' should depend on all available
>implementations. same for ivciphers, hashs, rng implementations etc.
>
>what do you think about it?
I don't the like extra work for 2%. Even if someone does this, you still
have lets say the geode, via-padlock and the hfin driver on a 486 system
which can't use all of them and relies on pure SW. No benefit there.

Okay. You put the crypto modules in initramfs in case the root partition
and or swap is encrypted. In case just /data is encrypted you don't need
those modules at all. So d-i needs all them in case the user might want
to xts(twofish) and not just the standard thing. The user-initramfs
script could take the full set of crypto modules if it is building a new
initramfs and grab the list of required modules from lsmod if the
initramfs is updated and the kernel is running.

>greetings,
> jonas

Sebastian
