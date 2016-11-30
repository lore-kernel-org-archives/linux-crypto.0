From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: arm64/aes-ce-ccm - fix decrypt path with new
 skcipher interface
Date: Wed, 30 Nov 2016 21:17:24 +0800
Message-ID: <20161130131723.GA4064@gondor.apana.org.au>
References: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
 <1480424733-10797-3-git-send-email-ard.biesheuvel@linaro.org>
 <20161130131407.GA3958@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57465 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755449AbcK3NRb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:17:31 -0500
Content-Disposition: inline
In-Reply-To: <20161130131407.GA3958@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 30, 2016 at 09:14:07PM +0800, Herbert Xu wrote:
> On Tue, Nov 29, 2016 at 01:05:32PM +0000, Ard Biesheuvel wrote:
> > The new skcipher walk interface does not take into account whether we
> > are encrypting or decrypting. In the latter case, the walk should
> > disregard the MAC. Fix this in the arm64 CE driver.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Thanks for the patch.  I'm going to build this into the AEAD walker
> instead, by providing separate entry points for encryption and
> decryption.  Like this,
> 
> Subject: crypto: skcipher - Add separate walker for AEAD decryption

---8<---
Subject: crypto: arm64/aes-ce-ccm - Fix AEAD decryption length

This patch fixes the ARM64 CE CCM implementation decryption by
using skcipher_walk_aead_decrypt instead of skcipher_walk_aead,
which ensures the correct length is used when doing the walk.

Fixes: cf2c0fe74084 ("crypto: aes-ce-ccm - Use skcipher walk interface")
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index d4f3568..cc5515d 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -167,7 +167,7 @@ static int ccm_encrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	err = skcipher_walk_aead(&walk, req, true);
+	err = skcipher_walk_aead_encrypt(&walk, req, true);
 
 	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
@@ -219,7 +219,7 @@ static int ccm_decrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	err = skcipher_walk_aead(&walk, req, true);
+	err = skcipher_walk_aead_decrypt(&walk, req, true);
 
 	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
