From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Sun, 11 Oct 2015 14:59:41 +0800
Message-ID: <20151011065941.GC17272@gondor.apana.org.au>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151010184607.353cb5f3@bbrezillon>
 <20151010165229.GH32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55378 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbJKG7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 02:59:53 -0400
Content-Disposition: inline
In-Reply-To: <20151010165229.GH32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 10, 2015 at 05:52:29PM +0100, Russell King - ARM Linux wrote:
>
> If you're using AF_ALG, and you attach to (say) the ARM Neon SHA512
> implementation through it, and then use accept() to duplicate it's
> state, what prevents the kernel from oopsing when hash_accept() calls
> crypto_ahash_export(), which then dereferences the NULL alg->export
> function pointer?

After reading the code I don't think you can actually trigger a NULL
dereference since the crypto API will provide a default import
and export function that just returns ENOSYS.  Having said that,
not having an import/export function means that algif_hash may
not work correctly so they should be provided by the driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
