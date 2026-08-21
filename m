Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5F03AC0D9
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288182; cv=none; b=fBu8W5tAAE56byCpwqJKwGuRh2F3Ntg9AcVkw4v/SyXleUjYKyRhNFEbm0Etg7U5cZRVX3KLGYYhERngT+iuwNQlKcCuv5IJ4bWMpHtxqQ90YIRCw/tXUPYi4K6IoBIli6oei+7iu596ghuGlqsRfguCDfQsT6ZA8FOB5bpYlNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288182; c=relaxed/simple;
	bh=lkNrMKx37gIAO05dD9M/A6tKLLRdr7XkW7tjnvEObAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bByE5WX/d8lKUNDUi3ZG3CDpmjFn4KpATmwwAe9bVHa+mFMeQBb8H2myvrNB9cyxK4kpwHzgqOVUf/vEDNcQgLVU7uT6nbQVz5ZdyEoCqtjUUTRptBRavfJEje5YSf0rUp5pGBGBSYO2gkjCu4ILGDwkMQp/SKObm9O29GCrofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=XwHjjMSZ; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="XwHjjMSZ"
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 04A9B44B8A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 04:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1787288170;
	bh=gyIdXhgrta0UR+ylzsvsJajvblw6ZqKRaY7y7WPUpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=XwHjjMSZUbZ3lY5dFrWPXEw9EHD4/5MDBScXKHZEuLTJObCjYw88RmcFWQ4NlrVtC
	 aXfox8TgfF3dljXzu/aVhc2KxoQ8atqY1i+gORfjHq0WwFCMyWVMN/JA/iLtFfTwzx
	 FPMkjM41F8TJzDU9CSntR1DJPeHwhit4WrQQkRGi5R7rfnHKsRFZ+OndlaVrD5uBpj
	 Y9qs8AkmKlaJI02qOfdn70THpRgFW1pvoTUeU5WztXUIEQUuheROiWw1VH7MfYDM6h
	 xiNXkbijzq3Lr112fn0SogrYIydnI5OSI4Ip/udOdU32fEWF1InKUO/bc2LOxhDJpI
	 0TmYDe+/x5aj4Cr5roWxsi6SDr4M9sloQDBlhQT05uzTyHzaFowS3lxXj5kU1Ww0R5
	 dz+BLT1OtxdEqMG7kIcU+A0fxIUIRCUQSJFBO3w4vqqj6ZbsWWYW2lc6xnrCSi5+rI
	 ZJY/5JX+4WpNM0E4EdXlWMdkzyv52rzkqEhpUFuqq0nXa4m2kbhHNjkRgu9+qB0Unx
	 Xact1VoCQqeKw75XbyMoFJgNGFgOKhGL9vTVA52uWTxOd6CeqRjC2WPO1o+SMQq4J8
	 JecYA1gcxmdwio4s06jRnHp12ihUVfaJAK0QPBKjGy+kF8jiuLACeEOH3XNWSyyJcV
	 MECPRkO7MqHwsRFL439YU8P8=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so772319a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 21:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787288168; x=1787892968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gyIdXhgrta0UR+ylzsvsJajvblw6ZqKRaY7y7WPUpYs=;
        b=cC1oIQXI48QQUHF6+EO4SEGZC63OF5y8lytfZ/SZMVBwHnclb4FOFIFBVB+rGNHV1t
         09ZPk4yCVLlCq5lvrrnaDdXVu8nAVBsvy1heHLvoQM7dNoO61g/Yl07HNxf26NNLV8uw
         nsSaBejHI2PiGIWlFrrF5q1xpTAqko2n705mHu/JSXmWer52eyuOMyMez5701vP9jBgO
         nKEp+Wc8OP71V12kxl+Rx1lJ80/8WIcxo/doxD0tVIX5+1gVCKkp7AsCLBXWaF0NdeOW
         7D0OhlcSw66hb8LXgjj4gMJx9FsC3+oWszHSX7IHICgV+mIVYheQfjwPWdlwrTYilb9l
         lnjg==
X-Gm-Message-State: AFuF++mqEizTT+UHMFVZ8N2rRnDeawXMLNJ7RzIEjFMKAp8fHz2dvAon
	hAezyxSBl9HpeVh7jz4+C/U5MDotrE5tIBCdCWtYIM/gEs5A2l7IHHDrr/AYB/dDcZst1P6I20a
	iIfu5xgJiG5+OAFCic7qKKWaru3MMX6VIsuJ2pSE3bbeeVuRC572mbzAXFezgcpkCuYADsQm12v
	NysYW1og==
