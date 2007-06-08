From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Fri, 8 Jun 2007 16:26:52 +1000
Message-ID: <20070608062652.GA21503@gondor.apana.org.au>
References: <46689D79.8020908@pmc-sierra.com> <E1HwXnA-0005QC-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Shane_McDonald@pmc-sierra.com
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2315 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756537AbXFHG0z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 02:26:55 -0400
Content-Disposition: inline
In-Reply-To: <E1HwXnA-0005QC-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 08, 2007 at 04:17:48PM +1000, Herbert Xu wrote:
> Marc St-Jean <Marc_St-Jean@pmc-sierra.com> wrote:
> > 
> > I'm porting a security engine driver from 2.6.18 to 2.6.21/22. I've found
> > that although 'cit_mode' is still in struct cipher_tfm, the definitions
> > for CRYPTO_TFM_MODE_ECB and CRYPTO_TFM_MODE_CBC are gone!
> 
> Thanks for noticing it, I'll make sure that cit_mode disappears :)

Here is the patch.

[CRYPTO] cipher: Remove obsolete fields from cipher_tfm

This removes all the unused block cipher fields from cipher_tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 0de7e2a..357e8cf 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -295,28 +295,8 @@ struct blkcipher_tfm {
 };
 
 struct cipher_tfm {
-	void *cit_iv;
-	unsigned int cit_ivsize;
-	u32 cit_mode;
 	int (*cit_setkey)(struct crypto_tfm *tfm,
 	                  const u8 *key, unsigned int keylen);
-	int (*cit_encrypt)(struct crypto_tfm *tfm,
-			   struct scatterlist *dst,
-			   struct scatterlist *src,
-			   unsigned int nbytes);
-	int (*cit_encrypt_iv)(struct crypto_tfm *tfm,
-	                      struct scatterlist *dst,
-	                      struct scatterlist *src,
-	                      unsigned int nbytes, u8 *iv);
-	int (*cit_decrypt)(struct crypto_tfm *tfm,
-			   struct scatterlist *dst,
-			   struct scatterlist *src,
-			   unsigned int nbytes);
-	int (*cit_decrypt_iv)(struct crypto_tfm *tfm,
-			   struct scatterlist *dst,
-			   struct scatterlist *src,
-			   unsigned int nbytes, u8 *iv);
-	void (*cit_xor_block)(u8 *dst, const u8 *src);
 	void (*cit_encrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 	void (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
