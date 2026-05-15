Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD8647ECE7;
	Fri, 15 May 2026 11:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778845655; cv=none; b=S9WDDFlw6ebJXQGhOuzrwkNsankmDwvakRDaVK7+8kFIkuRflE0yfweKAXjfLTsQZVMgT5XfBNW/l54Bzl6cyQaOO62cAeNJ/5pT7w/byaiJ94X6BPhtLTzXPeQjvEnX7a/uPaF6hsqz8/utjeQ1EaZ9smsoGYEq4DiKwT9yIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778845655; c=relaxed/simple;
	bh=Y+B2c66eiSn3w6C5DXydM6iFDVF2x73nuA05dGFDja8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1pNQq1vb+4qV2XFqW356rw0nXSWFpfoRgLFi7+8LWhumVv1bEz5tR44kxPVxf9nqd1ot7XyQXDx8W9UvFEzm2ojNKJp57/6CVeoN14wRXEgNX2H1+Cw9aof6XTuxZUThHHw8hUHbDr67dpgRaupYpIpv5O9CF05CnIemK7pyjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jT5ROkLg; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jT5ROkLg"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4f/mCpezbIUl9t6IsoTMHDrpqSOvVYEMwH362WXuqlQ=;
	b=jT5ROkLgjt4SRTuDJkl/ySj2NiUtfJ9sBcSD3WvAQXPG9mpR3QsX2lgapb8MLCq2edNkOdH3R
	396Rw+mpknnB5tzpkuqXxeCgomuUbkf/wabwDiQ11EownO/9G4MyDoysrX/nWCb2n5S14aP8D9S
	sKOLuZ9NnoWMG6XHhmofE6o=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gH4xH2ypBzRhQy;
	Fri, 15 May 2026 19:39:47 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 70D1440538;
	Fri, 15 May 2026 19:47:25 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 19:47:24 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 2/3] crypto: hisilicon/sec2 - fix UAF in sec_alg_send_backlog
Date: Fri, 15 May 2026 19:46:00 +0800
Message-ID: <20260515114601.2492524-3-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260515114601.2492524-1-wuzongyu1@huawei.com>
References: <20260515114601.2492524-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Wenkai Lin <linwenkai6@hisilicon.com>

After crypto_request_complete() is invoked, the crypto core may
immediately free the request structure and its associated tfm context.
Consequently, the sec_ctx and qp_ctx are also released.

However, sec_alg_send_backlog() can still attempt to access these
structures when processing queued requests, resulting in a
use-after-free (UAF) bug.

Fix this by accessing the backlog list through the long-term qp memory
and using the ctx memory only when the backlog list is not empty.

Fixes: f0ae287c5045 ("crypto: hisilicon/sec2 - implement full backlog mode for sec")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 23 +++++++++++-----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2471a4dd0b50..7f2c81170431 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -234,13 +234,15 @@ static int qp_send_message(struct sec_req *req)
 	return -EINPROGRESS;
 }
 
-static void sec_alg_send_backlog_soft(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
+static void sec_alg_send_backlog_soft(struct hisi_qp *qp)
 {
 	struct sec_req *req, *tmp;
+	struct sec_ctx *ctx;
 	int ret;
 
-	list_for_each_entry_safe(req, tmp, &qp_ctx->qp->backlog.list, list) {
+	list_for_each_entry_safe(req, tmp, &qp->backlog.list, list) {
 		list_del(&req->list);
+		ctx = req->qp_ctx->ctx;
 		ctx->req_op->buf_unmap(ctx, req);
 		if (req->req_id >= 0)
 			sec_free_req_id(req);
@@ -258,9 +260,8 @@ static void sec_alg_send_backlog_soft(struct sec_ctx *ctx, struct sec_qp_ctx *qp
 	}
 }
 
-static void sec_alg_send_backlog(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
+static void sec_alg_send_backlog(struct hisi_qp *qp)
 {
-	struct hisi_qp *qp = qp_ctx->qp;
 	struct sec_req *req, *tmp;
 	int ret;
 
@@ -277,7 +278,7 @@ static void sec_alg_send_backlog(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
 			goto unlock;
 		default:
 			/* Release memory resources and send all requests through software. */
-			sec_alg_send_backlog_soft(ctx, qp_ctx);
+			sec_alg_send_backlog_soft(qp);
 			goto unlock;
 		}
 	}
@@ -306,6 +307,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 
 	ctx->req_op->buf_unmap(ctx, req);
 	ctx->req_op->callback(ctx, req, err);
+	sec_alg_send_backlog(qp);
 }
 
 static void sec_req_cb3(struct hisi_qp *qp, void *resp)
@@ -331,6 +333,7 @@ static void sec_req_cb3(struct hisi_qp *qp, void *resp)
 
 	ctx->req_op->buf_unmap(ctx, req);
 	ctx->req_op->callback(ctx, req, err);
+	sec_alg_send_backlog(qp);
 }
 
 static int sec_alg_send_message_retry(struct sec_req *req)
@@ -1673,8 +1676,6 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 				  int err)
 {
-	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-
 	if (req->req_id >= 0)
 		sec_free_req_id(req);
 
@@ -1684,7 +1685,6 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 		sec_update_iv(req, SEC_SKCIPHER);
 
 	crypto_request_complete(req->base, err);
-	sec_alg_send_backlog(ctx, qp_ctx);
 }
 
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
@@ -1923,7 +1923,7 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 	struct aead_request *a_req = req->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
 	size_t authsize = crypto_aead_authsize(tfm);
-	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	int error = err;
 	size_t sz;
 
 	if (!err && req->c_req.encrypt) {
@@ -1934,15 +1934,14 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 					  authsize, a_req->cryptlen + a_req->assoclen);
 		if (unlikely(sz != authsize)) {
 			dev_err(c->dev, "copy out mac err!\n");
-			err = -EINVAL;
+			error = -EINVAL;
 		}
 	}
 
 	if (req->req_id >= 0)
 		sec_free_req_id(req);
 
-	crypto_request_complete(req->base, err);
-	sec_alg_send_backlog(c, qp_ctx);
+	crypto_request_complete(req->base, error);
 }
 
 static void sec_request_uninit(struct sec_req *req)
-- 
2.43.0

