From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: hash - Fix digest size check for digest type
Date: Mon, 4 Aug 2008 11:14:45 +0800
Message-ID: <20080804031445.GA7181@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54489 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754302AbYHDDOr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Aug 2008 23:14:47 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KPqWz-0000FL-RU
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 13:14:46 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KPqWz-0001sA-00
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 11:14:45 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

The new crypto testing stuff I've been working on has revealed
a harmless regression in crc32c when the old algorithm is used
through the new interface (which can't happen in practice).

commit e3698cd1602280dad00eb134a1803291c6b56407
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 3 21:19:43 2008 +0800

    crypto: hash - Fix digest size check for digest type
    
    The changeset ca786dc738f4f583b57b1bba7a335b5e8233f4b0
    
    	crypto: hash - Fixed digest size check
    
    missed one spot for the digest type.  This patch corrects that
    error.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/digest.c b/crypto/digest.c
index ac09194..5d3f130 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -225,7 +225,7 @@ int crypto_init_digest_ops_async(struct crypto_tfm *tfm)
 	struct ahash_tfm  *crt  = &tfm->crt_ahash;
 	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
 
-	if (dalg->dia_digestsize > crypto_tfm_alg_blocksize(tfm))
+	if (dalg->dia_digestsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	crt->init       = digest_async_init;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
