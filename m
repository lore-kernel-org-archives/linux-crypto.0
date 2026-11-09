Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209776;
	b=teBUpHyhNIk22oCzfXHVOiOTBtzWjQpcn4+ummxxtL05g4IaF4482LobEAo3l7ajxQRO
	 zKxAfheM48lkqNr1QYFnmQOOB2akQqemwMEYe/FX1aoQAnrNnZjLDSFEYYeO1VIANNsJQ
	 YrYb4Fp/tUjntgoRAkAa/j6vnk0Ll3EEResPcEHFN96oWfuYRITepwXWYqnYWZZ4RfpRY
	 d2PBb7fH+DmliG+cMqAP8uvaVXiRHafKTmVEK/RkTEsobzp3Car3/7NBiIXCOGsHVj/nP
	 OAOzhvTT28MKPaKZKGHagrg+vL4oVhXPHuIHM7ofthHkYEjpDe6YblpZl09jWKyOH1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209776;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=oP+TfnNZPEQgVNjsskoT2TVn8bAN4JFZz+oj1kzTdjw=;
	b=pSH+h+x5MBc873sRtc90pLDUxfylnxyiJENy9Y4rfpVOBvUP+Ja21FvfrlzhIUylNkas
	 Fg8yEZF4IVni8q8+0DcvqLI0El9GgHXjyuKoJ4kI3ErP47UnmXO9TcM3lozLEzTHTSUvO
	 OTKow9FWmS7sg92EY8NEPfNUfkcpJgeqXC4if0NPZ8rgXPG2ClzizaPYJKcAJDbmlVOxt
	 9g/ZIGu1mko2hj1oV3x5hgwTBS2cTHswrHSg06CIPOAqPZ4nR8Oyx5O4zBp9x3r3f6NCn
	 qgXdgD2wEWv62dAHeBBbZ5vrRqnCK4nuJm016LGENYZuzMWllOx52bT6imfNaHMiQ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=frNFWsws;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A868F606A321;
	Mon,  9 Nov 2026 07:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A868F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=frNFWsws
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oP+TfnNZPEQgVNjsskoT2TVn8bAN4JFZz+oj1kzTdjw=;
	b=frNFWsws9egrFENZkBILAFMGc/QbzT3N+dIl3UTPvUswe2/CTu2CpDInfAcrI72P8J0ZCvJQL
	UPH3VmNhjAXThCpN6xQrbqW1RJdcWDmiXEjK35La8xzQCYqiOLz/OPKiISXR/4AscXqW7dcz9kw
	0HZbPRIVCdldXZGiX2ABoEM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jNM671gfhznTbQ;
	Mon,  9 Nov 2026 15:36:15 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 3ABA44055B;
	Mon,  9 Nov 2026 15:36:11 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:10 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 3/4] crypto: hisilicon/hpre - use crypto engine framework
Date: Mon, 9 Nov 2026 15:35:55 +0800
Message-ID: <20261109073556.2517351-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109073556.2517351-1-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

From: Weili Qian <qianweili@huawei.com>

The HPRE driver has no software backlog queue for MAY_BACKLOG requests.
When the hardware queue is full, such requests fail instead of being
queued for later retry.

Migrate DH/RSA/ECDH to the crypto engine framework, which provides a
backlog queue and built-in retry on -ENOSPC. Convert akcipher_alg/kpp_alg
to akcipher_engine_alg/kpp_engine_alg and use the corresponding engine
register/unregister APIs.

Only MAY_BACKLOG requests are routed through the engine; the QM
hardware queue is deep enough to accept other requests directly, so
they skip the engine overhead and fail with -ENOSPC when full, per
the API contract. Non-backlog requests use a direct-send path with
bounded retries; the error code for a full queue changes from -EBUSY
to -ENOSPC in this path.

HPRE_SEND_CNT now counts successful sends instead of attempts.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig            |   1 +
 drivers/crypto/hisilicon/hpre/hpre.h        |   4 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 414 +++++++++++++++-----
 3 files changed, 314 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index e38a71d96201..bd8390337d09 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -58,6 +58,7 @@ config CRYPTO_DEV_HISI_HPRE
 	select CRYPTO_DH
 	select CRYPTO_RSA
 	select CRYPTO_ECDH
