From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Tue, 13 Oct 2015 14:55:18 +0100
Message-ID: <20151013135518.GJ32532@n2100.arm.linux.org.uk>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
 <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
 <20151011065505.GA17272@gondor.apana.org.au>
 <20151013130048.GA6820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60403 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbbJMNzd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:55:33 -0400
Content-Disposition: inline
In-Reply-To: <20151013130048.GA6820@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 09:00:48PM +0800, Herbert Xu wrote:
> On Sun, Oct 11, 2015 at 02:55:05PM +0800, Herbert Xu wrote:
> > On Sat, Oct 10, 2015 at 05:17:54PM +0100, Russell King - ARM Linux wrote:
> > >
> > > I _also_ notice that despite having the ARM assembly crypto functions
> > > enabled and built-in to the kernel, they don't appear in /proc/crypto -
> > > and this is because of patch 1 in this series, which blocks out any
> > > crypto driver which has a zero statesize (as the ARM crypto functions
> > > appear to have.)  I found this by rebuilding the ARM crypto stuff as
> > > modules, and then trying to insert them:
> > 
> > They're buggy and unfortunately this wasn't caught during the
> > review process.  The import/export functions are required and
> > certainly not optional.
> 
> OK it looks like I was confused.  Yes the import and export functions
> are required but for shash algorithms we provide a simple default.
> This means that implementations can simply leave it NULL and they
> will then use the default import/export functions which exports
> the shash_desc as the state.
> 
> So Russell what I'll do is apply your patch without the hunk
> for shash_prepare_alg.  IOW we will block any ahash algorithms
> that leave state as zero since ahash does not provide a default
> import/export function (it can't because it may involve hardware
> state).  shash algorithms on the other hand won't be affected.

Okay.

I've a larger queue of patches building at the moment for the Marvell
driver - I've found that it's touch-and-go whether it produces the
correct hash result, and previous hashes can affect subsequent hashes
in some circumstances.  I'm currently at another 7 patches, plus a
"big" as-yet uncommitted patch which is virtually a rewrite of the
DMA preparation - diffstat wise, in total it's looking like:

 drivers/crypto/marvell/cesa.h |   8 +-
 drivers/crypto/marvell/hash.c | 258 ++++++++++++++++++++++--------------------
 drivers/crypto/marvell/tdma.c |   7 ++
 3 files changed, 151 insertions(+), 122 deletions(-)

and there's still a few more cases that need solving: zero bytes of
input should not give a zero hash, and an input which is the multiple
of the blocksize causes the hardware to hang - though I'm not yet
sure whether that's a result of my above changes.  At least with my
above changes, I now get stable and correct hash values for sizes
which do not hit any of those remaining bugs.

Given it's size so far, I'm not sure it makes much sense to backport
any of these fixes to stable; I think maybe we should just say "okay,
before these fixes, it's just broken."

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
