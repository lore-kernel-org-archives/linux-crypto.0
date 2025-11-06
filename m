Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3B5318130
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428888; cv=none; b=i5asTMASycUpX53e0lv7aKBH1Fzu9nHCqu4Z1m6ATSdNPRIBYm7s8WSQ/6yaEy4OolhxC5epKtR+v3AfmRd+1gqAPN2X3IgLfsHXjCf7xNJDdGHt/H4wKqfBWkvNqd2X4AQU9A4uxL47Fcn3Myc/SsJimdvnK3snNKgc7L/zUAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428888; c=relaxed/simple;
	bh=s1TSeMY8TYeWUqJN+NLoCq/MH+IRv9s48jeTq7Gbbf8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TVvNVSyhTA+KKVyg9YIZE9SLEg57QXe0il5EAc4Irw7s4GpGnw+CPq6AGluudWlMeltzcalFuWHgb955PvYf9TGwGbMZU8sP/102fzeDJ6wobss9LHxjsFz4CzwIGpELZtYsxWQPU9z0SOSDRsr82Hkknp5SGwbToEMNk+EDX/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=V3xpKhRn; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="V3xpKhRn"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429c2f6a580so805225f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 03:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1762428884; x=1763033684; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0slMlJM7u9gD6l8dG4n25D1+B/Pqy3PuC+FWW1MvYSg=;
        b=V3xpKhRnHptAwvY//bqP7zQI0CW+Rddd3JmUhM2nf2vOH3X+X87cvp9cVIYPpdAf54
         IR6HnGTRgSPQeRsLggkEhsA9zxeSFfgHedP9lHvHlf1555uQVtAKA392BRYlJAZZzWdv
         pzDulkXn4cFYpjGjIfLkCGZcxVuQ0OXeY6GuTDwdks6YTStW0wxFwWSEOZfR17bUfHpv
         EUkLSIbAcmUwX15zt0rw9SLgAR4cTqv6oE8LlhZ5hKOc+i2IhOfGjnDpWFJXBwNagcz4
         rxClXu7xOjevORQh5rump8Om0hKMAN7QqAe4V2SqZJt0vMnw7XbMqddp62N2RhYDVLBO
         neWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428884; x=1763033684;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0slMlJM7u9gD6l8dG4n25D1+B/Pqy3PuC+FWW1MvYSg=;
        b=nwhNXkN60o3YEHMt84VBfCraautsp9d44CCihtVIk7YvLhBncyCKvBdnIL0K2Q1DD2
         dyvCX8tb1LQkmaaaujXoTPn/e71gH/7qcxuT4K3tLWJ26xSNtRYwTO20AziS2b9uV2uV
         7vJILq2Ldblwt99hokPlCnI/oQ5pbzh0kIQoaXKd5VcmPhtQIo1t+fh4kQp02XoV4T/M
         8G4og1gikyFxcgeTS7VH99ncAq4felA3LMzsvd7pfXqRSNbZefgKjHQfcWZrpYHsNnbG
         r0XtTKNnJUlVysFUUYh7e+qcQlgfYnXXDExLBC1baZrLSIdG+i2hwMHNo2FSEQ0Yd3Iu
         f5iA==
X-Forwarded-Encrypted: i=1; AJvYcCVgoInkk1XnHtXxp1uQBMyQugLmhLJmf5JR8JUUkIHjoDjTsd1LmNZ11GnEr33I3AHxqzxe0Evp0fr3pDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyASYjoOqxxmCtJa2GOK+DYwEDqX7qfkcP+kcTqjOdZld0GmaNg
	UHEfxMXukB3M/xx+OCbxHSzrqR5nRFgzi/9VMEOdhiryTizarYQhlaO0oM2gdDjv2Y0=
X-Gm-Gg: ASbGncviQCdcdNhtHeXXzi8ddIcvayFGf3pLYmF4DXpjrw3c3XBSXk7rQxfYHQ+Y0yY
	qUbGkSYAy0uhm7T8UbfJ3GzRSc/owDo7ehMGUMR7u4BMfhYzaEQmWSwMy2epiytr4hxBgUSb9m2
	mcyDeX78d0mW2To4ic9x0+ew3lr88MenMcS9co0YE9tiPkw40zGo8SyktVe6s54VXCZP8syFZFG
	fPhXQyphV4L7BTyOUO6VMlaxmy2w6xNtTkJuvJj4P2udWMjlYcNgxVWCDWdzKq6vMCTCQqQiU9S
	nVpSa/3PvyDKNPcvDHGcy4SJ3lprpWp/fexes37KkkcT7RF07KfZfFnK6g2qqaEWoxX6z2BcwO/
	X5BmsFNld6n6fI7P1dY17PljLNIHleA1mfUNOTe6/Xe8UQM1G+uzbwQyecTh2p3WUy/o0
X-Google-Smtp-Source: AGHT+IH/fiOSpX8Bd1PNfxDUNCCGWk+vEcb6nEZ3+jlgwUCbejOylW0/BOX0SYiK7oI9XmgnVzY0Qg==
X-Received: by 2002:a05:6000:1869:b0:3f2:b077:94bc with SMTP id ffacd0b85a97d-429e32dd886mr5841798f8f.4.1762428884172;
        Thu, 06 Nov 2025 03:34:44 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:d9de:4038:a78:acab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40379esm4389459f8f.9.2025.11.06.03.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:34:42 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 06 Nov 2025 12:34:07 +0100
Subject: [PATCH v8 11/11] crypto: qce - Switch to using BAM DMA for crypto
 I/O
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-qcom-qce-cmd-descr-v8-11-ecddca23ca26@linaro.org>
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
In-Reply-To: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6106;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=2zlVAHXO/DOwordNK3r9sCFLHH3vkgBdbL2WMJAKOzQ=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBpDIe9+1fIkMp/fEXn98fhQgw9tFW/4REfExT+H
 vU/2dMogemJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaQyHvQAKCRARpy6gFHHX
 crcnEADK/TmYg5xmjUrAjllFl8IKDa0f455O8YfKfKz4A4LxicVDLIxSp8O5LTaP6UvBKGtCTxV
 r4hadowYw+W2k/Xdt8Kw/27fBjoy4CnByQhWvNIsIWb6HbePWFP+0lpdCRd3hiurvyXEnYexLN2
 P+bO7meTR3UwUrCAPOYv/GHerTQgDBV+HZKHwI70CRqLwA2CadFjVWkYKTu07/pvICd5gCTv6EP
 eXmIuISa1Nb2sxnSJjzcIhzX7QtSzxZUZB+NhhBB1W3lyHAvin0ZjhV9GGzScUhKKQA+GsYWsIT
 XlOGfGNk+nlJm0lK8/3xFWu5n57z6iewexnhZvXhOo7LF+VZxyI1e4OOhI5D0hvhA7uPHxbj8Os
 oNAXqKAi+pOTivBdtMQZs8lVzpHi7TTTUH6MeZpTOTglj5zLtBVJ1jhSaOY+gLz992XLBcv2+D+
 ryDD89nYOoB7p8EVyBGc3biZlxhsTNCHXdWriVCAmt698iupYt44Ba2X1KUotJV1DndTdHjmzAV
 8laH52cTwVV/JKDoiWbA+l92liEZz0YT36YyfOsIH9wKF896gdVLbG2qTjW05wKZhfiFq7oWUnG
 V+1OvqIdw/WIYOMGomtxserWMNTz/64RcLxz7LQZpF5xYE451IcSOZcROwHayijUE+d2xTSpwx4
 2nmFiD4tTZ11bdw==
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

