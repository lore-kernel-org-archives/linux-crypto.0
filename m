Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA932DA745;
	Thu, 26 Jun 2025 09:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931972; cv=none; b=HJPGOaU2nK2gYeoP96jpyMtgZAu0i0qVnWfPLcHe67/YvOgzky2UJlGai5ktdinskV2Fa/Vl8uoEvZAqiGf/ntl1Li/2PYz3B3Hc/cTlQ6r1h9xKMLhpNuFmlmFnZnmfuffNxHpfPkiFjuSxA4dTBm4pqCpVTv4yS0gBfVILAms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931972; c=relaxed/simple;
	bh=dsS+p6UvQk8Xwg+WgyOGAas3d5MTBbJN2FAK8gI6CFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRpgfo9AVBQZuhldoDKNbHA7ugCMdA/Fm/N6cO3AhCCQe40/MREUH0UbjpatBPg8L5l3chx6xgj/6xQbYIzY91YANDr7N5wpP/fdDDK58KkwazQDyFHwFUY/QI0GJifR9P41UcCHv1don6M51POeZH3NwhL3ottn6npINlK1ybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g91ne9IL; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g91ne9IL"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ade58ef47c0so179361266b.1;
        Thu, 26 Jun 2025 02:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931969; x=1751536769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=579Q1QhHC2sKl8ad1uJdu4XVU+r2uSj185NnGxhlUu0=;
        b=g91ne9ILpAvaZpcyYNfZuNZejRBA1uLPPz10V9MT4RQ4uV30Dg/JNfRp/gRv0Eyx26
         IKZKxOZMbhTJATtiAjhKhsMCEQH7/R9o0gHtRQPTPT1eQi4uqmVrv+y0bH/lN/vki3qB
         jGAtsXSMoDOssapuMwrsHzJfVsbiEcyRe1yH7bxteor7jjYlVi9VpFxK4xKD113TOFVD
         KyH/MjAGjeG9p+5NNGduDJplYPiKbDzmNZsPRvxPIKtDp/VS6RfFGNXceLqKbwNbjamy
         xB+OtOjVphnugpXR6nUZv1WMOjgcXGTntrsx8yJYxr7uEts6XMPTR32to/s+XZezRPqV
         AAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931969; x=1751536769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=579Q1QhHC2sKl8ad1uJdu4XVU+r2uSj185NnGxhlUu0=;
        b=q5HGZ05ZkkHdM1/wG/maFnJhzIc3kvkrxJdgJ0Pcr4IvKiTPSsXiN1tgPHhhj/yJKe
         kpjzHYGfAc81P95Jv9EwET2eGb3MZhWWT1c5EILu+SZYbNREVLaSPDB5e7FDf1+wOX4t
         2WVAO81/4hp2U/LCw5H2D6UPkbaL2RxeZw0Y2HljfXk7JhWBCHXOAfFDkGVE6pCnExSo
         I9m0z3Dn7ABkQEsG+1gzY74AN2L3Rn6belsLFoQmBQR7TTMtVwTf8AaavG7C7utDaQfU
         x9P1WswcCAUYRghAU3NgzxgY4QYVSGgE6R5E3gla0hZma+kKpsvTM/8WBeA1JHklEnEv
         BB3g==
X-Forwarded-Encrypted: i=1; AJvYcCVRortVGi9kM8V1+xAk61jEmB5GkVGefMu6WLmbjtcE+DLY2WKlwnXOC2xXk39fZTpYh4Aq0lxEhu+SzAA=@vger.kernel.org, AJvYcCXUyN4iFBr2Imd7TnTakISM0RmPONqm0UWxvVa/i6W6CZMVNvL84qk5X8acW8lu3SQAEnuzt2iAbfY+RcsQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwMXl34DM+NP0QPCu6XFu49ijWHm/NIkIa6IoqluLG1vFjCBk+w
	jU1H/M1qwN6kyM8F77UG5Jv6gEchpgEVJLU/ItB1MCu2LEJncrscr0/xhPywsg==
X-Gm-Gg: ASbGncs43xFH1kq5yAjbxjltZGcp4d12966TlM3ezHHhzIkLiuKU+eINYujLWDwfmE5
	O9PLN+VO40/7Xf+/9hH6wmxDGnBMt5KGWctL/+uV+wEeHm0v8L+WAVNqL8z53JpMz6TM+x+lDRs
	tByrsmmOCc3HRpsweANhXtRuvzpPIxSAPwGC/UVOiHp7a81/IsfAcAQBKrRmooJhfymklJk2qSs
	qIuAnjj0evOJVHdHuMtf3shNs/RekNtbE70e2tm3JEggOaQtGPeWEOEBHkFkR8wFfQkt+Bri+oO
	0EE2dBH0eUZqi+563upAKCSeVO7mCWVCiR5g/7+TaypksUc8SUlazfV2QQE/34d2rg0R3zDe0aF
	nOCaFzhsc4A3aGg==
X-Google-Smtp-Source: AGHT+IGVv+Hw7jSjoixa1/E7zQmSwh1p6WVQXmOD2Loe5VSlhlnuizOR3ugGTm+11YiJ3z+bTMozvg==
X-Received: by 2002:a17:906:d553:b0:ae0:c4e3:e2e8 with SMTP id a640c23a62f3a-ae0d26f80f4mr322465866b.28.1750931968753;
        Thu, 26 Jun 2025 02:59:28 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:28 -0700 (PDT)
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
Subject: [PATCH v2 09/10] crypto: sun8i-ce - add a new function for dumping task descriptors
Date: Thu, 26 Jun 2025 12:58:12 +0300
Message-ID: <20250626095813.83963-10-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
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

