Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87232413622
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781543423; cv=none; b=HQWiVdRgwN3IINrHOZdz8ORgT7G2du3EfmTykgEuHioG+xrAfI65K+4G8033CSauq6MY1diVLzkTNZxGauKQPc/dDf2rLE4CIz0znOEwAQZW1/i1281ZYurGfZARyHf0b7/7dWu2D7S/GpsMpb3RzAOulSAaedRiLAXS64jFUNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781543423; c=relaxed/simple;
	bh=LXs2zueE0D2dpytVaeCLfAUjvvjZIlkaXlqTqIYex3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMLxoxt+DoRYya3JMgbmlUjaxwysAwtLmem9hTrABQ+EvrglYrxLEYUaK1ywv2JiK9R1lI6+ERB2ApRkDtxG64U22yMrpjtuOJmgml5S3iRQzVWiOpGH4xEAp33QvKD0VP3BS5HIhKRyWEI36Qf0eNEItRMrGdvkoVNoMMJ9CoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lhve2f30; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lhve2f30"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490be03d47bso38349125e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 10:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781543420; x=1782148220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VdFdlTV/MJfNAMtE1zuVhep47GAWFmfkWpWdR9Lfcxs=;
        b=Lhve2f306EYtH5OhyzfGEzhjc9zYBZmYw2mQTDyojBTDjiKJK9xCukxsTRxOPXuMAL
         dYQPilecrmRY5Lm9twLKEw67+2s67lnGnk03FqWO7xq26v8BNW7DOZx6Ps7qKIkq7hW0
         d/OEONNHU+CPtedwG9zMPQBwSNb8Mt8dULHgpTmE0ZStl68smJl3BMwjMpOtFJOVkHt5
         /Z9cWAQK7TSnjWvV/2YvK0ge1f/LgwFoz5R7x2PlH0PWA1ep/IHN9HhpBhbnPWo9TNJR
         /1rv1H0Q8/fv+MQUI7S2Xx1ewVSIjfsBME4v6xzxZCBYTeTwtSNRn2lJzKcsfrmgPPuC
         vLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781543420; x=1782148220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdFdlTV/MJfNAMtE1zuVhep47GAWFmfkWpWdR9Lfcxs=;
        b=jKvTxMDzzJxRVlPxDnEeTLVUcFrx33LqbmSUEQsDlxGxTJvQlgV1wqmbLOQV0Q5nDh
         Vj/8X+NegtcAVPqiB+pDSS14auHntYbgeg9Qn/1jSBqCIi/Z2rATFUs56RXdWK+O4rK9
         mxdqfvsOfPK7qQBkeHbmBjS6iiASxC4Sjevyt19LF79SGYIZZ+AvDzSQU0ihM09r9nDm
         r2nKMqTlaTSX2dyFVylebX8CcxRhcge3Fzu5EJKF7tjcbtIrM9Xmnm2Emkfkrndl88sD
         ohCYsAvzfSymhj5UfM76IuOFpYxBF0ZAd1oHRE5yvKVFSFmAITFAZjjUKVuC8vRIbKha
         fL6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8EuwC8phvgWXkTL39BNyZjwB0VL3E7kxrHoBBjherbENNdc+zJ/3Yjj7OCdoYlfEN1JrASP9OagiF/BZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGxx88aOeFVQUnC8RlpDrL6eBo7Xosu6OG3dLz6D2v37j4pCwH
	XdU5pEJ/6YkvoQXdrYboeCJRsO3wzbht3HA214D0CViEEBb0wDw4nbLV
X-Gm-Gg: Acq92OFdFkUbExP5HeLJSIUNHXDTe0UYLPGmKOVg5bQ8Tg8sxRlGLfVvKqKS5m9VirQ
	BrDHsk9wY+GuZq0HJvxoe2Pi48zl9TiJPThfTJ8sov+7DFUcTq6m3GJ2JtGBg0zz+2ydWuLxxsD
	zevH7vyI3ErT/rp8GHz7nsrC56zpTZ/R3UtcAHV1fI3yrwZV05gq7vLqk2CSgq9WsCYa8bjZQnW
	Rq6osiQmRqlOQMIRYznJ25WSVtkugiHnDx93AIYrSE0edgunEFEt/k6LApZG92KSf58W1LToEyb
	5AefmWeNWidOXxi79iNSHzQG2Mu+acnUu2KQt8XUrN9vJuHndub6i7peNnMHkkBLhSR+mNseY5y
	mZdk5OYTegn7YO2tj7JxTkgxXaRg59z5a1u/tC1c8dV+WoLBVjWenTpuEztlWiwtpXkPEIQViLK
	6JHFnoEMRnlySNhipAwaqpQKC//ST4WD5Wa7AVfLTvc+e2pPzwlr6bHOdCstqXTHMlfrfrJ+3/a
	F+DCsKFOPzK/6X+iElfxlc=
