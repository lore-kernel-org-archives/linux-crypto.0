Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780917;
	b=gzIkOZvT6068UBqB+vT/fTHFWPzdyshM5UuRgI8jVf9B8zbHRVtK0LqunyJ/8nETayoL
	 wSDXRtM1M6JhPBgNKU1smTGwui6Q8EvQDtXVP70fuY32l5vySEvHiUBbYQZ3zKGpmL8Ax
	 /EfrEVw4qskTY3TOyi/w8UWhE0DMTPVS8GZmizYC6bGuRRzhCFMYUjMJp8v1xj1N3gAYJ
	 m0toar1/oyuWJvv1GK13h5ouz+samsO5I62gmJ+qvcQc/Ts/MtZJcwUa69XTK3PLS8QX6
	 Bo48+VbVCI8f/zesdRhtlWW5zHskw9w0i3cW5Uh42Bp6FumIU/qnc7Ue+7SWAtLIobQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780917;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=H6JuaHlgOFaTRvm4ik6+FqVcECQ77XVTUFxb5teXNtM=;
	b=YYa4+2YkYKa8pbsRYuMewGB33bZl32FXpq7mghi1m15TLpXP8nResfDVi5dcLA2OLwt9
	 T5+NZhoM347V/T2I8RcDOXa5U5ENbhBa1BB4CtEGQs7IVyiP21iPj8e1J5x7g6pvERq5K
	 SmTzy1XZakqfTWh/aagjmHL0Dg66wQT0rATd9VEZWLfC01IFdQ8AY1fvHwPK4z+M/bWap
	 Y3jMSI5EBfxf6NOXt2Stii0E6Kj/1T3PlynoOj4DRgfjUD6l5qyyJ0XNSIX2yC9QPPFj+
	 Zc1NThQN+G9q3E7Dvx1/w9GJBTJ+3hDTtdGeoUcQW3JTSP9z2RJ6XczGlvyyKd48GIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rvezEVeP;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB155606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB155606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rvezEVeP
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so49688175e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780915; x=1796385715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H6JuaHlgOFaTRvm4ik6+FqVcECQ77XVTUFxb5teXNtM=;
        b=rvezEVePSWgqG1fmVnf+JOhFq/PFr9tnnD7HkDU0tqdSbXoUmjQeUQB44qGRNwMqWf
         hrRLMpLkEKgQ+tzCUtUj2CLMY/Zy3rGTDge1q4gm4p4Va0gFYgAhUZZWKyp7v3pvlXv3
         8tO4Z7KozGU9zAXAggPpRPfT+D9oVdMWyPmObg4RmTjKAs9yolWjOzJNDvZ3WoNq7zzv
         aJ56tlaiK+7FWGsEP5ttH+4Rq+ntH3j6nnNpFT1zFbSJK0dImalZwn+O7WocwpHY4D66
         h7V1QbJYdGSkVuLR4eh8ToGwDa3a+i8hhZv4uGSPgJ2PWxy5YanClyKBgTnQSLLWXBS5
         keXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780915; x=1796385715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H6JuaHlgOFaTRvm4ik6+FqVcECQ77XVTUFxb5teXNtM=;
        b=JsgK9VkMRZ9mrJkuvpw9e3G7tjcCqW2DsALXK3hY/AGG1h9sB/IurlEUQk0PdQwj+M
         TKTyx4+7pkJW+2QW6KfQ5QstP0YwFndw7m5Iy3ZZcvm6Gh1zpRDx8hhS1MLpkT7vrNxo
         H/50+Rk0/I0OVBkEih8POR35vkqCMONhgjU6wWXW3dGEDFGyMMTNNTL71HPzZPyy30CX
         PiLobpSZOYsrlZHgK5QdOv1ifGiN+f/ouvAn0c5GzI/nZ4Sz41hGiOnJpFeSMQi+lYLP
         q1pCwTEbe0JfQZ4KD1BkzwBBidO95d3M4RobUGmrcLHOPA0cQmueIunS+otIAU/LkhjL
         0e0A==
X-Gm-Message-State: APuU4Z8awG/6kRlfFS4Hc8z+PuSKpUM7DKGY0hLCOlCFTVtdtwxoj8x5
	0dVybwA+Wli7Ma9PcESPW/9H1IQhcHeFpKa/1O7D4TuXR6demsluPkIS
X-Gm-Gg: AZFdTZfjNDztpmgE7Jw57bs6xFlsukaWpmA6Gi02seAoSnVh3MmbgAxqjKkRxszZ1CG
	BNMo0GsjQjJrdTQlose9tU+xkzdLedfk+1drQBR45c07QHtygirs/XxBk43j6flmrzdNPnnaCwT
	xP5kXJ6gEF6OVgk461dfzmy6pvAM41V6/0yzEzzBP+5QIP8ig26uadG+DCLFaZ41xXLw9I70Lnx
	fDvQLS79WV8LE1smKYL9NcjFh4Txf0xFZkuDa5HMQUn/6zQ0kPUzzUit0AfqelMID480jap3w7D
	zy7gUQSSyG+sj3xvcVKJVFwDjD2L1zX6uhrGGoClz3VN4JXnCNo8gtxETh+4HxqYBj26BlThwvP
	R4sKB0+2CC4M5F5EdlR129P5Ew34fCGd0aXaazcYzkkHG5dDwk7o/enPy+jxRPiLT8wBnNEO2Tt
	i2dPT+9ORegmSdnFrXpcuBXLXDLZ/hJT/wmkT5xQ17sg1W4xZPsUiAlXarmxANr4dwZFue9QEbd
	997xHmDCVXAbmWk+EPYiJ0sbXJPQ6W3bwjDyom+qwcz77iB4Zm0D4cugcOd99BzXePAWseud55m
	wp2+z8GUw6gC70Py3kxuqid/I9yUNV1Rk9OaDb2HqneEDwE=
X-Received: by 2002:a05:600c:5303:b0:4ba:4928:8aec with SMTP id 5b1f17b1804b1-4bb88807d7cmr456893495e9.9.1795780914919;
        Fri, 27 Nov 2026 04:01:54 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:52 -0800 (PST)
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
Subject: [PATCH v14 19/30] crypto: amlogic: hasher: add one-shot digest path
Date: Fri, 27 Nov 2026 13:00:52 +0100
Message-ID: <20261127120103.1532882-20-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  9 ++++---
 drivers/crypto/amlogic/amlogic-gxl-hasher.c | 29 +++++++++++++++++++--
 drivers/crypto/amlogic/amlogic-gxl.h        |  5 +++-
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 3a6bac10bb04..38b9645386ae 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -237,6 +237,10 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (err)
 		goto error_flow;
 
+	err = meson_hasher_register(mc);
+	if (err)
+		goto error_hasher;
+
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG)) {
 		struct dentry *dbgfs_dir;
 
@@ -247,10 +251,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 #endif
 	}
 
-	err = meson_hasher_register(mc);
-	if (err)
-		goto error_hasher;
-
 	return 0;
 
 error_hasher:
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

