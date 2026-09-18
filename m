Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72054B5CD0;
	Fri, 18 Sep 2026 12:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734455; cv=none; b=ZfKlq9qgr28DuTCnqeeIlR4JOHYsSQa/ATwVSA7Q34Oz3RFLKr17OzIyi6Ru/PhwYM9S/+G83Vr5JiZasgVYlB5wmvNlHtCyqjWstG0NwMNJ/LZQ3ivoSQmGAWQKak6Rg49RJAHWvGgJwf2noUZt7EJsBTvELuN+gbXrUCj323k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734455; c=relaxed/simple;
	bh=ZTA2yq+xKCIgjYdHHld2+CkUR+CD5y4Lx5nxLGlNS6w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuhEBcQcJ7MHOgXSb1zdERJOhXWBUkwYdus0OdjY0rw7blUe5XDxSPZS1gw+5vAjhY1olUozcID5FcldJtNb0sX8fOl6KrED7cCohN95C2N/H1Wmx0jdhUx8yxKpbRtLDaWO0z1TRrhzC0KXW62TjNHC1j2IcJr28kRiqtq58TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xIn8Ys7+; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xIn8Ys7+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hvW4+Oqcg/pgFFd6QfLNFWFWT9SevP0LL6+aVDTAX8E=;
	b=xIn8Ys7+KH++OO/zF4N1o8XSXGLi9DxbeJYBU4a9UruQxrKXXIZ0df28JD6FwCN0n39TbpyFg
	0JCjt3kXaUJj+Gm0Aosg3VIWkOfwuGmfVKsjbCaU5dm8SFrvoqh9K/aTiJQklrru1Kjj8LEcc//
	lff0PXnebrnnB236Xp+Tb4o=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnR6RMmz1prLc;
	Fri, 18 Sep 2026 20:16:27 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 400C240538;
	Fri, 18 Sep 2026 20:27:29 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:28 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 5/7] crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
Date: Fri, 18 Sep 2026 20:27:24 +0800
Message-ID: <20260918122726.3014899-6-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

The HPRE driver hard-codes GFP_ATOMIC for RSA/DH and GFP_KERNEL for
ECDH. This may cause "scheduling while atomic" in atomic context or
unnecessary allocation failures under memory pressure.

Select GFP flags dynamically based on CRYPTO_TFM_REQ_MAY_SLEEP and
store them in hpre_asym_request::flags. The areq field is a union of
rsa/dh/ecdh request pointers; reading base.flags through any union
member other than the one that was written would be type-punning, so
a dedicated flags field avoids that.

Fixes: 98dfa9343f37 ("crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index f77c318caa35..6ca34f3bf9ff 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -138,6 +138,7 @@ struct hpre_asym_request {
 	int err;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	u32 flags;
 };
 
 static inline unsigned int hpre_align_sz(void)
@@ -186,6 +187,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				struct scatterlist *data, unsigned int len,
 				int is_src, dma_addr_t *tmp)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
 	void *ptr;
@@ -195,7 +197,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
@@ -419,6 +421,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, hpre_align_sz());
 		h_req->cb = hpre_rsa_cb;
 		h_req->areq.rsa = akreq;
+		h_req->flags = akreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 	} else {
@@ -433,6 +436,7 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		h_req = PTR_ALIGN(tmp, hpre_align_sz());
 		h_req->cb = hpre_dh_cb;
 		h_req->areq.dh = kreq;
+		h_req->flags = kreq->base.flags;
 		msg = &h_req->req;
 		memset(msg, 0, sizeof(*msg));
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
@@ -1457,6 +1461,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req = PTR_ALIGN(tmp, hpre_align_sz());
 	h_req->cb = hpre_ecdh_cb;
 	h_req->areq.ecdh = req;
+	h_req->flags = req->base.flags;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
 	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
@@ -1475,6 +1480,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 				   struct scatterlist *data, unsigned int len)
 {
+	gfp_t gfp = hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = ctx->dev;
@@ -1488,7 +1494,7 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.43.0

