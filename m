Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB7314A65
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 11:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781696817; cv=none; b=lL2Ubd70uwyzIr8uy6AIPINRlR6l1OsXFhWw6Uo8zvGtYwhQwAmCUuaOFLo2gu7PiZv3PETEQNLS3zW99qpFmvGNKDCyAAJi86+82eWIoapYuqf/lBnWJqp6ehziVGXKcdBxfwKrMFPJecnt0fg/X4hGJ4uCFLv2UATBoRlkt1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781696817; c=relaxed/simple;
	bh=0X7i2KUBJWNqMEcdWRUJvZ6mZ/oWjbbd8I5nakizUHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jao3NIQypsgsv0GOY1bkxdKAb5LUcX5wV2XB1ZGVvF12dp01/qcK8CDtETN3/gOcwPMpDVviN9dOpJl0rXkVD/R712RL3tiqOta1egrX553Fiw5/cYJgYnPVjwfSa+0NJ/6dS2ZRJMBwDPgJE7bKy4IWa4mLDrg6KLeSwvg4nXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQgNy2MA; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQgNy2MA"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4629d80fa08so618627f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 04:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781696814; x=1782301614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1xUbc08OXQwXD0H7YUvkinrceXsCq3vVphz8033T20=;
        b=MQgNy2MAE+0vCqlZg/iP3tr7HRbBAt4XWHzWfePtoV3q+HWVWAinIF2i6ICLAJiXSh
         qxGXofukYn8vKIlL4dXrN1PE5+STubqLYzzakaHLsEbl2yf5/PjB+K1GMSljMhzwvuse
         /iS+Wric5wZ2h0jjHS2rnd8WrWzzHGcWiJBLx7QhsedOt1N+5oqk1iAMqu+C4JSLUSVz
         aS2I3iX2fRHK6e5W9dqqZipE1FSwu/+QLe9S+toyxHkKDF7SjUoAm/4W/7jEW40m2vfs
         eY/MOXGllax/2tclPfoeyNIjwDFocfDCxBQV4lA4fqFWHnhK+saOIirhfOkM3xVON88F
         7foA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781696814; x=1782301614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T1xUbc08OXQwXD0H7YUvkinrceXsCq3vVphz8033T20=;
        b=lPS/5LhUSB3larFNbHo0FSsCWKN7yf14T81HfVHSD2gN4NX79DyRXsV4Sxkniks5Oq
         ZRug0hMZJMn8i/m9YP9sIN9woeR/2mAMb6aYCatrBXPvBQbKxgIYum3J8uTL6bh2Op5N
         j1CspH18riDOvzJ/TxBLnVSi1ZQTy/02JZMk7qHFeKK57ZlgJP9ya/e5vJvjJCWPF0lT
         2NyVkQhRLvPS8uCzEhq/R3Sopq1ogZiIbw55xoOmHh3uPeBg4xoYrcSrJ16UnwBCzsmc
         s5eE63KQfEtkIt6DbUJcG/LzgYlkHHIr8vIS/OkOBa2Tolog//sfsc9Yuc/uLxHvzJIF
         kTng==
X-Forwarded-Encrypted: i=1; AFNElJ8scLhesWGiR5wzQ/t2RO+rV+wnxEBgvDZhZPYRm90BqM/hP0JfmhE3NGDyU6mEcflPdlSL9BVYmHQj+c4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyADrme7LWV760AUrpP5Ga9hq5DZfqi0P0/7o34TPwbfPZq7V0Z
	dXw2EJq3fu6nEQbyS5hDu0we1nZoEpgrU3/X9aD1ucRoJvI26rhda9hr
X-Gm-Gg: AfdE7cnsV4HoZr5U1r3yE7GvVoYZkCiLL/lAz05Ab+KyxfizsKddbrXW/tpKeP/XFef
	eS6WkmWDyoiX7UjyOQbmV6GfQlgNWx+OMOvQr2mGxuyYv3JJv3VTtEOF3Q+Bur66o0fVmEP1Od/
	XE1tA08OkHVXR5J6hqITwKudCihyfZYFiCXi81u8KNe7t6h+vClrzhF6XYnWElMa/4O57bu0P0m
	TaZj7VT4PlIp5LRvIrRic8bw9wQXisuAHwlxauYh4UnBYKhIRl17SWnRa3Y69vm7ch5CHITDrRq
	UxA7+YZWR9Hl1YU7VM1UIibs1p/9a9WhSC4VDX3ltWA4DMfZ4La4QaGVZaDwfa+sYlFbLrNwqg5
	j+OeQDRF/d36tDKywdTxgmPoVIlf228Jy7cCuqn/mOI21x7Y6caAV7rl+Pp1hcM7kcz5r/f5Yap
	71iOHml/dlEV8oFbIOVWrHv50aPc/q+a5TehDLMEfTcn4RljXwt8r8V0BHwzCKnQU=
