Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569828;
	b=2jzma039mlD/fVs6o1OXR+AgY14A8d1ajA1wpdE75wtrO3SahpEkOCliC6hnLkDz/tbf
	 iBwVBc7g4p0N2Xpp5RSebAdRnMVlDOkp8Cc0XIJu/Gdf/AhHs/lW6qrzu8wUYei456Lsg
	 G0SH4gTYmt2/JKxlonXm+L8A9bViiPiqTpAapWIgXfbFsIZjwc/GCbKq/m4BV7RNZLxCT
	 xOkcNd2wSee2sotl8SQuHqn5IZxlNHbb6KW3Ts95CzJ+YYYh/BOc2I3leHcdnsWPgctPi
	 uD3uOFJ7XtOmCDodqCkr8xMuXiIpIFgDJU0WcuHJdD6apy9Nysg8o/kNxCeLPR9/f6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569828;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8rzGcqO6FOauElNVIzlvQ2HVSNmWKT8BFtuZe8FFl4U=;
	b=HE6ST2Qx1vjOf+2fKI9kpIzCW3MVWyDRWqL206H4I7wK2N5FKIFXPPgnUNmCMJ1lkXbr
	 hDuQ4Ox9dheb8UtztaXONW+EL4dJC2UGSQWhDfdxRA5X1snElKKGlGaTawVTDOIGDpupx
	 KaxsK+M5fbssw/9lj+OinHNrB0QYmp0gBMTc3J4Wr6ud713iPhsF7FroCo7EB1Mnal5s6
	 t/jXDe+OjPybfZeH1+g297W7bnjKaYWbgEmNVeLf9k4i4ZmRBkA0xk7sVAs0S+cYYtp5T
	 RLm2EfWPtmQAFFRrqq7nraZuLqq0/+S5fDcNDIEAYLofYBDhzajVHMuHpd9vUNytSSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=fn8mvbsw;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3289606A881
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3289606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=fn8mvbsw
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6947B4087A
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794569826;
	bh=8rzGcqO6FOauElNVIzlvQ2HVSNmWKT8BFtuZe8FFl4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=fn8mvbsw5DxdWmPB3g8G4LL7IOv+9iKraEtdua5plpN12G3qgXJN+Kw1Cft64nTtN
	 yf/UBS3oUbcl4QcIKTgCkKYD1BsFzFgqZDYBGnjRn3Tl04Zy2lAiCBbJdMwjBRZSEc
	 yQAx62Duc4hT0ZPu52qDJ42FM15baqNheT0qEq4R7aZ46KUTMXHtgq8CIlkhAC+Y4H
	 0Kf6b8otz8LP4B1Bfp7oa2ksSuZDzZo+7YBhsnslgzkW+yDNZ+nZwUUix0DuLom1dI
	 h4Sg1hzIq1dKek62vNDHV0e21cQm2vAaLCY4j05fMdHK0b9QTbKZSNE0jQNqlsZ2rI
	 7mZnD8wNeIvMTVCLbjunkwnwsLk/ikENqK5BV2AIbdRIZgyEjYJ+gbWUgMebhTZggu
	 kvmgiM5n5/Yh/iYPUGJTAySGKLNgbOepktXGRrVw46BO6EuooAFrFXXxCxbXmDM/WT
	 Z7rglSktL4sf7U4q0yHIrGBEeOSiz7TJKwAqwKb8YzKZ21OZlTfNrTOuNqD1uDQ/O3
	 PP+1jrAZCHlRbpNNGBbPmHEUctu1BB9BWrAed/T0Oeblm5DAF4HFWoWoKQ7b++g/g+
	 NVfibTGk7WQNzxd7SZGkwDNsW7cxubBZojyy4Ube9/q621RMtb8Oijj2qRCxGMc2kB
	 71RnQL8/n++JBQVKiVlNdaMs=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed2803f863so7269195ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569825; x=1795174625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8rzGcqO6FOauElNVIzlvQ2HVSNmWKT8BFtuZe8FFl4U=;
        b=z+SJ4x+BrM8B7Z1lbBG0FF5KScKTIqesxMTMfOgEcq5lBYoNfw9qyVSxVnztwp/obQ
         SVa7h3Fp8YZ8VNdCZgkRUaeD/asfjGhdG6Yv1TEyDsYyD4LFnAh0+2m/GVzUFhAWF1VN
         w4HmPW1zMq2d7gdl7uN0a9w1hKN34XFN6w0pwpcF6qyqhlvcCGhGU7MC2SuwtgTGB106
         PTdSXlZMHIT/Ch+0VI+CSlQmeH1bNOdUAobg2LOwWLAHmN4Jn8t5D5CJIAYRVeSF4q7k
         U1cY6EQ/+6PSTexUxE7sxSgp7Olb/JI/39kYE2Dylw2278E02YgwdjCGsVHVSm0PqF4o
         2cdw==
