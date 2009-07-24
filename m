From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Fix aligned ctx helper
Date: Fri, 24 Jul 2009 15:28:00 +0800
Message-ID: <20090724072800.GA23057@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57889 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049AbZGXH2B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2009 03:28:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MUFCC-0004aK-Um
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2009 17:28:01 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MUFCC-00060k-CX
	for linux-crypto@vger.kernel.org; Fri, 24 Jul 2009 15:28:00 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit ab300465676b0c0559af62d57ec9a902f5680b03
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jul 24 15:26:15 2009 +0800

    crypto: api - Fix aligned ctx helper
    
    The aligned ctx helper was using a bogus alignment value thas was
    one off the correct value.  Fortunately the current users do not
    require anything beyond the natural alignment of the platform so
    this hasn't caused a problem.
    
    This patch fixes that and also removes the unnecessary minimum
    check since if the alignment is less than the natural alignment
    then the subsequent ALIGN operation should be a noop.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 9de6c38..3f38814 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -175,12 +175,8 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
-	unsigned long addr = (unsigned long)crypto_tfm_ctx(tfm);
-	unsigned long align = crypto_tfm_alg_alignmask(tfm);
