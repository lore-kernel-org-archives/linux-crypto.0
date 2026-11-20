Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178272;
	b=DOyM7Nb7XNyJJxPgBLjJIhH9xPhuUjq9m0dpgrT6VE7z58u1z5hlKWhQrBrS62Gnb353
	 34muhfuXGF92ZlhyTlFa96pmcNVMHjDBfDmlJm3oAQAn5cJVUXhsc7uPTL1cZ6S3g+jUH
	 6+EwBsVjx2Fh5zZUh5Pfv9q3EdDs8H95XbhsjSZse4G81wGI2p0NJNhhm44+35EArTuGd
	 plQVBBc4d/+nebg7teD39QhqhB4U0ZnTRG2DbKbQzJ9VCInptnCe6slHw7PEyltvN6ybb
	 zaTTKqTnoIcxJHZv21+lfw4mp7qij238yjPnAZYRNjVHNuvVgdqi3gIZR0flshTckeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178272;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i9H1Qf5VeBDEAJ+KENGPjuJrwt4TmksckkFthv/+CKg=;
	b=Ud3bqdtb7snqHlfg4mXZmN3oSwBtrEceTN/O0C4s4JMPwWsOiKgUb/xuWDVzzSaFxLCI
	 K8nRWKn7awzifyARZjX3gxlgwZpchDsSaNWm0ZDH3a4c+khvRUu1oK6vqyarGxib7Yljl
	 XGeOJBvxXCYP13hEAdzTk6IJMh71hWjXB0tZ1duqwRZkfa5Wpum37KPOcfejvSfH/Fb4i
	 +LUQLkg9aa3EVze/6/axDfp38C6t6U3wMCBZiRx+9v2pcGKRqftpr2V/gpJYEkMTt6vud
	 PSTZ5hQy4g7e/V2VaBFArv76nnDMvLz8BSzUWBtQfC3v/vLwWAXAn4ODUS/T4JF/4eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b="mz/XdwZ1";
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97149606A32A
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97149606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=mz/XdwZ1
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 386E53F920
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795178270;
	bh=i9H1Qf5VeBDEAJ+KENGPjuJrwt4TmksckkFthv/+CKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=mz/XdwZ1rC7uARepzQ2g+LPWLKZStFbDS4ZueAhwH1ZXAZbhU24T/56g6k5Zz2g1/
	 JBy54xpce1M40Abt4Oh5i2zs7IwI0QJRPCbab92Zeehi456uPbhhhlhUVXpNtXUReU
	 BZJA7FNAP4nJR57ZdrtE4eJpQ2/oxYZ3pZVuyRD5MA9LjKZnHCvF1BRzw8FcV55hlu
	 0OnNvbL6925W90t9EUXg27vdoEABG3ntRa4y+pzEBxKJX9JTtiTOYS+0YLGErJHXMq
	 DxHJledVg1LTFvqB+I54RajtKFZdhKbL76gn0F9L/OJwDorw2KriDysYMHqPhwJahk
	 WiKvUIKONSrA3jX4CoplPGRFPql3joL/g3JRk/BmKsHk7UvPrziWwgjUvxtoVIpAmS
	 DjYeyXEHQGr0hY8+UE/1D1sS3PDcNNcnBf97JE7A2fbKsgPjxaDWOFnF8DocrUUbxV
	 Hco+696pp4KIeXxaT31RUvuaGPIMkQGkenHrL4gahzCJG/smtYkma7AmbJqmij77JR
	 wFoe6/GPp/XzMkVmP90RLWlsFhw+YjohVCFJYFQ5gkqrDESNZ/mGjgaWTZp9O9cTsy
	 hk2iAvkHyyuB4/E5ReRBsl4dDv8Cepn0N8UbHmbqc4/HUEGm7Bs+KiYhr3CvoVDoJA
	 1kwLu3hlOWDyD3QYS0bOGuqg=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso896168eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795178268; x=1795783068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i9H1Qf5VeBDEAJ+KENGPjuJrwt4TmksckkFthv/+CKg=;
        b=IN2u2f4Zn9VW5ZEeNGMAGnXwog0wMvD8T+4x65h/eQ6FGIyngNgwAhYiqjhigN9LVe
         wV1M3Jr5h2d6tgAnj/suN8AR5drEjexYjaDc5eW4JycSyk0AFJmeb8hhgeN7z5DZ/zAu
         /KdRXSmE0TImcXAk96dAj9z3pAySK+b6+ksxZWpbgNPnqs+M89yjFba6Oo/rmQmFtOUO
         sYf5NjKnquUDH7+3nsiayrpTJV4Xeey92VW0byUIS1vhgSTQ2CRhmoBPYg/Co1M9hVT/
         O8o743VSh7viYURBk7iHeYe3Mnm/ap0S/xtSyj0i+i0geB2bOPJ/6NB/a+BVEJoNxDtu
         dCxg==
X-Forwarded-Encrypted: i=1; AL+hErHMb/GHOfEH4sJZVLM6T4uVDUH1Cb8fNIUfzqovBoYd3SbYRKppR14Vk6WtFU9ls7k8yXDQ5cjVkrDVm6c=@vger.kernel.org
X-Gm-Message-State: APuU4Z/QXMXhg/l7MvSTm6CTZ5RrV6qTrrVPWP39ai99/a+RllCN3BPn
	IfPQd4dgYsw3fmU70FIBVkj8WIIeMIU40mkdDPW0PRxWu9TnabsknxDVxBpH8/RA94iUbSlfxx+
	zvxsVXm/a0wyCnLuSV111mQ6oT+J3xBQjLPmKYhArtxAWkWs3HRMpB0WsyQ9xs3zEtPD+aVpKN+
	D48acohA==
