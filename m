From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Tue, 13 Oct 2015 22:01:20 +0800
Message-ID: <20151013140120.GA7603@gondor.apana.org.au>
References: <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
 <20151011065505.GA17272@gondor.apana.org.au>
 <20151013130048.GA6820@gondor.apana.org.au>
 <20151013135518.GJ32532@n2100.arm.linux.org.uk>
 <20151013135722.GA7543@gondor.apana.org.au>
 <20151013135947.GK32532@n2100.arm.linux.org.uk>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:34204 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbbJMOBe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 10:01:34 -0400
Content-Disposition: inline
In-Reply-To: <20151013135947.GK32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 02:59:47PM +0100, Russell King - ARM Linux wrote:
>
> It will disable the Marvell driver, along with the SW implementations in
> arch/arm/crypto/ which don't set .statesize, .import and .export.  I
> would not be surprised if it also affects others too.

As I said earlier I'll make sure to delete the hunk for
shash_prepare_alg when I apply your patch so only ahash drivers
will be affected.

The ARM stuff is all shash so they are fine and will use the
default import/export functions.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
