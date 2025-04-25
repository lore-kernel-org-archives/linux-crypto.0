Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A10D24BC1D;
	Fri, 25 Apr 2025 12:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585150; cv=none; b=ibvG0cGoHLQbeTcIhSgJ1EWRHEK1z7ouGXi33aAMs5RXtARxRA8bO8KORPgdf4dPtflOjKa5Ev6CVLu7JIrvXuDFRqpPwZmgnr+m4BQMOamfTZU06repzH9dNgtO+yOKVF+aB4w1Q7Q4LLOYM0raL/OY4meEH7AYEmgEsGppf8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585150; c=relaxed/simple;
	bh=N1JqJa/Thtcgbai7AXn0UM396DEB6usJBO8fHeX8CeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TbU2Cyqvf6egm+YUVzXDJ7GlUYeoIXOK7vUMDkIA0uoxi/ikH+A9ENATeHtzAcZFdY8dQ6BhC1dxgh88tGeWBW4cp+AeA7jBUH11SYE1HqFO+M4Ll5dNFhxogDcGhwPZHovjIJAXeRiXFrl2eYmxbc5aWFrbLSvIAmD9NE+Kk0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rng4Q1ek; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rng4Q1ek"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac2bdea5a38so336511366b.0;
        Fri, 25 Apr 2025 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745585146; x=1746189946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l3BCALyVfXKt+WZYBHxbyWx+XxVRkGCfaI97XHpd+pY=;
        b=Rng4Q1ekEgj4eHEgEGAHrrYJb35kVZmqmz2o0o51RVO9Zxd3Bse2ALlohNR6Vdwe0w
         iIZ9iVJiL05MmOiukVkWbmAPrgFlD2U4TlXQjxPOBYGmhOAVN/hsQcLG+/PSZkRrnHs7
         3mVu3jmo7k9MmrFYVUWyLo9SpIOiO/3sNm97xKPSzAwqhkp7bMWweqfunUn1vEEOIJ3w
         AxROhPBeVAoUkbANVTE2Pk9tfPFRuugqRpa9epK0VqnjscVNb/BB8bu+bTKgJc5g683j
         z0KVOzbldWuzd5B+PkyPsiokdsGRNuOzOvzmdA5qS1GcNaDqp6Vdiq+GU1Y8ACXzJjih
         IvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585146; x=1746189946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3BCALyVfXKt+WZYBHxbyWx+XxVRkGCfaI97XHpd+pY=;
        b=LNE0CyByBEhkNyErrxT++sk2M/A7lttQZMfB8RlGxP7Jbq8mAt7xgoxDEm/xZ1pq49
         iGtm6LccScJPdUupOOeTNGDcfpjGzNnZg5RjovglLshrJzAJUiYKzryUFrTllihG0Ab4
         5Y/BtR9VIUhEZHpz2GFIw+73bPPDBCb6xg4C+TAau8LPwwGos6VNcVHnUq4U/R7CYZEN
         msyeVfNqpneUOC5O/amNrqXgmCcRXvvd43gjEq0yyrBLqtHCIK4TMaRkRbFHjKD8WhkX
         ONJL5NNeKNXkQXzaNJWmsxjzCjtx9RcFM75+T3y+I0yPsMr2zjZMulejsx6UaQZ2rQU9
         Fn5A==
X-Forwarded-Encrypted: i=1; AJvYcCVNGi+rsXSnGybXk6yjZwHrizukJhALv/JzsJZmqrHFIIB2qKn+/deoWK3/OCj8ni7xwJihq7XkJraZ1e8=@vger.kernel.org, AJvYcCXU6qenmHErF4tyuhMwvySmbP/J3IqEDjYFJTywoq7wrjGl1xOkPt22nP0gecJ7EyNASoXPYoL+eZEwpSYy@vger.kernel.org
X-Gm-Message-State: AOJu0YzUnIuEq2lTc/uidojylZM87Z8b3q+0fw1A779axTcd2kV4LMy0
	L9ZAOIjjqJeluJm/Qhw45tydhMJnbf6N16U3Fuh1pZpQr6SnIjQQ
