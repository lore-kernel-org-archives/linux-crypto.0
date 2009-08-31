From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Date: Mon, 31 Aug 2009 23:16:40 +0200
Message-ID: <20090831211639.GA4675@Chamillionaire.breakpoint.cc>
References: <20090825195852.1dfacb6c.celejar@gmail.com> <20090827095516.6817be1e.randy.dunlap@oracle.com> <20090827183500.GC24973@resivo.wgnet.de> <20090827123401.86cd4319.randy.dunlap@oracle.com> <20090828080056.GA3204@Chamillionaire.breakpoint.cc> <20090830153722.GA28497@Chamillionaire.breakpoint.cc> <20090831155200.GD7678@resivo.wgnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Celejar <celejar@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, 541835@bugs.debian.org,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Jonas Meurer <jonas@freesources.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34403 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbZHaVQp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2009 17:16:45 -0400
Content-Disposition: inline
In-Reply-To: <20090831155200.GD7678@resivo.wgnet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Jonas Meurer | 2009-08-31 17:52:00 [+0200]:

>> Could someone please look at initramfs to figure out why those three
>> modules are not copied in this reduced setup?
>
>the reason is simply that no other crypto modules define depends on the
>listed ones:
Well yes, but aes cbc is placed in the new initrd. I took a look, read
below.

>so the following depends should be added/changed:
>
>- chainiv should depend o 'krng' instead of 'rng' at least
   rng is a subsubsystem within crypto. krng is one implementation which
   provides random numbers. So does ansi_cprng. Another implementation
   may come.
>- maybe cipher modules like aes,serpent,... should depend on 'cryptomgr'
>  instead of 'crypto_algapi'
   This isn't possible without dummy variables because they don't need
   each other in first place. We could move code but crypto_algapi can
   live without cryptomgr. However cryptomgr doesn't make sense without
   crypto_algapi.
   Lets say you have a VIA CPU which provides cbc(aes) in HW. So you
   don't need cryptomgr because cbc(aes) is allready available. You need
   aes_generic but that's another story :)

>- crypto_algapi should depend on chainiv
   chainiv is one possible implementation eseqiv is another one. The
   later is used on async-hw and in 2.6.32+ on SMP afaik.
   
>these changes are pure guesses, i don't know the details. but at least
>additional depends need to be defined for crypto modules, don't you
>think so?
We have them in Kconfig. All required modules are built and are
available. However the things aren't that easy. The crypto subsystem is
very flexible and undocumented and this is the problem here I think.
Another example:
The geode aes HW/driver can handle cbc(aes) requests as long as its
keysize is 128bits. Larger keys can't be handled by HW so we fallback to
the next implementation. If you just copy the geode module then the
geode module won't work because an alternative implementation is
missing.

So this brings me to the following question: Why are you so picky and you
don't take all of the modules? sh 2.6.30-1 on various debian archs:
du -sh              x86_64  i386  powerpc  s390x   mips(r5k-ip32)
crypto              720K    636K  1.1M     804K    968K
arch/<arch>/crypto  72K     36K   0        92K     0
driver/crypto       32K     60K   60K      0       52K
Total               824K    732K  1.2M     896K    1020

So all modules together have an average footprint of 941.0K. This isn't
that much. There is no size limit on initrd unless you are on a system
with has 32MiB or something like that :)
With *all* those crypto modules which are selected and built you are
able to cover all corner cases.
I took a look at hooks/cryptroot and really and only a few modules are
included. Right now you don't include HW cipher e.g. VIA's padlock or
AMD's geode. If you don't load those module while openning the root
partition (the first request), then the module is never loaded / used.
The other unhandled case are non default ciphers like xts(aes) which one
might use. The brand new aes implementation aesni-intel is also not be
considered. Most modules have _generic in their name if there is
another implementation available and <name>-arch if there is an assembly
variant but I would prefer that this does not become part of an ABI
where one can rely on.

Would it be okay for you to change the way the crypto modules are picked
and include the full set?

>greetings,
> jonas

Sebastian
