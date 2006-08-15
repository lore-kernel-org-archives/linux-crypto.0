From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [1/2] [PATCH] scatterlist: Add const to sg_set_buf/sg_init_one pointer argument
Date: Tue, 15 Aug 2006 21:52:00 +1000
Message-ID: <20060815115200.GA14517@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1540 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1030272AbWHOLwG
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Aug 2006 07:52:06 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I'm adding these two patches to cryptodev-2.6.

[PATCH] scatterlist: Add const to sg_set_buf/sg_init_one pointer argument

This patch adds a const modifier to the buf argument of sg_set_buf and
sg_init_one.  This lets people call it with pointers that are const.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 
-static inline void sg_set_buf(struct scatterlist *sg, void *buf,
+static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
 	sg->page = virt_to_page(buf);
@@ -13,7 +13,7 @@ static inline void sg_set_buf(struct sca
 	sg->length = buflen;
 }
 
-static inline void sg_init_one(struct scatterlist *sg, void *buf,
+static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 			       unsigned int buflen)
 {
 	memset(sg, 0, sizeof(*sg));
