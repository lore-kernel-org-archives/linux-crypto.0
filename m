Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8E5254867;
	Thu, 19 Jun 2025 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335864; cv=none; b=FDnnMzMVNqo5F5jkdZLal87Pm/P3G/lZOF524vMF01SkwVcrR78HtCPAM+vBzvBwFm7emLC1Kw9kHaNrnfscwlQsRArTnrewo1ahpGnhknGtU9fnpvTIhefftLUtwApfJMc2iz0EZfcG3QzZFt5Ci4Lm7g+CVkG9NHtJFtuoNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335864; c=relaxed/simple;
	bh=dsS+p6UvQk8Xwg+WgyOGAas3d5MTBbJN2FAK8gI6CFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPG44GknfSAck2uKo2coyyN9b+ZN5DNHC9LKD0ARYuTX7YjGU95RLys0nSfSAKwaNop4/F6pkjl27QxFzVByPfU1RFRs8GIOcxlZMBCBZIG2G0alCSBW0oheGV2NfAu+BOzjqh+gU+f2PksvYGAvExnAguSXPlssWV6C3J/WDIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WyUAnXSZ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WyUAnXSZ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-addda47ebeaso145465766b.1;
        Thu, 19 Jun 2025 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335861; x=1750940661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=579Q1QhHC2sKl8ad1uJdu4XVU+r2uSj185NnGxhlUu0=;
        b=WyUAnXSZuMRt6wM/um1tG1kIb3Nd1D4JR19GnVZqLxNit722wN+RAymOleqnE0mmTT
         gk7/uhZyZh8mt1EB4k9ARP3JVg1HX2IQXM1gJANpQCQpmY0zzAk2jg15U7itX1klrX9v
         kCjiklV3YfFk8Lu9zeONlAw9CuA9+qvlIUU06DJkYxY64WSD4NA3zEK+z2Ot+h/CK2cx
         aXDvWYWv/KuIvFpHsMEpnJB4ud2aO6gahhtSx6KfzR1wjaJ0n54TU0u68+csQT3ITDxZ
         D8KPq8fJu3p0/WyMHYDBPsD8Tq1s3MqubG40KuQt5/67d3nTjc1dSQkQC0bwQmA7HQ4d
         gO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335861; x=1750940661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=579Q1QhHC2sKl8ad1uJdu4XVU+r2uSj185NnGxhlUu0=;
        b=FhgfcKY6Q9VH6Qw87I+iTi/C8FIcetPm4nFP7+AFu+1EVXfQD2itWOcR1XKFihmz5Z
         qq4e23N9UPisio+dGNJeciV5NdNl68gbDpYySHB5Lu/GMxGFprjrT9XC+tZ7F5wRNsXj
         ig7R2z14cLoQbMmxrN4ryK6zoDCVc/Y9nbnNPznZAI4gZ0FCurxS7U9ufhyFLzgP/0C0
         B6CLDYtN5iYqm2lEpUhlbbthPqLgLhsXt0aKJO6KfFE30uxzUJ2fTTbaNKbQr/4HJY+T
         2sB9el1TPHdvlfI9PH0RjWmLfXgx34Bd+46HBABZ5zpL8YFptjx+nvyOuP0arHyMzpIq
         wP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNZt7wV/PgcJUVvxeS14LM6IUPbhhnI3QPatPxaWY+TvYB+FV3walrjb+j4oCE+pGcx/CulxiZpfmjkDM=@vger.kernel.org, AJvYcCWALTm4RSaMJsGjX4yWshB7PWei/XG3flfJu1ozxTxXvQYIJPRcl3/3R6d5KZvslgbgn+hqMAD50TiU4+xO@vger.kernel.org
X-Gm-Message-State: AOJu0YzpcwvJlnkHP15Oj1RVGv5ociyYKLKcBUv0WfmNUD4SK903e+D9
	g93Al1QQVWcHUanc+zXh0TrmyTzxVn5AeXxp20sHfTKtEhkUb5w5LWNA
X-Gm-Gg: ASbGnctQSlggsD/Ihyz7Fwl6kCy1yQFo5QG/RED2uy/eiCnN58g4dNPa+SUud2eDvci
	2jY/j6fyAfkDQiR/4zbuWhGmdJlCos2hd5m6DE06aFn1XKJwWDmbGDc++0QFi68lDneUDPcq5wd
	vOIvFgLwm60HfM7qv9br/d0jG5HqzOZIcRi2fd3MXaKDCHu7QwgV1+EVV++r+7cizjGzYpKa6B3
	ugG2kj8z3w3aDpgT90+98t+GZ/hRz5Hibb+09AqtqRNdYYR0ANCYF6AStXUwbVUhXxMA/WjUmb7
	fw28/WneoU0aICWhwU9c2vUvY/sW5o3QRpeMvEpf8y2ioYBjWVu/5cKpdQbBPgni8yxNQrhSqPm
	zlWmXKV5dVimveg==
X-Google-Smtp-Source: AGHT+IHH6DFXlW3XSv30gN9W1MaxFbV4Xi7gLnQBbzesKqNPz0MrTZ8hdE2KCDgVxH4xeRlqT8acsw==
X-Received: by 2002:a17:907:9694:b0:ad5:4a43:5ae8 with SMTP id a640c23a62f3a-adfad31cd15mr2245682266b.12.1750335860965;
        Thu, 19 Jun 2025 05:24:20 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:20 -0700 (PDT)
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
Subject: [PATCH 09/10] crypto: sun8i-ce - add a new function for dumping task descriptors
Date: Thu, 19 Jun 2025 15:23:15 +0300
Message-ID: <20250619122316.2587236-10-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
References: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to remove code duplication, factor out task descriptor dumping to
a new function sun8i_ce_dump_task_descriptors().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c    | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 930a6579d853..b6cfc6758a5a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -169,6 +169,12 @@ static const struct ce_variant ce_r40_variant = {
 	.trng = CE_ID_NOTSUPP,
 };
 
+static void sun8i_ce_dump_task_descriptors(struct sun8i_ce_flow *chan)
+{
+	print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
+		       chan->tl, sizeof(struct ce_task), false);
+}
+
 /*
  * sun8i_ce_get_engine_number() get the next channel slot
  * This is a simple round-robin way of getting the next channel
@@ -183,7 +189,6 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 {
 	u32 v;
 	int err = 0;
-	struct ce_task *cet = ce->chanlist[flow].tl;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	ce->chanlist[flow].stat_req++;
@@ -225,9 +230,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 		/* Sadly, the error bit is not per flow */
 		if (v) {
 			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
+			sun8i_ce_dump_task_descriptors(&ce->chanlist[flow]);
 			err = -EFAULT;
-			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
-				       cet, sizeof(struct ce_task), false);
 		}
 		if (v & CE_ERR_ALGO_NOTSUP)
 			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
@@ -244,9 +248,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 		v &= 0xF;
 		if (v) {
 			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
+			sun8i_ce_dump_task_descriptors(&ce->chanlist[flow]);
 			err = -EFAULT;
-			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
-				       cet, sizeof(struct ce_task), false);
 		}
 		if (v & CE_ERR_ALGO_NOTSUP)
 			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
@@ -260,9 +263,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 		v &= 0xFF;
 		if (v) {
 			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
+			sun8i_ce_dump_task_descriptors(&ce->chanlist[flow]);
 			err = -EFAULT;
-			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
-				       cet, sizeof(struct ce_task), false);
 		}
 		if (v & CE_ERR_ALGO_NOTSUP)
 			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
-- 
2.49.0

