Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE802192FA
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020179; cv=none; b=gOibk1L9TiD0mtCTyjIZAJ2zYyQMkuuYEVS1dt3VgvJwMApki1wQEfSjRGGV7DxFo3m8+UhR1Pm1jMhj2zsaJC5J0LzFXC9UukL0YJCqBhNO5+pSXA///aaxFM4no6pCIGhRL6GjgBKJZYEoQBXKvSfMceT2bgDA3BNWwITS8gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020179; c=relaxed/simple;
	bh=6jdN5qo50DDwf5CSuTbVxXt3x0IpLL5C5XJVgCN9460=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=r2F5hJqtST+cez6fPcpbECEQu+0eR7n5GWKfHyxGkfrQRbrePhum6tfjRfP3GKZNNSfsGhwqVjt2B/i4vqiFlxtJxXS9W91VDC+TWIYggaUm7OXiA7VeBhhwyc8yDehuWmhQu4AwkNX5iSJGUHBmA/CdFMbBrYPaoyG3hIF/j7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=svmmqo+N; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="svmmqo+N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=H3qmPC540vj+KWPyVGIUKyAF9WbqmMBeBWMS8tfPYEI=; b=svmmqo+Njr2/cZEiDYUULEHeUb
	t1dvVZSddqSCpBBk6I845HcQ7YWOF6j2svIBdufFqI7BFN+AwAVRYs2zfob27B/weuL0m5BU1v2ho
	P3g40+iI6U75gI/J6gjXNPwNpgaFrAcYxHNMZNJ0zBRLYNDROIoq5iSCHoyOZG9eY3gojLRlALV5Z
	gIt/pDz/IUoP5oMutNjtAQoJ4da7rLrndUEnAR2R5monAc6W5CyhzG67ngZW+WGKJXKskycmvh4ND
	ci4FZ1gYURTqugme6MAmnv2IADBJIF6SGBeeOhuQtySpBmQl5vLczOxqspypq+xOCHTxqR3hGs4XJ
	HncoWLqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJd-00DTHP-1k;
	Mon, 07 Apr 2025 18:02:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:02:53 +0800
Date: Mon, 07 Apr 2025 18:02:53 +0800
Message-Id: <f229244c4d84d9de43c5dc187bdd3233d68cb263.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/7] crypto: acomp - Use request flag helpers and add
 acomp_request_flags
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the newly added request flag helpers to manage the request
flags.

Also add acomp_request_flags which lets bottom-level users to
access the request flags without the bits private to the acomp
API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/acompress.h          | 27 ++++++++++++++++-----------
 include/crypto/internal/acompress.h |  6 ++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 080e134df35c..f383a4008854 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -38,6 +38,12 @@
 /* Set this bit if destination is a folio. */
 #define CRYPTO_ACOMP_REQ_DST_FOLIO	0x00000040
 
+/* Private flags that should not be touched by the user. */
+#define CRYPTO_ACOMP_REQ_PRIVATE \
+	(CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA | \
+	 CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA | \
+	 CRYPTO_ACOMP_REQ_SRC_FOLIO | CRYPTO_ACOMP_REQ_DST_FOLIO)
+
 #define CRYPTO_ACOMP_DST_MAX		131072
 
 #define	MAX_SYNC_COMP_REQSIZE		0
@@ -201,7 +207,7 @@ static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
 static inline void acomp_request_set_tfm(struct acomp_req *req,
 					 struct crypto_acomp *tfm)
 {
-	req->base.tfm = crypto_acomp_tfm(tfm);
+	crypto_request_set_tfm(&req->base, crypto_acomp_tfm(tfm));
 }
 
 static inline bool acomp_is_async(struct crypto_acomp *tfm)
@@ -298,6 +304,11 @@ static inline void *acomp_request_extra(struct acomp_req *req)
 	return (void *)((char *)req + len);
 }
 
+static inline bool acomp_req_on_stack(struct acomp_req *req)
+{
+	return crypto_req_on_stack(&req->base);
+}
+
 /**
  * acomp_request_free() -- zeroize and free asynchronous (de)compression
  *			   request as well as the output buffer if allocated
@@ -307,7 +318,7 @@ static inline void *acomp_request_extra(struct acomp_req *req)
  */
 static inline void acomp_request_free(struct acomp_req *req)
 {
-	if (!req || (req->base.flags & CRYPTO_TFM_REQ_ON_STACK))
+	if (!req || acomp_req_on_stack(req))
 		return;
 	kfree_sensitive(req);
 }
@@ -328,15 +339,9 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      crypto_completion_t cmpl,
 					      void *data)
 {
-	u32 keep = CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA |
-		   CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA |
-		   CRYPTO_ACOMP_REQ_SRC_FOLIO | CRYPTO_ACOMP_REQ_DST_FOLIO |
-		   CRYPTO_TFM_REQ_ON_STACK;
-
-	req->base.complete = cmpl;
-	req->base.data = data;
-	req->base.flags &= keep;
-	req->base.flags |= flgs & ~keep;
+	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
+	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
 /**
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 960cdd1f3a57..5483ca5b46ad 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -229,4 +229,10 @@ static inline bool acomp_walk_more_src(const struct acomp_walk *walk, int cur)
 {
 	return walk->slen != cur;
 }
+
+static inline u32 acomp_request_flags(struct acomp_req *req)
+{
+	return crypto_request_flags(&req->base) & ~CRYPTO_ACOMP_REQ_PRIVATE;
+}
+
 #endif
-- 
2.39.5

