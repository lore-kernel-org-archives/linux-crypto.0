From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash
	functions
Date: Sun, 6 May 2012 13:25:06 +0100
Message-ID: <20120506122506.GJ26481@n2100.arm.linux.org.uk>
References: <20120223183439.GA18545@orbit.nwl.cc> <4FA5AE7A.3000201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank <frank@debian-nas.org>,
	'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	uri@jdland.co.il, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org
To: Simon Baatz <gmbnomis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34216 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2EFMZm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 May 2012 08:25:42 -0400
Content-Disposition: inline
In-Reply-To: <4FA5AE7A.3000201@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 06, 2012 at 12:49:30AM +0200, Simon Baatz wrote:
> Am 23.02.2012 19:34, schrieb Phil Sutter:
> > But you might suffer from another problem, which is only present on
> > ARM machines with VIVT cache and linux >= 2.6.37: due to commit
> > f8b63c1, "ARM: 6382/1: Remove superfluous flush_kernel_dcache_page()"
> > which prevents pages being flushed from inside the scatterlist
> > iterator API. This patch seems to introduce problems in other places
> > (namely NFS), too but I sadly did not have time to investigate this
> > further. I will post a possible (cryptodev-internal) solution to
> > cryptodev-linux-devel@gna.org, maybe this fixes the problem with
> > openssl. Greetings, Phil 

Well, the reason it has been removed is as follows:

When pages are allocated, they have a special flag bit called PG_arch_1
cleared by the page allocator.

We used to use PG_arch_1 to indicate that the page contained dirty cache
lines - so by default, the page was marked clean.

Normal kernel behaviour upon allocating a page into the page cache is to
read data off the disk into the new page cache page, calling
flush_kernel_dcache_page() in the process.  This would ensure that data
would be pushed out of the cache lines associated with the kernel mapping
of the page into RAM.

This means when we map the page into userspace, we can be sure that the new
mapping will see the data written there.  Moreover, when we place a page
into a user process, we check this PG_arch_1 bit, and if it's set, we
flush the kernel mapping cache lines at this point as well.

Patch 6379/1 changed this behaviour: PG_arch_1 being _clear_ now indicates
that the page contains dirty data.

What this means is that when a page is placed into userspace, we check the
PG_arch_1 bit.  If it is clear, we flush the kernel mapping for the page
to push dirty data out to RAM.  This makes the flush in
flush_kernel_dcache_page() entirely redundant.

> since there has been no reaction on this, I would like to bring this
> issue up again (I sadly don't have the expertise to investigate this
> further...). The issue is not limited to cryptodev, but seems to be
> either a problem with commit f8b63c1 or a problem in mv_cesa that was
> uncovered by this commit.

Can you reproduce it with anything else?

It could be a problem with the way crypto stuff works - I've never had
any dealings with that subsystem, so I really can't comment.  If crypto
uses scatterlists, and walks them with the standard API, and uses
scatterlists with pages which are already mapped into userspace, then
I can see how the above commit would make things go wrong.

So, without knowledge of the crypto subsystem, I'm not sure I can help
sort this out.

If it's possible to reproduce with NFS, and it seems sorted in the latest
kernel, that's probably because something changed with NFS - NFS did for
a time have issues on ARM for various reasons (because of remapping kernel
memory into vmalloc space and expecting it to be DMA coherent...) and that
got fixed.  Whether that's why you're not seeing problems with v3.4-rc5,
I couldn't be sure unless you did a bisection between the bad and good
kernel versions.  That would at least allow us to confirm that that issue
has been properly resolved.

Thanks.