X-Forwarded-Encrypted: i=1; AL+hErGgMA3/AUYBbz/RQRqsi9UBcDz6XOnvj812jeA0eyk80W8rHympUF4r8xTcfDldoEM9QnwNvVNhCu9Ce/c=@vger.kernel.org
X-Gm-Message-State: APuU4Z/LqKt8+F5zdRqA7ehSqvdjcnh/33uPGvklJ5s0Bu5w4HXJeuTy
	mZB+RYqpD9eK2653T4RSvJIYNFsBBFiG6DSYwEiWe5osj8FfKIRoihpoaUauP6q4j6mgD8ulQUP
	XBtQZXaLho3o3++ebs3CPBbBHJsRp2RJaEvm7tceUxlmS9XAv7f1GvTbHySQy+7Pd5HZorVGQOv
	oWZcsaBA==
X-Gm-Gg: AYBFou0XXvhiCjQM3ohToBplsW9m5wn6gafdjw8lXCyW8Nf+XxzrkUhn6P4X8A2AcCx
	YLiie1DANQXwlx24HovF+CeEXt8SpwEWl3BhQJcShhl46Wghj6ikxhpexsA7Af4EX6LQkOPCQy0
	0k0SmWgj6J4Nsqp6dV+wlsJfoliM0O9PoaWIvDDV3M7vmCrvqLNEGrrN1WseGC8K/SQW99+TY8h
	qPiwR+5/xyDZcsl0Oye3PFyXI7kaEyeDaNsJra9q80/Tu0ASCLGOGLtXn2fzVHxTOq9kV1fQM+N
	sAygt5/MsaV9K50RnViYuDCeAhu6E6iLxH9pD0pEJIR/DOQ/QCBGDo3Pc4SI32zkbjPhJYFNF/L
	FJwXsGhRa4wkxS9ERqK78Cj0Btj2DUPUebzmQAqNo/t0IrMd0jkbtGmSIBGA=
X-Received: by 2002:a17:903:2301:b0:2ed:2d5b:d42 with SMTP id d9443c01a7336-2ee0dc93f9fmr22057275ad.52.1794569824810;
        Fri, 13 Nov 2026 03:37:04 -0800 (PST)
X-Received: by 2002:a17:903:2301:b0:2ed:2d5b:d42 with SMTP id d9443c01a7336-2ee0dc93f9fmr22057135ad.52.1794569824452;
        Fri, 13 Nov 2026 03:37:04 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f80b7f6sm8757445ad.40.2026.11.13.03.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:37:04 -0800 (PST)
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
Subject: [PATCH v5 1/2] crypto: caam - Fix wrong unmap operations
Date: Fri, 13 Nov 2026 22:36:49 +1100
Message-ID: <20261113113650.63038-2-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113113650.63038-1-changwei.zou@canonical.com>
References: <20261113113650.63038-1-changwei.zou@canonical.com>
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
correct unmap function based on key->priv_form. Factor this dispatch into
a shared rsa_pdb_unmap() helper so both error paths stay in sync.

caam_rsa_set_priv_key_form() implicitly relies on zero-initialization
for priv_form. Set priv_form = FORM1 explicitly at the head of the function
for clarity and robustness.

Fixes: bf53795025a2 ("crypto: caam - add crypto_engine support for RSA algorithms")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
Assisted-by: OpenCode:claude-sonnet-4.6
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 48 ++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de66..24c740cc4a8c 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -192,6 +192,32 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
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
+		switch (key->priv_form) {
+		case FORM1:
+			rsa_priv_f1_unmap(jrdev, edesc, req);
+			break;
+		case FORM2:
+			rsa_priv_f2_unmap(jrdev, edesc, req);
+			break;
+		case FORM3:
+			rsa_priv_f3_unmap(jrdev, edesc, req);
+			break;
+		}
+	}
+}
+
 /**
  * caam_rsa_count_leading_zeros - Count leading zeros, need it to strip,
  *                                from a given scatterlist
@@ -391,7 +417,8 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 		return ret;
 
 	if (ret != -EINPROGRESS) {
-		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		rsa_pdb_unmap(jrdev, req_ctx->edesc, req,
+			      req_ctx->akcipher_op_done);
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
 		kfree(req_ctx->edesc);
 	} else {
@@ -670,9 +697,6 @@ static int akcipher_enqueue_req(struct device *jrdev,
 				struct akcipher_request *req)
 {
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
-	struct caam_rsa_key *key = &ctx->key;
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct rsa_edesc *edesc = req_ctx->edesc;
 	u32 *desc = edesc->hw_desc;
@@ -691,19 +715,7 @@ static int akcipher_enqueue_req(struct device *jrdev,
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
@@ -992,6 +1004,8 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	size_t q_sz = raw_key->q_sz;
 	unsigned aligned_size;
 
+	rsa_key->priv_form = FORM1;
+
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
 		return -ENOMEM;
-- 
2.43.0

