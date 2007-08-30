From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] [CRYPTO] scatterwalk: Add scatterwalk_map_and_copy
Date: Thu, 30 Aug 2007 16:41:31 +0800
Message-ID: <E1IQfal-0004Bn-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1419 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756326AbXH3Ilf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] scatterwalk: Add scatterwalk_map_and_copy

This patch adds the function scatterwalk_map_and_copy which reads or
writes a chunk of data from a scatterlist at a given offset.  It will
be used by authenc which would read/write the authentication data at
the end of the cipher/plain text.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |   22 ++++++++++++++++++++++
 crypto/scatterwalk.h |    3 +++
 2 files changed, 25 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 81afd17..e93a8f6 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -107,3 +107,25 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 	}
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
+
+void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
+			      unsigned int start, unsigned int nbytes, int out)
+{
+	struct scatter_walk walk;
+	unsigned int offset = 0;
+
+	for (;;) {
+		scatterwalk_start(&walk, sg);
+
+		if (start < offset + sg->length)
+			break;
+
+		offset += sg->length;
+		sg = sg_next(sg);
+	}
+
+	scatterwalk_advance(&walk, start - offset);
+	scatterwalk_copychunks(buf, &walk, nbytes, out);
+	scatterwalk_done(&walk, out, 0);
+}
+EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index f1592cc..500a220 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -74,4 +74,7 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 void *scatterwalk_map(struct scatter_walk *walk, int out);
 void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
+void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
+			      unsigned int start, unsigned int nbytes, int out);
+
 #endif  /* _CRYPTO_SCATTERWALK_H */
