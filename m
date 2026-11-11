Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438166;
	b=WEXhg/f6bCXpczvfkwXksz8kWkXzfvAMvLz8RtRc6EBRKc2/RBdaUjuMTwwe6WJIaDuF
	 M4XRuOzK8Fl9B83e7a836PRp/Zier1PYAp9+SiYmUa//vq/K0JBh3WP/ttIgF2JxFVX5y
	 j7YPWbr3J11CGcGap9ee75Y1v36SSJST6metCMzi29Y43CluVVLKm4nPic77E5g4sf+Zx
	 iwTehChl0ms0taCI293HZRdTOfEniSP7PKHTZ8O5O6dX1CHr4WGI6NYvHbVYUPA/Eaxou
	 Zfe0dnVLm+mKHD5dLNDQk65pellVXiGC7ZPyTyETBe8nVzCXqnBCSXao03v4CDrad2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438166;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
	b=ho1UIeQvK6r5cx25DlqLp8XuOn7u9ZewZ5GaWZMD5v9OHO//gEM89954VDkLtd7Xg2SJ
	 7GhgDwbqa9Cn/gWWFWgJo3lgYanQVB5squoyK//wMDjgKB7qEpyxbghuKDZe93ctJltc0
	 zUnYF/8ISd4JpGyidMMbBRsX34glHb3r/Y0jaK1wo9/r/wlUZap3cCxOlTrq+zEKBlmZJ
	 D57JA3MN9HXbRji9/ziA5t5LQM+l0cndhpO5PwMPR8lZXU3etAA8wiN/SeOjibSnjoTBa
	 tFTMdgMkU7hgDjvr8Ug2081NT6AMfJHhUifcxW2jZBCuzqYHsDC0te9tPDXjvtGBC8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=cMqS8ZZf;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941A606A8AC
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6941A606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=cMqS8ZZf
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AA9A13F276
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794438157;
	bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=cMqS8ZZfs2nHWQBV5lCUd1j/0+rJUxZc5Vmam4PDhu28doLBU4v5FGkib/xlRQYd+
	 aK+Du2BYI0NpDJN6y6oJgM8jWJW5B7frliavU94Iw3BViwHGBtZwtG7EMyHnGCd0j8
	 n1O9CHM0O93lB2l9AIt6tOFWPjkXZro9pir7ZZwWur7ifypdgeDJfLixf3d+rB6hci
	 PJlszQ5T9YYX/80Dd2Nd/FmjGwEOjtXqcFxM5ATqVXVwK2WClPhd4dwpg61IHSQB9W
	 jPR2lgXmcZu+rx22zEW14+A3CRhJ+vV4O+TND7GCj3W/WAvGeuHdspoZVzTwK+UFUZ
	 3QvPYjYbs52v4sQH4AC6gJQycOstwqD0E1jxoXPnSs1cV9t7F/JeG8l70kzn5WEN2A
	 2jmp2kYMYSXjNu2nDCAxU1SOkJ5pq2fpLlPMt/pSwLjXF0W5Td8u4NmjcSzWHS8KtW
	 hBSHS2RslNUuip59W1EzNlIsyC5bnMPOUTSD8S04C4RrkRHLGx3eUIAJ1O4YDsdcgy
	 bYfEvzeglz1NBGgiAk8vZnItc2y98MAgWQlD6smwpVUmB2SdDfiBzMsMkn9zqddZ9K
	 uay14/JEgAEujsWTjNALJcnvqpmay0DuxOyI6jOi9xbBAZP+AhE+BcXKL8WilLW//A
	 l8SoZzw9V6KWjIYRDTWfQAIw=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8aa185840bdso2772901b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794438156; x=1795042956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
        b=0zFFwCGCxeczTUkJO+fjgtp1NhYDE2D1leLZLDwPiQ4GGWohQeiSWgT3hoOaQ+hcbl
         SGNHh2366ofIADDr1A8qw6rIF//sl90uLSjp0bX5lFf49annFRxgKZ40Zl1DUfwEgx6n
         idoEHkNILKg5xM5AeMAsvi0H571DYmdp2VkoJlESOEmyGdvI4H2gsjb8jhM/SFTbAt/P
         UunDwzfl+2Loxx3icCK6nIckvZr51xGuUj0eW500ZR64UfqtwiYdnH8w0DwfXnetRZfw
         Q4rB658h8IVPEr7Lt12NVFX//iqQRwRBMzvANMedqZYv7h1kFtWql8TXUc1y71BD/idm
         vMCg==
