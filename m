Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DE02750FB
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 11:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695626; cv=none; b=ESSIp+i865cd9aFHKKTpDxVjRsW2PDP55+iPyrGNKQGx9WD8uyF85++GOMMt4dkkIg2ZN+e/m7+65AY1jCp8ANDJPsZJbZRK62VFsWtCK+v85qA+u3yGTfPHIUuJNt0kueVmSsLTP+HGJU/JPe9xVk+bKaIisOYEZpb4wso/KWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695626; c=relaxed/simple;
	bh=Qu0NdULWjbe5HjOF+DVF/PYQGOZPxEdCiD9DaDW41pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEywR9SakhuydVpNY0A1nGcD0vidu/IuToNoAiqzKyBKyyWueFDUldaKhMQce0GyXGtSgTchYeXrCvL78fA2Ok5K/kUwBmWHlkQNZ8FvohJ4QbmF601G+gJkAdU1NkB9Gp3l96khyku2oCgT2jREGoRgOpyzq5nfS+IsmPEd4KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sOpp0H1s; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOpp0H1s"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4921e4dd62dso6876295e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 04:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781695623; x=1782300423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6dcFt3Ouz43mydiNqOzalCb19OSb2vzeWjSnutao5A=;
        b=sOpp0H1s+ykpx9dAwdZm6WrAJX5Wv/iFRIuDNvuJH5KTO1u+3HiA4mr/1cjQyzqcT9
         ymytPzvEmVqysnuC4+9H0Yl2dHSEgcH6l3bblWaG2+iSkFMDN+sPZmpMlh7mVxEhIy3L
         cOr+KO4jtmFyMQMOSn9LX0q/EA6B0/VXzcmIfulRVaYlXZW9K17MxveTq4VZBpd+G0/Q
         i4Ee7OM36QU48JRQZ9KO5VoNz+WSx7q9BzFdX20uiDgmvXhrFHhjofXvp3wvK3eaTh1X
         9PPB8P/0ppuwMavpyMZQzCw6aWVtEssbYhd9bnO0v9Usy9aVSdJVMbqcr/vnVlVgayxO
         5jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781695623; x=1782300423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6dcFt3Ouz43mydiNqOzalCb19OSb2vzeWjSnutao5A=;
        b=YBkAlsMq3fgpkuTXc0eX5B22L6B3Aum/gZOmX9n30WCmKfcc7qkzwWcwqnxzcXYpI6
         Vpb+EYMRVOdVsLULeQgNIsTuc07NGK2OtUsz5vS6/QDetd61C/o9LR+f9JSsbR6vjg6A
         W+q/P9FXVBDyoBCWpTKfn7ltQZZf8Ef7OIQLnwRIHPjWbkGZgrhRCn0Xjv7NOU0acxuj
         bFe6jMr8+wDWSP+XOs+2060bFrqIRLxZAYYGZDw4MklFEXhJAmcbuDjStJTi9Zkbk+pH
         yUp5YxpBYc0SaXS+NzfyATftMtAe7IU6PDwTbZSbrmlQXIZww3sowKjwdwt63vEm9pel
         4NzQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CDtLDIGFwwKJr2nmJ6SiOrQhT1e4a3IlJ6pW8igWHZeEinG3J82Inh0LQ1zs/g2ep70AiF92eHzp8anQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbD5+Xo5VdfqxHhwFRlqJO7RUMmoah+4GSNj8aVXxieygAQmeS
	+6aCa+Rbbteba4Ek7Kq+EuFX1iAEvuBhklPioxgYZYof7BoJaLW4yWJQ
X-Gm-Gg: Acq92OGNMqjJk7PP0KAnLZBddrhzGyi21SJKsOfh5nQ9bzBYlRYQBKfELbnPwomariq
	6QHcImf+U4GyAU10IywerCtHPm7eWAeiIeRqUUQLDyprVXSF3/0nVYcpC7AkI3fg7fy24uUAjC6
	EKoyQ/mptb3RGeINiD+aaVuwlm/BbaOCgBlGyfTPaSHeccscreb0xzlNSyHocoTKdxmC2QXfTQw
	Bgf/7BZqxXxYMLhuWvMEOEFkgXLK+pBAU6e48UXu11qdC3apeFun6D2+3wfB3eD/U0hq+N0XeXo
	hs1BOFiMLsKwkIlX1PFcbs6fgZEzEibqGnSls/XRJbz1IDaTxQJHORD8rVqbFsNwNUq+8/Wv9II
	sbdQe2oYbbTbP8w7hpR2LmAVOpsyjubuBaKCXeRdUpKibb9us1og17LFCmq7DnQDVzmRUfA6c1U
	/q4BsMhR8PpO7zQR4oYNexmTp41wMH2SVknGqo+q3Wt93DKbuwzArjCOYzcNaPlXQ=
X-Received: by 2002:a05:600c:1e0f:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-492340bc974mr39130605e9.2.1781695622898;
        Wed, 17 Jun 2026 04:27:02 -0700 (PDT)
Received: from fedora ([196.77.26.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a96d14sm138192065e9.12.2026.06.17.04.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 04:27:02 -0700 (PDT)
From: Jad Keskes <inasj268@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Olivia Lu <luolivialean@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Alexander Clouter <alex@digriz.org.uk>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jad Keskes <inasj268@gmail.com>
Subject: [PATCH v3 2/2] hw_random: timeriomem-rng: add configurable read width and data mask
Date: Wed, 17 Jun 2026 12:26:42 +0100
Message-ID: <20260617112642.1897096-2-inasj268@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260617112642.1897096-1-inasj268@gmail.com>
References: <20260617112642.1897096-1-inasj268@gmail.com>
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
 drivers/char/hw_random/timeriomem-rng.c | 78 ++++++++++++++++++++-----
 include/linux/timeriomem-rng.h          | 12 ++++
 2 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index e61f06393209..4557326618c9 100644
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
+	if (!IS_ALIGNED(res->start, priv->width / 8) ||
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