X-Gm-Gg: ASbGncsPNttTSSzJv3s0/e4hZvSdoeYLHWuPem95EvbY/16YFH3yCp0pbN93mWYd2w+
	sNDXxoLdeKsBAFF5Pm2DZddsvGEGFeo6aVUdUlVx5gf0SFxR8wEsV6ofTFpJjwMdecfOSeY1j08
	5X7UeE5xgD2OvBHD8VPusdYCAHYLdZpHhti4EypFm1LqNedB1PSBSlI2X6H1irm0vGPrVRDo9QY
	iG/mYFfN20fUCzkNxZPIzQweeG7lhXfnST1xOfqkpmeDUGHXXKBBueBN+SUet8EeumPjhs2MhS5
	GS7WjCzWI5mtiIPc7L5vmcoEbBjFJrqlPAO3Z44VFnlkmW3gdQSyDkzBHC4yr8fLY/PyQzEJFdE
	0q+I=
X-Google-Smtp-Source: AGHT+IF6lACxg5XQV9zx3XY5JZvnZc0emetlxi1pM+qXxla8Kdp3t0Y/dF93JbbLv9LE6OFyvzm8+A==
X-Received: by 2002:a17:907:1c29:b0:aca:95e7:9977 with SMTP id a640c23a62f3a-ace7113336fmr191137166b.28.1745585146266;
        Fri, 25 Apr 2025 05:45:46 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7094sm134641766b.56.2025.04.25.05.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:45:45 -0700 (PDT)
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
Subject: [PATCH 1/4] crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()
Date: Fri, 25 Apr 2025 15:45:14 +0300
Message-ID: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two DMA cleanup issues on the error path in sun8i_ce_cipher_prepare():

1] If dma_map_sg() fails for areq->dst, the device driver would try to free
   DMA memory it has not allocated in the first place. To fix this, on the
   "theend_sgs" error path, call dma unmap only if the corresponding dma
   map was successful.

2] If the dma_map_single() call for the IV fails, the device driver would
   try to free an invalid DMA memory address on the "theend_iv" path:
   ------------[ cut here ]------------
   DMA-API: sun8i-ce 1904000.crypto: device driver tries to free an invalid DMA memory address
   WARNING: CPU: 2 PID: 69 at kernel/dma/debug.c:968 check_unmap+0x123c/0x1b90
   Modules linked in: skcipher_example(O+)
   CPU: 2 UID: 0 PID: 69 Comm: 1904000.crypto- Tainted: G           O        6.15.0-rc3+ #24 PREEMPT
   Tainted: [O]=OOT_MODULE
   Hardware name: OrangePi Zero2 (DT)
   pc : check_unmap+0x123c/0x1b90
   lr : check_unmap+0x123c/0x1b90
   ...
   Call trace:
    check_unmap+0x123c/0x1b90 (P)
    debug_dma_unmap_page+0xac/0xc0
    dma_unmap_page_attrs+0x1f4/0x5fc
    sun8i_ce_cipher_do_one+0x1bd4/0x1f40
    crypto_pump_work+0x334/0x6e0
    kthread_worker_fn+0x21c/0x438
    kthread+0x374/0x664
    ret_from_fork+0x10/0x20
   ---[ end trace 0000000000000000 ]---

To fix this, check for !dma_mapping_error() before calling
dma_unmap_single() on the "theend_iv" path.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 19b7fb4a93e8..05f67661553c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -275,13 +275,16 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	} else {
 		if (nr_sgs > 0)
 			dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
-		dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
+
+		if (nr_sgd > 0)
+			dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
 	}
 
 theend_iv:
 	if (areq->iv && ivsize > 0) {
-		if (rctx->addr_iv)
+		if (!dma_mapping_error(ce->dev, rctx->addr_iv))
 			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
+
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
 			memcpy(areq->iv, chan->backup_iv, ivsize);
-- 
2.48.1

