Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464886;
	b=ILlza2WKep4SgIJJcCiQmnk1NO1LH8kNeayDYdC8PUNUqpq3EseobgFEImRVGQcHMW7P
	 kD9oQXxf1++yYpKBn6of1A/fN/Mrrw3lz/F1xERMdHHlxfFzl3miwJ2aCzqq9sdwZfeJs
	 NenasiiD7t9whX+BFShqXG/bDlS1eTuEVuIG06Xap0oU1ugLQaIjxT2SzPZQnxQpK4sqL
	 J0vaHha4/ejekMmveJovYuiptUskzPk7osLch+V9s/OoTSUbGkreo5YbTsaY8udzYvCXK
	 jDwKXdp/YoS87oqw6Yu3hIGg3cu+XoNsxRprigRSacwO6I05ZSSsOZ9jj5Wn9K1uNOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464886;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
	b=jl712jnmBlYg5fefKbiInJuJkAS7YtbirudiPkocPgxdmrdhU+Q5aDsZ2vt+EtIlDLdO
	 0mP92l5eBJJ2p2NF7swiw/nGtlef4a9cYEonQ9Qpdm5uXVOHQi7GbAfeiHFgn7n4Btih+
	 WrbPkqfkhJwugG5FoUNg12HWSKnMUY2ro/fZOgXUB3Tu/BHwa65T04DXK5azisYT0bepi
	 vMvHmvJMQap/2TIm4zHXHUYTWuYAAuE4zwIzN6/ZBsgD5waPGReKNnkY5aesHl8hZDCm3
	 Y2FkwxRh22nxwhjryjDIeRX6Hu3pHuXrO1BqYr8etFAbZ23JUY/SUTGDVlIGHWEkmwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=P72JMuUp;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C87A606A31D
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C87A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=P72JMuUp
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A52253F9C8
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 02:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792464882;
	bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=P72JMuUpS/ztCkXdUArBYlAZeFleAt5MwNABhvLf5Swxs44yudr2JG7a7McqTD8jU
	 iOw/pIzIWnfF//vX0rD0HAa51mIM5EIQlpfLFJV7ekT0whJXqhleU7da9ttOl/RvxZ
	 9Mmaxb22mrVIXa/WHuouXpgvTCzFNavkIlwagPd8O3qb2BFzhBFVDIJWjr1lLwcpG8
	 Iw7Q5PvkE887GRdsTdf9IWLhMXiIVgqsg0HBtIecIRa6WJ0SIXbO/ncnSpMMkPdwwx
	 oRDTyo7LoZjRlVfgdya/HZZM8otRWZaOJ8xRh8IfTam3V0mLKKizu235FdRL9IC17Y
	 bTElAgl5iq4Nq9J5vD+frHIabJTb6B8+sdkGuiUxx+82nbfdpeNrUZVPHhhgI6dZ9G
	 Rd2IiMg/4JSp9RxFw7P85UxTnT1pzcKsKGsDdBkYOvKm4mEi8DGcUekFlKGeIMpI4N
	 +lZDKdQAZN+i7/MuarshLQFgxhSuIt1+f63HphjQ8ccO2+7zByP1AW9t62jJS4xM7p
	 80tBotHFBg+Kvg1kZJRptZksNzpcalQGfXZlTusuXhynbapXGyHQ5nD3GVfs6EAO+2
	 WFX2KrX2ss9kxkFPsy4p8LC8AVo+l68I/F2VRF6dMx8B90YAvjCF88u+2TasuoWusR
	 6AeeRTkgXmm157iy9RZOAnOI=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd65070d3feso179894a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 19:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464881; x=1793069681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=37xB/YNDXqmc8yrI7VGEp2TohG1TORHxT4RwOLqZ3wg=;
        b=YzJT8todhctJ8bfCHrd+71E07x9WSSRxaRiGt1G9nAIecbR//5I2k2kwbIOEEH8wMa
         8jgm+QutQbfIPPs6MTxl3c5AT0WMyQEteFHlYb0APqHt8Rh//u9ZZtw605zyBaf1T1Bk
         kkH7MByn3zKf4rKOlUsY2fC5z3NZceg/megRLHOAb9WaQbOiUtAjzV7Ud/kwb62g7elj
         gqDiXI+9EF5sRIH0JIewwzi3nHqQB+0H6zSbk3RL0Km01FGv16j9633WRH52oHCGFcZ+
         bkl6ERdLkvhDdPwbOV3LR3u1yeHvvBmIvseNdtF1eOX8xttN6oNacE9f/h1GAP9vANDX
         7yzw==
X-Forwarded-Encrypted: i=1; AKwUvByJtxN+Bihbn7jjr9j1NKirD0klaNj9BBVmPYvyJrUft1mTYyzQwriY1QWohsxBkoGtV/cAu0krg2/pa+M=@vger.kernel.org
X-Gm-Message-State: AFq9FYI3ec2dlrexyeggHnRnSwJt9Uli8vxfSXauBXXEC8BaYsMVbYn9
	JgFgk9XKY2GJrgMwbgJkmDZAMRYFPHm9KTGQBFwBXtfFGg0Hop32ybxOaWEEUOM5SpOI8x1YK7N
	h2V1b2Ho3vazSbV17sxVZNnTYAltXu9L/trqyxYd6QJ36SFBRq31ThRXIzA3i9Wfl/Sp0hnzxo/
	bsxzFSXQ==
X-Gm-Gg: AYBFou0AvFg+rx7UHJ2M+iKfpFdmpV3LR84JdvpZ1bfQnjSTaOi8kjyYM595AHQfeXm
	RdmHM3ka+UU1CvvdKfvIhTUdxYPUL80d488o6bD6wfFHEAqPiUf9lZMXDQcEfpCDwNhmlZfnM6D
	d9xJdExBgvKczaIFslIFpM87K9tIgd98/GRE2xdTN8JaC4Mb6yJ7B5fLaA2akyHWlXUwm5DLv7V
	HCMemvirDqK1U9/ckXmPJ0KiET6BjthP4QT3i+/G84j2RExhaF/EVowapTqSsOUup8Ji43pgVYT
	7KJ0iNq6ljWLUTidyn+FO45gBfX9uJeG+LAk6NYWfe0dYp5LSkkzl2Eef/3froN9Ghoo3NDAOiP
	oEcbMNuh1VA==
X-Received: by 2002:a17:90b:448e:b0:3a8:337d:228a with SMTP id 98e67ed59e1d1-3ad64b90a7fmr509220a91.6.1792464881027;
        Mon, 19 Oct 2026 19:54:41 -0700 (PDT)
X-Received: by 2002:a17:90b:448e:b0:3a8:337d:228a with SMTP id 98e67ed59e1d1-3ad64b90a7fmr509197a91.6.1792464880205;
        Mon, 19 Oct 2026 19:54:40 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d5679d5sm1962994a91.7.2026.10.19.19.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:54:39 -0700 (PDT)
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
Subject: [PATCH v3 1/2] crypto: caam - Fix wrong unmap operations
Date: Tue, 20 Oct 2026 13:54:25 +1100
Message-ID: <20261020025426.955531-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020025426.955531-1-changwei.zou@canonical.com>
References: <20261020025426.955531-1-changwei.zou@canonical.com>
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

