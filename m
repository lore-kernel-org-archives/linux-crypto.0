From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Date: Fri, 28 Aug 2009 10:00:56 +0200
Message-ID: <20090828080056.GA3204@Chamillionaire.breakpoint.cc>
References: <20090825195852.1dfacb6c.celejar@gmail.com> <20090827095516.6817be1e.randy.dunlap@oracle.com> <20090827183500.GC24973@resivo.wgnet.de> <20090827123401.86cd4319.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jonas Meurer <jonas@freesources.org>, 541835@bugs.debian.org,
	Celejar <celejar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43715 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbZH1IBB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2009 04:01:01 -0400
Content-Disposition: inline
In-Reply-To: <20090827123401.86cd4319.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Randy Dunlap | 2009-08-27 12:34:01 [-0700]:

>> On 27/08/2009 Randy Dunlap wrote:
>> > On Tue, 25 Aug 2009 19:58:52 -0400 Celejar wrote:
>> > 
>> > > I'm having a pretty bizarre problem with my kernel crypto
>> > > configuration.  I need support for a bog standard LUKS (aes /
>> > > cbc-essiv:sha256) / cryptsetup installation, but even after I enable
>> > > virtually everything in the crypto section of the kernel configs, cbc
>> > > fails to load.  All the relevant modules are exist (dm-mod, dm-crypt,
>> > > crypto_blkcipher, crypto_algapi, crypto_hash, aes_generic,
>> > > sha256_generic), but even after modprobing / insmoding
>> > > everything, /proc/crypto shows that aes and sha is there, but not cbc.
>> > > 
>> > > The problem has been reproduced (using my kernel config) by Jonas
>> > > Meurer, the Debian cryptsetup maintainer, so it's not just me ;).
>> > > We've tried numerous different kernel versions in the .30 / .31 range.
>> > > 
>> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=541835
>> > > 
>> > > Does this mean that something else somewhere in the kernel needs to be
>> > > configured but isn't, and the necessary dependency isn't properly
>> > > declared?
>> > > 
>> > > My config is at:
>> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=45;filename=config-2.6.31-rc6-lizzie-00042-gb2add73;att=1;bug=541835
>> > > 
>> > > [I'm not subscribed to lkml; please cc me on responses]
>> the problem rather is that loading the cbc blockcipher module simply
>> does nothing. the module is listed in /proc/modules, but the blockcipher
>> is still missing from /proc/crypto.
Yes. cbc(aes) is auto-generated once someone requests such a cipher. The
block modes are not listed.

>> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
>> even though it has cbc compiled as module as well. but if I recompile
>> the same kernel sources with Celejars kernel .config, the problem
>> occurs. thus it must be related to the kernel config in some way.
It must be the kernel confing since I run .30.stable and it works. I try
to look at it later.

>---
>~Randy

Sebastian
