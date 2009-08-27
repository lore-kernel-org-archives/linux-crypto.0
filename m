From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
 dependencies broken
Date: Thu, 27 Aug 2009 12:34:01 -0700
Message-ID: <20090827123401.86cd4319.randy.dunlap@oracle.com>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
	<20090827095516.6817be1e.randy.dunlap@oracle.com>
	<20090827183500.GC24973@resivo.wgnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 541835@bugs.debian.org, Celejar <celejar@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Jonas Meurer <jonas@freesources.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:22995 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZH0TcH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Aug 2009 15:32:07 -0400
In-Reply-To: <20090827183500.GC24973@resivo.wgnet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 27 Aug 2009 20:35:01 +0200 Jonas Meurer wrote:

> hey,
> 
> On 27/08/2009 Randy Dunlap wrote:
> > On Tue, 25 Aug 2009 19:58:52 -0400 Celejar wrote:
> > 
> > > I'm having a pretty bizarre problem with my kernel crypto
> > > configuration.  I need support for a bog standard LUKS (aes /
> > > cbc-essiv:sha256) / cryptsetup installation, but even after I enable
> > > virtually everything in the crypto section of the kernel configs, cbc
> > > fails to load.  All the relevant modules are exist (dm-mod, dm-crypt,
> > > crypto_blkcipher, crypto_algapi, crypto_hash, aes_generic,
> > > sha256_generic), but even after modprobing / insmoding
> > > everything, /proc/crypto shows that aes and sha is there, but not cbc.
> > > 
> > > The problem has been reproduced (using my kernel config) by Jonas
> > > Meurer, the Debian cryptsetup maintainer, so it's not just me ;).
> > > We've tried numerous different kernel versions in the .30 / .31 range.
> > > 
> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=541835
> > > 
> > > Does this mean that something else somewhere in the kernel needs to be
> > > configured but isn't, and the necessary dependency isn't properly
> > > declared?
> > > 
> > > My config is at:
> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=45;filename=config-2.6.31-rc6-lizzie-00042-gb2add73;att=1;bug=541835
> > > 
> > > [I'm not subscribed to lkml; please cc me on responses]
> > 
> > 
> > You could try/test a patch that was just posted:
> >   http://lkml.org/lkml/2009/8/27/249
> 
> that patch seems to be for ecryptfs only, while Celejar uses dm-crypt.
> second, the patch just ensures that CRYPTO_ECB and CRYPTO_CBC are
> selected along with ECRYPT_FS. but Celejar does have both CRYPTO_ECB and
> CRYPTO_CBC selected.

ack.

> the problem rather is that loading the cbc blockcipher module simply
> does nothing. the module is listed in /proc/modules, but the blockcipher
> is still missing from /proc/crypto.
> 
> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
> even though it has cbc compiled as module as well. but if I recompile
> the same kernel sources with Celejars kernel .config, the problem
> occurs. thus it must be related to the kernel config in some way.

add cc: linux-crypto@vger.kernel.org -- maybe someone there can help out.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
