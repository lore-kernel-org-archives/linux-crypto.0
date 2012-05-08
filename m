From: Simon Baatz <gmbnomis@gmail.com>
Subject: Re: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash
 functions
Date: Tue, 8 May 2012 22:50:27 +0200
Message-ID: <20120508205027.GA31974@schnuecks.de>
References: <20120223183439.GA18545@orbit.nwl.cc>
 <4FA5AE7A.3000201@gmail.com>
 <20120506122506.GJ26481@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Simon Baatz <gmbnomis@gmail.com>, Frank <frank@debian-nas.org>,
	'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41711 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2EHUuc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2012 16:50:32 -0400
Received: by wgbdr13 with SMTP id dr13so6386215wgb.1
        for <linux-crypto@vger.kernel.org>; Tue, 08 May 2012 13:50:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120506122506.GJ26481@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 06, 2012 at 01:25:06PM +0100, Russell King - ARM Linux wrote:
> On Sun, May 06, 2012 at 12:49:30AM +0200, Simon Baatz wrote:
> > Am 23.02.2012 19:34, schrieb Phil Sutter:
> > > But you might suffer from another problem, which is only present on
> > > ARM machines with VIVT cache and linux >= 2.6.37: due to commit
> > > f8b63c1, "ARM: 6382/1: Remove superfluous flush_kernel_dcache_page()"
> > > which prevents pages being flushed from inside the scatterlist
> > > iterator API. This patch seems to introduce problems in other places
> > > (namely NFS), too but I sadly did not have time to investigate this
> > > further. I will post a possible (cryptodev-internal) solution to
> > > cryptodev-linux-devel@gna.org, maybe this fixes the problem with
> > > openssl. Greetings, Phil 
> 
> Well, the reason it has been removed is as follows:
> 

Thanks for the explanation. This helped a lot.

> > since there has been no reaction on this, I would like to bring this
> > issue up again (I sadly don't have the expertise to investigate this
> > further...). The issue is not limited to cryptodev, but seems to be
> > either a problem with commit f8b63c1 or a problem in mv_cesa that was
> > uncovered by this commit.
> 
> Can you reproduce it with anything else?

No, I only have issues with mv_cesa (and NFS in the past, see below).
 
> It could be a problem with the way crypto stuff works - I've never had
> any dealings with that subsystem, so I really can't comment.  If crypto
> uses scatterlists, and walks them with the standard API, and uses
> scatterlists with pages which are already mapped into userspace, then
> I can see how the above commit would make things go wrong.

As Phil explained in his mail, this seems to be what happens. I have
another question on top of his.  mv_cesa uses SG_MITER_TO_SG, whose
function was described in the respective commit as:

commit 6de7e356faf54aa75de5b624bbce28a5b776dfa8
Author: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Date:   Thu Jun 18 10:19:12 2009 +0200

    lib/scatterlist: add a flags to signalize mapping direction
    sg_miter_start() is currently unaware of the direction of the copy
    process (to or from the scatter list). It is important to know the
    direction because the page has to be flushed in case the data written
    is seen on a different mapping in user land on cache incoherent
    architectures.

Thus, I would have expected that the scatterlist iterators do the
necessary "magic" in the userspace mapped case.  Apparently, this is
not the case with the changes you describe above.  

Is each driver supposed to handle this case or can/should this be handled
in a generic fashion by scatterlists?

> If it's possible to reproduce with NFS, and it seems sorted in the latest
> kernel, that's probably because something changed with NFS - NFS did for
> a time have issues on ARM for various reasons (because of remapping kernel
> memory into vmalloc space and expecting it to be DMA coherent...) and that
> got fixed.  Whether that's why you're not seeing problems with v3.4-rc5,
> I couldn't be sure unless you did a bisection between the bad and good
> kernel versions.  That would at least allow us to confirm that that issue
> has been properly resolved.

I had no idea that I reverted f8b63c1 for so long, but you are right
again.  The merge b9d919a4ac6cf031b8e065f82ad8f1b0c9ed74b1 (in
2.6.38) containing:

NFS: Don't use vm_map_ram() in readdir

fixes my test case.


- Simon