X-Received: by 2002:a5d:5d81:0:b0:441:1e41:194 with SMTP id ffacd0b85a97d-46236ef6b36mr6601847f8f.17.1781696814071;
        Wed, 17 Jun 2026 04:46:54 -0700 (PDT)
Received: from fedora ([196.77.26.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-462e7fc53fasm3221857f8f.33.2026.06.17.04.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 04:46:53 -0700 (PDT)
From: Jad Keskes <inasj268@gmail.com>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexander Clouter <alex@digriz.org.uk>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jad Keskes <inasj268@gmail.com>
Subject: [PATCH v4 2/2] hw_random: timeriomem-rng: add configurable read width and data mask
Date: Wed, 17 Jun 2026 12:46:42 +0100
Message-ID: <20260617114642.1911191-1-inasj268@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260617114436.1909659-1-inasj268@gmail.com>
References: <20260617114436.1909659-1-inasj268@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TODO for supporting read sizes other than 32 bits and masking has
been sitting in this driver since 2009.  Implement it.

Add reg-io-width (1, 2, or 4 bytes) and mask support.  The read loop
dispatches on width using readb/readw/readl so a configured 1-byte
access doesn't trigger a bus error on hardware that rejects 32-bit
reads to that address.  The mask is ANDed with the value before storing.

These are platform properties, not runtime policy -- width depends on
SoC integration, mask reflects which output bits carry entropy.

The alignment check in probe is updated to verify the resource is
aligned to the configured width instead of hardcoding 4-byte alignment.

Signed-off-by: Jad Keskes <inasj268@gmail.com>
---
 drivers/char/hw_random/timeriomem-rng.c | 77 ++++++++++++++++++++-----
 include/linux/timeriomem-rng.h          | 12 ++++
 2 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index e61f06393209..42393409f22a 100644
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
+	unsigned int		reg_io_width;
+	u32			mask;
 
 	struct hrtimer		timer;
 	struct completion	completion;
@@ -48,6 +52,7 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 		container_of(hwrng, struct timeriomem_rng_private, rng_ops);
 	int retval = 0;
 	int period_us = ktime_to_us(priv->period);
+	int chunk = priv->reg_io_width;
 
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
+		switch (priv->reg_io_width) {
+		case 1: {
+			u8 val = readb(priv->io_base) & priv->mask;
+			*(u8 *)data = val;
+			break;
+		}
+		case 2: {
+			u16 val = readw(priv->io_base) & priv->mask;
+			*(u16 *)data = val;
+			break;
+		}
+		case 4: {
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
+	priv->reg_io_width = 4;
+	priv->mask = 0xFFFFFFFF;
 
 	if (pdev->dev.of_node) {
 		int i;
@@ -145,9 +164,41 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		if (!of_property_read_u32(pdev->dev.of_node,
 						"quality", &i))
 			priv->rng_ops.quality = i;
+
+		of_property_read_u32(pdev->dev.of_node,
+				     "reg-io-width", &priv->reg_io_width);
+		of_property_read_u32(pdev->dev.of_node,
+				     "mask", &priv->mask);
 	} else {
 		period = pdata->period;
 		priv->rng_ops.quality = pdata->quality;
+
+		if (pdata->reg_io_width_set)
+			priv->reg_io_width = pdata->reg_io_width;
+		if (pdata->mask_set)
+			priv->mask = pdata->mask;
+	}
+
+	if (priv->reg_io_width == 0)
+		priv->reg_io_width = 4;
+
+	switch (priv->reg_io_width) {
+	case 1:
+	case 2:
+	case 4:
+		break;
+	default:
+		dev_err(&pdev->dev, "invalid reg-io-width %u, must be 1, 2, or 4\n",
+			priv->reg_io_width);
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(res->start, priv->reg_io_width) ||
+	    resource_size(res) < priv->reg_io_width) {
+		dev_err(&pdev->dev,
+			"address must be %u-byte aligned\n",
+			priv->reg_io_width);
+		return -EINVAL;
 	}
 
 	priv->period = us_to_ktime(period);
@@ -167,8 +218,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
-			priv->io_base, period);
+	dev_info(&pdev->dev, "%u-byte from %p @ %dus\n",
+		 priv->reg_io_width, priv->io_base, period);
 
 	return 0;
 }
diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
index 672df7fbf6c1..5732489a17a1 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -16,6 +16,18 @@ struct timeriomem_rng_data {
 
 	/* bits of entropy per 1024 bits read */
 	unsigned int		quality;
+
+	/* read width (1, 2, or 4 bytes), 0 means 4 */
+	unsigned int		reg_io_width;
+
+	/* set to true if reg-io-width is explicitly provided */
+	bool			reg_io_width_set;
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

