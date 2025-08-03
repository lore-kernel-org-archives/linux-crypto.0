Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE461FDA92;
	Sun,  3 Aug 2025 19:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248270; cv=none; b=YL9kvgz2AGLzX2CTI63wQKCQir8zqCyFZJHgptBmmyzOipKEwG8gwG+YkR1XYAEor+HDZ1u7ed+05KHlnm16qhp2KqDUeFOMrAG7G/VWViboTHTF5hkHc4M9z2fVyR4geVQCEgilDBCgx+w13Opc6U78vHHysIfFzTf5AcpdztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248270; c=relaxed/simple;
	bh=NuYFEKMaNu1hQjN2Md5xNm1r7h0CNUWlhKkPh3zc5MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG3k9PCxwy+AzPXqipsP8plMlvDUEmCTvaZZeG3IO8edgfbE7fhdL34olymH2zc7VdekULKS8dIwfu3VK2azG0doY7tO3vOvuOf3TDC9ystB8cPVBqHIHXwOrZwXSKd68gidUt0nv3dBifjcoiRyiR0wGN6V6Tw5ryBQ+wlxFu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0wVtLdJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0wVtLdJ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-458bece40fcso5525005e9.3;
        Sun, 03 Aug 2025 12:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248267; x=1754853067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qolo47kLruRZDje5v7puvJiYv8DgcRb8St2Hs5XCLlg=;
        b=J0wVtLdJGMPvfZ7XNeWwSdv22DkHtZD7ybiModzFB3TIPDmhuWLJNcCBNX7FNLhSiy
         +ddzXLSvm9bjHXeb+6T3A7RSlA+5RrNArGDPUxNIOPCGAIdvtu0kaiV46WXZhe75l9Ve
         wjp0RF0GQS1Hc5cffmN4RsdGVgy6fQZin/ABEphZ2S3+QSWxMk3EAdnGiTcuAFAVTD0v
         iBfrs7ncA71gXXEdWUSI1RSLQzBdgzXoEAG3J2omwCEF7kXmRWtLem/MgGYv2X4Xj0lQ
         lgTY2rFW11JvIL2XDnlmFfd/2j/Nqs4Kfrc4OW1a6JL2eSjtZYY/6ZzLrWH9UFG3XYvg
         6Trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248267; x=1754853067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qolo47kLruRZDje5v7puvJiYv8DgcRb8St2Hs5XCLlg=;
        b=tm/fAe401DG5W9BsLstKWhIXSRcrVVmbKppX/5q4KL+7jxbQ2zays7UZgdneLvC148
         tZTH7vjPEU3UBTLcjp45hDX1ZzIVr0dJvmnUrVHLU8LCSwdRsAA+zYe2inGT2v88XltS
         ybZ+IEPfbnluG4at/+pllrKNUuwKF3fIPWFFD7OX1EliDWreH1m95AyY5luMZ+i4zjAM
         52ZvBmdHZBHTPw/sxRo/yYunbM4tKsseCcfNMZhFV5HkVQ3HexFc/p7K0BukocqEHw88
         m2ZEgv76WWwAPjTfHjs9UTrmUP5kQmxtkX9d+dfHBn6Edu0Wn46g6ocp7ilyouFOaqP7
         wOZg==
X-Forwarded-Encrypted: i=1; AJvYcCW0Rq6nwX4nHuXu9C1tTEjO2ddC09ZIRjkuzHie4tKGGReG2qojJrA5cvD9gNn5syoLkdsEF19p4SXrWdg=@vger.kernel.org, AJvYcCWYZxaQkYA8q0npddNY46SpbKDZ5cAVAdCLRXFbct8Pq4n1+l+jAGiYdpigjsvetIh4P/x5/OUwG0T+K2sL@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8KsKxcq8HpULZ6nwN3LdOJdi/wvt2AAE84yH83WwJT+MDPEUP
	ZHEjGS+2VzlBds9snfc8Gxrg6vIWN5AwmDY7TX1H3tpDrORiAfBwZ6ep
X-Gm-Gg: ASbGncsN2NfdTqqaLJuGpKU85YbsGSIBBnWCPw5iXFa308R1wqDRW2ddrYulQLQQMS5
	ro0CzcyEw99pbaqy5f4CJDaYF7UO6e4AQo4whphBOILes1AfZDK8phRFl8YA6rYubyN4Lv2Iwb6
	VyNXWYh3fxgfPwugxTDLYn4c7mug+8nExoipYh2a87aVue8cP0wx4sicSm0W6Yk77q2SV/jXK4a
	eP2A0WcV4O0UVHrUFTB7x4eg7dy2B2NjZusk7Az5GzVayMbFxm+HpG+Na7rTaHiKjBpKEtybT7U
	Nd/Psan9tX1ZhAQFjEPSTbidDlccMUyXYKBn82elTJF3+deoJAF3P66e0fGGzYB8QY9zbU+MMwp
	fvbqLac583ckXqzcPG+HuLMTP/0II4cdnXw==
X-Google-Smtp-Source: AGHT+IHJPGckbzUmSSL2cgE0cCZx9wW/o8POt8Pcz8H/fgdDIEL5DMDINIkmWcO6ymEP+suWYNdLTw==
X-Received: by 2002:a05:600c:4692:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-458b69dd831mr46823935e9.13.1754248266873;
        Sun, 03 Aug 2025 12:11:06 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:06 -0700 (PDT)
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
Subject: [PATCH v2 4/9] crypto: sun8i-ce - add a new function for dumping task descriptors
Date: Sun,  3 Aug 2025 22:10:24 +0300
Message-ID: <20250803191029.3592987-5-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
References: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
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
index ba30859e749c..b7093fbb8e9d 100644
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
2.50.0

