Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794636056;
	b=JD+iUOU+Dwc2OleZo483wXTjP2gSFLc4rPC+cx+uMVrFn63imQD/a7NNzm0KsLFXbdye
	 RRcQWd/XL0ef84eAiYj6EYxPmTcKgJKVZQkNkdbBvuUQJwDjOd/2xgmWNP0SKZdP3NFZW
	 WekwLuxxoemuGJIwNny3UZq/deeTqtaVJeJ1iGzLqJ2iw+oil1HIBJSVg6SdMNsxQcIy2
	 XygwxMdLLu3dyosX4waj1FKjfKvulLCnVC7VxPaHf0crwPbO3BxcVaHbeoQnQ6Juabeun
	 WklJzphhyUnRafwaLfqq1oLgGSK+eJONMewTpVN3X/kCaXxuI24hVR1X59pbQKQXdiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794636056;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=az7EXLtBAsInaTQj8TdEMBDE43RfNIrjZXWpPaT6N8U=;
	b=qZiCc/SHK6OaUusrHiu8dH0k0KXkU4jDAsBX22WPdm4CiphBFU6KhRWp2pP/tHZ4T1gg
	 YRCVhzhEXJrhCDOP/0bZR8SdlqKexve+SKeqbeeQNmrMEkGgj7oeRaGEKmvz3mXrzusip
	 a1GrzpfAle3tNh/+IexhGRziStgJ44HDd9gM51XM0mNam9/eN/SVF0pCpSHea6vBJDMAG
	 pPksfvcLuXdMzTg/4UksKGxpLi6N9sl37I7wr2g0iAJYuWTbSwZEVWMIj+sssZ1lO4z9i
	 TKqi0lreEtrnkNsngLlvwgeKaDUv8HfqUsf9f9ruFyTLhAFOL3Y9L016ANsxk8HXD8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=lKsWKo3F;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3C606A332
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD3C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=lKsWKo3F
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 791B44013D
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794636049;
	bh=az7EXLtBAsInaTQj8TdEMBDE43RfNIrjZXWpPaT6N8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=lKsWKo3FZVkcd4z2aCWiHOACqLZon6OJCzDMO0Nm749HYOjzXRiBpMwbrrCaZs1UT
	 utbXba8yBj830Az7IdUOVedFoTGGikpCvubo6tY4WBePKkzEVaP5JQGKDq3SOeocpY
	 mRHtcVJItbVl7AJNANXHaKPk2QGPpwCx/lSr1GGNmmkaHc53u6zo4XWPGknOSb/Eyu
	 nCF7ip7WgNoJM2ib1qd2d+s3/VNX0WP0H1hvkUV5ceU+IsBzfmQP05GpBOwfqSw4L+
	 vuKs6eETGeI+ctKvux0lo0MvtrVjISW12cD7L34GhwiaxJVJ3CmekwOiV33WFGKmLw
	 uR8Cu7TyeXA9/b4/PX92C0u1uKkMrLOif6ira3Mc6OmWtFk67hfexqw6nRwHOkEx8K
	 r1WPBo0ZTrOFslTDTIEzJ0Z3zWmVHykheerBf9S8vgqhTygkr/VoiDDlLNcJJQ/cMC
	 /T3G0hR7rO9qY8UXvGW5b3ydyCnM71Ofw31cCyM7LvPs7/qVRu/MS06M9WOknPkUEl
	 xcjKNijPU+NXba+tcHnlRm/LktbqKDKeSD1TI9FOn3j4WCfsgKsCsArNdVyL5mNKUQ
	 IuNl8zsqdeV0PtiLep5vWrQLqNeZFpkH3CagOADQoKyP/hyDef9ry1mWJZn0a48lCV
	 evZZh0p4AEyx5TMjV6OZSo9c=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b09a466295so1335830a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 22:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794636048; x=1795240848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=az7EXLtBAsInaTQj8TdEMBDE43RfNIrjZXWpPaT6N8U=;
        b=xgolNDDzkg9Q2TzvjqH+s6GLK/XmYjqVEQBp0Q9uwXZrIbUSv/OZLfKu3ZcKNOsJHB
         h3YwPJrwncbYbnX0DQr4sbVtwEax1vpB1Wf5mdtbxUkSf6nCxyhWz1XjpxJHSE+KVK11
         1anUkKrDF2OtC2xkyY9MTm7+LimUtSFVSFpnclw79vYMNm93p61Gg7aQC17MLJ501PdY
         uF9Ca7yY6Ay9v++1aLeQvJ98Om56kAeDB6i+1FupUYUyifmva8ILLo4qDMXiRuVYcqD4
         NlXYn4dMJCs22SMosevWMF8CNJFZZ40fLdZmCz6tVvaIzvEvtp8BLJ9OB6FRyoU/VWau
         vD3w==
