From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/11] crypto: scatterwalk - Add missing sg_init_table to scatterwalk_ffwd
Date: Wed, 27 May 2015 14:37:27 +0800
Message-ID: <E1YxUxz-0006lD-TG@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36917 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbbE0Gha (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:30 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy0-0005bJ-4d
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:28 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We need to call sg_init_table as otherwise the first entry may
inadvertently become the last.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 8690324..2ef9cbb 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -158,6 +158,7 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 		src = sg_next(src);
 	}
 
+	sg_init_table(dst, 2);
 	sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
 	scatterwalk_crypto_chain(dst, sg_next(src), 0, 2);
 
