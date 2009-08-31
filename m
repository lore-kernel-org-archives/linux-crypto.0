From: Jonas Meurer <jonas@freesources.org>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
 dependencies broken
Date: Mon, 31 Aug 2009 17:52:00 +0200
Message-ID: <20090831155200.GD7678@resivo.wgnet.de>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
 <20090827095516.6817be1e.randy.dunlap@oracle.com>
 <20090827183500.GC24973@resivo.wgnet.de>
 <20090827123401.86cd4319.randy.dunlap@oracle.com>
 <20090828080056.GA3204@Chamillionaire.breakpoint.cc>
 <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Celejar <celejar@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, 541835@bugs.debian.org,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753046AbZHaPwZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

hey,

On 30/08/2009 Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2009-08-28 10:00:56 [+0200]:
> 
> >>> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
> >>> even though it has cbc compiled as module as well. but if I recompile
> >>> the same kernel sources with Celejars kernel .config, the problem
> >>> occurs. thus it must be related to the kernel config in some way.
> >It must be the kernel confing since I run .30.stable and it works. I try
> >to look at it later.
> 
> Your kernel config is fine, the problem is that the initramfs tools do
> not copy all of the required modules into the initramfs. The missing
> modles are:
> - cryptomgr: that one is responsible to load the cbc and aes module and
>   bind them to cbc(aes)
> - chainiv: that one creates IVs if the "user" does not specify one.
>   dm-crypt probably does not use that one but is required due to the way
>   crypto works atm.
> - krng: provides random numbers and is required by chainiv.
> 
> If you add those three to /etc/initramfs/modules than it should work.
> 
> Could someone please look at initramfs to figure out why those three
> modules are not copied in this reduced setup?

the reason is simply that no other crypto modules define depends on the
listed ones:

# modinfo -F depends dm-crypt
dm-mod,crypto_blkcipher

# modinfo -F aes_generic sha256_generic cbc
crypto_algapi
crypto_hash
crypto_algapi,crypto_blkcipher

# modinfo -F crypto_blkcipher crypto_hash
crypto_algapi
crypto_algapi

and even the new modules don't depend on each other:

# modinfo -F cryptomgr
crypto_hash,crypto_algapi,crypto_blkcipher,aead,pcompress

# modinfo -F chainiv
crypto_algapi,rng,crypto_wq,crypto_blkcipher

# modinfo -F krng
rng,crypto_algapi

so the following depends should be added/changed:

- chainiv should depend o 'krng' instead of 'rng' at least
- maybe cipher modules like aes,serpent,... should depend on 'cryptomgr'
  instead of 'crypto_algapi'
- crypto_algapi should depend on chainiv

these changes are pure guesses, i don't know the details. but at least
additional depends need to be defined for crypto modules, don't you
think so?

greetings,
 jonas