+	select CRYPTO_ENGINE
 	help
 	  Support for HiSilicon HPRE(High Performance RSA Engine)
 	  accelerator, which can accelerate RSA and DH algorithms.
diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index f73d01f6da87..c1843d85bcd1 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -5,10 +5,12 @@
 
 #include <linux/list.h>
 #include <linux/hisi_acc_qm.h>
+#include <crypto/engine.h>
 
 #define HPRE_SQE_SIZE			sizeof(struct hpre_sqe)
 #define HPRE_PF_DEF_Q_NUM		64
 #define HPRE_PF_DEF_Q_BASE		0
+#define HPRE_MAX_CRYPTO_ENGINE		64
 
 /*
  * type used in qm sqc DW6.
@@ -70,6 +72,8 @@ struct hpre_debug {
 struct hpre {
 	struct hisi_qm qm;
 	struct hpre_debug debug;
+	struct crypto_engine *engine[HPRE_MAX_CRYPTO_ENGINE];
+	u32 engine_num;
 };
 
 enum hpre_alg_type {
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 66a276786a7d..c02c33ba04d4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -4,6 +4,7 @@
 #include <crypto/dh.h>
 #include <crypto/ecc_curve.h>
 #include <crypto/ecdh.h>
+#include <crypto/engine.h>
 #include <crypto/rng.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/kpp.h>
@@ -118,6 +119,7 @@ struct hpre_ctx {
 	/* for high performance core */
 	u8 enable_hpcore;
 	bool fallback;
+	struct crypto_engine *engine;
 };
 
 struct hpre_asym_request {
@@ -336,7 +338,12 @@ static void hpre_dh_cb(struct hpre_ctx *ctx, void *resp)
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
 	hpre_hw_data_clr_all(ctx, req, areq->dst, areq->src);
-	kpp_request_complete(areq, ret);
+	local_bh_disable();
+	if (areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		crypto_finalize_kpp_request(ctx->engine, areq, ret);
+	else
+		kpp_request_complete(areq, ret);
+	local_bh_enable();
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
 }
 
@@ -357,7 +364,12 @@ static void hpre_rsa_cb(struct hpre_ctx *ctx, void *resp)
 	areq = req->areq.rsa;
 	areq->dst_len = ctx->key_sz;
 	hpre_hw_data_clr_all(ctx, req, areq->dst, areq->src);
-	akcipher_request_complete(areq, ret);
+	local_bh_disable();
+	if (areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		crypto_finalize_akcipher_request(ctx->engine, areq, ret);
+	else
+		akcipher_request_complete(areq, ret);
+	local_bh_enable();
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
 }
 
@@ -386,10 +398,20 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 		return -ENODEV;
 	}
 
+	hpre = container_of(qp->qm, struct hpre, qm);
+	if (!hpre->engine_num) {
+		hisi_qm_free_qps(&qp, 1);
+		return -ENODEV;
+	}
+	ctx->engine = hpre->engine[qp->qp_id % hpre->engine_num];
+	if (!ctx->engine) {
+		hisi_qm_free_qps(&qp, 1);
+		return -ENODEV;
+	}
+
 	qp->req_cb = hpre_alg_cb;
 	ctx->qp = qp;
 	ctx->dev = &qp->qm->pdev->dev;
-	hpre = container_of(ctx->qp->qm, struct hpre, qm);
 	ctx->hpre = hpre;
 	ctx->key_sz = 0;
 	ctx->crt_g2_mode = false;
@@ -448,25 +470,29 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 	return 0;
 }
 
-static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
+static int hpre_alg_send_message_retry(struct hpre_asym_request *hpre_req)
 {
-	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
-	int ctr = 0;
+	struct hpre_dfx *dfx = hpre_req->ctx->hpre->debug.dfx;
+	struct hisi_qp *qp = hpre_req->ctx->qp;
+	int cnt = 0;
 	int ret;
 
 	do {
-		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
-		ret = hisi_qp_send(ctx->qp, msg);
+		ret = hisi_qp_send(qp, &hpre_req->req);
 		if (ret != -EBUSY)
 			break;
 		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
-	} while (ctr++ < HPRE_TRY_SEND_TIMES);
+	} while (cnt++ < HPRE_TRY_SEND_TIMES);
 
-	if (likely(!ret))
-		return ret;
+	if (ret == -EBUSY)
+		return -ENOSPC;
+
+	if (likely(!ret)) {
+		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
+		return -EINPROGRESS;
+	}
 
