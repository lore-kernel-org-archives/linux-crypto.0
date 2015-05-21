From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/16] crypto: scatterwalk - Add scatterwalk_ffwd helper
Date: Thu, 21 May 2015 15:10:59 +0800
Message-ID: <E1YvKd9-0005dN-WD@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46698 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbEUHLD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdA-0002x2-73
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:00 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the scatterwalk_ffwd helper which can create an
SG list that starts in the middle of an existing SG list.  The
new list may either be part of the existing list or be a chain
that latches onto part of the existing list.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c         |   22 ++++++++++++++++++++++
 include/crypto/scatterwalk.h |    4 ++++
 2 files changed, 26 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 3bd749c..db920b5 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -146,3 +146,25 @@ int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)
 	return n;
 }
 EXPORT_SYMBOL_GPL(scatterwalk_bytes_sglen);
+
+struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
+				     struct scatterlist *src,
+				     unsigned int len)
+{
+	for (;;) {
+		if (!len)
+			return src;
+
+		if (src->length > len)
+			break;
+
+		len -= src->length;
+		src = sg_next(src);
+	}
+
+	sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
+	scatterwalk_crypto_chain(dst, sg_next(src), 0, 2);
+
+	return dst;
+}
+EXPORT_SYMBOL_GPL(scatterwalk_ffwd);
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 20e4226..96670e7 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -102,4 +102,8 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 
 int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes);
 
+struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
+				     struct scatterlist *src,
+				     unsigned int len);
+
 #endif  /* _CRYPTO_SCATTERWALK_H */
