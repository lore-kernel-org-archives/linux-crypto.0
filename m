Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245EF288C2B
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 02:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768877653; cv=none; b=YeQVn6ZaquAmbsVxZe15k87PyBt6KxVLdoXhd1RXYFXQY+YP22sNFUkbpP8dgTWK95AZ/yVphgvi8tk7WMFXVSd/2HktqDQrzeNEbDwbBGxeunG6j2r46STaw1hXjZrI13/IdrYgknqAGb4AsR8BncBycU9H0ypttRWQHLSUucw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768877653; c=relaxed/simple;
	bh=3olXPzM1qgiWx/qcbWNWtmDJCGDFbWI2fdTK1AIODH0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SpFloelaVu5FK7Y1bKZJ2MkhSPb6qJZMj4CkDxUpgo0rM2gdISio+V/rUKqmmnq8Td31c1+Z7UFfXvhgfwHvK5zBsvT1T3nWy3sinyFL2CcK8sNBvTlXiwFVLZwQJZTfRiybARzjd5kD9KrtMs5DCCv4wnlpxTB1aQIKWM6DMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUv61sqA; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUv61sqA"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-121a0bcd376so5132659c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 18:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768877651; x=1769482451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DXcj7Mzk1xfN6EsBGo9fgY1I2HlcRhrQHtG/TGeOkDQ=;
        b=jUv61sqAcriMardyv/u1ztpoXP5y7w5OG5L5VUw+XHKJ1I+J04X95l+p6uCVRsNPB+
         fHn8rv0TQADKcTPjSb+GTDjy8NInAXMKjzMQlpEHZRpHUcoQkbE9MsJTwsDapvNIDytw
         7F3WQK4wXGBGj1+UPAlh3NvJfCAMWkbHQoyWpUIjdSVE08+ehpB/Rct0mrIWUwcFVdyF
         P2qe2A54+tpLr2JZ5+ePiwWs7xqHTdfhwCbkiY1/KazM8vfCU80i3DnpgwhRFjmNDKuL
         UpFuvr3jw09TRCM8f/GYEeZ1LkLPWC2LceQn7JGoVyn5bUHrX6oNbbLEemqxxm7Wyp3Q
         Q4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768877651; x=1769482451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXcj7Mzk1xfN6EsBGo9fgY1I2HlcRhrQHtG/TGeOkDQ=;
        b=WUN3CPNleGaCQe6peD4VjMh4ZiDrEcmQGbyT5BtmcO7vpgncXV5mVKUW+vNd0sYsuO
         Yy3gYMiZ1FMvtiiC+kYnr0lT0UECbxlniLuYsQnf7fVoipoNHgkJwXlIiv4cVNXe9XkG
         dHbF5C5aea1A+ldYgguLTT7v1JVia/p/KtHbsJTxtTN2XvnAhZwk9HtZ0Vi7mMD3UxpW
         wTd9PzrPFVTmc97pktNKNdn6HOSkgocucSCurgmBcA5prfXOG099PnJ9IReELq4tzZ53
         0UsiGtzw17wSBC3HHaJ0G6aPyXcPV/qmN26xK5FMYH9897V7SJlm87A+zoe2eE41a6G6
         47dA==
X-Forwarded-Encrypted: i=1; AJvYcCU9CQ7ssBaFI2vsatuQgwshP3hOvw0D8hxFn9wJecQ4BWlPxX2rXqgH76sjcYBi/QHSIWkL2sgMypA1E/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOk4tfp672tyltiMAUMyK1QzRGysO3V+mVc/HKWIlOyZiXBmSI
	ZOLspttuBvzYye2j03bRbkG8zWH7zg28ozg/AOIvlnbXxTpr4+/Fk25f
X-Gm-Gg: AY/fxX6Ja+5o+5jkoeec+4tp0d/Z4e3P2Uj8nEYYoVfpudZqWtMfgUxIiKMPiR45cFY
	lLv7ejN2P+2ogVOA3bXC0VtEDMKUUX6vXX/DS7Y0lzKbnZ2HeaBrN/PQLgqYmmalMf3WQqfCRT6
	PfeGt2z734IbZr3/l+4HJH9x6XV/K17ypaZZgWW0ShdsrcYlK9ib7T91ohGRw3X+/TnwI8yn+1l
	4TN86kbm0QyohbVDe94cp+m3y4WCqRaPxZLkm99wEH85yWFdgVhGv6atxSx0A3yc77ziZqftKpv
	Ip2nLDx4nbEDFmO7pokp8EQPX5n92G093/GuOBhraZQLSo5fWPD5E9x7Nzhx6I133Q+FuW/N5jU
	VDj7+lA+R3qMZ9pl5dvTn0tsVny8pjqBf2z+7KANZc2vdT7bVqvVZ8YlR0Su7BrH8E+5QKAxjpw
	==
