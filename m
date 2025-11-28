Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCEA313525
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764330278; cv=none; b=M8RLdPFBqWi4s0bhQUwZG7h4xDTEJsk4q5K//JcTBg07NLYGtOV40gi43g2usqIwFZ1dTSeDXqnDeD45uYCyMMZwyUHHi2svkACM7hg7F0CRxeprTdCpmr+Jq10AZQcOb8etxKccoA+FiO9vg4zFSVVfPL2Tt2cwunQDwZleo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764330278; c=relaxed/simple;
	bh=s1TSeMY8TYeWUqJN+NLoCq/MH+IRv9s48jeTq7Gbbf8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DOZxaOIumwTi+Sh4vTjitrhjbTffV04PBxdQgCZ0sfIXZ32Eg8H1xwCTb8KyrXjMOLltAW7mtPV3Ti1VVIqdU7uHML8ARfI2ShRUFIWUz04yjTBetyoktEmhJm5zeubvTttApgNiSPWJaxaZCRvkySvXcdlCc8NGucsdz9Lev2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=jX7Qveym; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="jX7Qveym"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso7378565e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 03:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1764330270; x=1764935070; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0slMlJM7u9gD6l8dG4n25D1+B/Pqy3PuC+FWW1MvYSg=;
        b=jX7Qveyms/ZnLta+//hZiYGiYqUkBD6TTOZJFauYH4Q8LhapAYMXRYqtVnW9vxEtCe
         P4bnHYNHR7Sz0d6/eKr8JyMalElu3uQwcUuCOwROo7hb0NKCJF/U5DN+hYYdPmlfg8d5
         cvWKrWP/ley4pWXPvcPffJwmgnqV1jervB+qvEZRJCcMxxrFyBCUu+HDC78i2P/1tRRo
         SGcdhNBMjn1gnQmx+75w667msxRoKEcUIjk6ngVBIrgYuN6iEE/hR2umi4ofJa2cwQ0z
         D/XnbNj5dpT0ehmGVeKhTmolQUdHoRNaBDeS2nEMep5oH5dwcXcThqlc9TPTpPvjE7fm
         8+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764330270; x=1764935070;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0slMlJM7u9gD6l8dG4n25D1+B/Pqy3PuC+FWW1MvYSg=;
        b=C0hSkb8MDoTMmXJ5gIYr9Oc7PptLIPK2vpmFE65eq4lsmcDk6b/PSyNFZi944+a6tk
         WDM9siBhm3zhWB5Tm99qs6GRDlcw/ZLNZVr70HiIWqo7MAneUQb/C8vO2eszh1Hc8rEQ
         q5wXk4om0BP2Xv7PxoxiM6xlc8ybpKfhuell+QHVmwbVO5uSTWhF0XYa5syPmUXMDr3X
         X9dIT2YEM1YwEfiUeel1xtWcwz7NghbPes2sS5hvqpXQ9LbubVBxBI2oiqCMWmWbwvVu
         JJNIX7JFrgu/F8uWNoT09nI0azU4+klpXuwITq0xH5AMbr0AFm626NApWZqLMY2Q4izQ
         PWDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOiUxks9xeGa8E15lDQvfklHh2RFH1mTo50ziH2f+0Zdia7/2O6/vygXGbzmwKPZVRtFQGSfbi2/XHKMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7oe+pH8GUbW4N1n8kD6zLt/ZMfrxUSKkRkaXfidm8OmgoPuzr
	gq2KLsdBo1Wh9026WGVg31se1eKVy6UOivajXl0IMc1xFh2xsug2BGGnNEeV5JYN/84=
