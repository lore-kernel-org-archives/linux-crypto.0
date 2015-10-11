From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Sun, 11 Oct 2015 14:55:05 +0800
Message-ID: <20151011065505.GA17272@gondor.apana.org.au>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
 <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:57142 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbJKGzr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 02:55:47 -0400
Content-Disposition: inline
In-Reply-To: <20151010161754.GG32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 10, 2015 at 05:17:54PM +0100, Russell King - ARM Linux wrote:
>
> I _also_ notice that despite having the ARM assembly crypto functions
> enabled and built-in to the kernel, they don't appear in /proc/crypto -
> and this is because of patch 1 in this series, which blocks out any
> crypto driver which has a zero statesize (as the ARM crypto functions
> appear to have.)  I found this by rebuilding the ARM crypto stuff as
> modules, and then trying to insert them:

They're buggy and unfortunately this wasn't caught during the
review process.  The import/export functions are required and
certainly not optional.

> # modprobe sha512-arm
> modprobe: ERROR: could not insert 'sha512_arm': Invalid argument

This is the correct response and what will happen is that the
software implementation of sha512 will be used rather than the
accelerated sha512_arm.

Once the sha512_arm driver has been fixed then it can be loaded
again.

> So, I think it's best if this patch series is *NOT* merged until someone
> who knows the kernel crypto code gets to grips with what's supposed to be
> done in various parts of the code.  Yes, I know that Herbert suggested
> the approach in patch 1, but that _will_ cause regressions like the above
> when if it's merged.

Considering that the current driver can be used to trigger a kernel
oops from user-space I think preventing the buggy driver from loading
is the right thing to do.

We can then fix them one-by-one.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
