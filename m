Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B7A56774
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 11:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638145; cv=none; b=SNPMIPwX2wNP00HpN2FIXLhrrkzNcdOxJDaQIb1ogiAYyYmDEMQDDu3N2nXaZT96WTaWo24NssyjSI797oTyzOOFjkZ0YDIuJfBGUiVVxOLQxlDm0lsVIQGW/Qf6b9IANJinlv+g4Edp4n+Xn80vUS1ZEWggkFUZhoLFFaDrImw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638145; c=relaxed/simple;
	bh=qiXA4lygS7Tli7TGrrGF2xpcAU0zkGitd4O+fXFaTjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GyIYMua0NUb/P2k54s93u1tyVIPhRUlp7brItp6KcciFP2jSc3vyfqGWZSgkyP4llHc0jZqkdmfAP64Iw81cGnzcVjI8Mu/TXRxYdNgDCLKNjiSHXZCzmfZR5ZzQ9D1AFDboWMH60Gw7eeY/cHv79RtfVyBVwvRU18o0hL72rFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=HhW18CNt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="HhW18CNt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd0d46ecc3so16613315ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 03:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709638134; x=1710242934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92y1KGT9cHdqSjZVAlpZVSR1YrHRG/pmQpg2U8jILaM=;
        b=HhW18CNtL5iHPgwKIp7tBdyHX4CMcMTwAIpo0+hozJYGOOhwFSFAxWF0pvNE36tW3G
         /OkMBeTgCbMId4nvjZ6TprJuT8nv5ZE3vsIKuiBQXvHbDal6mvNl4S9dKuaxnMGI0cef
         RfakP3K7Jq1lGhhktjTdGzjwmFEq65B03mkQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709638134; x=1710242934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92y1KGT9cHdqSjZVAlpZVSR1YrHRG/pmQpg2U8jILaM=;
        b=g7hHbIvCIlH2fX5csSn1cYCgIGx8/CjYgWsA//8lOVles75gw4tGoUrk8YgiSdJA/l
         uYE7wzEo4/X5tde8uqPQ0hgfqJV8F1rjcsxZJRs3Rz0FGP+rCPTpGltUB4s9Dp4E7pPN
         tgSH+3LoRqLsirsIBk7BXyd0GGIggsfNiQPcoM2tWvhljXf7VsbFNeLQFxvQ8on+UD6v
         vdmT8CZdKhI8OJhoDonMVwFe1THGAudptnWcifPLyW0aHqhTlKM1q4zzi+8eoP3ErrDk
         OmL/u0KuBhgEdUpo3c79kdlC2eUlz20R6o96qdeycStsJXLCW319X0f1Lg3vmWWy8uQd
         lSyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcgQUcjEm6Cf9IMTppV/AGGA2pZDT6oldOPf+WwTa7lZwVQFF0As92+C91/C4aFft16/GbqsjST1/I3/8KyZcneJMJTPLIYNylut8N
X-Gm-Message-State: AOJu0YwvXg8QC4Ep+FFd8pki+JQcT8rq+syHcRj6bEMhw1Tu554sJ0UJ
	R1jkVtsJ/WRmMyyieIRzXeGUAHlNH5qIh/9b0plrPiJ8G76ldwj/oXBVuKmvX9o=
X-Google-Smtp-Source: AGHT+IGKb3kJeuQFj+Bfebca9IKmAKcH7iaZX4FXHzDegrWIn83X8IJ51YjZCWT7Zw6UvY3UctwlTw==
X-Received: by 2002:a17:902:e892:b0:1dc:744f:5317 with SMTP id w18-20020a170902e89200b001dc744f5317mr2172478plg.50.1709638133506;
        Tue, 05 Mar 2024 03:28:53 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001db7e461d8asm10287212plb.130.2024.03.05.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 03:28:52 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>
Subject: [PATCH 1/4] Add SPAcc driver to Linux kernel
Date: Tue,  5 Mar 2024 16:58:28 +0530
Message-Id: <20240305112831.3380896-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: shwetar <shwetar@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/spacc_aead.c      | 1386 +++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c     | 1216 ++++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 3046 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  833 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  323 +++
 drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  205 ++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  781 +++++
 11 files changed, 9174 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c