-	if (ret != -EBUSY)
-		atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
+	atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
 
 	return ret;
 }
@@ -501,11 +527,16 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	else
 		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_DH);
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = crypto_transfer_kpp_request_to_engine(ctx->engine, req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			return ret;
+		goto clear_all;
+	}
 
+	ret = hpre_alg_send_message_retry(hpre_req);
+	if (ret == -EINPROGRESS)
+		return ret;
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 
@@ -779,10 +810,16 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	if (unlikely(ret))
 		goto clear_all;
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = crypto_transfer_akcipher_request_to_engine(ctx->engine, req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			return ret;
+		goto clear_all;
+	}
+
+	ret = hpre_alg_send_message_retry(hpre_req);
+	if (ret == -EINPROGRESS)
+		return ret;
 
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
@@ -832,11 +869,16 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	if (unlikely(ret))
 		goto clear_all;
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = crypto_transfer_akcipher_request_to_engine(ctx->engine, req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			return ret;
+		goto clear_all;
+	}
 
+	ret = hpre_alg_send_message_retry(hpre_req);
+	if (ret == -EINPROGRESS)
+		return ret;
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 
@@ -1433,8 +1475,12 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
 	p = sg_virt(areq->dst);
 	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
 	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
-
-	kpp_request_complete(areq, ret);
+	local_bh_disable();
+	if (areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		crypto_finalize_kpp_request(ctx->engine, areq, ret);
+	else
+		kpp_request_complete(areq, ret);
+	local_bh_enable();
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
 }
@@ -1561,9 +1607,16 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_ECC_MUL);
 	msg->resv1 = ctx->enable_hpcore << HPRE_ENABLE_HPCORE_SHIFT;
 
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = crypto_transfer_kpp_request_to_engine(ctx->engine, req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			return ret;
+		goto clear_all;
+	}
+
+	ret = hpre_alg_send_message_retry(hpre_req);
+	if (ret == -EINPROGRESS)
+		return ret;
 
 clear_all:
 	hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
@@ -1679,86 +1732,176 @@ static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	hpre_ecc_clear_ctx(ctx, true);
 }
 
