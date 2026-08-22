Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2F137FF53
	for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2026 08:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787388328; cv=none; b=Kxbn3JNMYSMxzWcjB/YtQnYMmQdAYsNEDslLvz5RJQsOkCJjcSi+a5F5Mp8TAo7fQuzOalrJJ9vNiIQT+u0ADFBB87Oro5EZG9YlfoKF9tIIo6qtSU/6lS3BUzWaMpI92VYxbOqSeUnwlIRM5hve2uwLp1IG1U/BwKWV07P0P6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787388328; c=relaxed/simple;
	bh=LgJkC43UU3SzSb36mlfID1pfqacnkEZzBSfIu4rC31s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u4HKXn3itf9VL64VV+5tZU26fUVQHwLadN1XIAepBPaVZCIxsg8U+vvQaIw7BhthRLP5T+Svox3ZORFQM+4Suqnh02jyJo3DbNFvsmfQI41RXFdwWvT418EaewY4HsxBPz+1qJiBVBKMUGqGCwt6EjLXaFbbOdKsR1ewOvRWkQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6G0g6zW; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6G0g6zW"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dcbade417so1998215a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2026 01:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787388317; x=1787993117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=74796tnDJ+NCSB9SFK75OzCa7nSnHKFX91lyqQmVcl4=;
        b=s6G0g6zWw+apEkNtqjMobA2qTbrVxYYeF9LLSPPPXbpT/rvgRTVcxDZkMcvajQ/SQv
         PGPh1sYbK+qww7gDT0BPuSbGCI120yagdMik4/JwWd2O04WaZGziHY21p8V60+MsWgge
         u7tdZmUDdvG8sct45n/N3ZWBHPLwq42Md7AIozTLLRSetCmzMOztkNWPUb/BAhu+M/id
         iySj3ndnjTY96h4D8wwZ6tDme3SHolDolAz2cWY8ZTXdYQ3ULnuh7j84FqZfg2fcnOYj
         EHlIf7P1ZoOLWpyijZ7zlKUjIPr1swv/xt39yvgzYhGUPW6fOJWGjTXxqj7KPNCJTl7N
         yNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787388317; x=1787993117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=74796tnDJ+NCSB9SFK75OzCa7nSnHKFX91lyqQmVcl4=;
        b=hmncjzkdrSBrAwLwE52WIgj+y92UaKVEe+OYIxn9BaOCCZPVTodLRVfzCBwbIR7Sz2
         cULeU5v/qUE4q0meDpUa8b/xyW7YtZqbDKahvaGVuq2ZoRHN6lS/w9WxAS+b3niNiz+9
         3pwD6NWnDyzJj3I/jOB7niAQUmI8q9HQNa27SSjWMbEHJs4nchsTDEfZZUe4PlYzKQgd
         10PocvVpPTTxlP1pUn5skJTmbogzipF8AJCexto4CJ109WVnE6SzZto96EHdUxNjrNIS
         1q9rc9ZqvNEREKGPyHm1QlyrOiYIP3Mr9qd4j+1416PBvKezislCNVjR62LdWQnRHeoU
         PfWw==
X-Forwarded-Encrypted: i=1; AHgh+RoGSUjKhfTHqToL/nfQBVGomSitxfXNx1h1f+FPctSRfQ/0d9bVU6OykSScpgSXUoXZyetksTnl3lNAQC4=@vger.kernel.org
X-Gm-Message-State: AFuF++kLTK62XBqO5TFB735yX/vLv/9FFIW+vWGa4LkM84n4E/SHD17i
	dBUMHT2a1GLesKsBEBSMgTyoHtgDhH1UNfs9UTlqg8Wa0TEV2PdDGmZq
X-Gm-Gg: AR+sD13VkY3XKUCRs04p6Ar0zWknDrDbiNlYqW4kaiUoCipp+aA8iPE2V5OegUyHxvq
	e3Vy+yVYty+LDoPR61uZuffDvTgcG2jj78cyTNWC4TyDcCJgY0AjQUEkq0g9mhB9QQltAqPjZzd
	67H412+EpqWKBk3ImK+0MKC3pGWFsj8pyAw9/OdhpRnEuofOzK4T4IFv28Tk/j0VxMYxzI1B7jl
	TTiFWdoEhHQTfBumM+m9LkjLWYTnlGWubF5khYSRwHLM3cNb9J8jP2SB51/K2jyMAHDelB/DG/p
	RIAWvUmHSgSwZxkLbzRgGE6yNx/MgMMN5ue6UuuxdylUlSRZI/TIfgSKSIpzkkV92IQ7Q/a+HEU
	ZkxFcki4IwqRcfZs1J3yOius8dXqiWPfGzbgv/WrQ1s/ihJApNqAmA7ifuJQTPg1SNeoZjVCO8G
	9Cfrm9EfsRac9XB8iTGMwq35ipxozCtSD20RgzpFWBIdfMvqRYy0MXiS65XBikD9jq7tef5QnLR
	Qf+qoSs
X-Received: by 2002:a17:90a:ec8e:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-395c2f2a10bmr22322171a91.0.1787388317445;
        Sat, 22 Aug 2026 01:45:17 -0700 (PDT)
Received: from kernel ([103.219.206.63])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f909c6c9sm5467855eec.6.2026.08.22.01.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 01:45:16 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH v2] crypto: amlogic: Fix DMA memory leak in cipher error path
Date: Sat, 22 Aug 2026 14:15:08 +0530
Message-ID: <20260822084509.26385-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A DMA memory leak occurs in meson_cipher() on the mapping error paths.
The driver jumps to the end of the function without unmapping the
previously mapped source scatterlist and key/IV buffer when the
destination apping fails.

Additionally, a memory leak occurs when a scatterlist mapping succeeds
but the returned count exceeds the driver's MAXDESC limit. In this case,
the driver rejects the mapping without unmapping it. The BIDIRECTIONAL
mapping branch also lacks the required 'MAXDESC -3' upper bound check.

Fix this by introducing proper error labels, error_src and error_keyiv
and unmap resources immediately inside the calidation checks to ensure
all successfully mapped resources are cleaned up before returning the
error.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
Changes in v2:
- Add missing '> MAXDESC - 3' upper bound check for the BIDIRECTIONAL
  scatterlist mapping branch.
- Unmap scatterlists immediately inside the 'if' block when the count
  exceeds MAXDESC - 3, because dma_map_sg() actually succeeds in this
  case and the mapping must be undone.

 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 29048da6f50a..39b44ec89997 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -177,10 +177,13 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (!nr_sgs) {
-			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
+		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
+			dev_err(mc->dev, "Invalid BIDIR SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+			
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_BIDIRECTIONAL);
+			goto error_keyiv;
 		}
 		nr_sgd = nr_sgs;
 	} else {
@@ -189,14 +192,20 @@ static int meson_cipher(struct skcipher_request *areq)
 		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+			goto error_keyiv;
 		}
 		nr_sgd = dma_map_sg(mc->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
 		if (!nr_sgd || nr_sgd > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgd);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgd)
+				dma_unmap_sg(mc->dev, areq->dst, sg_nents(areq->dst), DMA_FROM_DEVICE);
+			goto error_src;
 		}
 	}
 
@@ -251,6 +260,12 @@ static int meson_cipher(struct skcipher_request *areq)
 						 ivsize, 0);
 		}
 	}
+	goto theend;
+
+error_src:
+	dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+error_keyiv:
+	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
 theend:
 	kfree_sensitive(bkeyiv);
 	kfree_sensitive(backup_iv);
-- 
2.53.0

