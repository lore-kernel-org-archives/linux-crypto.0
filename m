From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: AF_ALG broken?
Date: Tue, 9 Aug 2016 08:27:17 +0100
Message-ID: <20160809072717.GG1041@n2100.armlinux.org.uk>
References: <20160808181117.GD1041@n2100.armlinux.org.uk>
 <20160809031820.GA4142@gondor.apana.org.au>
 <20160809070859.GF1041@n2100.armlinux.org.uk>
 <20160809071402.GA5466@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34019 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcHIH1Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:27:24 -0400
Content-Disposition: inline
In-Reply-To: <20160809071402.GA5466@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 03:14:02PM +0800, Herbert Xu wrote:
> On Tue, Aug 09, 2016 at 08:08:59AM +0100, Russell King - ARM Linux wrote:
> > 
> > I thought I gave the commands and link to your example code.  The
> > openssl case is md5, though sha* also gives the same result.  Your
> > example code was sha1 iirc.  I guess none of these would be using
> > HMAC - the openssl cases used to give results compatible with the
> > md5sum/ sha1sum etc userspace commands.
> > 
> > /proc/crypto:
> > 
> > name         : md5
> > driver       : md5-caam
> 
> Right, caam is providing a setkey function for md5, which leads the
> API to think that a key is required.  We should fix it so that setkey
> is only set for the HMAC-variant.

Thanks, that works nicely again, and passes my tests.

8<====
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] crypto: caam - fix non-hmac hashes

Since 6de62f15b581 ("crypto: algif_hash - Require setkey before
accept(2)"), the AF_ALG interface requires userspace to provide a key
to any algorithm that has a setkey method.  However, the non-HMAC
algorithms are not keyed, so setting a key is unnecessary.

Fix this by removing the setkey method from the non-keyed hash
algorithms.

Fixes: 6de62f15b581 ("crypto: algif_hash - Require setkey before accept(2)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index ea284e3909ef..9d7fc9ec0b7e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1950,6 +1950,7 @@ caam_hash_alloc(struct caam_hash_template *template,
 			 template->name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->driver_name);
+		t_alg->ahash_alg.setkey = NULL;
 	}
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = caam_hash_cra_init;
-- 
2.1.0

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
