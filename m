Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C9D3A3830
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777585440; cv=none; b=bUjK6K+z/8Yt1wxgKln7VOuSVswts5K59UOVElDJ5SD+ObRXbSrCQpwRs/CBfNzVBC140+qkMDQ8aZiN4eoyalIJYT/eD1FScHKy4XbidJrToGWYi5vOOXgvMKR3AI9uqUlpKwSaODV1e0pehtgZUaRt5WfWkf/a8+Ddt3isG+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777585440; c=relaxed/simple;
	bh=M26zyhA5t24GPKGYCTGb/aogmGLpzeEa8q2aXPKEQas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eEX2kTZNW9lHiXT5XlfoETIY8zNw4ifDqmuhUdZcyUhE6V/LfscmOiAfuHTG+9V7LVsgaHV8rsGZNxwIKl01p34la97lQjpV2oFm7XowOecd9CTrjxD5eHYVq0q6b59m2KE5mtXP5d5DYKyi7XV+acEmF3eEZQ6fp6Vr+6ws2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVPiMVoy; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVPiMVoy"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so1510887a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 14:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777585438; x=1778190238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XX7iQVHvtl0B67D8W3qVofrAFP/lX8Hl1A01uIMYbIQ=;
        b=LVPiMVoybTWmuGgEgSqt0ivJb+2mRKP3k03gQwKxTJRnNopjmpe2E8RQVzHYv2qJVK
         Kd0rOey3DIq95uR15GjkbYQQ5CLS174T4cRz4Ru8Kx4iXtUzz3HBT1HZH+vE7sQbZg/d
         xaSOcQffcZ6exgFjccxa6E38VwTx2PKOHe3L8iQVIy6lI3OCZzfT/b9hjBQvjEbXU2t0
         NzdcDe51bpUVXf7C+zSV7CBs+7Iy1/Mkto2WAh4GY0wu9quryHXmmPz8er0kBKWtefay
         sLu0s88FptH6ihX0Vdi00Vy0onquvYhVyGuXa6MaOkqOPC2/m6G8eVwieq4kSaaT/LFX
         z5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777585438; x=1778190238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XX7iQVHvtl0B67D8W3qVofrAFP/lX8Hl1A01uIMYbIQ=;
        b=oLNWvrjI3UXjytnHyFoUQ0afcbqniYbm1r50Uf4i9Tdlid07jBH6dYuNo/AJ82hySt
         dBiOTsmdffPLhR0/WyH7bkxu41FLS1E+MSe+jGY9hYZvf6FpsCwnFuEndNmCcG0I0WIs
         d7k6gCfz2FHiJMQ+ehOSjWg9riwV8430d2zCJjg5BGcA4x9xmVN0VterDJyAlLxQh4XN
         /gC4j8kul1fkiWol6SkgNUxyNzSCI3fTVHfZkgmdAWpizUO71f5NO11/r0PQ00qIdYAt
         WVdecfpBht7UcWi5EY7FUOqSAOnQ04OIzwl04uVSKFKLe1oFyjpei+NcTFZemAlo4ykO
         lTjw==
X-Gm-Message-State: AOJu0YyYqtcI8s+sq8HNfCPCdjZihximhlCunWGD/YOjU7JSywSeWLjw
	n7UMiF27/Lr8L+VBLjh1gs+X+rnUY7zpp34O+onOiZfGKUGzfvLREKzSF1Ipcg==
X-Gm-Gg: AeBDietLmGmMWRULT2/zNYEnsy8vG9j+41Ey3NB7Sur5JgQoewbutNAflNcvhEI/20M
	kVvFunxO/Drwyf5RjtL5mHlqwi/86Qt15NZtV+E+IEpTUT6JS8C1vGOqtUqKgiU20pxij+KJgRx
	sO47IbV7eXMdFs95gcQCCNoswJYPs3Hgcl1lZm/U6j47d1aVK6GdhiA4kFMch2ai9mODLR/4Fi2
	QG9+/XvOjSGhStkPfgIzI1IYwbIKtTWB12axzA6MHXlshNfdh3mFj1dyEgkh2x2gq99djZ+BtU4
	6EFU9Y5Ga9NsdENuBjz9ZHIgzy0nrz98W0BiCz87u5yU1bJ9YfhE92sr91KR/RelSHG/gHWhhaO
	GW86c52hR2ae7q3fR4+/pUyB182j4HZjINaQtTqfzx+I6AHjULiBKdjBZlpHukuR/HyLHuvE3DH
	LVXIOsYqbcCEybTeO/xo3q26D7/6JCox/iKfwqwrJ3hb3Gu2mlcvrCFLzuqoeUXAl84PCOIXvbg
	JsEkNLBW2hrcfYGOLK3qEaq0bhjJqwPxZ/rpKFheuSXYA==
X-Received: by 2002:a17:90b:5252:b0:35e:3e86:e2d1 with SMTP id 98e67ed59e1d1-364ef3a2290mr304651a91.7.1777585438238;
        Thu, 30 Apr 2026 14:43:58 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364bdf2a71bsm3945592a91.1.2026.04.30.14.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:43:57 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH] talitos: allocate channels with main struct
Date: Thu, 30 Apr 2026 14:43:40 -0700
Message-ID: <20260430214340.59588-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a flexible array member to combine allocations.

Add __counted_by for extra runtime analysis.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/talitos.c | 17 +++++------------
 drivers/crypto/talitos.h |  5 +++--
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bc61d0fe3514..98323c154031 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3409,14 +3409,18 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
+	unsigned int num_channels;
 	int i, err;
 	int stride;
 	struct resource *res;
 
-	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
+	of_property_read_u32(np, "fsl,num-channels", &num_channels);
+	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_channels = num_channels;
+
 	INIT_LIST_HEAD(&priv->alg_list);
 
 	dev_set_drvdata(dev, priv);
@@ -3436,7 +3440,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3511,16 +3514,6 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
-	priv->chan = devm_kcalloc(dev,
-				  priv->num_channels,
-				  sizeof(struct talitos_channel),
-				  GFP_KERNEL);
-	if (!priv->chan) {
-		dev_err(dev, "failed to allocate channel management space\n");
-		err = -ENOMEM;
-		goto err_out;
-	}
-
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 1a93ee355929..34b0b5fab7e7 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -139,8 +139,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -153,6 +151,9 @@ struct talitos_private {
 	/* hwrng device */
 	struct hwrng rng;
 	bool rng_registered;
+
+	struct talitos_channel chan[] __counted_by(num_channels);
+
 };
 
 /* .features flag */
-- 
2.54.0

