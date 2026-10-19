Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427149;
	b=Jo1E07CQC+Rp9OKrrOR7UI81p8f/84vA7YOz0lMzdEZbdLp85Y8g26kdLdhuXZwu52ZW
	 KKJIFCVzMYovaji4iz4uGRpcfwGm8vrwRJEThPLzPv64647E1Y8GcxNc9CM4ZrFlI9Gly
	 UEVbwXVltgim/ltbdWzCZu9i3jgWA6GagyDOkeOAD9LEe3gyHyHje9X/xVkCD5qqcvjsB
	 sUJ1Vt29XMBkCf3yMmYF974xOHDXv6I31aSrUB80IUdyOr8D4+8c8yPJN0k4sX9AXY8cj
	 SH6hmJJkfzgjWuV2O+Kc/J+Kqht1qCWvAPq2+W1NouuiM0ycsGwY/3F7qn2epSbY0Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NpS0FfHoBwpCh3PjzBhg3cfuhhSSL8uR8es+vbxkTOw=;
	b=RyBEPTqran2rAJjqXzVA7kth39UaC0OU4saikMiNJhy03JWTCimrVoYULIc1gLJ3W3DR
	 70NakZqc57IY30R13SO7lZBpjdZJHLj9z+NF+j3qSiIOAFzU/qiWTAjolYJDXcBu01aBx
	 mHpowOFjzcfbBZpiLRoQlsvBPwSgAmeCPtC+hFikDp7n3R7mMLlqZ2NyFi3urAB5a+4XF
	 m6G/qEIgnZgVaoadVPFdounxx7CJWoqUh+R3zrDZaP49wqRi+4LNCM5OfHgM8CZzObCVJ
	 OFuQsMiXxzpSQgSzObdQqgNhYiqrC0KASgjqEBaop8DNAVBqA+utiUJ7zWkFCdBNuAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=RMCg0arD;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8A60A2600
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 16:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FF8A60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=RMCg0arD
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3514b90bb89so5929454eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 09:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1792427147; x=1793031947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NpS0FfHoBwpCh3PjzBhg3cfuhhSSL8uR8es+vbxkTOw=;
        b=RMCg0arDV4NbMdt2yxbbikjOcLn3I+Ijwr/r66hC+mMPB9SDkpFa/s2icDyQOzd+Ji
         yVgpDRVOvw05Oe6nPFFoW2YtMn8JbFIGo+P2zhLIEM3BJ9q1dOwjJTkXKbahxMF7YhUZ
         topPaoGM9Dgb720JjcYBvj7fL9br8xs5mlgf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427147; x=1793031947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NpS0FfHoBwpCh3PjzBhg3cfuhhSSL8uR8es+vbxkTOw=;
        b=U8BnnPKcqZERSQYwwaQou0dAM2COpOljy0ZuTPaUBoZQW6nnGoptwO0OH+ilxkamqm
         zZBMHOxOUtnvZQFZA786JYz5+R6Zhhc7gHCVKgsySyq3sTuJfJZDllmz/TfIa/BsfG70
         asha538GIyfzq37elVGFensDN5WK2b2lH+9KtBkuZE16+/N+jgU9cqkimSBr8rKxIQVn
         2G+I96kE4aP/Dvcs/zOUf06TE7cr7xY6RncMwvNw0ZeyQi5wTO6481+rrVNt/i18d3uZ
         nRXZuc9GCUfLfpSP8Rewk1P1CtISW6RgI+zoT2kUYs7fHcAX6eOjuwr/wOARZ5jiryrw
         QkeA==
X-Gm-Message-State: AFq9FYK9kmZQf+4Tl0L0gE3y0ga0JK5zOqDeDwDNcPao0LVKgN5DQH2D
	NdQ3UenymvS4OAhkUWnLoIhtWTUMkFCGUig4/ufFUlA9uph3ARkFFkPFbSPVY5+OkO8zRH2rWFZ
	0C+Bq52M=
X-Gm-Gg: AYBFou33OM6EEUe2fMX4ZD72NvYBzVgVrxlPrudkRp5s0ra2VNODFdo8Sz8s/iPyy+N
	FIQivGGTSpDUVipCcnJJJdEukIFsjDn4CxsjAGdpjt+o7oPEbepehguJ8Tvz6VoF9Mo2+0z5+IT
	sHMBnerqNVueCsQNjq8Ar4zSotTe1fxN4hMLr477s47lsEP4JvN5nfxe4SlYdG6zVo+DEDqf4Y9
	KA+5FUL2czcx5eJ9VusHu0ZKO7epJgvnzxsFk6TWvutVrOBaRVP+TWG/9Y1UJ8bSazp4c701BwB
	NxOpTDKzAuTI/kUAObGJYd3sseiZVONQtMQuaXcDLBZFR6xvJufBDNRy8jAWmE3yEiF2qwzB6Y3
	vBs2oUoBnGCXc1K5b9/iKLTbKgHQeswPLav3nxUvlaIhuhIASTDc+RLhqMadBqV3BzOhjYWnGFN
	fdBfDwuKSvZ8dFrawUSmD+h0Qwx30rLXL6x0c67pT/mnu7UWDaM4ysrnOsrzk2DzTBCRLPl2M0d
	0yF340W5CfiEj7BnfPliOXLCCw3wlFhkLwO+KXZJ4aBQY8yz7ooW51O27dNntDeEqydHEK7UeBS
	vLnBmeqWnkhPBgjWsgauqw9CY1qKh4YkT9kQAw==
X-Received: by 2002:a05:693c:69d1:b0:33e:c164:b5d7 with SMTP id 5a478bee46e88-3619ed114f5mr11352330eec.3.1792427145607;
        Mon, 19 Oct 2026 09:25:45 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819bc569sm32218885eec.11.2026.10.19.09.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:25:44 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v26 2/4] crypto: spacc - Add SPAcc ahash support
Date: Mon, 19 Oct 2026 21:54:55 +0530
Message-Id: <20261019162457.1000115-3-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019162457.1000115-1-pavitrakumarm@vayavyalabs.com>
References: <20261019162457.1000115-1-pavitrakumarm@vayavyalabs.com>
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

Add ahash support to SPAcc driver.
Below are the hash algos supported:
- cmac(sm4)
- xcbc(sm4)
- hmac(md5)
- md5
- hmac(sha1)
- sha1
- sha224
- sha256
- sha384
- sha512
- hmac(sha224)
- hmac(sha256)
- hmac(sha384)
- hmac(sha512)
- sha3-224
- sha3-256
- sha3-384
- sha3-512

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
---
 drivers/crypto/dwc-spacc/spacc_ahash.c     |  827 ++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 1355 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  863 +++++++++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  326 +++++
 drivers/crypto/dwc-spacc/spacc_device.h    |  182 +++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  349 +++++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  113 ++
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  360 ++++++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  661 ++++++++++
 9 files changed, 5036 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c

diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-spacc/spacc_ahash.c
new file mode 100644
index 0000000000000..f0e1efd3b67fe
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
@@ -0,0 +1,827 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/dmapool.h>
+#include <crypto/sha1.h>
+#include <crypto/sm4.h>
+#include <crypto/sha2.h>
+#include <crypto/sha3.h>
+#include <crypto/md5.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/hash.h>
+#include <crypto/engine.h>
+#include <linux/delay.h>
+#include <linux/atomic.h>
+
+#include "spacc_device.h"
+#include "spacc_core.h"
+
+#define PPP_BUF_SIZE 128
+
+static struct mode_tab possible_hashes[] = {
+	{ MODE_TAB_HASH("cmac(sm4)",	MAC_SM4_CMAC, 16, 16) },
+	{ .keylen[0] = 32 | MODE_TAB_HASH_XCBC, MODE_TAB_HASH("xcbc(sm4)",
+	MAC_SM4_XCBC, 16, 16) },
+
+	{ MODE_TAB_HASH("hmac(md5)",	HMAC_MD5, MD5_DIGEST_SIZE,
+	MD5_HMAC_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("md5",		HASH_MD5, MD5_DIGEST_SIZE,
+	MD5_HMAC_BLOCK_SIZE) },
+
+	{ MODE_TAB_HASH("hmac(sha1)",	HMAC_SHA1, SHA1_DIGEST_SIZE,
+	SHA1_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha1",		HASH_SHA1, SHA1_DIGEST_SIZE,
+	SHA1_BLOCK_SIZE) },
+
+	{ MODE_TAB_HASH("sha224",	HASH_SHA224, SHA224_DIGEST_SIZE,
+	SHA224_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha256",	HASH_SHA256, SHA256_DIGEST_SIZE,
+	SHA256_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha384",	HASH_SHA384, SHA384_DIGEST_SIZE,
+	SHA384_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha512",	HASH_SHA512, SHA512_DIGEST_SIZE,
+	SHA512_BLOCK_SIZE) },
+
+	{ MODE_TAB_HASH("hmac(sha512)",	HMAC_SHA512, SHA512_DIGEST_SIZE,
+	SHA512_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("hmac(sha224)",	HMAC_SHA224, SHA224_DIGEST_SIZE,
+	SHA224_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("hmac(sha256)",	HMAC_SHA256, SHA256_DIGEST_SIZE,
+	SHA256_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("hmac(sha384)",	HMAC_SHA384, SHA384_DIGEST_SIZE,
+	SHA384_BLOCK_SIZE) },
+
+	{ MODE_TAB_HASH("sha3-224",	HASH_SHA3_224, SHA3_224_DIGEST_SIZE,
+	SHA3_224_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha3-256",	HASH_SHA3_256, SHA3_256_DIGEST_SIZE,
+	SHA3_256_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha3-384",	HASH_SHA3_384, SHA3_384_DIGEST_SIZE,
+	SHA3_384_BLOCK_SIZE) },
+	{ MODE_TAB_HASH("sha3-512",	HASH_SHA3_512, SHA3_512_DIGEST_SIZE,
+	SHA3_512_BLOCK_SIZE) },
+};
+
+static void spacc_hash_cleanup_dma_dst(struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	pdu_ddt_free(&ctx->dst);
+}
+
+static void spacc_hash_cleanup_dma_src(struct spacc_crypto_ctx *tctx,
+				       struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	if (tctx->tmp_sgl && tctx->tmp_sgl[0].length != 0) {
+		dma_unmap_sg(tctx->dev, tctx->tmp_sgl, ctx->src_nents,
+			     DMA_TO_DEVICE);
+		tctx->tmp_sgl[0].length = 0;
+	} else {
+		dma_unmap_sg(tctx->dev, req->src, ctx->src_nents,
+			     DMA_TO_DEVICE);
+	}
+
+	pdu_ddt_free(&ctx->src);
+}
+
+static int spacc_init_calg(struct crypto_alg *calg,
+			   const struct mode_tab *mode)
+{
+	if (strscpy(calg->cra_name, mode->name) < 0)
+		return -ENAMETOOLONG;
+
+	if (snprintf(calg->cra_driver_name, CRYPTO_MAX_ALG_NAME,
+			"spacc-%s", mode->name) >= CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	calg->cra_blocksize = mode->blocklen;
+
+	return 0;
+}
+
+static int spacc_ctx_clone_handle(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	if (tctx->handle < 0)
+		return -EINVAL;
+
+	if (!priv)
+		return -ENODEV;
+
+	ctx->acb.new_handle = spacc_clone_handle(&priv->spacc, tctx->handle,
+						 &ctx->acb);
+
+	if (ctx->acb.new_handle < 0)
+		return -ENOMEM;
+
+	ctx->acb.tctx  = tctx;
+	ctx->acb.ctx   = ctx;
+	ctx->acb.req   = req;
+	ctx->acb.spacc = &priv->spacc;
+
+	return 0;
+}
+
+static int spacc_hash_init_dma(struct device *dev, struct ahash_request *req)
+{
+	int rc = -1;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(dev);
+
+	/*
+	 * do_one_request runs in a sleepable context,
+	 * so GFP_KERNEL is always safe here.
+	 */
+	gfp_t mflags = GFP_KERNEL;
+
+	ctx->acb.new_handle = -1;
+	ctx->digest_buf = dma_pool_alloc(priv->hash_pool, mflags,
+					 &ctx->digest_dma);
+
+	if (!ctx->digest_buf)
+		return -ENOMEM;
+
+	rc = pdu_ddt_init(dev, &ctx->dst, 1 | 0x80000000);
+	if (rc < 0) {
+		dev_err(dev, "ERR: PDU DDT init error\n");
+		rc = -EIO;
+		goto err_free_digest;
+	}
+
+	pdu_ddt_add(dev, &ctx->dst, ctx->digest_dma, SPACC_MAX_DIGEST_SIZE);
+
+	if (ctx->total_nents > 0 && ctx->single_shot) {
+		/* single shot */
+		rc = spacc_ctx_clone_handle(req);
+		if (rc < 0)
+			goto err_free_dst;
+
+		if (req->nbytes) {
+			rc = spacc_sg_to_ddt(dev, req->src, req->nbytes,
+					&ctx->src, DMA_TO_DEVICE);
+		} else {
+			memset(tctx->tmp_buffer, '\0', PPP_BUF_SIZE);
+			sg_set_buf(&tctx->tmp_sgl[0], tctx->tmp_buffer,
+					PPP_BUF_SIZE);
+			rc = spacc_sg_to_ddt(dev, &tctx->tmp_sgl[0],
+					tctx->tmp_sgl[0].length,
+					&ctx->src, DMA_TO_DEVICE);
+		}
+	} else if (ctx->total_nents == 0 && req->nbytes == 0) {
+		rc = spacc_ctx_clone_handle(req);
+		if (rc < 0)
+			goto err_free_dst;
+
+		/* zero length case */
+		memset(tctx->tmp_buffer, '\0', PPP_BUF_SIZE);
+		sg_set_buf(&tctx->tmp_sgl[0], tctx->tmp_buffer, PPP_BUF_SIZE);
+		rc = spacc_sg_to_ddt(dev, &tctx->tmp_sgl[0],
+					tctx->tmp_sgl[0].length,
+					&ctx->src, DMA_TO_DEVICE);
+	} else {
+		/*
+		 * ctx->total_nents == 0 with req->nbytes > 0: an empty
+		 * scatterlist can't supply the bytes the request claims to
+		 * have. Fail explicitly instead of silently falling through
+		 * with a stale `rc`.
+		 */
+		dev_err(dev, "ERR: empty src sg with nbytes=%u\n", req->nbytes);
+		rc = -EINVAL;
+		goto err_free_dst;
+	}
+
+	if (rc < 0)
+		goto err_free_dst;
+
+	ctx->src_nents = rc;
+	return rc;
+
+err_free_dst:
+	/*
+	 * If the handle was already cloned (semaphore count and job slot
+	 * taken) before this failure, release it.
+	 */
+	if (ctx->acb.new_handle >= 0) {
+		spacc_close(&priv->spacc, ctx->acb.new_handle);
+		ctx->acb.new_handle = -1;
+	}
+	pdu_ddt_free(&ctx->dst);
+
+err_free_digest:
+	dma_pool_free(priv->hash_pool, ctx->digest_buf, ctx->digest_dma);
+
+	return rc;
+}
+
+static void spacc_free_mems(struct spacc_crypto_reqctx *ctx,
+			    struct spacc_crypto_ctx *tctx,
+			    struct ahash_request *req)
+{
+	spacc_hash_cleanup_dma_dst(req);
+	spacc_hash_cleanup_dma_src(tctx, req);
+
+	if (ctx->single_shot) {
+		kfree(tctx->tmp_sgl);
+		tctx->tmp_sgl = NULL;
+
+		ctx->single_shot = 0;
+		if (ctx->total_nents)
+			ctx->total_nents = 0;
+	}
+}
+
+static void spacc_digest_cb(void *spacc, void *tfm)
+{
+	int err;
+	int dig_sz;
+	struct ahash_cb_data *cb = tfm;
+	struct spacc_device *device = spacc;
+	struct spacc_priv *priv = container_of(device, struct spacc_priv,
+					       spacc);
+
+	dig_sz = crypto_ahash_digestsize(crypto_ahash_reqtfm(cb->req));
+
+	if (cb->ctx->single_shot)
+		memcpy(cb->req->result, cb->ctx->digest_buf, dig_sz);
+	else
+		memcpy(cb->tctx->digest_ctx_buf, cb->ctx->digest_buf, dig_sz);
+
+	err = cb->spacc->job[cb->new_handle].job_err;
+
+	dma_pool_free(priv->hash_pool, cb->ctx->digest_buf,
+			cb->ctx->digest_dma);
+
+	spacc_free_mems(cb->ctx, cb->tctx, cb->req);
+	spacc_close(cb->spacc, cb->new_handle);
+
+	local_bh_disable();
+	crypto_finalize_hash_request(priv->engine, cb->req, err);
+	local_bh_enable();
+
+	/*
+	 * This decrement must run exactly once for every enqueued job (it
+	 * balances the atomic_inc in spacc_hash_do_one_request and releases
+	 * the drain in spacc_crypto_remove).
+	 */
+	if (atomic_dec_and_test(&priv->dma_ref_cnt))
+		wake_up(&priv->drain_wq);
+}
+
+static int spacc_hash_commit_key(struct crypto_ahash *tfm,
+				 struct spacc_priv *priv,
+				 const u8 *key, unsigned int keylen,
+				 const u8 *keybuf, unsigned int klen)
+{
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *fb;
+	int ret;
+
+	guard(mutex)(&tctx->lock);
+
+	fb = crypto_ahash_fb(tfm);
+	if (fb) {
+		ret = crypto_ahash_setkey(fb, key, keylen);
+		if (ret)
+			return ret;
+	}
+
+	memcpy(tctx->ipad, keybuf, klen);
+	tctx->keylen = klen;
+
+	/* Invalidate any cached HW context - key has changed. */
+	if (tctx->handle >= 0) {
+		spacc_close(&priv->spacc, tctx->handle);
+		tctx->handle = -1;
+	}
+
+	tctx->ctx_valid = false;
+	return 0;
+}
+
+static int spacc_hash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			     unsigned int keylen)
+{
+	unsigned int block_size;
+	unsigned int digest_size;
+	const struct spacc_alg *salg = spacc_tfm_ahash(&tfm->base);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(salg->dev);
+	u8 keybuf[sizeof(tctx->ipad)];
+	unsigned int klen;
+	int ret = 0;
+
+	if (!priv)
+		return -ENODEV;
+
+	block_size = crypto_tfm_alg_blocksize(&tfm->base);
+	digest_size = crypto_ahash_digestsize(tfm);
+
+	/*
+	 * We are using hardware for HMAC operations. The software fallback is
+	 * only for key pre-processing in case of HMACs.
+	 * This was meant for hashes but it also works for cmac/xcbc.
+	 */
+	if (keylen > block_size) {
+		dev_dbg(salg->dev, "Exceeds keylen: %u\n", keylen);
+		dev_dbg(salg->dev, "Req. keylen hashing %s\n",
+				salg->calg->cra_name);
+
+		switch (salg->mode->id) {
+		case CRYPTO_MODE_HMAC_SHA224:
+			sha224(key, keylen, keybuf);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA256:
+			sha256(key, keylen, keybuf);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA384:
+			sha384(key, keylen, keybuf);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA512:
+			sha512(key, keylen, keybuf);
+			break;
+
+		case CRYPTO_MODE_HMAC_MD5:
+			md5(key, keylen, keybuf);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA1:
+			sha1(key, keylen, keybuf);
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+
+		klen = digest_size;
+		dev_dbg(salg->dev, "updated keylen: %u\n", keylen);
+	} else {
+		/*
+		 * CMAC/XCBC skip the hashing path above, and via AF_ALG the
+		 * key length is fully user-controlled.  tctx->ipad is a fixed
+		 * 128-byte buffer, so reject anything that would not fit
+		 * before copying to prevent a heap buffer overflow.
+		 */
+		if (keylen > sizeof(keybuf)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Enforcing valid block-cipher key sizes supported by SPAcc:
+		 *  - AES-CMAC accepts 16/24/32,
+		 *  - SM4-CMAC/XCBC/SM4-XCBC only 16.
+		 */
+		memcpy(keybuf, key, keylen);
+		klen = keylen;
+	}
+
+	if (!spacc_is_mode_keysize_supported(&priv->spacc, salg->mode->id,
+				klen, 1)) {
+		dev_dbg(salg->dev, "keylen %u not supported for mode %d\n",
+				klen, salg->mode->id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = spacc_hash_commit_key(tfm, priv, key, keylen, keybuf, klen);
+
+out:
+	memzero_explicit(keybuf, sizeof(keybuf));
+	return ret;
+}
+
+static int spacc_hash_try_hw(struct spacc_crypto_ctx *tctx,
+			     struct spacc_priv *priv,
+			     const struct spacc_alg *salg,
+			     struct crypto_ahash *reqtfm,
+			     struct ahash_request *req)
+{
+	int rc;
+
+	guard(mutex)(&tctx->lock);
+
+	if (tctx->handle < 0 || !tctx->ctx_valid) {
+		/*
+		 * spacc_open() acquires ctx_sem which may sleep;
+		 * do_one_request runs in the crypto_engine workqueue
+		 * which is a sleepable context, so this is safe.
+		 */
+		tctx->handle = spacc_open(&priv->spacc,
+					  CRYPTO_MODE_NULL, salg->mode->id,
+					  -1, 0, spacc_digest_cb, reqtfm);
+		if (tctx->handle < 0) {
+			dev_dbg(salg->dev, "context open failed, fallback\n");
+			return tctx->handle;
+		}
+
+		rc = spacc_set_operation(&priv->spacc, tctx->handle,
+				OP_ENCRYPT, ICV_HASH, IP_ICV_OFFSET, 0, 0, 0);
+		if (rc < 0) {
+			spacc_close(&priv->spacc, tctx->handle);
+			tctx->handle = -1;
+			return rc;
+		}
+
+		if (tctx->keylen > 0) {
+			u32 mode_id = salg->mode->id;
+
+			if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+				rc = spacc_compute_xcbc_key(&priv->spacc,
+							    mode_id,
+							    tctx->handle,
+							    tctx->ipad,
+							    tctx->keylen,
+							    tctx->ipad);
+				if (rc < 0) {
+					spacc_close(&priv->spacc, tctx->handle);
+					tctx->handle = -1;
+					return rc;
+				}
+
+				rc = spacc_write_context(&priv->spacc,
+							 tctx->handle,
+							 SPACC_HASH_OPERATION,
+							 tctx->ipad,
+							 32 + tctx->keylen,
+							 NULL, 0);
+			} else {
+				rc = spacc_write_context(&priv->spacc,
+							 tctx->handle,
+							 SPACC_HASH_OPERATION,
+							 tctx->ipad,
+							 tctx->keylen,
+							 NULL, 0);
+			}
+
+			if (rc < 0) {
+				spacc_close(&priv->spacc, tctx->handle);
+				tctx->handle = -1;
+				return rc;
+			}
+		}
+
+		memzero_explicit(tctx->ipad, sizeof(tctx->ipad));
+		tctx->ctx_valid = true;
+	}
+
+	rc = spacc_hash_init_dma(tctx->dev, req);
+	if (rc < 0) {
+		dev_dbg(salg->dev, "DMA init failed (%d), falling back\n", rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+/* Crypto engine hash operation */
+static int spacc_hash_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	int rc = 0;
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	const struct spacc_alg *salg = spacc_tfm_ahash(&reqtfm->base);
+
+	/*
+	 * Derive priv from the algorithm's stable device, not tctx->dev --
+	 * the latter is mutated by setkey() concurrently with this
+	 * function and is not safe to read outside tctx->lock.
+	 */
+	struct spacc_priv *priv = dev_get_drvdata(salg->dev);
+
+	ctx->single_shot = 1;
+	ctx->total_nents = sg_nents(req->src);
+	if (req->nbytes > priv->max_msg_len)
+		goto fallback;
+
+	tctx->tmp_sgl = kmalloc_array(2, sizeof(*tctx->tmp_sgl), GFP_KERNEL);
+	if (!tctx->tmp_sgl)
+		goto fallback;
+
+	sg_init_table(tctx->tmp_sgl, 2);
+	tctx->tmp_sgl[0].length = 0;
+
+	if (spacc_hash_try_hw(tctx, priv, salg, reqtfm, req) < 0)
+		goto fallback;
+
+	atomic_inc(&priv->dma_ref_cnt);
+
+	rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
+			&ctx->src, &ctx->dst, req->nbytes,
+			0, req->nbytes, 0, 0, 0, false);
+	if (rc < 0) {
+
+		atomic_dec(&priv->dma_ref_cnt);
+		spacc_free_mems(ctx, tctx, req);
+		dma_pool_free(priv->hash_pool, ctx->digest_buf,
+				ctx->digest_dma);
+		pdu_ddt_free(&ctx->dst);
+
+		if (ctx->acb.new_handle >= 0) {
+			spacc_close(&priv->spacc, ctx->acb.new_handle);
+			ctx->acb.new_handle = -1;
+		}
+
+		if (rc == -EBUSY)
+			dev_dbg(salg->dev, "HW full, failing request\n");
+
+		local_bh_disable();
+		crypto_finalize_hash_request(priv->engine, req, rc);
+		local_bh_enable();
+
+		return 0;
+	}
+
+	return 0;
+
+fallback:
+	kfree(tctx->tmp_sgl);
+	tctx->tmp_sgl = NULL;
+
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	rc = crypto_ahash_digest(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+
+	local_bh_disable();
+	crypto_finalize_hash_request(engine, req, rc);
+	local_bh_enable();
+
+	return 0;
+}
+
+static int spacc_hash_init_tfm(struct crypto_ahash *tfm)
+{
+	const struct spacc_alg *salg = container_of(crypto_ahash_alg(tfm),
+						    struct spacc_alg,
+						    alg.hash.base);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	tctx->handle    = -1;
+	tctx->ctx_valid = false;
+	tctx->dev       = get_device(salg->dev);
+	mutex_init(&tctx->lock);
+
+	return 0;
+}
+
+static void spacc_hash_exit_tfm(struct crypto_ahash *tfm)
+{
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	if (priv && tctx->handle >= 0)
+		spacc_close(&priv->spacc, tctx->handle);
+
+	put_device(tctx->dev);
+	mutex_destroy(&tctx->lock);
+}
+
+static int spacc_hash_init(struct ahash_request *req)
+{
+	int rc;
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	memset(ctx->state_buffer, 0, sizeof(ctx->state_buffer));
+
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	rc = crypto_ahash_init(fbreq);
+	if (!rc)
+		rc = crypto_ahash_export(fbreq, ctx->state_buffer);
+	HASH_REQUEST_ZERO(fbreq);
+
+	return rc;
+}
+
+static int spacc_hash_update(struct ahash_request *req)
+{
+	int rc;
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	if (!req->nbytes)
+		return 0;
+
+	HASH_FBREQ_ON_STACK(fbreq, req);
+
+	rc = crypto_ahash_import(fbreq, ctx->state_buffer);
+	if (!rc)
+		rc = crypto_ahash_update(fbreq);
+	if (!rc)
+		rc = crypto_ahash_export(fbreq, ctx->state_buffer);
+
+	HASH_REQUEST_ZERO(fbreq);
+
+	return rc;
+}
+
+static int spacc_hash_final(struct ahash_request *req)
+{
+	int rc;
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	rc = crypto_ahash_import(fbreq, ctx->state_buffer);
+	if (!rc)
+		rc = crypto_ahash_final(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+
+	return rc;
+}
+
+static int spacc_hash_digest(struct ahash_request *req)
+{
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+	unsigned long flags;
+	bool removing;
+
+	if (!priv || !priv->engine)
+		return -ENODEV;
+
+	spin_lock_irqsave(&priv->spacc.lock, flags);
+	removing = priv->removing;
+	spin_unlock_irqrestore(&priv->spacc.lock, flags);
+
+	if (removing)
+		return -ENODEV;
+
+	return crypto_transfer_hash_request_to_engine(priv->engine, req);
+}
+
+static int spacc_hash_finup(struct ahash_request *req)
+{
+	int rc;
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	rc = crypto_ahash_import(fbreq, ctx->state_buffer);
+	if (!rc)
+		rc = crypto_ahash_finup(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+
+	return rc;
+}
+
+static int spacc_hash_export(struct ahash_request *req, void *out)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(out, ctx->state_buffer, HASH_MAX_STATESIZE);
+	return 0;
+}
+
+static int spacc_hash_import(struct ahash_request *req, const void *in)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(ctx->state_buffer, in, HASH_MAX_STATESIZE);
+	return 0;
+}
+
+static void spacc_hash_alg_destroy(struct crypto_alg *alg)
+{
+	struct spacc_alg *salg = container_of(alg, struct spacc_alg,
+					      alg.hash.base.halg.base);
+
+	kfree(salg);
+}
+
+static const struct ahash_engine_alg spacc_hash_template = {
+	.base = {
+		.init		= spacc_hash_init,
+		.update		= spacc_hash_update,
+		.final		= spacc_hash_final,
+		.finup		= spacc_hash_finup,
+		.digest		= spacc_hash_digest,
+		.setkey		= spacc_hash_setkey,
+		.export		= spacc_hash_export,
+		.import		= spacc_hash_import,
+		.init_tfm	= spacc_hash_init_tfm,
+		.exit_tfm	= spacc_hash_exit_tfm,
+
+		.halg.base = {
+			.cra_priority	= 300,
+			.cra_module	= THIS_MODULE,
+			.cra_ctxsize	= sizeof(struct spacc_crypto_ctx),
+			.cra_reqsize	= sizeof(struct spacc_crypto_reqctx),
+			.cra_destroy	= spacc_hash_alg_destroy,
+			.cra_flags	= CRYPTO_ALG_TYPE_AHASH		|
+					  CRYPTO_ALG_ASYNC		|
+					  CRYPTO_AHASH_ALG_BLOCK_ONLY	|
+					  CRYPTO_ALG_OPTIONAL_KEY
+		},
+	},
+	.op = {
+		.do_one_request = spacc_hash_do_one_request,
+	},
+};
+
+static int spacc_register_hash(struct spacc_alg *salg)
+{
+	int rc = 0;
+	struct spacc_priv *priv = dev_get_drvdata(salg->dev);
+
+	salg->calg = &salg->alg.hash.base.halg.base;
+	salg->alg.hash = spacc_hash_template;
+
+	rc = spacc_init_calg(salg->calg, salg->mode);
+	if (rc)
+		return rc;
+
+	salg->alg.hash.base.halg.digestsize = salg->mode->hashlen;
+	salg->alg.hash.base.halg.statesize = HASH_MAX_STATESIZE;
+
+	rc = crypto_engine_register_ahash(&salg->alg.hash);
+	if (rc < 0)
+		return rc;
+
+	guard(mutex)(&priv->hash_alg_mutex);
+	list_add(&salg->list, &priv->hash_alg_list);
+
+	return 0;
+}
+
+int spacc_probe_hashes(struct platform_device *spacc_pdev)
+{
+	int rc = 0;
+	unsigned int index;
+	int registered = 0;
+	struct spacc_alg *salg;
+	struct spacc_priv *priv = dev_get_drvdata(&spacc_pdev->dev);
+	const char *name = NULL;
+
+	INIT_LIST_HEAD(&priv->hash_alg_list);
+	mutex_init(&priv->hash_alg_mutex);
+
+	/* Create per-device DMA pool */
+	priv->hash_pool = dma_pool_create("spacc-digest", &spacc_pdev->dev,
+			SPACC_MAX_DIGEST_SIZE,
+			SPACC_DMA_ALIGN, SPACC_DMA_BOUNDARY);
+
+	if (!priv->hash_pool)
+		return -ENOMEM;
+
+	for (index = 0; index < ARRAY_SIZE(possible_hashes); index++) {
+		name = possible_hashes[index].name;
+
+		if (!crypto_has_ahash(name, 0, 0))
+			continue;
+
+		if (spacc_is_mode_keysize_supported(&priv->spacc,
+					possible_hashes[index].id & 0xFF,
+					possible_hashes[index].hashlen, 1)) {
+			salg = kmalloc_obj(*salg, GFP_KERNEL);
+			if (!salg) {
+				rc = -ENOMEM;
+				goto err_unregister;
+			}
+
+			salg->mode = &possible_hashes[index];
+			salg->dev = &spacc_pdev->dev;
+
+			rc = spacc_register_hash(salg);
+			if (rc < 0) {
+				kfree(salg);
+				continue;
+			}
+
+			registered++;
+		}
+	}
+
+	return registered;
+
+err_unregister:
+	spacc_unregister_hash_algs(priv);
+	return rc;
+}
+
+int spacc_unregister_hash_algs(struct spacc_priv *priv)
+{
+	struct spacc_alg *salg, *tmp;
+
+	if (!priv)
+		return 0;
+
+	guard(mutex)(&priv->hash_alg_mutex);
+
+	list_for_each_entry_safe(salg, tmp, &priv->hash_alg_list, list) {
+		list_del(&salg->list);
+		crypto_engine_unregister_ahash(&salg->alg.hash);
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
new file mode 100644
index 0000000000000..aa5fbe9a3e074
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -0,0 +1,1355 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/skcipher.h>
+#include <linux/of.h>
+#include <linux/vmalloc.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/iopoll.h>
+
+#include "spacc_core.h"
+#include "spacc_device.h"
+
+static const u8 spacc_ctrl_map[SPACC_CTRL_VER_SIZE][SPACC_CTRL_MAPSIZE] = {
+	{ 0, 8, 4, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 8, 3, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 4, 8, 13, 15, 16, 24, 25, 26, 27, 28, 29, 30, 31 }
+};
+
+static const int keysizes[2][7] = {
+	/* 1  2   4   8  16  32   64 */
+	{ 5,  8, 16, 24, 32,  0,   0 },  /* cipher key sizes */
+	{ 8, 16, 20, 24, 32, 64, 128 },  /* hash key sizes */
+};
+
+static const struct enc_config enc_table[] = {
+	/* mode			    cipher_alg	 cipher_mode  auxinfo_cs_mode */
+	{CRYPTO_MODE_NULL,		 0,		 0,		   0},
+	{CRYPTO_MODE_AES_ECB,		 C_AES,		 CM_ECB,	   0},
+	{CRYPTO_MODE_AES_CBC,		 C_AES,		 CM_CBC,	   0},
+	{CRYPTO_MODE_AES_CS1,		 C_AES,		 CM_CBC,	   1},
+	{CRYPTO_MODE_AES_CS2,		 C_AES,		 CM_CBC,	   2},
+	{CRYPTO_MODE_AES_CS3,		 C_AES,		 CM_CBC,	   3},
+	{CRYPTO_MODE_AES_CFB,		 C_AES,		 CM_CFB,	   0},
+	{CRYPTO_MODE_AES_OFB,		 C_AES,		 CM_OFB,	   0},
+	{CRYPTO_MODE_AES_CTR,		 C_AES,		 CM_CTR,	   0},
+	{CRYPTO_MODE_AES_CCM,		 C_AES,		 CM_CCM,	   0},
+	{CRYPTO_MODE_AES_GCM,		 C_AES,		 CM_GCM,	   0},
+	{CRYPTO_MODE_AES_F8,		 C_AES,		 CM_F8,		   0},
+	{CRYPTO_MODE_AES_XTS,		 C_AES,		 CM_XTS,	   0},
+	{CRYPTO_MODE_MULTI2_ECB,	 C_MULTI2,	 CM_ECB,	   0},
+	{CRYPTO_MODE_MULTI2_CBC,	 C_MULTI2,	 CM_CBC,	   0},
+	{CRYPTO_MODE_MULTI2_OFB,	 C_MULTI2,	 CM_OFB,	   0},
+	{CRYPTO_MODE_MULTI2_CFB,	 C_MULTI2,	 CM_CFB,	   0},
+	{CRYPTO_MODE_3DES_CBC,		 C_DES,		 CM_CBC,	   0},
+	{CRYPTO_MODE_DES_CBC,		 C_DES,		 CM_CBC,	   0},
+	{CRYPTO_MODE_3DES_ECB,		 C_DES,		 CM_ECB,	   0},
+	{CRYPTO_MODE_DES_ECB,		 C_DES,		 CM_ECB,	   0},
+	{CRYPTO_MODE_KASUMI_ECB,	 C_KASUMI,	 CM_ECB,	   0},
+	{CRYPTO_MODE_KASUMI_F8,		 C_KASUMI,	 CM_F8,		   0},
+	{CRYPTO_MODE_SNOW3G_UEA2,	 C_SNOW3G_UEA2,	 CM_ECB,	   0},
+	{CRYPTO_MODE_ZUC_UEA3,		 C_ZUC_UEA3,	 CM_ECB,	   0},
+	{CRYPTO_MODE_CHACHA20_STREAM,	 C_CHACHA20,	 CM_CHACHA_STREAM, 0},
+	{CRYPTO_MODE_CHACHA20_POLY1305,	 C_CHACHA20,	 CM_CHACHA_AEAD,   0},
+	{CRYPTO_MODE_SM4_ECB,		 C_SM4,		 CM_ECB,	   0},
+	{CRYPTO_MODE_SM4_CBC,		 C_SM4,		 CM_CBC,	   0},
+	{CRYPTO_MODE_SM4_CS1,		 C_SM4,		 CM_CBC,	   1},
+	{CRYPTO_MODE_SM4_CS2,		 C_SM4,		 CM_CBC,	   2},
+	{CRYPTO_MODE_SM4_CS3,		 C_SM4,		 CM_CBC,	   3},
+	{CRYPTO_MODE_SM4_CFB,		 C_SM4,		 CM_CFB,	   0},
+	{CRYPTO_MODE_SM4_OFB,		 C_SM4,		 CM_OFB,	   0},
+	{CRYPTO_MODE_SM4_CTR,		 C_SM4,		 CM_CTR,	   0},
+	{CRYPTO_MODE_SM4_CCM,		 C_SM4,		 CM_CCM,	   0},
+	{CRYPTO_MODE_SM4_GCM,		 C_SM4,		 CM_GCM,	   0},
+	{CRYPTO_MODE_SM4_F8,		 C_SM4,		 CM_F8,		   0},
+	{CRYPTO_MODE_SM4_XTS,		 C_SM4,		 CM_XTS,	   0},
+};
+
+static const struct hash_config hash_table[] = {
+	/* mode			      hash_alg	   hash_mode     auxinfo_dir */
+	{CRYPTO_MODE_NULL,               H_NULL,         0,                0},
+	{CRYPTO_MODE_HMAC_SHA1,          H_SHA1,         HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_MD5,           H_MD5,          HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA224,        H_SHA224,       HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA256,        H_SHA256,       HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA384,        H_SHA384,       HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA512,        H_SHA512,       HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA512_224,    H_SHA512_224,   HM_HMAC,          0},
+	{CRYPTO_MODE_HMAC_SHA512_256,    H_SHA512_256,   HM_HMAC,          0},
+	{CRYPTO_MODE_SSLMAC_MD5,         H_MD5,          HM_SSLMAC,        0},
+	{CRYPTO_MODE_SSLMAC_SHA1,        H_SHA1,         HM_SSLMAC,        0},
+	{CRYPTO_MODE_HASH_SHA1,          H_SHA1,         HM_RAW,           0},
+	{CRYPTO_MODE_HASH_MD5,           H_MD5,          HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA224,        H_SHA224,       HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA256,        H_SHA256,       HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA384,        H_SHA384,       HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA512,        H_SHA512,       HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA512_224,    H_SHA512_224,   HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA512_256,    H_SHA512_256,   HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA3_224,      H_SHA3_224,     HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA3_256,      H_SHA3_256,     HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA3_384,      H_SHA3_384,     HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHA3_512,      H_SHA3_512,     HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SHAKE128,      H_SHAKE128,     HM_SHAKE_SHAKE,   0},
+	{CRYPTO_MODE_HASH_SHAKE256,      H_SHAKE256,     HM_SHAKE_SHAKE,   0},
+	{CRYPTO_MODE_HASH_CSHAKE128,     H_SHAKE128,     HM_SHAKE_CSHAKE,  0},
+	{CRYPTO_MODE_HASH_CSHAKE256,     H_SHAKE256,     HM_SHAKE_CSHAKE,  0},
+	{CRYPTO_MODE_MAC_KMAC128,        H_SHAKE128,     HM_SHAKE_KMAC,    0},
+	{CRYPTO_MODE_MAC_KMAC256,        H_SHAKE256,     HM_SHAKE_KMAC,    0},
+	{CRYPTO_MODE_MAC_KMACXOF128,     H_SHAKE128,     HM_SHAKE_KMAC,    1},
+	{CRYPTO_MODE_MAC_KMACXOF256,     H_SHAKE256,     HM_SHAKE_KMAC,    1},
+	{CRYPTO_MODE_MAC_XCBC,           H_XCBC,         HM_RAW,           0},
+	{CRYPTO_MODE_MAC_CMAC,           H_CMAC,         HM_RAW,           0},
+	{CRYPTO_MODE_MAC_KASUMI_F9,      H_KF9,          HM_RAW,           0},
+	{CRYPTO_MODE_MAC_SNOW3G_UIA2,    H_SNOW3G_UIA2,  HM_RAW,           0},
+	{CRYPTO_MODE_MAC_ZUC_UIA3,       H_ZUC_UIA3,     HM_RAW,           0},
+	{CRYPTO_MODE_MAC_POLY1305,       H_POLY1305,     HM_RAW,           0},
+	{CRYPTO_MODE_HASH_CRC32,         H_CRC32_I3E802_3, HM_RAW,         0},
+	{CRYPTO_MODE_MAC_MICHAEL,        H_MICHAEL,      HM_RAW,           0},
+	{CRYPTO_MODE_HASH_SM3,           H_SM3,          HM_RAW,           0},
+	{CRYPTO_MODE_HMAC_SM3,           H_SM3,          HM_HMAC,          0},
+	{CRYPTO_MODE_MAC_SM4_XCBC,       H_SM4_XCBC_MAC, HM_RAW,           0},
+	{CRYPTO_MODE_MAC_SM4_CMAC,       H_SM4_CMAC,     HM_RAW,           0},
+};
+
+/* bits are 40, 64, 128, 192, 256, and top bit for hash */
+static const unsigned char template[] = {
+	[CRYPTO_MODE_NULL]              = 0,
+	[CRYPTO_MODE_AES_ECB]           = 28,	/* AESECB 128/224/256 */
+	[CRYPTO_MODE_AES_CBC]           = 28,	/* AESCBC 128/224/256 */
+	[CRYPTO_MODE_AES_CTR]           = 28,	/* AESCTR 128/224/256 */
+	[CRYPTO_MODE_AES_CCM]           = 28,	/* AESCCM 128/224/256 */
+	[CRYPTO_MODE_AES_GCM]           = 28,	/* AESGCM 128/224/256 */
+	[CRYPTO_MODE_AES_F8]            = 28,	/* AESF8  128/224/256 */
+	[CRYPTO_MODE_AES_XTS]           = 20,	/* AESXTS 128/256 */
+	[CRYPTO_MODE_AES_CFB]           = 28,	/* AESCFB 128/224/256 */
+	[CRYPTO_MODE_AES_OFB]           = 28,	/* AESOFB 128/224/256 */
+	[CRYPTO_MODE_AES_CS1]           = 28,	/* AESCS1 128/224/256 */
+	[CRYPTO_MODE_AES_CS2]           = 28,	/* AESCS2 128/224/256 */
+	[CRYPTO_MODE_AES_CS3]           = 28,	/* AESCS3 128/224/256 */
+	[CRYPTO_MODE_MULTI2_ECB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_CBC]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_OFB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_CFB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_3DES_CBC]          = 8,	/* 3DES CBC */
+	[CRYPTO_MODE_3DES_ECB]          = 8,	/* 3DES ECB */
+	[CRYPTO_MODE_DES_CBC]           = 2,	/* DES CBC */
+	[CRYPTO_MODE_DES_ECB]           = 2,	/* DES ECB */
+	[CRYPTO_MODE_KASUMI_ECB]        = 4,	/* KASUMI ECB */
+	[CRYPTO_MODE_KASUMI_F8]         = 4,	/* KASUMI F8 */
+	[CRYPTO_MODE_SNOW3G_UEA2]       = 4,	/* SNOW3G */
+	[CRYPTO_MODE_ZUC_UEA3]          = 4,	/* ZUC */
+	[CRYPTO_MODE_CHACHA20_STREAM]   = 16,	/* CHACHA20 */
+	[CRYPTO_MODE_CHACHA20_POLY1305] = 16,	/* CHACHA20 */
+	[CRYPTO_MODE_SM4_ECB]           = 4,	/* SM4ECB 128 */
+	[CRYPTO_MODE_SM4_CBC]           = 4,	/* SM4CBC 128 */
+	[CRYPTO_MODE_SM4_CFB]           = 4,	/* SM4CFB 128 */
+	[CRYPTO_MODE_SM4_OFB]           = 4,	/* SM4OFB 128 */
+	[CRYPTO_MODE_SM4_CTR]           = 4,	/* SM4CTR 128 */
+	[CRYPTO_MODE_SM4_CCM]           = 4,	/* SM4CCM 128 */
+	[CRYPTO_MODE_SM4_GCM]           = 4,	/* SM4GCM 128 */
+	[CRYPTO_MODE_SM4_F8]            = 4,	/* SM4F8  128 */
+	[CRYPTO_MODE_SM4_XTS]           = 4,	/* SM4XTS 128 */
+	[CRYPTO_MODE_SM4_CS1]           = 4,	/* SM4CS1 128 */
+	[CRYPTO_MODE_SM4_CS2]           = 4,	/* SM4CS2 128 */
+	[CRYPTO_MODE_SM4_CS3]           = 4,	/* SM4CS3 128 */
+
+	[CRYPTO_MODE_HASH_MD5]          = 242,
+	[CRYPTO_MODE_HMAC_MD5]          = 242,
+	[CRYPTO_MODE_HASH_SHA1]         = 242,
+	[CRYPTO_MODE_HMAC_SHA1]         = 242,
+	[CRYPTO_MODE_HASH_SHA224]       = 242,
+	[CRYPTO_MODE_HMAC_SHA224]       = 242,
+	[CRYPTO_MODE_HASH_SHA256]       = 242,
+	[CRYPTO_MODE_HMAC_SHA256]       = 242,
+	[CRYPTO_MODE_HASH_SHA384]       = 242,
+	[CRYPTO_MODE_HMAC_SHA384]       = 242,
+	[CRYPTO_MODE_HASH_SHA512]       = 242,
+	[CRYPTO_MODE_HMAC_SHA512]       = 242,
+	[CRYPTO_MODE_HASH_SHA512_224]   = 242,
+	[CRYPTO_MODE_HMAC_SHA512_224]   = 242,
+	[CRYPTO_MODE_HASH_SHA512_256]   = 242,
+	[CRYPTO_MODE_HMAC_SHA512_256]   = 242,
+	[CRYPTO_MODE_MAC_XCBC]          = 130,	/* XCBC */
+	[CRYPTO_MODE_MAC_CMAC]          = 154,	/* CMAC */
+	[CRYPTO_MODE_MAC_KASUMI_F9]     = 130,	/* KASUMI */
+	[CRYPTO_MODE_MAC_SNOW3G_UIA2]   = 130,	/* SNOW */
+	[CRYPTO_MODE_MAC_ZUC_UIA3]      = 130,	/* ZUC */
+	[CRYPTO_MODE_MAC_POLY1305]      = 144,
+	[CRYPTO_MODE_SSLMAC_MD5]        = 130,
+	[CRYPTO_MODE_SSLMAC_SHA1]       = 132,
+	[CRYPTO_MODE_HASH_CRC32]        = 0,
+	[CRYPTO_MODE_MAC_MICHAEL]       = 129,
+
+	[CRYPTO_MODE_HASH_SHA3_224]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_256]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_384]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_512]     = 242,
+	[CRYPTO_MODE_HASH_SHAKE128]     = 242,
+	[CRYPTO_MODE_HASH_SHAKE256]     = 242,
+	[CRYPTO_MODE_HASH_CSHAKE128]    = 130,
+	[CRYPTO_MODE_HASH_CSHAKE256]    = 130,
+	[CRYPTO_MODE_MAC_KMAC128]       = 242,
+	[CRYPTO_MODE_MAC_KMAC256]       = 242,
+	[CRYPTO_MODE_MAC_KMACXOF128]    = 242,
+	[CRYPTO_MODE_MAC_KMACXOF256]    = 242,
+	[CRYPTO_MODE_HASH_SM3]          = 242,
+	[CRYPTO_MODE_HMAC_SM3]          = 242,
+	[CRYPTO_MODE_MAC_SM4_XCBC]      = 130,
+	[CRYPTO_MODE_MAC_SM4_CMAC]      = 130,
+};
+
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction)
+{
+	int i;
+	int nents;
+	int rc = 0;
+	int orig_nents;
+	struct scatterlist *sgl;
+	struct scatterlist *sg_entry;
+
+	/* Count the SG entries needed to cover the requested length. */
+	orig_nents = sg_nents_for_len(sg, nbytes);
+	if (orig_nents <= 0)
+		return orig_nents;
+
+	/*
+	 * Ignore a trailing zero-length SG entry if present.
+	 * Some callers use it as a terminator.
+	 */
+	if (orig_nents > 1) {
+		sgl = sg_last(sg, orig_nents);
+		if (sgl->length == 0)
+			orig_nents--;
+	}
+
+	nents = dma_map_sg(dev, sg, orig_nents, dma_direction);
+	if (nents <= 0)
+		return -ENOMEM;
+
+	rc = pdu_ddt_init(dev, ddt, nents | 0x80000000);
+	if (rc < 0) {
+		dma_unmap_sg(dev, sg, orig_nents, dma_direction);
+		return -EIO;
+	}
+
+	/* Populate the descriptor table with the DMA-mapped SG entries. */
+	for_each_sg(sg, sg_entry, nents, i) {
+		pdu_ddt_add(dev, ddt, sg_dma_address(sg_entry),
+			    sg_dma_len(sg_entry));
+	}
+
+	return orig_nents;
+}
+
+int spacc_set_operation(struct spacc_device *spacc, int handle, int op,
+			u32 prot, u32 icvcmd, u32 icvoff,
+			u32 icvsz, u32 sec_key)
+{
+	int ret = 0;
+	struct spacc_job *job = NULL;
+
+	if (handle < 0 || handle >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	job = &spacc->job[handle];
+
+	job->op = op;
+	if (op == OP_ENCRYPT)
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+	else
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+
+	switch (prot) {
+	case ICV_HASH:
+		/* HASH of plaintext */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		break;
+	case ICV_HASH_ENCRYPT:
+		/*
+		 * HASH the plaintext and encrypt the lot
+		 * ICV_PT and ICV_APPEND must be set too
+		 */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		 /* this mode is not valid when BIT_ALIGN != 0 */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case ICV_ENCRYPT_HASH:
+		/* HASH the ciphertext */
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+		break;
+	case ICV_IGNORE:
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	job->icv_len = icvsz;
+
+	switch (icvcmd) {
+	case IP_ICV_OFFSET:
+		job->icv_offset = icvoff;
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case IP_ICV_APPEND:
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case IP_ICV_IGNORE:
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (sec_key)
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_SEC_KEY);
+
+	return ret;
+}
+
+static int _spacc_fifo_full(struct spacc_device *spacc, u32 prio)
+{
+	if (spacc->config.is_qos)
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+		       SPACC_FIFO_STAT_CMDX_FULL(prio);
+	else
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+		       SPACC_FIFO_STAT_CMD0_FULL;
+}
+
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
+				int job_idx, struct pdu_ddt *src_ddt,
+				struct pdu_ddt *dst_ddt, u32 proc_sz,
+				u32 aad_offset, u32 pre_aad_sz, u32 post_aad_sz,
+				u32 iv_offset, u32 prio, bool aad_copy,
+				unsigned long *lock_flag)
+{
+	int job_index;
+	int proc_len;
+	struct spacc_job *job;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	/*
+	 * Handle priority jobs using cmd fifos, high priority
+	 * defaults to cmd0 fifo, medium to cmd1 fifo and low
+	 * to cmd2 fifo
+	 */
+	switch (prio)  {
+	case SPACC_SW_CTRL_PRIO_MED:
+		if (spacc->config.cmd1_fifo_depth == 0)
+			return -EINVAL;
+		break;
+	case SPACC_SW_CTRL_PRIO_LOW:
+		if (spacc->config.cmd2_fifo_depth == 0)
+			return -EINVAL;
+		break;
+	}
+
+	job = &spacc->job[job_idx];
+
+	if (use_jb && spacc_process_jb(spacc, lock_flag) != 0)
+		goto fifo_full;
+
+	if (_spacc_fifo_full(spacc, prio)) {
+		if (use_jb)
+			goto fifo_full;
+		else
+			return -EBUSY;
+	}
+
+	/*
+	 * Compute the length we must process, in decrypt mode
+	 * with an ICV (hash, hmac or CCM modes)
+	 * we must subtract the icv length from the buffer size
+	 */
+	if (proc_sz == SPACC_AUTO_SIZE) {
+		proc_len = src_ddt->len;
+
+		if (job->op == OP_DECRYPT &&
+		    (job->hash_mode > 0 ||
+		     job->enc_mode == CRYPTO_MODE_AES_CCM ||
+		     job->enc_mode == CRYPTO_MODE_AES_GCM)  &&
+		    !(job->ctrl & SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC)))
+			proc_len = src_ddt->len - job->icv_len;
+	} else
+		proc_len = proc_sz;
+
+	if ((u32)(proc_len - post_aad_sz) > spacc->config.max_msg_size)
+		return -EMSGSIZE;
+
+	/*
+	 * pre_aad_sz is a pure length here, bounded like proc_len by
+	 * max_msg_size (read from PROC_LEN: 16KB/32KB/64KB/256KB/512KB).
+	 * AAD copy is requested explicitly via aad_copy, not by any bit of
+	 * the length.
+	 */
+	if (pre_aad_sz > spacc->config.max_msg_size)
+		return -EMSGSIZE;
+
+	if (aad_copy)
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+	else
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+
+	job->pre_aad_sz  = pre_aad_sz;
+	job->post_aad_sz = post_aad_sz;
+
+	/* DDT DMA Support only, probe rejects non-DDT parts */
+	pdu_io_cached_write(spacc->dptr, spacc->regmap +
+			SPACC_REG_SRC_PTR, (u32)src_ddt->phys,
+			&spacc->cache.src_ptr);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap +
+			SPACC_REG_DST_PTR, (u32)dst_ddt->phys,
+				&spacc->cache.dst_ptr);
+
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_PROC_LEN,
+			    proc_len - job->post_aad_sz,
+			    &spacc->cache.proc_len);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_ICV_LEN,
+			    job->icv_len, &spacc->cache.icv_len);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_ICV_OFFSET,
+			    job->icv_offset, &spacc->cache.icv_offset);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_PRE_AAD_LEN,
+			    job->pre_aad_sz, &spacc->cache.pre_aad);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_POST_AAD_LEN,
+			    job->post_aad_sz, &spacc->cache.post_aad);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_IV_OFFSET,
+			    iv_offset, &spacc->cache.iv_offset);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_OFFSET,
+			    aad_offset, &spacc->cache.offset);
+	pdu_io_cached_write(spacc->dptr, spacc->regmap + SPACC_REG_AUX_INFO,
+			    AUX_DIR(job->auxinfo_dir) |
+			    AUX_BIT_ALIGN(job->auxinfo_bit_align) |
+			    AUX_CBC_CS(job->auxinfo_cs_mode),
+			    &spacc->cache.aux);
+
+	if (job->first_use) {
+		writel(job->ckey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
+		       spacc->regmap + SPACC_REG_KEY_SZ);
+		writel(job->hkey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
+		       spacc->regmap + SPACC_REG_KEY_SZ);
+	}
+
+	{
+		unsigned int swid = spacc->job_next_swid;
+		unsigned int tries;
+
+		for (tries = 0; tries < SPACC_MAX_JOBS; tries++) {
+			if (spacc->job_lookup[swid] == SPACC_JOB_IDX_UNUSED)
+				break;
+			swid = (swid + 1) % SPACC_MAX_JOBS;
+		}
+
+		if (tries == SPACC_MAX_JOBS) {
+			/*
+			 * fail loudly rather than silently corrupting
+			 * tracking if it ever isn't.
+			 */
+			return -EBUSY;
+		}
+
+		job->job_swid = swid;
+		spacc->job_lookup[swid] = job_idx;
+		spacc->job_next_swid = (swid + 1) % SPACC_MAX_JOBS;
+	}
+
+	writel(SPACC_SW_CTRL_ID_SET(job->job_swid) |
+	       SPACC_SW_CTRL_PRIO_SET(prio),
+	       spacc->regmap + SPACC_REG_SW_CTRL);
+	writel(job->ctrl, spacc->regmap + SPACC_REG_CTRL);
+
+	/* clear an expansion key after the first call */
+	if (job->first_use) {
+		job->first_use = false;
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+	}
+
+	return 0;
+
+fifo_full:
+	job_index = spacc->jb_head + 1;
+	if (job_index == SPACC_MAX_JOB_BUFFERS)
+		job_index = 0;
+
+	if (job_index == spacc->jb_tail)
+		return -EBUSY;
+
+	spacc->job_buffer[spacc->jb_head] = (struct spacc_job_buffer) {
+		.active		= 1,
+		.job_idx	= job_idx,
+		.src		= src_ddt,
+		.dst		= dst_ddt,
+		.proc_sz	= proc_sz,
+		.aad_offset	= aad_offset,
+		.pre_aad_sz	= pre_aad_sz,
+		.post_aad_sz	= post_aad_sz,
+		.iv_offset	= iv_offset,
+		.prio		= prio,
+		.aad_copy	= aad_copy
+	};
+
+	spacc->jb_head = job_index;
+
+	return 0;
+}
+
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+			     struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+			     u32 proc_sz, u32 aad_offset, u32 pre_aad_sz,
+			     u32 post_aad_sz, u32 iv_offset, u32 prio,
+			     bool aad_copy)
+{
+	int ret = 0;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&spacc->lock, lock_flags);
+	ret = spacc_packet_enqueue_ddt_ex(spacc, 1, job_idx, src_ddt,
+					  dst_ddt, proc_sz, aad_offset,
+					  pre_aad_sz, post_aad_sz,
+					  iv_offset, prio, aad_copy,
+					  &lock_flags);
+	spin_unlock_irqrestore(&spacc->lock, lock_flags);
+
+	return ret;
+}
+
+/*
+ * Plain hashes, HMAC and KMAC/cSHAKE accept arbitrary key lengths, so
+ * they keep the bit-7 "any size" fast path. The block-cipher MAC modes
+ * have a fixed key size that must be validated against the (autodetected)
+ * capability bits. Add other keyed cipher-MAC modes here once their valid
+ * key sizes are confirmed.
+ */
+static bool spacc_mode_has_fixed_keysize(int mode)
+{
+	switch (mode) {
+	case CRYPTO_MODE_MAC_CMAC:
+	case CRYPTO_MODE_MAC_XCBC:
+	case CRYPTO_MODE_MAC_SM4_CMAC:
+	case CRYPTO_MODE_MAC_SM4_XCBC:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* Check if the keysize is supported for the input mode */
+int spacc_is_mode_keysize_supported(struct spacc_device *spacc, int mode,
+				    int keysize, int keysz_index)
+{
+	int x;
+
+	if (mode < 0 || mode >= CRYPTO_MODE_LAST)
+		return SPACC_MODE_NOT_SUPPORTED;
+
+	if (mode == CRYPTO_MODE_NULL ||
+	    ((spacc->config.modes[mode] & 128) &&
+	      !spacc_mode_has_fixed_keysize(mode)))
+		return SPACC_MODE_SUPPORTED;
+
+	/* check for valid keysizes */
+	for (x = 0; x < ARRAY_SIZE(keysizes[0]); x++) {
+		if (keysizes[keysz_index][x] == keysize) {
+			if (spacc->config.modes[mode] & (1 << x))
+				return SPACC_MODE_SUPPORTED;
+			else
+				return SPACC_MODE_NOT_SUPPORTED;
+		}
+	}
+
+	return SPACC_MODE_NOT_SUPPORTED;
+}
+
+/* releases a crypto context back into appropriate module's pool */
+int spacc_close(struct spacc_device *dev, int handle)
+{
+	return spacc_job_release(dev, handle);
+}
+
+static void spacc_static_modes(struct spacc_device *spacc, int x, int y)
+{
+	/* disable the algos that are not supported here */
+	switch (x) {
+	case CRYPTO_MODE_AES_F8:
+	case CRYPTO_MODE_AES_CFB:
+	case CRYPTO_MODE_AES_OFB:
+	case CRYPTO_MODE_MULTI2_ECB:
+	case CRYPTO_MODE_MULTI2_CBC:
+	case CRYPTO_MODE_MULTI2_CFB:
+	case CRYPTO_MODE_MULTI2_OFB:
+	case CRYPTO_MODE_MAC_POLY1305:
+	case CRYPTO_MODE_HASH_CRC32:
+		/* disable the modes */
+		spacc->config.modes[x] &= ~(1 << y);
+		break;
+	default:
+		break; /* algos are enabled */
+	}
+}
+
+int spacc_static_config(struct spacc_device *spacc)
+{
+	int x, y;
+
+	for (x = 0; x < ARRAY_SIZE(template); x++) {
+		spacc->config.modes[x] = template[x];
+
+		for (y = 0; y < (ARRAY_SIZE(keysizes[0])); y++) {
+			/* list static modes */
+			spacc_static_modes(spacc, x, y);
+		}
+	}
+
+	return 0;
+}
+
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle,
+		       void *cbdata)
+{
+	int new_handle;
+	wait_queue_head_t saved_waitq;
+
+	if (old_handle < 0 || old_handle >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	new_handle = spacc_job_request(spacc, spacc->job[old_handle].ctx_idx);
+	if (new_handle < 0)
+		return new_handle;
+
+	/*
+	 * Struct copy is safe here except for the embedded waitq -
+	 * copying a wait_queue_head_t corrupts internal spinlock and
+	 * list_head pointers. Save and restore it around the copy.
+	 */
+	saved_waitq = spacc->job[new_handle].waitq;
+	spacc->job[new_handle]		= spacc->job[old_handle];
+	spacc->job[new_handle].waitq	= saved_waitq;
+	spacc->job[new_handle].job_used	= new_handle;
+	spacc->job[new_handle].cbdata	= cbdata;
+
+	return new_handle;
+}
+
+/*
+ * Allocate a job for spacc module context and initialize
+ * it with an appropriate type.
+ */
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctxid,
+	       int secure_mode, spacc_callback cb, void *cbdata)
+{
+	size_t i;
+	int ret = 0;
+	u32 ctrl = 0;
+	int job_idx = 0;
+	struct spacc_job *job = NULL;
+	const struct enc_config *enc_cfg = NULL;
+	const struct hash_config *hash_cfg = NULL;
+	unsigned long flags;
+
+	if (ctxid == -1) {
+		if (down_trylock(&spacc->ctx_sem)) {
+			dev_dbg(spacc->dptr, "No free HW context, fallback\n");
+			return -EBUSY;
+		}
+	}
+
+	spin_lock_irqsave(&spacc->ctx_lock, flags);
+	job_idx = spacc_job_request(spacc, ctxid);
+
+	if (job_idx < 0) {
+		spin_unlock_irqrestore(&spacc->ctx_lock, flags);
+		dev_dbg(spacc->dptr, "Failed to acquire context\n");
+		ret = -EIO;
+		goto err_release_sem;
+	}
+
+	job = &spacc->job[job_idx];
+	spin_unlock_irqrestore(&spacc->ctx_lock, flags);
+
+	if (secure_mode && job->ctx_idx >= spacc->config.num_sec_ctx) {
+		dev_dbg(spacc->dptr, "ERR: For secure contexts\n");
+		dev_dbg(spacc->dptr,
+			"ERR: Job ctx ID is outside allowed range\n");
+		ret = -EIO;
+		goto err_release_job;
+	}
+
+	job->auxinfo_cs_mode	= 0;
+	job->auxinfo_bit_align	= 0;
+	job->auxinfo_dir	= 0;
+	job->icv_len		= 0;
+
+	/* Process encryption mode using the lookup table */
+	for (i = 0; i < ARRAY_SIZE(enc_table); ++i) {
+		if (enc == enc_table[i].mode) {
+			enc_cfg = &enc_table[i];
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG,
+					       enc_cfg->cipher_alg);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE,
+					       enc_cfg->cipher_mode);
+			job->auxinfo_cs_mode = enc_cfg->auxinfo_cs_mode;
+			break;
+		}
+	}
+
+	if (enc != CRYPTO_MODE_NULL && !enc_cfg) {
+		ret = -EOPNOTSUPP;
+		goto err_release_job;
+	}
+
+	/* Process hash mode using the lookup table */
+	for (i = 0; i < ARRAY_SIZE(hash_table); ++i) {
+		if (hash == hash_table[i].mode) {
+			hash_cfg = &hash_table[i];
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					       hash_cfg->hash_alg);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					       hash_cfg->hash_mode);
+			job->auxinfo_dir = hash_cfg->auxinfo_dir;
+			break;
+		}
+	}
+
+	if (hash != CRYPTO_MODE_NULL && !hash_cfg) {
+		ret = -EOPNOTSUPP;
+		goto err_release_job;
+	}
+
+	ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN) |
+		SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+
+	/* Success path */
+	job->first_use		= true;
+	job->enc_mode		= enc;
+	job->hash_mode		= hash;
+	job->ckey_sz		= 0;
+	job->hkey_sz		= 0;
+	job->job_done		= 0;
+	job->job_swid		= 0;
+	job->job_secure		= !!secure_mode;
+	job->auxinfo_bit_align	= 0;
+	job->job_err		= -EINPROGRESS;
+	job->ctrl		= ctrl | SPACC_CTRL_SET(SPACC_CTRL_CTX_IDX,
+							job->ctx_idx);
+	job->cb			= cb;
+	job->cbdata		= cbdata;
+
+	return job_idx;
+
+err_release_job:
+	spacc_job_release(spacc, job_idx);
+	return ret;
+
+err_release_sem:
+	if (ctxid == -1)
+		up(&spacc->ctx_sem);
+
+	return ret;
+}
+
+/* Helper function to wait for job completion and check results */
+static bool spacc_wait_for_job_completion(struct spacc_device *spacc,
+		void *virt, unsigned char *expected_md)
+{
+	int stat;
+	u32 rbuf;
+
+	/*
+	 * Poll until the status FIFO is non-empty, checking every 10us
+	 * and giving up after 10ms.
+	 */
+	if (readl_poll_timeout(spacc->regmap + SPACC_REG_FIFO_STAT, rbuf,
+			       !(rbuf & SPACC_FIFO_STAT_STAT_EMPTY),
+			       10, 10000))
+		return false;
+
+	/* Pop the completed job and check its return code */
+	writel(1, spacc->regmap + SPACC_REG_STAT_POP);
+	rbuf = readl(spacc->regmap + SPACC_REG_STATUS);
+	stat = SPACC_GET_STATUS_RET_CODE(rbuf);
+
+	return (memcmp(virt, expected_md, 16) == 0) && (stat == SPACC_OK);
+}
+
+static int spacc_xof_stringsize_autodetect(struct spacc_device *spacc)
+{
+	void *virt;
+	int ss, alg;
+	dma_addr_t dma;
+	struct pdu_ddt ddt;
+	unsigned long buflen;
+	unsigned char *buf;
+	unsigned long spacc_ctrl[2] = {0xF400B400, 0xF400D400};
+	unsigned char test_str[6] = {0x01, 0x20, 0x54, 0x45, 0x53, 0x54};
+	unsigned char md[2][16] = {
+			 {0xc3, 0x6d, 0x0a, 0x88, 0xfa, 0x37, 0x4c, 0x9b,
+			  0x44, 0x74, 0xeb, 0x00, 0x5f, 0xe8, 0xca, 0x25},
+			 {0x68, 0x77, 0x04, 0x11, 0xf8, 0xe3, 0xb0, 0x1e,
+			  0x0d, 0xbf, 0x71, 0x6a, 0xe9, 0x87, 0x1a, 0x0d}};
+
+	buf = kzalloc(spacc->config.hash_page_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	virt = dma_alloc_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
+				  &dma, GFP_KERNEL);
+	if (!virt) {
+		kfree(buf);
+		return -EIO;
+	}
+
+	if (pdu_ddt_init(spacc->dptr, &ddt, 1)) {
+		kfree(buf);
+		dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
+				  virt, dma);
+		return -EIO;
+	}
+
+	pdu_ddt_add(spacc->dptr, &ddt, dma, SPACC_TEST_DMA_BUFF_SIZE);
+
+	/* populate registers for jobs */
+	writel((u32)ddt.phys, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel((u32)ddt.phys, spacc->regmap + SPACC_REG_DST_PTR);
+
+	writel(16, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(16, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+	writel(16, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(6, spacc->regmap + SPACC_REG_KEY_SZ);
+	writel(0, spacc->regmap + SPACC_REG_SW_CTRL);
+
+	/* repeat for 2 algorithms, CSHAKE128 and KMAC128 */
+	for (alg = 0; (alg < 2) && (spacc->config.string_size == 0); alg++) {
+		for (ss = 0; ss < 4; ss++) {
+			buflen = (32UL << ss);
+			if (buflen > spacc->config.hash_page_size)
+				break;
+
+			memset(virt, 0, SPACC_TEST_DMA_BUFF_SIZE);
+
+			memset(buf, 0, spacc->config.hash_page_size);
+			memcpy(buf, test_str, sizeof(test_str));
+			memcpy(buf + (buflen >> 1), test_str, sizeof(test_str));
+
+			pdu_to_dev_s(spacc->regmap + SPACC_CTX_HASH_KEY, buf,
+				     spacc->config.hash_page_size >> 2);
+
+			writel(spacc_ctrl[alg], spacc->regmap + SPACC_REG_CTRL);
+
+			if (spacc_wait_for_job_completion(spacc, virt, md[alg]))
+				spacc->config.string_size = (16 << ss);
+		}
+	}
+
+	/* reset registers */
+	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
+	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+
+	kfree(buf);
+	pdu_ddt_free(&ddt);
+	dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
+			  virt, dma);
+
+	return spacc->config.string_size ? 0 : -ENODEV;
+}
+
+void spacc_fini(struct spacc_device *spacc)
+{
+	kvfree(spacc->ctx);
+	kvfree(spacc->job);
+}
+
+int spacc_init(void __iomem *baseaddr, struct spacc_device *spacc,
+	       struct pdu_info *info, struct device *dev)
+{
+	int ret;
+#ifdef CONFIG_CRYPTO_DEV_SPACC_CONFIG_DEBUG
+	unsigned long id;
+	char version_string[3][16]  = { "SPACC", "SPACC-PDU" };
+	char idx_string[2][16]      = { "(Normal Port)", "(Secure Port)" };
+	char dma_type_string[4][16] = { "Unknown", "Scattergather", "Linear",
+					"Unknown" };
+#endif
+
+	memset(spacc, 0, sizeof(*spacc));
+
+	spacc->dptr = dev;
+
+	spin_lock_init(&spacc->lock);
+	spin_lock_init(&spacc->ctx_lock);
+
+	spacc->regmap = baseaddr;
+
+	/* version info */
+	spacc->config.version		= info->spacc_version.version;
+	spacc->config.pdu_version	= (info->pdu_config.major << 4) |
+					   info->pdu_config.minor;
+	spacc->config.project		= info->spacc_version.project;
+	spacc->config.is_pdu		= info->spacc_version.is_pdu;
+	spacc->config.is_qos		= info->spacc_version.qos;
+
+	spacc->config.is_partial	= info->spacc_version.partial;
+	spacc->config.num_ctx		= info->spacc_config.num_ctx;
+
+	/*
+	 * Initialize the counting semaphore. The count is set to the number
+	 * of hardware contexts available, allowing that many "threads" to
+	 * acquire a context before subsequent ones will sleep.
+	 */
+	sema_init(&spacc->ctx_sem, spacc->config.num_ctx);
+
+	spacc->config.ciph_page_size	= 1U <<
+					  info->spacc_config.ciph_ctx_page_size;
+
+	spacc->config.hash_page_size	= 1U <<
+					  info->spacc_config.hash_ctx_page_size;
+
+	spacc->config.dma_type		= info->spacc_config.dma_type;
+
+	/* DDT (scatter-gather) DMA support only */
+	if (spacc->config.dma_type != SPACC_DMA_DDT) {
+		dev_err(spacc->dptr,
+			"unsupported DMA type %u; driver supports DDT only\n",
+			spacc->config.dma_type);
+		return -ENODEV;
+	}
+
+	spacc->config.idx		= info->spacc_version.vspacc_id;
+	spacc->config.cmd0_fifo_depth	= info->spacc_config.cmd0_fifo_depth;
+	spacc->config.cmd1_fifo_depth	= info->spacc_config.cmd1_fifo_depth;
+	spacc->config.cmd2_fifo_depth	= info->spacc_config.cmd2_fifo_depth;
+	spacc->config.stat_fifo_depth	= info->spacc_config.stat_fifo_depth;
+	spacc->config.fifo_cnt		= 1;
+	spacc->config.is_ivimport	= info->spacc_version.ivimport;
+	spacc->wd_cnt_limit		= false;
+
+	/* ctrl register map */
+	if (spacc->config.version <= 0x4E)
+		spacc->config.ctrl_map	= spacc_ctrl_map[SPACC_CTRL_VER_0];
+	else if (spacc->config.version <= 0x60)
+		spacc->config.ctrl_map	= spacc_ctrl_map[SPACC_CTRL_VER_1];
+	else
+		spacc->config.ctrl_map	= spacc_ctrl_map[SPACC_CTRL_VER_2];
+
+	spacc->job_next_swid		= 0;
+	spacc->wdcnt			= 0;
+	spacc->config.wd_timer		= SPACC_WD_TIMER_INIT;
+
+	/*
+	 * Version 4.10 uses IRQ, above uses WD and we don't support
+	 * below 4.00
+	 */
+	if (spacc->config.version < 0x40) {
+		dev_dbg(spacc->dptr, "ERR: Unsupported SPAcc version\n");
+		return -EIO;
+	} else if (spacc->config.version < 0x4B)
+		spacc->op_mode = SPACC_OP_MODE_IRQ;
+	else
+		spacc->op_mode = SPACC_OP_MODE_WD;
+
+	/*
+	 * Set threshold and enable irq on 4.11 and newer cores, we can
+	 * derive this from the HW reported depths.
+	 */
+	if (spacc->config.stat_fifo_depth == 1)
+		spacc->config.ideal_stat_level = 1;
+	else if (spacc->config.stat_fifo_depth <= 4)
+		spacc->config.ideal_stat_level =
+			spacc->config.stat_fifo_depth - 1;
+	else if (spacc->config.stat_fifo_depth <= 8)
+		spacc->config.ideal_stat_level =
+			spacc->config.stat_fifo_depth - 2;
+	else
+		spacc->config.ideal_stat_level =
+			spacc->config.stat_fifo_depth - 4;
+
+	/* determine max proclen value */
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_PROC_LEN);
+	spacc->config.max_msg_size = readl(spacc->regmap + SPACC_REG_PROC_LEN);
+
+#ifdef CONFIG_CRYPTO_DEV_SPACC_CONFIG_DEBUG
+
+	/* read config info */
+	if (spacc->config.is_pdu) {
+		dev_dbg(spacc->dptr, "PDU:\n");
+		dev_dbg(spacc->dptr,
+			"   MAJOR      : %u\n", info->pdu_config.major);
+		dev_dbg(spacc->dptr,
+			"   MINOR      : %u\n", info->pdu_config.minor);
+	}
+
+	id = readl(spacc->regmap + SPACC_REG_ID);
+	dev_dbg(spacc->dptr, "SPACC ID: (%08lx)\n", (unsigned long)id);
+	dev_dbg(spacc->dptr, "   MAJOR      : %x\n", info->spacc_version.major);
+	dev_dbg(spacc->dptr, "   MINOR      : %x\n", info->spacc_version.minor);
+	dev_dbg(spacc->dptr, "   QOS        : %x\n", info->spacc_version.qos);
+	dev_dbg(spacc->dptr, "   IVIMPORT   : %x\n", spacc->config.is_ivimport);
+
+	if (spacc->config.version >= 0x48)
+		dev_dbg(spacc->dptr,
+			"   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
+			version_string[SPACC_ID_TYPE(id) & 3]);
+
+	dev_dbg(spacc->dptr, "   AUX        : %x\n", info->spacc_version.qos);
+	dev_dbg(spacc->dptr, "   IDX        : %lx %s\n", SPACC_ID_VIDX(id),
+		spacc->config.is_secure ?
+		(idx_string[spacc->config.is_secure_port & 1]) : "");
+	dev_dbg(spacc->dptr,
+		"   PARTIAL    : %x\n", info->spacc_version.partial);
+	dev_dbg(spacc->dptr,
+		"   PROJECT    : %x\n", info->spacc_version.project);
+
+	if (spacc->config.version >= 0x48)
+		id = readl(spacc->regmap + SPACC_REG_CONFIG);
+	else
+		id = 0xFFFFFFFF;
+
+	dev_dbg(spacc->dptr, "SPACC CFG: (%08lx)\n", id);
+	dev_dbg(spacc->dptr, "  CTX CNT    : %u\n", info->spacc_config.num_ctx);
+	dev_dbg(spacc->dptr,
+		"   VSPACC CNT : %u\n", info->spacc_config.num_vspacc);
+	dev_dbg(spacc->dptr, "   CIPH SZ    : %-3lu bytes\n", 1UL <<
+		info->spacc_config.ciph_ctx_page_size);
+	dev_dbg(spacc->dptr, "   HASH SZ    : %-3lu bytes\n", 1UL <<
+		info->spacc_config.hash_ctx_page_size);
+	dev_dbg(spacc->dptr,
+		"   DMA TYPE   : %u (%s)\n", info->spacc_config.dma_type,
+		dma_type_string[info->spacc_config.dma_type & 3]);
+	dev_dbg(spacc->dptr, "   MAX PROCLEN: %lu bytes\n", (unsigned long)
+		spacc->config.max_msg_size);
+	dev_dbg(spacc->dptr, "   FIFO CONFIG :\n");
+	dev_dbg(spacc->dptr, "CMD0 DEPTH: %d\n", spacc->config.cmd0_fifo_depth);
+
+	if (spacc->config.is_qos) {
+		dev_dbg(spacc->dptr, "      CMD1 DEPTH: %d\n",
+			spacc->config.cmd1_fifo_depth);
+		dev_dbg(spacc->dptr, "      CMD2 DEPTH: %d\n",
+			spacc->config.cmd2_fifo_depth);
+	}
+	dev_dbg(spacc->dptr, "STAT DEPTH: %d\n", spacc->config.stat_fifo_depth);
+
+	if (spacc->config.dma_type == SPACC_DMA_DDT) {
+		writel(0x1234567F, baseaddr + SPACC_REG_DST_PTR);
+		writel(0xDEADBEEF, baseaddr + SPACC_REG_SRC_PTR);
+
+		if (((readl(baseaddr + SPACC_REG_DST_PTR)) !=
+					(0x1234567F & SPACC_DST_PTR_PTR)) ||
+		    ((readl(baseaddr + SPACC_REG_SRC_PTR)) !=
+		     (0xDEADBEEF & SPACC_SRC_PTR_PTR))) {
+			dev_dbg(spacc->dptr, "ERR: Failed to set pointers\n");
+			goto ERR;
+		}
+	}
+#endif
+
+	/*
+	 * Zero the IRQ CTRL/EN register
+	 * (to make sure we're in a sane state)
+	 */
+	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* init cache */
+	memset(&spacc->cache, 0, sizeof(spacc->cache));
+	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
+	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+	writel(0, spacc->regmap + SPACC_REG_POST_AAD_LEN);
+	writel(0, spacc->regmap + SPACC_REG_IV_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_AUX_INFO);
+
+	spacc->ctx = kvmalloc_array(spacc->config.num_ctx,
+				    sizeof(struct spacc_ctx), GFP_KERNEL);
+	if (!spacc->ctx)
+		goto ERR;
+
+	spacc->job = kvmalloc_array(SPACC_MAX_JOBS, sizeof(struct spacc_job),
+				    GFP_KERNEL);
+	if (!spacc->job)
+		goto ERR;
+
+	/* initialize job_idx and lookup table */
+	spacc_job_init_all(spacc);
+
+	/* initialize contexts */
+	spacc_ctx_init_all(spacc);
+
+	/* autodetect and set string size setting */
+	if (spacc->config.version == 0x61 || spacc->config.version >= 0x65) {
+		ret = spacc_xof_stringsize_autodetect(spacc);
+		/*
+		 * Non-fatal: this only affects CSHAKE128/KMAC128. Failing
+		 * the whole probe over it would take down every other
+		 * cipher/hash mode this device supports. Leaving
+		 * string_size at 0 must be treated as "undetected" by
+		 * whatever registers XOF-capable algorithms, so those two
+		 * modes simply aren't offered rather than being offered
+		 * misconfigured.
+		 */
+		if (ret < 0)
+			dev_warn(spacc->dptr,
+				 "XOF string_size autodetect failed (%d)\n",
+				 ret);
+	}
+	return 0;
+ERR:
+	spacc_fini(spacc);
+	dev_dbg(spacc->dptr, "ERR: Crypto Failed\n");
+
+	return -EIO;
+}
+
+void spacc_pop_jobs(struct work_struct *data)
+{
+	int num = 0;
+	unsigned long lock_flag;
+	struct spacc_priv *priv = container_of(data, struct spacc_priv,
+					       pop_jobs);
+	struct spacc_device *spacc = &priv->spacc;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	spacc->wdcnt = 0;
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	spacc_pop_packets(spacc, &num);
+}
+
+void spacc_remove(struct platform_device *pdev)
+{
+	struct spacc_device *spacc;
+	struct spacc_priv *priv = platform_get_drvdata(pdev);
+
+	/* free test vector memory */
+	spacc = &priv->spacc;
+	spacc_fini(spacc);
+
+	/* devm functions do proper cleanup */
+	pdu_mem_deinit(&pdev->dev);
+}
+
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx)
+{
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS) {
+		dev_dbg(spacc->dptr,
+			"ERR: Invalid Job id specified (out of range)\n");
+		return -EINVAL;
+	}
+
+	job = &spacc->job[job_idx];
+	ctx = spacc_context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx) {
+		dev_dbg(spacc->dptr, "ERR: Failed to find ctx id\n");
+		return -EIO;
+	}
+
+	job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+
+	return 0;
+}
+
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key,
+			   int keylen, unsigned char *xcbc_out)
+{
+	int i;
+	int usecbc;
+	int handle;
+	int err = 0;
+	int ctx_idx;
+	unsigned char *buf;
+	dma_addr_t bufphys;
+	struct pdu_ddt ddt;
+	unsigned char iv[16];
+	struct spacc_job *job;
+
+	if (job_idx >= 0 && job_idx < SPACC_MAX_JOBS)
+		ctx_idx = spacc->job[job_idx].ctx_idx;
+	else
+		ctx_idx = -1;
+
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		/* figure out if we can schedule the key */
+		if (spacc_is_mode_keysize_supported(spacc, CRYPTO_MODE_AES_ECB,
+						    16, 0))
+			usecbc = 0;
+		else if (spacc_is_mode_keysize_supported(spacc,
+							 CRYPTO_MODE_AES_CBC,
+							 16, 0))
+			usecbc = 1;
+		else
+			return -EINVAL;
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		/* figure out if we can schedule the key */
+		if (spacc_is_mode_keysize_supported(spacc, CRYPTO_MODE_SM4_ECB,
+						    16, 0))
+			usecbc = 0;
+		else if (spacc_is_mode_keysize_supported(spacc,
+							 CRYPTO_MODE_SM4_CBC,
+							 16, 0))
+			usecbc = 1;
+		else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	memset(iv, 0, sizeof(iv));
+	memset(&ddt, 0, sizeof(ddt));
+
+	buf = dma_alloc_coherent(spacc->dptr, 64, &bufphys, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	handle = -1;
+
+	/* set to 1111...., 2222...., 333... */
+	for (i = 0; i < 48; i++)
+		buf[i] = (i >> 4) + 1;
+
+	/* build DDT */
+	err = pdu_ddt_init(spacc->dptr, &ddt, 1);
+	if (err)
+		goto xcbc_err;
+
+	pdu_ddt_add(spacc->dptr, &ddt, bufphys, 48);
+
+	/* open a handle in either CBC or ECB mode */
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				    CRYPTO_MODE_AES_CBC : CRYPTO_MODE_AES_ECB),
+				    CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				    CRYPTO_MODE_SM4_CBC : CRYPTO_MODE_SM4_ECB),
+				    CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	}
+
+	spacc_set_operation(spacc, handle, OP_ENCRYPT, 0, 0, 0, 0, 0);
+	job = &spacc->job[handle];
+
+	if (usecbc) {
+		/*
+		 * We can do the ECB work in CBC using three
+		 * jobs with the IVreset to zero each time
+		 */
+		for (i = 0; i < 3; i++) {
+			spacc_write_context(spacc, handle,
+					    SPACC_CRYPTO_OPERATION, key,
+					    keylen, iv, 16);
+			err = spacc_packet_enqueue_ddt(spacc, handle, &ddt,
+						       &ddt, 16, (i * 16) |
+						       ((i * 16) << 16), 0, 0,
+						       0, 0, false);
+			if (err != 0)
+				goto xcbc_err;
+
+			if (wait_event_interruptible(job->waitq,
+						     job->job_done))
+				wait_event(job->waitq,
+					/*
+					 * Pairs with smp_store_release() of
+					 * job_done in completion path.
+					 */
+					 smp_load_acquire(&job->job_done));
+
+			job->job_done = 0;
+			err = job->job_err;
+			if (err != 0)
+				goto xcbc_err;
+		}
+	} else {
+		/*
+		 * Do the 48 bytes as a single SPAcc job this is the ideal case
+		 * but only possible if ECB was enabled in the core
+		 */
+		spacc_write_context(spacc, handle, SPACC_CRYPTO_OPERATION,
+				    key, keylen, iv, 16);
+		err = spacc_packet_enqueue_ddt(spacc, handle, &ddt, &ddt, 48,
+					       0, 0, 0, 0, 0, false);
+		if (err != 0)
+			goto xcbc_err;
+
+		if (wait_event_interruptible(job->waitq, job->job_done))
+
+			wait_event(job->waitq,
+				  /*
+				   * Pairs with smp_store_release() of
+				   * job_done in completion path.
+				   */
+				   smp_load_acquire(&job->job_done));
+
+		job->job_done = 0;
+		err = job->job_err;
+		if (err != 0)
+			goto xcbc_err;
+	}
+
+	memcpy(xcbc_out, buf, 48);
+
+xcbc_err:
+	memzero_explicit(buf, 64);
+	dma_free_coherent(spacc->dptr, 64, buf, bufphys);
+	pdu_ddt_free(&ddt);
+
+	if (handle >= 0)
+		spacc_close(spacc, handle);
+
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
+
+void spacc_set_priority(struct spacc_device *spacc, int priority)
+{
+	u32 vspacc_prio_reg;
+
+	if (!spacc || !spacc->regmap)
+		return;
+
+	if (priority < 0 || priority > 15) {
+		dev_warn(spacc->dptr,
+			 "Invalid VSPAcc priority %d (valid:0-15)\n", priority);
+		return;
+	}
+
+	/* Build new register value with mode = 0 (WEIGHTED),
+	 * weight = priority.
+	 */
+	vspacc_prio_reg = VPRIO_SET(0, priority);
+
+	/* Write to the SPAcc virtual priority register */
+	writel(vspacc_prio_reg, spacc->regmap + SPACC_REG_VIRTUAL_PRIO);
+
+	dev_dbg(spacc->dptr, "Set VSPAcc priority: %d (reg = 0x%08x)\n",
+		priority, vspacc_prio_reg);
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_core.h b/drivers/crypto/dwc-spacc/spacc_core.h
new file mode 100644
index 0000000000000..3778576b1b26f
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.h
@@ -0,0 +1,863 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef SPACC_CORE_H_
+#define SPACC_CORE_H_
+
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include "spacc_hal.h"
+
+struct platform_device;
+
+enum dma_type {
+	SPACC_DMA_UNDEF	 = 0,
+	SPACC_DMA_DDT	 = 1,
+	SPACC_DMA_LINEAR = 2
+};
+
+enum op_mode {
+	SPACC_OP_MODE_IRQ	= 0,
+	SPACC_OP_MODE_WD	= 1 /* watchdog */
+};
+
+#define OP_ENCRYPT		0
+#define OP_DECRYPT		1
+#define SPACC_CTX_WAIT_TIMEOUT	5
+
+#define SPACC_CRYPTO_OPERATION	1
+#define SPACC_HASH_OPERATION	2
+
+#define SPACC_AUTO_SIZE		(-1)
+
+#define SPACC_WD_LIMIT		0x80
+#define SPACC_WD_TIMER_INIT	0x40000
+
+#define SPACC_MODE_SUPPORTED		1
+#define SPACC_MODE_NOT_SUPPORTED	0
+
+#define SPACC_AUTODETECT_TIMEOUT_MS	10
+#define SPACC_AUTODETECT_MAX_TIMEOUTS	3
+
+/********* Register Offsets **********/
+#define SPACC_REG_IRQ_EN	0x00000L
+#define SPACC_REG_IRQ_STAT	0x00004L
+#define SPACC_REG_IRQ_CTRL	0x00008L
+#define SPACC_REG_FIFO_STAT	0x0000CL
+#define SPACC_REG_SDMA_BRST_SZ	0x00010L
+
+#define SPACC_REG_SRC_PTR	0x00020L
+#define SPACC_REG_DST_PTR	0x00024L
+#define SPACC_REG_OFFSET	0x00028L
+#define SPACC_REG_PRE_AAD_LEN	0x0002CL
+#define SPACC_REG_POST_AAD_LEN	0x00030L
+
+#define SPACC_REG_PROC_LEN	0x00034L
+#define SPACC_REG_ICV_LEN	0x00038L
+#define SPACC_REG_ICV_OFFSET	0x0003CL
+#define SPACC_REG_IV_OFFSET	0x00040L
+
+#define SPACC_REG_SW_CTRL	0x00044L
+#define SPACC_REG_AUX_INFO	0x00048L
+#define SPACC_REG_CTRL		0x0004CL
+
+#define SPACC_REG_STAT_POP	0x00050L
+#define SPACC_REG_STATUS	0x00054L
+
+#define SPACC_REG_STAT_WD_CTRL	0x00080L
+
+#define SPACC_REG_KEY_SZ	0x00100L
+
+#define SPACC_REG_VIRTUAL_RQST	0x00140L
+#define SPACC_REG_VIRTUAL_ALLOC	0x00144L
+#define SPACC_REG_VIRTUAL_PRIO	0x00148L
+
+#define SPACC_REG_ID		0x00180L
+#define SPACC_REG_CONFIG	0x00184L
+#define SPACC_REG_CONFIG2	0x00190L
+
+#define SPACC_REG_SECURE_CTRL		0x001C0L
+#define SPACC_REG_SECURE_RELEASE	0x001C4
+
+#define SPACC_REG_SK_LOAD	0x00200L
+#define SPACC_REG_SK_STAT	0x00204L
+#define SPACC_REG_SK_KEY	0x00240L
+
+#define SPACC_REG_VERSION_EXT_3	0x00194L
+
+/* out 8MB from base of SPACC */
+#define SPACC_REG_SKP		0x800000UL
+
+/********** Context Offsets **********/
+#define SPACC_CTX_CIPH_KEY	0x04000L
+#define SPACC_CTX_HASH_KEY	0x08000L
+
+/******** Sub-Context Offsets ********/
+#define SPACC_CTX_AES_KEY	0x00
+#define SPACC_CTX_AES_IV	0x20
+
+#define SPACC_CTX_DES_KEY	0x08
+#define SPACC_CTX_DES_IV	0x00
+
+/* use these to loop over CMDX macros */
+#define SPACC_CMDX_MAX		1
+#define SPACC_CMDX_MAX_QOS	3
+
+/********** IRQ_EN Bit Masks **********/
+
+#define _SPACC_IRQ_CMD0		0
+#define _SPACC_IRQ_STAT		4
+#define _SPACC_IRQ_STAT_WD	12
+#define _SPACC_IRQ_GLBL		31
+
+#define SPACC_IRQ_EN_CMD(x)	(1UL << _SPACC_IRQ_CMD0 << (x))
+#define SPACC_IRQ_EN_STAT	BIT(_SPACC_IRQ_STAT)
+#define SPACC_IRQ_EN_STAT_WD	BIT(_SPACC_IRQ_STAT_WD)
+#define SPACC_IRQ_EN_GLBL	BIT(_SPACC_IRQ_GLBL)
+
+/********* IRQ_STAT Bitmasks *********/
+
+#define SPACC_IRQ_STAT_CMDX(x)	(1UL << _SPACC_IRQ_CMD0 << (x))
+#define SPACC_IRQ_STAT_STAT	BIT(_SPACC_IRQ_STAT)
+#define SPACC_IRQ_STAT_STAT_WD	BIT(_SPACC_IRQ_STAT_WD)
+
+#define SPACC_IRQ_STAT_CLEAR_STAT(spacc)    writel(SPACC_IRQ_STAT_STAT, \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+#define SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc) writel(SPACC_IRQ_STAT_STAT_WD, \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+#define SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x) writel(SPACC_IRQ_STAT_CMDX(x), \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+/********* IRQ_CTRL Bitmasks *********/
+/* CMD0 = 0; for QOS, CMD1 = 8, CMD2 = 16 */
+#define _SPACC_IRQ_CTRL_CMDX_CNT(x)	(8 * (x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_SET(x, n) \
+	(((n) & 0xFF) << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_MASK(x) \
+	(0xFF << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+
+/* STAT_CNT is at 16 and for QOS at 24 */
+#define _SPACC_IRQ_CTRL_STAT_CNT	16
+#define SPACC_IRQ_CTRL_STAT_CNT_SET(n)	((n) << _SPACC_IRQ_CTRL_STAT_CNT)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK	(0x1FF << _SPACC_IRQ_CTRL_STAT_CNT)
+
+#define _SPACC_IRQ_CTRL_STAT_CNT_QOS	24
+#define SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(n) \
+	((n) << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+
+/******** FIFO_STAT Bitmasks *********/
+
+/* SPACC with QOS */
+#define SPACC_FIFO_STAT_CMDX_CNT_MASK(x) (0x7F << ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_CNT_GET(x, y) \
+	(((y) & SPACC_FIFO_STAT_CMDX_CNT_MASK(x)) >> ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_FULL(x)	(1UL << (7 + (x) * 8))
+
+#define _SPACC_FIFO_STAT_STAT_CNT_QOS	24
+#define SPACC_FIFO_STAT_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_FIFO_STAT_STAT_CNT_QOS)
+#define SPACC_FIFO_STAT_STAT_CNT_GET_QOS(y)	\
+	(((y) &					\
+	SPACC_FIFO_STAT_STAT_CNT_MASK_QOS) >> _SPACC_FIFO_STAT_STAT_CNT_QOS)
+
+/* SPACC without QOS */
+#define SPACC_FIFO_STAT_CMD0_CNT_MASK	(0x1FF)
+#define SPACC_FIFO_STAT_CMD0_CNT_GET(y)	((y) & SPACC_FIFO_STAT_CMD0_CNT_MASK)
+#define _SPACC_FIFO_STAT_CMD0_FULL	15
+#define SPACC_FIFO_STAT_CMD0_FULL	BIT(_SPACC_FIFO_STAT_CMD0_FULL)
+
+#define _SPACC_FIFO_STAT_STAT_CNT	16
+#define SPACC_FIFO_STAT_STAT_CNT_MASK	(0x1FF << _SPACC_FIFO_STAT_STAT_CNT)
+#define SPACC_FIFO_STAT_STAT_CNT_GET(y) \
+	(((y) & SPACC_FIFO_STAT_STAT_CNT_MASK) >> _SPACC_FIFO_STAT_STAT_CNT)
+
+#define _SPACC_FIFO_STAT_STAT_EMPTY	31
+#define SPACC_FIFO_STAT_STAT_EMPTY	BIT(_SPACC_FIFO_STAT_STAT_EMPTY)
+
+/********* SRC/DST_PTR Bitmasks **********/
+
+#define SPACC_SRC_PTR_PTR	0xFFFFFFF8
+#define SPACC_DST_PTR_PTR	0xFFFFFFF8
+
+/********** OFFSET Bitmasks **********/
+
+#define SPACC_OFFSET_SRC_O	0
+#define SPACC_OFFSET_SRC_W	16
+#define SPACC_OFFSET_DST_O	16
+#define SPACC_OFFSET_DST_W	16
+
+#define SPACC_MIN_CHUNK_SIZE	1024
+#define SPACC_MAX_CHUNK_SIZE	16384
+
+/********* PKT_LEN Bitmasks **********/
+
+#ifndef _SPACC_PKT_LEN_PROC_LEN
+#define _SPACC_PKT_LEN_PROC_LEN		0
+#endif
+#ifndef _SPACC_PKT_LEN_AAD_LEN
+#define _SPACC_PKT_LEN_AAD_LEN		16
+#endif
+
+/********* SW_CTRL Bitmasks ***********/
+
+#define _SPACC_SW_CTRL_ID_0		0
+#define SPACC_SW_CTRL_ID_W		8
+#define SPACC_SW_CTRL_ID_MASK		(0xFF << _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_GET(y) \
+	(((y) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_SET(id) \
+	(((id) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+
+#define _SPACC_SW_CTRL_PRIO		30
+#define SPACC_SW_CTRL_PRIO_MASK		0x3
+#define SPACC_SW_CTRL_PRIO_SET(prio) \
+	(((prio) & SPACC_SW_CTRL_PRIO_MASK) << _SPACC_SW_CTRL_PRIO)
+
+/* Priorities */
+#define SPACC_SW_CTRL_PRIO_HI	0
+#define SPACC_SW_CTRL_PRIO_MED	1
+#define SPACC_SW_CTRL_PRIO_LOW	2
+
+/*********** SECURE_CTRL bitmasks *********/
+#define _SPACC_SECURE_CTRL_MS_SRC	0
+#define _SPACC_SECURE_CTRL_MS_DST	1
+#define _SPACC_SECURE_CTRL_MS_DDT	2
+#define _SPACC_SECURE_CTRL_LOCK		31
+
+#define SPACC_SECURE_CTRL_MS_SRC	BIT(_SPACC_SECURE_CTRL_MS_SRC)
+#define SPACC_SECURE_CTRL_MS_DST	BIT(_SPACC_SECURE_CTRL_MS_DST)
+#define SPACC_SECURE_CTRL_MS_DDT	BIT(_SPACC_SECURE_CTRL_MS_DDT)
+#define SPACC_SECURE_CTRL_LOCK		BIT(_SPACC_SECURE_CTRL_LOCK)
+
+/********* SKP bits **************/
+#define _SPACC_SK_LOAD_CTX_IDX	0
+#define _SPACC_SK_LOAD_ALG	8
+#define _SPACC_SK_LOAD_MODE	12
+#define _SPACC_SK_LOAD_SIZE	16
+#define _SPACC_SK_LOAD_ENC_EN	30
+#define _SPACC_SK_LOAD_DEC_EN	31
+#define _SPACC_SK_STAT_BUSY	0
+
+#define SPACC_SK_LOAD_ENC_EN	BIT(_SPACC_SK_LOAD_ENC_EN)
+#define SPACC_SK_LOAD_DEC_EN	BIT(_SPACC_SK_LOAD_DEC_EN)
+#define SPACC_SK_STAT_BUSY	BIT(_SPACC_SK_STAT_BUSY)
+
+/*********** CTRL Bitmasks ***********/
+/*
+ * These CTRL field locations vary with SPACC version
+ * and if they are used, they should be set accordingly
+ */
+#define _SPACC_CTRL_CIPH_ALG	0
+#define _SPACC_CTRL_HASH_ALG	4
+#define _SPACC_CTRL_CIPH_MODE	8
+#define _SPACC_CTRL_HASH_MODE	12
+#define _SPACC_CTRL_MSG_BEGIN	14
+#define _SPACC_CTRL_MSG_END	15
+#define _SPACC_CTRL_CTX_IDX	16
+#define _SPACC_CTRL_ENCRYPT	24
+#define _SPACC_CTRL_AAD_COPY	25
+#define _SPACC_CTRL_ICV_PT	26
+#define _SPACC_CTRL_ICV_ENC	27
+#define _SPACC_CTRL_ICV_APPEND	28
+#define _SPACC_CTRL_KEY_EXP	29
+#define _SPACC_CTRL_SEC_KEY	31
+
+/* CTRL bitmasks for 4.15+ cores */
+#define _SPACC_CTRL_CIPH_ALG_415	0
+#define _SPACC_CTRL_HASH_ALG_415	3
+#define _SPACC_CTRL_CIPH_MODE_415	8
+#define _SPACC_CTRL_HASH_MODE_415	12
+
+/********* Virtual Spacc Priority Bitmasks **********/
+#define _SPACC_VPRIO_MODE		0
+#define _SPACC_VPRIO_WEIGHT		8
+#define SPACC_VSPACC_PRIORITY		1
+#define SPACC_INTERNAL_COUNTER		100000
+
+/********* AUX INFO Bitmasks *********/
+#define _SPACC_AUX_INFO_DIR		0
+#define _SPACC_AUX_INFO_BIT_ALIGN	1
+#define _SPACC_AUX_INFO_CBC_CS		16
+
+/********* STAT_POP Bitmasks *********/
+#define _SPACC_STAT_POP_POP	0
+#define SPACC_STAT_POP_POP	BIT(_SPACC_STAT_POP_POP)
+
+/********** STATUS Bitmasks **********/
+#define _SPACC_STATUS_SW_ID	0
+#define _SPACC_STATUS_RET_CODE	24
+#define _SPACC_STATUS_SEC_CMD	31
+#define SPACC_GET_STATUS_RET_CODE(s) \
+	(((s) >> _SPACC_STATUS_RET_CODE) & 0x7)
+
+#define SPACC_STATUS_SW_ID_MASK		(0xFF << _SPACC_STATUS_SW_ID)
+#define SPACC_STATUS_SW_ID_GET(y) \
+	(((y) & SPACC_STATUS_SW_ID_MASK) >> _SPACC_STATUS_SW_ID)
+
+/********** KEY_SZ Bitmasks **********/
+#define _SPACC_KEY_SZ_SIZE	0
+#define _SPACC_KEY_SZ_CTX_IDX	8
+#define _SPACC_KEY_SZ_CIPHER	31
+
+#define SPACC_KEY_SZ_CIPHER		BIT(_SPACC_KEY_SZ_CIPHER)
+
+#define SPACC_SET_CIPHER_KEY_SZ(z) \
+	(((z) << _SPACC_KEY_SZ_SIZE) | (1UL << _SPACC_KEY_SZ_CIPHER))
+#define SPACC_SET_HASH_KEY_SZ(z)	((z) << _SPACC_KEY_SZ_SIZE)
+#define SPACC_SET_KEY_CTX(ctx)		((ctx) << _SPACC_KEY_SZ_CTX_IDX)
+
+/*****************************************************************************/
+
+#define AUX_DIR(a)       ((a) << _SPACC_AUX_INFO_DIR)
+#define AUX_BIT_ALIGN(a) ((a) << _SPACC_AUX_INFO_BIT_ALIGN)
+#define AUX_CBC_CS(a)    ((a) << _SPACC_AUX_INFO_CBC_CS)
+
+#define VPRIO_SET(mode, weight) \
+	(((mode) << _SPACC_VPRIO_MODE) | ((weight) << _SPACC_VPRIO_WEIGHT))
+
+#ifndef MAX_DDT_ENTRIES
+/* add one for null at end of list */
+#define MAX_DDT_ENTRIES \
+	((SPACC_MAX_MSG_MALLOC_SIZE / SPACC_MAX_PARTICLE_SIZE) + 1)
+#endif
+
+#define DDT_ENTRY_SIZE (sizeof(ddt_entry) * MAX_DDT_ENTRIES)
+
+#ifndef SPACC_MAX_JOBS
+#define SPACC_MAX_JOBS  BIT(SPACC_SW_CTRL_ID_W)
+#endif
+
+#if SPACC_MAX_JOBS > 256
+#  error SPACC_MAX_JOBS cannot exceed 256.
+#endif
+
+#ifndef SPACC_MAX_JOB_BUFFERS
+#define SPACC_MAX_JOB_BUFFERS	192
+#endif
+
+/* max DDT particle size */
+#ifndef SPACC_MAX_PARTICLE_SIZE
+#define SPACC_MAX_PARTICLE_SIZE	4096
+#endif
+
+/*
+ * Max message size from HW configuration
+ * usually defined in ICD as (2 exponent 16) -1
+ */
+#ifndef _SPACC_MAX_MSG_MALLOC_SIZE
+#define _SPACC_MAX_MSG_MALLOC_SIZE	16
+#endif
+#define SPACC_MAX_MSG_MALLOC_SIZE	BIT(_SPACC_MAX_MSG_MALLOC_SIZE)
+
+#ifndef SPACC_MAX_MSG_SIZE
+#define SPACC_MAX_MSG_SIZE	(SPACC_MAX_MSG_MALLOC_SIZE - 1)
+#endif
+
+#define SPACC_LOOP_WAIT		1000000
+#define SPACC_CTR_IV_MAX8	((u32)0xFF)
+#define SPACC_CTR_IV_MAX16	((u32)0xFFFF)
+#define SPACC_CTR_IV_MAX32	((u32)0xFFFFFFFF)
+#define SPACC_CTR_IV_MAX64	((u64)0xFFFFFFFFFFFFFFFF)
+
+/* cipher algos */
+enum ecipher {
+	C_NULL		= 0,
+	C_DES		= 1,
+	C_AES		= 2,
+	C_RC4		= 3,
+	C_MULTI2	= 4,
+	C_KASUMI	= 5,
+	C_SNOW3G_UEA2	= 6,
+	C_ZUC_UEA3	= 7,
+	C_CHACHA20	= 8,
+	C_SM4		= 9,
+	C_MAX		= 10
+};
+
+/* ctrl reg cipher modes */
+enum eciphermode {
+	CM_ECB = 0,
+	CM_CBC = 1,
+	CM_CTR = 2,
+	CM_CCM = 3,
+	CM_GCM = 5,
+	CM_OFB = 7,
+	CM_CFB = 8,
+	CM_F8  = 9,
+	CM_XTS = 10,
+	CM_MAX = 11
+};
+
+enum echachaciphermode {
+	CM_CHACHA_STREAM = 2,
+	CM_CHACHA_AEAD	 = 5
+};
+
+enum ehash {
+	H_NULL		 = 0,
+	H_MD5		 = 1,
+	H_SHA1		 = 2,
+	H_SHA224	 = 3,
+	H_SHA256	 = 4,
+	H_SHA384	 = 5,
+	H_SHA512	 = 6,
+	H_XCBC		 = 7,
+	H_CMAC		 = 8,
+	H_KF9		 = 9,
+	H_SNOW3G_UIA2	 = 10,
+	H_CRC32_I3E802_3 = 11,
+	H_ZUC_UIA3	 = 12,
+	H_SHA512_224	 = 13,
+	H_SHA512_256	 = 14,
+	H_MICHAEL	 = 15,
+	H_SHA3_224	 = 16,
+	H_SHA3_256	 = 17,
+	H_SHA3_384	 = 18,
+	H_SHA3_512	 = 19,
+	H_SHAKE128	 = 20,
+	H_SHAKE256	 = 21,
+	H_POLY1305	 = 22,
+	H_SM3		 = 23,
+	H_SM4_XCBC_MAC	 = 24,
+	H_SM4_CMAC	 = 25,
+	H_MAX		 = 26
+};
+
+enum ehashmode {
+	HM_RAW		= 0,
+	HM_SSLMAC	= 1,
+	HM_HMAC		= 2,
+	HM_MAX		= 3
+};
+
+enum eshakehashmode {
+	HM_SHAKE_SHAKE	= 0,
+	HM_SHAKE_CSHAKE	= 1,
+	HM_SHAKE_KMAC	= 2
+};
+
+enum spacc_ret_code {
+	SPACC_OK	= 0,
+	SPACC_ICVFAIL	= 1,
+	SPACC_MEMERR	= 2,
+	SPACC_BLOCKERR	= 3,
+	SPACC_SECERR	= 4
+};
+
+enum eicvpos {
+	IP_ICV_OFFSET	= 0,
+	IP_ICV_APPEND	= 1,
+	IP_ICV_IGNORE	= 2,
+	IP_MAX		= 3
+};
+
+enum hash_icv {
+	/* HASH of plaintext */
+	ICV_HASH		= 0,
+	/* HASH and encrypt the plaintext */
+	ICV_HASH_ENCRYPT	= 1,
+	/* HASH the ciphertext */
+	ICV_ENCRYPT_HASH	= 2,
+	ICV_IGNORE		= 3,
+	IM_MAX			= 4
+};
+
+enum crypto_modes {
+	CRYPTO_MODE_NULL,
+	CRYPTO_MODE_AES_ECB,
+	CRYPTO_MODE_AES_CBC,
+	CRYPTO_MODE_AES_CTR,
+	CRYPTO_MODE_AES_CCM,
+	CRYPTO_MODE_AES_GCM,
+	CRYPTO_MODE_AES_F8,
+	CRYPTO_MODE_AES_XTS,
+	CRYPTO_MODE_AES_CFB,
+	CRYPTO_MODE_AES_OFB,
+	CRYPTO_MODE_AES_CS1,
+	CRYPTO_MODE_AES_CS2,
+	CRYPTO_MODE_AES_CS3,
+	CRYPTO_MODE_MULTI2_ECB,
+	CRYPTO_MODE_MULTI2_CBC,
+	CRYPTO_MODE_MULTI2_OFB,
+	CRYPTO_MODE_MULTI2_CFB,
+	CRYPTO_MODE_3DES_CBC,
+	CRYPTO_MODE_3DES_ECB,
+	CRYPTO_MODE_DES_CBC,
+	CRYPTO_MODE_DES_ECB,
+	CRYPTO_MODE_KASUMI_ECB,
+	CRYPTO_MODE_KASUMI_F8,
+	CRYPTO_MODE_SNOW3G_UEA2,
+	CRYPTO_MODE_ZUC_UEA3,
+	CRYPTO_MODE_CHACHA20_STREAM,
+	CRYPTO_MODE_CHACHA20_POLY1305,
+	CRYPTO_MODE_SM4_ECB,
+	CRYPTO_MODE_SM4_CBC,
+	CRYPTO_MODE_SM4_CFB,
+	CRYPTO_MODE_SM4_OFB,
+	CRYPTO_MODE_SM4_CTR,
+	CRYPTO_MODE_SM4_CCM,
+	CRYPTO_MODE_SM4_GCM,
+	CRYPTO_MODE_SM4_F8,
+	CRYPTO_MODE_SM4_XTS,
+	CRYPTO_MODE_SM4_CS1,
+	CRYPTO_MODE_SM4_CS2,
+	CRYPTO_MODE_SM4_CS3,
+
+	CRYPTO_MODE_HASH_MD5,
+	CRYPTO_MODE_HMAC_MD5,
+	CRYPTO_MODE_HASH_SHA1,
+	CRYPTO_MODE_HMAC_SHA1,
+	CRYPTO_MODE_HASH_SHA224,
+	CRYPTO_MODE_HMAC_SHA224,
+	CRYPTO_MODE_HASH_SHA256,
+	CRYPTO_MODE_HMAC_SHA256,
+	CRYPTO_MODE_HASH_SHA384,
+	CRYPTO_MODE_HMAC_SHA384,
+	CRYPTO_MODE_HASH_SHA512,
+	CRYPTO_MODE_HMAC_SHA512,
+	CRYPTO_MODE_HASH_SHA512_224,
+	CRYPTO_MODE_HMAC_SHA512_224,
+	CRYPTO_MODE_HASH_SHA512_256,
+	CRYPTO_MODE_HMAC_SHA512_256,
+
+	CRYPTO_MODE_MAC_XCBC,
+	CRYPTO_MODE_MAC_CMAC,
+	CRYPTO_MODE_MAC_KASUMI_F9,
+	CRYPTO_MODE_MAC_SNOW3G_UIA2,
+	CRYPTO_MODE_MAC_ZUC_UIA3,
+	CRYPTO_MODE_MAC_POLY1305,
+
+	CRYPTO_MODE_SSLMAC_MD5,
+	CRYPTO_MODE_SSLMAC_SHA1,
+	CRYPTO_MODE_HASH_CRC32,
+	CRYPTO_MODE_MAC_MICHAEL,
+
+	CRYPTO_MODE_HASH_SHA3_224,
+	CRYPTO_MODE_HASH_SHA3_256,
+	CRYPTO_MODE_HASH_SHA3_384,
+	CRYPTO_MODE_HASH_SHA3_512,
+
+	CRYPTO_MODE_HASH_SHAKE128,
+	CRYPTO_MODE_HASH_SHAKE256,
+	CRYPTO_MODE_HASH_CSHAKE128,
+	CRYPTO_MODE_HASH_CSHAKE256,
+	CRYPTO_MODE_MAC_KMAC128,
+	CRYPTO_MODE_MAC_KMAC256,
+	CRYPTO_MODE_MAC_KMACXOF128,
+	CRYPTO_MODE_MAC_KMACXOF256,
+
+	CRYPTO_MODE_HASH_SM3,
+	CRYPTO_MODE_HMAC_SM3,
+	CRYPTO_MODE_MAC_SM4_XCBC,
+	CRYPTO_MODE_MAC_SM4_CMAC,
+
+	CRYPTO_MODE_LAST
+};
+
+/* job descriptor */
+typedef void (*spacc_callback)(void *spacc_dev, void *data);
+
+struct spacc_job {
+	wait_queue_head_t waitq;
+
+	unsigned long
+		enc_mode,	/* Encryption algorithm mode */
+		hash_mode,	/* Hash algorithm mode */
+		icv_len,
+		icv_offset,
+		op,		/* operation */
+		ctrl,		/* CTRL shadow register */
+		pre_aad_sz,
+		post_aad_sz,	/* size of AAD for the latest packet */
+		hkey_sz,
+		ckey_sz;
+	bool first_use;
+
+	/* direction and bit alignment parameters for the AUX_INFO reg */
+	unsigned int auxinfo_dir, auxinfo_bit_align;
+	unsigned int auxinfo_cs_mode; /* AUX info setting for CBC-CS */
+
+	u32	ctx_idx;
+	unsigned int job_used;
+	unsigned int job_swid;
+	unsigned int job_done;
+	unsigned int job_err;
+	unsigned int job_secure;
+	spacc_callback cb;
+	void	*cbdata;
+};
+
+#define SPACC_CTX_IDX_UNUSED	0xFFFFFFFF
+#define SPACC_JOB_IDX_UNUSED	0xFFFFFFFF
+
+struct spacc_ctx {
+	/* memory context to store cipher keys */
+	void __iomem *ciph_key;
+	/* memory context to store hash keys */
+	void __iomem *hash_key;
+	/* reference count of jobs using this context */
+	int ref_cnt;
+	/* number of contexts following related to this one */
+	int ncontig;
+};
+
+#define SPACC_CTRL_MASK(field) \
+	(1UL << spacc->config.ctrl_map[(field)])
+#define SPACC_CTRL_SET(field, value) \
+	((value) << spacc->config.ctrl_map[(field)])
+
+enum ctrl_map {
+	SPACC_CTRL_VER_0,
+	SPACC_CTRL_VER_1,
+	SPACC_CTRL_VER_2,
+	SPACC_CTRL_VER_SIZE
+};
+
+enum ctrl_type {
+	SPACC_CTRL_CIPH_ALG,
+	SPACC_CTRL_CIPH_MODE,
+	SPACC_CTRL_HASH_ALG,
+	SPACC_CTRL_HASH_MODE,
+	SPACC_CTRL_ENCRYPT,
+	SPACC_CTRL_CTX_IDX,
+	SPACC_CTRL_SEC_KEY,
+	SPACC_CTRL_AAD_COPY,
+	SPACC_CTRL_ICV_PT,
+	SPACC_CTRL_ICV_ENC,
+	SPACC_CTRL_ICV_APPEND,
+	SPACC_CTRL_KEY_EXP,
+	SPACC_CTRL_MSG_BEGIN,
+	SPACC_CTRL_MSG_END,
+	SPACC_CTRL_MAPSIZE
+};
+
+struct spacc_device {
+	void __iomem *regmap;
+	bool wd_cnt_limit;
+	bool autodetect;
+
+	/* Manages the pool of available H/W contexts */
+	struct semaphore ctx_sem;
+
+	/* hardware configuration */
+	struct {
+		unsigned int version,
+			     pdu_version,
+			     project;
+		u32 max_msg_size;	/* max PROCLEN value */
+
+		unsigned char modes[CRYPTO_MODE_LAST];
+
+		int num_ctx,		/* no. of contexts */
+		    num_sec_ctx,	/* no. of SKP contexts */
+		    sec_ctx_page_size,	/* page size of SKP context in bytes */
+		    ciph_page_size,	/* cipher context page size in bytes */
+		    hash_page_size,	/* hash context page size in bytes */
+		    string_size,
+		    is_qos,		/* QOS spacc? */
+		    is_pdu,		/* PDU spacc? */
+		    is_secure,
+		    is_secure_port,	/* are we on the secure port? */
+		    is_partial,		/* Is partial processing enabled? */
+		    is_ivimport,	/* is ivimport enabled? */
+		    dma_type,		/* DMA type: linear or scattergather */
+		    idx,		/* which virtual spacc IDX is this? */
+		    priority,		/* weighted priority of virtual spacc */
+		    cmd0_fifo_depth,	/* CMD FIFO depths */
+		    cmd1_fifo_depth,
+		    cmd2_fifo_depth,
+		    stat_fifo_depth,	/* depth of STATUS FIFO */
+		    fifo_cnt,
+		    ideal_stat_level;
+
+		u32 wd_timer;
+		u64 oldtimer, timer;
+		const u8 *ctrl_map;    /* map of ctrl register field offsets */
+	} config;
+
+	struct spacc_job_buffer {
+		int active;
+		int job_idx;
+		struct pdu_ddt *src, *dst;
+		u32 proc_sz, aad_offset, pre_aad_sz,
+		post_aad_sz, iv_offset, prio;
+		bool aad_copy;
+	} job_buffer[SPACC_MAX_JOB_BUFFERS];
+
+	int jb_head, jb_tail;
+
+	int op_mode,	/* operating mode and watchdog functionality */
+	    wdcnt;	/* number of pending WD IRQs */
+
+	/* SW_ID value which will be used for next job */
+	unsigned int job_next_swid;
+
+	struct spacc_ctx *ctx;	/* this size changes per configured device */
+	struct spacc_job *job;	/* allocate memory for [SPACC_MAX_JOBS]; */
+	int job_lookup[SPACC_MAX_JOBS];	/* correlate SW_ID back to job index */
+
+	spinlock_t lock;	/* lock for register access */
+	spinlock_t ctx_lock;
+
+	/* callback functions for IRQ processing */
+	void (*irq_cb_cmdx)(struct spacc_device *spacc, int x);
+	void (*irq_cb_stat)(struct spacc_device *spacc);
+	void (*irq_cb_stat_wd)(struct spacc_device *spacc);
+
+	/*
+	 * This is called after jobs have been popped off the STATUS FIFO
+	 * useful so you can be told when there might be space available
+	 * in the CMD FIFO
+	 */
+	void (*spacc_notify_jobs)(struct spacc_device *spacc);
+
+	/* cache */
+	struct {
+		u32 src_ptr,
+		    dst_ptr,
+		    proc_len,
+		    icv_len,
+		    icv_offset,
+		    pre_aad,
+		    post_aad,
+		    iv_offset,
+		    offset,
+		    aux;
+	} cache;
+
+	struct device *dptr;
+};
+
+struct spacc_priv {
+	struct spacc_device spacc;
+
+	/* dedicated workQ */
+	struct workqueue_struct *spacc_wq;
+	struct work_struct pop_jobs;
+	struct crypto_engine *engine;
+	unsigned long max_msg_len;
+	int irq;
+
+	atomic_t dma_ref_cnt;
+	wait_queue_head_t drain_wq;
+	bool removing;
+
+	/* Per-device DMA pools for multi-device safety */
+	struct dma_pool *hash_pool;
+	struct kmem_cache *iv_pool;
+	struct dma_pool *ddt_pool, *ddt16_pool, *ddt4_pool;
+
+	/* Per-device lists and mutexes for algorithm tracking */
+	struct list_head hash_alg_list;
+	struct mutex hash_alg_mutex;
+	struct list_head cipher_alg_list;
+	struct mutex cipher_alg_mutex;
+	struct list_head aead_alg_list;
+	struct mutex aead_alg_mutex;
+};
+
+/* Structure for encryption mode configuration */
+struct enc_config {
+	int mode;
+	u32 cipher_alg;
+	u32 cipher_mode;
+	int auxinfo_cs_mode;
+};
+
+/* Structure for hash mode configuration */
+struct hash_config {
+	int mode;
+	u32 hash_alg;
+	u32 hash_mode;
+	int auxinfo_dir;
+};
+
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctx,
+		int secure_mode, spacc_callback cb, void *cbdata);
+
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle,
+		       void *cbdata);
+
+int spacc_close(struct spacc_device *spacc, int job_idx);
+
+int spacc_set_operation(struct spacc_device *spacc, int job_idx, int op,
+			u32 prot, u32 icvcmd, u32 icvoff,
+			u32 icvsz, u32 sec_key);
+
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx);
+
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
+				int job_idx, struct pdu_ddt *src_ddt,
+				struct pdu_ddt *dst_ddt, u32 proc_sz,
+				u32 aad_offset, u32 pre_aad_sz, u32 post_aad_sz,
+				u32 iv_offset, u32 prio, bool aad_copy,
+				unsigned long *lock_flag);
+
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+			     struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+			     u32 proc_sz, u32 aad_offset, u32 pre_aad_sz,
+			     u32 post_aad_sz, u32 iv_offset, u32 prio,
+			     bool aad_copy);
+
+/* IRQ handling functions */
+void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt);
+void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx);
+void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt);
+void spacc_irq_stat_disable(struct spacc_device *spacc);
+void spacc_irq_stat_wd_enable(struct spacc_device *spacc);
+void spacc_irq_stat_wd_disable(struct spacc_device *spacc);
+void spacc_irq_glbl_enable(struct spacc_device *spacc);
+void spacc_irq_glbl_disable(struct spacc_device *spacc);
+u32 spacc_process_irq(struct spacc_device *spacc);
+void spacc_set_wd_count(struct spacc_device *spacc, u32 val);
+irqreturn_t spacc_irq_handler(int irq, void *dev);
+
+int spacc_sgs_to_ddt(struct device *dev,
+		     struct scatterlist *sg1, int len1, int *ents1,
+		     struct scatterlist *sg2, int len2, int *ents2,
+		     struct scatterlist *sg3, int len3, int *ents3,
+		     struct pdu_ddt *ddt, int dma_direction);
+
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction);
+
+/* context Manager */
+void spacc_ctx_init_all(struct spacc_device *spacc);
+
+/* SPAcc specific manipulation of context memory */
+int spacc_write_context(struct spacc_device *spacc, int job_idx, int op,
+			const unsigned char *key, int ksz,
+			const unsigned char *iv, int ivsz);
+
+int spacc_read_context(struct spacc_device *spacc, int job_idx, int op,
+		       unsigned char *key, int ksz, unsigned char *iv,
+		       int ivsz);
+
+/* job Manager */
+void spacc_job_init_all(struct spacc_device *spacc);
+int  spacc_job_request(struct spacc_device *dev, int job_idx);
+int  spacc_job_release(struct spacc_device *dev, int job_idx);
+
+/* helper functions */
+struct spacc_ctx *spacc_context_lookup_by_job(struct spacc_device *spacc,
+					      int job_idx);
+int spacc_is_mode_keysize_supported(struct spacc_device *spacc, int mode,
+				    int keysize, int keysz_index);
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key,
+			   int keylen, unsigned char *xcbc_out);
+
+int  spacc_process_jb(struct spacc_device *spacc, unsigned long *lock_flag);
+void spacc_remove(struct platform_device *pdev);
+int  spacc_static_config(struct spacc_device *spacc);
+int  spacc_autodetect(struct spacc_device *spacc);
+void spacc_pop_jobs(struct work_struct *work);
+void spacc_fini(struct spacc_device *spacc);
+int  spacc_init(void __iomem *baseaddr, struct spacc_device *spacc,
+		struct pdu_info *info, struct device *dev);
+int  spacc_pop_packets(struct spacc_device *spacc, int *num_popped);
+void spacc_set_priority(struct spacc_device *spacc, int priority);
+
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
new file mode 100644
index 0000000000000..af95be0a8ebc1
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/platform_device.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <crypto/engine.h>
+#include "spacc_device.h"
+
+static void spacc_cmd_process(struct spacc_device *spacc, int x)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
+
+	if (!work_pending(&priv->pop_jobs))
+		queue_work(priv->spacc_wq, &priv->pop_jobs);
+}
+
+static void spacc_stat_process(struct spacc_device *spacc)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
+
+	if (!work_pending(&priv->pop_jobs))
+		queue_work(priv->spacc_wq, &priv->pop_jobs);
+}
+
+static int spacc_init_device(struct platform_device *pdev)
+{
+	void __iomem *baseaddr;
+	struct pdu_info   info;
+	struct spacc_priv *priv;
+	int err = 0;
+	int ret = 0;
+	int oldmode;
+	int irq_num;
+	int irq_ret;
+	const u64 oldtimer = SPACC_OLD_TIMER;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err) {
+		dev_err(&pdev->dev, "No usable 32-bit DMA configuration\n");
+		return err;
+	}
+
+	/*
+	 * Each DDT fragment must be <= 64KB and must not straddle a 64KB
+	 * boundary. Declare these limits so that IOMMU/swiotlb mappings honour
+	 * them. On a dma-direct system they are advisory (an already-contiguous
+	 * mapping is not re-split), but the 64KB message cap together with
+	 * natural buffer alignment keeps every fragment inside a single 64KB
+	 * block in practice.
+	 */
+	dma_set_max_seg_size(&pdev->dev, SPACC_DMA_BOUNDARY);
+	dma_set_seg_boundary(&pdev->dev, SPACC_DMA_BOUNDARY - 1);
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	/*
+	 * Set drvdata before pdu_mem_init(): DDT DMA pools are now kept
+	 * per-device in priv (see spacc_core.h) instead of file-scope
+	 * globals, and pdu_mem_init() resolves priv via dev_get_drvdata(),
+	 * so drvdata must already be wired up by this point.
+	 */
+	priv->spacc.dptr = &pdev->dev;
+	platform_set_drvdata(pdev, priv);
+
+	/* initialize DDT DMA pools based on this device's resources */
+	if (pdu_mem_init(&pdev->dev)) {
+		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
+		return -ENOMEM;
+	}
+
+	baseaddr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(baseaddr)) {
+		dev_err(&pdev->dev, "Unable to map iomem\n");
+		err = PTR_ERR(baseaddr);
+		goto free_ddt_mem_pool;
+	}
+
+	pdu_get_version(baseaddr, &info);
+
+	ret = spacc_init(baseaddr, &priv->spacc, &info, &pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize SPAcc device\n");
+		err = ret;
+		goto free_ddt_mem_pool;
+	}
+
+	priv->spacc.config.oldtimer = oldtimer;
+
+	priv->spacc.config.timer = (u64)SPACC_INTERNAL_COUNTER;
+	dev_dbg(&pdev->dev, "SPAcc internal counter set to: %llu\n",
+		priv->spacc.config.timer);
+
+	priv->spacc.config.priority = SPACC_VSPACC_PRIORITY;
+	dev_dbg(&pdev->dev, "VSPACC priority : %u\n",
+		priv->spacc.config.priority);
+
+	/* Set the priority for this virtual SPAcc instance */
+	spacc_set_priority(&priv->spacc, priv->spacc.config.priority);
+
+	/* Initialize crypto engine */
+	priv->engine = crypto_engine_alloc_init(&pdev->dev, true);
+	if (!priv->engine) {
+		dev_err(&pdev->dev, "Could not allocate crypto engine\n");
+		err = -ENOMEM;
+		goto free_spacc_ctx;
+	}
+
+	err = crypto_engine_start(priv->engine);
+	if (err) {
+		dev_err(&pdev->dev, "Could not start crypto engine\n");
+		goto free_engine;
+	}
+
+	priv->spacc_wq = alloc_workqueue("spacc_workqueue", WQ_UNBOUND, 0);
+	if (!priv->spacc_wq) {
+		err = -ENOMEM;
+		goto free_engine;
+	}
+
+	INIT_WORK(&priv->pop_jobs, spacc_pop_jobs);
+
+	atomic_set(&priv->dma_ref_cnt, 0);
+	init_waitqueue_head(&priv->drain_wq);
+
+	spacc_irq_glbl_disable(&priv->spacc);
+
+	irq_num = platform_get_irq(pdev, 0);
+	if (irq_num < 0) {
+		err = irq_num;
+		goto free_spacc_workq;
+	}
+	priv->irq = irq_num;
+
+	/*
+	 * Maximum message length the engine will process, read per-part from
+	 * PROC_LEN (MSG_ADDR_WIDTH: 16KB..512KB). This bounds the whole
+	 * request; the separate 64KB fragment limit (CLUSTER_ADDR_WIDTH,
+	 * enforced via dma_set_seg_boundary()) bounds each DDT fragment, not
+	 * the message, so a large message is simply carried as multiple
+	 * fragments.
+	 */
+	priv->max_msg_len = priv->spacc.config.max_msg_size;
+
+	irq_ret = devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
+			     IRQF_SHARED, dev_name(&pdev->dev),
+			     &pdev->dev);
+	if (irq_ret) {
+		dev_err(&pdev->dev, "Failed to request IRQ : %d\n", irq_ret);
+		err = irq_ret;
+		goto free_spacc_workq;
+	}
+
+	priv->spacc.irq_cb_stat	= spacc_stat_process;
+	priv->spacc.irq_cb_cmdx	= spacc_cmd_process;
+	oldmode			= priv->spacc.op_mode;
+	priv->spacc.op_mode	= SPACC_OP_MODE_IRQ;
+
+	/* Enable STAT and CMD interrupts */
+	spacc_irq_stat_enable(&priv->spacc, 1);
+	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
+	spacc_irq_stat_wd_disable(&priv->spacc);
+	spacc_irq_glbl_enable(&priv->spacc);
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
+	err = spacc_autodetect(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto free_irq;
+	}
+#else
+	err = spacc_static_config(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto free_irq;
+	}
+#endif
+	priv->spacc.op_mode = oldmode;
+	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
+		priv->spacc.irq_cb_stat = spacc_stat_process;
+		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
+
+		/* Enable STAT and CMD interrupts */
+		spacc_irq_stat_enable(&priv->spacc, 1);
+		spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
+		spacc_irq_glbl_enable(&priv->spacc);
+	} else {
+		priv->spacc.irq_cb_stat = spacc_stat_process;
+		priv->spacc.irq_cb_stat_wd = spacc_stat_process;
+
+		spacc_irq_stat_enable(&priv->spacc,
+				      priv->spacc.config.ideal_stat_level);
+
+		/* Enable STAT and WD interrupts */
+		spacc_irq_cmdx_disable(&priv->spacc, 0);
+		spacc_irq_stat_wd_enable(&priv->spacc);
+		spacc_irq_glbl_enable(&priv->spacc);
+
+		/* enable the wd by setting the wd_timer = 100000 */
+		priv->spacc.config.wd_timer = priv->spacc.config.timer;
+		spacc_set_wd_count(&priv->spacc, priv->spacc.config.wd_timer);
+	}
+
+	if (priv->spacc.config.is_secure_port) {
+		u32 t;
+
+		/* secure port: preserve other bits, clear lock bit only */
+		t = readl(baseaddr + SPACC_REG_SECURE_CTRL);
+		t &= ~(1UL << 31);
+		writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
+	} else {
+		/* normal port: unlock device by default */
+		writel(0, baseaddr + SPACC_REG_SECURE_CTRL);
+	}
+
+	return 0;
+free_irq:
+	devm_free_irq(&pdev->dev, irq_num, &pdev->dev);
+free_spacc_workq:
+	destroy_workqueue(priv->spacc_wq);
+free_engine:
+	crypto_engine_exit(priv->engine);
+free_spacc_ctx:
+	spacc_fini(&priv->spacc);
+free_ddt_mem_pool:
+	pdu_mem_deinit(&pdev->dev);
+
+	return err;
+}
+
+static void spacc_unregister_algs(struct spacc_priv *priv)
+{
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	spacc_unregister_hash_algs(priv);
+#endif
+}
+
+static void spacc_crypto_remove(struct platform_device *pdev)
+{
+	struct spacc_priv *priv = platform_get_drvdata(pdev);
+	unsigned long flags;
+
+	/*
+	 * Set before anything else: sysfs unbind (unlike rmmod) has no
+	 * built-in wait for existing tfms to be freed, so a request can
+	 * reach spacc_hash_digest() at any point during this function.
+	 * This flag, checked under the same lock there, blocks any new
+	 * submission attempt from this point on.
+	 */
+	spin_lock_irqsave(&priv->spacc.lock, flags);
+	priv->removing = true;
+	spin_unlock_irqrestore(&priv->spacc.lock, flags);
+
+	/* Stop the crypto API from handing out any new tfms. */
+	spacc_unregister_algs(priv);
+
+	if (priv->engine)
+		crypto_engine_exit(priv->engine);
+
+	wait_event(priv->drain_wq, !atomic_read(&priv->dma_ref_cnt));
+
+	/* Nothing can dispatch new work past this point. */
+	spin_lock_irqsave(&priv->spacc.lock, flags);
+	spacc_irq_glbl_disable(&priv->spacc);
+	spin_unlock_irqrestore(&priv->spacc.lock, flags);
+
+	devm_free_irq(&pdev->dev, priv->irq, &pdev->dev);
+
+	if (priv->spacc_wq)
+		destroy_workqueue(priv->spacc_wq);
+
+	/* No job can still reference this pool past the drain above. */
+	dma_pool_destroy(priv->hash_pool);
+	priv->hash_pool = NULL;
+
+	spacc_remove(pdev);
+	platform_set_drvdata(pdev, NULL);
+}
+
+static int spacc_crypto_probe(struct platform_device *pdev)
+{
+	int rc = 0;
+
+	rc = spacc_init_device(pdev);
+	if (rc < 0)
+		return rc;
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	rc = spacc_probe_hashes(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+	return 0;
+err:
+	spacc_crypto_remove(pdev);
+
+	return rc;
+}
+
+static const struct of_device_id snps_spacc_id[] = {
+	{.compatible = "snps,nsimosci-hs-spacc" },
+	{ /* sentinel */        }
+};
+
+MODULE_DEVICE_TABLE(of, snps_spacc_id);
+
+static struct platform_driver spacc_driver = {
+	.probe  = spacc_crypto_probe,
+	.remove = spacc_crypto_remove,
+	.driver = {
+		.name  = "spacc",
+		.of_match_table = snps_spacc_id,
+	},
+};
+
+module_platform_driver(spacc_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Synopsys, Inc.");
+MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");
diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
new file mode 100644
index 0000000000000..38a8ae567fdbe
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.h
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_DEVICE_H_
+#define SPACC_DEVICE_H_
+
+#include <crypto/hash.h>
+#include <crypto/ctr.h>
+#include <crypto/skcipher.h>
+#include <crypto/internal/aead.h>
+#include <crypto/engine.h>
+#include <linux/of.h>
+#include "spacc_core.h"
+
+#define MODE_TAB_AEAD(_name, _ciph, _hash, _hashlen, _ivlen, _blocklen) \
+	.name = _name, .aead = { .ciph = _ciph, .hash = _hash }, \
+	.hashlen = _hashlen, .ivlen = _ivlen, .blocklen = _blocklen
+
+/* helper macros for initializing the hash/cipher tables */
+#define MODE_TAB_COMMON(_name, _id_name, _blocklen) \
+	.name = _name, .id = CRYPTO_MODE_##_id_name, .blocklen = _blocklen
+
+#define MODE_TAB_HASH(_name, _id_name, _hashlen, _blocklen) \
+	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
+	.hashlen = _hashlen, .testlen = _hashlen
+
+#define MODE_TAB_CIPH(_name, _id_name, _ivlen, _blocklen) \
+	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
+	.ivlen = _ivlen
+
+#define MODE_TAB_HASH_XCBC	0x8000
+
+#define SPACC_OLD_TIMER		100000
+#define SPACC_MAX_DIGEST_SIZE	64
+#define SPACC_MAX_KEY_SIZE	32
+#define SPACC_MAX_IV_SIZE	16
+
+#define SPACC_DMA_ALIGN			4
+#define SPACC_DMA_BOUNDARY		0x10000
+#define SPACC_TEST_DMA_BUFF_SIZE	256
+
+/* flag means the IV is computed from setkey and crypt */
+#define SPACC_MANGLE_IV_FLAG	0x8000
+
+/* we're doing a CTR mangle (for RFC3686/IPsec) */
+#define SPACC_MANGLE_IV_RFC3686	0x0100
+
+/* we're doing GCM */
+#define SPACC_MANGLE_IV_RFC4106	0x0200
+
+/* we're doing GMAC */
+#define SPACC_MANGLE_IV_RFC4543	0x0300
+
+/* we're doing CCM */
+#define SPACC_MANGLE_IV_RFC4309	0x0400
+
+/* we're doing SM4 GCM/CCM */
+#define SPACC_MANGLE_IV_RFC8998	0x0500
+
+#define CRYPTO_MODE_AES_CTR_RFC3686 (CRYPTO_MODE_AES_CTR \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC3686)
+#define CRYPTO_MODE_AES_GCM_RFC4106 (CRYPTO_MODE_AES_GCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4106)
+#define CRYPTO_MODE_AES_GCM_RFC4543 (CRYPTO_MODE_AES_GCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4543)
+#define CRYPTO_MODE_AES_CCM_RFC4309 (CRYPTO_MODE_AES_CCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4309)
+#define CRYPTO_MODE_SM4_GCM_RFC8998 (CRYPTO_MODE_SM4_GCM)
+#define CRYPTO_MODE_SM4_CCM_RFC8998 (CRYPTO_MODE_SM4_CCM)
+
+struct spacc_crypto_ctx {
+	struct device *dev;
+	int handle;
+	struct mutex lock;
+
+	/*
+	 * Indicates that the H/W context has been setup and can be used for
+	 * crypto; otherwise, the software fallback will be used.
+	 */
+	bool ctx_valid;
+
+	/* HW hash/MAC key material (staged into the SPAcc context) */
+	u8 ipad[128]           __aligned(sizeof(u32));
+	u8 digest_ctx_buf[128] __aligned(sizeof(u32));
+
+	/*
+	 * tmp_buffer is mapped directly for DMA on zero-length requests.
+	 * Must be cacheline-aligned to prevent cache maintenance operations
+	 * from corrupting adjacent fields on non-coherent architectures.
+	 */
+	u8 tmp_buffer[128] ____cacheline_aligned;
+
+	/* save keylen from setkey */
+	unsigned int keylen;
+	struct scatterlist *tmp_sgl;
+};
+
+struct spacc_crypto_reqctx {
+	struct pdu_ddt src, dst;
+	void *digest_buf;
+	dma_addr_t digest_dma;
+	int src_nents, total_nents;
+	int single_shot;
+	u8 state_buffer[HASH_MAX_STATESIZE + 16] __aligned(8);
+
+	struct ahash_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct ahash_request       *req;
+		struct spacc_device        *spacc;
+	} acb;
+};
+
+struct mode_tab {
+	char name[128];
+	int valid;
+
+	/* mode ID used in hash/cipher mode but not aead */
+	int id;
+
+	/* ciph/hash mode used in aead */
+	struct {
+		int ciph, hash;
+	} aead;
+
+	unsigned int hashlen, ivlen, blocklen, keylen[3];
+	unsigned int keylen_mask, testlen;
+	unsigned int chunksize, walksize, min_keysize, max_keysize;
+
+	union {
+		unsigned char hash_test[SPACC_MAX_DIGEST_SIZE];
+		unsigned char ciph_test[3][2 * SPACC_MAX_IV_SIZE];
+	};
+};
+
+struct spacc_alg {
+	struct mode_tab *mode;
+	unsigned int keylen_mask;
+
+	struct device *dev;
+
+	struct list_head list;
+	struct crypto_alg *calg;
+	struct crypto_tfm *tfm;
+
+	/*
+	 * Kept as a union so salg->alg.hash resolves unchanged; the aead and
+	 * skcipher arms belong to the later cipher/AEAD series and are not
+	 * part of this hash-only driver.
+	 */
+	union {
+		struct ahash_engine_alg hash;
+	} alg;
+};
+
+struct spacc_completion {
+	unsigned int wait_done;
+	struct completion spacc_wait_complete;
+	struct list_head list;
+};
+
+static inline const struct spacc_alg *spacc_tfm_ahash(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH) {
+		return container_of(calg, struct spacc_alg,
+				    alg.hash.base.halg.base);
+	}
+
+	return NULL;
+}
+
+int spacc_probe_hashes(struct platform_device *spacc_pdev);
+int spacc_unregister_hash_algs(struct spacc_priv *priv);
+
+irqreturn_t spacc_irq_handler(int irq, void *dev);
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.c b/drivers/crypto/dwc-spacc/spacc_hal.c
new file mode 100644
index 0000000000000..7973bcdf4be1b
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.c
@@ -0,0 +1,349 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include "spacc_hal.h"
+#include "spacc_core.h"
+#include "spacc_device.h"
+#include <linux/unaligned.h>
+
+#define PDU_REG_SPACC_VERSION		0x00180UL
+#define PDU_REG_SPACC_CONFIG		0x00184UL
+#define PDU_REG_SPACC_CONFIG2		0x00190UL
+#define PDU_REG_SPACC_IV_OFFSET		0x00040UL
+#define PDU_REG_PDU_CONFIG		0x00188UL
+#define PDU_REG_SECURE_LOCK		0x001C0UL
+#define SPACC_IV_IMPORT_PROBE_BIT	0x80000000UL
+
+#define DDT_MAX_ENTRIES		((PDU_MAX_DDT + 1) * 8)
+#define DDT_16_ENTRIES		((16 + 1) * 8)
+#define DDT_4_ENTRIES		((4 + 1) * 8)
+
+int pdu_get_version(void __iomem *dev, struct pdu_info *inf)
+{
+	unsigned long reg_val;
+
+	if (!inf)
+		return -EINVAL;
+
+	memset(inf, 0, sizeof(*inf));
+	reg_val = readl(dev + PDU_REG_SPACC_VERSION);
+
+	/*
+	 * Read the SPAcc version block; this tells us the revision,
+	 * project, and a few other feature bits
+	 * layout for v6.5+
+	 */
+	inf->spacc_version = (struct spacc_version_block) {
+		.minor      = SPACC_ID_MINOR(reg_val),
+		.major      = SPACC_ID_MAJOR(reg_val),
+		.version    = (SPACC_ID_MAJOR(reg_val) << 4) |
+			       SPACC_ID_MINOR(reg_val),
+		.qos        = SPACC_ID_QOS(reg_val),
+		.is_spacc   = SPACC_ID_TYPE(reg_val) == SPACC_TYPE_SPACCQOS,
+		.is_pdu     = SPACC_ID_TYPE(reg_val) == SPACC_TYPE_PDU,
+		.aux        = SPACC_ID_AUX(reg_val),
+		.vspacc_id  = SPACC_ID_VIDX(reg_val),
+		.partial    = SPACC_ID_PARTIAL(reg_val),
+		.project    = SPACC_ID_PROJECT(reg_val),
+	};
+
+	/* try to autodetect */
+	writel(SPACC_IV_IMPORT_PROBE_BIT, dev + PDU_REG_SPACC_IV_OFFSET);
+
+	if (readl(dev + PDU_REG_SPACC_IV_OFFSET) == SPACC_IV_IMPORT_PROBE_BIT)
+		inf->spacc_version.ivimport = 1;
+	else
+		inf->spacc_version.ivimport = 0;
+
+	/*
+	 * Read the SPAcc config block (v6.5+) which tells us how many
+	 * contexts there are and context page sizes
+	 * this register is only available in v6.5 and up
+	 */
+	reg_val = readl(dev + PDU_REG_SPACC_CONFIG);
+	inf->spacc_config = (struct spacc_config_block) {
+				SPACC_CFG_CTX_CNT(reg_val),
+				SPACC_CFG_VSPACC_CNT(reg_val),
+				SPACC_CFG_CIPH_CTX_SZ(reg_val),
+				SPACC_CFG_HASH_CTX_SZ(reg_val),
+				SPACC_CFG_DMA_TYPE(reg_val),
+				0, 0, 0, 0 };
+
+	/* CONFIG2 only present in v6.5+ cores */
+	reg_val = readl(dev + PDU_REG_SPACC_CONFIG2);
+	if (inf->spacc_version.qos) {
+		inf->spacc_config.cmd0_fifo_depth =
+				SPACC_CFG_CMD0_FIFO_QOS(reg_val);
+		inf->spacc_config.cmd1_fifo_depth =
+				SPACC_CFG_CMD1_FIFO(reg_val);
+		inf->spacc_config.cmd2_fifo_depth =
+				SPACC_CFG_CMD2_FIFO(reg_val);
+		inf->spacc_config.stat_fifo_depth =
+				SPACC_CFG_STAT_FIFO_QOS(reg_val);
+	} else {
+		inf->spacc_config.cmd0_fifo_depth =
+				SPACC_CFG_CMD0_FIFO(reg_val);
+		inf->spacc_config.stat_fifo_depth =
+				SPACC_CFG_STAT_FIFO(reg_val);
+	}
+
+	/* only read PDU config if it's actually a PDU engine */
+	if (inf->spacc_version.is_pdu) {
+		reg_val = readl(dev + PDU_REG_PDU_CONFIG);
+		inf->pdu_config = (struct pdu_config_block) {
+				SPACC_PDU_CFG_MINOR(reg_val),
+				SPACC_PDU_CFG_MAJOR(reg_val)};
+
+		/* unlock all cores by default */
+		writel(0, dev + PDU_REG_SECURE_LOCK);
+	}
+
+	return 0;
+}
+
+void pdu_to_dev(void __iomem *addr_, u32 *src, unsigned long nword)
+{
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		writel(*src++, addr);
+		addr += 4;
+	}
+}
+
+void pdu_from_dev(u32 *dst, void __iomem *addr_, unsigned long nword)
+{
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		*dst++ = readl(addr);
+		addr += 4;
+	}
+}
+
+/*
+ * Context key staging to and from the SPAcc registers.
+ *
+ * This driver supports little-endian SPAcc integrations only. The IP can
+ * be synthesized with a big-endian register interface but that configuration
+ * is not supported here and is not detected.
+ *
+ * src/dst are plain byte buffers holding key material in the order the
+ * SPAcc expects to see it and may be unaligned hence using
+ * get_unaligned_le32()/put_unaligned_le32() rather than a u32 cast and
+ * a direct dereference.
+ */
+void pdu_to_dev_s(void __iomem *addr, const unsigned char *src,
+		  unsigned long nword)
+{
+	while (nword--) {
+		writel(get_unaligned_le32(src), addr);
+		src += 4;
+		addr += 4;
+	}
+}
+
+void pdu_from_dev_s(unsigned char *dst, void __iomem *addr,
+		    unsigned long nword)
+{
+	while (nword--) {
+		put_unaligned_le32(readl(addr), dst);
+		addr += 4;
+		dst += 4;
+	}
+}
+
+void pdu_io_cached_write(struct device *dev, void __iomem *addr,
+			 u32 val, u32 *cache)
+{
+	if (*cache == val) {
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+
+		dev_dbg(dev, "pdu: write %.8x -> %p (cached)\n", val, addr);
+#endif
+		return;
+	}
+
+	*cache = val;
+	writel(val, addr);
+}
+
+/* platform specific DDT routines */
+
+/*
+ * DDT DMA pools are part of per-device in struct spacc_priv (spacc_core.h).
+ * A single global pool set previously gets allocated against whichever
+ * device happened to probe first. Every other instance's DMA then run through
+ * an IOMMU domain that isn't its own and removing that first device destroys
+ * the pools out from under every other still-active instance.
+ * dev_get_drvdata() recovers the right instance's pools from any struct device
+ * belonging to this driver.
+ *
+ * Create a DMA pool for DDT entries, this should help from splitting
+ * pages for DDTs which by default are 520 bytes long otherwise it would
+ * waste 3576 bytes per DDT allocated.
+ * It also maintain a smaller table of 4 entries common for simple jobs
+ * which uses 480 fewer bytes of DMA memory and for good measure another
+ * table for 16 entries saving 384 bytes
+ */
+int pdu_mem_init(struct device *device)
+{
+	struct spacc_priv *priv = dev_get_drvdata(device);
+
+	if (priv->ddt_pool)
+		return 0; /* already setup for this device */
+
+	/* max of 64 DDT entries */
+	priv->ddt_pool = dma_pool_create("spaccddt", device, DDT_MAX_ENTRIES,
+					 8, SPACC_DMA_BOUNDARY);
+
+	if (!priv->ddt_pool)
+		return -ENOSPC;
+
+#if PDU_MAX_DDT > 16
+	/* max of 16 DDT entries */
+	priv->ddt16_pool = dma_pool_create("spaccddt16", device, DDT_16_ENTRIES,
+					   8, SPACC_DMA_BOUNDARY);
+	if (!priv->ddt16_pool) {
+		dma_pool_destroy(priv->ddt_pool);
+		priv->ddt_pool = NULL;
+		return -ENOSPC;
+	}
+#else
+	priv->ddt16_pool = priv->ddt_pool;
+#endif
+	/* max of 4 DDT entries */
+	priv->ddt4_pool = dma_pool_create("spaccddt4", device, DDT_4_ENTRIES,
+					  8, SPACC_DMA_BOUNDARY);
+	if (!priv->ddt4_pool) {
+		dma_pool_destroy(priv->ddt_pool);
+		priv->ddt_pool = NULL;
+#if PDU_MAX_DDT > 16
+		dma_pool_destroy(priv->ddt16_pool);
+#endif
+		priv->ddt16_pool = NULL;
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+/* Destroy this device's pools */
+void pdu_mem_deinit(struct device *device)
+{
+	struct spacc_priv *priv = dev_get_drvdata(device);
+
+	if (!priv->ddt_pool)
+		return; /* never set up, or already torn down */
+
+	dma_pool_destroy(priv->ddt_pool);
+
+#if PDU_MAX_DDT > 16
+	dma_pool_destroy(priv->ddt16_pool);
+#endif
+	dma_pool_destroy(priv->ddt4_pool);
+
+	priv->ddt_pool   = NULL;
+	priv->ddt16_pool = NULL;
+	priv->ddt4_pool  = NULL;
+}
+
+int pdu_ddt_init(struct device *dev, struct pdu_ddt *ddt, unsigned long limit)
+{
+	struct spacc_priv *priv = dev_get_drvdata(dev);
+	/*
+	 * Set the MSB if we want to use an ATOMIC
+	 * allocation required for top half processing
+	 */
+	int flag = (limit & 0x80000000);
+
+	limit &= 0x7FFFFFFF;
+	if (limit + 1 >= SIZE_MAX / 8) {
+		/* too big to even compute DDT size */
+		return -EINVAL;
+	} else if (limit > PDU_MAX_DDT) {
+		size_t len = 8 * ((size_t)limit + 1);
+
+		ddt->virt = dma_alloc_coherent(dev, len, &ddt->phys,
+					       flag ? GFP_ATOMIC : GFP_KERNEL);
+	} else if (limit > 16) {
+		ddt->virt = dma_pool_alloc(priv->ddt_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else if (limit > 4) {
+		ddt->virt = dma_pool_alloc(priv->ddt16_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else {
+		ddt->virt = dma_pool_alloc(priv->ddt4_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	}
+
+	ddt->dev	= dev;
+	ddt->idx	= 0;
+	ddt->len	= 0;
+	ddt->limit	= limit;
+
+	if (!ddt->virt)
+		return -EINVAL;
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+
+	dev_dbg(dev, "   DDT[%.8lx]: allocated %lu fragments\n",
+			(unsigned long)ddt->phys, limit);
+#endif
+	return 0;
+}
+
+int pdu_ddt_add(struct device *dev, struct pdu_ddt *ddt, dma_addr_t phys,
+		unsigned long size)
+{
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+
+	dev_dbg(dev, "   DDT[%.8lx]: 0x%.8lx size %lu\n",
+			(unsigned long)ddt->phys,
+			(unsigned long)phys, size);
+#endif
+
+	if (ddt->idx == ddt->limit)
+		return -EINVAL;
+
+	/*
+	 * DDT descriptor layout assumes a little-endian SPAcc integration
+	 *  : pointer word first, length word second.
+	 * The big-endian build reverses this order and is not supported.
+	 */
+	ddt->virt[ddt->idx * 2 + 0] = cpu_to_le32((u32)phys);
+	ddt->virt[ddt->idx * 2 + 1] = cpu_to_le32(size);
+	ddt->virt[ddt->idx * 2 + 2] = 0;
+	ddt->virt[ddt->idx * 2 + 3] = 0;
+
+	ddt->len += size;
+	++(ddt->idx);
+
+	return 0;
+}
+
+int pdu_ddt_free(struct pdu_ddt *ddt)
+{
+	struct spacc_priv *priv;
+
+	if (ddt->virt) {
+		priv = dev_get_drvdata(ddt->dev);
+
+		if (ddt->limit > PDU_MAX_DDT) {
+			size_t len = 8 * ((size_t)ddt->limit + 1);
+
+			dma_free_coherent(ddt->dev, len, ddt->virt,
+					  ddt->phys);
+		} else if (ddt->limit > 16) {
+			dma_pool_free(priv->ddt_pool, ddt->virt, ddt->phys);
+		} else if (ddt->limit > 4) {
+			dma_pool_free(priv->ddt16_pool, ddt->virt, ddt->phys);
+		} else {
+			dma_pool_free(priv->ddt4_pool, ddt->virt, ddt->phys);
+		}
+
+		ddt->virt = NULL;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.h b/drivers/crypto/dwc-spacc/spacc_hal.h
new file mode 100644
index 0000000000000..5a5ea9a3324eb
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_HAL_H
+#define SPACC_HAL_H
+
+/* maximum number of DDT entries allowed */
+#ifndef PDU_MAX_DDT
+#define PDU_MAX_DDT		64
+#endif
+
+/* platform Generic */
+#define PDU_IRQ_EN_GLBL		BIT(31)
+#define PDU_IRQ_EN_VSPACC(x)	(1UL << (x))
+#define PDU_IRQ_EN_RNG		BIT(16)
+
+#ifndef SPACC_ID_MINOR
+	#define SPACC_ID_MINOR(x)		((x)         & 0x0F)
+	#define SPACC_ID_MAJOR(x)		(((x) >>  4) & 0x0F)
+	#define SPACC_ID_QOS(x)			(((x) >>  8) & 0x01)
+	#define SPACC_ID_TYPE(x)		(((x) >>  9) & 0x03)
+	#define SPACC_ID_AUX(x)			(((x) >> 11) & 0x01)
+	#define SPACC_ID_VIDX(x)		(((x) >> 12) & 0x07)
+	#define SPACC_ID_PARTIAL(x)		(((x) >> 15) & 0x01)
+	#define SPACC_ID_PROJECT(x)		((x) >> 16)
+
+	#define SPACC_TYPE_SPACCQOS		0
+	#define SPACC_TYPE_PDU			1
+
+	#define SPACC_CFG_CTX_CNT(x)		((x) & 0x7F)
+	#define SPACC_CFG_RC4_CTX_CNT(x)	(((x) >>  8) & 0x7F)
+	#define SPACC_CFG_VSPACC_CNT(x)		(((x) >> 16) & 0x0F)
+	#define SPACC_CFG_CIPH_CTX_SZ(x)	(((x) >> 20) & 0x07)
+	#define SPACC_CFG_HASH_CTX_SZ(x)	(((x) >> 24) & 0x0F)
+	#define SPACC_CFG_DMA_TYPE(x)		(((x) >> 28) & 0x03)
+
+	#define SPACC_CFG_CMD0_FIFO_QOS(x)	(((x) >>  0) & 0x7F)
+	#define SPACC_CFG_CMD0_FIFO(x)		(((x) >>  0) & 0x1FF)
+	#define SPACC_CFG_CMD1_FIFO(x)		(((x) >>  8) & 0x7F)
+	#define SPACC_CFG_CMD2_FIFO(x)		(((x) >> 16) & 0x7F)
+	#define SPACC_CFG_STAT_FIFO_QOS(x)	(((x) >> 24) & 0x7F)
+	#define SPACC_CFG_STAT_FIFO(x)		(((x) >> 16) & 0x1FF)
+
+	#define SPACC_PDU_CFG_MINOR(x)		((x) & 0x0F)
+	#define SPACC_PDU_CFG_MAJOR(x)		(((x) >> 4)  & 0x0F)
+
+	#define PDU_SECURE_LOCK_SPACC(x)	(x)
+	#define PDU_SECURE_LOCK_CFG		BIT(30)
+	#define PDU_SECURE_LOCK_GLBL		BIT(31)
+#endif /* SPACC_ID_MINOR */
+
+struct spacc_version_block {
+	unsigned int minor,
+		     major,
+		     version,
+		     qos,
+		     is_spacc,
+		     is_pdu,
+		     aux,
+		     vspacc_id,
+		     partial,
+		     project,
+		     ivimport;
+};
+
+struct spacc_config_block {
+	unsigned int num_ctx,
+		     num_vspacc,
+		     ciph_ctx_page_size,
+		     hash_ctx_page_size,
+		     dma_type,
+		     cmd0_fifo_depth,
+		     cmd1_fifo_depth,
+		     cmd2_fifo_depth,
+		     stat_fifo_depth;
+};
+
+struct pdu_config_block {
+	unsigned int minor,
+		     major;
+};
+
+struct pdu_info {
+	u32    clockrate;
+	struct spacc_version_block spacc_version;
+	struct spacc_config_block  spacc_config;
+	struct pdu_config_block    pdu_config;
+};
+
+struct pdu_ddt {
+	dma_addr_t phys;
+	__le32 *virt;
+	struct device *dev;
+	unsigned long idx, limit, len;
+};
+
+void pdu_io_cached_write(struct device *dev, void __iomem *addr,
+			 u32 val, u32 *cache);
+void pdu_to_dev(void  __iomem *addr, u32 *src, unsigned long nword);
+void pdu_from_dev(u32 *dst, void __iomem *addr, unsigned long nword);
+
+void pdu_from_dev_s(unsigned char *dst, void __iomem *addr,
+		    unsigned long nword);
+void pdu_to_dev_s(void __iomem *addr, const unsigned char *src,
+		  unsigned long nword);
+
+int  pdu_mem_init(struct device *device);
+void pdu_mem_deinit(struct device *device);
+int  pdu_ddt_init(struct device *dev, struct pdu_ddt *ddt, unsigned long limit);
+int  pdu_ddt_add(struct device *dev, struct pdu_ddt *ddt, dma_addr_t phys,
+		unsigned long size);
+int  pdu_ddt_free(struct pdu_ddt *ddt);
+int  pdu_get_version(void __iomem *dev, struct pdu_info *inf);
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_interrupt.c b/drivers/crypto/dwc-spacc/spacc_interrupt.c
new file mode 100644
index 0000000000000..68dd049a5f65a
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_interrupt.c
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/interrupt.h>
+#include <linux/minmax.h>
+#include <crypto/scatterwalk.h>
+#include <linux/platform_device.h>
+#include "spacc_core.h"
+
+static inline u32 _spacc_get_stat_cnt(struct spacc_device *spacc)
+{
+	u32 fifo;
+
+	if (spacc->config.is_qos)
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET_QOS(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+	else
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+	return fifo;
+}
+
+/* Map a SPAcc hardware status code to the errno reported for the job. */
+static int spacc_status_to_err(struct spacc_device *spacc, u32 spacc_errcode)
+{
+	switch (spacc_errcode) {
+	case SPACC_OK:
+		return 0;
+	case SPACC_ICVFAIL:
+		return -EBADMSG;
+	case SPACC_MEMERR:
+	case SPACC_BLOCKERR:
+		return -EINVAL;
+	case SPACC_SECERR:
+		return -EIO;
+	default:
+		dev_err(spacc->dptr, "Invalid SPAcc Error\n");
+		return -EIO;
+	}
+}
+
+/*
+ * Pop one entry from the STATUS FIFO and dispatch its completion.
+ *
+ * Called with spacc->lock held. When the completed job has a callback,
+ * the lock is dropped across that callback and re-acquired before return,
+ * so the caller must re-sample any hardware state afterwards. Returns true
+ * and stores the job status in *job_ret when a live job was dispatched;
+ * false for a dropped/stale FIFO entry that maps to no live job (the FIFO
+ * slot is still consumed either way).
+ */
+static bool spacc_pop_one_job(struct spacc_device *spacc,
+			      unsigned long *lock_flag, int *job_ret)
+{
+	struct spacc_job *job;
+	u32 cmdstat, swid;
+	int ret;
+
+	/* write the pop register to get the next job */
+	writel(1, spacc->regmap + SPACC_REG_STAT_POP);
+	cmdstat = readl(spacc->regmap + SPACC_REG_STATUS);
+
+	swid = SPACC_STATUS_SW_ID_GET(cmdstat);
+
+	if (swid >= SPACC_MAX_JOBS) {
+		dev_warn(spacc->dptr, "out-of-range swid %u dropped\n", swid);
+		return false;
+	}
+	if (spacc->job_lookup[swid] == SPACC_JOB_IDX_UNUSED) {
+		dev_warn(spacc->dptr, "stale swid %u dropped\n", swid);
+		return false;
+	}
+
+	job = &spacc->job[spacc->job_lookup[swid]];
+
+	/*
+	 * Release the swid before running the callback so a duplicate/stale
+	 * STATUS entry for this swid is dropped on the next pass. A
+	 * HW-completed job is dispatched here exactly once; buffered jobs that
+	 * never reached HW are dispatched only by spacc_process_jb(). The two
+	 * sets are disjoint, so each job's cb runs once.
+	 */
+	spacc->job_lookup[swid] = SPACC_JOB_IDX_UNUSED;
+
+	ret = spacc_status_to_err(spacc, SPACC_GET_STATUS_RET_CODE(cmdstat));
+	job->job_err = ret;
+
+	if (spacc->autodetect) {
+		/* Pairs with smp_load_acquire() in the sync waiters. */
+		smp_store_release(&job->job_done, 1);
+		wake_up(&job->waitq);
+	}
+
+	if (job->cb) {
+		spacc_callback cb = job->cb;
+		void *cbdata = job->cbdata;
+
+		/*
+		 * Done touching the SPAcc hw: drop the lock across the job
+		 * callback and re-acquire it before returning to the caller.
+		 */
+		spin_unlock_irqrestore(&spacc->lock, *lock_flag);
+		cb(spacc, cbdata);
+		spin_lock_irqsave(&spacc->lock, *lock_flag);
+	} else if (!spacc->autodetect) {
+		/*
+		 * Pairs with smp_load_acquire() in the synchronous waiters
+		 * (autodetect, xcbc key computation).
+		 */
+		smp_store_release(&job->job_done, 1);
+		wake_up(&job->waitq);
+	}
+
+	*job_ret = ret;
+	return true;
+}
+
+static int spacc_pop_packets_ex(struct spacc_device *spacc, int *num_popped,
+				unsigned long *lock_flag)
+{
+	int jobs;
+	int ret = -EINPROGRESS;
+
+	*num_popped = 0;
+
+	/*
+	 * Re-sample the STATUS FIFO count on each outer pass: jobs can
+	 * complete while we process a batch (spacc_pop_one_job() drops the
+	 * lock across each callback), so keep draining until the FIFO reports
+	 * empty instead of servicing only the count seen on entry.
+	 */
+	while ((jobs = _spacc_get_stat_cnt(spacc))) {
+		while (jobs-- > 0) {
+			if (spacc_pop_one_job(spacc, lock_flag, &ret))
+				(*num_popped)++;
+		}
+	}
+
+	if (!*num_popped)
+		dev_dbg(spacc->dptr, "Failed to pop a single job\n");
+
+	spacc_process_jb(spacc, lock_flag);
+
+	/* reset the WD timer to the original value */
+	if (spacc->op_mode == SPACC_OP_MODE_WD) {
+		spacc->config.wd_timer = spacc->config.timer;
+		spacc_set_wd_count(spacc, spacc->config.wd_timer);
+	}
+
+	if (*num_popped && spacc->spacc_notify_jobs)
+		spacc->spacc_notify_jobs(spacc);
+
+	return ret;
+}
+
+int spacc_pop_packets(struct spacc_device *spacc, int *num_popped)
+{
+	int err = 0;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	err = spacc_pop_packets_ex(spacc, num_popped, &lock_flag);
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return err;
+}
+
+u32 spacc_process_irq(struct spacc_device *spacc)
+{
+	u32 irq_status;
+	int x, cmd_max;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	irq_status = readl(spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* clear interrupt pin and run registered callback */
+	if (irq_status & SPACC_IRQ_STAT_STAT) {
+		SPACC_IRQ_STAT_CLEAR_STAT(spacc);
+		if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+			spacc->config.fifo_cnt <<= 2;
+			spacc->config.fifo_cnt = min(spacc->config.fifo_cnt,
+					spacc->config.stat_fifo_depth);
+
+			/* update fifo count to allow more stats to pile up */
+			spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt);
+
+			/* re-enable CMD0 empty interrupt */
+			spacc_irq_cmdx_enable(spacc, 0, 0);
+		}
+
+		/* Re-enable the watchdog interrupt */
+		if (spacc->op_mode == SPACC_OP_MODE_IRQ &&
+				spacc->wd_cnt_limit) {
+			spacc_irq_stat_wd_enable(spacc);
+			spacc->wdcnt = 0;
+			spacc->op_mode = SPACC_OP_MODE_WD;
+			spacc->wd_cnt_limit = false;
+		}
+
+		if (spacc->irq_cb_stat)
+			spacc->irq_cb_stat(spacc);
+	}
+
+	/* watchdog IRQ */
+	if (spacc->op_mode == SPACC_OP_MODE_WD &&
+			irq_status & SPACC_IRQ_STAT_STAT_WD) {
+		if (++spacc->wdcnt == SPACC_WD_LIMIT) {
+			/*
+			 * This happens when you get too many IRQs that
+			 * go unanswered
+			 */
+			spacc_irq_stat_wd_disable(spacc);
+
+			/*
+			 * We set the STAT CNT to 1 so that every job
+			 * generates an IRQ now
+			 */
+			spacc_irq_stat_enable(spacc, 1);
+			spacc->op_mode = SPACC_OP_MODE_IRQ;
+			spacc->wd_cnt_limit = true;
+		} else if (spacc->config.wd_timer < (0xFFFFFFUL >> 4)) {
+			/*
+			 * If the timer isn't too high lets bump it up
+			 * a bit so as to give the IRQ a chance to
+			 * reply
+			 */
+			spacc->config.wd_timer <<= 4;
+			spacc_set_wd_count(spacc, spacc->config.wd_timer);
+		}
+
+		SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc);
+		if (spacc->irq_cb_stat_wd)
+			spacc->irq_cb_stat_wd(spacc);
+	}
+
+	if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+		cmd_max = (spacc->config.is_qos ? SPACC_CMDX_MAX_QOS :
+				SPACC_CMDX_MAX);
+		for (x = 0; x < cmd_max; x++) {
+			if (irq_status & SPACC_IRQ_STAT_CMDX(x)) {
+				spacc->config.fifo_cnt = 1;
+
+				/* disable CMD0 interrupt since STAT=1 */
+				spacc_irq_cmdx_disable(spacc, x);
+				spacc_irq_stat_enable(spacc,
+						spacc->config.fifo_cnt);
+
+				SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x);
+
+				/* run registered callback */
+				if (spacc->irq_cb_cmdx)
+					spacc->irq_cb_cmdx(spacc, x);
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return irq_status;
+}
+
+void spacc_set_wd_count(struct spacc_device *spacc, u32 val)
+{
+	writel(val, spacc->regmap + SPACC_REG_STAT_WD_CTRL);
+}
+
+/*
+ * cmdx and cmdx_cnt depend on HW config
+ * cmdx can be 0, 1 or 2
+ * cmdx_cnt must be 2^6 or less
+ */
+void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt)
+{
+	u32 reg_val;
+
+	/* read the reg, clear the bit range and set the new value */
+	reg_val = readl(spacc->regmap + SPACC_REG_IRQ_CTRL) &
+		(~SPACC_IRQ_CTRL_CMDX_CNT_MASK(cmdx));
+	reg_val |= SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt);
+
+	writel(reg_val | SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt),
+	       spacc->regmap + SPACC_REG_IRQ_CTRL);
+
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_CMD(cmdx),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+	       (~SPACC_IRQ_EN_CMD(cmdx)), spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt)
+{
+	u32 reg_val;
+
+	reg_val = readl(spacc->regmap + SPACC_REG_IRQ_CTRL);
+	if (spacc->config.is_qos) {
+		reg_val &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS);
+		reg_val |= SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(stat_cnt);
+	} else {
+		reg_val &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK);
+		reg_val |= SPACC_IRQ_CTRL_STAT_CNT_SET(stat_cnt);
+	}
+
+	writel(reg_val, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_STAT,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) & (~SPACC_IRQ_EN_STAT),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_STAT_WD,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+	       (~SPACC_IRQ_EN_STAT_WD), spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_GLBL,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) & (~SPACC_IRQ_EN_GLBL),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+/* Function to run callbacks in the IRQ handler */
+irqreturn_t spacc_irq_handler(int irq, void *dev)
+{
+	struct spacc_priv *priv = platform_get_drvdata(to_platform_device(dev));
+	struct spacc_device *spacc = &priv->spacc;
+
+	if (spacc->config.oldtimer != spacc->config.timer) {
+		spacc->config.wd_timer = spacc->config.timer;
+		spacc_set_wd_count(spacc, spacc->config.wd_timer);
+		spacc->config.oldtimer = spacc->config.timer;
+	}
+
+	/* check irq flags and process as required */
+	if (!spacc_process_irq(spacc))
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_manager.c b/drivers/crypto/dwc-spacc/spacc_manager.c
new file mode 100644
index 0000000000000..0ee40fa7678cf
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_manager.c
@@ -0,0 +1,661 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/minmax.h>
+#include <crypto/skcipher.h>
+#include <linux/vmalloc.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include "spacc_core.h"
+
+/* Prevent reading past the end of the buffer */
+static void spacc_read_from_buf(unsigned char *dst, unsigned char *src,
+				int off, int n, int buflen)
+{
+	if (!dst)
+		return;
+
+	while (n > 0 && (off < buflen)) {
+		*dst++ = src[off++];
+		--n;
+	}
+}
+
+static void spacc_write_to_buf(unsigned char *dst, const unsigned char *src,
+			       int off, int n, int buflen)
+{
+	if (!src)
+		return;
+
+	while (n > 0 && (off < buflen)) {
+		dst[off++] = *src++;
+		--n;
+	}
+}
+
+/*
+ * This is not meant to be called directly, it should be called
+ * from the job manager
+ */
+static int spacc_ctx_request(struct spacc_device *spacc,
+			     int ctx_id, int ncontig)
+{
+	int ret = 0;
+	int x, y, count;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (ctx_id < -1 || ctx_id >= spacc->config.num_ctx)
+		return -EINVAL;
+
+	if (ncontig < 1 || ncontig > spacc->config.num_ctx)
+		return -EINVAL;
+
+	/*
+	 * Look for contiguous contexts. Free contexts have a ref_cnt of 0.
+	 * If specific ctx_id is requested, test the ncontig
+	 * and then bump the ref_cnt
+	 */
+	if (ctx_id != -1) {
+		if ((&spacc->ctx[ctx_id])->ncontig != ncontig - 1)
+			ret = -1;
+		goto NO_FREE_CTX;
+	}
+
+	/*
+	 * Check to see if ncontig are free
+	 * loop over all available contexts to find the first
+	 * ncontig empty ones
+	 */
+	for (x = 0; x <= (spacc->config.num_ctx - ncontig); ) {
+		count = ncontig;
+		while (count) {
+			if ((&spacc->ctx[x + count - 1])->ref_cnt != 0) {
+				/*
+				 * Increment x to past failed count
+				 * location
+				 */
+				x += count;
+				break;
+			}
+			count--;
+		}
+
+		if (count != 0)
+			ret = -1;
+		else {
+			ctx_id = x;
+			ret = 0;
+			break;
+		}
+	}
+
+NO_FREE_CTX:
+	if (ret == 0) {
+		/* ctx_id is good so mark used */
+		for (y = 0; y < ncontig; y++)
+			(&spacc->ctx[ctx_id + y])->ref_cnt++;
+		(&spacc->ctx[ctx_id])->ncontig = ncontig - 1;
+	} else
+		ctx_id = -1;
+
+	return ctx_id;
+}
+
+static int spacc_ctx_release(struct spacc_device *spacc, int ctx_id)
+{
+	int y;
+	int ncontig;
+
+	if (ctx_id < 0 || ctx_id >= spacc->config.num_ctx)
+		return -EINVAL;
+
+	/* release the base context and contiguous block */
+	ncontig = (&spacc->ctx[ctx_id])->ncontig;
+
+	for (y = 0; y <= ncontig; y++) {
+		if ((&spacc->ctx[ctx_id + y])->ref_cnt > 0)
+			(&spacc->ctx[ctx_id + y])->ref_cnt--;
+	}
+
+	if ((&spacc->ctx[ctx_id])->ref_cnt == 0) {
+		(&spacc->ctx[ctx_id])->ncontig = 0;
+
+#ifdef CONFIG_CRYPTO_DEV_SPACC_SECURE_MODE
+		writel(ctx_id, spacc->regmap + SPACC_REG_SECURE_RELEASE);
+#endif
+
+		/* This will wake up a sleeping task, if any */
+		up(&spacc->ctx_sem);
+	}
+
+	return 0;
+}
+
+void spacc_job_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_job *job;
+
+	for (x = 0; x < (SPACC_MAX_JOBS); x++) {
+		job = &spacc->job[x];
+		memset(job, 0, sizeof(struct spacc_job));
+
+		job->job_swid	     = SPACC_JOB_IDX_UNUSED;
+		job->job_used	     = SPACC_JOB_IDX_UNUSED;
+		spacc->job_lookup[x] = SPACC_JOB_IDX_UNUSED;
+		init_waitqueue_head(&job->waitq);
+	}
+}
+
+/* Get a new job id and use a specific ctx_idx or -1 for a new one */
+int spacc_job_request(struct spacc_device *spacc, int ctx_idx)
+{
+	int x, ret = 0;
+	struct spacc_job *job;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -EINVAL;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	/* find the first available job id */
+	for (x = 0; x < SPACC_MAX_JOBS; x++) {
+		job = &spacc->job[x];
+		if (job->job_used == SPACC_JOB_IDX_UNUSED) {
+			job->job_used = x;
+			break;
+		}
+	}
+
+	if (x == SPACC_MAX_JOBS)
+		ret = -1;
+	else {
+		/* associate a single context to go with job */
+		ret = spacc_ctx_request(spacc, ctx_idx, 1);
+		if (ret != -1) {
+			job->ctx_idx = ret;
+			ret = x;
+		} else
+			job->job_used = SPACC_JOB_IDX_UNUSED;
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_job_release(struct spacc_device *spacc, int job_idx)
+{
+	int ret = 0;
+	struct spacc_job *job;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	job	      = &spacc->job[job_idx];
+
+	if (job->job_swid < SPACC_MAX_JOBS &&
+	    spacc->job_lookup[job->job_swid] == job_idx)
+		spacc->job_lookup[job->job_swid] = SPACC_JOB_IDX_UNUSED;
+
+	/* release context that goes with job */
+	ret		= spacc_ctx_release(spacc, job->ctx_idx);
+	job->ctx_idx	= SPACC_CTX_IDX_UNUSED;
+	job->job_used	= SPACC_JOB_IDX_UNUSED;
+
+	/* disable any callback */
+	job->cb		= NULL;
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+/* Return a context structure for a job idx or null if invalid */
+struct spacc_ctx *spacc_context_lookup_by_job(struct spacc_device *spacc,
+					      int job_idx)
+{
+	unsigned int ctx_idx;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return NULL;
+
+	ctx_idx = spacc->job[job_idx].ctx_idx;
+	if (ctx_idx >= spacc->config.num_ctx)
+		return NULL;
+
+	return &spacc->ctx[ctx_idx];
+}
+
+int spacc_process_jb(struct spacc_device *spacc, unsigned long *lock_flag)
+{
+	int tail;
+	int ret = 0;
+	struct spacc_job *job;
+
+	/* checks for jobs in the buffer */
+	while (spacc->jb_head != spacc->jb_tail) {
+		tail = spacc->jb_tail;
+
+		if (spacc->job_buffer[tail].active) {
+			ret = spacc_packet_enqueue_ddt_ex
+			      (spacc, 0, spacc->job_buffer[tail].job_idx,
+			       spacc->job_buffer[tail].src,
+			       spacc->job_buffer[tail].dst,
+			       spacc->job_buffer[tail].proc_sz,
+			       spacc->job_buffer[tail].aad_offset,
+			       spacc->job_buffer[tail].pre_aad_sz,
+			       spacc->job_buffer[tail].post_aad_sz,
+			       spacc->job_buffer[tail].iv_offset,
+			       spacc->job_buffer[tail].prio,
+			       spacc->job_buffer[tail].aad_copy, lock_flag);
+
+			if (ret == -EBUSY)
+				return -EBUSY;
+
+			spacc->job_buffer[tail].active = 0;
+			job = (ret != 0)
+			      ? &spacc->job[spacc->job_buffer[tail].job_idx]
+			      : NULL;
+
+			/*
+			 * Consume this slot and advance jb_tail before
+			 * dropping the lock for the callback, so the ring is
+			 * left consistent. A concurrent spacc_process_jb()
+			 * entering during job->cb() then sees this slot
+			 * already claimed and starts from the next one.
+			 * Advancing after re-acquiring the lock would skip
+			 * past whatever the other caller processed meanwhile,
+			 * stranding a live job.
+			 */
+			tail++;
+			if (tail == SPACC_MAX_JOB_BUFFERS)
+				tail = 0;
+			spacc->jb_tail = tail;
+
+			if (job) {
+				job->job_err = ret;
+
+				if (spacc->autodetect) {
+					/*
+					 * pairs with smp_load_acquire() in
+					 * spacc_check_modes().
+					 */
+					smp_store_release(&job->job_done, 1);
+					wake_up(&job->waitq);
+				} else if (job->cb) {
+					spacc_callback cb = job->cb;
+					void *cbdata = job->cbdata;
+
+					/*
+					 * jb_tail was advanced above and the
+					 * lock is about to be dropped, so this
+					 * job slot may be recycled while the
+					 * callback runs.
+					 */
+					spin_unlock_irqrestore(&spacc->lock,
+							       *lock_flag);
+					cb(spacc, cbdata);
+					spin_lock_irqsave(&spacc->lock,
+							  *lock_flag);
+				} else {
+					/*
+					 * pairs with smp_load_acquire() in
+					 * the waiters that open
+					 * a job without a callback.
+					 */
+					smp_store_release(&job->job_done, 1);
+					wake_up(&job->waitq);
+				}
+			}
+			continue;
+		}
+
+		/* inactive slot: just step over it */
+		tail++;
+		if (tail == SPACC_MAX_JOB_BUFFERS)
+			tail = 0;
+
+		spacc->jb_tail = tail;
+	}
+
+	return 0;
+}
+
+/* Write appropriate context data which depends on operation and mode */
+int spacc_write_context(struct spacc_device *spacc, int job_idx, int op,
+			const unsigned char *key, int ksz,
+			const unsigned char *iv, int ivsz)
+{
+	int buflen;
+	int ret = 0;
+	unsigned char buf[300] __aligned(sizeof(u32));
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	job = &spacc->job[job_idx];
+	ctx = spacc_context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx)
+		return -EIO;
+
+	switch (op) {
+	case SPACC_CRYPTO_OPERATION:
+		/*
+		 * Get page size and then read so we can do a
+		 * read-modify-write cycle
+		 */
+		buflen = min_t(size_t, sizeof(buf),
+			       spacc->config.ciph_page_size);
+
+		pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2);
+
+		switch (job->enc_mode) {
+		case CRYPTO_MODE_SM4_ECB:
+		case CRYPTO_MODE_SM4_CBC:
+		case CRYPTO_MODE_SM4_CFB:
+		case CRYPTO_MODE_SM4_OFB:
+		case CRYPTO_MODE_SM4_CTR:
+		case CRYPTO_MODE_SM4_CCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_SM4_CS1:
+		case CRYPTO_MODE_SM4_CS2:
+		case CRYPTO_MODE_SM4_CS3:
+		case CRYPTO_MODE_AES_ECB:
+		case CRYPTO_MODE_AES_CBC:
+		case CRYPTO_MODE_AES_CS1:
+		case CRYPTO_MODE_AES_CS2:
+		case CRYPTO_MODE_AES_CS3:
+		case CRYPTO_MODE_AES_CFB:
+		case CRYPTO_MODE_AES_OFB:
+		case CRYPTO_MODE_AES_CTR:
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_AES_GCM:
+			spacc_write_to_buf(buf, key, 0, ksz, buflen);
+			if (iv) {
+				unsigned char one[4] = { 0, 0, 0, 1 };
+				unsigned long enc1, enc2;
+
+				enc1 = CRYPTO_MODE_AES_GCM;
+				enc2 = CRYPTO_MODE_SM4_GCM;
+
+				spacc_write_to_buf(buf, iv, 32, ivsz, buflen);
+				if (ivsz == 12 &&
+				    (job->enc_mode ==  enc1 ||
+				     job->enc_mode == enc2))
+					spacc_write_to_buf(buf, one, 11 * 4, 4,
+							   buflen);
+			}
+			break;
+		case CRYPTO_MODE_SM4_F8:
+		case CRYPTO_MODE_AES_F8:
+			if (key) {
+				spacc_write_to_buf(buf, key + ksz, 0, ksz,
+						   buflen);
+				spacc_write_to_buf(buf, key, 48, ksz, buflen);
+			}
+			spacc_write_to_buf(buf, iv, 32,  16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_XTS:
+		case CRYPTO_MODE_AES_XTS:
+			if (key) {
+				spacc_write_to_buf(buf, key, 0,
+						   ksz >> 1, buflen);
+				spacc_write_to_buf(buf, key + (ksz >> 1), 48,
+						   ksz >> 1, buflen);
+				ksz = ksz >> 1;
+			}
+
+			spacc_write_to_buf(buf, iv, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_MULTI2_ECB:
+		case CRYPTO_MODE_MULTI2_CBC:
+		case CRYPTO_MODE_MULTI2_OFB:
+		case CRYPTO_MODE_MULTI2_CFB:
+			spacc_write_to_buf(buf, key, 0, ksz, buflen);
+			spacc_write_to_buf(buf, iv, 0x28, ivsz, buflen);
+			if (ivsz <= 8) {
+				/* default to 128 rounds */
+				unsigned char rounds[4] = { 0, 0, 0, 128};
+
+				spacc_write_to_buf(buf, rounds, 0x30, 4,
+						   buflen);
+			}
+			break;
+		case CRYPTO_MODE_3DES_CBC:
+		case CRYPTO_MODE_3DES_ECB:
+		case CRYPTO_MODE_DES_CBC:
+		case CRYPTO_MODE_DES_ECB:
+			spacc_write_to_buf(buf, iv, 0, 8, buflen);
+			spacc_write_to_buf(buf, key, 8, ksz, buflen);
+			break;
+		case CRYPTO_MODE_KASUMI_ECB:
+		case CRYPTO_MODE_KASUMI_F8:
+			spacc_write_to_buf(buf, iv, 16, 8, buflen);
+			spacc_write_to_buf(buf, key, 0, 16, buflen);
+			break;
+		case CRYPTO_MODE_SNOW3G_UEA2:
+		case CRYPTO_MODE_ZUC_UEA3:
+			spacc_write_to_buf(buf, key, 0, 32, buflen);
+			break;
+		case CRYPTO_MODE_CHACHA20_STREAM:
+		case CRYPTO_MODE_CHACHA20_POLY1305:
+			spacc_write_to_buf(buf, key, 0, ksz, buflen);
+			spacc_write_to_buf(buf, iv, 32, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_NULL:
+			break;
+		}
+
+		if (key) {
+			job->ckey_sz = SPACC_SET_CIPHER_KEY_SZ(ksz);
+			job->first_use = true;
+		}
+
+		pdu_to_dev_s(ctx->ciph_key, buf, buflen >> 2);
+		break;
+
+	case SPACC_HASH_OPERATION:
+		/*
+		 * Get page size and then read so we can do a
+		 * read-modify-write cycle
+		 */
+		buflen = min_t(size_t, sizeof(buf),
+			       spacc->config.hash_page_size);
+		pdu_from_dev_s(buf, ctx->hash_key, buflen >> 2);
+
+		switch (job->hash_mode) {
+		case CRYPTO_MODE_MAC_XCBC:
+		case CRYPTO_MODE_MAC_SM4_XCBC:
+			if (key) {
+				spacc_write_to_buf(buf, key + (ksz - 32),
+						32, 32, buflen);
+				spacc_write_to_buf(buf, key, 0, (ksz - 32),
+						buflen);
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz - 32);
+			}
+			break;
+		case CRYPTO_MODE_HASH_CRC32:
+		case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+		case CRYPTO_MODE_MAC_ZUC_UIA3:
+			if (key) {
+				spacc_write_to_buf(buf, key, 0, ksz, buflen);
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+			}
+			break;
+		case CRYPTO_MODE_MAC_POLY1305:
+			spacc_write_to_buf(buf, key, 0, ksz, buflen);
+			spacc_write_to_buf(buf, iv, 32, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_HASH_CSHAKE128:
+		case CRYPTO_MODE_HASH_CSHAKE256:
+			/* use "iv" and "key" to pass s-string & n-string */
+			spacc_write_to_buf(buf, iv, 0, ivsz, buflen);
+			spacc_write_to_buf(buf, key,
+				     spacc->config.string_size, ksz, buflen);
+			break;
+		case CRYPTO_MODE_MAC_KMAC128:
+		case CRYPTO_MODE_MAC_KMAC256:
+		case CRYPTO_MODE_MAC_KMACXOF128:
+		case CRYPTO_MODE_MAC_KMACXOF256:
+			/* use "iv" and "key" to pass s-string & key */
+			spacc_write_to_buf(buf, iv, 0, ivsz, buflen);
+			spacc_write_to_buf(buf, key,
+					   spacc->config.string_size, ksz,
+					   buflen);
+			job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+			break;
+		default:
+			if (key) {
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+				spacc_write_to_buf(buf, key, 0, ksz, buflen);
+			}
+		}
+		pdu_to_dev_s(ctx->hash_key, buf, buflen >> 2);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int spacc_read_context(struct spacc_device *spacc, int job_idx,
+		       int op, unsigned char *key, int ksz,
+		       unsigned char *iv, int ivsz)
+{
+	int buflen;
+	int ret = 0;
+	unsigned char buf[300] __aligned(sizeof(u32));
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -EINVAL;
+
+	job = &spacc->job[job_idx];
+	ctx = spacc_context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx)
+		return  -EIO;
+
+	switch (op) {
+	case SPACC_CRYPTO_OPERATION:
+		buflen = min_t(size_t, sizeof(buf),
+			       spacc->config.ciph_page_size);
+		pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2);
+
+		switch (job->enc_mode) {
+		case CRYPTO_MODE_SM4_ECB:
+		case CRYPTO_MODE_SM4_CBC:
+		case CRYPTO_MODE_SM4_CFB:
+		case CRYPTO_MODE_SM4_OFB:
+		case CRYPTO_MODE_SM4_CTR:
+		case CRYPTO_MODE_SM4_CCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_SM4_CS1:
+		case CRYPTO_MODE_SM4_CS2:
+		case CRYPTO_MODE_SM4_CS3:
+		case CRYPTO_MODE_AES_ECB:
+		case CRYPTO_MODE_AES_CBC:
+		case CRYPTO_MODE_AES_CS1:
+		case CRYPTO_MODE_AES_CS2:
+		case CRYPTO_MODE_AES_CS3:
+		case CRYPTO_MODE_AES_CFB:
+		case CRYPTO_MODE_AES_OFB:
+		case CRYPTO_MODE_AES_CTR:
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_AES_GCM:
+			spacc_read_from_buf(key, buf, 0, ksz, buflen);
+			spacc_read_from_buf(iv, buf,  32, 16, buflen);
+			break;
+		case CRYPTO_MODE_CHACHA20_STREAM:
+			spacc_read_from_buf(key, buf, 0, ksz, buflen);
+			spacc_read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_F8:
+		case CRYPTO_MODE_AES_F8:
+			if (key) {
+				spacc_read_from_buf(key + ksz, buf, 0, ksz,
+						    buflen);
+				spacc_read_from_buf(key, buf, 48, ksz, buflen);
+			}
+			spacc_read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_XTS:
+		case CRYPTO_MODE_AES_XTS:
+			if (key) {
+				spacc_read_from_buf(key, buf, 0, ksz >> 1,
+						    buflen);
+				spacc_read_from_buf(key + (ksz >> 1), buf,
+						    48, ksz >> 1, buflen);
+			}
+			spacc_read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_MULTI2_ECB:
+		case CRYPTO_MODE_MULTI2_CBC:
+		case CRYPTO_MODE_MULTI2_OFB:
+		case CRYPTO_MODE_MULTI2_CFB:
+			spacc_read_from_buf(key, buf, 0, ksz, buflen);
+			/* number of rounds at the end of the IV */
+			spacc_read_from_buf(iv, buf, 0x28, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_3DES_CBC:
+		case CRYPTO_MODE_3DES_ECB:
+			spacc_read_from_buf(iv,  buf, 0,  8, buflen);
+			spacc_read_from_buf(key, buf, 8, 24, buflen);
+			break;
+		case CRYPTO_MODE_DES_CBC:
+		case CRYPTO_MODE_DES_ECB:
+			spacc_read_from_buf(iv,  buf, 0, 8, buflen);
+			spacc_read_from_buf(key, buf, 8, 8, buflen);
+			break;
+		case CRYPTO_MODE_KASUMI_ECB:
+		case CRYPTO_MODE_KASUMI_F8:
+			spacc_read_from_buf(iv,  buf, 16,  8, buflen);
+			spacc_read_from_buf(key, buf, 0,  16, buflen);
+			break;
+		case CRYPTO_MODE_SNOW3G_UEA2:
+		case CRYPTO_MODE_ZUC_UEA3:
+			spacc_read_from_buf(key, buf, 0, 32, buflen);
+			break;
+		case CRYPTO_MODE_NULL:
+			break;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* Context manager: This will reset all reference counts, pointers, etc */
+void spacc_ctx_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_ctx *ctx;
+
+	/* initialize contexts */
+	for (x = 0; x < spacc->config.num_ctx; x++) {
+		ctx = &spacc->ctx[x];
+
+		/* sets everything including ref_cnt and ncontig to 0 */
+		memset(ctx, 0, sizeof(*ctx));
+
+		ctx->ciph_key = spacc->regmap + SPACC_CTX_CIPH_KEY +
+				(x * spacc->config.ciph_page_size);
+		ctx->hash_key = spacc->regmap + SPACC_CTX_HASH_KEY +
+				(x * spacc->config.hash_page_size);
+	}
+}
--
2.25.1

