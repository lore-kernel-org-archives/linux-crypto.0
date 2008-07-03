From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] talitos: Add support for 3des.
Date: Thu, 3 Jul 2008 19:15:40 +0800
Message-ID: <20080703111540.GA28772@gondor.apana.org.au>
References: <1215038923.24641.9.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Lee Nipper <lee.nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35435 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164AbYGCLzH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:07 -0400
Content-Disposition: inline
In-Reply-To: <1215038923.24641.9.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 02, 2008 at 10:48:43PM +0000, Lee Nipper wrote:
> This patch adds support for authenc(hmac(sha1),cbc(des3_ede))
> to the talitos crypto driver for the Freescale Security Engine.
> Some adjustments were made to the scatterlist to link table conversion
> to make 3des work for ping -s 1439..1446.
> 
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>

Applied to cryptodev-2.6.

While looking at this I noticed that the driver names are ambiguous,
I've fixed it up with this patch:

    crypto: talitos - Use proper form for algorithm driver names

    The name authenc(hmac(sha1-talitos),cbc(aes-talitos)) is potentially
    ambiguous since it could also mean using the generic authenc template
    on hmac(sha1-talitos) and cbc(aes-talitos).  In general, parentheses
    should be reserved for templates that spawn algorithms.

    This patches changes it to the form authenc-hmac-sha1-cbc-aes-talitos.

    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e8459e0..8c270cd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1144,7 +1144,7 @@ static struct talitos_alg_template driver_algs[] = {
 	/* single-pass ipsec_esp descriptor */
 	{
 		.name = "authenc(hmac(sha1),cbc(aes))",
-		.driver_name = "authenc(hmac(sha1-talitos),cbc(aes-talitos))",
+		.driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
 		.blocksize = TALITOS_AES_MIN_BLOCK_SIZE,
 		.aead = {
 			.setkey = aead_authenc_setkey,
@@ -1166,7 +1166,7 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
-		.driver_name = "authenc(hmac(sha1-talitos),cbc(3des-talitos))",
+		.driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 		.blocksize = TALITOS_3DES_MIN_BLOCK_SIZE,
 		.aead = {
 			.setkey = aead_authenc_setkey,

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
