From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Tue, 13 Oct 2015 21:00:48 +0800
Message-ID: <20151013130048.GA6820@gondor.apana.org.au>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
 <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
 <20151011065505.GA17272@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50963 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbbJMNBM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:01:12 -0400
Content-Disposition: inline
In-Reply-To: <20151011065505.GA17272@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 11, 2015 at 02:55:05PM +0800, Herbert Xu wrote:
> On Sat, Oct 10, 2015 at 05:17:54PM +0100, Russell King - ARM Linux wrote:
> >
> > I _also_ notice that despite having the ARM assembly crypto functions
> > enabled and built-in to the kernel, they don't appear in /proc/crypto -
> > and this is because of patch 1 in this series, which blocks out any
> > crypto driver which has a zero statesize (as the ARM crypto functions
> > appear to have.)  I found this by rebuilding the ARM crypto stuff as
> > modules, and then trying to insert them:
> 
> They're buggy and unfortunately this wasn't caught during the
> review process.  The import/export functions are required and
> certainly not optional.

OK it looks like I was confused.  Yes the import and export functions
are required but for shash algorithms we provide a simple default.
This means that implementations can simply leave it NULL and they
will then use the default import/export functions which exports
the shash_desc as the state.

So Russell what I'll do is apply your patch without the hunk
for shash_prepare_alg.  IOW we will block any ahash algorithms
that leave state as zero since ahash does not provide a default
import/export function (it can't because it may involve hardware
state).  shash algorithms on the other hand won't be affected.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