X-Gm-Gg: ASbGncvu9l0Om2+Ar2Bm5+TXLUkG9joH6uXhpgdNjc3LoRAq1zANa5VATWdo9QwWe8/
	HyzPI8ujd8/pfLTusPRhMkqhETky4yuBWawxRFxGcFp5N+JOvsZHZh3zgJglOh1UDslUKi/zpOT
	Id28N+xhfj011k41isuoxzo8cwZEakUaCOVkGyFu8faTHr2MliOkhEGjVyFfk8+9QEwL6h4UjPM
	lkXTQNtNSv9yR6+iLusjpMJXGCidVPL1TpH5dAI6Q4j1g/RqTbgoQlqZd3fk3TM3wkxp5w8aMWQ
	qiH5fjtxx3LVV0e9n5kN3n/3pF5okT477ksztnGMcsXaYKZh2ZhozxOusTUUrUsZX8II6cyWjZa
	BkW2pzqj+6v9Vd6DIWsoIcbYW/j1dbzog9Poep2Pw4vbbPycG6OGjwBE+Bi5n4Qvoe4DYpt5OIL
	RTxUXcGQ==
X-Google-Smtp-Source: AGHT+IHiFNtIlO4LqrcMmbtEMJgmSuRKa9qY+AWUXUaUq2NMI8ljNEJbZyCu/w1cNhv/t0kz4/Obhw==
X-Received: by 2002:a05:600c:474b:b0:477:9dc1:b706 with SMTP id 5b1f17b1804b1-477c01b494fmr272879555e9.19.1764330270423;
        Fri, 28 Nov 2025 03:44:30 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f3c6:aa54:79d2:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47906cb1f60sm89888445e9.1.2025.11.28.03.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 03:44:28 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 28 Nov 2025 12:44:09 +0100
Subject: [PATCH v9 11/11] crypto: qce - Switch to using BAM DMA for crypto
 I/O
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6106;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=2zlVAHXO/DOwordNK3r9sCFLHH3vkgBdbL2WMJAKOzQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpKYsKp4tQm0GWnTQy01SxXB3xWR1iKk4rN4PSQ
 fUHd+ZfrRyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaSmLCgAKCRAFnS7L/zaE
 w/k4D/9k60fNt06wowVTko9mwWQDpZ/lbTt/qRLhuMWJM+u344ZIGgGXAC2YwW2CuAsp4y2bCTS
 X970SrqB71sE+ZwXwzx9C9wSvvTtk1CppfVuIXlj+tUkwqGCm3Dv5xWiwv5Njok9vcX0ttv6GZk
 og+GTfv8gW/upb3+NveRPMKKefp7cGOiTAiU08t4CjvhEpfLKJPXc9lATLCWRLdKyjS6bEcACNp
 JFp4sNFaMBIpKcMmrL6lxV8xHqiJSI6L2FujyrSEtKhek7e2z3GVmLUf9vtW8cdp1y5jrRgY+5O
 Ge7kmNXzcYK/htsRVqFI5Ofa/RVUDDqmw3zNZKfCxu1hNshqqnHgc653oQjt57Uram9as+jm2FJ
 fqFNKlXznDzLdlPkd0i39XTEijuqJzAQsEJ6XHEk7XOq13wWxflv4ka3ftjTgut8JVTBytzvnIJ
 V67sBZ0rdDdR7qqXbHvW3zwnXnEzKOL9E/fBTznUVgmeNargKjwShGKqkEAlBEAXIvAw8ZlH0LX
 HmgCGPFznm9NuLeWkGlzSFyQgYZ4Tcy0+ue1NNxbrWEjqe6XDwCKYl2UC401gDUPhgwIn/T4/Gm
 1clZUXSOXtYrR8fYv3vXUn6PEoNLEp0xOcnE3w17drpux23K671+6MlZZAd1Ie8VeNYMmGuStMZ
 RkCkM1Ht3pI52HQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

With everything else in place, we can now switch to actually using the
BAM DMA for register I/O with DMA engine locking.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/crypto/qce/aead.c     | 10 ++++++++++
 drivers/crypto/qce/common.c   | 21 ++++++++++-----------
 drivers/crypto/qce/sha.c      |  8 ++++++++
 drivers/crypto/qce/skcipher.c |  7 +++++++
 4 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 11cec08544c912e562bf4b33d9a409f0e69a0ada..0fc69b019929342e14d3af8e24d7629ab171bc60 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -63,6 +63,10 @@ static void qce_aead_done(void *data)
 		sg_free_table(&rctx->dst_tbl);
 	}
 
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "aead: failed to unlock the BAM\n");
+
 	error = qce_check_status(qce, &status);
 	if (error < 0 && (error != -EBADMSG))
 		dev_err(qce->dev, "aead operation error (%x)\n", status);