X-Forwarded-Encrypted: i=1; AL+hErEv2QuC0HH38gUFoaPm0M8qDRFUbrFUqnNlbxoknPTm8wLuyhrsa3tMeivkRuEmZLQ4ZDqDLGmyV8aw3B0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/scoz6UPODXfYbhmceTQocWdj9XIogsf+PzO70h7kho8WxPu6L
	3w8IsUqmiXBJzV7gmRiosBuk/H2CXvLIsVvM2PQk4A2MeBRoMcWJXfhe5q6cewsyT9+C2TJ4tJc
	F084cdEIBbh4tAotmUiq6uBDVMRQhJ5fh7h6Y7vDilQJuKRMp5MCZ2BAz08DjADF7FtUJPPeH7C
	B2qodP9A==
X-Gm-Gg: AYBFou0QjS1BcxswKTcyyZvuQ5VUYtfMM56/nr0U+U1sV/uHF9VYBBh1MRHUjhDKPww
	gqWQc7FRPOb/IBfe38QoiWx1DFXlgF2IBJShwc1iPm4ENuYl84+0aYpAEifGK/cl5J+fWhL2lN0
	waLj4HTk3O3wZ8VZCjwhpfk7LE6gVw8qcCW0Abwq95k9+yT3LRbR98PDpgy2W/gxFBht7Ieh6fB
	A7W104/L2RRumBWBZJ9K6OLxxzy/GFj/rH/ZjiZh+IhT5fXy7J0lNgptTcoFX96poy7UICOvRs7
	wPqv1UbphnwZp8I9qCnoE6EcDtNkSMSkepA0FcUwvdruKzIB83pippy7MGiIFGA1CCf2APNSeaO
	zGD4PPHZOvVkrSv4/NSInUS2dsfsM18+apOO/oayC9AzO2xAwT0waLt/y63Q=
X-Received: by 2002:a17:90a:d2c7:b0:3a8:86b7:ad95 with SMTP id 98e67ed59e1d1-3b1b0cabc2dmr4543500a91.60.1794636047972;
        Fri, 13 Nov 2026 22:00:47 -0800 (PST)
X-Received: by 2002:a17:90a:d2c7:b0:3a8:86b7:ad95 with SMTP id 98e67ed59e1d1-3b1b0cabc2dmr4543470a91.60.1794636047620;
        Fri, 13 Nov 2026 22:00:47 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d32ea0sm12364451a91.15.2026.11.13.22.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 22:00:47 -0800 (PST)
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
Subject: [PATCH v6 1/2] crypto: caam - Fix wrong unmap operations
Date: Sat, 14 Nov 2026 17:00:31 +1100
Message-ID: <20261114060032.872141-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261114060032.872141-1-changwei.zou@canonical.com>
References: <20261114060032.872141-1-changwei.zou@canonical.com>
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
Assisted-by: OpenCode:claude-sonnet-4.6
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 66 +++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..789a8d571486 100644
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
@@ -992,6 +1002,8 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	size_t q_sz = raw_key->q_sz;
 	unsigned aligned_size;
 
+	rsa_key->priv_form = FORM1;
+
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
 		return -ENOMEM;
-- 
2.43.0