-static struct akcipher_alg rsa = {
-	.encrypt = hpre_rsa_enc,
-	.decrypt = hpre_rsa_dec,
-	.set_pub_key = hpre_rsa_setpubkey,
-	.set_priv_key = hpre_rsa_setprivkey,
-	.max_size = hpre_rsa_max_size,
-	.init = hpre_rsa_init_tfm,
-	.exit = hpre_rsa_exit_tfm,
-	.base = {
-		.cra_ctxsize = sizeof(struct hpre_ctx),
-		.cra_priority = HPRE_CRYPTO_ALG_PRI,
-		.cra_name = "rsa",
-		.cra_driver_name = "hpre-rsa",
-		.cra_module = THIS_MODULE,
-		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-	},
-};
+static int hpre_alg_send_message(struct hpre_asym_request *hpre_req)
+{
+	struct hpre_dfx *dfx = hpre_req->ctx->hpre->debug.dfx;
+	struct hisi_qp *qp = hpre_req->ctx->qp;
+	int ret;
 
-static struct kpp_alg dh = {
-	.set_secret = hpre_dh_set_secret,
-	.generate_public_key = hpre_dh_generate_public_key,
-	.compute_shared_secret = hpre_dh_compute_shared_secret,
-	.max_size = hpre_dh_max_size,
-	.init = hpre_dh_init_tfm,
-	.exit = hpre_dh_exit_tfm,
-	.base = {
-		.cra_ctxsize = sizeof(struct hpre_ctx),
-		.cra_priority = HPRE_CRYPTO_ALG_PRI,
-		.cra_name = "dh",
-		.cra_driver_name = "hpre-dh",
-		.cra_module = THIS_MODULE,
-		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
-	},
-};
+	ret = hisi_qp_send(qp, &hpre_req->req);
+	if (ret == -EBUSY) {
+		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
+		return -ENOSPC;
+	}
 
-static struct kpp_alg ecdh_curves[] = {
-	{
-		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_generate_public_key,
-		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
-		.max_size = hpre_ecdh_max_size,
-		.init = hpre_ecdh_nist_p192_init_tfm,
-		.exit = hpre_ecdh_exit_tfm,
+	if (likely(!ret)) {
+		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
+		return 0;
+	}
+
+	atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
+
+	return ret;
+}
+
+static int hpre_dh_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	struct kpp_request *kreq = container_of(areq, struct kpp_request, base);
+	void *tmp = kpp_request_ctx(kreq);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, hpre_align_sz());
+	int ret;
+
+	ret = hpre_alg_send_message(hpre_req);
+	if (ret && ret != -ENOSPC)
+		hpre_hw_data_clr_all(hpre_req->ctx, hpre_req, kreq->dst, kreq->src);
+
+	return ret;
+}
+
+static int hpre_ecdh_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	struct kpp_request *kreq = container_of(areq, struct kpp_request, base);
+	void *tmp = kpp_request_ctx(kreq);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, hpre_align_sz());
+	int ret;
+
+	ret = hpre_alg_send_message(hpre_req);
+	if (ret && ret != -ENOSPC)
+		hpre_ecdh_hw_data_clr_all(hpre_req->ctx, hpre_req, kreq->dst, kreq->src);
+
+	return ret;
+}
+
+static int hpre_rsa_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	struct akcipher_request *akreq =
+	    container_of(areq, struct akcipher_request, base);
+	void *tmp = akcipher_request_ctx(akreq);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, hpre_align_sz());
+	int ret;
+
+	ret = hpre_alg_send_message(hpre_req);
+	if (ret && ret != -ENOSPC)
+		hpre_hw_data_clr_all(hpre_req->ctx, hpre_req, akreq->dst, akreq->src);
+
+	return ret;
+}
+
+static struct akcipher_engine_alg rsa = {
+	.base = {
+		.encrypt = hpre_rsa_enc,
+		.decrypt = hpre_rsa_dec,
+		.set_pub_key = hpre_rsa_setpubkey,
+		.set_priv_key = hpre_rsa_setprivkey,
+		.max_size = hpre_rsa_max_size,
+		.init = hpre_rsa_init_tfm,
+		.exit = hpre_rsa_exit_tfm,
 		.base = {
 			.cra_ctxsize = sizeof(struct hpre_ctx),
 			.cra_priority = HPRE_CRYPTO_ALG_PRI,
-			.cra_name = "ecdh-nist-p192",
-			.cra_driver_name = "hpre-ecdh-nist-p192",
+			.cra_name = "rsa",
+			.cra_driver_name = "hpre-rsa",
 			.cra_module = THIS_MODULE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
-	}, {
-		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_generate_public_key,
-		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
-		.max_size = hpre_ecdh_max_size,
-		.init = hpre_ecdh_nist_p256_init_tfm,
-		.exit = hpre_ecdh_exit_tfm,
+	},
+	.op = {
+		.do_one_request = hpre_rsa_do_one_request,
+	},
+};
+
+static struct kpp_engine_alg dh = {
+	.base = {
+		.set_secret = hpre_dh_set_secret,
+		.generate_public_key = hpre_dh_generate_public_key,
+		.compute_shared_secret = hpre_dh_compute_shared_secret,
+		.max_size = hpre_dh_max_size,
+		.init = hpre_dh_init_tfm,
+		.exit = hpre_dh_exit_tfm,
 		.base = {
 			.cra_ctxsize = sizeof(struct hpre_ctx),
 			.cra_priority = HPRE_CRYPTO_ALG_PRI,
-			.cra_name = "ecdh-nist-p256",
-			.cra_driver_name = "hpre-ecdh-nist-p256",
+			.cra_name = "dh",
+			.cra_driver_name = "hpre-dh",
 			.cra_module = THIS_MODULE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
+	},
+	.op = {
+		.do_one_request = hpre_dh_do_one_request,
+	},
+};
+
+static struct kpp_engine_alg ecdh_curves[] = {
+	{
+		.base = {
+			.set_secret = hpre_ecdh_set_secret,
+			.generate_public_key = hpre_ecdh_generate_public_key,
+			.compute_shared_secret = hpre_ecdh_compute_shared_secret,
+			.max_size = hpre_ecdh_max_size,
+			.init = hpre_ecdh_nist_p192_init_tfm,
+			.exit = hpre_ecdh_exit_tfm,
+			.base = {
+				.cra_ctxsize = sizeof(struct hpre_ctx),
+				.cra_priority = HPRE_CRYPTO_ALG_PRI,
+				.cra_name = "ecdh-nist-p192",
+				.cra_driver_name = "hpre-ecdh-nist-p192",
+				.cra_module = THIS_MODULE,
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
+			},
+		},
+		.op = {
+			.do_one_request = hpre_ecdh_do_one_request,
+		},
 	}, {
-		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_generate_public_key,
-		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
-		.max_size = hpre_ecdh_max_size,
-		.init = hpre_ecdh_nist_p384_init_tfm,
-		.exit = hpre_ecdh_exit_tfm,
 		.base = {
-			.cra_ctxsize = sizeof(struct hpre_ctx),
-			.cra_priority = HPRE_CRYPTO_ALG_PRI,
-			.cra_name = "ecdh-nist-p384",
-			.cra_driver_name = "hpre-ecdh-nist-p384",
-			.cra_module = THIS_MODULE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
+			.set_secret = hpre_ecdh_set_secret,
+			.generate_public_key = hpre_ecdh_generate_public_key,
+			.compute_shared_secret = hpre_ecdh_compute_shared_secret,
+			.max_size = hpre_ecdh_max_size,
+			.init = hpre_ecdh_nist_p256_init_tfm,
+			.exit = hpre_ecdh_exit_tfm,
+			.base = {
+				.cra_ctxsize = sizeof(struct hpre_ctx),
+				.cra_priority = HPRE_CRYPTO_ALG_PRI,
+				.cra_name = "ecdh-nist-p256",
+				.cra_driver_name = "hpre-ecdh-nist-p256",
+				.cra_module = THIS_MODULE,
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
+			},
+		},
+		.op = {
+			.do_one_request = hpre_ecdh_do_one_request,
+		},
+	}, {
+		.base = {
+			.set_secret = hpre_ecdh_set_secret,
+			.generate_public_key = hpre_ecdh_generate_public_key,
+			.compute_shared_secret = hpre_ecdh_compute_shared_secret,
+			.max_size = hpre_ecdh_max_size,
+			.init = hpre_ecdh_nist_p384_init_tfm,
+			.exit = hpre_ecdh_exit_tfm,
+			.base = {
+				.cra_ctxsize = sizeof(struct hpre_ctx),
+				.cra_priority = HPRE_CRYPTO_ALG_PRI,
+				.cra_name = "ecdh-nist-p384",
+				.cra_driver_name = "hpre-ecdh-nist-p384",
+				.cra_module = THIS_MODULE,
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
+			},
+		},
+		.op = {
+			.do_one_request = hpre_ecdh_do_one_request,
 		},
 	}
 };
@@ -1770,8 +1913,7 @@ static int hpre_register_rsa(struct hisi_qm *qm)
 	if (!hpre_check_alg_support(qm, HPRE_DRV_RSA_MASK_CAP))
 		return 0;
 
-	rsa.base.cra_flags = 0;
-	ret = crypto_register_akcipher(&rsa);
+	ret = crypto_engine_register_akcipher(&rsa);
 	if (ret)
 		dev_err(&qm->pdev->dev, "failed to register rsa (%d)!\n", ret);
 
@@ -1783,7 +1925,7 @@ static void hpre_unregister_rsa(struct hisi_qm *qm)
 	if (!hpre_check_alg_support(qm, HPRE_DRV_RSA_MASK_CAP))
 		return;
 
-	crypto_unregister_akcipher(&rsa);
+	crypto_engine_unregister_akcipher(&rsa);
 }
 
 static int hpre_register_dh(struct hisi_qm *qm)
@@ -1793,7 +1935,7 @@ static int hpre_register_dh(struct hisi_qm *qm)
 	if (!hpre_check_alg_support(qm, HPRE_DRV_DH_MASK_CAP))
 		return 0;
 
-	ret = crypto_register_kpp(&dh);
+	ret = crypto_engine_register_kpp(&dh);
 	if (ret)
 		dev_err(&qm->pdev->dev, "failed to register dh (%d)!\n", ret);
 
@@ -1805,7 +1947,7 @@ static void hpre_unregister_dh(struct hisi_qm *qm)
 	if (!hpre_check_alg_support(qm, HPRE_DRV_DH_MASK_CAP))
 		return;
 
-	crypto_unregister_kpp(&dh);
+	crypto_engine_unregister_kpp(&dh);
 }
 
 static int hpre_register_ecdh(struct hisi_qm *qm)