@@ -188,6 +192,8 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct qce_aead_reqctx *rctx = aead_request_ctx_dma(req);
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
 	unsigned int assoclen = rctx->assoclen;
 	unsigned int adata_header_len, cryptlen, totallen;
 	gfp_t gfp;
@@ -200,6 +206,10 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 		cryptlen = rctx->cryptlen;
 	totallen = cryptlen + req->assoclen;
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	/* Get the msg */
 	msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
 
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 74756c222fed6d0298eb6c957ed15b8b7083b72f..930006aaba4accb51576ecfb84aa9cf20849a72f 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -14,6 +14,7 @@
 #include "cipher.h"
 #include "common.h"
 #include "core.h"
+#include "dma.h"
 #include "regs-v5.h"
 #include "sha.h"
 #include "aead.h"
@@ -25,7 +26,7 @@ static inline u32 qce_read(struct qce_device *qce, u32 offset)
 
 static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
 {
-	writel(val, qce->base + offset);
+	qce_write_dma(qce, offset, val);
 }
 
 static inline void qce_write_array(struct qce_device *qce, u32 offset,
@@ -82,6 +83,8 @@ static void qce_setup_config(struct qce_device *qce)
 {
 	u32 config;
 
+	qce_clear_bam_transaction(qce);
+
 	/* get big endianness */
 	config = qce_config_reg(qce, 0);
 
@@ -90,12 +93,14 @@ static void qce_setup_config(struct qce_device *qce)
 	qce_write(qce, REG_CONFIG, config);
 }
 
-static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
+static int qce_crypto_go(struct qce_device *qce, bool result_dump)
 {
 	if (result_dump)
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
 	else
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
+
+	return qce_submit_cmd_desc(qce);
 }
 
 #if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
@@ -223,9 +228,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -386,9 +389,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce, true);
-
-	return 0;
+	return qce_crypto_go(qce, true);
 }
 #endif
 
@@ -535,9 +536,7 @@ static int qce_setup_regs_aead(struct crypto_async_request *async_req)
 	qce_write(qce, REG_CONFIG, config);
 
 	/* Start the process */
-	qce_crypto_go(qce, !IS_CCM(flags));
-
-	return 0;
+	return qce_crypto_go(qce, !IS_CCM(flags));
 }
 #endif
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0c7aab711b7b8434d5f89ab4565ef4123fc5322e..286477a3001248e745d79b209aebb6ed6bf11f62 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -60,6 +60,10 @@ static void qce_ahash_done(void *data)
 	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
 	rctx->byte_count[1] = cpu_to_be32(result->auth_byte_count[1]);
 
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "ahash: failed to unlock the BAM\n");
+
 	error = qce_check_status(qce, &status);
 	if (error < 0)
 		dev_dbg(qce->dev, "ahash operation error (%x)\n", status);
@@ -90,6 +94,10 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (rctx->src_nents < 0) {
 		dev_err(qce->dev, "Invalid numbers of src SG.\n");
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index cab796cd7e43c548a49df468b2dde84942c5bd87..8317c79fb9c2b209884187d65655d04c580e9cde 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -51,6 +51,9 @@ static void qce_skcipher_done(void *data)
 	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 
 	sg_free_table(&rctx->dst_tbl);
+	error = qce_bam_unlock(qce);
+	if (error)
+		dev_err(qce->dev, "skcipher: failed to unlock the BAM\n");
 
 	error = qce_check_status(qce, &status);
 	if (error < 0)
@@ -78,6 +81,10 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
 	rctx->cryptlen = req->cryptlen;
 
+	ret = qce_bam_lock(qce);
+	if (ret)
+		return ret;
+
 	diff_dst = (req->src != req->dst) ? true : false;
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;

-- 
2.51.0

