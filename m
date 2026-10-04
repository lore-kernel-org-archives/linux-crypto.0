Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D26B4A64DC
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791147742; cv=none; b=Gx6HXExStdHxxF7jZ4YpF5iVa3FONQEqcLno8Bt42H0GRIkmCOPuwm6hQyWm4VfHY8agWjg1tqlwRPZJPvO9ugBULLnflzR277uoMNdFfLy8oF//uQsKVkZb8pfu3SS63amEIp13wV4h/BAbgvyhCq2lnoRxWEw44z/CAASEtyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791147742; c=relaxed/simple;
	bh=4mrNvIBRG0ugNAIRL/B5GpUeBHBWSgyLwU7Krrx6iDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezCH+UeV83fX9pkdiZGJnMJPMGSF5JeRmdeaggzh8XmvgFz0dDrU3j4PRtcCcWHuIW3QgZIpzzctyIPJ358wXG/Zc4xPQTwsyb3bKkri8ut/oLHLrqDbNqLN/pym6Lat0WJc4m2S+PsFHd8anv1aBiaCNBtVhCTmKTrL3lCe2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=g+Jcp37x; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="g+Jcp37x"
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 48B203F1D4
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791147733;
	bh=/5awgMiDygLT+g4MpCAKUR5+TiU0F3UslknD2wRpPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=g+Jcp37x3AMvTCwN6WaoMuz1a5prqJ9xHMhxE/ROiQ/NZujFNPeDRRsZuk0IVsnP7
	 vz7euNvhlHQ2bZqxXNZPNRKdxbyJt0iPaybpMf0xBnveiryK67wKI9Od6wyQuKFPrR
	 0h/g0lfjKhlYXs5/7146pYt8fJZpTMj2S8SJhRIjEXNKHh4proYhEU8zLJSkjsiWL3
	 EnOvzREa9+9NhEHLSzUoN/0roXBKcMcyq4DZrF0wmX7ibJntiGnCesr2RGQ1uiYEoF
	 fyD6k+B1KcJ70+8X2/+DAph7FQfGM88vmvafAYdt27Oqlq+d8r4nj3rrMqX4HBglhj
	 OgqPCynJpcY9ulevMlac9vcyb3e6vkSGdwfdeGXbsrTAPi8gTUJg3ikIrPZ9vx0u2K
	 TpTzqFhyP84Nw+bwTliDOMQpuF60PJMTXIwBZHzcRuCgDCm7eVYK7WKdBvLWvYv7AT
	 nnaaObEkIkxIQhQLR+v/7/zNKDiXA7tUcE0D6cRBKOfrsknyZ2tP2habF87gH7LpTv
	 NnmO+HvN7fiYXzTwOIE4bsJS2h088WJzoMIQKOF8k8ZyvZ3qIBd8bG9R9mMj1bVwxC
	 vAMlq9Ii1vBf8Uo1/fz5egGCiU1udZU83NTxJCQi/o6+qpigx6wEv1Tt6gads9tyPR
	 BA5acZYpvo0yExE3KnKCIC9k=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so809774a91.3
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 14:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791147732; x=1791752532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/5awgMiDygLT+g4MpCAKUR5+TiU0F3UslknD2wRpPK8=;
        b=Jp02VsHdzxUgBT/iC5RdU4NUMM338Ae3Xe/lF8f1j2ngoOD+BJd8/gG+NxCTFkTGL5
         E0qMPEJT7Ey17stLLtlj/PoezZlOOvuMxmgNzsx07R3WRIb29BJIVn6TKwaiO703MCfK
         Gq79pBqlw64w+CWhPgMQyHVQFGQY3hGyrl7UNsJQrJBUT+pjeP2Hxaes6JLPSBVIb2yy
         xJe/R1omRQN7ZwN938q6fA3nadEE6g0gJnaPM9GqL/MAG74medsOC8RZawKVv9x5hpFG
         djFj+pG7Ai+yvuvfHR9zbCuOn3fnAOpDSlfSWOUw8BBrGULngj9Dn5TFuBE/mdFSsBr9
         v9Zw==
X-Forwarded-Encrypted: i=1; AKwUvBxD6vjMtu4zzNpZHuyZbZkokL1s9dbyrMtzDaReztTd4HruYDCz9XW8M2Gc2ayT/qTlR79M2Ut8wjN0JI4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKKsRehhePJCsHdwbckvzz3e458CIfTEBWRiLiPtpjlnzR7EZd6
	CmkqaqsZqdHxomRTOAoTaUYtc90ffNysK0Ha01qY/fcZ9iXu6u+gP6sVxG1DnsX/p+zvSW/z5kz
	DHSGYsoQXJxwA1OOIyG6EP/c7ZKR4sXrA4SWpmM/FCj0gY4eiQGcQxOvWjAMTHLiZrHoEtqgEU3
	l1MMzhQA==
X-Gm-Gg: AYBFou3rl/RLMK9MN/SDlHOd0YsKfnr2EcqMtL/w4c+VvudjjKXLjjuJyi/ntOZ14NO
	uzD9sUsMtqwIOSfryEd+A3Qmsnay/BmVh5WygVC26/elsR0qGxBo/+i2WsPtn2qZnk/sZjemxQP
	MfUiPnMBy/bxRTdxEGBhpJpzBgCl5aRkB1k478pOk3b6xfeJSAScQhINGG68rLC2kdkTaCLUIIg
	I/JZFToe10IZkGU6mJkgj0uUZERlIXeYxmyQOqw3mJdCuM1yC9w+wLkGTgQ09lOknf6fK79WVJM
	4eFFd6emQLiAOqlRN8/2xgSyvY7gI6SVH9f9LqGo9U/wiqIXlGd85OaLDxPpZ8XvcD+2sxG1HnG
	WpMobpLXqWQ==
X-Received: by 2002:a17:90b:48ca:b0:3a4:b638:3798 with SMTP id 98e67ed59e1d1-3a6ce6b43acmr3649593a91.16.1791147731757;
        Sun, 04 Oct 2026 14:02:11 -0700 (PDT)
X-Received: by 2002:a17:90b:48ca:b0:3a4:b638:3798 with SMTP id 98e67ed59e1d1-3a6ce6b43acmr3649581a91.16.1791147731376;
        Sun, 04 Oct 2026 14:02:11 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4664ebsm8313782a91.7.2026.10.04.14.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:02:11 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: caam - Fix wrong unmap operations
Date: Mon,  5 Oct 2026 08:01:59 +1100
Message-ID: <20261004210200.290119-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261004210200.290119-1-changwei.zou@canonical.com>
References: <20261004210200.290119-1-changwei.zou@canonical.com>
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

Fixes: bf53795025a2 ("crypto: caam - add crypto_engine support for RSA algorithms")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
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

