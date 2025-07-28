Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C73224896;
	Mon, 28 Jul 2025 06:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682882; cv=none; b=WHr1lyFeW+O7r4WCT4r84OO1JsNBNZLcWOMMFUDW4ikCGQ+vLtWpb8aBKY5fiy4Txc9l85f5I9GxHJlCVnAuyxI1iEulnuLKseQJDPrcMHas3nCRtNEXErLv1XFjS/mP6I/QywiLgy+BYCbDRGyblMRXEO9q7EH84cFkutx8RNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682882; c=relaxed/simple;
	bh=b3yfadSxlQTuuUjecZzGWQXT1ppEt7Mr1bmdx41N2Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPVrt7a6zJkt+WxNoLpSXOHaS9WJ4T/4XHQlzCvdZYLI9L+pgAlTvUjSVTOielcRzfz+LOvMr+gtp6b6GO7rwqJytzZtRG+PmvyQKH/sv4/KNsZeskem5xvoWrknzd2avb+MOt7YNDAKZzX+JoHjmtWulquHoisur3HldaySOr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBYQyu/b; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBYQyu/b"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-451d3f72391so37785145e9.3;
        Sun, 27 Jul 2025 23:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682879; x=1754287679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJtO1nuKB/731gs+IWxyxQBo+tSaie/TO/30jHleAGw=;
        b=MBYQyu/bqp7TAna6nI9G0OnOZ2s81LZqkaHu6ZMJ4p+Vuf8scFcSqDUoH5dMW9clS1
         hwPiImKz+uBd8rNr9qcJoOOYLfj3UFpq7rHPXUxvsT50iYFaeY6MYNsmZ6XpxIHOQnCZ
         Chz10e34Ty9pP49aa7+9D7d7DxpMaLCqSgh/A1XTwzcmeTay3Kiq/ykN1auhX0kWqyFA
         GE7VSuZJcgt8QpIoM/x6EkhBCGCj+KVgrdelrN7Gfr/LDHuENyHqEgqFGQCuykQvJXee
         bq4tqo/WK+JxMpz617tjUC836wL0Y633O20TsZSglVR9tN8OhOBx2yR1D7QU1KMJNm/w
         2hsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682879; x=1754287679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJtO1nuKB/731gs+IWxyxQBo+tSaie/TO/30jHleAGw=;
        b=TBhgfmD3YBe0up9XnI+dtjDCr2pIQ81iN9WYWgiBEvk8Az39igrsTdWgkpzEca3Q8Q
         YeeltbnuSAzJpB6Qn1r+KU+Vv1E97XKRMQcZ74X02TKWA3pa/FFocFAge9YSPNdtfnwv
         pHJZkkoXlzmX2FPLRAas/M5DJyW7mQkMUHB8k+G7dQvUA3OxHjD7tMQkUpaKJ4OaYBMm
         bIky8etN/+MmxAuH7twrRmV2MCcRO9XO1GQD1Ua35g7vobACOz3SgIy+hUOFu6k4GV43
         XLDcKbFZz+JFc1tSwZJ6L8p3N2VrzZNwCqoYiHGGffKvdhji70q0xoWss3TcC/isXue2
         EdXg==
X-Forwarded-Encrypted: i=1; AJvYcCU9/Pamz81o3FT5bgDV29WfoEf8/E//B+/rXllXziOZaDYyK0J/URxaicsCzcsQCx4wdhltWSRjmVZ0okU=@vger.kernel.org, AJvYcCXj5Yz991y1eQqizhJvWCjTk5XH9qv/nLbn9odYoPqdhCIQDb5q8ZvP0jmk0aJ+ct8tsUDYyhuSHYHmatgK@vger.kernel.org
X-Gm-Message-State: AOJu0Yydagn+K3b6QRQ0C6xSkb2NU6C70aG65Nk7kreD2L8v1sEgqxoq
	/bbgRKpQwo+05LP5zsajIZwoYjmqKyMWzKNwYLMEIn+9bQHPG8hzpIHKSvU5Lg==
X-Gm-Gg: ASbGncv3cioIVQcrVyBHuA8d5zzW2V5RJOmiXGOQ4tBMuYzIeiuk6E7sK3rs359LKuy
	JcKCuAcpmgE+hSE4TXy2Go3Ruy7TNpD4SnHNkS3+i+JLEXdaSiu/I64oQi5FOiSpXl3rOJ7W6Wn
	Or0RFtpxqkPqzogcvEeC/kNFw+uQ5b4t/hR1W1NiEXlhtZcvmPykTIB8IbDHYsbjqWv/YJINLVA
	CYp+PNlczdWAQjYN6uMu+4T8NP4UBsDShsJ01STDv5BjjDSI0k4Q7HRlB5sBI6SFikFsw37mFBb
	XKyhyo2nWx/iLJ5ZwNJfMDShyx3plw9Kbyaj6rfUZdqTyE0QEsRC2351S0oBb8yCncNYmDIxiz5
	HzqRhUJBB+nC1+hJbSUtheVifYm4L/4Ga+JjAU0vPDWhV
X-Google-Smtp-Source: AGHT+IHcuqZDSycBlmjS65wGUlNSERplHlPi6V2vucApJV8xzGnmPFaJnpc/De5ZHaB9MzmHrkvGag==
X-Received: by 2002:a05:600c:4590:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-4587643ec92mr86897145e9.18.1753682879129;
        Sun, 27 Jul 2025 23:07:59 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:07:58 -0700 (PDT)
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
Subject: [PATCH 4/9] crypto: sun8i-ce - add a new function for dumping task descriptors
Date: Mon, 28 Jul 2025 09:06:56 +0300
Message-ID: <20250728060701.1787607-5-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
References: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
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
index 326d9c988bb1..d94304a439d3 100644
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