X-Gm-Gg: AR+sD12MNe/fJidF/soDHo3IVsC4nuQoAGv8SUY+l2Xb1cMwkOLcoh7oE8hEQkt3qXI
	/qd2HOWURlwlEnVP4rb3A1dTX0zh0LBze758bpVsxIGJwLlcz88ForKuSjOcEQY7v+Vz9H4CLEc
	IdpQC6o5yiUwxsWYku//b5dzkWLuK+OTbgLSqoHyn4ea1Mq1ogkSTtCl0YpJppyNp4oy8e6T+9n
	Mdsxo/z9mHctzs5vJMkX0pMY6oo1TbOgeYYTc3hWewkw6J109K7j1lKHF22BHnEIHsvJMpa/UVZ
	J0Gj9w65On8DDTydn/j/4O01btxVrQefvRx+EmF0McoggH5Df/2G63D/PwpqlE5SRV/ty8dAQP3
	D6Yf+glfDkX4=
X-Received: by 2002:a17:90b:4fc2:b0:38d:dfd1:7a8 with SMTP id 98e67ed59e1d1-395c33e1194mr6834636a91.2.1787288168504;
        Thu, 20 Aug 2026 21:56:08 -0700 (PDT)
X-Received: by 2002:a17:90b:4fc2:b0:38d:dfd1:7a8 with SMTP id 98e67ed59e1d1-395c33e1194mr6834602a91.2.1787288168129;
        Thu, 20 Aug 2026 21:56:08 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4553168sm1535224a91.1.2026.08.20.21.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 21:56:07 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	changwei.zou@canonical.com
Subject: [PATCH 1/2] crypto: caam - Fix wrong unmap operations
Date: Fri, 21 Aug 2026 14:55:54 +1000
Message-ID: <20260821045555.806471-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260821045555.806471-1-changwei.zou@canonical.com>
References: <20260821045555.806471-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both akcipher_do_one_req() and akcipher_enqueue_req() call rsa_pub_unmap()
regardless of the key type. priv_form only takes values FORM1/FORM2/FORM3
with no distinct public key enumerator.

Use key->d to distinguish public from private key operations, then
dispatch to the correct unmap function based on key->priv_form.

caam_rsa_set_priv_key_form() implicitly relies on zero-initialization
for priv_form. Set priv_form = FORM1 explicitly at the head of the function
for clarity and robustness.

Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
---
 drivers/crypto/caam/caampkc.c | 43 +++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..840271840cce 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -379,6 +379,7 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
+	struct caam_rsa_key *key = &ctx->key;
 	struct device *jrdev = ctx->dev;
 	u32 *desc = req_ctx->edesc->hw_desc;
 	int ret;
@@ -391,7 +392,21 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		return ret;
 
 	if (ret != -EINPROGRESS) {
-		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		if (key->d) {
+			switch (key->priv_form) {
+			case FORM1:
+				rsa_priv_f1_unmap(jrdev, req_ctx->edesc, req);
+				break;
+			case FORM2:
+				rsa_priv_f2_unmap(jrdev, req_ctx->edesc, req);
+				break;
+			case FORM3:
+				rsa_priv_f3_unmap(jrdev, req_ctx->edesc, req);
+				break;
+			}
+		} else {
+			rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
 	} else {
@@ -691,17 +706,19 @@ static int akcipher_enqueue_req(struct device *jrdev,
 		ret = caam_jr_enqueue(jrdev, desc, cbk, req);
 
 	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
-		switch (key->priv_form) {
-		case FORM1:
-			rsa_priv_f1_unmap(jrdev, edesc, req);
-			break;
-		case FORM2:
-			rsa_priv_f2_unmap(jrdev, edesc, req);
-			break;
-		case FORM3:
-			rsa_priv_f3_unmap(jrdev, edesc, req);
-			break;
-		default:
+		if (key->d) {
+			switch (key->priv_form) {
+			case FORM1:
+				rsa_priv_f1_unmap(jrdev, edesc, req);
+				break;
+			case FORM2:
+				rsa_priv_f2_unmap(jrdev, edesc, req);
+				break;
+			case FORM3:
+				rsa_priv_f3_unmap(jrdev, edesc, req);
+				break;
+			}
+		} else {
 			rsa_pub_unmap(jrdev, edesc, req);
 		}
 		rsa_io_unmap(jrdev, edesc, req);
@@ -992,6 +1009,8 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	size_t q_sz = raw_key->q_sz;
 	unsigned aligned_size;
 
+	rsa_key->priv_form = FORM1;
+
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
 		return -ENOMEM;
-- 
2.43.0