diff --git a/drivers/crypto/dwc-spacc/spacc_aead.c b/drivers/crypto/dwc-spacc/spacc_aead.c
new file mode 100644
index 000000000000..90d623abce34
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_aead.c
@@ -0,0 +1,1386 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/aes.h>
+#include <crypto/sm4.h>
+#include <crypto/gcm.h>
+#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
+#include <linux/rtnetlink.h>
+#include <crypto/authenc.h>
+#include <linux/platform_device.h>
+#include "spacc_device.h"
+#include "spacc_core.h"
+#include <crypto/scatterwalk.h>
+
+static LIST_HEAD(spacc_aead_alg_list);
+static DEFINE_MUTEX(spacc_aead_alg_mutex);
+
+#define SPACC_B0_LEN		16
+#define SET_IV_IN_SRCBUF	0x80000000
+#define SET_IV_IN_CONTEXT	0x0
+#define IV_PTEXT_BUF_SZ		8192
+#define XTRA_BUF_LEN		112
+
+struct spacc_iv_buf {
+	unsigned char iv[SPACC_MAX_IV_SIZE];
+	unsigned char fulliv[SPACC_MAX_IV_SIZE + SPACC_B0_LEN + XTRA_BUF_LEN];
+	unsigned char ptext[IV_PTEXT_BUF_SZ];
+	struct scatterlist sg[2], fullsg[2], ptextsg[2];
+};
+
+static struct kmem_cache *spacc_iv_pool;
+
+static void spacc_init_aead_alg(struct crypto_alg *calg,
+				const struct mode_tab *mode)
+{
+	snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
+	snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
+					"spacc-%s", mode->name);
+
+	calg->cra_blocksize = mode->blocklen;
+}
+
+static struct mode_tab possible_aeads[] = {
+	{ MODE_TAB_AEAD("rfc7539(chacha20,poly1305)",
+			CRYPTO_MODE_CHACHA20_POLY1305, CRYPTO_MODE_NULL,
+			16, 12, 1), .keylen = { 16, 24, 32 }
+	},
+	{ MODE_TAB_AEAD("gcm(aes)",
+			CRYPTO_MODE_AES_GCM, CRYPTO_MODE_NULL,
+			16, 12, 1), .keylen = { 16, 24, 32 }
+	},
+	{ MODE_TAB_AEAD("rfc8998(gcm(sm4))",
+			CRYPTO_MODE_SM4_GCM_RFC8998, CRYPTO_MODE_NULL,
+			16, 16, 1), .keylen = { 16 }
+	},
+	{ MODE_TAB_AEAD("gcm(sm4)",
+			CRYPTO_MODE_SM4_GCM, CRYPTO_MODE_NULL,
+			16, 12, 1), .keylen = { 16 }
+	},
+	{ MODE_TAB_AEAD("ccm(aes)",
+			CRYPTO_MODE_AES_CCM, CRYPTO_MODE_NULL,
+			16, 16, 1), .keylen = { 16, 24, 32 }
+	},
+	{ MODE_TAB_AEAD("ccm(sm4)",
+			CRYPTO_MODE_SM4_CCM, CRYPTO_MODE_NULL,
+			16, 16, 1), .keylen = { 16, 24, 32 }
+	},
+};
+
+static int ccm_16byte_aligned_len(int in_len)
+{
+	int len;
+	int computed_mod;
+
+	if (in_len > 0) {
+		computed_mod = in_len % 16;
+		if (computed_mod)
+			len = in_len - computed_mod + 16;
+		else
+			len = in_len;
+	} else {
+		len = in_len;
+	}
+
+	return len;
+}
+
+/* taken from crypto/ccm.c */
+static int spacc_aead_set_msg_len(u8 *block, unsigned int msglen, int csize)
+{
+	__be32 data;
+
+	memset(block, 0, csize);
+	block += csize;
+
+	if (csize >= 4)
+		csize = 4;
+	else if (msglen > (unsigned int)(1 << (8 * csize)))
+		return -EOVERFLOW;
+
+	data = cpu_to_be32(msglen);
+	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
+
+	return 0;
+}
+
+static int spacc_aead_init_dma(struct device *dev, struct aead_request *req,
+			       u64 seq, uint32_t icvlen,
+			       int encrypt)
+{
+	struct crypto_aead *reqtfm      = crypto_aead_reqtfm(req);
+	struct spacc_crypto_ctx *tctx   = crypto_aead_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = aead_request_ctx(req);
+
+	gfp_t mflags = GFP_ATOMIC;
+	struct spacc_iv_buf *iv;
+	int ccm_aad_16b_len;
+	int rc, B0len;
+	int payload_len, fullsg_buf_len;
+	unsigned int ivsize = crypto_aead_ivsize(reqtfm);
+
+	/* always have 1 byte of IV */
+	if (!ivsize)
+		ivsize = 1;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		mflags = GFP_KERNEL;
+
+	ctx->iv_buf = kmem_cache_alloc(spacc_iv_pool, mflags);
+	if (!ctx->iv_buf)
+		return -ENOMEM;
+	iv = ctx->iv_buf;
+
+	sg_init_table(iv->sg, ARRAY_SIZE(iv->sg));
+	sg_init_table(iv->fullsg, ARRAY_SIZE(iv->fullsg));
+	sg_init_table(iv->ptextsg, ARRAY_SIZE(iv->ptextsg));
+
+	B0len = 0;
+	ctx->ptext_nents = 0;
+	ctx->fulliv_nents = 0;
+
+	/* copy the IV out for AAD */
+	memcpy(iv->iv, req->iv, ivsize);
+
+	memset(iv->fulliv, 0, 144);
+
+	/* now we need to figure out the cipher IV which may or
+	 * may not be "req->iv" depending on the mode we are
+	 */
+	if (tctx->mode & SPACC_MANGLE_IV_FLAG) {
+		switch (tctx->mode & 0x7F00) {
+		case SPACC_MANGLE_IV_RFC3686:
+		case SPACC_MANGLE_IV_RFC4106:
+		case SPACC_MANGLE_IV_RFC4543:
+			{
+				unsigned char *p = iv->fulliv;
+				/* we're in RFC3686 mode so the last
+				 * 4 bytes of the key are the SALT
+				 */
+				memcpy(p, tctx->csalt, 4);
+				memcpy(p + 4, req->iv, ivsize);
+
+				p[12] = 0;
+				p[13] = 0;
+				p[14] = 0;
+				p[15] = 1;
+			}
+			break;
+		case SPACC_MANGLE_IV_RFC4309:
+			{
+				unsigned char *p = iv->fulliv;
+				int L, M;
+				u32 lm = req->cryptlen;
+
+				/* CCM mode */
+				/* p[0..15] is the CTR IV */
+				/* p[16..31] is the CBC-MAC B0 block*/
+				B0len = SPACC_B0_LEN;
+				/* IPsec requires L=4*/
+				L = 4;
+				M = tctx->auth_size;
+
+				/* CTR block */
+				p[0] = L - 1;
+				memcpy(p + 1, tctx->csalt, 3);
+				memcpy(p + 4, req->iv, ivsize);
+				p[12] = 0;
+				p[13] = 0;
+				p[14] = 0;
+				p[15] = 1;
+
+				/* store B0 block at p[16..31] */
+				p[16] = (1 << 6) | (((M - 2) >> 1) << 3)
+					| (L - 1);
+				memcpy(p + 1 + 16, tctx->csalt, 3);
+				memcpy(p + 4 + 16, req->iv, ivsize);
+
+				/* now store length */
+				p[16 + 12 + 0] = (lm >> 24) & 0xFF;
+				p[16 + 12 + 1] = (lm >> 16) & 0xFF;
+				p[16 + 12 + 2] = (lm >> 8) & 0xFF;
+				p[16 + 12 + 3] = (lm) & 0xFF;
+
+				/*now store the pre-formatted AAD */
+				p[32] = (req->assoclen >> 8) & 0xFF;
+				p[33] = (req->assoclen) & 0xFF;
+				/* we added 2 byte header to the AAD */
+				B0len += 2;
+			}
+			break;
+		}
+	} else if (tctx->mode == CRYPTO_MODE_AES_CCM ||
+		   tctx->mode == CRYPTO_MODE_SM4_CCM) {
+		unsigned char *p = iv->fulliv;
+		int L, M;
+
+		u32 lm = (encrypt) ?
+			 req->cryptlen :
+			 req->cryptlen - tctx->auth_size;
+
+		memset(iv->fulliv, 0, 144);
+
+		if (req->assoclen)
+			ccm_aad_16b_len =
+				ccm_16byte_aligned_len(req->assoclen + 2);
+		else
+			ccm_aad_16b_len = 0;
+
+		/* CCM mode */
+		/* p[0..15] is the CTR IV */
+		/* p[16..31] is the CBC-MAC B0 block*/
+		B0len = SPACC_B0_LEN;
+
+		/* IPsec requires L=4 */
+		L = req->iv[0] + 1;
+		M = tctx->auth_size;
+		memset(p, 0, 128);
+
+		/* CTR block */
+		memcpy(p, req->iv, ivsize);
+
+		/* Taken from ccm.c
+		 * Note: rfc 3610 and NIST 800-38C require counter of
+		 * zero to encrypt auth tag.
+		 */
+
+		/* Store B0 block at p[16..31] */
+		p[16] = (((M - 2) >> 1) << 3) | (L - 1);
+
+		/* set adata if assoclen > 0 */
+		if (req->assoclen)
+			p[16] |= 1 << 6;
+
+		memcpy(p + 1 + 16, req->iv + 1, ivsize - 1);
+
+		/* now store length, this is L size starts from 16-L
+		 * to 16 of B0
+		 */
+		spacc_aead_set_msg_len(p + 16 + 16 - L, lm, L);
+
+		memset(p + 32, 0, ccm_aad_16b_len);
+
+		if (req->assoclen) {
+			char *buf = sg_virt(req->src);
+			struct scatterlist *dst_sg = req->dst;
+
+			/* store pre-formatted AAD:
+			 * AAD_LEN + AAD + PAD
+			 */
+			p[32] = (req->assoclen >> 8) & 0xFF;
+			p[33] = (req->assoclen) & 0xFF;
+
+			/* Adding the rest of AAD from req->src */
+			scatterwalk_map_and_copy(p + 34,
+						 req->src, 0,
+						 req->assoclen, 0);
+
+			/* Copy AAD to req->dst */
+			buf = sg_virt(dst_sg);
+			scatterwalk_map_and_copy(p + 34, req->dst,
+						 0, req->assoclen, 1);
+
+		}
+
+		/* Adding PT/CT from req->src to ptext here */
+		if (req->cryptlen)
+			memset(iv->ptext, 0,
+			       ccm_16byte_aligned_len(req->cryptlen));
+
+		scatterwalk_map_and_copy(iv->ptext, req->src,
+					 req->assoclen,
+					 req->cryptlen, 0);
+
+
+	} else {
+
+		/* default is to copy the iv over since the
+		 * cipher and protocol IV are the same
+		 */
+		memcpy(iv->fulliv, req->iv, ivsize);
+
+	}
+
+	/* this is part of the AAD */
+	sg_set_buf(iv->sg, iv->iv, ivsize);
+
+	/* GCM and CCM don't include the IV in the AAD */
+	if (tctx->mode == CRYPTO_MODE_AES_GCM_RFC4106	||
+	    tctx->mode == CRYPTO_MODE_AES_GCM		||
+	    tctx->mode == CRYPTO_MODE_SM4_GCM_RFC8998	||
+	    tctx->mode == CRYPTO_MODE_CHACHA20_POLY1305 ||
+	    tctx->mode == CRYPTO_MODE_NULL) {
+
+		ctx->iv_nents  = 0;
+		payload_len    = req->cryptlen + icvlen + req->assoclen;
+		fullsg_buf_len = SPACC_MAX_IV_SIZE + B0len;
+
+		/* this is the actual IV getting fed to the core
+		 * (via IV IMPORT)
+		 */
+
+		sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
+
+		rc = spacc_sgs_to_ddt(dev,
+				      iv->fullsg, fullsg_buf_len,
+				      &ctx->fulliv_nents, NULL, 0,
+				      &ctx->iv_nents, req->src,
+				      payload_len, &ctx->src_nents,
+				      &ctx->src, DMA_TO_DEVICE);
+
+	} else if (tctx->mode == CRYPTO_MODE_AES_CCM	     ||
+		   tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309 ||
+		   tctx->mode == CRYPTO_MODE_SM4_CCM) {
+
+		if (req->assoclen)
+			ccm_aad_16b_len =
+				ccm_16byte_aligned_len(req->assoclen + 2);
+		else
+			ccm_aad_16b_len = 0;
+
+		ctx->iv_nents = 0;
+
+		if (encrypt)
+			payload_len =
+				ccm_16byte_aligned_len(req->cryptlen + icvlen);
+		else
+			payload_len =
+				ccm_16byte_aligned_len(req->cryptlen);
+
+		fullsg_buf_len = SPACC_MAX_IV_SIZE + B0len + ccm_aad_16b_len;
+
+
+		/* this is the actual IV getting fed to the core (via IV IMPORT)
+		 * This has CTR IV + B0 + AAD(B1, B2, ...)
+		 */
+		sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
+		sg_set_buf(iv->ptextsg, iv->ptext, payload_len);
+
+		rc = spacc_sgs_to_ddt(dev,
+				      iv->fullsg, fullsg_buf_len,
+				      &ctx->fulliv_nents, NULL, 0,
+				      &ctx->iv_nents, iv->ptextsg,
+				      payload_len, &ctx->ptext_nents,
+				      &ctx->src, DMA_TO_DEVICE);
+
+	} else {
+		payload_len = req->cryptlen + icvlen + req->assoclen;
+		fullsg_buf_len = SPACC_MAX_IV_SIZE + B0len;
+
+		/* this is the actual IV getting fed to the core (via IV IMPORT)
+		 * This has CTR IV + B0 + AAD(B1, B2, ...)
+		 */
+		sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
+
+		rc = spacc_sgs_to_ddt(dev, iv->fullsg, fullsg_buf_len,
+				      &ctx->fulliv_nents, iv->sg,
+				      ivsize, &ctx->iv_nents,
+				      req->src, payload_len, &ctx->src_nents,
+				      &ctx->src, DMA_TO_DEVICE);
+	}
+
+	if (rc < 0)
+		goto err_free_iv;
+
+	/* Putting in req->dst is good since it won't overwrite anything
+	 * even in case of CCM this is fine condition
+	 */
+	if (req->dst != req->src) {
+		if (tctx->mode == CRYPTO_MODE_AES_CCM		||
+		    tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM) {
+			/* If req->dst buffer len is not-positive,
+			 * then skip setting up of DMA
+			 */
+			if (req->dst->length <= 0) {
+				ctx->dst_nents = 0;
+				return 0;
+			}
+
+			if (encrypt)
+				payload_len = req->cryptlen + icvlen +
+						req->assoclen;
+			else
+				payload_len = req->cryptlen - tctx->auth_size +
+						req->assoclen;
+
+			/* For corner cases where PTlen=AADlen=0, we set default
+			 * to 16
+			 */
+			rc = spacc_sg_to_ddt(dev, req->dst,
+					     payload_len > 0 ? payload_len : 16,
+					     &ctx->dst, DMA_FROM_DEVICE);
+			if (rc < 0)
+				goto err_free_src;
+
+			ctx->dst_nents = rc;
+		} else {
+
+			/* If req->dst buffer len is not-positive,
+			 * then skip setting up of DMA
+			 */
+			if (req->dst->length <= 0) {
+				ctx->dst_nents = 0;
+				return 0;
+			}
+
+			if (encrypt)
+				payload_len = SPACC_MAX_IV_SIZE + req->cryptlen
+						+ icvlen + req->assoclen;
+			else {
+				payload_len = req->cryptlen - tctx->auth_size +
+						req->assoclen;
+				if (payload_len == 0)
+					return -EBADMSG;
+			}
+
+
+			rc = spacc_sg_to_ddt(dev, req->dst, payload_len,
+						&ctx->dst, DMA_FROM_DEVICE);
+			if (rc < 0)
+				goto err_free_src;
+
+			ctx->dst_nents = rc;
+		}
+	}
+
+	return 0;
+
+err_free_src:
+	if (ctx->fulliv_nents)
+		dma_unmap_sg(dev, iv->fullsg, ctx->fulliv_nents,
+			     DMA_TO_DEVICE);
+
+	if (ctx->iv_nents)
+		dma_unmap_sg(dev, iv->sg, ctx->iv_nents, DMA_TO_DEVICE);
+
+	if (ctx->ptext_nents)
+		dma_unmap_sg(dev, iv->ptextsg, ctx->ptext_nents,
+			     DMA_TO_DEVICE);
+
+	dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE);
+	pdu_ddt_free(&ctx->src);
+
+err_free_iv:
+	kmem_cache_free(spacc_iv_pool, ctx->iv_buf);
+
+	return rc;
+}
+
+static void spacc_aead_cleanup_dma(struct device *dev, struct aead_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = aead_request_ctx(req);
+	struct spacc_iv_buf *iv = ctx->iv_buf;
+
+	if (req->src != req->dst) {
+		if (req->dst->length > 0) {
+			dma_unmap_sg(dev, req->dst, ctx->dst_nents,
+				     DMA_FROM_DEVICE);
+			pdu_ddt_free(&ctx->dst);
+		}
+	}
+
+	if (ctx->fulliv_nents)
+		dma_unmap_sg(dev, iv->fullsg, ctx->fulliv_nents,
+			     DMA_TO_DEVICE);
+
+	if (ctx->ptext_nents)
+		dma_unmap_sg(dev, iv->ptextsg, ctx->ptext_nents,
+			     DMA_TO_DEVICE);
+
+	if (ctx->iv_nents)
+		dma_unmap_sg(dev, iv->sg, ctx->iv_nents,
+			     DMA_TO_DEVICE);
+
+	if (req->src->length > 0) {
+		dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE);
+		pdu_ddt_free(&ctx->src);
+	}
+
+	kmem_cache_free(spacc_iv_pool, ctx->iv_buf);
+}
+
+static bool spacc_keylen_ok(const struct spacc_alg *salg, unsigned int keylen)
+{
+	unsigned int i, mask = salg->keylen_mask;
+
+	BUG_ON(mask > (1ul << ARRAY_SIZE(salg->mode->keylen)) - 1);
+
+	for (i = 0; mask; i++, mask >>= 1) {
+		if (mask & 1 && salg->mode->keylen[i] == keylen)
+			return true;
+	}
+
+	return false;
+}
+
+static void spacc_aead_cb(void *spacc, void *tfm)
+{
+	struct aead_cb_data *cb = tfm;
+	int err = -1;
+	struct spacc_iv_buf *iv = (struct spacc_iv_buf *)cb->ctx->iv_buf;
+	u32 status_reg = readl(cb->spacc->regmap + SPACC_REG_STATUS);
+	u32 status_ret = (status_reg >> 24) & 0x3;
+
+	dma_sync_sg_for_cpu(cb->tctx->dev, cb->req->dst,
+			    cb->ctx->dst_nents, DMA_FROM_DEVICE);
+
+	/* ICV mismatch send bad msg */
+	if (status_ret == 0x1) {
+		err = -EBADMSG;
+		goto REQ_DST_CP_SKIP;
+	}
+
+	/* copy the ptext to req->src/dst for CCMs only */
+	if (cb->tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309 ||
+	    cb->tctx->mode == CRYPTO_MODE_AES_CCM	  ||
+	    cb->tctx->mode == CRYPTO_MODE_SM4_CCM) {
+
+		if (cb->req->src == cb->req->dst) {
+			/* encryption op */
+			if (cb->ctx->encrypt_op) {
+				scatterwalk_map_and_copy(iv->ptext,
+							 cb->req->dst,
+							 cb->req->assoclen,
+							 cb->req->cryptlen +
+							 cb->tctx->auth_size,
+							 1);
+			} else {
+				scatterwalk_map_and_copy(iv->ptext,
+							 cb->req->dst,
+							 cb->req->assoclen,
+							 cb->req->cryptlen, 1);
+			}
+		}
+	}
+	err = cb->spacc->job[cb->new_handle].job_err;
+
+REQ_DST_CP_SKIP:
+	spacc_aead_cleanup_dma(cb->tctx->dev, cb->req);
+	spacc_close(cb->spacc, cb->new_handle);
+
+	/* call complete */
+	aead_request_complete(cb->req, err);
+}
+
+static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned
+		int keylen)
+{
+	struct spacc_crypto_ctx *ctx  = crypto_aead_ctx(tfm);
+	const struct spacc_alg  *salg = spacc_tfm_aead(&tfm->base);
+	struct spacc_priv	*priv;
+	struct rtattr *rta = (void *)key;
+	struct crypto_authenc_key_param *param;
+	unsigned int x, authkeylen, enckeylen;
+	const unsigned char *authkey, *enckey;
+	unsigned char xcbc[64];
+
+	int err = -EINVAL;
+	int singlekey = 0;
+
+	/* are keylens valid? */
+	ctx->ctx_valid = false;
+
+	switch (ctx->mode & 0xFF) {
+	case CRYPTO_MODE_SM4_GCM:
+	case CRYPTO_MODE_SM4_CCM:
+	case CRYPTO_MODE_NULL:
+	case CRYPTO_MODE_AES_GCM:
+	case CRYPTO_MODE_AES_CCM:
+	case CRYPTO_MODE_CHACHA20_POLY1305:
+		authkey      = key;
+		authkeylen   = 0;
+		enckey       = key;
+		enckeylen    = keylen;
+		ctx->keylen  = keylen;
+		singlekey    = 1;
+		goto skipover;
+	}
+
+	if (!RTA_OK(rta, keylen))
+		goto badkey;
+
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		goto badkey;
+
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		goto badkey;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+
+	if (keylen < enckeylen)
+		goto badkey;
+
+	authkeylen = keylen - enckeylen;
+
+	/* enckey is at &key[authkeylen] and
+	 * authkey is at &key[0]
+	 */
+	authkey = &key[0];
+	enckey  = &key[authkeylen];
+
+skipover:
+	/* detect RFC3686/4106 and trim from enckeylen(and copy salt..) */
+	if (ctx->mode & SPACC_MANGLE_IV_FLAG) {
+		switch (ctx->mode & 0x7F00) {
+		case SPACC_MANGLE_IV_RFC3686:
+		case SPACC_MANGLE_IV_RFC4106:
+		case SPACC_MANGLE_IV_RFC4543:
+			memcpy(ctx->csalt, enckey + enckeylen - 4, 4);
+			enckeylen -= 4;
+			break;
+		case SPACC_MANGLE_IV_RFC4309:
+			memcpy(ctx->csalt, enckey + enckeylen - 3, 3);
+			enckeylen -= 3;
+			break;
+		}
+	}
+
+	if (!singlekey) {
+		if (authkeylen > salg->mode->hashlen) {
+			dev_warn(ctx->dev, "Auth key size of %u is not valid\n",
+				 authkeylen);
+			return -EINVAL;
+		}
+	}
+
+	if (!spacc_keylen_ok(salg, enckeylen)) {
+		dev_warn(ctx->dev, "Enc key size of %u is not valid\n",
+			 enckeylen);
+		return -EINVAL;
+	}
+
+	/* if we're already open close the handle since
+	 * the size may have changed
+	 */
+	if (ctx->handle != -1) {
+		priv = dev_get_drvdata(ctx->dev);
+		spacc_close(&priv->spacc, ctx->handle);
+		put_device(ctx->dev);
+		ctx->handle = -1;
+	}
+
+	/* Open a handle and
+	 * search all devices for an open handle
+	 */
+	priv = NULL;
+	for (x = 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
+		priv = dev_get_drvdata(salg->dev[x]);
+
+		/* increase reference */
+		ctx->dev = get_device(salg->dev[x]);
+
+		/* check if its a valid mode ... */
+		if (spacc_isenabled(&priv->spacc, salg->mode->aead.ciph & 0xFF,
+				    enckeylen) &&
+		    spacc_isenabled(&priv->spacc,
+				    salg->mode->aead.hash & 0xFF, authkeylen)) {
+				/* try to open spacc handle */
+			ctx->handle = spacc_open(&priv->spacc,
+						 salg->mode->aead.ciph & 0xFF,
+						 salg->mode->aead.hash & 0xFF,
+						 -1, 0, spacc_aead_cb, tfm);
+		}
+
+		if (ctx->handle < 0)
+			put_device(salg->dev[x]);
+		else
+			break;
+	}
+
+	if (ctx->handle < 0) {
+		dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
+		return -EIO;
+	}
+
+	/* setup XCBC key */
+	if (salg->mode->aead.hash == CRYPTO_MODE_MAC_XCBC) {
+		err = spacc_compute_xcbc_key(&priv->spacc,
+					     salg->mode->aead.hash,
+					     ctx->handle, authkey,
+					     authkeylen, xcbc);
+		if (err < 0) {
+			dev_warn(ctx->dev, "Failed to compute XCBC key: %d\n",
+				 err);
+			return -EIO;
+		}
+		authkey    = xcbc;
+		authkeylen = 48;
+	}
+
+	/* handle zero key/zero len DEC condition for SM4/AES GCM mode */
+	ctx->zero_key = 0;
+	if (!key[0]) {
+		int i, val = 0;
+
+		for (i = 0; i < keylen ; i++)
+			val += key[i];
+
+		if (val == 0)
+			ctx->zero_key = 1;
+	}
+
+	err = spacc_write_context(&priv->spacc, ctx->handle,
+				  SPACC_CRYPTO_OPERATION, enckey,
+				  enckeylen, NULL, 0);
+
+	if (err) {
+		dev_warn(ctx->dev,
+			 "Could not write ciphering context: %d\n", err);
+		return -EIO;
+	}
+
+	if (!singlekey) {
+		err = spacc_write_context(&priv->spacc, ctx->handle,
+					  SPACC_HASH_OPERATION, authkey,
+					  authkeylen, NULL, 0);
+		if (err) {
+			dev_warn(ctx->dev,
+				 "Could not write hashing context: %d\n", err);
+			return -EIO;
+		}
+	}
+
+	/* set expand key */
+	spacc_set_key_exp(&priv->spacc, ctx->handle);
+	ctx->ctx_valid = true;
+
+	memset(xcbc, 0, sizeof(xcbc));
+
+	/* copy key to ctx for fallback */
+	memcpy(ctx->key, key, keylen);
+
+	return 0;
+
+badkey:
+	return err;
+}
+
+static int spacc_aead_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	struct spacc_crypto_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->auth_size = authsize;
+
+	/* taken from crypto/ccm.c */
+	switch (ctx->mode) {
+	case CRYPTO_MODE_SM4_GCM:
+	case CRYPTO_MODE_AES_GCM:
+		switch (authsize) {
+		case 4:
+		case 8:
+		case 12:
+		case 13:
+		case 14:
+		case 15:
+		case 16:
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+
+	case CRYPTO_MODE_AES_CCM:
+	case CRYPTO_MODE_SM4_CCM:
+		switch (authsize) {
+		case 4:
+		case 6:
+		case 8:
+		case 10:
+		case 12:
+		case 14:
+		case 16:
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+
+	case CRYPTO_MODE_CHACHA20_POLY1305:
+		switch (authsize) {
+		case 16:
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static int spacc_aead_fallback(struct aead_request *req,
+			       struct spacc_crypto_ctx *ctx,
+			       int encrypt)
+{
+	int ret;
+	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_aead *reqtfm	= crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(reqtfm);
+	const char *aead_name = alg->base.cra_name;
+
+	ctx->fb.aead = crypto_alloc_aead(aead_name, 0,
+					 CRYPTO_ALG_NEED_FALLBACK |
+					 CRYPTO_ALG_ASYNC);
+	if (!ctx->fb.aead) {
+		pr_err("Spacc aead fallback tfm is NULL!\n");
+		return -EINVAL;
+	}
+
+	subreq = aead_request_alloc(ctx->fb.aead, GFP_KERNEL);
+	if (!subreq)
+		return -ENOMEM;
+
+	crypto_aead_setauthsize(ctx->fb.aead, ctx->auth_size);
+	crypto_aead_setkey(ctx->fb.aead, ctx->key, ctx->keylen);
+
+	aead_request_set_tfm(subreq, ctx->fb.aead);
+	aead_request_set_callback(subreq, req->base.flags,
+			req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	if (encrypt)
+		ret = crypto_aead_encrypt(subreq);
+	else
+		ret = crypto_aead_decrypt(subreq);
+
+	aead_request_free(subreq);
+	crypto_free_aead(ctx->fb.aead);
+	ctx->fb.aead = NULL;
+
+	return ret;
+}
+
+static int spacc_aead_process(struct aead_request *req, u64 seq, int
+		encrypt)
+{
+	int rc;
+	int icvremove;
+	int ivaadsize;
+	int ptaadsize;
+	int B0len;
+	u32 dstoff;
+	int iv_to_context;
+	int spacc_proc_len;
+	u32 spacc_icv_offset;
+	int spacc_pre_aad_size;
+	int ccm_aad_16b_len;
+	struct crypto_aead *reqtfm	= crypto_aead_reqtfm(req);
+	int ivsize			= crypto_aead_ivsize(reqtfm);
+	struct spacc_crypto_ctx *tctx   = crypto_aead_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = aead_request_ctx(req);
+	struct spacc_priv *priv		= dev_get_drvdata(tctx->dev);
+	u32 msg_len = req->cryptlen - tctx->auth_size;
+	u32 l;
+
+	ctx->encrypt_op = encrypt;
+	if (req->assoclen)
+		ccm_aad_16b_len = ccm_16byte_aligned_len(req->assoclen + 2);
+	else
+		ccm_aad_16b_len = 0;
+
+	if (tctx->handle < 0 || !tctx->ctx_valid || (req->cryptlen +
+				req->assoclen) > priv->max_msg_len)
+		return -EINVAL;
+
+	/* IV is programmed to context by default */
+	iv_to_context = SET_IV_IN_CONTEXT;
+
+	if (encrypt) {
+		switch (tctx->mode & 0xFF) {
+		case CRYPTO_MODE_AES_GCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_CHACHA20_POLY1305:
+			/* For cryptlen = 0 */
+			if (req->cryptlen + req->assoclen == 0)
+				return spacc_aead_fallback(req, tctx, encrypt);
+			break;
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_SM4_CCM:
+			l = req->iv[0] + 1;
+
+			/* 2 <= L <= 8, so 1 <= L' <= 7. */
+			if (req->iv[0] < 1 || req->iv[0] > 7)
+				return -EINVAL;
+
+			/* verify that CCM dimension 'L' is set correctly
+			 * in the IV
+			 */
+			if (l < 2 || l > 8)
+				return -EINVAL;
+
+			/* verify that msglen can in fact be represented
+			 * in L bytes
+			 */
+			if (l < 4 && msg_len >> (8 * l))
+				return -EOVERFLOW;
+
+			break;
+		}
+	} else {
+		int ret;
+
+		/* Handle the decryption */
+		switch (tctx->mode & 0xFF) {
+		case CRYPTO_MODE_AES_GCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_CHACHA20_POLY1305:
+			/* For assoclen = 0 */
+			if (req->assoclen == 0 && req->cryptlen == 16) {
+				ret = spacc_aead_fallback(req, tctx, encrypt);
+
+				/*if (tctx->zero_key)
+					* for zero key ret 0 *
+					ret = 0;
+				else
+					* for non-zero key ret -EBADMSG *
+					ret = -EBADMSG;
+				*/
+
+				return ret;
+			}
+			break;
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_SM4_CCM:
+			/* 2 <= L <= 8, so 1 <= L' <= 7. */
+			if (req->iv[0] < 1 || req->iv[0] > 7)
+				return -EINVAL;
+			break;
+		}
+	}
+
+	icvremove = (encrypt) ? 0 : tctx->auth_size;
+
+	rc = spacc_aead_init_dma(tctx->dev, req, seq, (encrypt) ?
+			tctx->auth_size : 0, encrypt);
+	if (rc < 0)
+		return -EINVAL;
+
+	/* Note: This won't work if IV_IMPORT has been disabled */
+	ctx->cb.new_handle = spacc_clone_handle(&priv->spacc, tctx->handle,
+						&ctx->cb);
+	if (ctx->cb.new_handle < 0) {
+		spacc_aead_cleanup_dma(tctx->dev, req);
+		return -EINVAL;
+	}
+
+	ctx->cb.tctx  = tctx;
+	ctx->cb.ctx   = ctx;
+	ctx->cb.req   = req;
+	ctx->cb.spacc = &priv->spacc;
+
+	/* Write IV to the spacc-context
+	 * IV can be written to context or as part of the input src buffer
+	 * IV in case of CCM is going in the input src buff.
+	 * IV for GCM is written to the context.
+	 */
+	if (tctx->mode == CRYPTO_MODE_AES_GCM_RFC4106	||
+	    tctx->mode == CRYPTO_MODE_AES_GCM		||
+	    tctx->mode == CRYPTO_MODE_SM4_GCM_RFC8998	||
+	    tctx->mode == CRYPTO_MODE_CHACHA20_POLY1305	||
+	    tctx->mode == CRYPTO_MODE_NULL) {
+		iv_to_context = SET_IV_IN_CONTEXT;
+		rc = spacc_write_context(&priv->spacc, ctx->cb.new_handle,
+					 SPACC_CRYPTO_OPERATION, NULL, 0,
+					 req->iv, ivsize);
+	}
+
+	/* CCM and GCM don't include the IV in the AAD */
+	if (tctx->mode == CRYPTO_MODE_AES_GCM_RFC4106	||
+	    tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+	    tctx->mode == CRYPTO_MODE_AES_GCM		||
+	    tctx->mode == CRYPTO_MODE_AES_CCM		||
+	    tctx->mode == CRYPTO_MODE_SM4_CCM		||
+	    tctx->mode == CRYPTO_MODE_SM4_GCM_RFC8998	||
+	    tctx->mode == CRYPTO_MODE_CHACHA20_POLY1305	||
+	    tctx->mode == CRYPTO_MODE_NULL) {
+		ivaadsize = 0;
+	} else {
+		ivaadsize = ivsize;
+	}
+
+	/* CCM requires an extra block of AAD */
+	if (tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309 ||
+	    tctx->mode == CRYPTO_MODE_AES_CCM	      ||
+	    tctx->mode == CRYPTO_MODE_SM4_CCM)
+		B0len = SPACC_B0_LEN;
+	else
+		B0len = 0;
+
+	/* GMAC mode uses AAD for the entire message.
+	 * So does NULL cipher
+	 */
+	if (tctx->mode == CRYPTO_MODE_AES_GCM_RFC4543 ||
+	    tctx->mode == CRYPTO_MODE_NULL) {
+		if (req->cryptlen >= icvremove)
+			ptaadsize = req->cryptlen - icvremove;
+	} else {
+		ptaadsize = 0;
+	}
+
+	/* Calculate and set the below, important parameters
+	 * spacc icv offset	- spacc_icv_offset
+	 * destination offset	- dstoff
+	 * IV to context	- This is set for CCM, not set for GCM
+	 */
+	if (req->dst == req->src) {
+		dstoff = ((uint32_t)(SPACC_MAX_IV_SIZE + B0len +
+				     req->assoclen + ivaadsize));
+
+		if (req->assoclen + req->cryptlen >= icvremove)
+			spacc_icv_offset =  ((uint32_t)(SPACC_MAX_IV_SIZE +
+						B0len + req->assoclen +
+						ivaadsize + req->cryptlen -
+						icvremove));
+		else
+			spacc_icv_offset =  ((uint32_t)(SPACC_MAX_IV_SIZE +
+						B0len + req->assoclen +
+						ivaadsize + req->cryptlen));
+
+		/* CCM case */
+		if (tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+		    tctx->mode == CRYPTO_MODE_AES_CCM		||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM) {
+			iv_to_context = SET_IV_IN_SRCBUF;
+			dstoff = ((uint32_t)(SPACC_MAX_IV_SIZE + B0len +
+				 ccm_aad_16b_len + ivaadsize));
+
+			if (encrypt)
+				spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len + ccm_aad_16b_len
+					+ ivaadsize
+					+ ccm_16byte_aligned_len(req->cryptlen)
+					- icvremove));
+			else
+				spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len + ccm_aad_16b_len + ivaadsize
+					+ req->cryptlen - icvremove));
+		}
+
+	} else {
+		dstoff = ((uint32_t)(req->assoclen + ivaadsize));
+
+		if (req->assoclen + req->cryptlen >= icvremove)
+			spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len + req->assoclen
+					+ ivaadsize + req->cryptlen
+					- icvremove));
+		else
+			spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len + req->assoclen
+					+ ivaadsize + req->cryptlen));
+
+		/* CCM case */
+		if (tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+		    tctx->mode == CRYPTO_MODE_AES_CCM		||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM) {
+			iv_to_context = SET_IV_IN_SRCBUF;
+			dstoff = ((uint32_t)(req->assoclen + ivaadsize));
+
+			if (encrypt)
+				spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len
+					+ ccm_aad_16b_len + ivaadsize
+					+ ccm_16byte_aligned_len(req->cryptlen)
+					- icvremove));
+			else
+				spacc_icv_offset = ((uint32_t)(SPACC_MAX_IV_SIZE
+					+ B0len + ccm_aad_16b_len + ivaadsize
+					+ req->cryptlen - icvremove));
+		}
+	}
+
+	/* compute the ICV offset which is different for both encrypt/decrypt */
+	if (encrypt) {
+		if (tctx->mode == CRYPTO_MODE_AES_CCM		||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM		||
+		    tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM_RFC8998) {
+			rc = spacc_set_operation(&priv->spacc,
+					 ctx->cb.new_handle,
+					 encrypt ? OP_ENCRYPT : OP_DECRYPT,
+					 ICV_ENCRYPT_HASH, IP_ICV_APPEND,
+					 spacc_icv_offset,
+					 tctx->auth_size, 0);
+
+			spacc_proc_len = B0len + ccm_aad_16b_len
+					+ req->cryptlen + ivaadsize
+					- icvremove;
+			spacc_pre_aad_size = B0len + ccm_aad_16b_len
+					+ ivaadsize + ptaadsize;
+
+		} else {
+			rc = spacc_set_operation(&priv->spacc,
+					 ctx->cb.new_handle,
+					 encrypt ? OP_ENCRYPT : OP_DECRYPT,
+					 ICV_ENCRYPT_HASH, IP_ICV_APPEND,
+					 spacc_icv_offset,
+					 tctx->auth_size, 0);
+
+			spacc_proc_len = B0len + req->assoclen
+					+ req->cryptlen - icvremove
+					+ ivaadsize;
+			spacc_pre_aad_size = B0len + req->assoclen
+					+ ivaadsize + ptaadsize;
+		}
+	} else {
+		if (tctx->mode == CRYPTO_MODE_AES_CCM		||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM		||
+		    tctx->mode == CRYPTO_MODE_AES_CCM_RFC4309	||
+		    tctx->mode == CRYPTO_MODE_SM4_CCM_RFC8998) {
+			rc = spacc_set_operation(&priv->spacc,
+					 ctx->cb.new_handle,
+					 encrypt ? OP_ENCRYPT : OP_DECRYPT,
+					 ICV_ENCRYPT_HASH, IP_ICV_OFFSET,
+					 spacc_icv_offset,
+					 tctx->auth_size, 0);
+
+			spacc_proc_len = B0len + ccm_aad_16b_len
+					+ req->cryptlen + ivaadsize
+					- icvremove;
+			spacc_pre_aad_size = B0len + ccm_aad_16b_len
+					+ ivaadsize + ptaadsize;
+
+		} else {
+			rc = spacc_set_operation(&priv->spacc,
+					 ctx->cb.new_handle,
+					 encrypt ? OP_ENCRYPT : OP_DECRYPT,
+					 ICV_ENCRYPT_HASH, IP_ICV_APPEND,
+					 req->cryptlen - icvremove +
+					 SPACC_MAX_IV_SIZE + B0len +
+					 req->assoclen + ivaadsize,
+					 tctx->auth_size, 0);
+
+			spacc_proc_len = B0len + req->assoclen
+					+ req->cryptlen - icvremove
+					+ ivaadsize;
+			spacc_pre_aad_size = B0len + req->assoclen
+					+ ivaadsize + ptaadsize;
+		}
+	}
+
+	rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->cb.new_handle,
+				      &ctx->src,
+				      (req->dst == req->src) ? &ctx->src :
+				      &ctx->dst, spacc_proc_len,
+				      (dstoff << SPACC_OFFSET_DST_O) |
+				      SPACC_MAX_IV_SIZE,
+				      spacc_pre_aad_size,
+				      0, iv_to_context, 0);
+
+	if (rc < 0) {
+		spacc_aead_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->cb.new_handle);
+
+		if (rc != -EBUSY) {
+			dev_err(tctx->dev, "  failed to enqueue job, ERR: %d\n",
+				rc);
+		}
+
+		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+
+		return -EINVAL;
+	}
+
+	/* At this point the job is in flight to the engine ... remove first use
+	 * so subsequent calls don't expand the key again... ideally we would
+	 * pump a dummy job through the engine to pre-expand the key so that by
+	 * time setkey was done we wouldn't have to do this
+	 */
+	priv->spacc.job[tctx->handle].first_use  = 0;
+	priv->spacc.job[tctx->handle].ctrl &= ~(1UL
+			<< priv->spacc.config.ctrl_map[SPACC_CTRL_KEY_EXP]);
+
+	return -EINPROGRESS;
+}
+
+static int spacc_aead_encrypt(struct aead_request *req)
+{
+	return spacc_aead_process(req, 0ULL, 1);
+}
+
+static int spacc_aead_decrypt(struct aead_request *req)
+{
+	return spacc_aead_process(req, 0ULL, 0);
+}
+
+static int spacc_aead_init(struct crypto_aead *tfm)
+{
+	struct spacc_crypto_ctx *ctx   = crypto_aead_ctx(tfm);
+	const struct spacc_alg  *salg = spacc_tfm_aead(&tfm->base);
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct spacc_crypto_reqctx));
+
+	ctx->zero_key = 0;
+	ctx->fb.aead  = NULL;
+	ctx->handle   = -1;
+	ctx->mode     = salg->mode->aead.ciph;
+	ctx->dev      = get_device(salg->dev[0]);
+
+	return 0;
+}
+
+static void spacc_aead_exit(struct crypto_aead *tfm)
+{
+	struct spacc_crypto_ctx *ctx = crypto_aead_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(ctx->dev);
+
+	ctx->fb.aead = NULL;
+	/* close spacc handle */
+	if (ctx->handle >= 0) {
+		spacc_close(&priv->spacc, ctx->handle);
+		ctx->handle = -1;
+	}
+
+	put_device(ctx->dev);
+}
+
+struct aead_alg spacc_aead_algs = {
+	.setkey      = spacc_aead_setkey,
+	.setauthsize = spacc_aead_setauthsize,
+	.encrypt     = spacc_aead_encrypt,
+	.decrypt     = spacc_aead_decrypt,
+	.init        = spacc_aead_init,
+	.exit        = spacc_aead_exit,
+
+	.base.cra_priority = 300,
+	.base.cra_module   = THIS_MODULE,
+	.base.cra_ctxsize  = sizeof(struct spacc_crypto_ctx),
+	.base.cra_flags    = CRYPTO_ALG_TYPE_AEAD
+			   | CRYPTO_ALG_ASYNC
+			   | CRYPTO_ALG_NEED_FALLBACK
+			   | CRYPTO_ALG_KERN_DRIVER_ONLY
+			   | CRYPTO_ALG_OPTIONAL_KEY
+};
+
+static int spacc_register_aead(unsigned int aead_mode,
+			       struct platform_device *spacc_pdev)
+{
+	int rc;
+	struct spacc_alg *salg;
+
+	salg = kmalloc(sizeof(*salg), GFP_KERNEL);
+	if (!salg)
+		return -ENOMEM;
+
+	salg->mode	= &possible_aeads[aead_mode];
+	salg->dev[0]	= &spacc_pdev->dev;
+	salg->dev[1]	= NULL;
+	salg->calg	= &salg->alg.aead.base;
+	salg->alg.aead	= spacc_aead_algs;
+
+	spacc_init_aead_alg(salg->calg, salg->mode);
+
+	salg->alg.aead.ivsize		  = salg->mode->ivlen;
+	salg->alg.aead.maxauthsize	  = salg->mode->hashlen;
+	salg->alg.aead.base.cra_blocksize = salg->mode->blocklen;
+
+	salg->keylen_mask = possible_aeads[aead_mode].keylen_mask;
+
+	if (salg->mode->aead.ciph & SPACC_MANGLE_IV_FLAG) {
+		switch (salg->mode->aead.ciph & 0x7F00) {
+		case SPACC_MANGLE_IV_RFC3686: /*CTR*/
+		case SPACC_MANGLE_IV_RFC4106: /*GCM*/
+		case SPACC_MANGLE_IV_RFC4543: /*GMAC*/
+		case SPACC_MANGLE_IV_RFC4309: /*CCM*/
+		case SPACC_MANGLE_IV_RFC8998: /*GCM/CCM*/
+			salg->alg.aead.ivsize  = 12;
+			break;
+		}
+	}
+
+	rc = crypto_register_aead(&salg->alg.aead);
+	if (rc < 0) {
+		kfree(salg);
+		return rc;
+	}
+
+	dev_dbg(salg->dev[0], "Registered %s\n", salg->mode->name);
+
+	mutex_lock(&spacc_aead_alg_mutex);
+	list_add(&salg->list, &spacc_aead_alg_list);
+	mutex_unlock(&spacc_aead_alg_mutex);
+
+	return 0;
+}
+
+int probe_aeads(struct platform_device *spacc_pdev)
+{
+	int err;
+	unsigned int x, y;
+	struct spacc_priv *priv = NULL;
+
+	size_t alloc_size = max_t(unsigned long,
+			roundup_pow_of_two(sizeof(struct spacc_iv_buf)),
+			dma_get_cache_alignment());
+
+	spacc_iv_pool = kmem_cache_create("spacc-aead-iv", alloc_size,
+					  alloc_size, 0, NULL);
+
+	if (!spacc_iv_pool)
+		return -ENOMEM;
+
+	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
+		possible_aeads[x].keylen_mask = 0;
+		possible_aeads[x].valid       = 0;
+	}
+
+	/* compute cipher key masks (over all devices) */
+	priv = dev_get_drvdata(&spacc_pdev->dev);
+
+	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
+		for (y = 0; y < ARRAY_SIZE(possible_aeads[x].keylen); y++) {
+			if (spacc_isenabled(&priv->spacc,
+					    possible_aeads[x].aead.ciph & 0xFF,
+					possible_aeads[x].keylen[y]))
+				possible_aeads[x].keylen_mask |= 1u << y;
+		}
+	}
+
+	/* scan for combined modes */
+	priv = dev_get_drvdata(&spacc_pdev->dev);
+
+	for (x = 0; x < ARRAY_SIZE(possible_aeads); x++) {
+		if (!possible_aeads[x].valid && possible_aeads[x].keylen_mask) {
+			if (spacc_isenabled(&priv->spacc,
+					    possible_aeads[x].aead.hash & 0xFF,
+					possible_aeads[x].hashlen)) {
+
+				possible_aeads[x].valid = 1;
+				err = spacc_register_aead(x, spacc_pdev);
+				if (err < 0)
+					goto error;
+			}
+		}
+	}
+
+	return 0;
+
+error:
+	return err;
+}
+
+int spacc_unregister_aead_algs(void)
+{
+	struct spacc_alg *salg, *tmp;
+
+	mutex_lock(&spacc_aead_alg_mutex);
+	list_for_each_entry_safe(salg, tmp, &spacc_aead_alg_list, list) {
+		crypto_unregister_alg(salg->calg);
+		list_del(&salg->list);
+		kfree(salg);
+	}
+	mutex_unlock(&spacc_aead_alg_mutex);
+
+	kmem_cache_destroy(spacc_iv_pool);
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-spacc/spacc_ahash.c
new file mode 100644
index 000000000000..7f4be6530591
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
@@ -0,0 +1,1216 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/internal/hash.h>
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <crypto/sm3.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <crypto/sha3.h>
+#include <crypto/md5.h>
+#include <crypto/aes.h>
+#include "spacc_device.h"
+#include "spacc_core.h"
+
+#define PPP_BUF_SZ 128
+
+
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+struct my_list {
+	struct list_head list;
+	char *buffer;
+};
+
+static struct dma_pool *spacc_hash_pool;
+static LIST_HEAD(spacc_hash_alg_list);
+static LIST_HEAD(head_sglbuf);
+static DEFINE_MUTEX(spacc_hash_alg_mutex);
+
+static struct mode_tab possible_hashes[] = {
+	{ .keylen[0] = 16, MODE_TAB_HASH("cmac(aes)", MAC_CMAC, 16,  16),
+	.sw_fb = true },
+	{ .keylen[0] = 48 | MODE_TAB_HASH_XCBC, MODE_TAB_HASH("xcbc(aes)",
+	MAC_XCBC, 16,  16), .sw_fb = true },
+
+	{ MODE_TAB_HASH("cmac(sm4)", MAC_SM4_CMAC, 16, 16), .sw_fb = true },
+	{ .keylen[0] = 32 | MODE_TAB_HASH_XCBC, MODE_TAB_HASH("xcbc(sm4)",
+	MAC_SM4_XCBC, 16, 16), .sw_fb = true },
+
+	{ MODE_TAB_HASH("hmac(md5)", HMAC_MD5, MD5_DIGEST_SIZE,
+	MD5_HMAC_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("md5", HASH_MD5, MD5_DIGEST_SIZE,
+	MD5_HMAC_BLOCK_SIZE), .sw_fb = true },
+
+	{ MODE_TAB_HASH("hmac(sha1)", HMAC_SHA1, SHA1_DIGEST_SIZE,
+	SHA1_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha1", HASH_SHA1, SHA1_DIGEST_SIZE,
+	SHA1_BLOCK_SIZE), .sw_fb = true },
+
+	{ MODE_TAB_HASH("sha224",	HASH_SHA224, SHA224_DIGEST_SIZE,
+	SHA224_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha256",	HASH_SHA256, SHA256_DIGEST_SIZE,
+	SHA256_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha384",	HASH_SHA384, SHA384_DIGEST_SIZE,
+	SHA384_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha512",	HASH_SHA512, SHA512_DIGEST_SIZE,
+	SHA512_BLOCK_SIZE), .sw_fb = true },
+
+	{ MODE_TAB_HASH("hmac(sha512)",	HMAC_SHA512, SHA512_DIGEST_SIZE,
+	SHA512_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("hmac(sha224)",	HMAC_SHA224, SHA224_DIGEST_SIZE,
+	SHA224_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("hmac(sha256)",	HMAC_SHA256, SHA256_DIGEST_SIZE,
+	SHA256_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("hmac(sha384)",	HMAC_SHA384, SHA384_DIGEST_SIZE,
+	SHA384_BLOCK_SIZE), .sw_fb = true },
+
+	{ MODE_TAB_HASH("sha3-224", HASH_SHA3_224, SHA3_224_DIGEST_SIZE,
+	SHA3_224_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha3-256", HASH_SHA3_256, SHA3_256_DIGEST_SIZE,
+	SHA3_256_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha3-384", HASH_SHA3_384, SHA3_384_DIGEST_SIZE,
+	SHA3_384_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sha3-512", HASH_SHA3_512, SHA3_512_DIGEST_SIZE,
+	SHA3_512_BLOCK_SIZE), .sw_fb = true },
+
+	{ MODE_TAB_HASH("hmac(sm3)", HMAC_SM3, SM3_DIGEST_SIZE,
+	SM3_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("sm3", HASH_SM3, SM3_DIGEST_SIZE,
+	SM3_BLOCK_SIZE), .sw_fb = true },
+	{ MODE_TAB_HASH("michael_mic", MAC_MICHAEL, 8, 8), .sw_fb = true },
+
+	// Below algorithms are not supported in crypto test manager
+#ifdef ADDITIONAL_SPACC_SUPPORTED_HASHES
+	{ MODE_TAB_HASH("mac(kasumi)", MAC_KASUMI_F9, 4, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("mac(snow3g)", MAC_SNOW3G_UIA2, 4, 64),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("mac(zuc)", MAC_ZUC_UIA3, 4, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("sslmac(md5)", SSLMAC_MD5, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("sslmac(sha1)", SSLMAC_SHA1, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("sha512-224", HASH_SHA512_224, 28, 128),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("sha512-256", HASH_SHA512_256, 32, 128),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("hmac(sha512-224)", HMAC_SHA512_224, 28, 128),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("hmac(sha512-256)", HMAC_SHA512_256, 32, 128),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("shake128", HASH_SHAKE128, 16, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("shake256", HASH_SHAKE256, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("cshake128", HASH_CSHAKE128, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("cshake256", HASH_CSHAKE256, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("kmac128", MAC_KMAC128, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("kmac256", MAC_KMAC256, 32, 64), .sw_fb = false },
+	{ MODE_TAB_HASH("kmacxof128", MAC_KMACXOF128, 32, 64),
+	.sw_fb = false },
+	{ MODE_TAB_HASH("kmacxof256", MAC_KMACXOF256, 32, 64), .sw_fb = false },
+#endif
+};
+
+
+static void spacc_hash_cleanup_dma_dst(struct device *dev,
+				       struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	dma_pool_free(spacc_hash_pool, ctx->digest_buf, ctx->digest_dma);
+	pdu_ddt_free(&ctx->dst);
+}
+
+static void spacc_hash_cleanup_dma_src(struct device *dev,
+				       struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE);
+	pdu_ddt_free(&ctx->src);
+}
+
+static void spacc_hash_cleanup_dma(struct device *dev,
+				   struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE);
+	pdu_ddt_free(&ctx->src);
+
+	dma_pool_free(spacc_hash_pool, ctx->digest_buf, ctx->digest_dma);
+	pdu_ddt_free(&ctx->dst);
+}
+
+static void spacc_hash_cleanup_ppp(struct ahash_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	if (ctx->total_nents) {
+		ctx->total_nents = 0;
+		ctx->cur_part_pck = 0;
+	}
+	ctx->acb.tctx->flag_ppp = 0;
+}
+
+static void spacc_init_calg(struct crypto_alg *calg,
+			    const struct mode_tab *mode)
+{
+	snprintf(calg->cra_name, sizeof(calg->cra_name),
+					"%s", mode->name);
+	snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
+					"spacc-%s", mode->name);
+	calg->cra_blocksize = mode->blocklen;
+}
+
+static void sgl_node_delete(void)
+{
+	/* go through the list and free the memory. */
+	struct my_list *cursor, *temp;
+
+	list_for_each_entry_safe(cursor, temp, &head_sglbuf, list) {
+		kfree(cursor->buffer);
+		list_del(&cursor->list);
+		kfree(cursor);
+	}
+}
+
+static void sg_node_create_add(char *sg_buf)
+{
+	struct my_list *temp_node = NULL;
+
+	/*Creating Node*/
+	temp_node = kmalloc(sizeof(struct my_list), GFP_KERNEL);
+
+	/*Assgin the data that is received*/
+	temp_node->buffer = sg_buf;
+
+	/*Init the list within the struct*/
+	INIT_LIST_HEAD(&temp_node->list);
+
+	/*Add Node to Linked List*/
+	list_add_tail(&temp_node->list, &head_sglbuf);
+}
+
+static int spacc_ctx_clone_handle(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	ctx->acb.new_handle = spacc_clone_handle(&priv->spacc, tctx->handle,
+			&ctx->acb);
+
+	if (ctx->acb.new_handle < 0) {
+		spacc_hash_cleanup_dma(tctx->dev, req);
+		return -ENOMEM;
+	}
+
+	ctx->acb.tctx  = tctx;
+	ctx->acb.ctx   = ctx;
+	ctx->acb.req   = req;
+	ctx->acb.spacc = &priv->spacc;
+
+	return 0;
+}
+
+
+static int spacc_hash_init_dma(struct device *dev, struct ahash_request *req,
+			       int final)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	const struct spacc_alg *salg = spacc_tfm_ahash(&tfm->base);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	gfp_t mflags = GFP_ATOMIC;
+	int rc = -1, blk_sz = 64;
+	char *sgl_buffer;
+	int prev_rem_len = ctx->rem_len;
+	int nbytes = req->nbytes;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		mflags = GFP_KERNEL;
+
+	ctx->digest_buf = dma_pool_alloc(spacc_hash_pool, mflags,
+					 &ctx->digest_dma);
+
+	if (!ctx->digest_buf)
+		return -ENOMEM;
+
+	rc = pdu_ddt_init(&ctx->dst, 1 | 0x80000000);
+	if (rc < 0) {
+		pr_err("ERR: PDU DDT init error\n");
+		rc = -EIO;
+		goto err_free_digest;
+	}
+	pdu_ddt_add(&ctx->dst, ctx->digest_dma, SPACC_MAX_DIGEST_SIZE);
+
+	if (ctx->total_nents && !ctx->single_shot) {
+		switch (salg->mode->id) {
+		case CRYPTO_MODE_HASH_SHA384:
+		case CRYPTO_MODE_HMAC_SHA384:
+		case CRYPTO_MODE_HASH_SHA512:
+		case CRYPTO_MODE_HMAC_SHA512:
+			blk_sz = 128;
+			break;
+		case CRYPTO_MODE_MAC_MICHAEL:
+			blk_sz = 64;
+			break;
+		default:
+			blk_sz = 64;
+		}
+
+		ctx->rem_len = modify_scatterlist(req->src,
+						  &(tctx->ppp_sgl[0]),
+						  tctx->ppp_buffer,
+						  prev_rem_len, blk_sz,
+						  sgl_buffer,
+						  nbytes, final);
+
+		sg_node_create_add(sgl_buffer);
+	}
+
+	/* partial packet handling */
+	if (ctx->total_nents && !ctx->single_shot) {
+
+		if (final) {
+			spacc_ctx_clone_handle(req);
+
+			if (ctx->small_pck)
+				;/* small packet, do nothing */
+			else {
+				/* set to LAST PARTIAL PKT, Regular PPP pkt,
+				 * final chunk
+				 * Also for final rem_len = 0, setting up last
+				 * pkt with 0 len doesnt work
+				 */
+				rc = spacc_partial_packet(&priv->spacc,
+						ctx->acb.new_handle,
+						LAST_PARTIAL_PCK);
+				if (rc != CRYPTO_OK)
+					return -ENOMEM;
+			}
+		} else if (!final && tctx->ppp_sgl[0].length != 0) {
+			spacc_ctx_clone_handle(req);
+
+			/* not a small packet anymore */
+			ctx->small_pck = 0;
+
+			/* Set FIRST/MIDDLE partial pkt */
+			if (ctx->first_ppp_chunk) {
+				ctx->first_ppp_chunk = 0;
+
+				if (ctx->total_nents == ctx->rem_nents &&
+				    ctx->rem_len == 0) {
+					/* case of UPDATE % blksz == 0 */
+					spacc_partial_packet(&priv->spacc,
+							ctx->acb.new_handle,
+							NO_PARTIAL_PCK);
+				} else {
+					spacc_partial_packet(&priv->spacc,
+							ctx->acb.new_handle,
+							FIRST_PARTIAL_PCK);
+				}
+			} else {
+
+				if (ctx->total_nents == ctx->rem_nents &&
+				    ctx->rem_len == 0) {
+					rc = spacc_partial_packet(&priv->spacc,
+							ctx->acb.new_handle,
+							LAST_PARTIAL_PCK);
+				} else
+					spacc_partial_packet(&priv->spacc,
+							ctx->acb.new_handle,
+							MIDDLE_PARTIAL_PCK);
+			}
+		} else {
+			/* set first+last pkt together */
+			return 0;
+		}
+
+		if (tctx->ppp_sgl[0].length) {
+			rc = spacc_sg_to_ddt(dev, &(tctx->ppp_sgl[0]),
+					     tctx->ppp_sgl[0].length,
+					     &ctx->src, DMA_TO_DEVICE);
+		} else {
+			;/* Handle ZERO msg or ZERO last chunk */
+		}
+
+	} else if (ctx->total_nents > 0 && ctx->single_shot) {
+		/* single shot */
+		spacc_ctx_clone_handle(req);
+
+		if (req->nbytes) {
+			rc = spacc_sg_to_ddt(dev, req->src, req->nbytes,
+					     &ctx->src, DMA_TO_DEVICE);
+		} else {
+			memset(tctx->ppp_buffer, '\0', PPP_BUF_SZ);
+			sg_set_buf(&(tctx->ppp_sgl[0]), tctx->ppp_buffer,
+								PPP_BUF_SZ);
+			rc = spacc_sg_to_ddt(dev, &(tctx->ppp_sgl[0]),
+					     tctx->ppp_sgl[0].length,
+					     &ctx->src, DMA_TO_DEVICE);
+
+		}
+	} else if (ctx->total_nents == 0 && req->nbytes == 0) {
+		spacc_ctx_clone_handle(req);
+
+		/* zero length case */
+		memset(tctx->ppp_buffer, '\0', PPP_BUF_SZ);
+		sg_set_buf(&(tctx->ppp_sgl[0]), tctx->ppp_buffer, PPP_BUF_SZ);
+		rc = spacc_sg_to_ddt(dev, &(tctx->ppp_sgl[0]),
+					    tctx->ppp_sgl[0].length,
+					    &ctx->src, DMA_TO_DEVICE);
+
+	} else if (ctx->total_nents == 0 && !ctx->single_shot) {
+		/* INIT-FINUP sequence */
+		spacc_ctx_clone_handle(req);
+		rc = spacc_sg_to_ddt(dev, req->src, req->nbytes,
+				     &ctx->src, DMA_TO_DEVICE);
+	} else {
+		;/* do nothing */
+	}
+
+	if (rc < 0)
+		goto err_free_dst;
+
+	ctx->src_nents = rc;
+
+	return rc;
+
+err_free_dst:
+	pdu_ddt_free(&ctx->dst);
+err_free_digest:
+	dma_pool_free(spacc_hash_pool, ctx->digest_buf, ctx->digest_dma);
+
+	return rc;
+}
+
+static void spacc_free_mems(struct spacc_crypto_reqctx *ctx,
+			    struct spacc_crypto_ctx *tctx,
+			    struct ahash_request *req)
+{
+	spacc_hash_cleanup_dma_dst(tctx->dev, req);
+	spacc_hash_cleanup_dma_src(tctx->dev, req);
+
+	if (ctx->final_part_pck) {
+		ctx->final_part_pck = 0;
+		spacc_hash_cleanup_ppp(req);
+	}
+}
+
+static void spacc_digest_cb(void *spacc, void *tfm)
+{
+	struct ahash_cb_data *cb = tfm;
+	int err = -1;
+	int dig_sz;
+
+	dig_sz = crypto_ahash_digestsize(crypto_ahash_reqtfm(cb->req));
+
+	if (cb->ctx->single_shot || cb->ctx->final_part_pck) {
+		if (cb->ctx->single_shot)
+			cb->ctx->single_shot = 0;
+
+		memcpy(cb->req->result, cb->ctx->digest_buf, dig_sz);
+
+		err = cb->spacc->job[cb->new_handle].job_err;
+
+		spacc_free_mems(cb->ctx, cb->tctx, cb->req);
+		spacc_close(cb->spacc, cb->new_handle);
+	} else {
+		memcpy(cb->tctx->digest_ctx_buf, cb->ctx->digest_buf, dig_sz);
+
+		err = cb->spacc->job[cb->new_handle].job_err;
+
+		spacc_free_mems(cb->ctx, cb->tctx, cb->req);
+		spacc_close(cb->spacc, cb->new_handle);
+	}
+
+	/* call complete once at the end */
+	if (cb->req->base.complete)
+		ahash_request_complete(cb->req, err);
+}
+
+static int do_shash(unsigned char *name, unsigned char *result,
+		    const u8 *data1, unsigned int data1_len,
+		    const u8 *data2, unsigned int data2_len,
+		    const u8 *key, unsigned int key_len)
+{
+	int rc;
+	unsigned int size;
+	struct crypto_shash *hash;
+	struct sdesc *sdesc;
+
+	hash = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(hash)) {
+		rc = PTR_ERR(hash);
+		pr_err("ERR: Crypto %s allocation error %d\n", name, rc);
+		return rc;
+	}
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		rc = -ENOMEM;
+		goto do_shash_err;
+	}
+	sdesc->shash.tfm = hash;
+
+	if (key_len > 0) {
+		rc = crypto_shash_setkey(hash, key, key_len);
+		if (rc) {
+			pr_err("ERR: Could not setkey %s shash\n", name);
+			goto do_shash_err;
+		}
+	}
+
+	rc = crypto_shash_init(&sdesc->shash);
+	if (rc) {
+		pr_err("ERR: Could not init %s shash\n", name);
+		goto do_shash_err;
+	}
+
+	rc = crypto_shash_update(&sdesc->shash, data1, data1_len);
+	if (rc) {
+		pr_err("ERR: Could not update1\n");
+		goto do_shash_err;
+	}
+
+	if (data2 && data2_len) {
+		rc = crypto_shash_update(&sdesc->shash, data2, data2_len);
+		if (rc) {
+			pr_err("ERR: Could not update2\n");
+			goto do_shash_err;
+		}
+	}
+
+	rc = crypto_shash_final(&sdesc->shash, result);
+	if (rc)
+		pr_err("ERR: Could not generate %s hash\n", name);
+
+do_shash_err:
+	crypto_free_shash(hash);
+	kfree(sdesc);
+
+	return rc;
+}
+
+static int spacc_hash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			     unsigned int keylen)
+{
+	const struct spacc_alg *salg = spacc_tfm_ahash(&tfm->base);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+	unsigned int digest_size, block_size;
+	int x, rc;
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+
+	block_size = crypto_tfm_alg_blocksize(&tfm->base);
+	digest_size = crypto_ahash_digestsize(tfm);
+
+	/*
+	 * If keylen > hash block len, the key is supposed to be hashed so that
+	 * it is less than the block length. This is kind of a useless
+	 * property of HMAC as you can just use that hash as the key directly.
+	 * We will just not use the hardware in this case to avoid the issue.
+	 * This test was meant for hashes but it works for cmac/xcbc since we
+	 * only intend to support 128-bit keys...
+	 */
+
+	if (keylen > block_size && salg->mode->id != CRYPTO_MODE_MAC_CMAC) {
+		dev_dbg(salg->dev[0], "Exceeds keylen: %u\n", keylen);
+		dev_dbg(salg->dev[0], "Req. keylen hashing %s\n",
+			salg->calg->cra_name);
+
+		memset(hash_alg, 0x00, CRYPTO_MAX_ALG_NAME);
+		switch (salg->mode->id)	{
+		case CRYPTO_MODE_HMAC_SHA224:
+			rc = do_shash("sha224", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA256:
+			rc = do_shash("sha256", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA384:
+			rc = do_shash("sha384", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA512:
+			rc = do_shash("sha512", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		case CRYPTO_MODE_HMAC_MD5:
+			rc = do_shash("md5", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		case CRYPTO_MODE_HMAC_SHA1:
+			rc = do_shash("sha1", tctx->ipad, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+
+		default:
+			return -EINVAL;
+		}
+
+		if (rc < 0) {
+			pr_err("ERR: %d computing shash for %s\n",
+								rc, hash_alg);
+			return -EIO;
+		}
+
+		keylen = digest_size;
+		dev_dbg(salg->dev[0], "updated keylen: %u\n", keylen);
+	} else {
+		memcpy(tctx->ipad, key, keylen);
+	}
+
+	tctx->ctx_valid = false;
+
+	if (salg->mode->sw_fb) {
+		rc = crypto_ahash_setkey(tctx->fb.hash, key, keylen);
+		if (rc < 0)
+			return rc;
+	}
+
+	/* close handle since key size may have changed */
+	if (tctx->handle >= 0) {
+		spacc_close(&priv->spacc, tctx->handle);
+		put_device(tctx->dev);
+		tctx->handle = -1;
+		tctx->dev = NULL;
+	}
+
+	priv = NULL;
+	for (x = 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
+		priv = dev_get_drvdata(salg->dev[x]);
+		tctx->dev = get_device(salg->dev[x]);
+		if (spacc_isenabled(&priv->spacc, salg->mode->id, keylen)) {
+			tctx->handle = spacc_open(&priv->spacc,
+						  CRYPTO_MODE_NULL,
+						  salg->mode->id, -1,
+						  0, spacc_digest_cb, tfm);
+
+		} else
+			pr_debug("  Keylen: %d not enabled for algo: %d",
+							keylen, salg->mode->id);
+
+		if (tctx->handle >= 0)
+			break;
+
+		put_device(salg->dev[x]);
+	}
+
+	if (tctx->handle < 0) {
+		pr_err("ERR: Failed to open SPAcc context\n");
+		dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
+		return -EIO;
+	}
+
+	rc = spacc_set_operation(&priv->spacc, tctx->handle, OP_ENCRYPT,
+				 ICV_HASH, IP_ICV_OFFSET, 0, 0, 0);
+	if (rc < 0) {
+		spacc_close(&priv->spacc, tctx->handle);
+		tctx->handle = -1;
+		put_device(tctx->dev);
+		return -EIO;
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_MAC_XCBC ||
+	    salg->mode->id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		rc = spacc_compute_xcbc_key(&priv->spacc, salg->mode->id,
+					    tctx->handle, tctx->ipad,
+					    keylen, tctx->ipad);
+		if (rc < 0) {
+			dev_warn(tctx->dev,
+				 "Failed to compute XCBC key: %d\n", rc);
+			return -EIO;
+		}
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_HASH_OPERATION, tctx->ipad,
+					 32 + keylen, NULL, 0);
+	} else {
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_HASH_OPERATION, tctx->ipad,
+					 keylen, NULL, 0);
+	}
+
+	memset(tctx->ipad, 0, sizeof(tctx->ipad));
+	if (rc < 0) {
+		pr_err("ERR: Failed to write SPAcc context\n");
+		dev_warn(tctx->dev, "Failed to write SPAcc context %d: %d\n",
+			 tctx->handle, rc);
+
+		/* Non-fatal; we continue with the software fallback. */
+		return 0;
+	}
+
+	tctx->ctx_valid = true;
+
+	return 0;
+}
+
+static int spacc_hash_cra_init(struct crypto_tfm *tfm)
+{
+	const struct spacc_alg *salg = spacc_tfm_ahash(tfm);
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct spacc_priv *priv;
+
+	tctx->handle    = -1;
+	tctx->ctx_valid = false;
+	tctx->flag_ppp  = 0;
+	tctx->dev       = get_device(salg->dev[0]);
+
+	if (salg->mode->sw_fb) {
+		tctx->fb.hash = crypto_alloc_ahash(salg->calg->cra_name, 0,
+						   CRYPTO_ALG_NEED_FALLBACK);
+
+		if (IS_ERR(tctx->fb.hash)) {
+			if (tctx->handle >= 0)
+				spacc_close(&priv->spacc, tctx->handle);
+			put_device(tctx->dev);
+
+			return PTR_ERR(tctx->fb.hash);
+		}
+
+		crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+					 sizeof(struct spacc_crypto_reqctx) +
+					 crypto_ahash_reqsize(tctx->fb.hash));
+
+	} else {
+		crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+					 sizeof(struct spacc_crypto_reqctx));
+	}
+
+	return 0;
+}
+
+static void spacc_hash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	sgl_node_delete();
+	crypto_free_ahash(tctx->fb.hash);
+
+	if (tctx->handle >= 0)
+		spacc_close(&priv->spacc, tctx->handle);
+
+	put_device(tctx->dev);
+}
+
+static int spacc_hash_init(struct ahash_request *req)
+{
+	int x = 0, rc = 0;
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	const struct spacc_alg *salg = spacc_tfm_ahash(&reqtfm->base);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+
+	ctx->digest_buf = NULL;
+
+	ctx->single_shot = 0;
+	ctx->total_nents = 0;
+	ctx->cur_part_pck = 0;
+	ctx->final_part_pck = 0;
+	ctx->rem_len = 0;
+	ctx->rem_nents = 0;
+	ctx->first_ppp_chunk = 1;
+	ctx->small_pck = 1;
+	tctx->ppp_sgl = NULL;
+
+	if (tctx->handle < 0 || !tctx->ctx_valid) {
+		priv = NULL;
+		dev_dbg(tctx->dev, "%s: open SPAcc context\n", __func__);
+
+		for (x = 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
+			priv = dev_get_drvdata(salg->dev[x]);
+			tctx->dev = get_device(salg->dev[x]);
+			if (spacc_isenabled(&priv->spacc, salg->mode->id, 0)) {
+				tctx->handle = spacc_open(&priv->spacc,
+							  CRYPTO_MODE_NULL,
+						salg->mode->id, -1, 0,
+						spacc_digest_cb, reqtfm);
+			}
+
+			if (tctx->handle >= 0)
+				break;
+
+			put_device(salg->dev[x]);
+		}
+
+		if (tctx->handle < 0) {
+			dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
+			goto fallback;
+		}
+
+		rc = spacc_set_operation(&priv->spacc, tctx->handle,
+					 OP_ENCRYPT, ICV_HASH, IP_ICV_OFFSET,
+					 0, 0, 0);
+		if (rc < 0) {
+			spacc_close(&priv->spacc, tctx->handle);
+			dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
+			tctx->handle = -1;
+			put_device(tctx->dev);
+			goto fallback;
+		}
+		tctx->ctx_valid = true;
+	} else {
+		;/* do nothing */
+	}
+
+	/* alloc ppp_sgl */
+	tctx->ppp_sgl = kmalloc(sizeof(*(tctx->ppp_sgl)) * 2, GFP_KERNEL);
+	if (!tctx->ppp_sgl)
+		return -ENOMEM;
+
+	sg_init_table(tctx->ppp_sgl, 2);
+
+	return 0;
+fallback:
+
+	ctx->fb.hash_req.base = req->base;
+	ahash_request_set_tfm(&ctx->fb.hash_req, tctx->fb.hash);
+
+	return crypto_ahash_init(&ctx->fb.hash_req);
+}
+
+static int spacc_hash_final_part_pck(struct ahash_request *req)
+{
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	int rc;
+
+	ctx->final_part_pck = 1;
+
+	/* In all the final calls the data is same as prev update and
+	 * hence we can skip this init dma part and just enQ ddt
+	 * No use in calling initdata, just process remaining bytes in ppp_sgl
+	 * and be done with it.
+	 */
+
+	rc = spacc_hash_init_dma(tctx->dev, req, 1);
+
+	if (rc < 0)
+		return -ENOMEM;
+
+	if (rc == 0)
+		;/* small packet */
+
+	/* enqueue ddt for the remaining bytes of data, everything else
+	 * would have been processed already, req->nbytes need not be
+	 * processed
+	 * Since this will hit only for small pkts, hence the condition
+	 *  ctx->rem_len-req->nbytes for the small pkt len
+	 */
+	if (ctx->rem_len)
+		rc = spacc_packet_enqueue_ddt(&priv->spacc,
+				ctx->acb.new_handle, &ctx->src, &ctx->dst,
+				tctx->ppp_sgl[0].length,
+				0, tctx->ppp_sgl[0].length, 0, 0, 0);
+	else {
+		/* zero msg handling */
+		rc = spacc_packet_enqueue_ddt(&priv->spacc,
+				ctx->acb.new_handle,
+				&ctx->src, &ctx->dst, 0, 0, 0, 0, 0, 0);
+	}
+
+	if (rc < 0) {
+		spacc_hash_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->acb.new_handle);
+
+		if (rc != -EBUSY) {
+			dev_err(tctx->dev, "ERR: Failed to enqueue job: %d\n", rc);
+			return rc;
+		}
+
+		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+	}
+
+	return -EINPROGRESS;
+}
+
+static int spacc_hash_update(struct ahash_request *req)
+{
+	int rc;
+	int nents = sg_nents(req->src);
+	int nbytes = req->nbytes;
+
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	ctx->rem_nents += sg_nents_for_len(req->src, req->nbytes);
+
+	if (!nbytes)
+		return 0;
+
+
+	if (req->src) {
+		/* set partial packet flag */
+		ctx->cur_part_pck++;
+
+		if (ctx->total_nents == 0 && nents > 0) {
+			/* assigned once for a req */
+			ctx->total_nents = nents;
+		}
+	}
+
+	if (tctx->handle < 0 ||
+	    !tctx->ctx_valid ||
+	    nbytes > priv->max_msg_len) {
+		goto fallback;
+	}
+
+	rc = spacc_hash_init_dma(tctx->dev, req, 0);
+	if (rc < 0)
+		goto fallback;
+
+	if (rc == 0)
+		return 0;
+
+	/* assumption: update wont be getting a zero len */
+	rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
+				      &ctx->src, &ctx->dst,
+				      tctx->ppp_sgl[0].length,
+				      0, tctx->ppp_sgl[0].length, 0, 0, 0);
+	if (rc < 0) {
+		spacc_hash_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->acb.new_handle);
+
+		if (rc != -EBUSY) {
+			dev_err(tctx->dev,
+				"ERR: Failed to enqueue job: %d\n", rc);
+			return rc;
+		} else if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+
+		goto fallback;
+	}
+
+	return -EINPROGRESS;
+
+fallback:
+	dev_dbg(tctx->dev, "%s Using SW fallback\n", __func__);
+
+	ctx->fb.hash_req.base.flags = req->base.flags;
+	ctx->fb.hash_req.nbytes = req->nbytes;
+	ctx->fb.hash_req.src = req->src;
+
+	return crypto_ahash_update(&ctx->fb.hash_req);
+}
+
+static int spacc_hash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct ahash_cb_data *acb = &ctx->acb;
+	int err;
+
+	if (tctx->handle < 0 || !tctx->ctx_valid)
+		goto fallback;
+
+	/* a corner case of final, where rem_len is 0, we dont proccess
+	 * that 0-size chunk and send the prev computed hash
+	 */
+	if (ctx->total_nents == ctx->rem_nents && ctx->rem_len == 0 &&
+	    ctx->total_nents != 0) {
+
+		memcpy(req->result, acb->tctx->digest_ctx_buf,
+			crypto_ahash_digestsize(crypto_ahash_reqtfm(acb->req)));
+
+		err = acb->spacc->job[acb->new_handle].job_err;
+
+		/* cleanup everything before exiting on this path */
+		spacc_free_mems(ctx, tctx, req);
+		spacc_close(acb->spacc, acb->new_handle);
+
+		return CRYPTO_OK;
+	}
+
+	if (ctx->total_nents || ctx->small_pck) {
+		err = spacc_hash_final_part_pck(req);
+		/* no returns from here, this is final, process everything
+		 * and copy result/digest and exit from here
+		 */
+
+		if (err == -ENOMEM) {
+			/* Hash init failed */
+			memcpy(req->result, acb->tctx->digest_ctx_buf,
+			crypto_ahash_digestsize(crypto_ahash_reqtfm(acb->req)));
+
+			err = acb->spacc->job[acb->new_handle].job_err;
+			spacc_close(acb->spacc, acb->new_handle);
+			err = CRYPTO_OK;
+		}
+
+		return err;
+	}
+
+	memcpy(req->result, acb->tctx->digest_ctx_buf,
+	       crypto_ahash_digestsize(crypto_ahash_reqtfm(acb->req)));
+
+	err = acb->spacc->job[acb->new_handle].job_err;
+	spacc_close(acb->spacc, acb->new_handle);
+
+	return 0;
+
+fallback:
+	ctx->fb.hash_req.base.flags = req->base.flags;
+	ctx->fb.hash_req.result = req->result;
+
+	return crypto_ahash_final(&ctx->fb.hash_req);
+}
+
+static int spacc_hash_digest(struct ahash_request *req)
+{
+	int final = 0;
+	int rc, total_len;
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	if (tctx->flag_ppp) {
+		/* from finup */
+		ctx->single_shot = 0;
+		ctx->final_part_pck = 1;
+		final = 2;
+	} else {
+		/* direct single shot digest call */
+		ctx->single_shot = 1;
+		ctx->rem_len = 0;
+		ctx->total_nents = sg_nents(req->src);
+	}
+
+	if (tctx->handle < 0 || !tctx->ctx_valid ||
+	    req->nbytes > priv->max_msg_len)
+		goto fallback;
+
+	rc = spacc_hash_init_dma(tctx->dev, req, final);
+	if (rc < 0)
+		goto fallback;
+
+	if (rc == 0)
+		return 0;
+
+	if (final) {
+		if (ctx->total_nents) {
+			/* INIT-UPDATE-UPDATE-FINUP/FINAL */
+			total_len = tctx->ppp_sgl[0].length;
+		} else if (req->src->length == 0 && ctx->total_nents == 0) {
+			/* zero msg handling */
+			total_len = 0;
+		} else {
+			/* handle INIT-FINUP sequence, process req->nbytes */
+			total_len = req->nbytes;
+		}
+
+		rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
+				&ctx->src, &ctx->dst, total_len,
+				0, total_len, 0, 0, 0);
+	} else {
+		rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->acb.new_handle,
+				&ctx->src, &ctx->dst, req->nbytes,
+				0, req->nbytes, 0, 0, 0);
+	}
+
+	if (rc < 0) {
+		spacc_hash_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->acb.new_handle);
+
+		if (rc != -EBUSY) {
+			pr_debug("Failed to enqueue job, ERR: %d\n", rc);
+			return rc;
+		}
+
+		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+
+		goto fallback;
+	}
+
+	return -EINPROGRESS;
+
+fallback:
+	/* Start from scratch as init is not called before digest */
+	ctx->fb.hash_req.base = req->base;
+	ahash_request_set_tfm(&ctx->fb.hash_req, tctx->fb.hash);
+
+	ctx->fb.hash_req.nbytes = total_len;
+	ctx->fb.hash_req.src = req->src;
+	ctx->fb.hash_req.result = req->result;
+
+	return crypto_ahash_digest(&ctx->fb.hash_req);
+}
+
+static int spacc_hash_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
+	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+	int rc;
+
+	if (tctx->handle < 0 || !tctx->ctx_valid)
+		goto fallback;
+
+	/* set this flag for rem_len usage */
+	tctx->flag_ppp = 1;
+	rc = spacc_hash_digest(req);
+	return rc;
+
+fallback:
+	ctx->fb.hash_req.base.flags = req->base.flags;
+	ctx->fb.hash_req.nbytes     = req->nbytes;
+	ctx->fb.hash_req.src        = req->src;
+	ctx->fb.hash_req.result     = req->result;
+
+	return crypto_ahash_finup(&ctx->fb.hash_req);
+}
+
+static int spacc_hash_import(struct ahash_request *req, const void *in)
+{
+	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(ctx, in, sizeof(*ctx));
+
+	return 0;
+}
+
+static int spacc_hash_export(struct ahash_request *req, void *out)
+{
+	const struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(out, ctx, sizeof(*ctx));
+
+	return 0;
+}
+
+const struct ahash_alg spacc_hash_template = {
+	.init   = spacc_hash_init,
+	.update = spacc_hash_update,
+	.final  = spacc_hash_final,
+	.finup  = spacc_hash_finup,
+	.digest = spacc_hash_digest,
+	.setkey = spacc_hash_setkey,
+	.export = spacc_hash_export,
+	.import = spacc_hash_import,
+
+	.halg.base = {
+		.cra_priority	= 300,
+		.cra_module	= THIS_MODULE,
+		.cra_init	= spacc_hash_cra_init,
+		.cra_exit	= spacc_hash_cra_exit,
+		.cra_ctxsize	= sizeof(struct spacc_crypto_ctx),
+		.cra_flags	= CRYPTO_ALG_TYPE_AHASH    |
+				  CRYPTO_ALG_ASYNC	   |
+				  CRYPTO_ALG_NEED_FALLBACK |
+				  CRYPTO_ALG_OPTIONAL_KEY
+	},
+};
+
+static int spacc_register_hash(struct spacc_alg *salg)
+{
+	int rc;
+
+	salg->calg = &salg->alg.hash.halg.base;
+	salg->alg.hash = spacc_hash_template;
+
+	spacc_init_calg(salg->calg, salg->mode);
+	salg->alg.hash.halg.digestsize = salg->mode->hashlen;
+	salg->alg.hash.halg.statesize = sizeof(struct spacc_crypto_reqctx);
+
+	rc = crypto_register_ahash(&salg->alg.hash);
+	if (rc < 0)
+		return rc;
+
+	mutex_lock(&spacc_hash_alg_mutex);
+	list_add(&salg->list, &spacc_hash_alg_list);
+	mutex_unlock(&spacc_hash_alg_mutex);
+
+	return 0;
+}
+
+int probe_hashes(struct platform_device *spacc_pdev)
+{
+	int rc;
+	unsigned int i;
+	int registered = 0;
+	struct spacc_alg *salg;
+	struct spacc_priv *priv = dev_get_drvdata(&spacc_pdev->dev);
+
+	spacc_hash_pool = dma_pool_create("spacc-digest", &spacc_pdev->dev,
+					  SPACC_MAX_DIGEST_SIZE,
+					  SPACC_DMA_ALIGN, SPACC_DMA_BOUNDARY);
+
+	if (!spacc_hash_pool)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(possible_hashes); i++)
+		possible_hashes[i].valid = 0;
+
+	for (i = 0; i < ARRAY_SIZE(possible_hashes); i++) {
+		if (possible_hashes[i].valid == 0 &&
+		       spacc_isenabled(&priv->spacc,
+				       possible_hashes[i].id & 0xFF,
+				       possible_hashes[i].hashlen)) {
+
+			salg = kmalloc(sizeof(*salg), GFP_KERNEL);
+			if (!salg)
+				return -ENOMEM;
+
+			salg->mode = &possible_hashes[i];
+
+			/* Copy all dev's over to the salg */
+			salg->dev[0] = &spacc_pdev->dev;
+			salg->dev[1] = NULL;
+
+			rc = spacc_register_hash(salg);
+			if (rc < 0) {
+				kfree(salg);
+				continue;
+			}
+			dev_dbg(&spacc_pdev->dev, "registered %s\n",
+				 possible_hashes[i].name);
+
+			registered++;
+			possible_hashes[i].valid = 1;
+		}
+	}
+
+	return registered;
+}
+
+int spacc_unregister_hash_algs(void)
+{
+	struct spacc_alg *salg, *tmp;
+
+	mutex_lock(&spacc_hash_alg_mutex);
+	list_for_each_entry_safe(salg, tmp, &spacc_hash_alg_list, list) {
+		crypto_unregister_alg(salg->calg);
+		list_del(&salg->list);
+		kfree(salg);
+	}
+	mutex_unlock(&spacc_hash_alg_mutex);
+
+	dma_pool_destroy(spacc_hash_pool);
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
new file mode 100644
index 000000000000..94bf138eb86d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -0,0 +1,3046 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include "spacc_hal.h"
+#include "spacc_core.h"
+
+static const u8 spacc_ctrl_map[SPACC_CTRL_VER_SIZE][SPACC_CTRL_MAPSIZE] = {
+	{ 0, 8, 4, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 8, 3, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 4, 8, 13, 15, 16, 24, 25, 26, 27, 28, 29, 30, 31 }
+};
+
+static const int keysizes[2][7] = {
+	/*   1    2   4   8  16  32   64 */
+	{ 5,   8, 16, 24, 32,  0,   0 },  /* cipher key sizes*/
+	{ 8,  16, 20, 24, 32, 64, 128 },  /* hash key sizes*/
+};
+
+
+/* bits are 40, 64, 128, 192, 256, and top bit for hash */
+static const unsigned char template[] = {
+	[CRYPTO_MODE_NULL]            = 0,
+	[CRYPTO_MODE_AES_ECB]         = 28,/*  AESECB 128/224/256*/
+	[CRYPTO_MODE_AES_CBC]         = 28,/*  AESCBC 128/224/256*/
+	[CRYPTO_MODE_AES_CTR]         = 28,/*  AESCTR 128/224/256*/
+	[CRYPTO_MODE_AES_CCM]         = 28,/*  AESCCM 128/224/256*/
+	[CRYPTO_MODE_AES_GCM]         = 28,/*  AESGCM 128/224/256*/
+	[CRYPTO_MODE_AES_F8]          = 28,/*  AESF8  128/224/256*/
+	[CRYPTO_MODE_AES_XTS]         = 20,/* AESXTS 128/256*/
+	[CRYPTO_MODE_AES_CFB]         = 28,/* AESCFB 128/224/256*/
+	[CRYPTO_MODE_AES_OFB]         = 28,/* AESOFB 128/224/256*/
+	[CRYPTO_MODE_AES_CS1]         = 28,/* AESCS1 128/224/256*/
+	[CRYPTO_MODE_AES_CS2]         = 28,/* AESCS2 128/224/256*/
+	[CRYPTO_MODE_AES_CS3]         = 28,/* AESCS3 128/224/256*/
+	[CRYPTO_MODE_MULTI2_ECB]      = 0, /* MULTI2*/
+	[CRYPTO_MODE_MULTI2_CBC]      = 0, /* MULTI2*/
+	[CRYPTO_MODE_MULTI2_OFB]      = 0, /* MULTI2*/
+	[CRYPTO_MODE_MULTI2_CFB]      = 0, /* MULTI2*/
+	[CRYPTO_MODE_3DES_CBC]        = 8, /* 3DES CBC*/
+	[CRYPTO_MODE_3DES_ECB]        = 8, /* 3DES ECB*/
+	[CRYPTO_MODE_DES_CBC]         = 2, /* DES CBC*/
+	[CRYPTO_MODE_DES_ECB]         = 2, /* DES ECB*/
+	[CRYPTO_MODE_KASUMI_ECB]      = 4, /* KASUMI ECB*/
+	[CRYPTO_MODE_KASUMI_F8]       = 4, /* KASUMI F8*/
+	[CRYPTO_MODE_SNOW3G_UEA2]     = 4, /* SNOW3G*/
+	[CRYPTO_MODE_ZUC_UEA3]        = 4, /* ZUC*/
+	[CRYPTO_MODE_CHACHA20_STREAM] = 16, /* CHACHA20*/
+	[CRYPTO_MODE_CHACHA20_POLY1305] = 16, /* CHACHA20*/
+	[CRYPTO_MODE_SM4_ECB]         = 4, /* SM4ECB 128*/
+	[CRYPTO_MODE_SM4_CBC]         = 4, /* SM4CBC 128*/
+	[CRYPTO_MODE_SM4_CFB]         = 4, /* SM4CFB 128*/
+	[CRYPTO_MODE_SM4_OFB]         = 4, /* SM4OFB 128*/
+	[CRYPTO_MODE_SM4_CTR]         = 4,  /* SM4CTR 128*/
+	[CRYPTO_MODE_SM4_CCM]         = 4, /* SM4CCM 128*/
+	[CRYPTO_MODE_SM4_GCM]         = 4, /* SM4GCM 128*/
+	[CRYPTO_MODE_SM4_F8]          = 4, /* SM4F8  128*/
+	[CRYPTO_MODE_SM4_XTS]         = 4, /* SM4XTS 128*/
+	[CRYPTO_MODE_SM4_CS1]         = 4, /* SM4CS1 128*/
+	[CRYPTO_MODE_SM4_CS2]         = 4, /* SM4CS2 128*/
+	[CRYPTO_MODE_SM4_CS3]         = 4, /* SM4CS3 128*/
+
+	[CRYPTO_MODE_HASH_MD5]        = 242,
+	[CRYPTO_MODE_HMAC_MD5]        = 242,
+	[CRYPTO_MODE_HASH_SHA1]       = 242,
+	[CRYPTO_MODE_HMAC_SHA1]       = 242,
+	[CRYPTO_MODE_HASH_SHA224]     = 242,
+	[CRYPTO_MODE_HMAC_SHA224]     = 242,
+	[CRYPTO_MODE_HASH_SHA256]     = 242,
+	[CRYPTO_MODE_HMAC_SHA256]     = 242,
+	[CRYPTO_MODE_HASH_SHA384]     = 242,
+	[CRYPTO_MODE_HMAC_SHA384]     = 242,
+	[CRYPTO_MODE_HASH_SHA512]     = 242,
+	[CRYPTO_MODE_HMAC_SHA512]     = 242,
+	[CRYPTO_MODE_HASH_SHA512_224] = 242,
+	[CRYPTO_MODE_HMAC_SHA512_224] = 242,
+	[CRYPTO_MODE_HASH_SHA512_256] = 242,
+	[CRYPTO_MODE_HMAC_SHA512_256] = 242,
+	[CRYPTO_MODE_MAC_XCBC]        = 154, /* XCBC*/
+	[CRYPTO_MODE_MAC_CMAC]        = 154, /* CMAC*/
+	[CRYPTO_MODE_MAC_KASUMI_F9]   = 130, /* KASUMI*/
+	[CRYPTO_MODE_MAC_SNOW3G_UIA2] = 130, /* SNOW*/
+	[CRYPTO_MODE_MAC_ZUC_UIA3]    = 130, /* ZUC*/
+	[CRYPTO_MODE_MAC_POLY1305]    = 144,
+	[CRYPTO_MODE_SSLMAC_MD5]      = 130,
+	[CRYPTO_MODE_SSLMAC_SHA1]     = 132,
+	[CRYPTO_MODE_HASH_CRC32]      = 0,
+	[CRYPTO_MODE_MAC_MICHAEL]     = 129,
+
+	[CRYPTO_MODE_HASH_SHA3_224]   = 242,
+	[CRYPTO_MODE_HASH_SHA3_256]   = 242,
+	[CRYPTO_MODE_HASH_SHA3_384]   = 242,
+	[CRYPTO_MODE_HASH_SHA3_512]   = 242,
+	[CRYPTO_MODE_HASH_SHAKE128]   = 242,
+	[CRYPTO_MODE_HASH_SHAKE256]   = 242,
+	[CRYPTO_MODE_HASH_CSHAKE128]  = 130,
+	[CRYPTO_MODE_HASH_CSHAKE256]  = 130,
+	[CRYPTO_MODE_MAC_KMAC128]     = 242,
+	[CRYPTO_MODE_MAC_KMAC256]     = 242,
+	[CRYPTO_MODE_MAC_KMACXOF128]  = 242,
+	[CRYPTO_MODE_MAC_KMACXOF256]  = 242,
+	[CRYPTO_MODE_HASH_SM3]        = 242,
+	[CRYPTO_MODE_HMAC_SM3]        = 242,
+	[CRYPTO_MODE_MAC_SM4_XCBC]    = 242,
+	[CRYPTO_MODE_MAC_SM4_CMAC]    = 242,
+};
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
+static const struct {
+	unsigned int min_version;
+	struct {
+		int outlen;
+		unsigned char data[64];
+	} test[7];
+} testdata[CRYPTO_MODE_LAST] = {
+	/* NULL*/
+	{ .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* AES_ECB*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data = { 0xc6, 0xa1, 0x3b, 0x37,
+			0x87, 0x8f, 0x5b, 0x82, 0x6f, 0x4f, 0x81, 0x62, 0xa1,
+			0xc8, 0xd8, 0x79,  },
+		.test[3].outlen = 16, .test[3].data = { 0x91, 0x62, 0x51, 0x82,
+			0x1c, 0x73, 0xa5, 0x22, 0xc3, 0x96, 0xd6, 0x27, 0x38,
+			0x01, 0x96, 0x07,  },
+		.test[4].outlen = 16, .test[4].data = { 0xf2, 0x90, 0x00, 0xb6,
+			0x2a, 0x49, 0x9f, 0xd0, 0xa9, 0xf3, 0x9a, 0x6a, 0xdd,
+			0x2e, 0x77, 0x80,  },
+	},
+
+	/* AES_CBC*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data = { 0x0a, 0x94, 0x0b, 0xb5,
+			0x41, 0x6e, 0xf0, 0x45, 0xf1, 0xc3, 0x94, 0x58, 0xc6,
+			0x53, 0xea, 0x5a,  },
+		.test[3].outlen = 16, .test[3].data = { 0x00, 0x60, 0xbf, 0xfe,
+			0x46, 0x83, 0x4b, 0xb8, 0xda, 0x5c, 0xf9, 0xa6, 0x1f,
+			0xf2, 0x20, 0xae,  },
+		.test[4].outlen = 16, .test[4].data = { 0x5a, 0x6e, 0x04, 0x57,
+			0x08, 0xfb, 0x71, 0x96, 0xf0, 0x2e, 0x55, 0x3d, 0x02,
+			0xc3, 0xa6, 0x92,  },
+	},
+
+	/* AES_CTR*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data = { 0x0a, 0x94, 0x0b, 0xb5,
+			0x41, 0x6e, 0xf0, 0x45, 0xf1, 0xc3, 0x94, 0x58, 0xc6,
+			0x53, 0xea, 0x5a,  },
+		.test[3].outlen = 16, .test[3].data = { 0x00, 0x60, 0xbf, 0xfe,
+			0x46, 0x83, 0x4b, 0xb8, 0xda, 0x5c, 0xf9, 0xa6, 0x1f,
+			0xf2, 0x20, 0xae,  },
+		.test[4].outlen = 16, .test[4].data = { 0x5a, 0x6e, 0x04, 0x57,
+			0x08, 0xfb, 0x71, 0x96, 0xf0, 0x2e, 0x55, 0x3d, 0x02,
+			0xc3, 0xa6, 0x92,  },
+	},
+
+	/* AES_CCM*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 32, .test[2].data = { 0x02, 0x63, 0xec, 0x94,
+			0x66, 0x18, 0x72, 0x96, 0x9a, 0xda, 0xfd, 0x0f, 0x4b,
+			0xa4, 0x0f, 0xdc, 0xa5, 0x09, 0x92, 0x93, 0xb6, 0xb4,
+			0x38, 0x34, 0x63, 0x72, 0x50, 0x4c, 0xfc, 0x8a, 0x63,
+			0x02,  },
+		.test[3].outlen = 32, .test[3].data = { 0x29, 0xf7, 0x63, 0xe8,
+			0xa1, 0x75, 0xc6, 0xbf, 0xa5, 0x54, 0x94, 0x89, 0x12,
+			0x84, 0x45, 0xf5, 0x9b, 0x27, 0xeb, 0xb1, 0xa4, 0x65,
+			0x93, 0x6e, 0x5a, 0xc0, 0xa2, 0xa3, 0xe2, 0x6c, 0x46,
+			0x29,  },
+		.test[4].outlen = 32, .test[4].data = { 0x60, 0xf3, 0x10, 0xd5,
+			0xc3, 0x85, 0x58, 0x5d, 0x55, 0x16, 0xfb, 0x51, 0x72,
+			0xe5, 0x20, 0xcf, 0x8e, 0x87, 0x6d, 0x72, 0xc8, 0x44,
+			0xbe, 0x6d, 0xa2, 0xd6, 0xf4, 0xba, 0xec, 0xb4, 0xec,
+			0x39,  },
+	},
+
+	/* AES_GCM*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 32, .test[2].data = { 0x93, 0x6c, 0xa7, 0xce,
+			0x66, 0x1b, 0xf7, 0x54, 0x4b, 0xd2, 0x61, 0x8a, 0x36,
+			0xa3, 0x70, 0x08, 0xc0, 0xd7, 0xd0, 0x77, 0xc5, 0x64,
+			0x76, 0xdb, 0x48, 0x4a, 0x53, 0xe3, 0x6c, 0x93, 0x34,
+			0x0f,  },
+		.test[3].outlen = 32, .test[3].data = { 0xe6, 0xf9, 0x22, 0x9b,
+			0x99, 0xb9, 0xc9, 0x0e, 0xd0, 0x33, 0xdc, 0x82, 0xff,
+			0xa9, 0xdc, 0x70, 0x4c, 0xcd, 0xc4, 0x1b, 0xa3, 0x5a,
+			0x87, 0x5d, 0xd8, 0xef, 0xb6, 0x48, 0xbb, 0x0c, 0x92,
+			0x60,  },
+		.test[4].outlen = 32, .test[4].data = { 0x47, 0x02, 0xd6, 0x1b,
+			0xc5, 0xe5, 0xc2, 0x1b, 0x8d, 0x41, 0x97, 0x8b, 0xb1,
+			0xe9, 0x78, 0x6d, 0x48, 0x6f, 0x78, 0x81, 0xc7, 0x98,
+			0xcc, 0xf5, 0x28, 0xf1, 0x01, 0x7c, 0xe8, 0xf6, 0x09,
+			0x78,  },
+	},
+
+	/* AES-F8*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* AES-XTS*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 32, .test[2].data = { 0xa0, 0x1a, 0x6f, 0x09,
+			0xfa, 0xef, 0xd2, 0x72, 0xc3, 0x9b, 0xad, 0x35, 0x52,
+			0xfc, 0xa1, 0xcb, 0x33, 0x69, 0x51, 0xc5, 0x23, 0xbe,
+			0xac, 0xa5, 0x4a, 0xf2, 0xfc, 0x77, 0x71, 0x6f, 0x9a,
+			0x86,  },
+		.test[4].outlen = 32, .test[4].data = { 0x05, 0x45, 0x91, 0x86,
+			0xf2, 0x2d, 0x97, 0x93, 0xf3, 0xa0, 0xbb, 0x29, 0xc7,
+			0x9c, 0xc1, 0x4c, 0x3b, 0x8f, 0xdd, 0x9d, 0xda, 0xc7,
+			0xb5, 0xaa, 0xc2, 0x7c, 0x2e, 0x71, 0xce, 0x7f, 0xce,
+			0x0e,  },
+	},
+
+	/* AES-CFB*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* AES-OFB*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* AES-CS1*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 31, .test[2].data = { 0x0a, 0x94, 0x0b, 0xb5,
+			0x41, 0x6e, 0xf0, 0x45, 0xf1, 0xc3, 0x94, 0x58, 0xc6,
+			0x53, 0xea, 0xae, 0xe7, 0x1e, 0xa5, 0x41, 0xd7, 0xae,
+			0x4b, 0xeb, 0x60, 0xbe, 0xcc, 0x59, 0x3f, 0xb6, 0x63,
+		},
+		.test[3].outlen = 31, .test[3].data = { 0x00, 0x60, 0xbf, 0xfe,
+			0x46, 0x83, 0x4b, 0xb8, 0xda, 0x5c, 0xf9, 0xa6, 0x1f,
+			0xf2, 0x20, 0x2e, 0x84, 0xcb, 0x12, 0xa3, 0x59, 0x17,
+			0xb0, 0x9e, 0x25, 0xa2, 0xa2, 0x3d, 0xf1, 0x9f, 0xdc,
+		},
+		.test[4].outlen = 31, .test[4].data = { 0x5a, 0x6e, 0x04, 0x57,
+			0x08, 0xfb, 0x71, 0x96, 0xf0, 0x2e, 0x55, 0x3d, 0x02,
+			0xc3, 0xa6, 0xcd, 0xfc, 0x25, 0x35, 0x31, 0x0b, 0xf5,
+			0x6b, 0x2e, 0xb7, 0x8a, 0xa2, 0x5a, 0xdd, 0x77, 0x51,
+		},
+	},
+
+	/* AES-CS2*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 31, .test[2].data = { 0xae, 0xe7, 0x1e, 0xa5,
+			0x41, 0xd7, 0xae, 0x4b, 0xeb, 0x60, 0xbe, 0xcc, 0x59,
+			0x3f, 0xb6, 0x63, 0x0a, 0x94, 0x0b, 0xb5, 0x41, 0x6e,
+			0xf0, 0x45, 0xf1, 0xc3, 0x94, 0x58, 0xc6, 0x53, 0xea,
+		},
+		.test[3].outlen = 31, .test[3].data = { 0x2e, 0x84, 0xcb, 0x12,
+			0xa3, 0x59, 0x17, 0xb0, 0x9e, 0x25, 0xa2, 0xa2, 0x3d,
+			0xf1, 0x9f, 0xdc, 0x00, 0x60, 0xbf, 0xfe, 0x46, 0x83,
+			0x4b, 0xb8, 0xda, 0x5c, 0xf9, 0xa6, 0x1f, 0xf2, 0x20,
+		},
+		.test[4].outlen = 31, .test[4].data = { 0xcd, 0xfc, 0x25, 0x35,
+			0x31, 0x0b, 0xf5, 0x6b, 0x2e, 0xb7, 0x8a, 0xa2, 0x5a,
+			0xdd, 0x77, 0x51, 0x5a, 0x6e, 0x04, 0x57, 0x08, 0xfb,
+			0x71, 0x96, 0xf0, 0x2e, 0x55, 0x3d, 0x02, 0xc3, 0xa6,
+		},
+	},
+
+	/* AES-CS3*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 31, .test[2].data = { 0xae, 0xe7, 0x1e, 0xa5,
+			0x41, 0xd7, 0xae, 0x4b, 0xeb, 0x60, 0xbe, 0xcc, 0x59,
+			0x3f, 0xb6, 0x63, 0x0a, 0x94, 0x0b, 0xb5, 0x41, 0x6e,
+			0xf0, 0x45, 0xf1, 0xc3, 0x94, 0x58, 0xc6, 0x53, 0xea,
+		},
+		.test[3].outlen = 31, .test[3].data = { 0x2e, 0x84, 0xcb, 0x12,
+			0xa3, 0x59, 0x17, 0xb0, 0x9e, 0x25, 0xa2, 0xa2, 0x3d,
+			0xf1, 0x9f, 0xdc, 0x00, 0x60, 0xbf, 0xfe, 0x46, 0x83,
+			0x4b, 0xb8, 0xda, 0x5c, 0xf9, 0xa6, 0x1f, 0xf2, 0x20,
+		},
+		.test[4].outlen = 31, .test[4].data = { 0xcd, 0xfc, 0x25, 0x35,
+			0x31, 0x0b, 0xf5, 0x6b, 0x2e, 0xb7, 0x8a, 0xa2, 0x5a,
+			0xdd, 0x77, 0x51, 0x5a, 0x6e, 0x04, 0x57, 0x08, 0xfb,
+			0x71, 0x96, 0xf0, 0x2e, 0x55, 0x3d, 0x02, 0xc3, 0xa6,
+		},
+	},
+
+	/* MULTI2*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* 3DES_CBC*/
+	{  .min_version = 0x65,
+		.test[3].outlen = 16, .test[3].data = { 0x58, 0xed, 0x24, 0x8f,
+			0x77, 0xf6, 0xb1, 0x9e, 0x47, 0xd9, 0xb7, 0x4a, 0x4f,
+			0x5a, 0xe6, 0x6d,  }
+	},
+
+	/* 3DES_ECB*/
+	{  .min_version = 0x65,
+		.test[3].outlen = 16, .test[3].data = { 0x89, 0x4b, 0xc3, 0x08,
+			0x54, 0x26, 0xa4, 0x41, 0x89, 0x4b, 0xc3, 0x08, 0x54,
+			0x26, 0xa4, 0x41,  }
+	},
+
+	/* DES_CBC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0xe1, 0xb2, 0x46, 0xe5,
+			0xa7, 0xc7, 0x4c, 0xbc, 0xd5, 0xf0, 0x8e, 0x25, 0x3b,
+			0xfa, 0x23, 0x80,  }
+	},
+
+	/* DES_ECB*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0xa5, 0x17, 0x3a,
+			0xd5, 0x95, 0x7b, 0x43, 0x70, 0xa5, 0x17, 0x3a, 0xd5,
+			0x95, 0x7b, 0x43, 0x70,  }
+	},
+
+	/* KASUMI_ECB*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x04, 0x7d, 0x5d,
+			0x2c, 0x8c, 0x2e, 0x91, 0xb3, 0x04, 0x7d, 0x5d, 0x2c,
+			0x8c, 0x2e, 0x91, 0xb3,  } },
+
+	/* KASUMI_F8*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0xfc, 0xf7, 0x45,
+			0xee, 0x1d, 0xbb, 0xa4, 0x57, 0xa7, 0x45, 0xdc, 0x6b,
+			0x2a, 0x1b, 0x50, 0x88,  }
+	},
+
+	/* SNOW3G UEA2*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x95, 0xd3, 0xc8,
+			0x13, 0xc0, 0x20, 0x24, 0xa3, 0x76, 0x24, 0xd1, 0x98,
+			0xb6, 0x67, 0x4d, 0x4c,  }
+	},
+
+	/* ZUC UEA3*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0xda, 0xdf, 0xb6,
+			0xa2, 0xac, 0x9d, 0xba, 0xfe, 0x18, 0x9c, 0x0c, 0x75,
+			0x79, 0xc6, 0xe0, 0x4e,  }
+	},
+
+	/* CHACHA20_STREAM*/
+	{  .min_version = 0x65,
+		.test[4].outlen = 16, .test[4].data =  { 0x55, 0xdf, 0x91,
+			0xe9, 0x27, 0x01, 0x37, 0x69, 0xdb, 0x38, 0xd4, 0x28,
+			0x01, 0x79, 0x76, 0x64 }
+	},
+
+	/* CHACHA20_POLY1305 (AEAD)*/
+	{  .min_version = 0x65,
+		.test[4].outlen = 16, .test[4].data =  { 0x89, 0xfb, 0x08,
+			0x00, 0x29, 0x17, 0xa5, 0x40, 0xb7, 0x83, 0x3f, 0xf3,
+			0x98, 0x1d, 0x0e, 0x63 }
+	},
+
+	/* SM4_ECB 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x1e, 0x96, 0x34,
+			0xb7, 0x70, 0xf9, 0xae, 0xba, 0xa9, 0x34, 0x4f, 0x5a,
+			0xff, 0x9f, 0x82, 0xa3 }
+	},
+
+	/* SM4_CBC 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x8f, 0x78, 0x76,
+			0x3e, 0xe0, 0x60, 0x13, 0xe0, 0xb7, 0x62, 0x2c, 0x42,
+			0x8f, 0xd0, 0x52, 0x8d }
+	},
+
+	/* SM4_CFB 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x8f, 0x78, 0x76,
+			0x3e, 0xe0, 0x60, 0x13, 0xe0, 0xb7, 0x62, 0x2c, 0x42,
+			0x8f, 0xd0, 0x52, 0x8d }
+	},
+
+	 /* SM4_OFB 128*/
+	 {  .min_version = 0x65,
+	 .test[2].outlen = 16, .test[2].data =  { 0x8f, 0x78, 0x76, 0x3e, 0xe0,
+		 0x60, 0x13, 0xe0, 0xb7, 0x62, 0x2c, 0x42, 0x8f, 0xd0, 0x52,
+		 0x8d }
+	 },
+
+	 /* SM4_CTR 128*/
+	 {  .min_version = 0x65,
+	 .test[2].outlen = 16, .test[2].data =  { 0x8f, 0x78, 0x76, 0x3e, 0xe0,
+		 0x60, 0x13, 0xe0, 0xb7, 0x62, 0x2c, 0x42, 0x8f, 0xd0, 0x52,
+		 0x8d }
+	 },
+
+	/* SM4_CCM 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x8e, 0x25, 0x5a,
+			0x13, 0xc7, 0x43, 0x4d, 0x95, 0xef, 0x14, 0x15, 0x11,
+			0xd0, 0xb9, 0x60, 0x5b }
+	},
+
+	/* SM4_GCM 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x97, 0x46, 0xde,
+			0xfb, 0xc9, 0x6a, 0x85, 0x00, 0xff, 0x9c, 0x74, 0x4d,
+			0xd1, 0xbb, 0xf9, 0x66 }
+	},
+
+	/* SM4_F8 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x77, 0x30, 0xff,
+			0x70, 0x46, 0xbc, 0xf4, 0xe3, 0x11, 0xf6, 0x27, 0xe2,
+			0xff, 0xd7, 0xc4, 0x2e }
+	},
+
+	/* SM4_XTS 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x05, 0x3f, 0xb6,
+			0xe9, 0xb1, 0xff, 0x09, 0x4f, 0x9d, 0x69, 0x4d, 0xc2,
+			0xb6, 0xa1, 0x15, 0xde }
+	},
+
+	/* SM4_CS1 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0x8f, 0x78, 0x76,
+			0x3e, 0xe0, 0x60, 0x13, 0xe0, 0xb7, 0x62, 0x2c, 0x42,
+			0x8f, 0xd0, 0x52, 0xa0 }
+	},
+
+	/* SM4_CS2 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0xa0, 0x1c, 0xfe,
+			0x91, 0xaa, 0x7e, 0xf1, 0x75, 0x6a, 0xe8, 0xbc, 0xe1,
+			0x55, 0x08, 0xda, 0x71 }
+	},
+
+	/* SM4_CS3 128*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 16, .test[2].data =  { 0xa0, 0x1c, 0xfe,
+			0x91, 0xaa, 0x7e, 0xf1, 0x75, 0x6a, 0xe8, 0xbc, 0xe1,
+			0x55, 0x08, 0xda, 0x71 }
+	},
+
+	/* hashes ... note they use the 2nd keysize
+	 * array so the indecies mean different sizes!!!
+	 */
+
+	/* MD5 HASH/HMAC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0x70, 0xbc, 0x8f, 0x4b,
+			0x72, 0xa8, 0x69, 0x21, 0x46, 0x8b, 0xf8, 0xe8, 0x44,
+			0x1d, 0xce, 0x51,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0xb6, 0x39, 0xc8, 0x73,
+			0x16, 0x38, 0x61, 0x8b, 0x70, 0x79, 0x72, 0xaa, 0x6e,
+			0x96, 0xcf, 0x90,  },
+		.test[4].outlen = 16, .test[4].data = { 0xb7, 0x79, 0x68, 0xea,
+			0x17, 0x32, 0x1e, 0x32, 0x13, 0x90, 0x6c, 0x2e, 0x9f,
+			0xd5, 0xc8, 0xb3,  },
+		.test[5].outlen = 16, .test[5].data = { 0x80, 0x3e, 0x0a, 0x2f,
+			0x8a, 0xd8, 0x31, 0x8f, 0x8e, 0x12, 0x28, 0x86, 0x22,
+			0x59, 0x6b, 0x05,  },
+	},
+	/* SHA1*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 20, .test[1].data = { 0xde, 0x8a, 0x84, 0x7b,
+			0xff, 0x8c, 0x34, 0x3d, 0x69, 0xb8, 0x53, 0xa2, 0x15,
+			0xe6, 0xee, 0x77, 0x5e, 0xf2, 0xef, 0x96,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 20, .test[1].data = { 0xf8, 0x54, 0x60, 0x50,
+			0x49, 0x56, 0xd1, 0xcd, 0x55, 0x5c, 0x5d, 0xcd, 0x24,
+			0x33, 0xbf, 0xdc, 0x5c, 0x99, 0x54, 0xc8,  },
+		.test[4].outlen = 20, .test[4].data = { 0x66, 0x3f, 0x3a, 0x3c,
+			0x08, 0xb6, 0x87, 0xb2, 0xd3, 0x0c, 0x5a, 0xa7, 0xcc,
+			0x5c, 0xc3, 0x99, 0xb2, 0xb4, 0x58, 0x55,  },
+		.test[5].outlen = 20, .test[5].data = { 0x9a, 0x28, 0x54, 0x2f,
+			0xaf, 0xa7, 0x0b, 0x37, 0xbe, 0x2d, 0x3e, 0xd9, 0xd4,
+			0x70, 0xbc, 0xdc, 0x0b, 0x54, 0x20, 0x06,  },
+	},
+	/* SHA224_HASH*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 28, .test[1].data = { 0xb3, 0x38, 0xc7, 0x6b,
+			0xcf, 0xfa, 0x1a, 0x0b, 0x3e, 0xad, 0x8d, 0xe5, 0x8d,
+			0xfb, 0xff, 0x47, 0xb6, 0x3a, 0xb1, 0x15, 0x0e, 0x10,
+			0xd8, 0xf1, 0x7f, 0x2b, 0xaf, 0xdf,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 28, .test[1].data = { 0xf3, 0xb4, 0x33, 0x78,
+			0x53, 0x4c, 0x0c, 0x4a, 0x1e, 0x31, 0xc2, 0xce, 0xda,
+			0xc8, 0xfe, 0x74, 0x4a, 0xd2, 0x9b, 0x7c, 0x1d, 0x2f,
+			0x5e, 0xa1, 0xaa, 0x31, 0xb9, 0xf5,  },
+		.test[4].outlen = 28, .test[4].data = { 0x4b, 0x6b, 0x3f, 0x9a,
+			0x66, 0x47, 0x45, 0xe2, 0x60, 0xc9, 0x53, 0x86, 0x7a,
+			0x34, 0x65, 0x7d, 0xe2, 0x24, 0x06, 0xcc, 0xf9, 0x17,
+			0x20, 0x5d, 0xc2, 0xb6, 0x97, 0x9a,  },
+		.test[5].outlen = 28, .test[5].data = { 0x90, 0xb0, 0x6e, 0xee,
+			0x21, 0x57, 0x38, 0xc7, 0x65, 0xbb, 0x9a, 0xf5, 0xb4,
+			0x31, 0x0a, 0x0e, 0xe5, 0x64, 0xc4, 0x49, 0x9d, 0xbd,
+			0xe9, 0xf7, 0xac, 0x9f, 0xf8, 0x05,  },
+	},
+
+	/* SHA256_HASH*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data = { 0x66, 0x68, 0x7a, 0xad,
+			0xf8, 0x62, 0xbd, 0x77, 0x6c, 0x8f, 0xc1, 0x8b, 0x8e,
+			0x9f, 0x8e, 0x20, 0x08, 0x97, 0x14, 0x85, 0x6e, 0xe2,
+			0x33, 0xb3, 0x90, 0x2a, 0x59, 0x1d, 0x0d, 0x5f, 0x29,
+			0x25,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data = { 0x75, 0x40, 0x84, 0x49,
+			0x54, 0x0a, 0xf9, 0x80, 0x99, 0xeb, 0x93, 0x6b, 0xf6,
+			0xd3, 0xff, 0x41, 0x05, 0x47, 0xcc, 0x82, 0x62, 0x76,
+			0x32, 0xf3, 0x43, 0x74, 0x70, 0x54, 0xe2, 0x3b, 0xc0,
+			0x90,  },
+		.test[4].outlen = 32, .test[4].data = { 0x41, 0x6c, 0x53, 0x92,
+			0xb9, 0xf3, 0x6d, 0xf1, 0x88, 0xe9, 0x0e, 0xb1, 0x4d,
+			0x17, 0xbf, 0x0d, 0xa1, 0x90, 0xbf, 0xdb, 0x7f, 0x1f,
+			0x49, 0x56, 0xe6, 0xe5, 0x66, 0xa5, 0x69, 0xc8, 0xb1,
+			0x5c,  },
+		.test[5].outlen = 32, .test[5].data = { 0x49, 0x1f, 0x58, 0x3b,
+			0x05, 0xe2, 0x3a, 0x72, 0x1d, 0x11, 0x6d, 0xc1, 0x08,
+			0xa0, 0x3f, 0x30, 0x37, 0x98, 0x36, 0x8a, 0x49, 0x4c,
+			0x21, 0x1d, 0x56, 0xa5, 0x2a, 0xf3, 0x68, 0x28, 0xb7,
+			0x69,  },
+	},
+	/* SHA384_HASH*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 48, .test[1].data = { 0xa3, 0x8f, 0xff, 0x4b,
+			0xa2, 0x6c, 0x15, 0xe4, 0xac, 0x9c, 0xde, 0x8c, 0x03,
+			0x10, 0x3a, 0xc8, 0x90, 0x80, 0xfd, 0x47, 0x54, 0x5f,
+			0xde, 0x94, 0x46, 0xc8, 0xf1, 0x92, 0x72, 0x9e, 0xab,
+			0x7b, 0xd0, 0x3a, 0x4d, 0x5c, 0x31, 0x87, 0xf7, 0x5f,
+			0xe2, 0xa7, 0x1b, 0x0e, 0xe5, 0x0a, 0x4a, 0x40,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 48, .test[1].data = { 0x6c, 0xd8, 0x89, 0xa0,
+			0xca, 0x54, 0xa6, 0x1d, 0x24, 0xc4, 0x1d, 0xa1, 0x77,
+			0x50, 0xd6, 0xf2, 0xf3, 0x43, 0x23, 0x0d, 0xb1, 0xf5,
+			0xf7, 0xfc, 0xc0, 0x8c, 0xf6, 0xdf, 0x3c, 0x61, 0xfc,
+			0x8a, 0xb9, 0xda, 0x12, 0x75, 0x97, 0xac, 0x51, 0x88,
+			0x59, 0x19, 0x44, 0x13, 0xc0, 0x78, 0xa5, 0xa8,  },
+		.test[4].outlen = 48, .test[4].data = { 0x0c, 0x91, 0x36, 0x46,
+			0xd9, 0x17, 0x81, 0x46, 0x1d, 0x42, 0xb1, 0x00, 0xaa,
+			0xfa, 0x26, 0x92, 0x9f, 0x05, 0xc0, 0x91, 0x8e, 0x20,
+			0xd7, 0x75, 0x9d, 0xd2, 0xc8, 0x9b, 0x02, 0x18, 0x20,
+			0x1f, 0xdd, 0xa3, 0x32, 0xe3, 0x1e, 0xa4, 0x2b, 0xc3,
+			0xc8, 0xb9, 0xb1, 0x53, 0x4e, 0x6a, 0x49, 0xd2,  },
+		.test[5].outlen = 48, .test[5].data = { 0x84, 0x78, 0xd2, 0xf1,
+			0x44, 0x95, 0x6a, 0x22, 0x2d, 0x08, 0x19, 0xe8, 0xea,
+			0x61, 0xb4, 0x86, 0xe8, 0xc6, 0xb0, 0x40, 0x51, 0x28,
+			0x22, 0x54, 0x48, 0xc0, 0x70, 0x09, 0x81, 0xf9, 0xf5,
+			0x47, 0x9e, 0xb3, 0x2c, 0x69, 0x19, 0xd5, 0x8d, 0x03,
+			0x5d, 0x24, 0xca, 0x90, 0xa6, 0x9d, 0x80, 0x2a,  },
+		.test[6].outlen = 48, .test[6].data = { 0x0e, 0x68, 0x17, 0x31,
+			0x01, 0xa8, 0x28, 0x0a, 0x4e, 0x47, 0x22, 0xa6, 0x89,
+			0xf0, 0xc6, 0xcd, 0x4e, 0x8c, 0x19, 0x4c, 0x44, 0x3d,
+			0xb5, 0xa5, 0xf9, 0xfe, 0xea, 0xc7, 0x84, 0x0b, 0x57,
+			0x0d, 0xd4, 0xe4, 0x8a, 0x3f, 0x68, 0x31, 0x20, 0xd9,
+			0x1f, 0xc4, 0xa3, 0x76, 0xcf, 0xdd, 0x07, 0xa6,  },
+	},
+	/* SHA512_HASH */
+	{  .min_version = 0x65,
+		.test[1].outlen = 64, .test[1].data = { 0x50, 0x46, 0xad, 0xc1,
+			0xdb, 0xa8, 0x38, 0x86, 0x7b, 0x2b, 0xbb, 0xfd, 0xd0,
+			0xc3, 0x42, 0x3e, 0x58, 0xb5, 0x79, 0x70, 0xb5, 0x26,
+			0x7a, 0x90, 0xf5, 0x79, 0x60, 0x92, 0x4a, 0x87, 0xf1,
+			0x96, 0x0a, 0x6a, 0x85, 0xea, 0xa6, 0x42, 0xda, 0xc8,
+			0x35, 0x42, 0x4b, 0x5d, 0x7c, 0x8d, 0x63, 0x7c, 0x00,
+			0x40, 0x8c, 0x7a, 0x73, 0xda, 0x67, 0x2b, 0x7f, 0x49,
+			0x85, 0x21, 0x42, 0x0b, 0x6d, 0xd3,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 64, .test[1].data = { 0xec, 0xfd, 0x83, 0x74,
+			0xc8, 0xa9, 0x2f, 0xd7, 0x71, 0x94, 0xd1, 0x1e, 0xe7,
+			0x0f, 0x0f, 0x5e, 0x11, 0x29, 0x58, 0xb8, 0x36, 0xc6,
+			0x39, 0xbc, 0xd6, 0x88, 0x6e, 0xdb, 0xc8, 0x06, 0x09,
+			0x30, 0x27, 0xaa, 0x69, 0xb9, 0x2a, 0xd4, 0x67, 0x06,
+			0x5c, 0x82, 0x8e, 0x90, 0xe9, 0x3e, 0x55, 0x88, 0x7d,
+			0xb2, 0x2b, 0x48, 0xa2, 0x28, 0x92, 0x6c, 0x0f, 0xf1,
+			0x57, 0xb5, 0xd0, 0x06, 0x1d, 0xf3,  },
+		.test[4].outlen = 64, .test[4].data = { 0x47, 0x88, 0x91, 0xe9,
+			0x12, 0x3e, 0xfd, 0xdc, 0x26, 0x29, 0x08, 0xd6, 0x30,
+			0x8f, 0xcc, 0xb6, 0x93, 0x30, 0x58, 0x69, 0x4e, 0x81,
+			0xee, 0x9d, 0xb6, 0x0f, 0xc5, 0x54, 0xe6, 0x7c, 0x84,
+			0xc5, 0xbc, 0x89, 0x99, 0xf0, 0xf3, 0x7f, 0x6f, 0x3f,
+			0xf5, 0x04, 0x2c, 0xdf, 0x76, 0x72, 0x6a, 0xbe, 0x28,
+			0x3b, 0xb8, 0x05, 0xb3, 0x47, 0x45, 0xf5, 0x7f, 0xb1,
+			0x21, 0x2d, 0xe0, 0x8d, 0x1e, 0x29,  },
+		.test[5].outlen = 64, .test[5].data = { 0x7e, 0x55, 0xda, 0x88,
+			0x28, 0xc1, 0x6e, 0x9a, 0x6a, 0x99, 0xa0, 0x37, 0x68,
+			0xf0, 0x28, 0x5e, 0xe2, 0xbe, 0x00, 0xac, 0x76, 0x89,
+			0x76, 0xcc, 0x5d, 0x98, 0x1b, 0x32, 0x1a, 0x14, 0xc4,
+			0x2e, 0x9c, 0xe4, 0xf3, 0x3f, 0x5f, 0xa0, 0xae, 0x95,
+			0x16, 0x0b, 0x14, 0xf5, 0xf5, 0x45, 0x29, 0xd8, 0xc9,
+			0x43, 0xf2, 0xa9, 0xbc, 0xdc, 0x03, 0x81, 0x0d, 0x36,
+			0x2f, 0xb1, 0x22, 0xe8, 0x13, 0xf8,  },
+		.test[6].outlen = 64, .test[6].data = { 0x5d, 0xc4, 0x80, 0x90,
+			0x6b, 0x00, 0x17, 0x04, 0x34, 0x63, 0x93, 0xf1, 0xad,
+			0x9a, 0x3e, 0x13, 0x37, 0x6b, 0x86, 0xd7, 0xc4, 0x2b,
+			0x22, 0x9c, 0x2e, 0xf2, 0x1d, 0xde, 0x35, 0x39, 0x03,
+			0x3f, 0x2b, 0x3a, 0xc3, 0x49, 0xb3, 0x32, 0x86, 0x63,
+			0x6b, 0x0f, 0x27, 0x95, 0x97, 0xe5, 0xe7, 0x2b, 0x9b,
+			0x80, 0xea, 0x94, 0x4d, 0x84, 0x2e, 0x39, 0x44, 0x8f,
+			0x56, 0xe3, 0xcd, 0xa7, 0x12, 0x3e,  },
+	},
+	/* SHA512_224_HASH */
+	{  .min_version = 0x65,
+		.test[1].outlen = 28, .test[1].data = { 0x9e, 0x7d, 0x60, 0x80,
+			0xde, 0xf4, 0xe1, 0xcc, 0xf4, 0xae, 0xaa, 0xc6, 0xf7,
+			0xfa, 0xd0, 0x08, 0xd0, 0x60, 0xa6, 0xcf, 0x87, 0x06,
+			0x20, 0x38, 0xd6, 0x16, 0x67, 0x74,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 28, .test[1].data = { 0xff, 0xfb, 0x43, 0x27,
+			0xdd, 0x2e, 0x39, 0xa0, 0x18, 0xa8, 0xaf, 0xde, 0x84,
+			0x0b, 0x5d, 0x0f, 0x3d, 0xdc, 0xc6, 0x17, 0xd1, 0xb6,
+			0x2f, 0x8c, 0xf8, 0x7e, 0x34, 0x34,  },
+		.test[4].outlen = 28, .test[4].data = { 0x00, 0x19, 0xe2, 0x2d,
+			0x44, 0x80, 0x2d, 0xd8, 0x1c, 0x57, 0xf5, 0x57, 0x92,
+			0x08, 0x13, 0xe7, 0x9d, 0xbb, 0x2b, 0xc2, 0x8d, 0x77,
+			0xc1, 0xff, 0x71, 0x4c, 0xf0, 0xa9,  },
+		.test[5].outlen = 28, .test[5].data = { 0x6a, 0xc4, 0xa8, 0x73,
+			0x21, 0x54, 0xb2, 0x82, 0xee, 0x89, 0x8d, 0x45, 0xd4,
+			0xe3, 0x76, 0x3e, 0x04, 0x03, 0xc9, 0x71, 0xee, 0x01,
+			0x25, 0xd2, 0x7b, 0xa1, 0x20, 0xc4,  },
+		.test[6].outlen = 28, .test[6].data = { 0x0f, 0x98, 0x15, 0x9b,
+			0x11, 0xca, 0x60, 0xc7, 0x82, 0x39, 0x1a, 0x50, 0x8c,
+			0xe4, 0x79, 0xfa, 0xa8, 0x0e, 0xc7, 0x12, 0xfd, 0x8c,
+			0x9c, 0x99, 0x7a, 0xe8, 0x7e, 0x92,  },
+	},
+	/* SHA512_256_HASH*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data = { 0xaf, 0x13, 0xc0, 0x48,
+			0x99, 0x12, 0x24, 0xa5, 0xe4, 0xc6, 0x64, 0x44, 0x6b,
+			0x68, 0x8a, 0xaf, 0x48, 0xfb, 0x54, 0x56, 0xdb, 0x36,
+			0x29, 0x60, 0x1b, 0x00, 0xec, 0x16, 0x0c, 0x74, 0xe5,
+			0x54,  }
+	},
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data = { 0x3a, 0x2c, 0xd0, 0x2b,
+			0xfa, 0xa6, 0x72, 0xe4, 0xf1, 0xab, 0x0a, 0x3e, 0x70,
+			0xe4, 0x88, 0x1a, 0x92, 0xe1, 0x3b, 0x64, 0x5a, 0x9b,
+			0xed, 0xb3, 0x97, 0xc0, 0x17, 0x1f, 0xd4, 0x05, 0xf1,
+			0x72,  },
+		.test[4].outlen = 32, .test[4].data = { 0x6f, 0x2d, 0xae, 0xc6,
+			0xe4, 0xa6, 0x5b, 0x52, 0x0f, 0x26, 0x16, 0xf6, 0xa9,
+			0xc1, 0x23, 0xc2, 0xb3, 0x67, 0xfc, 0x69, 0xac, 0x73,
+			0x87, 0xa2, 0x5b, 0x6c, 0x44, 0xad, 0xc5, 0x26, 0x2b,
+			0x10,  },
+		.test[5].outlen = 32, .test[5].data = { 0x63, 0xe7, 0xb8, 0xd1,
+			0x76, 0x33, 0x56, 0x29, 0xba, 0x99, 0x86, 0x42, 0x0d,
+			0x4f, 0xf7, 0x54, 0x8c, 0xb9, 0x39, 0xf2, 0x72, 0x1d,
+			0x0e, 0x9d, 0x80, 0x67, 0xd9, 0xab, 0x15, 0xb0, 0x68,
+			0x18,  },
+		.test[6].outlen = 32, .test[6].data = { 0x64, 0x78, 0x56, 0xd7,
+			0xaf, 0x5b, 0x56, 0x08, 0xf1, 0x44, 0xf7, 0x4f, 0xa1,
+			0xa1, 0x13, 0x79, 0x6c, 0xb1, 0x31, 0x11, 0xf3, 0x75,
+			0xf4, 0x8c, 0xb4, 0x9f, 0xbf, 0xb1, 0x60, 0x38, 0x3d,
+			0x28,  },
+	},
+
+	/* AESXCBC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0x35, 0xd9, 0xdc, 0xdb,
+			0x82, 0x9f, 0xec, 0x33, 0x52, 0xe7, 0xbf, 0x10, 0xb8,
+			0x4b, 0xe4, 0xa5,  },
+		.test[3].outlen = 16, .test[3].data = { 0x39, 0x6f, 0x99, 0xb5,
+			0x43, 0x33, 0x67, 0x4e, 0xd4, 0x45, 0x8f, 0x80, 0x77,
+			0xe4, 0xd4, 0x14,  },
+		.test[4].outlen = 16, .test[4].data = { 0x73, 0xd4, 0x7c, 0x38,
+			0x37, 0x4f, 0x73, 0xd0, 0x78, 0xa8, 0xc6, 0xec, 0x05,
+			0x67, 0xca, 0x5e,  },
+	},
+
+	/* AESCMAC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0x15, 0xbe, 0x1b, 0xfd,
+			0x8c, 0xbb, 0xaf, 0x8b, 0x51, 0x9a, 0x64, 0x3b, 0x1b,
+			0x46, 0xc1, 0x8f,  },
+		.test[3].outlen = 16, .test[3].data = { 0x4e, 0x02, 0xd6, 0xec,
+			0x92, 0x75, 0x88, 0xb4, 0x3e, 0x83, 0xa7, 0xac, 0x32,
+			0xb6, 0x2b, 0xdb,  },
+		.test[4].outlen = 16, .test[4].data = { 0xa7, 0x37, 0x01, 0xbe,
+			0xe8, 0xce, 0xed, 0x44, 0x49, 0x4a, 0xbb, 0xf6, 0x9e,
+			0xd9, 0x31, 0x3e,  },
+	},
+
+	/* KASUMIF9*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 4, .test[1].data = {  0x5b, 0x26, 0x81, 0x06
+		}
+	},
+
+	/* SNOW3G UIA2*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 4, .test[1].data = { 0x08, 0xed, 0x2c, 0x76,
+		}
+	},
+
+	/* ZUC UIA3*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 4, .test[1].data = { 0x6a, 0x2b, 0x4c, 0x3a,
+		}
+	},
+
+	/* POLY1305*/
+	{  .min_version = 0x65,
+		.test[4].outlen = 16, .test[4].data = { 0xef, 0x91, 0x06, 0x4e,
+			0xce, 0x99, 0x9c, 0x4e, 0xfd, 0x05, 0x6a, 0x8c, 0xe6,
+			0x18, 0x23, 0xad }
+	},
+
+	/* SSLMAC MD5*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data = { 0x0e, 0xf4, 0xca, 0x32,
+			0x32, 0x40, 0x1d, 0x1b, 0xaa, 0xfd, 0x6d, 0xa8, 0x01,
+			0x79, 0xed, 0xcd,  },
+	},
+
+	/* SSLMAC_SHA1*/
+	{  .min_version = 0x65,
+		.test[2].outlen = 20, .test[2].data = { 0x05, 0x9d, 0x99, 0xb4,
+			0xf3, 0x03, 0x1e, 0xc5, 0x24, 0xbf, 0xec, 0xdf, 0x64,
+			0x8e, 0x37, 0x2e, 0xf0, 0xef, 0x93, 0xa0,  },
+	},
+
+	/* CRC32*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 0
+	},
+
+	/* TKIP-MIC*/
+	{  .min_version = 0x65,
+		.test[0].outlen = 8, .test[0].data =   { 0x16, 0xfb, 0xa0,
+			0x0e, 0xe2, 0xab, 0x6c, 0x97,  }
+	},
+
+	/* SHA3-224*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 28, .test[1].data =  { 0x73, 0xe0, 0x87,
+			0xae, 0x12, 0x71, 0xb2, 0xc5, 0xf6, 0x85, 0x46, 0xc9,
+			0x3a, 0xb4, 0x25, 0x14, 0xa6, 0x9e, 0xef, 0x25, 0x2b,
+			0xfd, 0xd1, 0x37, 0x55, 0x74, 0x8a, 0x00,  }
+	},
+
+	/* SHA3-256*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data = { 0x9e, 0x62, 0x91, 0x97,
+			0x0c, 0xb4, 0x4d, 0xd9, 0x40, 0x08, 0xc7, 0x9b, 0xca,
+			0xf9, 0xd8, 0x6f, 0x18, 0xb4, 0xb4, 0x9b, 0xa5, 0xb2,
+			0xa0, 0x47, 0x81, 0xdb, 0x71, 0x99, 0xed, 0x3b, 0x9e,
+			0x4e,  }
+	},
+
+	/* SHA3-384*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 48, .test[1].data =  { 0x4b, 0xda, 0xab,
+			0xf7, 0x88, 0xd3, 0xad, 0x1a, 0xd8, 0x3d, 0x6d, 0x93,
+			0xc7, 0xe4, 0x49, 0x37, 0xc2, 0xe6, 0x49, 0x6a, 0xf2,
+			0x3b, 0xe3, 0x35, 0x4d, 0x75, 0x69, 0x87, 0xf4, 0x51,
+			0x60, 0xfc, 0x40, 0x23, 0xbd, 0xa9, 0x5e, 0xcd, 0xcb,
+			0x3c, 0x7e, 0x31, 0xa6, 0x2f, 0x72, 0x6d, 0x70, 0x2c,
+		}
+	},
+
+	/* SHA3-512*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 64, .test[1].data = { 0xad, 0x56, 0xc3, 0x5c,
+			0xab, 0x50, 0x63, 0xb9, 0xe7, 0xea, 0x56, 0x83, 0x14,
+			0xec, 0x81, 0xc4, 0x0b, 0xa5, 0x77, 0xaa, 0xe6, 0x30,
+			0xde, 0x90, 0x20, 0x04, 0x00, 0x9e, 0x88, 0xf1, 0x8d,
+			0xa5, 0x7b, 0xbd, 0xfd, 0xaa, 0xa0, 0xfc, 0x18, 0x9c,
+			0x66, 0xc8, 0xd8, 0x53, 0x24, 0x8b, 0x6b, 0x11, 0x88,
+			0x44, 0xd5, 0x3f, 0x7d, 0x0b, 0xa1, 0x1d, 0xe0, 0xf3,
+			0xbf, 0xaf, 0x4c, 0xdd, 0x9b, 0x3f,  }
+	},
+
+	/* SHAKE128*/
+	{  .min_version = 0x65,
+		.test[4].outlen = 16, .test[4].data =  { 0x24, 0xa7, 0xca,
+			0x4b, 0x75, 0xe3, 0x89, 0x8d, 0x4f, 0x12, 0xe7, 0x4d,
+			0xea, 0x8c, 0xbb, 0x65 }
+	},
+
+	/* SHAKE256*/
+	{  .min_version = 0x65,
+		.test[4].outlen = 32, .test[4].data =  { 0xf5, 0x97, 0x7c,
+			0x82, 0x83, 0x54, 0x6a, 0x63, 0x72, 0x3b, 0xc3, 0x1d,
+			0x26, 0x19, 0x12, 0x4f,
+			0x11, 0xdb, 0x46, 0x58, 0x64, 0x33, 0x36, 0x74, 0x1d,
+			0xf8, 0x17, 0x57, 0xd5, 0xad, 0x30, 0x62 }
+	},
+
+	/* CSHAKE128*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0xe0, 0x6f, 0xd8,
+			0x50, 0x57, 0x6f, 0xe4, 0xfa, 0x7e, 0x13, 0x42, 0xb5,
+			0xf8, 0x13, 0xeb, 0x23 }
+	},
+
+	/* CSHAKE256*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data =  { 0xf3, 0xf2, 0xb5,
+			0x47, 0xf2, 0x16, 0xba, 0x6f, 0x49, 0x83, 0x3e, 0xad,
+			0x1e, 0x46, 0x85, 0x54,
+			0xd0, 0xd7, 0xf9, 0xc6, 0x7e, 0xe9, 0x27, 0xc6, 0xc3,
+			0xc3, 0xdb, 0x91, 0xdb, 0x97, 0x04, 0x0f }
+	},
+
+	/* KMAC128*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0x6c, 0x3f, 0x29,
+			0xfe, 0x01, 0x96, 0x59, 0x36, 0xb7, 0xae, 0xb7, 0xff,
+			0x71, 0xe0, 0x3d, 0xff },
+		.test[4].outlen = 16, .test[4].data =  { 0x58, 0xd9, 0x8d,
+			0xe8, 0x1f, 0x64, 0xb4, 0xa3, 0x9f, 0x63, 0xaf, 0x21,
+			0x99, 0x03, 0x97, 0x06 },
+		.test[5].outlen = 16, .test[5].data =  { 0xf8, 0xf9, 0xb7,
+			0xa4, 0x05, 0x3d, 0x90, 0x7c, 0xf2, 0xa1, 0x7c, 0x34,
+			0x39, 0xc2, 0x87, 0x4b },
+		.test[6].outlen = 16, .test[6].data =  { 0xef, 0x4a, 0xd5,
+			0x1d, 0xd7, 0x83, 0x56, 0xd3, 0xa8, 0x3c, 0xf5, 0xf8,
+			0xd1, 0x12, 0xf4, 0x44 }
+	},
+
+	/* KMAC256*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data =  { 0x0d, 0x86, 0xfa,
+			0x92, 0x92, 0xe4, 0x77, 0x24, 0x6a, 0xcc, 0x79, 0xa0,
+			0x1e, 0xb4, 0xc3, 0xac,
+			0xfc, 0x56, 0xbc, 0x63, 0xcc, 0x1b, 0x6e, 0xf6, 0xc8,
+			0x99, 0xa5, 0x3a, 0x38, 0x14, 0xa2, 0x40 },
+		.test[4].outlen = 32, .test[4].data =  { 0xad, 0x99, 0xed,
+			0x20, 0x1f, 0xbe, 0x45, 0x07, 0x3d, 0xf4, 0xae, 0x9f,
+			0xc2, 0xd8, 0x06, 0x18,
+			0x31, 0x4e, 0x8c, 0xb6, 0x33, 0xe8, 0x31, 0x36, 0x00,
+			0xdd, 0x42, 0x20, 0xda, 0x2b, 0xd5, 0x2b },
+		.test[5].outlen = 32, .test[5].data =  { 0xf9, 0xc6, 0x2b,
+			0x17, 0xa0, 0x04, 0xd9, 0xf2, 0x6c, 0xbf, 0x5d, 0xa5,
+			0x9a, 0xd7, 0x36, 0x1d,
+			0xad, 0x66, 0x6b, 0x3d, 0xb1, 0x52, 0xd3, 0x81, 0x39,
+			0x20, 0xd4, 0xf0, 0x43, 0x72, 0x2c, 0xb7 },
+		.test[6].outlen = 32, .test[6].data =  { 0xcc, 0x89, 0xe4,
+			0x05, 0x58, 0x77, 0x38, 0x8b, 0x18, 0xa0, 0x7c, 0x8d,
+			0x20, 0x99, 0xea, 0x6e,
+			0x6b, 0xe9, 0xf7, 0x0c, 0xe1, 0xe5, 0xce, 0xbc, 0x55,
+			0x4c, 0x80, 0xa5, 0xdc, 0xae, 0xf7, 0x94 }
+	},
+
+	/* KMAC128XOF*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0x84, 0x07, 0x89,
+			0x29, 0xa7, 0xf4, 0x98, 0x91, 0xf5, 0x64, 0x61, 0x8d,
+			0xa5, 0x93, 0x00, 0x31 },
+		.test[4].outlen = 16, .test[4].data =  { 0xf0, 0xa4, 0x1b,
+			0x98, 0x0f, 0xb3, 0xf2, 0xbd, 0xc3, 0xfc, 0x64, 0x1f,
+			0x73, 0x1f, 0xd4, 0x74 },
+		.test[5].outlen = 16, .test[5].data =  { 0xa5, 0xc5, 0xad,
+			0x25, 0x59, 0xf1, 0x5d, 0xea, 0x5b, 0x18, 0x0a, 0x52,
+			0xce, 0x6c, 0xc0, 0x88 },
+		.test[6].outlen = 16, .test[6].data =  { 0x1a, 0x81, 0xdd,
+			0x81, 0x47, 0x89, 0xf4, 0x15, 0xcc, 0x18, 0x05, 0x81,
+			0xe3, 0x95, 0x21, 0xc3 }
+	},
+
+	/* KMAC256XOF*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data =  { 0xff, 0x85, 0xe9,
+			0x61, 0x67, 0x96, 0x35, 0x58, 0x33, 0x38, 0x2c, 0xe8,
+			0x25, 0x77, 0xbe, 0x63,
+			0xd5, 0x2c, 0xa7, 0xef, 0xce, 0x9b, 0x63, 0x71, 0xb2,
+			0x09, 0x7c, 0xd8, 0x60, 0x4e, 0x5a, 0xfa },
+		.test[4].outlen = 32, .test[4].data =  { 0x86, 0x89, 0xc2,
+			0x4a, 0xe8, 0x18, 0x46, 0x10, 0x6b, 0xf2, 0x09, 0xd7,
+			0x37, 0x83, 0xab, 0x77,
+			0xb5, 0xce, 0x7c, 0x96, 0x9c, 0xfa, 0x0f, 0xa0, 0xd8,
+			0xde, 0xb5, 0xb7, 0xc6, 0xcd, 0xa9, 0x8f },
+		.test[5].outlen = 32, .test[5].data =  { 0x4d, 0x71, 0x81,
+			0x5a, 0x5f, 0xac, 0x3b, 0x29, 0xf2, 0x5f, 0xb6, 0x56,
+			0xf1, 0x76, 0xcf, 0xdc,
+			0x51, 0x56, 0xd7, 0x3c, 0x47, 0xec, 0x6d, 0xea, 0xc6,
+			0x3e, 0x54, 0xe7, 0x6f, 0xdc, 0xe8, 0x39 },
+		.test[6].outlen = 32, .test[6].data =  { 0x5f, 0xc5, 0xe1,
+			0x1e, 0xe7, 0x55, 0x0f, 0x62, 0x71, 0x29, 0xf3, 0x0a,
+			0xb3, 0x30, 0x68, 0x06,
+			0xea, 0xec, 0xe4, 0x37, 0x17, 0x37, 0x2d, 0x5d, 0x64,
+			0x09, 0x70, 0x63, 0x94, 0x80, 0x9b, 0x80 }
+	},
+
+	/* HASH SM3*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data =  { 0xe0, 0xba, 0xb8,
+			0xf4, 0xd8, 0x17, 0x2b, 0xa2, 0x45, 0x19, 0x0d, 0x13,
+			0xc9, 0x41, 0x17, 0xe9,
+			0x3b, 0x82, 0x16, 0x6c, 0x25, 0xb2, 0xb6, 0x98, 0x83,
+			0x35, 0x0c, 0x19, 0x2c, 0x90, 0x51, 0x40 },
+		.test[4].outlen = 32, .test[4].data =  { 0xe0, 0xba, 0xb8,
+			0xf4, 0xd8, 0x17, 0x2b, 0xa2, 0x45, 0x19, 0x0d, 0x13,
+			0xc9, 0x41, 0x17, 0xe9,
+			0x3b, 0x82, 0x16, 0x6c, 0x25, 0xb2, 0xb6, 0x98, 0x83,
+			0x35, 0x0c, 0x19, 0x2c, 0x90, 0x51, 0x40 },
+		.test[5].outlen = 32, .test[5].data =  { 0xe0, 0xba, 0xb8,
+			0xf4, 0xd8, 0x17, 0x2b, 0xa2, 0x45, 0x19, 0x0d, 0x13,
+			0xc9, 0x41, 0x17, 0xe9,
+			0x3b, 0x82, 0x16, 0x6c, 0x25, 0xb2, 0xb6, 0x98, 0x83,
+			0x35, 0x0c, 0x19, 0x2c, 0x90, 0x51, 0x40 },
+		.test[6].outlen = 32, .test[6].data =  { 0xe0, 0xba, 0xb8,
+			0xf4, 0xd8, 0x17, 0x2b, 0xa2, 0x45, 0x19, 0x0d, 0x13,
+			0xc9, 0x41, 0x17, 0xe9,
+			0x3b, 0x82, 0x16, 0x6c, 0x25, 0xb2, 0xb6, 0x98, 0x83,
+			0x35, 0x0c, 0x19, 0x2c, 0x90, 0x51, 0x40 }
+	},
+
+	/* HMAC SM3*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 32, .test[1].data =  { 0x68, 0xf0, 0x65,
+			0xd8, 0xd8, 0xc9, 0xc2, 0x0e, 0x10, 0xfd, 0x52, 0x7c,
+			0xf2, 0xd7, 0x42, 0xd3,
+			0x08, 0x44, 0x22, 0xbc, 0xf0, 0x9d, 0xcc, 0x34, 0x7b,
+			0x76, 0x13, 0x91, 0xba, 0xce, 0x4d, 0x17 },
+		.test[4].outlen = 32, .test[4].data =  { 0xd8, 0xab, 0x2a,
+			0x7b, 0x56, 0x21, 0xb1, 0x59, 0x64, 0xb2, 0xa3, 0xd6,
+			0x72, 0xb3, 0x95, 0x81,
+			0xa0, 0xcd, 0x96, 0x47, 0xf0, 0xbc, 0x8c, 0x16, 0x5b,
+			0x9b, 0x7d, 0x2f, 0x71, 0x3f, 0x23, 0x19},
+		.test[5].outlen = 32, .test[5].data =  { 0xa0, 0xd1, 0xd5,
+			0xa0, 0x9e, 0x4c, 0xca, 0x8c, 0x7b, 0xe0, 0x8f, 0x70,
+			0x92, 0x2e, 0x3f, 0x4c,
+			0xa0, 0xca, 0xef, 0xa1, 0x86, 0x9d, 0xb2, 0xe1, 0xc5,
+			0xfa, 0x9d, 0xfa, 0xbc, 0x11, 0xcb, 0x1f },
+		.test[6].outlen = 32, .test[6].data =  { 0xa0, 0xd1, 0xd5,
+			0xa0, 0x9e, 0x4c, 0xca, 0x8c, 0x7b, 0xe0, 0x8f, 0x70,
+			0x92, 0x2e, 0x3f, 0x4c,
+			0xa0, 0xca, 0xef, 0xa1, 0x86, 0x9d, 0xb2, 0xe1, 0xc5,
+			0xfa, 0x9d, 0xfa, 0xbc, 0x11, 0xcb, 0x1f}
+	},
+
+	/* MAC_SM4_XCBC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0x69, 0xaf, 0x45,
+			0xe6, 0x0c, 0x78, 0x71, 0x7e, 0x44, 0x6c, 0xfe, 0x68,
+			0xd4, 0xfe, 0x20, 0x8b },
+		.test[4].outlen = 16, .test[4].data =  { 0x69, 0xaf, 0x45,
+			0xe6, 0x0c, 0x78, 0x71, 0x7e, 0x44, 0x6c, 0xfe, 0x68,
+			0xd4, 0xfe, 0x20, 0x8b },
+		.test[5].outlen = 16, .test[5].data =  { 0x69, 0xaf, 0x45,
+			0xe6, 0x0c, 0x78, 0x71, 0x7e, 0x44, 0x6c, 0xfe, 0x68,
+			0xd4, 0xfe, 0x20, 0x8b },
+		.test[6].outlen = 16, .test[6].data =  { 0x69, 0xaf, 0x45,
+			0xe6, 0x0c, 0x78, 0x71, 0x7e, 0x44, 0x6c, 0xfe, 0x68,
+			0xd4, 0xfe, 0x20, 0x8b }
+	},
+
+	/* MAC_SM4_CMAC*/
+	{  .min_version = 0x65,
+		.test[1].outlen = 16, .test[1].data =  { 0x36, 0xbe, 0xec,
+			0x03, 0x9c, 0xc7, 0x0c, 0x28, 0x23, 0xdd, 0x71, 0x8b,
+			0x3c, 0xbd, 0x7f, 0x37 },
+		.test[4].outlen = 16, .test[4].data =  { 0x36, 0xbe, 0xec,
+			0x03, 0x9c, 0xc7, 0x0c, 0x28, 0x23, 0xdd, 0x71, 0x8b,
+			0x3c, 0xbd, 0x7f, 0x37 },
+		.test[5].outlen = 16, .test[5].data =  { 0x36, 0xbe, 0xec,
+			0x03, 0x9c, 0xc7, 0x0c, 0x28, 0x23, 0xdd, 0x71, 0x8b,
+			0x3c, 0xbd, 0x7f, 0x37 },
+		.test[6].outlen = 16, .test[6].data =  { 0x36, 0xbe, 0xec,
+			0x03, 0x9c, 0xc7, 0x0c, 0x28, 0x23, 0xdd, 0x71, 0x8b,
+			0x3c, 0xbd, 0x7f, 0x37 }
+	},
+
+};
+#endif
+
+static const char *const names[] = {
+	"NULL",
+	"AES_ECB",
+	"AES_CBC",
+	"AES_CTR",
+	"AES_CCM",
+	"AES_GCM",
+	"AES_F8",
+	"AES_XTS",
+	"AES_CFB",
+	"AES_OFB",
+	"AES_CS1",
+	"AES_CS2",
+	"AES_CS3",
+	"MULTI2_ECB",
+	"MULTI2_CBC",
+	"MULTI2_OFB",
+	"MULTI2_CFB",
+	"3DES_CBC",
+	"3DES_ECB",
+	"DES_CBC",
+	"DES_ECB",
+	"KASUMI_ECB",
+	"KASUMI_F8",
+	"SNOW3G_UEA2",
+	"ZUC_UEA2",
+	"CHACHA20_STREAM",
+	"CHACHA20_POLY1305",
+	"SM4_ECB",
+	"SM4_CBC",
+	"SM4_CFB",
+	"SM4_OFB",
+	"SM4_CTR",
+	"SM4_CCM",
+	"SM4_GCM",
+	"SM4_F8",
+	"SM4_XTS",
+	"SM4_CS1",
+	"SM4_CS2",
+	"SM4_CS3",
+
+	"HASH_MD5",
+	"HMAC_MD5",
+	"HASH_SHA1",
+	"HMAC_SHA1",
+	"HASH_SHA224",
+	"HMAC_SHA224",
+	"HASH_SHA256",
+	"HMAC_SHA256",
+	"HASH_SHA384",
+	"HMAC_SHA384",
+	"HASH_SHA512",
+	"HMAC_SHA512",
+	"HASH_SHA512_224",
+	"HMAC_SHA512_224",
+	"HASH_SHA512_256",
+	"HMAC_SHA512_256",
+	"MAC_XCBC",
+	"MAC_CMAC",
+	"MAC_KASUMI_F9",
+	"SNOW3G_UIA2",
+	"ZUC_UIA3",
+	"POLY1305",
+	"SSLMAC_MD5",
+	"SSLMAC_SHA1",
+	"CRC32",
+	"MICHAEL-MIC",
+	"HASH_SHA3_224",
+	"HASH_SHA3_256",
+	"HASH_SHA3_384",
+	"HASH_SHA3_512",
+	"HASH_SHAKE128",
+	"HASH_SHAKE256",
+	"HASH_CSHAKE128",
+	"HASH_CSHAKE256",
+	"KMAC128",
+	"KMAC256",
+	"KMACXOF128",
+	"KMACXOF256",
+	"HASH_SM3",
+	"HMAC_SM3",
+	"MAC_SM4_XCBC",
+	"MAC_SM4_CMAC",
+};
+
+/*
+ * This hack implements SG chaining in a way that works around some
+ * limitations of Linux -- the generic sg_chain function fails on ARM, and
+ * the scatterwalk_sg_chain function creates chains that cannot be DMA mapped
+ * on x86.  So this one is halfway inbetween, and hopefully works in both
+ * environments.
+ *
+ * Unfortunately, if SG debugging is enabled the scatterwalk code will bail
+ * on these chains, but it will otherwise work properly.
+ */
+static inline void spacc_sg_chain(struct scatterlist *sg1, int num,
+				  struct scatterlist *sg2)
+{
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_DEBUG_SG));
+	sg_chain(sg1, num, sg2);
+	sg1[num - 1].page_link |= 1;
+}
+
+/* Prepare the SG for DMA mapping.  Returns the number of SG entries. */
+static int fixup_sg(struct scatterlist *sg, int nbytes)
+{
+	int sg_nents = 0;
+
+	while (nbytes > 0) {
+		if (sg && sg->length) {
+			++sg_nents;
+
+			if (sg->length > nbytes)
+				return sg_nents;
+
+			nbytes -= sg->length;
+
+			sg = sg_next(sg);
+			if (!sg)
+				break;
+			/* WARNING: sg->length may be > nbytes */
+		} else {
+			/*
+			 * The Linux crypto system uses its own SG chaining
+			 * method which is slightly incompatible with the
+			 * generic SG chaining.  In
+			 * particular, dma_map_sg does not support this method.
+			 * Turn			  them into proper chained SGs
+			 * here (which dma_map_sg does
+			 * support) as a workaround.
+			 */
+			spacc_sg_chain(sg, 1, sg_chain_ptr(sg));
+			sg = sg_chain_ptr(sg);
+			if (!sg)
+				break;
+		}
+	}
+
+	return sg_nents;
+}
+
+int spacc_sgs_to_ddt(struct device *dev,
+		     struct scatterlist *sg1, int len1, int *ents1,
+		     struct scatterlist *sg2, int len2, int *ents2,
+		     struct scatterlist *sg3, int len3, int *ents3,
+		     struct pdu_ddt *ddt, int dma_direction)
+{
+	struct scatterlist *sg_entry, *foo_sg[3];
+	int nents[3], onents[3], tents;
+	int i, j, k, rc, *vents[3];
+	unsigned int foo_len[3];
+
+	foo_sg[0] = sg1; foo_len[0] = len1; vents[0] = ents1;
+	foo_sg[1] = sg2; foo_len[1] = len2; vents[1] = ents2;
+	foo_sg[2] = sg3; foo_len[2] = len3; vents[2] = ents3;
+
+	/* map them all*/
+	tents = 0;
+	for (j = 0; j < 3; j++) {
+		if (foo_sg[j]) {
+			onents[j] = fixup_sg(foo_sg[j], foo_len[j]);
+
+			*vents[j] = nents[j] = dma_map_sg(dev, foo_sg[j],
+					onents[j], dma_direction);
+			tents += nents[j];
+			if (nents[j] <= 0) {
+				for (k = 0; k < j; k++) {
+					if (foo_sg[k])
+						dma_unmap_sg(dev, foo_sg[k],
+							     nents[k],
+								dma_direction);
+				}
+				return -ENOMEM;
+			}
+		}
+	}
+
+	/* require ATOMIC operations */
+	rc = pdu_ddt_init(ddt, tents | 0x80000000);
+	if (rc < 0) {
+		for (k = 0; k < 3; k++) {
+			if (foo_sg[k])
+				dma_unmap_sg(dev, foo_sg[k], nents[k],
+					     dma_direction);
+		}
+		return -EIO;
+	}
+
+	for (j = 0; j < 3; j++) {
+		if (foo_sg[j]) {
+			for_each_sg(foo_sg[j], sg_entry, nents[j], i) {
+				pdu_ddt_add(ddt, sg_dma_address(sg_entry),
+					    min(foo_len[j], sg_dma_len(sg_entry)));
+				foo_len[j] -= sg_dma_len(sg_entry);
+			}
+			dma_sync_sg_for_device(dev, foo_sg[j], nents[j],
+					       dma_direction);
+		}
+	}
+
+	return tents;
+}
+
+int modify_scatterlist(struct scatterlist *src, struct scatterlist *dst,
+		       char *ppp_buf, int prev_remainder_len, int blk_sz,
+		       char *buffer, int nbytes, int final)
+{
+	int err;
+	size_t len = nbytes;
+	int sg_total_len;
+	int remainder_len = (len + prev_remainder_len) % blk_sz;
+
+	buffer = kmalloc(len + prev_remainder_len, GFP_KERNEL);
+
+	if (prev_remainder_len)
+		memcpy(buffer, ppp_buf, prev_remainder_len);
+
+	if (final) {
+		memset(ppp_buf, '\0', 128);
+
+		if (final == 1) {
+			sg_set_buf(dst, buffer, prev_remainder_len);
+			err = prev_remainder_len;
+			return err;
+		}
+
+		err = len + prev_remainder_len;
+
+		err = sg_copy_to_buffer(src,
+				sg_nents_for_len(src, len),
+				(buffer + prev_remainder_len), len);
+		if (err != len)
+			pr_debug("ERR: Failed to copy scatterlist: err:%d\n",
+									err);
+
+		sg_set_buf(dst, buffer, len+prev_remainder_len);
+		return len+prev_remainder_len;
+	}
+
+	err = sg_copy_to_buffer(src, sg_nents_for_len(src, len),
+					(buffer + prev_remainder_len), len);
+	if (err != len)
+		pr_debug("Failed to copy scatterlist to buffer\n");
+
+	if (remainder_len) {
+		memset(ppp_buf, '\0', 128);
+
+		if (len+prev_remainder_len > blk_sz)
+			memcpy(ppp_buf, buffer +
+				(len + prev_remainder_len - remainder_len),
+				remainder_len);
+		else
+			memcpy(ppp_buf, buffer, remainder_len);
+	}
+
+	sg_total_len = (len - remainder_len) + prev_remainder_len;
+	sg_set_buf(dst, buffer, sg_total_len);
+
+	return remainder_len;
+}
+
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction)
+{
+	struct scatterlist *sg_entry;
+	int nents, orig_nents;
+	int i, rc;
+
+	orig_nents = fixup_sg(sg, nbytes);
+
+	nents = dma_map_sg(dev, sg, orig_nents, dma_direction);
+
+	if (nents <= 0)
+		return -ENOMEM;
+
+	/* require ATOMIC operations */
+	rc = pdu_ddt_init(ddt, nents | 0x80000000);
+	if (rc < 0) {
+		dma_unmap_sg(dev, sg, orig_nents, dma_direction);
+		return -EIO;
+	}
+
+	for_each_sg(sg, sg_entry, nents, i) {
+		pdu_ddt_add(ddt, sg_dma_address(sg_entry),
+				 sg_dma_len(sg_entry));
+	}
+
+	dma_sync_sg_for_device(dev, sg, nents, dma_direction);
+
+	return orig_nents;
+}
+
+/*
+ * CTRL.MSG_BEGIN = 1 and CTRL.MSG_END = 1, no partial-packet processing
+ * CTRL.MSG_BEGIN = 1 and CTRL.MSG_END = 0, start of partial-packet processing
+ * CTRL.MSG_BEGIN = 0 and CTRL.MSG_END = 0, middle of partial-packet processing
+ * CTRL.MSG_BEGIN = 0 and CTRL.MSG_END = 1, end of partial-packet processing
+ */
+int spacc_partial_packet(struct spacc_device *spacc, int handle,
+			 int packet_stat)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = NULL;
+
+	if (handle < 0 || handle > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[handle];
+	if (!job) {
+		ret = -EIO;
+	} else {
+		switch (packet_stat) {
+		case NO_PARTIAL_PCK:
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN);
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+			break;
+
+		case FIRST_PARTIAL_PCK:
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN);
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+			break;
+
+		case MIDDLE_PARTIAL_PCK:
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN);
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+			break;
+
+		case LAST_PARTIAL_PCK:
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN);
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+			break;
+
+		default:  /* NO_PARTIAL_PCK */
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN);
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int spacc_set_operation(struct spacc_device *spacc, int handle, int op,
+			u32 prot, uint32_t icvcmd, uint32_t icvoff, uint32_t
+
+		icvsz, uint32_t sec_key)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = NULL;
+
+	if (handle < 0 || handle > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[handle];
+	if (!job) {
+		ret = -EIO;
+	} else {
+		if (op == OP_ENCRYPT) {
+			job->op = OP_ENCRYPT;
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+		} else {
+			job->op = OP_DECRYPT;
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+		}
+		switch (prot) {
+		case ICV_HASH:        /* HASH of plaintext */
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+			break;
+		case ICV_HASH_ENCRYPT:
+			/* HASH the plaintext and encrypt the lot */
+			/* ICV_PT and ICV_APPEND must be set too */
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+			 /* This mode is not valid when BIT_ALIGN != 0 */
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+			break;
+		case ICV_ENCRYPT_HASH: /* HASH the ciphertext */
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+			break;
+		case ICV_IGNORE:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		job->icv_len = icvsz;
+
+		switch (icvcmd) {
+		case IP_ICV_OFFSET:
+			job->icv_offset = icvoff;
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+			break;
+		case IP_ICV_APPEND:
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+			break;
+		case IP_ICV_IGNORE:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		if (sec_key)
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_SEC_KEY);
+	}
+
+	return ret;
+}
+
+static int spacc_set_auxinfo(struct spacc_device *spacc, int jobid, uint32_t
+		direction, uint32_t bitsize)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job;
+
+	if (jobid < 0 || jobid > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[jobid];
+	if (!job) {
+		ret = -EIO;
+	} else {
+		job->auxinfo_dir = direction;
+		job->auxinfo_bit_align = bitsize;
+	}
+
+	return ret;
+}
+
+static int _spacc_fifo_full(struct spacc_device *spacc, uint32_t prio)
+{
+	if (spacc->config.is_qos)
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+			SPACC_FIFO_STAT_CMDX_FULL(prio);
+	else
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+			SPACC_FIFO_STAT_CMD0_FULL;
+}
+
+/* When proc_sz != 0 it overrides the ddt_len value
+ * defined in the context referenced by 'job_idx'
+ */
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb, int
+		job_idx, struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+		u32 proc_sz, uint32_t aad_offset, uint32_t pre_aad_sz,
+		u32 post_aad_sz, uint32_t iv_offset, uint32_t prio)
+{
+	int ret = CRYPTO_OK, proc_len;
+	struct spacc_job *job;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
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
+	if (!job) {
+		ret = -EIO;
+	} else {
+		/* process any jobs in the jb*/
+		if (use_jb && spacc_process_jb(spacc) != 0)
+			goto fifo_full;
+
+		if (_spacc_fifo_full(spacc, prio)) {
+			if (use_jb)
+				goto fifo_full;
+			else
+				return -EBUSY;
+		}
+
+		/* compute the length we must process, in decrypt mode
+		 * with an ICV (hash, hmac or CCM modes)
+		 * we must subtract the icv length from the buffer size
+		 */
+		if (proc_sz == SPACC_AUTO_SIZE) {
+			if (job->op == OP_DECRYPT &&
+			    (job->hash_mode > 0 || (job->enc_mode ==
+				    CRYPTO_MODE_AES_CCM || job->enc_mode ==
+				    CRYPTO_MODE_AES_GCM)) &&	!(job->ctrl &
+				    SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC))) {
+				proc_len = src_ddt->len - job->icv_len;
+			} else {
+				proc_len = src_ddt->len;
+			}
+		} else {
+			proc_len = proc_sz;
+		}
+
+		if (pre_aad_sz & SPACC_AADCOPY_FLAG) {
+			job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+			pre_aad_sz &= ~(SPACC_AADCOPY_FLAG);
+		} else {
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+		}
+
+		job->pre_aad_sz  = pre_aad_sz;
+		job->post_aad_sz = post_aad_sz;
+
+		if (spacc->config.dma_type == SPACC_DMA_DDT) {
+			pdu_io_cached_write(spacc->regmap +
+					SPACC_REG_SRC_PTR,
+					(uint32_t)src_ddt->phys,
+					&spacc->cache.src_ptr);
+			pdu_io_cached_write(spacc->regmap +
+					SPACC_REG_DST_PTR,
+					(uint32_t)dst_ddt->phys,
+					&spacc->cache.dst_ptr);
+		} else if (spacc->config.dma_type == SPACC_DMA_LINEAR) {
+			pdu_io_cached_write(spacc->regmap +
+					SPACC_REG_SRC_PTR,
+					(uint32_t)src_ddt->virt[0],
+					&spacc->cache.src_ptr);
+			pdu_io_cached_write(spacc->regmap +
+					SPACC_REG_DST_PTR,
+					(uint32_t)dst_ddt->virt[0],
+					&spacc->cache.dst_ptr);
+		} else {
+			return -EIO;
+		}
+
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_PROC_LEN,     proc_len -
+				job->post_aad_sz,
+				&spacc->cache.proc_len);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_ICV_LEN,      job->icv_len,
+				&spacc->cache.icv_len);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_ICV_OFFSET,
+				job->icv_offset,
+				&spacc->cache.icv_offset);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_PRE_AAD_LEN,
+				job->pre_aad_sz,
+				&spacc->cache.pre_aad);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_POST_AAD_LEN,
+				job->post_aad_sz,
+				&spacc->cache.post_aad);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_IV_OFFSET,    iv_offset,
+				&spacc->cache.iv_offset);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_OFFSET,
+				aad_offset, &spacc->cache.offset);
+		pdu_io_cached_write(spacc->regmap +
+				SPACC_REG_AUX_INFO,
+				AUX_DIR(job->auxinfo_dir) |
+				AUX_BIT_ALIGN(job->auxinfo_bit_align) |
+				AUX_CBC_CS(job->auxinfo_cs_mode),
+				&spacc->cache.aux);
+
+		if (job->first_use == 1) {
+			writel(job->ckey_sz |
+				SPACC_SET_KEY_CTX(job->ctx_idx),
+				spacc->regmap + SPACC_REG_KEY_SZ);
+			writel(job->hkey_sz |
+				SPACC_SET_KEY_CTX(job->ctx_idx),
+				spacc->regmap + SPACC_REG_KEY_SZ);
+		}
+
+		job->job_swid = spacc->job_next_swid;
+		spacc->job_lookup[job->job_swid] = job_idx;
+		spacc->job_next_swid = (spacc->job_next_swid + 1) %
+			SPACC_MAX_JOBS;
+		writel(SPACC_SW_CTRL_ID_SET(job->job_swid) |
+		       SPACC_SW_CTRL_PRIO_SET(prio),
+		       spacc->regmap + SPACC_REG_SW_CTRL);
+		writel(job->ctrl, spacc->regmap + SPACC_REG_CTRL);
+
+		/* Clear an expansion key after the first call*/
+		if (job->first_use == 1) {
+			job->first_use = 0;
+			job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+		}
+	}
+
+
+	return ret;
+fifo_full:
+	/* try to add a job to the job buffers*/
+	{
+		int i;
+
+		i = spacc->jb_head + 1;
+		if (i == SPACC_MAX_JOB_BUFFERS)
+			i = 0;
+
+		if (i == spacc->jb_tail)
+			return -EBUSY;
+
+		spacc->job_buffer[spacc->jb_head] = (struct spacc_job_buffer) {
+			.active		= 1,
+			.job_idx	= job_idx,
+			.src		= src_ddt,
+			.dst		= dst_ddt,
+			.proc_sz	= proc_sz,
+			.aad_offset	= aad_offset,
+			.pre_aad_sz	= pre_aad_sz,
+			.post_aad_sz	= post_aad_sz,
+			.iv_offset	= iv_offset,
+			.prio		= prio
+		};
+
+		spacc->jb_head = i;
+
+		return CRYPTO_USED_JB;
+	}
+}
+
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+			     struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+			     u32 proc_sz, u32 aad_offset, uint32_t pre_aad_sz,
+			     uint32_t post_aad_sz, u32 iv_offset, uint32_t prio)
+{
+	unsigned long lock_flags;
+	int ret;
+
+	spin_lock_irqsave(&spacc->lock, lock_flags);
+	ret = spacc_packet_enqueue_ddt_ex(spacc, 1, job_idx, src_ddt,
+					  dst_ddt, proc_sz, aad_offset,
+					  pre_aad_sz, post_aad_sz, iv_offset,
+					  prio);
+	spin_unlock_irqrestore(&spacc->lock, lock_flags);
+
+	return ret;
+}
+
+static inline uint32_t _spacc_get_stat_cnt(struct spacc_device *spacc)
+{
+	u32 fifo;
+
+	if (spacc->config.is_qos)
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET_QOS(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+	else
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+
+	return fifo;
+}
+
+static int spacc_pop_packets_ex(struct spacc_device *spacc, int *num_popped,
+				unsigned long *lock_flag)
+{
+	int ret = -EINPROGRESS;
+	struct spacc_job *job = NULL;
+	u32 cmdstat, swid, spacc_errcode = SPACC_OK;
+	int jobs;
+
+	*num_popped = 0;
+
+	while ((jobs = _spacc_get_stat_cnt(spacc))) {
+		while (jobs-- > 0) {
+			/* write the pop register to get the next job */
+			writel(1, spacc->regmap + SPACC_REG_STAT_POP);
+			cmdstat = readl(spacc->regmap + SPACC_REG_STATUS);
+
+			swid = SPACC_STATUS_SW_ID_GET(cmdstat);
+
+			if (spacc->job_lookup[swid] == SPACC_JOB_IDX_UNUSED) {
+				ret = -EIO;
+				goto ERR;
+			}
+
+			/* find the associated job with popped swid */
+			if (swid < 0 || swid >= SPACC_MAX_JOBS)
+				job = NULL;
+			else
+				job = &spacc->job[spacc->job_lookup[swid]];
+
+			if (!job) {
+				ret = -EIO;
+				goto ERR;
+			}
+
+			/* mark job as done */
+			job->job_done = 1;
+			spacc->job_lookup[swid] = SPACC_JOB_IDX_UNUSED;
+			spacc_errcode = SPACC_GET_STATUS_RET_CODE(cmdstat);
+
+			switch (spacc_errcode) {
+			case SPACC_ICVFAIL:
+				ret = -EBADMSG;
+				break;
+			case SPACC_MEMERR:
+				ret = -EINVAL;
+				break;
+			case SPACC_BLOCKERR:
+				ret = -EINVAL;
+				break;
+			case SPACC_SECERR:
+				ret = -EIO;
+				break;
+			case SPACC_OK:
+				ret = CRYPTO_OK;
+				break;
+			default:
+				pr_debug("   BUG: Hitting default case");
+			}
+
+			job->job_err = ret;
+
+			/*
+			 * We're done touching the SPAcc hw, so release the
+			 * lock across the job callback.  It must be reacquired
+			 * before continuing to the next iteration.
+			 */
+
+			if (job->cb) {
+				spin_unlock_irqrestore(&spacc->lock,
+						       *lock_flag);
+				job->cb(spacc, job->cbdata);
+				spin_lock_irqsave(&spacc->lock, *lock_flag);
+			}
+
+			(*num_popped)++;
+		}
+	}
+
+	if (!*num_popped)
+		pr_debug("   Failed to pop a single job\n");
+
+ERR:
+	spacc_process_jb(spacc);
+
+	/* reset the WD timer to the original value*/
+	if (spacc->op_mode == SPACC_OP_MODE_WD)
+		spacc_set_wd_count(spacc, spacc->config.wd_timer);
+
+	if (*num_popped && spacc->spacc_notify_jobs)
+		spacc->spacc_notify_jobs(spacc);
+
+	return ret;
+}
+
+int spacc_pop_packets(struct spacc_device *spacc, int *num_popped)
+{
+	unsigned long lock_flag;
+	int err;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	err = spacc_pop_packets_ex(spacc, num_popped, &lock_flag);
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return err;
+}
+
+/* test if done */
+static int spacc_packet_dequeue(struct spacc_device *spacc, int job_idx)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = &spacc->job[job_idx];
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	if (!job && !(job_idx == SPACC_JOB_IDX_UNUSED)) {
+		ret = -EIO;
+	} else {
+		if (job->job_done) {
+			job->job_done  = 0;
+			ret = job->job_err;
+		} else {
+			ret = -EINPROGRESS;
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_isenabled(struct spacc_device *spacc, int mode, int keysize)
+{
+	int x;
+	static const int keysizes[2][7] = {
+		{ 5,  8, 16, 24, 32,  0,   0 }, /* cipher key sizes */
+		{ 8, 16, 20, 24, 32, 64, 128 }, /* hash key sizes */
+	};
+
+	if (mode < 0 || mode > CRYPTO_MODE_LAST)
+		return 0;
+
+	/* always return true for NULL */
+	if (mode == CRYPTO_MODE_NULL)
+		return 1;
+
+	if (spacc->config.modes[mode] & 128) {
+		return 1;
+
+	} else {
+		if (mode == CRYPTO_MODE_AES_XTS ||
+		    mode == CRYPTO_MODE_SM4_XTS ||
+		    mode == CRYPTO_MODE_AES_F8  ||
+		    mode == CRYPTO_MODE_SM4_F8)
+			return 1;
+
+		for (x = 0; x < 6; x++) {
+			if (keysizes[0][x] == keysize) {
+				if (spacc->config.modes[mode] & (1 << x))
+					return 1;
+				else
+					return 0;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/* Releases a crypto context back into appropriate module's pool*/
+int spacc_close(struct spacc_device *dev, int handle)
+{
+	return spacc_job_release(dev, handle);
+}
+
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
+static void check_modes(struct spacc_device *spacc, int x, int y, void *virt,
+			char *key, struct pdu_ddt *ddt)
+{
+	int proclen, aadlen, ivsize, h, err, enc, hash;
+
+	if (template[x] & (1 << y)) {
+		/* testing keysizes[y] with algo 'x' which
+		 * should match the ENUMs above
+		 */
+
+		if (template[x] & 128) {
+			enc = 0;
+			hash = x;
+		} else {
+			enc = x;
+			hash = 0;
+		}
+
+		h = spacc_open(spacc, enc, hash, -1, 0, NULL, NULL);
+		if (h < 0) {
+			spacc->config.modes[x] &= ~(1 << y);
+			return;
+		}
+
+		spacc_set_operation(spacc, h, OP_ENCRYPT, 0, IP_ICV_APPEND, 0,
+				    0, 0);
+
+		/* if this is a hash or mac*/
+		if (template[x] & 128) {
+			switch (x) {
+			case CRYPTO_MODE_HASH_CSHAKE128:
+			case CRYPTO_MODE_HASH_CSHAKE256:
+			case CRYPTO_MODE_MAC_KMAC128:
+			case CRYPTO_MODE_MAC_KMAC256:
+			case CRYPTO_MODE_MAC_KMACXOF128:
+			case CRYPTO_MODE_MAC_KMACXOF256:
+				/* special initial bytes to encode
+				 * length for cust strings
+				 */
+				key[0] = 0x01;
+				key[1] = 0x70;
+				break;
+			}
+
+			spacc_write_context(spacc, h, SPACC_HASH_OPERATION,
+					    key, keysizes[1][y] +
+					(x == CRYPTO_MODE_MAC_XCBC ? 32 : 0),
+					key, 16);
+		} else {
+			u32 keysize;
+
+			ivsize = 16;
+			keysize = keysizes[0][y];
+			switch (x) {
+			case CRYPTO_MODE_CHACHA20_STREAM:
+			case CRYPTO_MODE_AES_CCM:
+			case CRYPTO_MODE_SM4_CCM:
+				ivsize = 16;
+				break;
+			case CRYPTO_MODE_SM4_GCM:
+			case CRYPTO_MODE_CHACHA20_POLY1305:
+			case CRYPTO_MODE_AES_GCM:
+				ivsize = 12;
+				break;
+			case CRYPTO_MODE_KASUMI_ECB:
+			case CRYPTO_MODE_KASUMI_F8:
+			case CRYPTO_MODE_3DES_CBC:
+			case CRYPTO_MODE_3DES_ECB:
+			case CRYPTO_MODE_DES_CBC:
+			case CRYPTO_MODE_DES_ECB:
+				ivsize = 8;
+				break;
+			case CRYPTO_MODE_SM4_XTS:
+			case CRYPTO_MODE_AES_XTS:
+				keysize <<= 1;
+				break;
+			}
+			spacc_write_context(spacc, h, SPACC_CRYPTO_OPERATION,
+					    key, keysize, key, ivsize);
+		}
+
+		spacc_set_key_exp(spacc, h);
+
+		switch (x) {
+		case CRYPTO_MODE_ZUC_UEA3:
+		case CRYPTO_MODE_SNOW3G_UEA2:
+		case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+		case CRYPTO_MODE_MAC_ZUC_UIA3:
+		case CRYPTO_MODE_KASUMI_F8:
+			spacc_set_auxinfo(spacc, h, 0, 0);
+			break;
+		case CRYPTO_MODE_MAC_KASUMI_F9:
+			spacc_set_auxinfo(spacc, h, 0, 8);
+			break;
+		}
+
+		memset(virt, 0, 256);
+
+		/* 16AAD/16PT or 32AAD/0PT depending on
+		 * whether we're in a hash or not mode
+		 */
+		aadlen = 16;
+		proclen = 32;
+		if (!enc)
+			aadlen += 16;
+
+		switch (x) {
+		case CRYPTO_MODE_SM4_CS1:
+		case CRYPTO_MODE_SM4_CS2:
+		case CRYPTO_MODE_SM4_CS3:
+		case CRYPTO_MODE_AES_CS1:
+		case CRYPTO_MODE_AES_CS2:
+		case CRYPTO_MODE_AES_CS3:
+			proclen = 31;
+			fallthrough;
+		case CRYPTO_MODE_SM4_XTS:
+		case CRYPTO_MODE_AES_XTS:
+			aadlen = 0;
+		}
+
+		err = spacc_packet_enqueue_ddt(spacc, h, ddt, ddt, proclen, 0,
+					       aadlen, 0, 0, 0);
+		if (err == CRYPTO_OK) {
+			do {
+				err = spacc_packet_dequeue(spacc, h);
+			} while (err == -EINPROGRESS);
+		}
+		if (err != CRYPTO_OK || !testdata[x].test[y].outlen ||
+			memcmp(testdata[x].test[y].data, virt,
+			       testdata[x].test[y].outlen)) {
+			spacc->config.modes[x] &= ~(1 << y);
+		}
+		spacc_close(spacc, h);
+	}
+}
+
+int spacc_autodetect(struct spacc_device *spacc)
+{
+	struct pdu_ddt ddt;
+	dma_addr_t dma;
+	void *virt;
+	int x, y;
+	unsigned char key[64];
+
+	/* allocate DMA memory ...*/
+	virt = dma_alloc_coherent(get_ddt_device(), 256, &dma, GFP_KERNEL);
+	if (!virt)
+		return -2;
+
+	if (pdu_ddt_init(&ddt, 1)) {
+		dma_free_coherent(get_ddt_device(), 256, virt, dma);
+		return -3;
+	}
+
+	pdu_ddt_add(&ddt, dma, 256);
+
+	for (x = 0; x < 64; x++)
+		key[x] = x;
+
+	for (x = 0; x < ARRAY_SIZE(template); x++) {
+		spacc->config.modes[x] = template[x];
+		if (template[x] && spacc->config.version >=
+				testdata[x].min_version) {
+			for (y = 0; y < (ARRAY_SIZE(keysizes[0])); y++)
+				check_modes(spacc, x, y, virt, key, &ddt);
+		}
+	}
+
+	pdu_ddt_free(&ddt);
+	dma_free_coherent(get_ddt_device(), 256, virt, dma);
+
+	return 0;
+}
+
+#else
+
+static void spacc_static_modes(struct spacc_device *spacc, int x, int y)
+{
+	//Disable the algos that as not supported here
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
+		/* Algos are enabled */
+		break;
+	}
+}
+
+int spacc_static_config(struct spacc_device *spacc)
+{
+
+	int x, y;
+
+	for (x = 0; x < ARRAY_SIZE(template); x++) {
+		spacc->config.modes[x] = template[x];
+
+		for (y = 0; y < (ARRAY_SIZE(keysizes[0])); y++) {
+			/* List static modes */
+			spacc_static_modes(spacc, x, y);
+		}
+	}
+
+	return 0;
+}
+
+#endif
+
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle, void
+		*cbdata)
+{
+	int new_handle;
+
+	new_handle = spacc_job_request(spacc, spacc->job[old_handle].ctx_idx);
+	if (new_handle < 0)
+		return new_handle;
+
+	spacc->job[new_handle]          = spacc->job[old_handle];
+	spacc->job[new_handle].job_used = new_handle;
+	spacc->job[new_handle].cbdata   = cbdata;
+
+	return new_handle;
+}
+
+/* Allocates a job for spacc module context and initialize
+ * it with an appropriate type.
+ */
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctxid, int
+		secure_mode, spacc_callback cb, void *cbdata)
+{
+	int ret = CRYPTO_OK;
+	int job_idx = 0;
+	struct spacc_job *job = NULL;
+	u32 ctrl = 0;
+
+	job_idx = spacc_job_request(spacc, ctxid);
+	if (job_idx < 0) {
+		ret = -EIO;
+	} else {
+		job = &spacc->job[job_idx];
+
+		if (secure_mode && job->ctx_idx > spacc->config.num_sec_ctx) {
+			pr_debug("ERR: For secure contexts");
+			pr_debug("ERR: Job ctx ID is outside allowed range\n");
+			spacc_job_release(spacc, job_idx);
+			return -EIO;
+		}
+
+		job->auxinfo_cs_mode = 0;
+		job->auxinfo_bit_align = 0;
+		job->auxinfo_dir = 0;
+		job->icv_len = 0;
+
+		switch (enc) {
+		case CRYPTO_MODE_NULL:
+			break;
+		case CRYPTO_MODE_AES_ECB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_AES_CBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			break;
+		case CRYPTO_MODE_AES_CS1:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 1;
+			break;
+		case CRYPTO_MODE_AES_CS2:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 2;
+			break;
+		case CRYPTO_MODE_AES_CS3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 3;
+			break;
+		case CRYPTO_MODE_AES_CFB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CFB);
+			break;
+		case CRYPTO_MODE_AES_OFB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_OFB);
+			break;
+		case CRYPTO_MODE_AES_CTR:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CTR);
+			break;
+		case CRYPTO_MODE_AES_CCM:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CCM);
+			break;
+		case CRYPTO_MODE_AES_GCM:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_GCM);
+			break;
+		case CRYPTO_MODE_AES_F8:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_F8);
+			break;
+		case CRYPTO_MODE_AES_XTS:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_XTS);
+			break;
+		case CRYPTO_MODE_MULTI2_ECB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_MULTI2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_MULTI2_CBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_MULTI2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			break;
+		case CRYPTO_MODE_MULTI2_OFB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_MULTI2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_OFB);
+			break;
+		case CRYPTO_MODE_MULTI2_CFB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_MULTI2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CFB);
+			break;
+		case CRYPTO_MODE_3DES_CBC:
+		case CRYPTO_MODE_DES_CBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_DES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			break;
+		case CRYPTO_MODE_3DES_ECB:
+		case CRYPTO_MODE_DES_ECB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_DES);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_KASUMI_ECB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_KASUMI);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_KASUMI_F8:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_KASUMI);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_F8);
+			break;
+		case CRYPTO_MODE_SNOW3G_UEA2:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG,
+					C_SNOW3G_UEA2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_ZUC_UEA3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG,
+					C_ZUC_UEA3);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_CHACHA20_STREAM:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG,
+					C_CHACHA20);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE,
+					CM_CHACHA_STREAM);
+			break;
+		case CRYPTO_MODE_CHACHA20_POLY1305:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG,
+					C_CHACHA20);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE,
+					CM_CHACHA_AEAD);
+			break;
+		case CRYPTO_MODE_SM4_ECB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+			break;
+		case CRYPTO_MODE_SM4_CBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			break;
+		case CRYPTO_MODE_SM4_CS1:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 1;
+			break;
+		case CRYPTO_MODE_SM4_CS2:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 2;
+			break;
+		case CRYPTO_MODE_SM4_CS3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+			job->auxinfo_cs_mode = 3;
+			break;
+		case CRYPTO_MODE_SM4_CFB:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CFB);
+			break;
+
+		case CRYPTO_MODE_SM4_OFB:
+		    ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		    ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_OFB);
+		break;
+
+		case CRYPTO_MODE_SM4_CTR:
+		    ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		    ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CTR);
+		break;
+
+		case CRYPTO_MODE_SM4_CCM:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CCM);
+			break;
+		case CRYPTO_MODE_SM4_GCM:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_GCM);
+			break;
+		case CRYPTO_MODE_SM4_F8:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_F8);
+			break;
+		case CRYPTO_MODE_SM4_XTS:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_XTS);
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		switch (hash) {
+		case CRYPTO_MODE_NULL:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_NULL);
+			break;
+		case CRYPTO_MODE_HMAC_SHA1:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA1);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_MD5:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_MD5);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA224:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA224);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA384:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA384);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA512:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA512);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA512_224:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA512_224);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_HMAC_SHA512_256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA512_256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_SSLMAC_MD5:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_MD5);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SSLMAC);
+			break;
+		case CRYPTO_MODE_SSLMAC_SHA1:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA1);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SSLMAC);
+			break;
+		case CRYPTO_MODE_HASH_SHA1:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA1);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_MD5:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_MD5);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA224:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA224);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA384:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA384);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA512:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SHA512);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA512_224:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA512_224);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA512_256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA512_256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA3_224:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA3_224);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA3_256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA3_256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA3_384:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA3_384);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHA3_512:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHA3_512);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SHAKE128:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE128);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_SHAKE);
+			break;
+		case CRYPTO_MODE_HASH_SHAKE256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_SHAKE);
+			break;
+		case CRYPTO_MODE_HASH_CSHAKE128:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE128);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_CSHAKE);
+			break;
+		case CRYPTO_MODE_HASH_CSHAKE256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_CSHAKE);
+			break;
+		case CRYPTO_MODE_MAC_KMAC128:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE128);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_KMAC);
+			break;
+		case CRYPTO_MODE_MAC_KMAC256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_KMAC); break;
+		case CRYPTO_MODE_MAC_KMACXOF128:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE128);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_KMAC);
+			/* auxinfo_dir reused to indicate XOF */
+			job->auxinfo_dir = 1;
+			break;
+		case CRYPTO_MODE_MAC_KMACXOF256:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SHAKE256);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,
+					HM_SHAKE_KMAC);
+			/* auxinfo_dir reused to indicate XOF */
+			job->auxinfo_dir = 1;
+			break;
+		case CRYPTO_MODE_MAC_XCBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_XCBC);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_CMAC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_CMAC);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_KASUMI_F9:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_KF9);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SNOW3G_UIA2);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_ZUC_UIA3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_ZUC_UIA3);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_POLY1305:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_POLY1305);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_CRC32:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_CRC32_I3E802_3);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE,  HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_MICHAEL:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_MICHAEL);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HASH_SM3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SM3);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_HMAC_SM3:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG, H_SM3);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_HMAC);
+			break;
+		case CRYPTO_MODE_MAC_SM4_XCBC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SM4_XCBC_MAC);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		case CRYPTO_MODE_MAC_SM4_CMAC:
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_ALG,
+					H_SM4_CMAC);
+			ctrl |= SPACC_CTRL_SET(SPACC_CTRL_HASH_MODE, HM_RAW);
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			break;
+		}
+	}
+
+	ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN) |
+		SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+
+	if (ret != CRYPTO_OK) {
+		spacc_job_release(spacc, job_idx);
+	} else {
+		ret		= job_idx;
+		job->first_use	= 1;
+		job->enc_mode	= enc;
+		job->hash_mode	= hash;
+		job->ckey_sz	= 0;
+		job->hkey_sz	= 0;
+		job->job_done	= 0;
+		job->job_swid	= 0;
+		job->job_secure	= !!secure_mode;
+
+		job->auxinfo_bit_align = 0;
+		job->job_err	= -EINPROGRESS;
+		job->ctrl	= ctrl |
+				  SPACC_CTRL_SET(SPACC_CTRL_CTX_IDX,
+						 job->ctx_idx);
+		job->cb		= cb;
+		job->cbdata	= cbdata;
+	}
+
+	return ret;
+}
+
+static int spacc_xof_stringsize_autodetect(struct spacc_device *spacc)
+{
+	struct pdu_ddt	ddt;
+	dma_addr_t dma;
+	void	*virt;
+	int	ss, alg, i, stat;
+	unsigned long spacc_ctrl[2] = {0xF400B400, 0xF400D400};
+	unsigned char buf[256];
+	unsigned long buflen, rbuf;
+	unsigned char test_str[6] = {0x01, 0x20, 0x54, 0x45, 0x53, 0x54};
+	unsigned char md[2][16] = {{0xc3, 0x6d, 0x0a, 0x88, 0xfa, 0x37, 0x4c,
+		0x9b, 0x44, 0x74, 0xeb, 0x00, 0x5f, 0xe8, 0xca, 0x25},
+		{0x68, 0x77, 0x04, 0x11, 0xf8, 0xe3, 0xb0, 0x1e, 0x0d, 0xbf,
+			0x71, 0x6a, 0xe9, 0x87, 0x1a, 0x0d}};
+
+	/* get memory*/
+	virt = dma_alloc_coherent(get_ddt_device(), 256, &dma, GFP_KERNEL);
+	if (!virt)
+		return -EIO;
+
+	if (pdu_ddt_init(&ddt, 1)) {
+		dma_free_coherent(get_ddt_device(), 256, virt, dma);
+		return -EIO;
+	}
+	pdu_ddt_add(&ddt, dma, 256);
+
+	/* populate registers for jobs*/
+	writel((uint32_t)ddt.phys, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel((uint32_t)ddt.phys, spacc->regmap + SPACC_REG_DST_PTR);
+	writel(16, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(16, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+	writel(16, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(6, spacc->regmap + SPACC_REG_KEY_SZ);
+	writel(0, spacc->regmap + SPACC_REG_SW_CTRL);
+
+	/* repeat for 2 algorithms, CSHAKE128 and KMAC128*/
+	for (alg = 0; (alg < 2) && (spacc->config.string_size == 0); alg++) {
+		/* repeat for 4 string_size sizes*/
+		for (ss = 0; ss < 4; ss++) {
+			buflen = (32UL << ss);
+			if (buflen > spacc->config.hash_page_size)
+				break;
+
+			/* clear I/O memory*/
+			memset(virt, 0, 256);
+
+			/* clear buf and then insert test string*/
+			memset(buf, 0, sizeof(buf));
+			memcpy(buf, test_str, sizeof(test_str));
+			memcpy(buf + (buflen >> 1), test_str,
+			       sizeof(test_str));
+
+			/*write key context*/
+			pdu_to_dev_s(spacc->regmap + SPACC_CTX_HASH_KEY,
+				     buf,
+				     spacc->config.hash_page_size >> 2,
+				     spacc->config.spacc_endian);
+
+			/*write ctrl*/
+			writel(spacc_ctrl[alg], spacc->regmap + SPACC_REG_CTRL);
+
+			/*wait for job complete*/
+			for (i = 0; i < 20; i++) {
+				rbuf = 0;
+				rbuf = readl(spacc->regmap +
+						SPACC_REG_FIFO_STAT) &
+						SPACC_FIFO_STAT_STAT_EMPTY;
+				if (!rbuf) {
+					/*check result, if it matches,
+					 * we have string_size
+					 */
+					writel(1, spacc->regmap +
+						SPACC_REG_STAT_POP);
+					rbuf = 0;
+					rbuf = readl(spacc->regmap +
+						     SPACC_REG_STATUS);
+					stat = SPACC_GET_STATUS_RET_CODE(rbuf);
+					if ((!memcmp(virt, md[alg], 16)) &&
+					    stat == SPACC_OK) {
+						spacc->config.string_size = (16
+								<< ss);
+					}
+					break;
+				}
+			}
+		}
+	}
+
+	/* reset registers*/
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
+	pdu_ddt_free(&ddt);
+	dma_free_coherent(get_ddt_device(), 256, virt, dma);
+
+	return CRYPTO_OK;
+}
+
+/* free up the memory */
+void spacc_fini(struct spacc_device *spacc)
+{
+	vfree(spacc->ctx);
+	vfree(spacc->job);
+}
+
+int spacc_init(void *baseaddr, struct spacc_device *spacc,
+	       struct pdu_info *info)
+{
+	unsigned long id;
+	char version_string[3][16] = { "SPACC", "SPACC-PDU" };
+	char idx_string[2][16] = { "(Normal Port)", "(Secure Port)" };
+	char dma_type_string[4][16] = {"Unknown", "Scattergather", "Linear",
+		"Unknown"};
+
+	if (!baseaddr) {
+		pr_debug("ERR: baseaddr is NULL\n");
+		return -1;
+	}
+	if (!spacc) {
+		pr_debug("ERR: spacc is NULL\n");
+		return -1;
+	}
+
+	memset(spacc, 0, sizeof(*spacc));
+	spin_lock_init(&spacc->lock);
+	spin_lock_init(&spacc->ctx_lock);
+
+	/* assign the baseaddr*/
+	spacc->regmap = baseaddr;
+
+	/* version info*/
+	spacc->config.version     = info->spacc_version.version;
+	spacc->config.pdu_version = (info->pdu_config.major << 4) |
+		info->pdu_config.minor;
+	spacc->config.project     = info->spacc_version.project;
+	spacc->config.is_pdu      = info->spacc_version.is_pdu;
+	spacc->config.is_qos      = info->spacc_version.qos;
+
+	/* misc*/
+	spacc->config.is_partial        = info->spacc_version.partial;
+	spacc->config.num_ctx           = info->spacc_config.num_ctx;
+	spacc->config.ciph_page_size    = 1U <<
+		info->spacc_config.ciph_ctx_page_size;
+	spacc->config.hash_page_size    = 1U <<
+		info->spacc_config.hash_ctx_page_size;
+	spacc->config.dma_type          = info->spacc_config.dma_type;
+	spacc->config.idx               = info->spacc_version.vspacc_idx;
+	spacc->config.cmd0_fifo_depth   = info->spacc_config.cmd0_fifo_depth;
+	spacc->config.cmd1_fifo_depth   = info->spacc_config.cmd1_fifo_depth;
+	spacc->config.cmd2_fifo_depth   = info->spacc_config.cmd2_fifo_depth;
+	spacc->config.stat_fifo_depth   = info->spacc_config.stat_fifo_depth;
+	spacc->config.fifo_cnt          = 1;
+
+	spacc->config.is_ivimport = info->spacc_version.ivimport;
+
+	/* ctrl register map*/
+	if (spacc->config.version <= 0x4E)
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_0];
+	else if (spacc->config.version <= 0x60)
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_1];
+	else
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_2];
+
+	spacc->job_next_swid            = 0;
+	spacc->wdcnt                    = 0;
+	spacc->config.wd_timer          = SPACC_WD_TIMER_INIT;
+
+	/* version 4.10 uses IRQ,
+	 * above uses WD and we don't support below 4.00
+	 */
+	if (spacc->config.version < 0x40) {
+		pr_debug("ERR: Unsupported SPAcc version\n");
+		return -EIO;
+	} else if (spacc->config.version < 0x4B) {
+		spacc->op_mode                  = SPACC_OP_MODE_IRQ;
+	} else {
+		spacc->op_mode                  = SPACC_OP_MODE_WD;
+	}
+
+	/* set threshold and enable irq
+	 * on 4.11 and newer cores we can derive this
+	 * from the HW reported depths.
+	 */
+	if (spacc->config.stat_fifo_depth == 1)
+		spacc->config.ideal_stat_level = 1;
+	else if (spacc->config.stat_fifo_depth <= 4)
+		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
+			- 1;
+	else if (spacc->config.stat_fifo_depth <= 8)
+		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
+			- 2;
+	else
+		spacc->config.ideal_stat_level = spacc->config.stat_fifo_depth
+			- 4;
+
+	/* determine max PROClen value */
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_PROC_LEN);
+	spacc->config.max_msg_size = readl(spacc->regmap + SPACC_REG_PROC_LEN);
+
+	/* read config info*/
+	if (spacc->config.is_pdu) {
+		pr_debug("PDU:\n");
+		pr_debug("   MAJOR      : %u\n", info->pdu_config.major);
+		pr_debug("   MINOR      : %u\n", info->pdu_config.minor);
+	}
+	id = readl(spacc->regmap + SPACC_REG_ID);
+	pr_debug("SPACC ID: (%08lx)\n", (unsigned long)id);
+	pr_debug("   MAJOR      : %x\n", info->spacc_version.major);
+	pr_debug("   MINOR      : %x\n", info->spacc_version.minor);
+	pr_debug("   QOS        : %x\n", info->spacc_version.qos);
+	pr_debug("   IVIMPORT   : %x\n", spacc->config.is_ivimport);
+
+	if (spacc->config.version >= 0x48)
+		pr_debug("   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
+			version_string[SPACC_ID_TYPE(id) & 3]);
+
+	pr_debug("   AUX        : %x\n", info->spacc_version.qos);
+	pr_debug("   IDX        : %lx %s\n", SPACC_ID_VIDX(id),
+		spacc->config.is_secure ?
+		(idx_string[spacc->config.is_secure_port & 1]) : "");
+	pr_debug("   PARTIAL    : %x\n", info->spacc_version.partial);
+	pr_debug("   PROJECT    : %x\n", info->spacc_version.project);
+	if (spacc->config.version >= 0x48)
+		id = readl(spacc->regmap + SPACC_REG_CONFIG);
+	else
+		id = 0xFFFFFFFF;
+
+	pr_debug("SPACC CFG: (%08lx)\n", id);
+	pr_debug("   CTX CNT    : %u\n", info->spacc_config.num_ctx);
+	pr_debug("   VSPACC CNT : %u\n", info->spacc_config.num_vspacc);
+	pr_debug("   CIPH SZ    : %-3lu bytes\n", 1UL <<
+			info->spacc_config.ciph_ctx_page_size);
+	pr_debug("   HASH SZ    : %-3lu bytes\n", 1UL <<
+			info->spacc_config.hash_ctx_page_size);
+	pr_debug("   DMA TYPE   : %u (%s)\n", info->spacc_config.dma_type,
+		dma_type_string[info->spacc_config.dma_type & 3]);
+	pr_debug("   MAX PROCLEN: %lu bytes\n", (unsigned
+				long)spacc->config.max_msg_size);
+	pr_debug("   FIFO CONFIG :\n");
+	pr_debug("      CMD0 DEPTH: %d\n", spacc->config.cmd0_fifo_depth);
+	if (spacc->config.is_qos) {
+		pr_debug("      CMD1 DEPTH: %d\n",
+			spacc->config.cmd1_fifo_depth);
+		pr_debug("      CMD2 DEPTH: %d\n",
+			spacc->config.cmd2_fifo_depth);
+	}
+	pr_debug("      STAT DEPTH: %d\n", spacc->config.stat_fifo_depth);
+
+	if (spacc->config.dma_type == SPACC_DMA_DDT) {
+		writel(0x1234567F, baseaddr + SPACC_REG_DST_PTR);
+		writel(0xDEADBEEF, baseaddr + SPACC_REG_SRC_PTR);
+		if (((readl(baseaddr + SPACC_REG_DST_PTR)) !=
+					(0x1234567F & SPACC_DST_PTR_PTR)) ||
+		    ((readl(baseaddr + SPACC_REG_SRC_PTR)) !=
+		     (0xDEADBEEF & SPACC_SRC_PTR_PTR))) {
+			pr_debug("ERR: Failed to set pointers\n");
+			goto ERR;
+		}
+	}
+
+	/* zero the IRQ CTRL/EN register
+	 * (to make sure we're in a sane state)
+	 */
+	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* init cache*/
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
+	spacc->ctx = vmalloc(sizeof(struct spacc_ctx) * spacc->config.num_ctx);
+	if (!spacc->ctx)
+		goto ERR;
+
+	spacc->job = vmalloc(sizeof(struct spacc_job) * SPACC_MAX_JOBS);
+	if (!spacc->job)
+		goto ERR;
+
+	/* initialize job_idx and lookup table */
+	spacc_job_init_all(spacc);
+
+	/* initialize contexts */
+	spacc_ctx_init_all(spacc);
+
+	/* autodetect and set string size setting*/
+	if (spacc->config.version == 0x61 || spacc->config.version >= 0x65)
+		spacc_xof_stringsize_autodetect(spacc);
+
+	return CRYPTO_OK;
+ERR:
+	spacc_fini(spacc);
+	pr_debug("ERR: Crypto Failed\n");
+
+	return -EIO;
+}
+
+/* callback function to initialize tasklet running */
+void spacc_stat_process(struct spacc_device *spacc)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv,
+			spacc);
+
+	/* run tasklet to pop jobs off fifo */
+	tasklet_schedule(&priv->pop_jobs);
+}
+
+void spacc_cmd_process(struct spacc_device *spacc, int x)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv,
+					       spacc);
+
+	/* run tasklet to pop jobs off fifo */
+	tasklet_schedule(&priv->pop_jobs);
+}
+
+void spacc_pop_jobs(unsigned long data)
+{
+	struct spacc_priv *priv =  (struct spacc_priv *)data;
+	struct spacc_device *spacc = &priv->spacc;
+	int num = 0;
+
+	/* decrement the WD CNT here since
+	 * now we're actually going to respond
+	 * to the IRQ completely
+	 */
+	if (spacc->wdcnt)
+		--(spacc->wdcnt);
+
+	spacc_pop_packets(spacc, &num);
+}
+
+#define HW_ENTRY(x) { x, #x }
+static const struct { unsigned int addr; char *name; } reg_names[] = {
+	HW_ENTRY(SPACC_REG_IRQ_EN),
+	HW_ENTRY(SPACC_REG_IRQ_STAT),
+	HW_ENTRY(SPACC_REG_IRQ_CTRL),
+	HW_ENTRY(SPACC_REG_FIFO_STAT),
+	HW_ENTRY(SPACC_REG_SDMA_BRST_SZ),
+	HW_ENTRY(SPACC_REG_SRC_PTR),
+	HW_ENTRY(SPACC_REG_DST_PTR),
+	HW_ENTRY(SPACC_REG_OFFSET),
+	HW_ENTRY(SPACC_REG_PRE_AAD_LEN),
+	HW_ENTRY(SPACC_REG_POST_AAD_LEN),
+	HW_ENTRY(SPACC_REG_PROC_LEN),
+	HW_ENTRY(SPACC_REG_ICV_LEN),
+	HW_ENTRY(SPACC_REG_ICV_OFFSET),
+	HW_ENTRY(SPACC_REG_IV_OFFSET),
+	HW_ENTRY(SPACC_REG_SW_CTRL),
+	HW_ENTRY(SPACC_REG_AUX_INFO),
+	HW_ENTRY(SPACC_REG_CTRL),
+	HW_ENTRY(SPACC_REG_STAT_POP),
+	HW_ENTRY(SPACC_REG_STATUS),
+	HW_ENTRY(SPACC_REG_STAT_WD_CTRL),
+	HW_ENTRY(SPACC_REG_KEY_SZ),
+	HW_ENTRY(SPACC_REG_VIRTUAL_RQST),
+	HW_ENTRY(SPACC_REG_VIRTUAL_ALLOC),
+	HW_ENTRY(SPACC_REG_VIRTUAL_PRIO),
+	HW_ENTRY(SPACC_REG_ID),
+	HW_ENTRY(SPACC_REG_CONFIG),
+	HW_ENTRY(SPACC_REG_CONFIG2),
+	HW_ENTRY(SPACC_REG_SECURE_CTRL),
+	HW_ENTRY(SPACC_REG_SECURE_RELEASE),
+	HW_ENTRY(SPACC_REG_SK_LOAD),
+	HW_ENTRY(SPACC_REG_SK_STAT),
+	HW_ENTRY(SPACC_REG_SK_KEY),
+
+	{ 0, NULL },
+};
+
+#undef HW_ENTRY
+
+int spacc_remove(struct platform_device *pdev)
+{
+	struct spacc_device *spacc;
+	struct spacc_priv *priv = platform_get_drvdata(pdev);
+
+	/* free test vector memory*/
+	spacc = &priv->spacc;
+	spacc_fini(spacc);
+
+	tasklet_kill(&priv->pop_jobs);
+
+	/* devm functions do proper cleanup */
+	pdu_mem_deinit(&pdev->dev);
+	dev_dbg(&pdev->dev, "removed!\n");
+
+	return 0;
+}
+
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx)
+{
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS) {
+		pr_debug("ERR: Invalid Job id specified (out of range)\n");
+		return -ENXIO;
+	}
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx) {
+		pr_debug("ERR: Failed to find ctx id\n");
+		return -EIO;
+	}
+
+	job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+
+	return CRYPTO_OK;
+}
+
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key, int keylen,
+		unsigned char *xcbc_out)
+{
+	unsigned char *buf;
+	dma_addr_t     bufphys;
+	struct pdu_ddt        ddt;
+	int err, i, handle, usecbc, ctx_idx;
+	unsigned char iv[16];
+
+	if (job_idx >= 0 && job_idx < SPACC_MAX_JOBS)
+		ctx_idx = spacc->job[job_idx].ctx_idx;
+	else
+		ctx_idx = -1;
+
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		/* figure out if we can schedule the key  */
+		if (spacc_isenabled(spacc, CRYPTO_MODE_AES_ECB, 16))
+			usecbc = 0;
+		else if (spacc_isenabled(spacc, CRYPTO_MODE_AES_CBC, 16))
+			usecbc = 1;
+		else
+			return -1;
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		/* figure out if we can schedule the key  */
+		if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_ECB, 16))
+			usecbc = 0;
+		else if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_CBC, 16))
+			usecbc = 1;
+		else
+			return -1;
+	} else {
+		return -1;
+	}
+
+	memset(iv, 0, sizeof(iv));
+	memset(&ddt, 0, sizeof(ddt));
+
+	buf = dma_alloc_coherent(get_ddt_device(), 64, &bufphys, GFP_KERNEL);
+	if (!buf)
+		return -EINVAL;
+
+	handle = -1;
+
+	/* set to 1111...., 2222...., 333... */
+	for (i = 0; i < 48; i++)
+		buf[i] = (i >> 4) + 1;
+
+	/* build DDT */
+	err = pdu_ddt_init(&ddt, 1);
+	if (err)
+		goto xcbc_err;
+
+	pdu_ddt_add(&ddt, bufphys, 48);
+
+	/* open a handle in either CBC or ECB mode */
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				CRYPTO_MODE_AES_CBC : CRYPTO_MODE_AES_ECB),
+				CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				CRYPTO_MODE_SM4_CBC : CRYPTO_MODE_SM4_ECB),
+				CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	}
+	spacc_set_operation(spacc, handle, OP_ENCRYPT, 0, 0, 0, 0, 0);
+
+	if (usecbc) {
+		/* we can do the ECB work in CBC using three
+		 * jobs with the IVreset to zero each time
+		 */
+		for (i = 0; i < 3; i++) {
+			spacc_write_context(spacc, handle,
+					    SPACC_CRYPTO_OPERATION, key,
+					    keylen, iv, 16);
+			err = spacc_packet_enqueue_ddt(spacc, handle, &ddt,
+						&ddt, 16, (i * 16) |
+						((i * 16) << 16), 0, 0, 0, 0);
+			if (err != CRYPTO_OK)
+				goto xcbc_err;
+
+			do {
+				err = spacc_packet_dequeue(spacc, handle);
+			} while (err == -EINPROGRESS);
+			if (err != CRYPTO_OK)
+				goto xcbc_err;
+		}
+	} else {
+		/* do the 48 bytes as a single SPAcc job this is the ideal case
+		 * but only possible
+		 * if ECB was enabled in the core
+		 */
+		spacc_write_context(spacc, handle, SPACC_CRYPTO_OPERATION,
+				    key, keylen, iv, 16);
+		err = spacc_packet_enqueue_ddt(spacc, handle, &ddt, &ddt, 48,
+					       0, 0, 0, 0, 0);
+		if (err != CRYPTO_OK)
+			goto xcbc_err;
+
+		do {
+			err = spacc_packet_dequeue(spacc, handle);
+		} while (err == -EINPROGRESS);
+		if (err != CRYPTO_OK)
+			goto xcbc_err;
+	}
+
+	/* now we can copy the key*/
+	memcpy(xcbc_out, buf, 48);
+	memset(buf, 0, 64);
+
+xcbc_err:
+	dma_free_coherent(get_ddt_device(), 64, buf, bufphys);
+	pdu_ddt_free(&ddt);
+	if (handle >= 0)
+		spacc_close(spacc, handle);
+
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
+
diff --git a/drivers/crypto/dwc-spacc/spacc_core.h b/drivers/crypto/dwc-spacc/spacc_core.h
new file mode 100644
index 000000000000..88fa8a9d74e8
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.h
@@ -0,0 +1,833 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_CORE_H_
+#define SPACC_CORE_H_
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
+#include <linux/dma-mapping.h>
+#include "spacc_hal.h"
+
+enum {
+	SPACC_DMA_UNDEF  = 0,
+	SPACC_DMA_DDT	 = 1,
+	SPACC_DMA_LINEAR = 2
+};
+
+enum {
+	SPACC_OP_MODE_IRQ = 0,
+	SPACC_OP_MODE_WD  = 1	/* watchdog */
+};
+
+#define OP_ENCRYPT		0
+#define OP_DECRYPT		1
+
+#define SPACC_CRYPTO_OPERATION	1
+#define SPACC_HASH_OPERATION	2
+
+#define SPACC_AADCOPY_FLAG	0x80000000
+
+#define SPACC_AUTO_SIZE		(-1)
+
+#define SPACC_WD_LIMIT		0x80
+#define SPACC_WD_TIMER_INIT	0x40000
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
+#define _SPACC_IRQ_CTRL_CMDX_CNT(x)       (8 * (x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_SET(x, n) \
+	(((n) & 0xFF) << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_MASK(x) \
+	(0xFF << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+
+/* STAT_CNT is at 16 and for QOS at 24 */
+#define _SPACC_IRQ_CTRL_STAT_CNT          16
+#define SPACC_IRQ_CTRL_STAT_CNT_SET(n)    ((n) << _SPACC_IRQ_CTRL_STAT_CNT)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK      (0x1FF << _SPACC_IRQ_CTRL_STAT_CNT)
+
+#define _SPACC_IRQ_CTRL_STAT_CNT_QOS         24
+#define SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(n) \
+	((n) << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+
+/******** FIFO_STAT Bitmasks *********/
+
+/* SPACC with QOS */
+#define SPACC_FIFO_STAT_CMDX_CNT_MASK(x) \
+	(0x7F << ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_CNT_GET(x, y) \
+	(((y) & SPACC_FIFO_STAT_CMDX_CNT_MASK(x)) >> ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_FULL(x)          (1UL << (7 + (x) * 8))
+
+#define _SPACC_FIFO_STAT_STAT_CNT_QOS         24
+#define SPACC_FIFO_STAT_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_FIFO_STAT_STAT_CNT_QOS)
+#define SPACC_FIFO_STAT_STAT_CNT_GET_QOS(y)	\
+	(((y) &					\
+	SPACC_FIFO_STAT_STAT_CNT_MASK_QOS) >> _SPACC_FIFO_STAT_STAT_CNT_QOS)
+
+/* SPACC without QOS */
+#define SPACC_FIFO_STAT_CMD0_CNT_MASK	(0x1FF)
+#define SPACC_FIFO_STAT_CMD0_CNT_GET(y)	((y) & SPACC_FIFO_STAT_CMD0_CNT_MASK)
+#define _SPACC_FIFO_STAT_CMD0_FULL      15
+#define SPACC_FIFO_STAT_CMD0_FULL       BIT(_SPACC_FIFO_STAT_CMD0_FULL)
+
+#define _SPACC_FIFO_STAT_STAT_CNT       16
+#define SPACC_FIFO_STAT_STAT_CNT_MASK   (0x1FF << _SPACC_FIFO_STAT_STAT_CNT)
+#define SPACC_FIFO_STAT_STAT_CNT_GET(y) \
+	(((y) & SPACC_FIFO_STAT_STAT_CNT_MASK) >> _SPACC_FIFO_STAT_STAT_CNT)
+
+/* both */
+#define _SPACC_FIFO_STAT_STAT_EMPTY	31
+#define SPACC_FIFO_STAT_STAT_EMPTY	BIT(_SPACC_FIFO_STAT_STAT_EMPTY)
+
+/********* SRC/DST_PTR Bitmasks **********/
+
+#define SPACC_SRC_PTR_PTR           0xFFFFFFF8
+#define SPACC_DST_PTR_PTR           0xFFFFFFF8
+
+/********** OFFSET Bitmasks **********/
+
+#define SPACC_OFFSET_SRC_O          0
+#define SPACC_OFFSET_SRC_W          16
+#define SPACC_OFFSET_DST_O          16
+#define SPACC_OFFSET_DST_W          16
+
+#define SPACC_MIN_CHUNK_SIZE        1024
+#define SPACC_MAX_CHUNK_SIZE        16384
+
+/********* PKT_LEN Bitmasks **********/
+
+#ifndef _SPACC_PKT_LEN_PROC_LEN
+#define _SPACC_PKT_LEN_PROC_LEN     0
+#endif
+#ifndef _SPACC_PKT_LEN_AAD_LEN
+#define _SPACC_PKT_LEN_AAD_LEN      16
+#endif
+
+/********* SW_CTRL Bitmasks ***********/
+
+#define _SPACC_SW_CTRL_ID_0          0
+#define SPACC_SW_CTRL_ID_W           8
+#define SPACC_SW_CTRL_ID_MASK        (0xFF << _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_GET(y) \
+	(((y) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_SET(id) \
+	(((id) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+
+#define _SPACC_SW_CTRL_PRIO          30
+#define SPACC_SW_CTRL_PRIO_MASK      0x3
+#define SPACC_SW_CTRL_PRIO_SET(prio) \
+	(((prio) & SPACC_SW_CTRL_PRIO_MASK) << _SPACC_SW_CTRL_PRIO)
+
+/* Priorities */
+#define SPACC_SW_CTRL_PRIO_HI         0
+#define SPACC_SW_CTRL_PRIO_MED        1
+#define SPACC_SW_CTRL_PRIO_LOW        2
+
+/*********** SECURE_CTRL bitmasks *********/
+#define _SPACC_SECURE_CTRL_MS_SRC     0
+#define _SPACC_SECURE_CTRL_MS_DST     1
+#define _SPACC_SECURE_CTRL_MS_DDT     2
+#define _SPACC_SECURE_CTRL_LOCK       31
+
+#define SPACC_SECURE_CTRL_MS_SRC    BIT(_SPACC_SECURE_CTRL_MS_SRC)
+#define SPACC_SECURE_CTRL_MS_DST    BIT(_SPACC_SECURE_CTRL_MS_DST)
+#define SPACC_SECURE_CTRL_MS_DDT    BIT(_SPACC_SECURE_CTRL_MS_DDT)
+#define SPACC_SECURE_CTRL_LOCK      BIT(_SPACC_SECURE_CTRL_LOCK)
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
+#define SPACC_SK_LOAD_ENC_EN         BIT(_SPACC_SK_LOAD_ENC_EN)
+#define SPACC_SK_LOAD_DEC_EN         BIT(_SPACC_SK_LOAD_DEC_EN)
+#define SPACC_SK_STAT_BUSY           BIT(_SPACC_SK_STAT_BUSY)
+
+/*********** CTRL Bitmasks ***********/
+/* These CTRL field locations vary with SPACC version
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
+#define SPACC_KEY_SZ_CIPHER        BIT(_SPACC_KEY_SZ_CIPHER)
+
+#define SPACC_SET_CIPHER_KEY_SZ(z) \
+	(((z) << _SPACC_KEY_SZ_SIZE) | (1UL << _SPACC_KEY_SZ_CIPHER))
+#define SPACC_SET_HASH_KEY_SZ(z)   ((z) << _SPACC_KEY_SZ_SIZE)
+#define SPACC_SET_KEY_CTX(ctx)     ((ctx) << _SPACC_KEY_SZ_CTX_IDX)
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
+#define CRYPTO_USED_JB	256
+
+/* max DDT particle size */
+#ifndef SPACC_MAX_PARTICLE_SIZE
+#define SPACC_MAX_PARTICLE_SIZE	4096
+#endif
+
+/* max message size from HW configuration */
+/* usually defined in ICD as (2 exponent 16) -1 */
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
+	HM_RAW    = 0,
+	HM_SSLMAC = 1,
+	HM_HMAC   = 2,
+	HM_MAX	  = 3
+};
+
+enum eshakehashmode {
+	HM_SHAKE_SHAKE  = 0,
+	HM_SHAKE_CSHAKE = 1,
+	HM_SHAKE_KMAC   = 2
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
+	IP_ICV_OFFSET = 0,
+	IP_ICV_APPEND = 1,
+	IP_ICV_IGNORE = 2,
+	IP_MAX	      = 3
+};
+
+enum {
+	/* HASH of plaintext */
+	ICV_HASH	 = 0,
+	/* HASH the plaintext and encrypt the plaintext and ICV */
+	ICV_HASH_ENCRYPT = 1,
+	/* HASH the ciphertext */
+	ICV_ENCRYPT_HASH = 2,
+	ICV_IGNORE	 = 3,
+	IM_MAX		 = 4
+};
+
+enum {
+	NO_PARTIAL_PCK	   = 0,
+	FIRST_PARTIAL_PCK  = 1,
+	MIDDLE_PARTIAL_PCK = 2,
+	LAST_PARTIAL_PCK   = 3
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
+	unsigned long
+		enc_mode,/* Encryption Algorithm mode */
+		hash_mode,/* HASH Algorithm mode */
+		icv_len,
+		icv_offset,
+		op, /* Operation */
+		ctrl,/* CTRL shadow register */
+		/* context just initialized or taken,
+		 * and this is the first use.
+		 */
+		first_use,
+		pre_aad_sz, post_aad_sz,  /* size of AAD for the latest packet*/
+		hkey_sz,
+		ckey_sz;
+
+	/* Direction and bit alignment parameters for the AUX_INFO reg */
+	unsigned int auxinfo_dir, auxinfo_bit_align;
+	unsigned int auxinfo_cs_mode; /* AUX info setting for CBC-CS */
+
+	u32	ctx_idx;
+	unsigned int job_used, job_swid, job_done, job_err, job_secure;
+	spacc_callback cb;
+	void	*cbdata;
+
+};
+
+#define SPACC_CTX_IDX_UNUSED	0xFFFFFFFF
+#define SPACC_JOB_IDX_UNUSED	0xFFFFFFFF
+
+struct spacc_ctx {
+	/* Memory context to store cipher keys*/
+	u32 *ciph_key;
+	/* Memory context to store hash keys*/
+	u32 *hash_key;
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
+enum {
+	SPACC_CTRL_VER_0,
+	SPACC_CTRL_VER_1,
+	SPACC_CTRL_VER_2,
+	SPACC_CTRL_VER_SIZE
+};
+
+enum {
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
+	void	*regmap;
+	int	zero_key;
+
+	/* hardware configuration */
+	struct {
+		unsigned int version,
+			     pdu_version,
+			     project;
+		uint32_t max_msg_size; /* max PROCLEN value */
+
+		unsigned char modes[CRYPTO_MODE_LAST];
+
+		int num_ctx,         /* # of contexts */
+		    num_sec_ctx,     /* # of SKP contexts*/
+		    sec_ctx_page_size, /* page size of SKP context in bytes*/
+		    ciph_page_size,  /* cipher context page size in bytes*/
+		    hash_page_size,  /* hash context page size in bytes*/
+		    string_size,
+		    is_qos,          /* QOS spacc? */
+		    is_pdu,          /* PDU spacc? */
+		    is_secure,
+		    is_secure_port, /* Are we on the secure port? */
+		    is_partial,     /* Is partial processing enabled? */
+		    is_ivimport,    /* is ivimport enabled? */
+		    dma_type, /* Which type of DMA linear or scattergather */
+		    idx,      /* Which virtual spacc IDX is this? */
+		    priority, /* Weighted priority of the virtual spacc */
+		    cmd0_fifo_depth, /* CMD FIFO depths */
+		    cmd1_fifo_depth,
+		    cmd2_fifo_depth,
+		    stat_fifo_depth, /* depth of STATUS FIFO */
+		    fifo_cnt,
+		    ideal_stat_level,
+		    spacc_endian;
+
+		uint32_t wd_timer;
+		u64 oldtimer, timer;
+
+		const u8 *ctrl_map; /* map of ctrl register field offsets */
+	} config;
+
+	struct spacc_job_buffer {
+		int active;
+		int job_idx;
+		struct pdu_ddt *src, *dst;
+		u32 proc_sz, aad_offset, pre_aad_sz,
+		post_aad_sz, iv_offset, prio;
+	} job_buffer[SPACC_MAX_JOB_BUFFERS];
+
+	int jb_head, jb_tail;
+
+	int op_mode,	/* operating mode and watchdog functionality */
+	    wdcnt;	/* number of pending WD IRQs*/
+
+	/* SW_ID value which will be used for next job. */
+	unsigned int job_next_swid;
+
+	struct spacc_ctx *ctx;	/* This size changes per configured device */
+	struct spacc_job *job;	/* allocate memory for [SPACC_MAX_JOBS]; */
+	int job_lookup[SPACC_MAX_JOBS];	/* correlate SW_ID back to job index */
+
+	spinlock_t lock;	/* lock for register access */
+	spinlock_t ctx_lock;	/* lock for context manager */
+
+	/* callback functions for IRQ processing */
+	void (*irq_cb_cmdx)(struct spacc_device *spacc, int x);
+	void (*irq_cb_stat)(struct spacc_device *spacc);
+	void (*irq_cb_stat_wd)(struct spacc_device *spacc);
+
+	/* this is called after jobs have been popped off the STATUS FIFO
+	 * useful so you can be told when there might be space available in the
+	 * CMD FIFO
+	 */
+	void (*spacc_notify_jobs)(struct spacc_device *spacc);
+
+	/* cache*/
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
+struct elpspacc_irq_ioctl {
+	u32 spacc_epn, spacc_virt,  /* identify which spacc */
+	    command,                /* what operation */
+	    irq_mode,
+	    wd_value,
+	    stat_value,
+	    cmd_value;
+};
+
+enum {
+	SPACC_IRQ_MODE_WD   = 1,  /* use WD*/
+	SPACC_IRQ_MODE_STEP = 2	  /* older use CMD/STAT stepping */
+};
+
+enum {
+	SPACC_IRQ_CMD_GET = 0,
+	SPACC_IRQ_CMD_SET = 1
+};
+
+struct spacc_priv {
+	struct spacc_device spacc;
+	struct semaphore core_running;
+	struct tasklet_struct pop_jobs;
+	spinlock_t hw_lock;
+	unsigned long max_msg_len;
+};
+
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctx,
+	       int secure_mode, spacc_callback cb, void *cbdata);
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle,
+		       void *cbdata);
+int spacc_close(struct spacc_device *spacc, int job_idx);
+int spacc_partial_packet(struct spacc_device *spacc, int handle,
+			 int packet_stat);
+int spacc_set_operation(struct spacc_device *spacc, int job_idx, int op,
+			u32 prot, uint32_t icvcmd, uint32_t icvoff,
+			uint32_t icvsz, uint32_t sec_key);
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx);
+
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
+		int job_idx, struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+		u32 proc_sz, uint32_t aad_offset, uint32_t pre_aad_sz,
+		u32 post_aad_sz, uint32_t iv_offset, uint32_t prio);
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+		struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+		uint32_t proc_sz, u32 aad_offset, uint32_t pre_aad_sz,
+		uint32_t post_aad_sz, u32 iv_offset, uint32_t prio);
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
+uint32_t spacc_process_irq(struct spacc_device *spacc);
+void spacc_set_wd_count(struct spacc_device *spacc, uint32_t val);
+int modify_scatterlist(struct scatterlist *src, struct scatterlist *dst,
+		       char *ppp_buf, int prev_remainder_len, int blk_sz,
+		       char *buffer, int nbytes, int final);
+int spacc_sgs_to_ddt(struct device *dev,
+		     struct scatterlist *sg1, int len1, int *ents1,
+		     struct scatterlist *sg2, int len2, int *ents2,
+		     struct scatterlist *sg3, int len3, int *ents3,
+		     struct pdu_ddt *ddt, int dma_direction);
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction);
+
+/* Context Manager */
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
+/* Job Manager */
+void spacc_job_init_all(struct spacc_device *spacc);
+int  spacc_job_request(struct spacc_device *dev, int job_idx);
+int  spacc_job_release(struct spacc_device *dev, int job_idx);
+int  spacc_handle_release(struct spacc_device *spacc, int job_idx);
+
+/* helper functions */
+struct spacc_ctx *context_lookup_by_job(struct spacc_device *spacc, int
+					job_idx);
+int spacc_isenabled(struct spacc_device *spacc, int mode, int keysize);
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key,
+			   int keylen, unsigned char *xcbc_out);
+
+int  spacc_process_jb(struct spacc_device *spacc);
+int  spacc_remove(struct platform_device *pdev);
+int spacc_static_config(struct spacc_device *spacc);
+int  spacc_autodetect(struct spacc_device *spacc);
+void spacc_pop_jobs(unsigned long data);
+void spacc_fini(struct spacc_device *spacc);
+int  spacc_init(void *baseaddr, struct spacc_device *spacc,
+		struct pdu_info *info);
+int  spacc_pop_packets(struct spacc_device *spacc, int *num_popped);
+void spacc_stat_process(struct spacc_device *spacc);
+void spacc_cmd_process(struct spacc_device *spacc, int x);
+
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
new file mode 100644
index 000000000000..d3fc23249250
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.c
@@ -0,0 +1,323 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include "spacc_device.h"
+
+static struct platform_device *spacc_pdev[ELP_CAPI_MAX_DEV + 1];
+
+/*VSPACC_PRIORITY.WEIGHT bits 11:8*/
+#define VSPACC_PRIORITY_MAX 15
+
+int spacc_probe(struct platform_device *pdev, const struct of_device_id
+		snps_spacc_id[])
+{
+	void *baseaddr;
+	struct resource *mem;
+	int spacc_priority = -1, spacc_idx = -1;
+	int spacc_endian = 0;
+	int x, err, oldmode, irq_num;
+	struct spacc_priv   *priv;
+	struct pdu_info     info;
+	const struct of_device_id *match, *id;
+	u64 oldtimer = 100000, timer = 100000;
+
+	if (pdev->dev.of_node) {
+		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
+		if (!id) {
+			dev_err(&pdev->dev, "DT node did not match\n");
+			return -EINVAL;
+		}
+	}
+
+	/* Initialize DDT DMA pools based on this device's resources */
+	if (pdu_mem_init(&pdev->dev)) {
+		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
+		return -ENOMEM;
+	}
+
+	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "SPAcc dtb missing");
+		return -ENODEV;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "no memory resource for spacc\n");
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		err = -ENOMEM;
+		goto free_ddt_mem_pool;
+	}
+
+	/* Read spacc priority and index and save inside priv.spacc.config */
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_priority",
+				 &spacc_priority)) {
+		dev_err(&pdev->dev, "No vspacc priority specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	if (spacc_priority < 0 && spacc_priority > VSPACC_PRIORITY_MAX) {
+		dev_err(&pdev->dev, "Invalid vspacc priority\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+	priv->spacc.config.priority = spacc_priority;
+
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_index",
+				 &spacc_idx)) {
+		dev_err(&pdev->dev, "No vspacc index specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+	priv->spacc.config.idx = spacc_idx;
+
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",
+				 &spacc_endian)) {
+		dev_dbg(&pdev->dev, "No spacc_endian specified\n");
+		dev_dbg(&pdev->dev, "Default spacc Endianness (0==little)\n");
+		spacc_endian = 0;
+	}
+	priv->spacc.config.spacc_endian = spacc_endian;
+
+	if (of_property_read_u64(pdev->dev.of_node, "oldtimer",
+				 &oldtimer)) {
+		dev_dbg(&pdev->dev, "No oldtimer specified\n");
+		dev_dbg(&pdev->dev, "Default oldtimer (100000)\n");
+		oldtimer = 100000;
+	}
+	priv->spacc.config.oldtimer = oldtimer;
+
+	if (of_property_read_u64(pdev->dev.of_node, "timer", &timer)) {
+		dev_dbg(&pdev->dev, "No timer specified\n");
+		dev_dbg(&pdev->dev, "Default timer (100000)\n");
+		timer = 100000;
+	}
+	priv->spacc.config.timer = timer;
+
+	baseaddr = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(baseaddr)) {
+		dev_err(&pdev->dev, "unable to map iomem\n");
+		err = PTR_ERR(baseaddr);
+		goto free_ddt_mem_pool;
+	}
+
+	pdu_get_version(baseaddr, &info);
+	if (pdev->dev.platform_data) {
+		struct pdu_info *parent_info = pdev->dev.platform_data;
+
+		memcpy(&info.pdu_config, &parent_info->pdu_config,
+		       sizeof(info.pdu_config));
+	}
+
+	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
+				info.spacc_version.project,
+				info.spacc_version.vspacc_idx);
+
+	/* Validate virtual spacc index with vspacc count read from
+	 * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3, gives valid index 0,1,2
+	 */
+	if (spacc_idx != info.spacc_version.vspacc_idx) {
+		dev_err(&pdev->dev, "DTS vspacc_idx mismatch read value\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	if (spacc_idx < 0 || spacc_idx > (info.spacc_config.num_vspacc - 1)) {
+		dev_err(&pdev->dev, "Invalid vspacc index specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	err = spacc_init(baseaddr, &priv->spacc, &info);
+	if (err != CRYPTO_OK) {
+		dev_err(&pdev->dev, "Failed to initialize device %d\n", x);
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	spin_lock_init(&priv->hw_lock);
+	spacc_irq_glbl_disable(&priv->spacc);
+	tasklet_init(&priv->pop_jobs, spacc_pop_jobs, (unsigned long)priv);
+
+	priv->spacc.dptr = &pdev->dev;
+	platform_set_drvdata(pdev, priv);
+
+	irq_num = platform_get_irq(pdev, 0);
+	if (irq_num < 0) {
+		dev_err(&pdev->dev, "no irq resource for spacc\n");
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	/* Determine configured maximum message length. */
+	priv->max_msg_len = priv->spacc.config.max_msg_size;
+
+	if (devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
+			     IRQF_SHARED, dev_name(&pdev->dev),
+			     &pdev->dev)) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		err = -EBUSY;
+		goto err_tasklet_kill;
+	}
+
+	priv->spacc.irq_cb_stat = spacc_stat_process;
+	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
+	oldmode = priv->spacc.op_mode;
+	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
+
+	spacc_irq_stat_enable(&priv->spacc, 1);
+	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
+	spacc_irq_stat_wd_disable(&priv->spacc);
+	spacc_irq_glbl_enable(&priv->spacc);
+
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
+	err = spacc_autodetect(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto err_tasklet_kill;
+	}
+#else
+	err = spacc_static_config(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto err_tasklet_kill;
+	}
+#endif
+
+	priv->spacc.op_mode = oldmode;
+
+	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
+		priv->spacc.irq_cb_stat = spacc_stat_process;
+		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
+
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
+		spacc_irq_cmdx_disable(&priv->spacc, 0);
+		spacc_irq_stat_wd_enable(&priv->spacc);
+		spacc_irq_glbl_enable(&priv->spacc);
+
+		/* enable the wd by setting the wd_timer = 100000 */
+		spacc_set_wd_count(&priv->spacc,
+				   priv->spacc.config.wd_timer =
+						priv->spacc.config.timer);
+	}
+
+	/* unlock normal*/
+	if (priv->spacc.config.is_secure_port) {
+		u32 t;
+
+		t = readl(baseaddr + SPACC_REG_SECURE_CTRL);
+		t &= ~(1UL << 31);
+		writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
+	}
+
+	/* unlock device by default*/
+	writel(0, baseaddr + SPACC_REG_SECURE_CTRL);
+
+	return err;
+
+err_tasklet_kill:
+	tasklet_kill(&priv->pop_jobs);
+	spacc_fini(&priv->spacc);
+
+free_ddt_mem_pool:
+	pdu_mem_deinit(&pdev->dev);
+
+	return err;
+}
+
+static void spacc_unregister_algs(struct device *dev)
+{
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	spacc_unregister_hash_algs();
+#endif
+#if  IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
+	spacc_unregister_aead_algs();
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
+	spacc_unregister_cipher_algs();
+#endif
+}
+
+static const struct of_device_id snps_spacc_id[] = {
+	{.compatible = "snps-dwc-spacc" },
+	{ /*sentinel */        }
+};
+
+MODULE_DEVICE_TABLE(of, snps_spacc_id);
+
+static int spacc_crypto_probe(struct platform_device *pdev)
+{
+	int rc;
+
+	rc = spacc_probe(pdev, snps_spacc_id);
+	if (rc < 0)
+		goto err;
+
+	spacc_pdev[0] = pdev;
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	rc = probe_hashes(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
+	rc = probe_ciphers(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
+	rc = probe_aeads(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+	return 0;
+err:
+	spacc_unregister_algs(NULL);
+
+	return rc;
+}
+
+static int spacc_crypto_remove(struct platform_device *pdev)
+{
+	spacc_unregister_algs(NULL);
+	spacc_remove(pdev);
+
+	return 0;
+}
+
+static struct platform_driver spacc_driver = {
+	.probe  = spacc_crypto_probe,
+	.remove = spacc_crypto_remove,
+	.driver = {
+		.name  = "spacc",
+		.of_match_table = of_match_ptr(snps_spacc_id),
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(spacc_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Synopsys, Inc.");
diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
new file mode 100644
index 000000000000..b4266147198c
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.h
@@ -0,0 +1,236 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_DEVICE_H_
+#define SPACC_DEVICE_H_
+
+#include <crypto/hash.h>
+#include <crypto/ctr.h>
+#include <crypto/internal/aead.h>
+#include <linux/of.h>
+#include "spacc_core.h"
+
+#define MODE_TAB_AEAD(_name, _ciph, _hash, _hashlen, _ivlen, _blocklen) \
+	.name = _name, .aead = { .ciph = _ciph, .hash = _hash }, \
+	.hashlen = _hashlen, .ivlen = _ivlen, .blocklen = _blocklen
+
+/* Helper macros for initializing the hash/cipher tables. */
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
+#define MODE_TAB_HASH_XCBC 0x8000
+
+/* Max # of SPAcc devices to look at in our CAPI driver...*/
+#define ELP_CAPI_MAX_DEV       8
+
+#define SPACC_MAX_DIGEST_SIZE 64
+#define SPACC_MAX_KEY_SIZE    32
+#define SPACC_MAX_IV_SIZE     16
+
+#define SPACC_DMA_ALIGN    4
+#define SPACC_DMA_BOUNDARY 0x10000
+
+/* flag means the IV is computed from setkey and crypt*/
+#define SPACC_MANGLE_IV_FLAG    0x8000
+
+/* we're doing a CTR mangle (for RFC3686/IPsec)*/
+#define SPACC_MANGLE_IV_RFC3686 0x0100
+
+/* we're doing GCM */
+#define SPACC_MANGLE_IV_RFC4106 0x0200
+
+/* we're doing GMAC */
+#define SPACC_MANGLE_IV_RFC4543 0x0300
+
+/* we're doing CCM */
+#define SPACC_MANGLE_IV_RFC4309 0x0400
+
+/* we're doing SM4 GCM/CCM */
+#define SPACC_MANGLE_IV_RFC8998 0x0500
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
+
+	spinlock_t lock;
+	struct list_head jobs;
+	int handle, mode, auth_size, key_len;
+	unsigned char *cipher_key;
+
+	/*
+	 * Indicates that the H/W context has been setup and can be used for
+	 * crypto; otherwise, the software fallback will be used.
+	 */
+	bool ctx_valid;
+	unsigned int flag_ppp;
+
+	/* salt used for rfc3686/givencrypt mode */
+	unsigned char csalt[16];
+	u8 ipad[128] __aligned(sizeof(u32));
+	u8 digest_ctx_buf[128] __aligned(sizeof(u32));
+	u8 ppp_buffer[128] __aligned(sizeof(u32));
+
+	/* Save keylen from setkey */
+	int keylen;
+	u8 key[256];
+	int zero_key;
+	struct scatterlist *ppp_sgl;
+
+	union{
+		struct crypto_ahash      *hash;
+		struct crypto_aead       *aead;
+		struct crypto_skcipher   *cipher;
+	} fb;
+};
+
+struct spacc_crypto_reqctx {
+	struct pdu_ddt src, dst;
+	void *digest_buf, *iv_buf;
+	dma_addr_t digest_dma, iv_dma;
+	int fulliv_nents, ptext_nents, iv_nents, assoc_nents, src_nents,
+	dst_nents;
+	int total_nents, single_shot, small_pck, cur_part_pck, final_part_pck;
+	int encrypt_op, mode;
+	unsigned int head_sg, tail_sg, rem_len, rem_nents, first_ppp_chunk;
+	unsigned int crypt_len;
+
+	struct aead_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct aead_request        *req;
+		struct spacc_device		*spacc;
+	} cb;
+
+	struct ahash_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct ahash_request       *req;
+		struct spacc_device        *spacc;
+	} acb;
+
+	struct cipher_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct skcipher_request    *req;
+		struct spacc_device        *spacc;
+	} ccb;
+
+	/* The fallback request must be the last member of this struct. */
+	union {
+		struct ahash_request hash_req;
+		struct skcipher_request cipher_req;
+		struct aead_request aead_req;
+	} fb;
+};
+
+struct mode_tab {
+	char name[48];
+
+	int valid;
+
+	/* mode ID used in hash/cipher mode but not aead*/
+	int id;
+
+	/* ciph/hash mode used in aead */
+	struct {
+		int ciph, hash;
+	} aead;
+
+	unsigned int hashlen, ivlen, blocklen, keylen[3], keylen_mask, testlen,
+	chunksize, walksize, min_keysize, max_keysize;
+
+	bool sw_fb;
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
+	struct device *dev[ELP_CAPI_MAX_DEV + 1];
+
+	struct list_head list;
+	struct crypto_alg *calg;
+	struct crypto_tfm *tfm;
+
+	union {
+		struct ahash_alg hash;
+		struct aead_alg aead;
+		struct skcipher_alg skcipher;
+	} alg;
+};
+
+static inline const struct spacc_alg *spacc_tfm_ahash(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
+		return container_of(calg, struct spacc_alg, alg.hash.halg.base);
+
+	return NULL;
+}
+
+static inline const struct spacc_alg *spacc_tfm_skcipher(struct crypto_tfm
+		*tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+			CRYPTO_ALG_TYPE_SKCIPHER)
+		return container_of(calg, struct spacc_alg, alg.skcipher.base);
+
+	return NULL;
+}
+
+static inline const struct spacc_alg *spacc_tfm_aead(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AEAD)
+		return container_of(calg, struct spacc_alg, alg.aead.base);
+
+	return NULL;
+}
+
+int probe_hashes(struct platform_device *spacc_pdev);
+int spacc_unregister_hash_algs(void);
+
+int probe_aeads(struct platform_device *spacc_pdev);
+int spacc_unregister_aead_algs(void);
+
+int probe_ciphers(struct platform_device *spacc_pdev);
+int spacc_unregister_cipher_algs(void);
+
+int spacc_probe(struct platform_device *pdev, const struct of_device_id
+		snps_spacc_id[]);
+
+irqreturn_t spacc_irq_handler(int irq, void *dev);
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.c b/drivers/crypto/dwc-spacc/spacc_hal.c
new file mode 100644
index 000000000000..87da658f3ac7
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.c
@@ -0,0 +1,365 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include "spacc_hal.h"
+
+static struct dma_pool *ddt_pool, *ddt16_pool, *ddt4_pool;
+static struct device *ddt_device;
+
+#define PDU_REG_SPACC_VERSION   0x00180UL
+#define PDU_REG_SPACC_CONFIG    0x00184UL
+#define PDU_REG_SPACC_CONFIG2   0x00190UL
+#define PDU_REG_SPACC_IV_OFFSET 0x00040UL
+#define PDU_REG_PDU_CONFIG      0x00188UL
+#define PDU_REG_SECURE_LOCK     0x001C0UL
+
+int pdu_get_version(void *dev, struct pdu_info *inf)
+{
+	unsigned long tmp;
+
+	if (!inf)
+		return -1;
+
+	memset(inf, 0, sizeof(*inf));
+	tmp = readl(dev + PDU_REG_SPACC_VERSION);
+
+	/* Read the SPAcc version block this tells us the revision,
+	 * project, and a few other feature bits
+	 */
+	/* layout for v6.5+ */
+	inf->spacc_version = (struct spacc_version_block) {
+		.minor = SPACC_ID_MINOR(tmp),
+		.major = SPACC_ID_MAJOR(tmp),
+		.version = (SPACC_ID_MAJOR(tmp) << 4) |
+			SPACC_ID_MINOR(tmp),
+		.qos = SPACC_ID_QOS(tmp),
+		.is_spacc = SPACC_ID_TYPE(tmp) == SPACC_TYPE_SPACCQOS,
+		.is_pdu = SPACC_ID_TYPE(tmp) ==	SPACC_TYPE_PDU,
+		.aux = SPACC_ID_AUX(tmp),
+		.vspacc_idx = SPACC_ID_VIDX(tmp),
+		.partial = SPACC_ID_PARTIAL(tmp),
+		.project = SPACC_ID_PROJECT(tmp),
+	};
+
+	/* try to autodetect */
+	writel(0x80000000, dev + PDU_REG_SPACC_IV_OFFSET);
+
+	if (readl(dev + PDU_REG_SPACC_IV_OFFSET) == 0x80000000)
+		inf->spacc_version.ivimport = 1;
+	else
+		inf->spacc_version.ivimport = 0;
+
+
+	/* Read the SPAcc config block (v6.5+) which tells us how many */
+	/* contexts there are and context page sizes */
+	/* this register only available in v6.5 and up */
+	tmp = readl(dev + PDU_REG_SPACC_CONFIG);
+	inf->spacc_config = (struct
+			spacc_config_block){SPACC_CFG_CTX_CNT(tmp),
+		SPACC_CFG_VSPACC_CNT(tmp),
+		SPACC_CFG_CIPH_CTX_SZ(tmp),
+		SPACC_CFG_HASH_CTX_SZ(tmp),
+		SPACC_CFG_DMA_TYPE(tmp), 0, 0, 0, 0};
+
+	/* CONFIG2 only present in v6.5+ cores */
+	tmp = readl(dev + PDU_REG_SPACC_CONFIG2);
+	if (inf->spacc_version.qos) {
+		inf->spacc_config.cmd0_fifo_depth =
+			SPACC_CFG_CMD0_FIFO_QOS(tmp);
+		inf->spacc_config.cmd1_fifo_depth =
+			SPACC_CFG_CMD1_FIFO(tmp);
+		inf->spacc_config.cmd2_fifo_depth =
+
+				SPACC_CFG_CMD2_FIFO(tmp);
+		inf->spacc_config.stat_fifo_depth =
+			SPACC_CFG_STAT_FIFO_QOS(tmp);
+	} else {
+		inf->spacc_config.cmd0_fifo_depth =
+			SPACC_CFG_CMD0_FIFO(tmp);
+		inf->spacc_config.stat_fifo_depth =
+			SPACC_CFG_STAT_FIFO(tmp);
+	}
+
+	/* only read PDU config if it's actually a PDU engine */
+	if (inf->spacc_version.is_pdu) {
+		tmp = readl(dev + PDU_REG_PDU_CONFIG);
+		inf->pdu_config = (struct pdu_config_block)
+		{SPACC_PDU_CFG_MINOR(tmp),
+			SPACC_PDU_CFG_MAJOR(tmp)};
+
+		/* unlock all cores by default */
+		writel(0, dev + PDU_REG_SECURE_LOCK);
+	}
+
+	return 0;
+}
+
+void pdu_to_dev(void *addr_, uint32_t *src, unsigned long nword)
+{
+	unsigned char *addr = addr_;
+
+	while (nword--) {
+		writel(*src++, addr);
+		addr += 4;
+	}
+}
+
+void pdu_from_dev(u32 *dst, void *addr_, unsigned long nword)
+{
+	unsigned char *addr = addr_;
+
+	while (nword--) {
+		*dst++ = readl(addr);
+		addr += 4;
+	}
+}
+
+static void pdu_to_dev_big(void *addr_, const unsigned char *src,
+			   unsigned long nword)
+{
+	unsigned char *addr = addr_;
+	unsigned long v;
+
+	while (nword--) {
+		v = 0;
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		writel(v, addr);
+		addr += 4;
+	}
+}
+
+static void pdu_from_dev_big(unsigned char *dst, void *addr_,
+			     unsigned long nword)
+{
+	unsigned char *addr = addr_;
+	unsigned long v;
+
+	while (nword--) {
+		v = readl(addr);
+		addr += 4;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+	}
+}
+
+static void pdu_to_dev_little(void *addr_, const unsigned char *src,
+			      unsigned long nword)
+{
+	unsigned char *addr = addr_;
+	unsigned long v;
+
+	while (nword--) {
+		v = 0;
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		writel(v, addr);
+		addr += 4;
+	}
+}
+
+static void pdu_from_dev_little(unsigned char *dst, void *addr_, unsigned long
+				nword)
+{
+	unsigned char *addr = addr_;
+	unsigned long v;
+
+	while (nword--) {
+		v = readl(addr);
+		addr += 4;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+	}
+}
+
+void pdu_to_dev_s(void *addr, const unsigned char *src, unsigned long nword,
+		  int endian)
+{
+	if (endian)
+		pdu_to_dev_big(addr, src, nword);
+	else
+		pdu_to_dev_little(addr, src, nword);
+}
+
+void pdu_from_dev_s(unsigned char *dst, void *addr, unsigned long nword, int
+		endian)
+{
+	if (endian)
+		pdu_from_dev_big(dst, addr, nword);
+	else
+		pdu_from_dev_little(dst, addr, nword);
+}
+
+void pdu_io_cached_write(void *addr, unsigned long val, uint32_t *cache)
+{
+	if (*cache == val) {
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+		pr_debug("PDU: write %.8lx -> %p (cached)\n", val, addr);
+#endif
+		return;
+	}
+
+	*cache = val;
+	writel(val, addr);
+}
+
+struct device *get_ddt_device(void)
+{
+	return ddt_device;
+}
+
+/* Platform specific DDT routines */
+
+/*
+ * create a DMA pool for DDT entries this should help from splitting
+ * pages for DDTs which by default are 520 bytes long meaning we would
+ * otherwise waste 3576 bytes per DDT allocated...
+ * we also maintain a smaller table of 4 entries common for simple jobs
+ * which uses 480 fewer bytes of DMA memory.
+ * and for good measure another table for 16 entries saving 384 bytes
+ */
+int pdu_mem_init(void *device)
+{
+	if (ddt_device) {
+		/* Already setup */
+		return 0;
+	}
+
+	ddt_device = device;
+
+	ddt_pool = dma_pool_create("elpddt", device, (PDU_MAX_DDT + 1) * 8, 8,
+				   0); /* max of 64 DDT entries*/
+
+	if (!ddt_pool)
+		return -1;
+
+#if PDU_MAX_DDT > 16
+	/* max of 16 DDT entries */
+	ddt16_pool = dma_pool_create("elpddt16", device, (16 + 1) * 8, 8, 0);
+	if (!ddt16_pool) {
+		dma_pool_destroy(ddt_pool);
+		return -1;
+	}
+#else
+	ddt16_pool = ddt_pool;
+#endif
+	/* max of 4 DDT entries */
+	ddt4_pool = dma_pool_create("elpddt4", device, (4 + 1) * 8, 8, 0);
+	if (!ddt4_pool) {
+		dma_pool_destroy(ddt_pool);
+#if PDU_MAX_DDT > 16
+		dma_pool_destroy(ddt16_pool);
+#endif
+		return -1;
+	}
+
+	return 0;
+}
+
+/* destroy the pool */
+void pdu_mem_deinit(void *device)
+{
+	/* For now, just skip deinit except for matching device */
+	if (device != ddt_device)
+		return;
+
+	dma_pool_destroy(ddt_pool);
+
+#if PDU_MAX_DDT > 16
+	dma_pool_destroy(ddt16_pool);
+#endif
+	dma_pool_destroy(ddt4_pool);
+
+	ddt_device = NULL;
+}
+
+int pdu_ddt_init(struct pdu_ddt *ddt, unsigned long limit)
+{
+	/* set the MSB if we want to use an ATOMIC
+	 * allocation required for top half processing
+	 */
+	int flag = (limit & 0x80000000);
+
+	limit &= 0x7FFFFFFF;
+
+	if (limit + 1 >= SIZE_MAX / 8) {
+		/* Too big to even compute DDT size */
+		return -1;
+	} else if (limit > PDU_MAX_DDT) {
+		size_t len = 8 * ((size_t)limit + 1);
+
+		ddt->virt = dma_alloc_coherent(ddt_device, len, &ddt->phys,
+					       flag ? GFP_ATOMIC : GFP_KERNEL);
+	} else if (limit > 16) {
+		ddt->virt = dma_pool_alloc(ddt_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else if (limit > 4) {
+		ddt->virt = dma_pool_alloc(ddt16_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else {
+		ddt->virt = dma_pool_alloc(ddt4_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	}
+	ddt->idx = 0;
+	ddt->len = 0;
+	ddt->limit = limit;
+
+	if (!ddt->virt)
+		return -1;
+
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+		pr_debug("   DDT[%.8lx]: allocated %lu fragments\n",
+			 (unsigned long)ddt->phys, limit);
+#endif
+
+	return 0;
+}
+
+int pdu_ddt_add(struct pdu_ddt *ddt, dma_addr_t phys, unsigned long size)
+{
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+		pr_debug("   DDT[%.8lx]: 0x%.8lx size %lu\n",
+					(unsigned long)ddt->phys,
+					(unsigned long)phys, size);
+#endif
+
+	if (ddt->idx == ddt->limit)
+		return -1;
+
+	ddt->virt[ddt->idx * 2 + 0] = (uint32_t)phys;
+	ddt->virt[ddt->idx * 2 + 1] = size;
+	ddt->virt[ddt->idx * 2 + 2] = 0;
+	ddt->virt[ddt->idx * 2 + 3] = 0;
+	ddt->len += size;
+	++(ddt->idx);
+	return 0;
+}
+
+int pdu_ddt_free(struct pdu_ddt *ddt)
+{
+	if (ddt->virt) {
+		if (ddt->limit > PDU_MAX_DDT) {
+			size_t len = 8 * ((size_t)ddt->limit + 1);
+
+			dma_free_coherent(ddt_device, len, ddt->virt,
+					  ddt->phys);
+		} else if (ddt->limit > 16) {
+			dma_pool_free(ddt_pool, ddt->virt, ddt->phys);
+		} else if (ddt->limit > 4) {
+			dma_pool_free(ddt16_pool, ddt->virt, ddt->phys);
+		} else {
+			dma_pool_free(ddt4_pool, ddt->virt, ddt->phys);
+		}
+		ddt->virt = NULL;
+	}
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.h b/drivers/crypto/dwc-spacc/spacc_hal.h
new file mode 100644
index 000000000000..ce327ba513de
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_HAL_H
+#define SPACC_HAL_H
+
+/* Maximum number of DDT entries allowed*/
+#ifndef PDU_MAX_DDT
+#define PDU_MAX_DDT		64
+#endif
+
+/* Platform Generic */
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
+	#define SPACC_CFG_RC4_CTX_CNT(x)	(((x) >> 8) & 0x7F)
+	#define SPACC_CFG_VSPACC_CNT(x)		(((x) >> 16) & 0x0F)
+	#define SPACC_CFG_CIPH_CTX_SZ(x)	(((x) >> 20) & 0x07)
+	#define SPACC_CFG_HASH_CTX_SZ(x)	(((x) >> 24) & 0x0F)
+	#define SPACC_CFG_DMA_TYPE(x)		(((x) >> 28) & 0x03)
+
+	#define SPACC_CFG_CMD0_FIFO_QOS(x)	(((x) >> 0) & 0x7F)
+	#define SPACC_CFG_CMD0_FIFO(x)		(((x) >> 0) & 0x1FF)
+	#define SPACC_CFG_CMD1_FIFO(x)		(((x) >> 8) & 0x7F)
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
+#define CRYPTO_OK                      (0)
+
+struct spacc_version_block {
+	unsigned int minor,
+		     major,
+		     version,
+		     qos,
+		     is_spacc,
+		     is_pdu,
+		     aux,
+		     vspacc_idx,
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
+	u32            clockrate;
+	struct spacc_version_block spacc_version;
+	struct spacc_config_block  spacc_config;
+	struct pdu_config_block    pdu_config;
+};
+
+struct pdu_ddt {
+	dma_addr_t phys;
+	u32 *virt; //PK: lets make these to 64 bit pointers
+	u32 *virt_orig;
+	unsigned long idx, limit, len;
+};
+
+void pdu_io_cached_write(void *addr, unsigned long val, uint32_t *cache);
+void pdu_to_dev(void *addr, uint32_t *src, unsigned long nword);
+void pdu_from_dev(u32 *dst, void *addr, unsigned long nword);
+void pdu_from_dev_s(unsigned char *dst, void *addr, unsigned long nword,
+		    int endian);
+void pdu_to_dev_s(void *addr, const unsigned char *src, unsigned long nword,
+		  int endian);
+struct device *get_ddt_device(void);
+int pdu_mem_init(void *device);
+void pdu_mem_deinit(void *device);
+int pdu_ddt_init(struct pdu_ddt *ddt, unsigned long limit);
+int pdu_ddt_add(struct pdu_ddt *ddt, dma_addr_t phys, unsigned long size);
+int pdu_ddt_free(struct pdu_ddt *ddt);
+int pdu_get_version(void *dev, struct pdu_info *inf);
+
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_interrupt.c b/drivers/crypto/dwc-spacc/spacc_interrupt.c
new file mode 100644
index 000000000000..72a6dc47738d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_interrupt.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include "spacc_core.h"
+
+/* Read the IRQ status register and process as needed */
+
+uint32_t spacc_process_irq(struct spacc_device *spacc)
+{
+	u32 temp, tempreg;
+	int x, cmd_max;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* clear interrupt pin and run registered callback */
+	if (temp & SPACC_IRQ_STAT_STAT) {
+		SPACC_IRQ_STAT_CLEAR_STAT(spacc);
+		if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+			spacc->config.fifo_cnt <<= 2;
+			if (spacc->config.fifo_cnt >=
+					spacc->config.stat_fifo_depth)
+				spacc->config.fifo_cnt =
+					spacc->config.stat_fifo_depth;
+
+			/* update fifo count to allow more stati to pile up*/
+			spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt);
+			 /* reenable CMD0 empty interrupt*/
+			spacc_irq_cmdx_enable(spacc, 0, 0);
+		} else if (spacc->op_mode == SPACC_OP_MODE_WD) {
+		}
+		if (spacc->irq_cb_stat)
+			spacc->irq_cb_stat(spacc);
+	}
+
+	/* Watchdog IRQ */
+	if (spacc->op_mode == SPACC_OP_MODE_WD) {
+		if (temp & SPACC_IRQ_STAT_STAT_WD) {
+			if (++spacc->wdcnt == SPACC_WD_LIMIT) {
+				/* this happens when you get too many IRQs that
+				 *  go unanswered
+				 */
+				tempreg = readl(spacc->regmap +
+							SPACC_REG_IRQ_EN);
+				spacc_irq_stat_wd_disable(spacc);
+				 /* we set the STAT CNT to 1 so that every job
+				  * generates an IRQ now
+				  */
+				spacc_irq_stat_enable(spacc, 1);
+				spacc->op_mode = SPACC_OP_MODE_IRQ;
+				tempreg = readl(spacc->regmap +
+							SPACC_REG_IRQ_EN);
+			} else if (spacc->config.wd_timer < (0xFFFFFFUL >> 4)) {
+				/* if the timer isn't too high lets bump it up
+				 * a bit so as to give the IRQ a chance to
+				 * reply
+				 */
+				spacc_set_wd_count(spacc,
+						   spacc->config.wd_timer << 4);
+			}
+
+			SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc);
+			if (spacc->irq_cb_stat_wd)
+				spacc->irq_cb_stat_wd(spacc);
+		}
+	}
+
+	if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+		cmd_max = (spacc->config.is_qos ? SPACC_CMDX_MAX_QOS :
+				SPACC_CMDX_MAX);
+		for (x = 0; x < cmd_max; x++) {
+			if (temp & SPACC_IRQ_STAT_CMDX(x)) {
+				spacc->config.fifo_cnt = 1;
+				/* disable CMD0 interrupt since STAT=1 */
+				spacc_irq_cmdx_disable(spacc, x);
+				spacc_irq_stat_enable(spacc,
+						      spacc->config.fifo_cnt);
+
+				SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x);
+				/* run registered callback */
+				if (spacc->irq_cb_cmdx)
+					spacc->irq_cb_cmdx(spacc, x);
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return temp;
+}
+
+void spacc_set_wd_count(struct spacc_device *spacc, uint32_t val)
+{
+	writel(val, spacc->regmap + SPACC_REG_STAT_WD_CTRL);
+}
+
+/* cmdx and cmdx_cnt depend on HW config */
+/* cmdx can be 0, 1 or 2 */
+/* cmdx_cnt must be 2^6 or less */
+void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt)
+{
+	u32 temp;
+
+	/* read the reg, clear the bit range and set the new value */
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL) &
+		(~SPACC_IRQ_CTRL_CMDX_CNT_MASK(cmdx));
+	temp |= SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt);
+	writel(temp | SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt),
+			spacc->regmap + SPACC_REG_IRQ_CTRL);
+
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
+				SPACC_IRQ_EN_CMD(cmdx),
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+			(~SPACC_IRQ_EN_CMD(cmdx)),
+			spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt)
+{
+	u32 temp;
+
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL);
+	if (spacc->config.is_qos) {
+		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS);
+		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(stat_cnt);
+	} else {
+		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK);
+		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET(stat_cnt);
+	}
+
+	writel(temp, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
+				SPACC_IRQ_EN_STAT,
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+				(~SPACC_IRQ_EN_STAT),
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
+				SPACC_IRQ_EN_STAT_WD,
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+				(~SPACC_IRQ_EN_STAT_WD),
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
+				SPACC_IRQ_EN_GLBL,
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+				(~SPACC_IRQ_EN_GLBL),
+				spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_disable_int (struct spacc_device *spacc)
+{
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+/* a function to run callbacks in the IRQ handler */
+irqreturn_t spacc_irq_handler(int irq, void *dev)
+{
+	struct spacc_priv *priv =
+		platform_get_drvdata(to_platform_device(dev));
+	struct spacc_device *spacc = &priv->spacc;
+
+	if (spacc->config.oldtimer != spacc->config.timer) {
+		spacc_set_wd_count(&priv->spacc,
+				priv->spacc.config.wd_timer =
+							spacc->config.timer);
+
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
index 000000000000..47a934edaa0d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_manager.c
@@ -0,0 +1,670 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "spacc_core.h"
+
+#define MIN(x, y) (((x) < (y)) ? (x) : (y))
+
+/* prevent reading passed the end of the buffer */
+static void read_from_buf(unsigned char *dst, unsigned char *src,
+			  int off, int n, int max)
+{
+	if (!dst)
+		return;
+
+	while (off < max && n) {
+		*dst++ = src[off++];
+		--n;
+	}
+}
+
+static void write_to_buf(unsigned char *dst, const unsigned char *src,
+			 int off, int n, int len)
+{
+	if (!src)
+		return;
+
+	while (n && (off < len)) {
+		dst[off++] = *src++;
+		--n;
+	}
+}
+
+/* ctx_id is requested */
+/* This function is not meant to be called directly,
+ * it should be called from the job manager
+ */
+static int spacc_ctx_request(struct spacc_device *spacc,
+			     int ctx_id, int ncontig)
+{
+	int ret;
+	int x, y, count;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -1;
+
+	if (ctx_id > spacc->config.num_ctx)
+		return -1;
+
+	if (ncontig < 1 || ncontig > spacc->config.num_ctx)
+		return -1;
+
+	ret = CRYPTO_OK;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+	/* allocating scheme, look for contiguous contexts. Free contexts have
+	 * a ref_cnt of 0.
+	 */
+
+	/* if specific ctx_id is requested,
+	 * test the ncontig and then bump the ref_cnt
+	 */
+	if (ctx_id != -1) {
+		if ((&spacc->ctx[ctx_id])->ncontig != ncontig - 1)
+			ret = -1;
+	} else {
+		/* check to see if ncontig are free */
+		/* loop over all available contexts to find the first
+		 * ncontig empty ones
+		 */
+		//FIXME: is ncontig guaranteed to be <= spacc->config.num_ctx?
+		for (x = 0; x <= (spacc->config.num_ctx - ncontig); ) {
+			count = ncontig;
+			while (count) {
+				if ((&spacc->ctx[x + count - 1])->ref_cnt != 0) {
+					/* incr x to past failed count
+					 * location
+					 */
+					x = x + count;
+					break;
+				}
+				count--;
+			}
+			if (count != 0) {
+				ret = -1;
+				/* test next x */
+			} else {
+				ctx_id = x;
+				ret = CRYPTO_OK;
+				break;
+			}
+		}
+	}
+
+	if (ret == CRYPTO_OK) {
+		/* ctx_id is good so mark used */
+		for (y = 0; y < ncontig; y++)
+			(&spacc->ctx[ctx_id + y])->ref_cnt++;
+
+		(&spacc->ctx[ctx_id])->ncontig = ncontig - 1;
+	} else {
+		ctx_id = -1;
+	}
+
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+
+	return ctx_id;
+}
+
+static int spacc_ctx_release(struct spacc_device *spacc, int ctx_id)
+{
+	unsigned long lock_flag;
+	int ncontig;
+	int y;
+
+
+	if (ctx_id < 0 || ctx_id > spacc->config.num_ctx)
+		return -EINVAL;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+	/* release the base context and contiguous block */
+	ncontig = (&spacc->ctx[ctx_id])->ncontig;
+	for (y = 0; y <= ncontig; y++) {
+
+		if ((&spacc->ctx[ctx_id + y])->ref_cnt > 0)
+			(&spacc->ctx[ctx_id + y])->ref_cnt--;
+
+	}
+
+	if ((&spacc->ctx[ctx_id])->ref_cnt == 0) {
+		(&spacc->ctx[ctx_id])->ncontig = 0;
+#ifdef CONFIG_CRYPTO_DEV_SPACC_SECURE_MODE
+		/* TODO:  This driver works in harmony with "normal" kernel
+		 * processes so we release the context all the time
+		 * normally this would be done from a "secure" kernel process
+		 * (trustzone/etc).  This hack is so that SPACC.0
+		 * cores can both use the same context space.
+		 */
+		writel(ctx_id, spacc->regmap + SPACC_REG_SECURE_RELEASE);
+#endif
+	}
+
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+
+	return CRYPTO_OK;
+}
+
+/* Job manager */
+/* This will reset all job data, pointers, etc */
+void spacc_job_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_job *job;
+
+	for (x = 0; x < (SPACC_MAX_JOBS); x++) {
+		job = &spacc->job[x];
+		memset(job, 0, sizeof(struct spacc_job));
+		job->job_swid = SPACC_JOB_IDX_UNUSED;
+		job->job_used = SPACC_JOB_IDX_UNUSED;
+		spacc->job_lookup[x] = SPACC_JOB_IDX_UNUSED;
+	}
+}
+
+/* get a new job id and use a specific ctx_idx or -1 for a new one */
+int spacc_job_request(struct spacc_device *spacc, int ctx_idx)
+{
+	int x, ret;
+	unsigned long lock_flag;
+	struct spacc_job *job;
+
+	if (!spacc)
+		return -1;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	/* find the first available job id */
+	for (x = 0; x < SPACC_MAX_JOBS; x++) {
+		job = &spacc->job[x];
+		if (job->job_used == SPACC_JOB_IDX_UNUSED) {
+			job->job_used = x;
+			break;
+		}
+	}
+
+	if (x == SPACC_MAX_JOBS) {
+		ret = -1;
+	} else {
+		/* associate a single context to go with job */
+		ret = spacc_ctx_request(spacc, ctx_idx, 1);
+		if (ret != -1) {
+			job->ctx_idx = ret;
+			ret = x;
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_job_release(struct spacc_device *spacc, int job_idx)
+{
+	int ret;
+	unsigned long lock_flag;
+	struct spacc_job *job;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	job = &spacc->job[job_idx];
+	/* release context that goes with job */
+	ret = spacc_ctx_release(spacc, job->ctx_idx);
+	job->ctx_idx  = SPACC_CTX_IDX_UNUSED;
+	job->job_used = SPACC_JOB_IDX_UNUSED;
+	job->cb       = NULL; /* disable any callback*/
+
+	/* NOTE: this leaves ctrl data in memory */
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_handle_release(struct spacc_device *spacc, int job_idx)
+{
+	int ret = 0;
+	unsigned long lock_flag;
+	struct spacc_job *job;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	job = &spacc->job[job_idx];
+	job->job_used = SPACC_JOB_IDX_UNUSED;
+	job->cb       = NULL; /* disable any callback*/
+
+	/* NOTE: this leaves ctrl data in memory */
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+/* Return a context structure for a job idx or null if invalid */
+struct spacc_ctx *context_lookup_by_job(struct spacc_device *spacc, int
+		job_idx)
+{
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return NULL;
+
+	return &spacc->ctx[(&spacc->job[job_idx])->ctx_idx];
+}
+
+int spacc_process_jb(struct spacc_device *spacc)
+{
+	/* are there jobs in the buffer? */
+	while (spacc->jb_head != spacc->jb_tail) {
+		int x, y;
+
+		x = spacc->jb_tail;
+		if (spacc->job_buffer[x].active) {
+			y = spacc_packet_enqueue_ddt_ex(spacc,
+							0,
+					spacc->job_buffer[x].job_idx,
+					spacc->job_buffer[x].src,
+					spacc->job_buffer[x].dst,
+					spacc->job_buffer[x].proc_sz,
+					spacc->job_buffer[x].aad_offset,
+					spacc->job_buffer[x].pre_aad_sz,
+					spacc->job_buffer[x].post_aad_sz,
+					spacc->job_buffer[x].iv_offset,
+					spacc->job_buffer[x].prio);
+
+			if (y != -EBUSY)
+				spacc->job_buffer[x].active = 0;
+			else
+				return -1;
+		}
+
+		x = (x + 1);
+
+		if (x == SPACC_MAX_JOB_BUFFERS)
+			x = 0;
+
+		spacc->jb_tail = x;
+	}
+
+	return 0;
+}
+
+/* Write appropriate context data which depends on operation and mode */
+int spacc_write_context(struct spacc_device *spacc, int job_idx, int op, const
+		unsigned char *key, int ksz, const unsigned char *iv, int ivsz)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	unsigned char buf[300];
+	int buflen;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!job || !ctx)
+		ret = -EIO;
+	else {
+		switch (op) {
+		case SPACC_CRYPTO_OPERATION:
+			/* get page size and then read so we can do a
+			 * read-modify-write cycle
+			 */
+			buflen = MIN(sizeof(buf),
+				   (unsigned int)spacc->config.ciph_page_size);
+
+			pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2,
+				       spacc->config.spacc_endian);
+
+			switch (job->enc_mode) {
+			case CRYPTO_MODE_SM4_ECB:
+			case CRYPTO_MODE_SM4_CBC:
+			case CRYPTO_MODE_SM4_CFB:
+			case CRYPTO_MODE_SM4_OFB:
+			case CRYPTO_MODE_SM4_CTR:
+			case CRYPTO_MODE_SM4_CCM:
+			case CRYPTO_MODE_SM4_GCM:
+			case CRYPTO_MODE_SM4_CS1:
+			case CRYPTO_MODE_SM4_CS2:
+			case CRYPTO_MODE_SM4_CS3:
+			case CRYPTO_MODE_AES_ECB:
+			case CRYPTO_MODE_AES_CBC:
+			case CRYPTO_MODE_AES_CS1:
+			case CRYPTO_MODE_AES_CS2:
+			case CRYPTO_MODE_AES_CS3:
+			case CRYPTO_MODE_AES_CFB:
+			case CRYPTO_MODE_AES_OFB:
+			case CRYPTO_MODE_AES_CTR:
+			case CRYPTO_MODE_AES_CCM:
+			case CRYPTO_MODE_AES_GCM:
+				write_to_buf(buf, key, 0, ksz, buflen);
+				if (iv) {
+					unsigned char one[4] = { 0, 0, 0, 1 };
+					unsigned long enc1, enc2;
+
+					enc1 = CRYPTO_MODE_AES_GCM;
+					enc2 = CRYPTO_MODE_SM4_GCM;
+
+					write_to_buf(buf, iv, 32, ivsz, buflen);
+					if (ivsz == 12 &&
+					    (job->enc_mode ==  enc1 ||
+					     job->enc_mode == enc2))
+						write_to_buf(buf, one, 11 * 4, 4,
+							buflen);
+				}
+				break;
+			case CRYPTO_MODE_SM4_F8:
+			case CRYPTO_MODE_AES_F8:
+				if (key) {
+					write_to_buf(buf, key + ksz, 0, ksz, buflen);
+					write_to_buf(buf, key, 48, ksz, buflen);
+				}
+				write_to_buf(buf, iv, 32,  16, buflen);
+				break;
+			case CRYPTO_MODE_SM4_XTS:
+			case CRYPTO_MODE_AES_XTS:
+				if (key) {
+					write_to_buf(buf, key, 0, ksz >> 1, buflen);
+					write_to_buf(buf, key + (ksz >> 1), 48, ksz
+							>> 1, buflen);
+					/* divide by two since that's
+					 * what we program the hardware
+					 */
+					ksz = ksz >> 1;
+				}
+				write_to_buf(buf, iv, 32, 16, buflen);
+				break;
+			case CRYPTO_MODE_MULTI2_ECB:
+			case CRYPTO_MODE_MULTI2_CBC:
+			case CRYPTO_MODE_MULTI2_OFB:
+			case CRYPTO_MODE_MULTI2_CFB:
+				write_to_buf(buf, key,   0, ksz,  buflen);
+				write_to_buf(buf, iv, 0x28, ivsz, buflen);
+				if (ivsz <= 8) {
+					/*default to 128 rounds*/
+					unsigned char rounds[4] = {0, 0, 0, 128};
+
+					write_to_buf(buf, rounds, 0x30, 4,
+									buflen);
+				}
+				break;
+			case CRYPTO_MODE_3DES_CBC:
+			case CRYPTO_MODE_3DES_ECB:
+			case CRYPTO_MODE_DES_CBC:
+			case CRYPTO_MODE_DES_ECB:
+				write_to_buf(buf, iv, 0, 8, buflen);
+				write_to_buf(buf, key, 8, ksz, buflen);
+				break;
+			case CRYPTO_MODE_KASUMI_ECB:
+			case CRYPTO_MODE_KASUMI_F8:
+				write_to_buf(buf, iv, 16, 8, buflen);
+				write_to_buf(buf, key, 0, 16, buflen);
+				break;
+			case CRYPTO_MODE_SNOW3G_UEA2:
+			case CRYPTO_MODE_ZUC_UEA3:
+				write_to_buf(buf, key, 0, 32, buflen);
+				break;
+			case CRYPTO_MODE_CHACHA20_STREAM:
+			case CRYPTO_MODE_CHACHA20_POLY1305:
+				write_to_buf(buf, key, 0, ksz, buflen);
+				write_to_buf(buf, iv, 32, ivsz, buflen);
+				break;
+			case CRYPTO_MODE_NULL:
+			default:
+				break;
+			}
+
+			if (key) {
+				job->ckey_sz = SPACC_SET_CIPHER_KEY_SZ(ksz);
+				job->first_use = 1;
+			}
+			pdu_to_dev_s(ctx->ciph_key, buf, buflen >> 2,
+				     spacc->config.spacc_endian);
+			break;
+
+		case SPACC_HASH_OPERATION:
+			/* get page size and then read so we can do a
+			 * read-modify-write cycle
+			 */
+			buflen = MIN(sizeof(buf),
+				     (u32)spacc->config.hash_page_size);
+			pdu_from_dev_s(buf, ctx->hash_key, buflen >> 2,
+				       spacc->config.spacc_endian);
+
+			switch (job->hash_mode) {
+			case CRYPTO_MODE_MAC_XCBC:
+			case CRYPTO_MODE_MAC_SM4_XCBC:
+				if (key) {
+					write_to_buf(buf, key + (ksz - 32), 32,
+						32, buflen);
+					write_to_buf(buf, key, 0, (ksz - 32),
+						buflen);
+					job->hkey_sz =
+						SPACC_SET_HASH_KEY_SZ(ksz - 32);
+				}
+				break;
+			case CRYPTO_MODE_HASH_CRC32:
+			case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+			case CRYPTO_MODE_MAC_ZUC_UIA3:
+				if (key) {
+					write_to_buf(buf, key, 0, ksz, buflen);
+					job->hkey_sz =
+						SPACC_SET_HASH_KEY_SZ(ksz);
+				}
+				break;
+			case CRYPTO_MODE_MAC_POLY1305:
+				write_to_buf(buf, key, 0, ksz, buflen);
+				write_to_buf(buf, iv, 32, ivsz, buflen);
+				break;
+			case CRYPTO_MODE_HASH_CSHAKE128:
+			case CRYPTO_MODE_HASH_CSHAKE256:
+				/* use "iv" and "key" to */
+				/* pass s-string and n-string */
+				write_to_buf(buf, iv, 0, ivsz, buflen);
+				write_to_buf(buf, key,
+					spacc->config.string_size, ksz, buflen);
+				break;
+			case CRYPTO_MODE_MAC_KMAC128:
+			case CRYPTO_MODE_MAC_KMAC256:
+			case CRYPTO_MODE_MAC_KMACXOF128:
+			case CRYPTO_MODE_MAC_KMACXOF256:
+				/* use "iv" and "key" to pass s-string & key */
+				write_to_buf(buf, iv, 0, ivsz, buflen);
+				write_to_buf(buf, key,
+					spacc->config.string_size, ksz, buflen);
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+				break;
+			default:
+				if (key) {
+					job->hkey_sz =
+						SPACC_SET_HASH_KEY_SZ(ksz);
+					write_to_buf(buf, key, 0, ksz, buflen);
+				}
+			}
+			pdu_to_dev_s(ctx->hash_key, buf, buflen >> 2,
+				     spacc->config.spacc_endian);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int spacc_read_context(struct spacc_device *spacc, int job_idx, int op,
+		       unsigned char *key, int ksz, unsigned char *iv,
+		       int ivsz)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+	unsigned char buf[300];
+	int buflen;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx)
+		ret = -EIO;
+	else {
+		switch (op) {
+		case SPACC_CRYPTO_OPERATION:
+			buflen = MIN(sizeof(buf),
+				     (u32)spacc->config.ciph_page_size);
+			pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2,
+				       spacc->config.spacc_endian);
+
+			switch (job->enc_mode) {
+			case CRYPTO_MODE_SM4_ECB:
+			case CRYPTO_MODE_SM4_CBC:
+			case CRYPTO_MODE_SM4_CFB:
+			case CRYPTO_MODE_SM4_OFB:
+			case CRYPTO_MODE_SM4_CTR:
+			case CRYPTO_MODE_SM4_CCM:
+			case CRYPTO_MODE_SM4_GCM:
+			case CRYPTO_MODE_SM4_CS1:
+			case CRYPTO_MODE_SM4_CS2:
+			case CRYPTO_MODE_SM4_CS3:
+			case CRYPTO_MODE_AES_ECB:
+			case CRYPTO_MODE_AES_CBC:
+			case CRYPTO_MODE_AES_CS1:
+			case CRYPTO_MODE_AES_CS2:
+			case CRYPTO_MODE_AES_CS3:
+			case CRYPTO_MODE_AES_CFB:
+			case CRYPTO_MODE_AES_OFB:
+			case CRYPTO_MODE_AES_CTR:
+			case CRYPTO_MODE_AES_CCM:
+			case CRYPTO_MODE_AES_GCM:
+				read_from_buf(key, buf, 0, ksz, buflen);
+				read_from_buf(iv, buf,  32, 16, buflen);
+				break;
+			case CRYPTO_MODE_CHACHA20_STREAM:
+				read_from_buf(key, buf, 0, ksz, buflen);
+				read_from_buf(iv, buf, 32, 16, buflen);
+				break;
+			case CRYPTO_MODE_SM4_F8:
+			case CRYPTO_MODE_AES_F8:
+				if (key) {
+					read_from_buf(key + ksz, buf, 0,  ksz,
+						  buflen);
+					read_from_buf(key, buf, 48, ksz,
+							buflen);
+				}
+				read_from_buf(iv, buf, 32, 16, buflen);
+				break;
+			case CRYPTO_MODE_SM4_XTS:
+			case CRYPTO_MODE_AES_XTS:
+				if (key) {
+					read_from_buf(key, buf, 0, ksz >> 1,
+						  buflen);
+					read_from_buf(key + (ksz >> 1), buf, 48,
+						  ksz >> 1, buflen);
+				}
+				read_from_buf(iv, buf, 32, 16, buflen);
+				break;
+			case CRYPTO_MODE_MULTI2_ECB:
+			case CRYPTO_MODE_MULTI2_CBC:
+			case CRYPTO_MODE_MULTI2_OFB:
+			case CRYPTO_MODE_MULTI2_CFB:
+				read_from_buf(key, buf, 0, ksz, buflen);
+				/* Number of rounds at the end of the IV */
+				read_from_buf(iv, buf, 0x28, ivsz, buflen);
+				break;
+			case CRYPTO_MODE_3DES_CBC:
+			case CRYPTO_MODE_3DES_ECB:
+				read_from_buf(iv,  buf, 0,  8, buflen);
+				read_from_buf(key, buf, 8, 24, buflen);
+				break;
+			case CRYPTO_MODE_DES_CBC:
+			case CRYPTO_MODE_DES_ECB:
+				read_from_buf(iv,  buf, 0, 8, buflen);
+				read_from_buf(key, buf, 8, 8, buflen);
+				break;
+			case CRYPTO_MODE_KASUMI_ECB:
+			case CRYPTO_MODE_KASUMI_F8:
+				read_from_buf(iv,  buf, 16,  8, buflen);
+				read_from_buf(key, buf, 0,  16, buflen);
+				break;
+			case CRYPTO_MODE_SNOW3G_UEA2:
+			case CRYPTO_MODE_ZUC_UEA3:
+				read_from_buf(key, buf, 0, 32, buflen);
+				break;
+			case CRYPTO_MODE_NULL:
+			default:
+				break;
+			}
+			break;
+
+		case SPACC_HASH_OPERATION:
+			buflen = MIN(sizeof(buf),
+				     (u32)spacc->config.hash_page_size);
+			pdu_from_dev_s(buf, ctx->hash_key, buflen >> 2,
+				       spacc->config.spacc_endian);
+			switch (job->hash_mode) {
+			case CRYPTO_MODE_MAC_XCBC:
+			case CRYPTO_MODE_MAC_SM4_XCBC:
+				if (key && ksz <= 64) {
+					read_from_buf(key + (ksz - 32), buf, 32,
+						  32, buflen);
+					read_from_buf(key, buf, 0,  ksz - 32,
+						  buflen);
+				}
+				break;
+			case CRYPTO_MODE_HASH_CRC32:
+				read_from_buf(iv, buf, 0, ivsz, buflen);
+				break;
+			case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+			case CRYPTO_MODE_MAC_ZUC_UIA3:
+				read_from_buf(key, buf, 0,  32, buflen);
+				break;
+			default:
+				read_from_buf(key, buf, 0, ksz, buflen);
+			}
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/* Context manager */
+/* This will reset all reference counts, pointers, etc */
+void spacc_ctx_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_ctx *ctx;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+	/* initialize contexts */
+	for (x = 0; x < spacc->config.num_ctx; x++) {
+		ctx = &spacc->ctx[x];
+
+		/* sets everything including ref_cnt and ncontig to 0 */
+		memset(ctx, 0, sizeof(*ctx));
+
+		ctx->ciph_key = spacc->regmap + SPACC_CTX_CIPH_KEY + (x *
+				spacc->config.ciph_page_size);
+		ctx->hash_key = spacc->regmap + SPACC_CTX_HASH_KEY + (x *
+				spacc->config.hash_page_size);
+	}
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+}
+
diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
new file mode 100644
index 000000000000..07e3e446a5cd
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
@@ -0,0 +1,781 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/dma-mapping.h>
+#include <crypto/ctr.h>
+#include <linux/platform_device.h>
+#include "spacc_device.h"
+#include "spacc_core.h"
+#include <crypto/des.h>
+#include <crypto/internal/des.h>
+#include <crypto/scatterwalk.h>
+
+static LIST_HEAD(spacc_cipher_alg_list);
+static DEFINE_MUTEX(spacc_cipher_alg_mutex);
+
+struct mode_tab possible_ciphers[] = {
+	/* {keylen, MODE_TAB_CIPH(name, id, iv_len, blk_len)} */
+
+	/* SM4 */
+	{ MODE_TAB_CIPH("cbc(sm4)", SM4_CBC, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("ecb(sm4)", SM4_ECB, 0,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("ofb(sm4)", SM4_OFB, 16,  1), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("cfb(sm4)", SM4_CFB, 16,  1), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("ctr(sm4)", SM4_CTR, 16,  1), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("xts(sm4)", SM4_XTS, 16,  16), .keylen[0] = 32,
+	.chunksize = 16, .walksize = 16, .min_keysize = 32, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("cts(cbc(sm4))", SM4_CS3, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+
+	/* AES */
+	{ MODE_TAB_CIPH("cbc(aes)", AES_CBC, 16,  16), .keylen = { 16, 24, 32 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("ecb(aes)", AES_ECB, 0,  16), .keylen = { 16, 24, 32 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("xts(aes)", AES_XTS, 16,  16), .keylen = { 32, 64 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 32, .max_keysize = 64 },
+	{ MODE_TAB_CIPH("cts(cbc(aes))", AES_CS3, 16,  16), .keylen = { 16, 24,
+	32 }, .chunksize = 16, .walksize = 16, .min_keysize = 16,
+	.max_keysize = 32 },
+	{ MODE_TAB_CIPH("ctr(aes)", AES_CTR, 16,  1), .keylen = { 16, 24, 32
+	}, .chunksize = 16, .walksize = 16, .min_keysize = 16,
+	.max_keysize = 32 },
+
+	/* CHACHA20 */
+	{ MODE_TAB_CIPH("chacha20", CHACHA20_STREAM, 16, 1), .keylen[0] = 32,
+	.chunksize = 64, .walksize = 64, .min_keysize = 32, .max_keysize = 32 },
+
+	/* DES */
+	{ MODE_TAB_CIPH("ecb(des)", DES_ECB, 0,  8), .keylen[0] = 8,
+	.chunksize = 8, .walksize = 8, .min_keysize = 8, .max_keysize = 8},
+	{ MODE_TAB_CIPH("cbc(des)", DES_CBC, 8,  8), .keylen[0] = 8,
+	.chunksize = 8, .walksize = 8, .min_keysize = 8, .max_keysize = 8},
+	{ MODE_TAB_CIPH("ecb(des3_ede)", 3DES_ECB, 0,  8), .keylen[0] = 24,
+	.chunksize = 8, .walksize = 8, .min_keysize = 24, .max_keysize = 24 },
+	{ MODE_TAB_CIPH("cbc(des3_ede)", 3DES_CBC, 8,  8), .keylen[0] = 24,
+	.chunksize = 8, .walksize = 8, .min_keysize = 24, .max_keysize = 24 },
+
+	/* Below algorithms are not supported in crypto test manager */
+#ifdef ADDITIONAL_SPACC_SUPPORTED_CIPHERS
+	{ MODE_TAB_CIPH("ecb(kasumi)", KASUMI_ECB, 0,  64), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("f8(kasumi)", KASUMI_F8, 16,  64), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("snow3g_uea2", SNOW3G_UEA2, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("cs1(cbc(aes))", AES_CS1, 16,  16), .keylen = { 16, 24,
+	32 }, .chunksize = 16, .walksize = 16, .min_keysize = 16,
+	.max_keysize = 32},
+	{ MODE_TAB_CIPH("cs2(cbc(aes))", AES_CS2, 16,  16), .keylen = { 16, 24,
+	32 }, .chunksize = 16, .walksize = 16, .min_keysize = 16,
+	.max_keysize = 32},
+	{ MODE_TAB_CIPH("cs1(cbc(sm4))", SM4_CS1, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("cs2(cbc(sm4))", SM4_CS2, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("f8(sm4)", SM4_F8, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+#endif
+};
+
+static int spacc_skcipher_fallback(unsigned char *name,
+				   struct skcipher_request *req,
+				   int enc_dec)
+{
+	int ret = 0;
+	struct crypto_skcipher *reqtfm   = crypto_skcipher_reqtfm(req);
+	struct spacc_crypto_ctx *tctx    = crypto_skcipher_ctx(reqtfm);
+	struct  spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	tctx->fb.cipher = crypto_alloc_skcipher(name,
+						CRYPTO_ALG_TYPE_SKCIPHER,
+						CRYPTO_ALG_NEED_FALLBACK);
+
+	crypto_skcipher_set_reqsize(reqtfm,
+				    sizeof(struct spacc_crypto_reqctx) +
+				    crypto_skcipher_reqsize(tctx->fb.cipher));
+
+	ret = crypto_skcipher_setkey(tctx->fb.cipher, tctx->cipher_key,
+				     tctx->key_len);
+
+	skcipher_request_set_tfm(&ctx->fb.cipher_req, tctx->fb.cipher);
+
+	skcipher_request_set_crypt(&ctx->fb.cipher_req, req->src, req->dst,
+				   req->cryptlen, req->iv);
+
+	if (enc_dec)
+		ret = crypto_skcipher_decrypt(&ctx->fb.cipher_req);
+	else
+		ret = crypto_skcipher_encrypt(&ctx->fb.cipher_req);
+
+	crypto_free_skcipher(tctx->fb.cipher);
+	tctx->fb.cipher = NULL;
+
+	return ret;
+}
+
+static void spacc_cipher_cleanup_dma(struct device *dev,
+				     struct skcipher_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	if (req->dst != req->src) {
+		if (ctx->dst_nents) {
+			dma_unmap_sg(dev, req->dst, ctx->dst_nents,
+							DMA_FROM_DEVICE);
+			pdu_ddt_free(&ctx->dst);
+		}
+		if (ctx->src_nents) {
+			dma_unmap_sg(dev, req->src, ctx->src_nents,
+							DMA_TO_DEVICE);
+			pdu_ddt_free(&ctx->src);
+		}
+	} else {
+		if (ctx->src_nents) {
+			dma_unmap_sg(dev, req->src, ctx->src_nents,
+							DMA_TO_DEVICE);
+			pdu_ddt_free(&ctx->src);
+		}
+	}
+}
+
+static void spacc_cipher_cb(void *spacc, void *tfm)
+{
+	struct cipher_cb_data *cb = tfm;
+	int err = -1, rc;
+	int total_len;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(cb->req);
+
+	u32 status_reg = readl(cb->spacc->regmap + SPACC_REG_STATUS);
+	u32 status_ret = (status_reg >> 24) & 0x03;
+
+	if (ctx->mode == CRYPTO_MODE_DES_CBC ||
+	    ctx->mode == CRYPTO_MODE_3DES_CBC) {
+		rc = spacc_read_context(cb->spacc, cb->tctx->handle,
+					SPACC_CRYPTO_OPERATION, NULL, 0,
+					cb->req->iv, 8);
+	} else if (ctx->mode != CRYPTO_MODE_DES_ECB  &&
+		   ctx->mode != CRYPTO_MODE_3DES_ECB &&
+		   ctx->mode != CRYPTO_MODE_SM4_ECB  &&
+		   ctx->mode != CRYPTO_MODE_AES_ECB  &&
+		   ctx->mode != CRYPTO_MODE_SM4_XTS  &&
+		   ctx->mode != CRYPTO_MODE_KASUMI_ECB) {
+		if (status_ret == 0x3) {
+			err = -EINVAL;
+			goto REQ_DST_CP_SKIP;
+		}
+		rc = spacc_read_context(cb->spacc, cb->tctx->handle,
+					SPACC_CRYPTO_OPERATION, NULL, 0,
+					cb->req->iv, 16);
+	}
+
+	if (ctx->mode != CRYPTO_MODE_DES_ECB  ||
+	    ctx->mode != CRYPTO_MODE_DES_CBC  ||
+	    ctx->mode != CRYPTO_MODE_3DES_ECB ||
+	    ctx->mode != CRYPTO_MODE_3DES_CBC) {
+		if (status_ret == 0x03) {
+			err = -EINVAL;
+			goto REQ_DST_CP_SKIP;
+		}
+	}
+
+	if (ctx->mode == CRYPTO_MODE_SM4_ECB && status_ret == 0x03) {
+		err = -EINVAL;
+		goto REQ_DST_CP_SKIP;
+	}
+
+	total_len = cb->req->cryptlen;
+	if (ctx->mode == CRYPTO_MODE_SM4_XTS && total_len != 16) {
+		if (status_ret == 0x03) {
+			err = -EINVAL;
+			goto REQ_DST_CP_SKIP;
+		}
+	}
+
+	dma_sync_sg_for_cpu(cb->tctx->dev, cb->req->dst, ctx->dst_nents,
+				DMA_FROM_DEVICE);
+
+	err = cb->spacc->job[cb->new_handle].job_err;
+REQ_DST_CP_SKIP:
+	spacc_cipher_cleanup_dma(cb->tctx->dev, cb->req);
+	spacc_close(cb->spacc, cb->new_handle);
+
+	/* call complete */
+	skcipher_request_complete(cb->req, err);
+}
+
+static int spacc_cipher_init_dma(struct device *dev,
+				 struct skcipher_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+	int rc;
+
+	rc = spacc_sg_to_ddt(dev, req->src, req->cryptlen, &ctx->src,
+			     DMA_TO_DEVICE);
+	if (rc < 0) {
+		pdu_ddt_free(&ctx->src);
+		return rc;
+	}
+	ctx->src_nents = rc;
+
+	rc = spacc_sg_to_ddt(dev, req->dst, req->cryptlen, &ctx->dst,
+			     DMA_FROM_DEVICE);
+	if (rc < 0) {
+		pdu_ddt_free(&ctx->dst);
+		return rc;
+	}
+	ctx->dst_nents = rc;
+
+	return 0;
+}
+
+static int spacc_cipher_cra_init(struct crypto_tfm *tfm)
+{
+	const struct spacc_alg *salg = spacc_tfm_skcipher(tfm);
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	tctx->keylen = 0;
+	tctx->cipher_key = NULL;
+
+	tctx->handle    = -1;
+	tctx->ctx_valid = false;
+	tctx->dev       = get_device(salg->dev[0]);
+
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct spacc_crypto_reqctx));
+
+	return 0;
+}
+
+static void spacc_cipher_cra_exit(struct crypto_tfm *tfm)
+{
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+	if (tctx->cipher_key) {
+		kfree(tctx->cipher_key);
+		tctx->cipher_key = NULL;
+	}
+
+	if (tctx->handle >= 0)
+		spacc_close(&priv->spacc, tctx->handle);
+
+	put_device(tctx->dev);
+}
+
+
+static int check_keylen(struct crypto_skcipher *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	const struct spacc_alg *salg =  spacc_tfm_skcipher(&tfm->base);
+	int mode = salg->mode->id;
+
+
+	if (mode == CRYPTO_MODE_SM4_CBC ||
+	    mode == CRYPTO_MODE_SM4_ECB ||
+	    mode == CRYPTO_MODE_SM4_OFB ||
+	    mode == CRYPTO_MODE_SM4_CFB ||
+	    mode == CRYPTO_MODE_SM4_CTR ||
+	    mode == CRYPTO_MODE_SM4_XTS) {
+		if (keylen != 16 && keylen != 32)
+			return -EINVAL;
+	}
+
+	if (mode == CRYPTO_MODE_AES_CBC ||
+	    mode == CRYPTO_MODE_AES_ECB ||
+	    mode == CRYPTO_MODE_AES_CTR ||
+	    mode == CRYPTO_MODE_AES_CS3) {
+		if (keylen != 16 && keylen != 24 && keylen != 32)
+			return -EINVAL;
+	}
+
+	if (mode == CRYPTO_MODE_AES_XTS) {
+		if (keylen != 32 && keylen != 64 && keylen != 48)
+			return -EINVAL;
+	}
+
+	if (mode == CRYPTO_MODE_CHACHA20_STREAM) {
+		if (keylen != 32)
+			return -EINVAL;
+	}
+
+	if (mode == CRYPTO_MODE_DES_ECB  ||
+	    mode == CRYPTO_MODE_DES_CBC  ||
+	    mode == CRYPTO_MODE_3DES_ECB ||
+	    mode == CRYPTO_MODE_3DES_CBC) {
+		if (keylen != 8 && keylen != 24)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int spacc_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	int x = 0, return_value = 0, rc = 0, err;
+	const struct spacc_alg *salg    =  spacc_tfm_skcipher(&tfm->base);
+	struct spacc_crypto_ctx *tctx   = crypto_skcipher_ctx(tfm);
+	struct spacc_priv *priv         = dev_get_drvdata(tctx->dev);
+	struct spacc_crypto_reqctx *ctx	= crypto_skcipher_ctx(tfm);
+
+	err = check_keylen(tfm, key, keylen);
+	if (err)
+		return err;
+
+	ctx->mode = salg->mode->id;
+	tctx->key_len = keylen;
+	tctx->cipher_key = kmalloc(keylen, GFP_KERNEL);
+	memcpy(tctx->cipher_key, key, keylen);
+
+	if (tctx->handle >= 0) {
+		spacc_close(&priv->spacc, tctx->handle);
+		put_device(tctx->dev);
+		tctx->handle = -1;
+		tctx->dev    = NULL;
+	}
+
+	priv = NULL;
+
+	for (x = 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
+		priv = dev_get_drvdata(salg->dev[x]);
+		tctx->dev = get_device(salg->dev[x]);
+		return_value = spacc_isenabled(&priv->spacc, salg->mode->id,
+					       keylen);
+		if (return_value)
+			tctx->handle = spacc_open(&priv->spacc, salg->mode->id,
+						  CRYPTO_MODE_NULL, -1, 0,
+						  spacc_cipher_cb, tfm);
+		if (tctx->handle >= 0) {
+			dev_dbg(salg->dev[0], "passed to open SPAcc context\n");
+			break;
+		}
+		put_device(salg->dev[x]);
+	}
+
+	if (tctx->handle < 0) {
+		dev_dbg(salg->dev[0], "failed to open SPAcc context\n");
+		return -EINVAL;
+	}
+
+	/* Weak key Implementation for DES_ECB */
+	if (salg->mode->id == CRYPTO_MODE_DES_ECB) {
+		err = verify_skcipher_des_key(tfm, key);
+		if (err)
+			return -EINVAL;
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_F8 ||
+	    salg->mode->id == CRYPTO_MODE_AES_F8) {
+		/* f8 mode requires an IV of 128-bits and a key-salt mask,
+		 * equivalent in size to the key.
+		 * AES-F8 or SM4-F8 mode has a SALTKEY prepended to the base
+		 * key.
+		 */
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, key, 16,
+					 NULL, 0);
+	} else {
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, key, keylen,
+					 NULL, 0);
+	}
+
+	if (rc < 0) {
+		dev_dbg(salg->dev[0], "failed with SPAcc write context\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
+{
+	int rc = 0, ret = 0, i = 0, j = 0;
+	u8 ivc1[16];
+	int ivsize;
+	unsigned char chacha20_iv[16];
+	unsigned char *name;
+	unsigned int len = 0;
+	u32 num_iv = 0, diff;
+	u64 num_iv64 = 0, diff64;
+	struct crypto_skcipher *reqtfm  = crypto_skcipher_reqtfm(req);
+	struct spacc_crypto_ctx *tctx	= crypto_skcipher_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx	= skcipher_request_ctx(req);
+	struct spacc_priv *priv		= dev_get_drvdata(tctx->dev);
+	const struct spacc_alg *salg	=  spacc_tfm_skcipher(&reqtfm->base);
+	struct spacc_device *device_h	= &priv->spacc;
+
+	len = ctx->crypt_len / 16;
+
+	if (req->cryptlen == 0) {
+		if (salg->mode->id == CRYPTO_MODE_SM4_CS3  ||
+		    salg->mode->id == CRYPTO_MODE_SM4_XTS  ||
+		    salg->mode->id == CRYPTO_MODE_AES_XTS  ||
+		    salg->mode->id == CRYPTO_MODE_AES_CS3) {
+			return -EINVAL;
+		} else
+			return 0;
+	}
+
+	/* Given IV - <1st 4-bytes as counter value>
+	 *            <last 12-bytes as nonce>
+	 * Reversing the order of nonce & counter as,
+	 *            <1st 12-bytes as nonce>
+	 *            <last 4-bytes as counter>
+	 * and then write to HW context,
+	 * ex:
+	 * Given IV - 2a000000000000000000000000000002
+	 * Reverse order - 0000000000000000000000020000002a
+	 */
+	if (salg->mode->id == CRYPTO_MODE_CHACHA20_STREAM) {
+		for (i = 4; i < 16; i++) {
+			chacha20_iv[j] = req->iv[i];
+			j++;
+		}
+
+		j = j + 3;
+
+		for (i = 0; i <= 3; i++) {
+			chacha20_iv[j] = req->iv[i];
+			j--;
+		}
+		memcpy(req->iv, chacha20_iv, 16);
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_CFB) {
+		if (req->cryptlen%16 != 0) {
+			name = salg->calg->cra_name;
+			ret = spacc_skcipher_fallback(name,
+						      req, enc_dec);
+			return ret;
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_XTS ||
+	    salg->mode->id == CRYPTO_MODE_SM4_CS3 ||
+	    salg->mode->id == CRYPTO_MODE_AES_XTS ||
+	    salg->mode->id == CRYPTO_MODE_AES_CS3) {
+		if (req->cryptlen == 16) {
+			name = salg->calg->cra_name;
+			ret = spacc_skcipher_fallback(name, req, enc_dec);
+			return ret;
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_AES_CTR ||
+	    salg->mode->id == CRYPTO_MODE_SM4_CTR) {
+		/* copy the IV to local buffer */
+		for (i = 0; i < 16; i++)
+			ivc1[i] = req->iv[i];
+
+		/* 32-bit counter width */
+		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
+		   & (0x2)) {
+			for (i = 12; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX32 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap +
+			  SPACC_REG_VERSION_EXT_3)
+			  & (0x3)) { /* 64-bit counter width */
+
+			for (i = 8; i < 16; i++) {
+				num_iv64 <<= 8;
+				num_iv64 |= ivc1[i];
+			}
+
+			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
+
+			if (len > diff64) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap +
+			   SPACC_REG_VERSION_EXT_3)
+			   & (0x1)) { /* 16-bit counter width */
+
+			for (i = 14; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX16 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap +
+			   SPACC_REG_VERSION_EXT_3)
+			   & (0x0)) { /* 8-bit counter width */
+
+			for (i = 15; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX8 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_DES_CBC ||
+	    salg->mode->id == CRYPTO_MODE_3DES_CBC) {
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, NULL, 0,
+					 req->iv, 8);
+	} else if (salg->mode->id != CRYPTO_MODE_DES_ECB &&
+		   salg->mode->id != CRYPTO_MODE_3DES_ECB &&
+		   salg->mode->id != CRYPTO_MODE_SM4_ECB &&
+		   salg->mode->id != CRYPTO_MODE_AES_ECB &&
+		   salg->mode->id != CRYPTO_MODE_KASUMI_ECB) {
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, NULL, 0,
+					 req->iv, 16);
+	}
+
+	if (rc < 0)
+		pr_err("ERR: spacc_write_context\n");
+
+	ivsize = crypto_skcipher_ivsize(reqtfm);
+	/* Initialize the DMA */
+	rc = spacc_cipher_init_dma(tctx->dev, req);
+
+	ctx->ccb.new_handle = spacc_clone_handle(&priv->spacc, tctx->handle,
+						 &ctx->ccb);
+	if (ctx->ccb.new_handle < 0) {
+		spacc_cipher_cleanup_dma(tctx->dev, req);
+		dev_dbg(salg->dev[0], "failed to clone handle\n");
+		return -EINVAL;
+	}
+
+	/* copying the data to clone handle */
+	ctx->ccb.tctx  = tctx;
+	ctx->ccb.ctx   = ctx;
+	ctx->ccb.req   = req;
+	ctx->ccb.spacc = &priv->spacc;
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_CS3) {
+		int handle = ctx->ccb.new_handle;
+
+		if (handle < 0 || handle > SPACC_MAX_JOBS)
+			return -ENXIO;
+		device_h->job[handle].auxinfo_cs_mode = 3;
+	}
+
+	if (enc_dec) {  /* for decrypt */
+		rc = spacc_set_operation(&priv->spacc, ctx->ccb.new_handle, 1,
+					 ICV_IGNORE, IP_ICV_IGNORE, 0, 0, 0);
+		spacc_set_key_exp(&priv->spacc, ctx->ccb.new_handle);
+	} else {       /* for encrypt */
+		rc = spacc_set_operation(&priv->spacc, ctx->ccb.new_handle, 0,
+					 ICV_IGNORE, IP_ICV_IGNORE, 0, 0, 0);
+	}
+
+	rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->ccb.new_handle,
+				      &ctx->src, &ctx->dst, req->cryptlen,
+				      0, 0, 0, 0, 0);
+
+	if (rc < 0) {
+		spacc_cipher_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->ccb.new_handle);
+
+		if (rc != -EBUSY)
+			dev_err(tctx->dev, "failed to enqueue job, ERR: %d\n",
+				rc);
+		else if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+	}
+
+	priv->spacc.job[tctx->handle].first_use  = 0;
+	priv->spacc.job[tctx->handle].ctrl &=
+		~(1UL << priv->spacc.config.ctrl_map[SPACC_CTRL_KEY_EXP]);
+
+	return -EINPROGRESS;
+}
+
+static int spacc_cipher_encrypt(struct skcipher_request *req)
+{
+	int rv = 0;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	ctx->crypt_len = req->cryptlen;
+
+	/* 2nd argument of spacc_cipher_process()
+	 * -> [enc_dec - 0(encrypt), 1(decrypt)]
+	 */
+	rv = spacc_cipher_process(req, 0);
+
+	return rv;
+}
+
+static int spacc_cipher_decrypt(struct skcipher_request *req)
+{
+	int rv = 0;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	ctx->crypt_len = req->cryptlen;
+
+	/* 2nd argument of spacc_cipher_process()
+	 * -> [enc_dec - 0(encrypt), 1(decrypt)]
+	 */
+	rv = spacc_cipher_process(req, 1);
+
+	return rv;
+}
+
+struct skcipher_alg spacc_skcipher_alg = {
+	.setkey = spacc_cipher_setkey,
+	.encrypt = spacc_cipher_encrypt,
+	.decrypt = spacc_cipher_decrypt,
+	/*
+	 * @chunksize: Equal to the block size except for stream ciphers such as
+	 * CTR where it is set to the underlying block size.
+	 * @walksize: Equal to the chunk size except in cases where the
+	 * algorithm is considerably more efficient if it can operate on
+	 * multiple chunks in parallel. Should be a multiple of chunksize.
+	 */
+	.min_keysize	= 16,
+	.max_keysize	= 64,
+	.ivsize		= 16,
+	.chunksize	= 16,
+	.walksize	= 16,
+	.base = {
+		.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+			     CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize	= 16,
+		.cra_ctxsize	= sizeof(struct spacc_crypto_ctx),
+		.cra_priority	= 300,
+		.cra_init	= spacc_cipher_cra_init,
+		.cra_exit	= spacc_cipher_cra_exit,
+		.cra_module	= THIS_MODULE,
+	},
+};
+
+static void spacc_init_calg(struct crypto_alg *calg,
+			    const struct mode_tab *mode)
+{
+	snprintf(calg->cra_name, sizeof(calg->cra_name), "%s", mode->name);
+	snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
+		 "spacc-%s", mode->name);
+	calg->cra_blocksize = mode->blocklen;
+}
+
+static int spacc_register_cipher(struct spacc_alg *salg,
+				 unsigned int algo_idx)
+{
+	int rc;
+
+	salg->calg     = &salg->alg.skcipher.base;
+	salg->alg.skcipher = spacc_skcipher_alg;
+
+	/* this function will assign mode->name to calg->cra_name &
+	 * calg->cra_driver_name
+	 */
+	spacc_init_calg(salg->calg, salg->mode);
+	salg->alg.skcipher.ivsize = salg->mode->ivlen;
+	salg->alg.skcipher.base.cra_blocksize = salg->mode->blocklen;
+
+	salg->alg.skcipher.chunksize = possible_ciphers[algo_idx].chunksize;
+	salg->alg.skcipher.walksize = possible_ciphers[algo_idx].walksize;
+	salg->alg.skcipher.min_keysize = possible_ciphers[algo_idx].min_keysize;
+	salg->alg.skcipher.max_keysize = possible_ciphers[algo_idx].max_keysize;
+
+	rc = crypto_register_skcipher(&salg->alg.skcipher);
+	if (rc < 0)
+		return rc;
+
+	mutex_lock(&spacc_cipher_alg_mutex);
+	list_add(&salg->list, &spacc_cipher_alg_list);
+	mutex_unlock(&spacc_cipher_alg_mutex);
+
+	return 0;
+}
+
+int probe_ciphers(struct platform_device *spacc_pdev)
+{
+	struct spacc_alg *salg;
+	int rc;
+	int registered = 0;
+	unsigned int i, y;
+	struct spacc_priv *priv = dev_get_drvdata(&spacc_pdev->dev);
+
+	for (i = 0; i < ARRAY_SIZE(possible_ciphers); i++)
+		possible_ciphers[i].valid = 0;
+
+	for (i = 0; i < ARRAY_SIZE(possible_ciphers) &&
+	     (possible_ciphers[i].valid == 0); i++) {
+		for (y = 0; y < 3; y++) {
+			if (spacc_isenabled(&priv->spacc,
+					    possible_ciphers[i].id & 0xFF,
+					    possible_ciphers[i].keylen[y])) {
+				salg = kmalloc(sizeof(*salg), GFP_KERNEL);
+				if (!salg)
+					return -ENOMEM;
+				salg->mode = &possible_ciphers[i];
+
+				/* Copy all dev's over to the salg dev */
+				salg->dev[0]  = &spacc_pdev->dev;
+				salg->dev[1] = NULL;
+
+				if (possible_ciphers[i].valid == 0)
+					rc = spacc_register_cipher(salg, i);
+				if (rc < 0) {
+					kfree(salg);
+						continue;
+				}
+				dev_dbg(&spacc_pdev->dev,
+					"registered %s\n",
+					 possible_ciphers[i].name);
+				registered++;
+				possible_ciphers[i].valid = 1;
+			}
+		}
+	}
+
+	return registered;
+}
+
+int spacc_unregister_cipher_algs(void)
+{
+	struct spacc_alg *salg, *tmp;
+
+	mutex_lock(&spacc_cipher_alg_mutex);
+
+	list_for_each_entry_safe(salg, tmp, &spacc_cipher_alg_list, list) {
+		crypto_unregister_alg(salg->calg);
+		list_del(&salg->list);
+		kfree(salg);
+	}
+
+	mutex_unlock(&spacc_cipher_alg_mutex);
+
+	return 0;
+}
+
-- 
2.25.1