X-Forwarded-Encrypted: i=1; AL+hErECRzoYPiTE7BxnHWkyfDSEOU0JOJRHdhn2ulPT82SyK2r3j5w4vw2IP5jKZbQ/OI266pe4AodY6FNVqHg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+sZXQbtp86y1iSQCz99rCkZ4S7tDBj0p/uCHMweW4wHbGmKynS
	WzS3VZYCqmz3QyXAELe/wFrwxOPMDR9HbV4AvGmwKMZIKLabHrht5Yyu2hmkRdm/D/h9aYXVXRG
	2L2Gv7y+T0c5cyi0U6thb/Dq5izXZTQ2VKkIdWQYwa7Kw7A7KREVjoujv1twI7veDl6tdIcYhxx
	zQbtNNJQ==
X-Gm-Gg: AYBFou2xZ5PeHMKFEdV0l1vVJU/bjyEcnGfFq4qrI7YdVT7+CY4C31MxsH+CD4xC89f
	k11xVYi9dT6X5h+y/IGkueW5RMwfk5NT1uVt4zvaDUitGtVRJtfXkMuIfD/iEbnbZlm9UH8RyZ0
	SAtx++1eocs2SkEaE1WutEmbDv6uhm1MRPh+it/zYoFJMCcrV6EEaqevxOnor4PvFPhXuvQBrR5
	9KCgWt7N5qMrbFm4P0JnmbLYqmd3Slby1UVuBBR45BlQkv8+rueqbNKogFHajNFStl4dzRk513u
	Xp6WkDUMQCUsNEZyN9e3iqbF98hjb82vn/2NtHYPCzMrt4qMBv3CkS7oV/XO/Fg3ooMPGELkYFQ
	1wR+T4u2hbARUkrw4uK9Afh+OStsD85Jj9suxGg/nEfYx8i/YN1tzIjKRjqE=
X-Received: by 2002:a05:6a21:e082:b0:3de:46cc:b641 with SMTP id adf61e73a8af0-3f2fa399342mr4349353637.8.1794438156154;
        Wed, 11 Nov 2026 15:02:36 -0800 (PST)
X-Received: by 2002:a05:6a21:e082:b0:3de:46cc:b641 with SMTP id adf61e73a8af0-3f2fa399342mr4349319637.8.1794438155767;
        Wed, 11 Nov 2026 15:02:35 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm2531211b3a.46.2026.11.11.15.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 15:02:35 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] crypto: caam - Fix wrong unmap operations
Date: Thu, 12 Nov 2026 10:02:20 +1100
Message-ID: <20261111230221.40297-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111230221.40297-1-changwei.zou@canonical.com>
References: <20261111230221.40297-1-changwei.zou@canonical.com>
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

Since priv_form only takes values FORM1/FORM2/FORM3 with no distinct
public key enumerator, rsa_pub_unmap() was not called correctly in
akcipher_do_one_req() and akcipher_enqueue_req().

Use the completion callback (rsa_pub_done vs rsa_priv_f_done) to
distinguish public from private key operations, then dispatch to the
correct unmap function based on key->priv_form.

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
index cb001aa1de66..18a728849147 100644
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
+		if (req_ctx->akcipher_op_done == rsa_pub_done) {
+			rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		} else {
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
+		}
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
 	} else {
@@ -691,18 +706,20 @@ static int akcipher_enqueue_req(struct device *jrdev,
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
+		if (cbk == rsa_pub_done) {
 			rsa_pub_unmap(jrdev, edesc, req);
+		} else {
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
 		}
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
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

