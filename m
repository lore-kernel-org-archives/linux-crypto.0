Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721613;
	b=LMGfD6QHsXObtqz8nZIPnlmdlkVito6GJyZmrpNvLmzpmOkyInl+A0YLFCPbWlyweLer
	 2HanJBbVxXJL8xOy3Cfdw6AWvIVhS7rPQGd1stoS5P+nS1ojS4N9JVlAItKG78amRUIdy
	 zgNv1piCWLfbrQcFQAVX+8iGgSNTrBCZgRUzliRkk0A4qdFtM7HrfacMJml6hQHov0Gye
	 SKZ8MQuYeKvwzxBifwb4EH64NhN3I2IdY+lbA+UbC51DYMFCkako22Fv/flG8xsca6fbZ
	 S4o16eUCbL2Ph9gtjNAlo85Zy/ZhhrVLtkWjTk2YeH/NBEu9X12Ox+MO6JZtZe+j25w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721613;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hbddC97o04ZKg1StPMOMc8GcEnBHPu2bJqDhfBcc/DY=;
	b=t1bhLW3TvyBX9lhYHRZY6KSS+U8pbFORiPl0bw0cXJciXX1olaM/YkETRq4l1+1dIvlP
	 p66VQAYoKrKiDhn65mf7n5HaTczGwa3D+mDXwVyWdmW6zETvPGvwqKCb2HHExrlv9m5Dv
	 tpi3JVkDG4yHrS71NmJggWw7j9u2lijYpQ0nCL/Yvar/yvOVWJl+2uIO2LUBVC40X7eB1
	 FctAPYErdavqNyZ9cHDIBczbyksrikW0a8950SZqLJaPBniETLfnikxjoalg/xjenrgnG
	 DvXbN1W/AkpVACHIIQwJ1xCjN5vE3QuL7sbsfXDPaAICzflREzpsprQ/NOxNTOuCaHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nEuFmZmc;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5C606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43A5C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nEuFmZmc
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e46e449e8so4805029f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721612; x=1796326412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hbddC97o04ZKg1StPMOMc8GcEnBHPu2bJqDhfBcc/DY=;
        b=nEuFmZmcwnPbcn1dHuvkbLsuE9X/xMVvodmJkIFdaqgVqSdEL6e2dycqIkqYjQbsMc
         Zel9/5cKu+fwWhDY6atXZl7AebF49FZ0qjif2xpuNJB+uRbMIIZsys9dZdJU26oBLsNh
         NfP5z3u/0prt2/r5aa58p+62QD6ah9hCMXBUCtZ/uptsipGEkzqrp9lJjwbHzrFcNmCD
         WznyDMKC+Z0uhFPV78FxMpUKpQnI62mjswgCayTyXU4Jx+hiJnIoRy6az7CeCBKrADYw
         0rPvypsOGk0+toY2uWnl/d9QcgeR+fAj7Mo2xgE2RLuAggqFlmlOvG5D+rVtjKwUOKSC
         WIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721612; x=1796326412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hbddC97o04ZKg1StPMOMc8GcEnBHPu2bJqDhfBcc/DY=;
        b=MhByZYcaULwaphucFI5ji4ESbrUVB4huemS1NSKWLk8EpONTLQJUChVou/TH/ez78U
         lQpD5TCrw00eqo89mvgqRkP/K9Dr/qzMZ6r49hO6I119x5gn+cCgsIYMFZzX+6EvDKad
         Wvpv6GrYU3hZmI54MFX2d15KU6hGJRApWfl/mbgy0A8X0rKgoAyEg3UAGGOywCgBBW5N
         KpS26epRwUxIDXE1oS0AYB8VOoQb0symgLWuI2fx5Mg7hauBO2v6fOOR0Xccxqqh0Khb
         oookDcEAKZrbQpkJt+WHY1jrR9ZKtneoFX39AM6vk3lmnE4Bcea1xurJUhfxRzMDPfnt
         ZYKA==
X-Gm-Message-State: APuU4Z+mz8l1/gTHsNAqaFf/RdxEYxiHp38ifatwT0JQsQ4HCAbBuixg
	4esh6NQzpx2hCr3sNt3d8BcrZGJ1qup7peNncdVBrvJU4jNPKlygDZPE
X-Gm-Gg: AZFdTZe+HpOmwFY7Q3fHPMgyeKANAfmETvI7LEDlhgl75c25nZbudn88lJcNCMYh8KV
	ETl4vk1eVmorEjeyGDNxHTnFchZ8Sf3ApR6GkPstGzkcTZ9XDRoM5ShQy7XZse3xjI1pHb6Dl/k
	yGgSZkCdVzlDhxWM6NilBHPphIb06/uKmbi64mqCLrF6Pifyw/7+97fdq66ffrxiFdZBwSXGsPX
	E3nmaRR8AdkXGYebBONkCnhmX9gZz/r2D46tDGsCXMnAvvocrCiWzFQQRTwDjceMUqeZgygQEVf
	Fm6GsoBsMZS3MScAJiwu7++TPUQZ+KFkN4d5luYLas5WLArizyV4wg/lQMzSgNbKTJy9QKdvLb8
	3I6LJn8Cpzk4ESxmAhJdlf5s2vkBRTOKnuTsiMztaLLybzMBdXayP9gbiJka0RsUKEgoVTbq+LS
	fRrgDeFMqIqTw8Vzwxr3p3BOwfqOsOiCfdeV+jbx7dkmJ3dRn5851EGWHAAFDdV1UGg30jjLalA
	KfkPRsnFqszZNIHcxe2yost1HqRWoAYrXO53scoIGQxmu0JMKMbs2qdwt76+m53kYNvh0Ybxfy0
	AfD83lDkGHTarSLR+7RP7bjP91iLJSWK+KfT6EWSOzhN4w==
