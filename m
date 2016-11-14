From: Alex Cope <alexcope@google.com>
Subject: [RFC][PATCH 1/7] crypto: skcipher adding skciper_walk_virt_init
Date: Mon, 14 Nov 2016 13:01:12 -0800
Message-ID: <1479157277-10251-2-git-send-email-alexcope@google.com>
References: <1479157277-10251-1-git-send-email-alexcope@google.com>
Cc: mhalcrow@google.com, edknapp@google.com,
        Alex Cope <alexcope@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35303 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcKNVBm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 16:01:42 -0500
Received: by mail-pf0-f173.google.com with SMTP id i88so31317933pfk.2
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2016 13:01:42 -0800 (PST)
In-Reply-To: <1479157277-10251-1-git-send-email-alexcope@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adding skcipher_walk_virt_init to allow a skciper_walk to specify
length and input/output sg. Provides similar funcationalty to
blkcipher_walk_init

Signed-off-by: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c                  | 32 +++++++++++++++++++++++---------
 include/crypto/internal/skcipher.h |  4 ++++
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e1633e6..df4b2de 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -447,16 +447,19 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 }
 
 static int skcipher_walk_skcipher(struct skcipher_walk *walk,
-				 struct skcipher_request *req)
+				  struct skcipher_request *req,
+				  struct scatterlist *src,
+				  struct scatterlist *dst,
+				  unsigned int len)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
-	scatterwalk_start(&walk->in, req->src);
-	scatterwalk_start(&walk->out, req->dst);
+	scatterwalk_start(&walk->in, src);
+	scatterwalk_start(&walk->out, dst);
 
-	walk->in.sg = req->src;
-	walk->out.sg = req->dst;
-	walk->total = req->cryptlen;
+	walk->in.sg = src;
+	walk->out.sg = dst;
+	walk->total = len;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 
@@ -474,17 +477,27 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		      struct skcipher_request *req, bool atomic)
 {
+	return skcipher_walk_virt_init(walk, req, atomic, req->src, req->dst,
+					req->cryptlen);
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_virt);
+
+int skcipher_walk_virt_init(struct skcipher_walk *walk,
+			    struct skcipher_request *req, bool atomic,
+			    struct scatterlist *src, struct scatterlist *dst,
+			    unsigned int len)
+{
 	int err;
 
 	walk->flags &= ~SKCIPHER_WALK_PHYS;
 
-	err = skcipher_walk_skcipher(walk, req);
+	err = skcipher_walk_skcipher(walk, req, src, dst, len);
 
 	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_virt);
+EXPORT_SYMBOL_GPL(skcipher_walk_virt_init);
 
 void skcipher_walk_atomise(struct skcipher_walk *walk)
 {
@@ -499,7 +512,8 @@ int skcipher_walk_async(struct skcipher_walk *walk,
 
 	INIT_LIST_HEAD(&walk->buffers);
 
-	return skcipher_walk_skcipher(walk, req);
+	return skcipher_walk_skcipher(walk, req, req->src, req->dst,
+					 req->cryptlen);
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_async);
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 26934a6..1173701 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -144,6 +144,10 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err);
 int skcipher_walk_virt(struct skcipher_walk *walk,
                       struct skcipher_request *req,
                       bool atomic);
+int skcipher_walk_virt_init(struct skcipher_walk *walk,
+			struct skcipher_request *req,
+			bool atomic, struct scatterlist *src,
+			struct scatterlist *dst, unsigned int len);
 void skcipher_walk_atomise(struct skcipher_walk *walk);
 int skcipher_walk_async(struct skcipher_walk *walk,
                        struct skcipher_request *req);
-- 
2.8.0.rc3.226.g39d4020
