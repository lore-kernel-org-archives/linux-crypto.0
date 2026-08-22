Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D19A242D67
	for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2026 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787383244; cv=none; b=OvdDJTXJBDLp9JJltb/zJQTEH/cEjd9LnESCZyMnTOMRXVSIMqgaSk58vWuHhqCJIusDtv2jLI1GcF9T9wXI/nspxXTyJqFkkhzIOHCw8zwm9ACqjd5Z6EUaGAwjZU/sAea+bLJN0B3zF1V6Sb8tRielQGwyj2ASic6oZbThz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787383244; c=relaxed/simple;
	bh=EMe0O0oAun09g3H2mTNI2xJBzXoNI5N35ldn1EuhJco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Im/Iq5lTKYcRnkJimD+4eVs8GGgwLMTNn5q0qAHX0QZ4GAcvLqOgAXD5kutiEcwkmAFI2fodj4tm1TbAjZx3Zf3+sH3CqOH71YKmkqRjg1fZDLrxiiIOzFJE06TV2pGhGPrxvuJ5B8yrFvCfFCvNWpKu5ycVvO7b+FxHCym2fPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J11aCbe2; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J11aCbe2"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e347638adso1606297a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 22 Aug 2026 00:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787383242; x=1787988042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3iQTnt9oJ3v6w7xIpplt3JgJj2kj/4e9mI/GL4WtqJk=;
        b=J11aCbe2tXDP5EfPVeSTchs8dIS+jthwDW3VJAVXcolxuBaIUF8XYmrp7xgzQAx4Wr
         lYI0bN77SqEnCL3bEOytMtt1qR5YhHMQ42k7hxTq/DOQK762kcaB+hq1qJQXPC5FvG0q
         SS65JUgkHLLlJZVa5j4BMu8eKFQxpRjYsVYaW64GO1N0WpMTIqUxDrT+VVyhLgvmkEpc
         u6aLVhLZYvmmtWU4VArdaKQklT5KfIuBTpkgI3pbsN1r3XwsbuANstD4KvT1aI8IbA12
         M+wKO9Y72eSIemFZn9tr5UVZIKl34Q5HM07UE2rGGgMYUtzEDQqToT6rDPuvat4ScLfh
         pO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787383242; x=1787988042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3iQTnt9oJ3v6w7xIpplt3JgJj2kj/4e9mI/GL4WtqJk=;
        b=flGBa4SBDR73WFDUvXhfbwfTLAH8LSkJjSItZNzX2RbZ6HdhZOKgS2iEbIS0ywO0zT
         5DgwFNTcDf2JQIjCgbqzmQUPnKSZmqeR9hIFF32q6+17w+VA3Xefci8jQje/OOr8X/jb
         QuS4H709z8vFiN0kBh0S8nj4Q2CgZDmt+B4z9SrVxozS4Ncmybw2nXJFq8CGcHNwalSM
         LvFRFZbXnTAVIcBF9fouFC19wOKhnuSHnf6qoaX00Bu4wWHGzATkzEhAQHTJmyLOq6p9
         mS9LhFVAxfU+7GTFeBI9xd/IiVKwFHKLV76VClh3dLOjWCyYzarVRljdgwnoYpFCWHuK
         5mwg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1A5VA+NpVFnAgL/pjPWAiHeg0qr6KQg+2WP7jslvFVaotFw8GPeZBKeX8B3NCMri82TcSSmrlF4dCD5k=@vger.kernel.org
X-Gm-Message-State: AFuF++mA8kZKNzx3nNGjDOVV2knnwsvjUOM+5IJRYqYzH6SjtXDTVkrq
	hD/brVSCAVIqx8ojF+tGatyvKUILY8rrouvw8TLEUdNKAW2FRm0T+qtE
X-Gm-Gg: AR+sD12XcI5fdfNIpDO9Ctds0QiYoU2mhe6Z0voT6+QDgMg/Fs7eSHoH5YkuzxWgwiM
	8Yc6MNc5GYAwkKR5XcO7wK8lrjbXoc5b9QcNpGZ4R00Ke0XaQY5wv3TSqGWClmaVbl2ipxXs02i
	SzuuyGB2iDVF8m7bjMusUOxnLrQxr+QGs/4lmDqttj4GFLdsqsY/xdFY3rMig35TZg25r2ktfi4
	+oH2cgYoIoBn7ml/0tzmpQEpr6uMFxQHHCUCrJRF6hg5NKr2WJmmfspMZsm4OgDYbJcifidXoRg
	OJ55FZa5ZLbNDEh1CobN3MtBYZkVLOE4MmE2qErbHrIwHWnLbLEl0JjslNCVDDDfHi3VmGsTYjx
	nsQgfXurrolixvoMLAq2+aaII+OeRkHqlFy+b3zNmNY3k7diBM4YGGQUHuxKFoSuUoYAav83qi9
	sl2AisJLQf0dsjCvAezMQ+4XCINGlL6sQvGOsgMG6G0rJgZuyX4gtFQRPl23+4a4IKuvZvRfbKN
	hJu29i1
X-Received: by 2002:a17:90b:538f:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-395df29e128mr7734335a91.13.1787383242533;
        Sat, 22 Aug 2026 00:20:42 -0700 (PDT)
Received: from kernel ([103.219.206.63])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f909a51fsm3290362eec.4.2026.08.22.00.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 00:20:42 -0700 (PDT)
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
Subject: [PATCH] crypto: amlogic: Fix DMA memory leak in cipher error path
Date: Sat, 22 Aug 2026 12:50:31 +0530
Message-ID: <20260822072031.23042-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In meson_cipher(), if the mapping of the destination scatterlist fails,
the driver jumps to the end of the function. This skips the unmapping of
the previously mapped source scatterlist and the key/IV buffer, causing
a DMA memory leak.

Fix this by introducing proper error labels, error_src and error_keyiv
to unmap the already mapped resources before returning the error.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 29048da6f50a..fc8569fd83fd 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -178,9 +178,9 @@ static int meson_cipher(struct skcipher_request *areq)
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
 		if (!nr_sgs) {
-			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
+			dev_err(mc->dev, "Invalid BIDIR SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+			goto error_keyiv;
 		}
 		nr_sgd = nr_sgs;
 	} else {
@@ -189,14 +189,14 @@ static int meson_cipher(struct skcipher_request *areq)
 		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+			goto error_keyiv;
 		}
 		nr_sgd = dma_map_sg(mc->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
 		if (!nr_sgd || nr_sgd > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgd);
 			err = -EINVAL;
-			goto theend;
+			goto error_src;
 		}
 	}
 
@@ -251,6 +251,12 @@ static int meson_cipher(struct skcipher_request *areq)
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