X-Gm-Gg: AZFdTZcgsM5fLtnOoR8AeeDl+ISwdIs/zRr4YmKHl9V/IhTOy5zUK62RTj2E0Lmz+8b
	1WhCxcNz6p7A30ybK6EbD6rXR/fRinv4JExH5YG8WJ8h+wQYd9BxTy6lveOWV0q+fqIRW9N3arb
	Sm8eKCGmJnHUoWdUqUBZs/B2SGffHskA0pHsL4yDX9Fu0QAejLEAymIey9g6Cisq1SyeT7xBrhz
	3zWrharfhm5KJ5EXK7tcQxhMwQWfTMosQJy4+8PRngy21/mZBlP52IH0PqQmMkQOvIcBXIWChU/
	02V/0n4NBenFwlszNpiHNpd8i6bO1kwT/jr5LLSiaN8Ys1TYArFROmz9LpSFrj6pxsHiH2vNecx
	GXimXi1g7f+XzJ6GeAWX4jEmxTCgg6nzGZmnk/n62XPbkFDY9y37cggltfSA=
X-Received: by 2002:a05:7301:6183:20b0:384:b2cb:5f76 with SMTP id 5a478bee46e88-3856fe5ebddmr2577983eec.23.1795178268530;
        Fri, 20 Nov 2026 04:37:48 -0800 (PST)
X-Received: by 2002:a05:7301:6183:20b0:384:b2cb:5f76 with SMTP id 5a478bee46e88-3856fe5ebddmr2577952eec.23.1795178268073;
        Fri, 20 Nov 2026 04:37:48 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm7994093eec.23.2026.11.20.04.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 04:37:47 -0800 (PST)
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
Subject: [PATCH v8 1/2] crypto: caam - Fix wrong unmap operations
Date: Fri, 20 Nov 2026 23:37:31 +1100
Message-ID: <20261120123732.1200685-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261120123732.1200685-1-changwei.zou@canonical.com>
References: <20261120123732.1200685-1-changwei.zou@canonical.com>
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
correct unmap function based on key->priv_form. Factor the priv_form
switch into rsa_priv_unmap() and the public/private dispatch into
rsa_pdb_unmap(), so rsa_priv_f_done() and both error paths share one
implementation.

caam_rsa_set_priv_key_form() implicitly relies on zero-initialization
for priv_form. Set priv_form = FORM1 explicitly at the head of the function
for clarity and robustness.

Fixes: bf53795025a2 ("crypto: caam - add crypto_engine support for RSA algorithms")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 66 +++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 2082adaae585..4b5397f2ca64 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -119,6 +119,23 @@ static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc *edesc,
 	dma_unmap_single(dev, pdb->tmp2_dma, q_sz, DMA_BIDIRECTIONAL);
 }
 
+static inline void rsa_priv_unmap(struct device *dev, struct rsa_edesc *edesc,
+				  struct akcipher_request *req,
+				  struct caam_rsa_key *key)
+{
+	switch (key->priv_form) {
+	case FORM1:
+		rsa_priv_f1_unmap(dev, edesc, req);
+		break;
+	case FORM2:
+		rsa_priv_f2_unmap(dev, edesc, req);
+		break;
+	case FORM3:
+		rsa_priv_f3_unmap(dev, edesc, req);
+		break;
+	}
+}
+
 /* RSA Job Completion handler */
 static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 {
@@ -168,16 +185,7 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 	edesc = req_ctx->edesc;
 	has_bklog = edesc->bklog;
 
-	switch (key->priv_form) {
-	case FORM1:
-		rsa_priv_f1_unmap(dev, edesc, req);
-		break;
-	case FORM2:
-		rsa_priv_f2_unmap(dev, edesc, req);
-		break;
-	case FORM3:
-		rsa_priv_f3_unmap(dev, edesc, req);
-	}
+	rsa_priv_unmap(dev, edesc, req, key);
 
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
@@ -192,6 +200,22 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
 }
 
+static void rsa_pdb_unmap(struct device *jrdev, struct rsa_edesc *edesc,
+			  struct akcipher_request *req,
+			  void (*cbk)(struct device *jrdev, u32 *desc,
+				      u32 err, void *context))
+{
+	if (cbk == rsa_pub_done) {
+		rsa_pub_unmap(jrdev, edesc, req);
+	} else {
+		struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+		struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
+		struct caam_rsa_key *key = &ctx->key;
+
+		rsa_priv_unmap(jrdev, edesc, req, key);
+	}
+}
+
 /**
  * caam_rsa_count_leading_zeros - Count leading zeros, need it to strip,
  *                                from a given scatterlist
@@ -391,7 +415,8 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		return ret;
 
 	if (ret != -EINPROGRESS) {
-		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		rsa_pdb_unmap(jrdev, req_ctx->edesc, req,
+			      req_ctx->akcipher_op_done);
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
 	} else {
@@ -670,9 +695,6 @@ static int akcipher_enqueue_req(struct device *jrdev,
 				struct akcipher_request *req)
 {
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
-	struct caam_rsa_key *key = &ctx->key;
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct rsa_edesc *edesc = req_ctx->edesc;
 	u32 *desc = edesc->hw_desc;
@@ -691,19 +713,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
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
-			rsa_pub_unmap(jrdev, edesc, req);
-		}
+		rsa_pdb_unmap(jrdev, edesc, req, cbk);
 		rsa_io_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
@@ -993,6 +1003,8 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	unsigned aligned_size;
 	int ret;
 
+	rsa_key->priv_form = FORM1;
+
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
 		return -ENOMEM;
-- 
2.43.0