X-Received: by 2002:a05:600c:1396:b0:490:c032:ae92 with SMTP id 5b1f17b1804b1-4922ffc87c1mr485005e9.33.1781543419402;
        Mon, 15 Jun 2026 10:10:19 -0700 (PDT)
Received: from 192.168.1.39 ([105.157.86.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa467b7sm7783725e9.5.2026.06.15.10.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 10:10:14 -0700 (PDT)
From: Jad Keskes <inasj268@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexander Clouter <alex@digriz.org.uk>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jad Keskes <inasj268@gmail.com>
Subject: [PATCH] hw_random: timeriomem-rng: add configurable read width and data mask
Date: Mon, 15 Jun 2026 18:09:22 +0100
Message-ID: <20260615170922.1132642-1-inasj268@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TODO for supporting read sizes other than 32 bits and masking has
been sitting in this driver since 2009.  Implement it.

Add width (8, 16, or 32 bits) and mask properties to the platform data
and device tree bindings.  The read loop dispatches on width using
readb/readw/readl so a configured 8-bit access doesn't trigger a bus
error on hardware that rejects 32-bit reads to that address.  The mask
is ANDed with the value before storing.

These are platform properties, not runtime policy -- width depends on
SoC integration, mask reflects which output bits carry entropy.

The alignment check in probe is updated to verify the resource is
aligned to the configured width instead of hardcoding 4-byte alignment.

Signed-off-by: Jad Keskes <inasj268@gmail.com>
---
 .../bindings/rng/timeriomem-rng.yaml          | 76 ++++++++++++++++++
 drivers/char/hw_random/timeriomem-rng.c       | 78 +++++++++++++++----
 include/linux/timeriomem-rng.h                | 12 +++
 3 files changed, 153 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/timeriomem-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/timeriomem-rng.yaml b/Documentation/devicetree/bindings/rng/timeriomem-rng.yaml
new file mode 100644
index 000000000000..0d8460e9f916
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/timeriomem-rng.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/timeriomem-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Timer IOMEM Hardware Random Number Generator
+
+description: |
+  This binding covers platforms that have a single IO memory address which
+  provides periodic random data.  The driver reads from the address at a
+  fixed interval, returning a configurable-width value masked to the desired
+  bits.
+
+maintainers:
+  - Alexander Clouter <alex@digriz.org.uk>
+
+properties:
+  compatible:
+    enum:
+      - timeriomem_rng
+
+  reg:
+    maxItems: 1
+
+  period:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Interval in microseconds between reads.  New random data is expected to
+      be available at this rate.
+
+  quality:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0
+    description:
+      Estimated entropy per 1024 bits of data, in the same scale as the
+      kernel's hwrng core (0-1024).
+
+  width:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 32
+    enum: [8, 16, 32]
+    description:
+      Access width in bits.  Determines whether the read is performed as
+      an 8-bit, 16-bit, or 32-bit bus access.
+
+  mask:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0xFFFFFFFF
+    description:
+      Mask applied to the value read from the register.  Bits set to 0 in
+      the mask are cleared in the output data.  Default (no mask) passes
+      all bits through.
+
+required:
+  - compatible
+  - reg
+  - period
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@f0001000 {
+        compatible = "timeriomem_rng";
+        reg = <0xf0001000 0x4>;
+        period = <100000>;
+    };
+
+    rng@f0002000 {
+        compatible = "timeriomem_rng";
+        reg = <0xf0002000 0x1>;
+        period = <50000>;
+        width = <8>;
+        mask = <0xFF>;
+    };
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index e61f06393209..930898852147 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -14,7 +14,9 @@
  *   has to do is provide the address and 'wait time' that new data becomes
  *   available.
  *
- * TODO: add support for reading sizes other than 32bits and masking
+ * The read width (8, 16, or 32 bits) and an optional data mask can be
+ * configured through platform data or device tree properties.  Default is
+ * 32-bit reads with no mask.
  */
 
 #include <linux/completion.h>
@@ -34,6 +36,8 @@ struct timeriomem_rng_private {
 	void __iomem		*io_base;
 	ktime_t			period;
 	unsigned int		present:1;
+	unsigned int		width;
+	u32			mask;
 
 	struct hrtimer		timer;
 	struct completion	completion;
@@ -48,6 +52,7 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 		container_of(hwrng, struct timeriomem_rng_private, rng_ops);
 	int retval = 0;
 	int period_us = ktime_to_us(priv->period);
+	int chunk = priv->width / 8;
 
 	/*
 	 * There may not have been enough time for new data to be generated
@@ -71,11 +76,28 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 			usleep_range(period_us,
 					period_us + max(1, period_us / 100));
 
-		*(u32 *)data = readl(priv->io_base);
-		retval += sizeof(u32);
-		data += sizeof(u32);
-		max -= sizeof(u32);
-	} while (wait && max > sizeof(u32));
+		switch (priv->width) {
+		case 8: {
+			u8 val = readb(priv->io_base) & priv->mask;
+			*(u8 *)data = val;
+			break;
+		}
+		case 16: {
+			u16 val = readw(priv->io_base) & priv->mask;
+			*(u16 *)data = val;
+			break;
+		}
+		case 32: {
+			u32 val = readl(priv->io_base) & priv->mask;
+			*(u32 *)data = val;
+			break;
+		}
+		}
+
+		retval += chunk;
+		data += chunk;
+		max -= chunk;
+	} while (wait && max > chunk);
 
 	/*
 	 * Block any new callers until the RNG has had time to generate new
@@ -125,11 +147,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->io_base))
 		return PTR_ERR(priv->io_base);
 
-	if (res->start % 4 != 0 || resource_size(res) < 4) {
-		dev_err(&pdev->dev,
-			"address must be at least four bytes wide and 32-bit aligned\n");
-		return -EINVAL;
-	}
+	priv->width = 32;
+	priv->mask = 0xFFFFFFFF;
 
 	if (pdev->dev.of_node) {
 		int i;
@@ -145,9 +164,42 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		if (!of_property_read_u32(pdev->dev.of_node,
 						"quality", &i))
 			priv->rng_ops.quality = i;
+
+		of_property_read_u32(pdev->dev.of_node,
+				     "width", &priv->width);
+		of_property_read_u32(pdev->dev.of_node,
+				     "mask", &priv->mask);
 	} else {
 		period = pdata->period;
 		priv->rng_ops.quality = pdata->quality;
+
+		if (pdata->width_set)
+			priv->width = pdata->width;
+		if (pdata->mask_set)
+			priv->mask = pdata->mask;
+	}
+
+	if (priv->width == 0)
+		priv->width = 32;
+
+	switch (priv->width) {
+	case 8:
+	case 16:
+	case 32:
+		break;
+	default:
+		dev_err(&pdev->dev, "invalid width %u, must be 8, 16, or 32\n",
+			priv->width);
+		return -EINVAL;
+	}
+
+	if (res->start % (priv->width / 8) != 0 ||
+	    resource_size(res) < priv->width / 8) {
+		dev_err(&pdev->dev,
+			"address must be at least %u-bit aligned (%u byte%s)\n",
+			priv->width, priv->width / 8,
+			priv->width / 8 > 1 ? "s" : "");
+		return -EINVAL;
 	}
 
 	priv->period = us_to_ktime(period);
@@ -167,8 +219,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
-			priv->io_base, period);
+	dev_info(&pdev->dev, "%ubit from %p @ %dus\n",
+		 priv->width, priv->io_base, period);
 
 	return 0;
 }
diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
index 672df7fbf6c1..b4202ad2f507 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -16,6 +16,18 @@ struct timeriomem_rng_data {
 
 	/* bits of entropy per 1024 bits read */
 	unsigned int		quality;
+
+	/* read width (8, 16, or 32), 0 means 32 */
+	unsigned int		width;
+
+	/* set to true if width is explicitly provided */
+	bool			width_set;
+
+	/* mask applied to raw read value */
+	u32			mask;
+
+	/* set to true if mask is explicitly provided */
+	bool			mask_set;
 };
 
 #endif /* _LINUX_TIMERIOMEM_RNG_H */
-- 
2.54.0