@@ -1816,10 +1958,10 @@ static int hpre_register_ecdh(struct hisi_qm *qm)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(ecdh_curves); i++) {
-		ret = crypto_register_kpp(&ecdh_curves[i]);
+		ret = crypto_engine_register_kpp(&ecdh_curves[i]);
 		if (ret) {
 			dev_err(&qm->pdev->dev, "failed to register %s (%d)!\n",
-				ecdh_curves[i].base.cra_name, ret);
+				ecdh_curves[i].base.base.cra_name, ret);
 			goto unreg_kpp;
 		}
 	}
@@ -1828,7 +1970,7 @@ static int hpre_register_ecdh(struct hisi_qm *qm)
 
 unreg_kpp:
 	for (--i; i >= 0; --i)
-		crypto_unregister_kpp(&ecdh_curves[i]);
+		crypto_engine_unregister_kpp(&ecdh_curves[i]);
 
 	return ret;
 }
@@ -1841,17 +1983,76 @@ static void hpre_unregister_ecdh(struct hisi_qm *qm)
 		return;
 
 	for (i = ARRAY_SIZE(ecdh_curves) - 1; i >= 0; --i)
-		crypto_unregister_kpp(&ecdh_curves[i]);
+		crypto_engine_unregister_kpp(&ecdh_curves[i]);
+}
+
+static void hpre_free_crypto_engine(struct hisi_qm *qm)
+{
+	struct hpre *hpre = container_of(qm, struct hpre, qm);
+	u32 i;
+
+	for (i = 0; i < hpre->engine_num; i++) {
+		if (hpre->engine[i])
+			crypto_engine_exit(hpre->engine[i]);
+	}
+
+	hpre->engine_num = 0;
+}
+
+static int hpre_alloc_crypto_engine(struct hisi_qm *qm)
+{
+	u32 engine_num = min_t(u32, qm->qp_num, HPRE_MAX_CRYPTO_ENGINE);
+	struct hpre *hpre = container_of(qm, struct hpre, qm);
+	struct device *dev = &qm->pdev->dev;
+	u16 qlen = qm->qp_array[0].sq_depth;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < engine_num; i++) {
+		hpre->engine[i] =
+			crypto_engine_alloc_init_and_set(dev, true,
+							 false, qlen);
+		if (!hpre->engine[i]) {
+			dev_err(dev, "failed to alloc crypto engine.\n");
+			ret = -ENOMEM;
+			goto free_engine;
+		}
+
+		ret = crypto_engine_start(hpre->engine[i]);
+		if (ret) {
+			dev_err(dev, "failed to start crypto engine.\n");
+			crypto_engine_exit(hpre->engine[i]);
+			hpre->engine[i] = NULL;
+			goto free_engine;
+		}
+	}
+
+	hpre->engine_num = engine_num;
+
+	return 0;
+
+free_engine:
+	for (i = 0; i < engine_num; i++) {
+		if (hpre->engine[i])
+			crypto_engine_exit(hpre->engine[i]);
+	}
+
+	return ret;
 }
 
 int hpre_algs_register(struct hisi_qm *qm)
 {
-	int ret = 0;
+	int ret;
+
+	ret = hpre_alloc_crypto_engine(qm);
+	if (ret)
+		return ret;
 
 	mutex_lock(&hpre_algs_lock);
 	if (hpre_available_devs) {
 		hpre_available_devs++;
-		goto unlock;
+		mutex_unlock(&hpre_algs_lock);
+		return 0;
 	}
 
 	ret = hpre_register_rsa(qm);
@@ -1877,6 +2078,8 @@ int hpre_algs_register(struct hisi_qm *qm)
 	hpre_unregister_rsa(qm);
 unlock:
 	mutex_unlock(&hpre_algs_lock);
+	hpre_free_crypto_engine(qm);
+
 	return ret;
 }
 
@@ -1892,4 +2095,5 @@ void hpre_algs_unregister(struct hisi_qm *qm)
 
 unlock:
 	mutex_unlock(&hpre_algs_lock);
+	hpre_free_crypto_engine(qm);
 }
-- 
2.43.0

