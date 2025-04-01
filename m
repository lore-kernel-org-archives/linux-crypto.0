Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814D39461;
	Tue,  1 Apr 2025 19:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535440; cv=none; b=cLi212o/0K7+M9fhwsdtcJJ53Rcusf1h7B/xqMOqFVBmZOOx7zeFwDpsoKTneRvU8WKEBJdJNgc4ESeBqUX58nBMPGWlBUZSJEZsnxUimADJ2gEZkTyc/L4bWHqr+rMk0fn9k7qMLOMZ8z99UY1WfNUn6Dnp/IM71qqOK9g0VV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535440; c=relaxed/simple;
	bh=/4EojNlyd9dMoLRzf5Mm/q8bty3ZBw5BXSWBsU/clpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjPTIaDbfXs9I+h4GoANZS/A8yjY4Y1t+fccMmFP5DHqMFvTEWm1gNeP43Yw4MyIgLazRlGhPUws3O6aVAoukuZcCusXQz14xUOinzGHr7uaHl1eQ10I4sSi/phymQ5s6BBeGyeuJH8Zrg+t5Vipt1FHAOI/EVUtu9kmmrS6z74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPyZlSXQ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPyZlSXQ"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso1526126f8f.0;
        Tue, 01 Apr 2025 12:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743535437; x=1744140237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nierB4LEgce+4kZQOSa3FNbylwS0gDWPVPBM7TYut2U=;
        b=kPyZlSXQySqPe1HXt8TcwuvhImhTQXkbyb2RbRs5BhKaABFU1Ov7iScWpgwFYe5uOU
         EZaP0QSahsbD533kxLHVdoSGpcl+Hio1VwOlh+vN9Is31GImUKvnfzxIr60ryEwgIrQX
         cTd7DRvltGdPceD5vSkF05Has+lBhdW4yjR1QaIFemnfVEFy7dmAV9pMP3j99m8qCISL
         ua6wbHpgTLrYkiScr1Xnfb/dwGMdP//9S1w5mb9WK2sPeHXivYjcSZZTVOq+S8+nXLGu
         o8oGuy96Tlz0oOKWXFdzWCLhUX966PzUp8vckSAnog1XnrrtGc3JasUqm8bLetfOeTN4
         x09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743535437; x=1744140237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nierB4LEgce+4kZQOSa3FNbylwS0gDWPVPBM7TYut2U=;
        b=Uo6pfKbM462hr6oO4f4CSCEybQHA0hD9GmGfQj0CiOvSKTDyROISkNrpYtilmIGd0e
         qkknPDYNdgoZIEIL9M2tP3lXT1pg9WMXNGGVYbAY1wH1Y3VswgdRUaNklR7uEk7xsh7w
         Sy1wQOBknSnqFaR6QH55u7dOkS/vDMsXtBvQ8cIPJjPfl3csMdITjVb9XQ+y/kX8tqkO
         XWdBNJnl9kmGHeCogk4LPe3fdn02Lh12w/bVda4D939OTkt3dGx8MIm1RvijRWLyGJFn
         SHoamJIZtd2e2y7wrZaxzKSlZYGWFTjcVuj3iDe86zyHrVeonz2+CjHJwhrJNmw+Ghyz
         pLWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVYAF1JxRyRXf/rzkPyCfSrvAcG12OaBVmbW6uhHkkAsat76o5MKEE6Y+8dW4as8b8WttotB2XIZcMK/s=@vger.kernel.org, AJvYcCXg10/koam8ude2oZi+lSy2XGfviqQj0DvXpBplerqlzg5a2jfZKbdJEgtu/1mZxfIpBwm0Yky92ViJFr9F@vger.kernel.org
X-Gm-Message-State: AOJu0Yym6Tsi3VnwB3MQx+YiAkzO/SuU6w3Ye3UwPItACwgFqTrud0p2
	RGFGNPp5lDx6THuNUsxttowSDglN5N8I1t0K9gOIASHaiywZ6GCu
X-Gm-Gg: ASbGncuGDzMwuQDcPw4BSdqFisstPviHD2QA/1UJZ+bYgIa/9ZxRgN7jGlaYCGCWqxd
	Sv/kf66tiU4RGI5BWarlyBIqDRhy/yHTTHcxsnPo6u8e/ZxdgQsmzSMzuicwGYM0D1zYXxBmeiQ
	LuQD4VQB3Q6+YhwNTTv6nFJfePAkoJvgzqWErCEbAbQcuTtn82Z2NhZuNDBKOqagW/thUAVcwlE
	fGWy79QGBQLhHsP8KLKEto9z9gAHP0Jea0UcFtjy6NgGL9SfCRj3Zfm8CwwGFHUsxY9dMBX4LAu
	mj4olnr52NM5TVodwbUHwjD2y17Oqq7+BFDi2i1FGJgpPgM/icGQtOvCLVoN0XfvL9l+VI1G
X-Google-Smtp-Source: AGHT+IGHyzi31e3692ONFiGCVRk0AOakCuPS3Q8lpPUYekXyBseRhASvcdujfWAcxWGfSdab5h7ydg==
X-Received: by 2002:a5d:64c7:0:b0:391:4bfd:6d5 with SMTP id ffacd0b85a97d-39c1211d5c8mr11428784f8f.52.1743535436607;
        Tue, 01 Apr 2025 12:23:56 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66aa32sm15353438f8f.50.2025.04.01.12.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:23:56 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 1/6] crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()
Date: Tue,  1 Apr 2025 22:23:16 +0300
Message-ID: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework error handling in sun8i_ce_hash_run() to unmap the dma buffers in
case of failure. Currently, the dma unmap functions are not called if the
function errors out at various points.

Fixes: 56f6d5aee88d1 ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 34 ++++++++++++-------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 6072dd9f390b..3f9d79ea01aa 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -343,9 +343,8 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	u32 common;
 	u64 byte_count;
 	__le32 *bf;
-	void *buf = NULL;
+	void *buf, *result;
 	int j, i, todo;
-	void *result = NULL;
 	u64 bs;
 	int digestsize;
 	dma_addr_t addr_res, addr_pad;
@@ -365,14 +364,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	buf = kcalloc(2, bs, GFP_KERNEL | GFP_DMA);
 	if (!buf) {
 		err = -ENOMEM;
-		goto theend;
+		goto err_out;
 	}
 	bf = (__le32 *)buf;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
 	if (!result) {
 		err = -ENOMEM;
-		goto theend;
+		goto err_free_buf;
 	}
 
 	flow = rctx->flow;
@@ -398,7 +397,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
-		goto theend;
+		goto err_free_result;
 	}
 
 	len = areq->nbytes;
@@ -411,7 +410,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (len > 0) {
 		dev_err(ce->dev, "remaining len %d\n", len);
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_src;
 	}
 	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
 	cet->t_dst[0].addr = desc_addr_val_le32(ce, addr_res);
@@ -419,7 +418,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_src;
 	}
 
 	byte_count = areq->nbytes;
@@ -441,7 +440,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	}
 	if (!j) {
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_result;
 	}
 
 	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
@@ -450,7 +449,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_result;
 	}
 
 	if (ce->variant->hash_t_dlen_in_bits)
@@ -463,16 +462,25 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
-	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
+
+err_unmap_result:
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+	if (!err)
+		memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
 
+err_unmap_src:
+	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 
-	memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
-theend:
-	kfree(buf);
+err_free_result:
 	kfree(result);
+
+err_free_buf:
+	kfree(buf);
+
+err_out:
 	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
 	local_bh_enable();
+
 	return 0;
 }
-- 
2.48.1