X-Received: by 2002:a05:600c:a08e:b0:4a1:fae5:f2e2 with SMTP id 5b1f17b1804b1-4bb887e0682mr449158305e9.4.1795721611530;
        Thu, 26 Nov 2026 11:33:31 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:31 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v13 19/25] crypto: amlogic: hasher: add one-shot digest path
Date: Thu, 26 Nov 2026 20:32:35 +0100
Message-ID: <20261126193241.1471372-20-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

Implement the ahash ->digest callback so one-shot SHA requests are sent
as a single engine transfer instead of the init/update/final sequence,
and skip the spurious trailing block for digest requests.

Also unregister the hasher on device removal and lower the "hasher not
supported" message to dev_dbg.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  1 +
 drivers/crypto/amlogic/amlogic-gxl-hasher.c | 29 +++++++++++++++++++--
 drivers/crypto/amlogic/amlogic-gxl.h        |  5 +++-
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 3a6bac10bb04..e79175368d8c 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -269,6 +269,7 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(mc->dbgfs_dir);
 #endif
 
+	meson_hasher_unregister(mc);
 	meson_cipher_unregister(mc);
 
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
index c83739ec3456..978cdcd8a4f9 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-hasher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
@@ -51,6 +51,25 @@ static int meson_sha_final(struct ahash_request *req)
 	return crypto_transfer_hash_request_to_engine(engine, req);
 }
 
+static int meson_sha_digest(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct meson_hasher_tfm_ctx *tctx = crypto_ahash_ctx_dma(tfm);
+	struct meson_hasher_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_engine *engine;
+
+	memset(rctx, 0, sizeof(struct meson_hasher_req_ctx));
+
+	rctx->flow = meson_get_engine_number(tctx->mc);
+	rctx->begin_req = true;
+	rctx->final_req = true;
+	rctx->digest_req = true;
+
+	engine = tctx->mc->chanlist[rctx->flow].engine;
+
+	return crypto_transfer_hash_request_to_engine(engine, req);
+}
+
 static int meson_hasher_req_map(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -251,7 +270,7 @@ static int meson_hasher_do_one_request(struct crypto_engine *engine, void *areq)
 	struct hasher_ctx ctx = {
 		.tloffset = 0,
 		.src_offset = 0,
-		.nbytes = rctx->final_req ? 0 : req->nbytes,
+		.nbytes = (rctx->final_req && !rctx->digest_req) ? 0 : req->nbytes,
 		.src_sg = req->src,
 		.areq = areq,
 	};
@@ -310,6 +329,9 @@ static int meson_hasher_do_one_request(struct crypto_engine *engine, void *areq)
 		if (!ctx.todo && ctx.nbytes)
 			continue;
 
+		if (!ctx.todo && rctx->final_req && rctx->partial_size)
+			continue;
+
 		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
 			continue;
 
@@ -393,6 +415,7 @@ static struct meson_alg_template mc_algs[] = {
 		.init = meson_sha_init,
 		.update = meson_sha_update,
 		.final = meson_sha_final,
+		.digest = meson_sha_digest,
 		.export = meson_hasher_export,
 		.import = meson_hasher_import,
 	},
@@ -421,6 +444,7 @@ static struct meson_alg_template mc_algs[] = {
 		.init = meson_sha_init,
 		.update = meson_sha_update,
 		.final = meson_sha_final,
+		.digest = meson_sha_digest,
 		.export = meson_hasher_export,
 		.import = meson_hasher_import,
 	},
@@ -449,6 +473,7 @@ static struct meson_alg_template mc_algs[] = {
 		.init = meson_sha_init,
 		.update = meson_sha_update,
 		.final = meson_sha_final,
+		.digest = meson_sha_digest,
 		.export = meson_hasher_export,
 		.import = meson_hasher_import,
 	},
@@ -463,7 +488,7 @@ int meson_hasher_register(struct meson_dev *mc)
 	int i;
 
 	if (!mc->pdata->hasher_supported) {
-		pr_info("amlogic-gxl-hasher: hasher not supported at current platform");
+		dev_dbg(mc->dev, "hasher is not supported on this platform\n");
 		return 0;
 	}
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index a44290fcf3a0..3f1ce6c05558 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -161,7 +161,9 @@ struct meson_cipher_tfm_ctx {
  * @partial_size:	size of the partial buffer
  * @partial_addr:	physical address of partial buffer
  * @partial_mapped:	indicates is partial buffer currently mapped or not
- * @flags:		request flags (for example, is this final req or not)
+ * @begin_req:		indicates this is the first request
+ * @final_req:		indicates this is the final request
+ * @digest_req:		indicates a one-shot digest request
  * @flow:		the flow to use for this request
  */
 struct meson_hasher_req_ctx {
@@ -173,6 +175,7 @@ struct meson_hasher_req_ctx {
 
 	bool begin_req;
 	bool final_req;
+	bool digest_req;
 	int flow;
 };
 
-- 
2.47.3