X-Received: by 2002:a05:7022:f90:b0:124:11af:7b75 with SMTP id a92af1059eb24-1246aadcaebmr449624c88.34.1768877651167;
        Mon, 19 Jan 2026 18:54:11 -0800 (PST)
Received: from gmail.com ([2a09:bac1:19e0:20::4:33f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af10e21sm18913273c88.16.2026.01.19.18.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 18:54:10 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: eip93: fix sleep inside atomic
Date: Tue, 20 Jan 2026 10:54:00 +0800
Message-ID: <20260120025400.54294-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crypto request is allowed to sleep only if CRYPTO_TFM_REQ_MAY_SLEEP is
set. Avoid GFP_KERNEL and usleep_range() if the flag is absent.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-aead.c   |  2 +-
 .../crypto/inside-secure/eip93/eip93-cipher.c |  2 +-
 .../crypto/inside-secure/eip93/eip93-cipher.h |  3 +-
 .../crypto/inside-secure/eip93/eip93-common.c | 36 ++++++++++++-------
 .../crypto/inside-secure/eip93/eip93-hash.c   |  9 +++--
 5 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 18dd8a9a5165..b5a47b583397 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -46,7 +46,7 @@ static int eip93_aead_send_req(struct crypto_async_request *async)
 	struct eip93_cipher_reqctx *rctx = aead_request_ctx(req);
 	int err;
 
-	err = check_valid_request(rctx);
+	err = check_valid_request(async, rctx);
 	if (err) {
 		aead_request_complete(req, err);
 		return err;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 1f2d6846610f..23df414b0321 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -36,7 +36,7 @@ static int eip93_skcipher_send_req(struct crypto_async_request *async)
 	struct eip93_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	int err;
 
-	err = check_valid_request(rctx);
+	err = check_valid_request(async, rctx);
 
 	if (err) {
 		skcipher_request_complete(req, err);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.h b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
index 6e2545ebd879..2d72fa5f8b7e 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
@@ -44,7 +44,8 @@ struct eip93_cipher_reqctx {
 	dma_addr_t			sa_state_ctr_base;
 };
 
-int check_valid_request(struct eip93_cipher_reqctx *rctx);
+int check_valid_request(struct crypto_async_request *async,
+			struct eip93_cipher_reqctx *rctx);
 
 void eip93_unmap_dma(struct eip93_device *eip93, struct eip93_cipher_reqctx *rctx,
 		     struct scatterlist *reqsrc, struct scatterlist *reqdst);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 66153aa2493f..5dd9c24bf463 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -148,15 +148,16 @@ static void eip93_free_sg_copy(const int len, struct scatterlist **sg)
 }
 
 static int eip93_make_sg_copy(struct scatterlist *src, struct scatterlist **dst,
-			      const u32 len, const bool copy)
+			      const u32 len, const bool copy, bool maysleep)
 {
+	gfp_t gfp = maysleep ? GFP_KERNEL : GFP_ATOMIC;
 	void *pages;
 
-	*dst = kmalloc(sizeof(**dst), GFP_KERNEL);
+	*dst = kmalloc(sizeof(**dst), gfp);
 	if (!*dst)
 		return -ENOMEM;
 
-	pages = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA,
+	pages = (void *)__get_free_pages(gfp | GFP_DMA,
 					 get_order(len));
 	if (!pages) {
 		kfree(*dst);
@@ -198,8 +199,10 @@ static bool eip93_is_sg_aligned(struct scatterlist *sg, u32 len,
 	return false;
 }
 
-int check_valid_request(struct eip93_cipher_reqctx *rctx)
+int check_valid_request(struct crypto_async_request *async,
+			struct eip93_cipher_reqctx *rctx)
 {
+	bool maysleep = async->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	struct scatterlist *src = rctx->sg_src;
 	struct scatterlist *dst = rctx->sg_dst;
 	u32 textsize = rctx->textsize;
@@ -267,13 +270,15 @@ int check_valid_request(struct eip93_cipher_reqctx *rctx)
 
 	copy_len = max(totlen_src, totlen_dst);
 	if (!src_align) {
-		err = eip93_make_sg_copy(src, &rctx->sg_src, copy_len, true);
+		err = eip93_make_sg_copy(src, &rctx->sg_src, copy_len, true,
+					 maysleep);
 		if (err)
 			return err;
 	}
 
 	if (!dst_align) {
-		err = eip93_make_sg_copy(dst, &rctx->sg_dst, copy_len, false);
+		err = eip93_make_sg_copy(dst, &rctx->sg_dst, copy_len, false,
+					 maysleep);
 		if (err)
 			return err;
 	}
@@ -379,7 +384,8 @@ void eip93_set_sa_record(struct sa_record *sa_record, const unsigned int keylen,
  */
 static int eip93_scatter_combine(struct eip93_device *eip93,
 				 struct eip93_cipher_reqctx *rctx,
-				 u32 datalen, u32 split, int offsetin)
+				 u32 datalen, u32 split, int offsetin,
+				 bool maysleep)
 {
 	struct eip93_descriptor *cdesc = rctx->cdesc;
 	struct scatterlist *sgsrc = rctx->sg_src;
@@ -497,8 +503,11 @@ static int eip93_scatter_combine(struct eip93_device *eip93,
 		scoped_guard(spinlock_irqsave, &eip93->ring->write_lock)
 			err = eip93_put_descriptor(eip93, cdesc);
 		if (err) {
-			usleep_range(EIP93_RING_BUSY_DELAY,
-				     EIP93_RING_BUSY_DELAY * 2);
+			if (maysleep)
+				usleep_range(EIP93_RING_BUSY_DELAY,
+					     EIP93_RING_BUSY_DELAY * 2);
+			else
+				cpu_relax();
 			goto again;
 		}
 		/* Writing new descriptor count starts DMA action */
@@ -512,6 +521,8 @@ int eip93_send_req(struct crypto_async_request *async,
 		   const u8 *reqiv, struct eip93_cipher_reqctx *rctx)
 {
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(async->tfm);
+	bool maysleep = async->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	gfp_t gfp = maysleep ? GFP_KERNEL : GFP_ATOMIC;
 	struct eip93_device *eip93 = ctx->eip93;
 	struct scatterlist *src = rctx->sg_src;
 	struct scatterlist *dst = rctx->sg_dst;
@@ -533,7 +544,7 @@ int eip93_send_req(struct crypto_async_request *async,
 
 	memcpy(iv, reqiv, rctx->ivsize);
 
-	rctx->sa_state = kzalloc(sizeof(*rctx->sa_state), GFP_KERNEL);
+	rctx->sa_state = kzalloc(sizeof(*rctx->sa_state), gfp);
 	if (!rctx->sa_state)
 		return -ENOMEM;
 
@@ -562,7 +573,7 @@ int eip93_send_req(struct crypto_async_request *async,
 			crypto_inc((u8 *)iv, AES_BLOCK_SIZE);
 
 			rctx->sa_state_ctr = kzalloc(sizeof(*rctx->sa_state_ctr),
-						     GFP_KERNEL);
+						     gfp);
 			if (!rctx->sa_state_ctr) {
 				err = -ENOMEM;
 				goto free_sa_state;
@@ -616,7 +627,8 @@ int eip93_send_req(struct crypto_async_request *async,
 		goto free_sg_dma;
 	}
 
-	return eip93_scatter_combine(eip93, rctx, datalen, split, offsetin);
+	return eip93_scatter_combine(eip93, rctx, datalen, split, offsetin,
+				     maysleep);
 
 free_sg_dma:
 	dma_unmap_sg(eip93->dev, dst, rctx->dst_nents, DMA_BIDIRECTIONAL);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index ac13d90a2b7c..9b58de886c70 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -215,6 +215,7 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 	struct eip93_device *eip93 = ctx->eip93;
 	struct eip93_descriptor cdesc = { };
 	dma_addr_t src_addr;
+	bool maysleep;
 	int ret;
 
 	/* Map block data to DMA */
@@ -267,12 +268,16 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 				 FIELD_PREP(EIP93_PE_USER_ID_DESC_FLAGS, EIP93_DESC_LAST);
 	}
 
+	maysleep = async->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 again:
 	scoped_guard(spinlock_irqsave, &eip93->ring->write_lock)
 		ret = eip93_put_descriptor(eip93, &cdesc);
 	if (ret) {
-		usleep_range(EIP93_RING_BUSY_DELAY,
-			     EIP93_RING_BUSY_DELAY * 2);
+		if (maysleep)
+			usleep_range(EIP93_RING_BUSY_DELAY,
+				     EIP93_RING_BUSY_DELAY * 2);
+		else
+			cpu_relax();
 		goto again;
 	}
 
-- 
2.43.0

