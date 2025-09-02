Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5923090FD;
	Tue,  2 Sep 2025 13:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819384; cv=none; b=nh1QbY58ywZHl14fZFnI6+0zGhoxxkSAPDqDuNBKUcpxijoTtQAaV6haNxsF7g+TEP2txp88Ug3lKcThHm4cC/mdH/kCZidFMFJS+FSKu05cEy0o9FYXdaEJ3aL1faPIezOPq0iQngmp6vBnAUfVCTIMvWXBOmrtJm+X1slHiWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819384; c=relaxed/simple;
	bh=NuYFEKMaNu1hQjN2Md5xNm1r7h0CNUWlhKkPh3zc5MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSxKG7FXTnlNRDcoSggs5W/52ug1vJpvSpJXidDu6w2NvD2bnzimidROeyAAG46e90lLGA784kGWdUJRn4EXkgSYOUZN63BSWhT06JvMM9WaBxdwwGerICLRTBdLtIy2yj0ICGXRSTjwYWJZ6npaCS9JuXbpEXFMVJkQply3lYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F30gZqHu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F30gZqHu"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b82a21e6bso25412425e9.2;
        Tue, 02 Sep 2025 06:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819380; x=1757424180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qolo47kLruRZDje5v7puvJiYv8DgcRb8St2Hs5XCLlg=;
        b=F30gZqHuULH4MaUitG25AfyQTZaZi7OS5i+/GHn2tfVDzael5+Pb2wk91yqK9DyQuf
         QzReF9plrgcT61Cl5HfNFFi+KA0KvopbFgeAOM02ysR/WhlmGvJNNMvfZpdqSvj5r+ND
         Y0IAEH6WrHHew0TdYINySSK6VcVLapRIkg8KrCQI4WOTufpNpLAdiZK8RHoTx4REz5jW
         EDphb9ubj8bLqyBmMiOFDrUqOi/cS+ZKUoKQgnCnp4RiMS2pDcJgaeedAMwx0zBoouvX
         Q6vAukeuplcdwYGiclWPCzhxz2Hxk9QDZ0wsqTTx3atDCRU6qrIOt7y0d8XAPMCp7bDK
         nxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819380; x=1757424180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qolo47kLruRZDje5v7puvJiYv8DgcRb8St2Hs5XCLlg=;
        b=HIv3PmSY9SOG/d79lsbGfPxwcYAM//rLKKSd9uadwxsjBbbzAA/5p+gKuPNJF4ffoq
         HhzTQRsR+vECnONxRKClt6FXalFJq+B95pjORKbO/M4HkJz0WyK8Di2OxizYhKkzpuqb
         IMtN4unzS5XvHvL+FoP/7aYqic9lbRVzzu2vOcitYwy8axCRxLUjX1J9A/porvo2L838
         rFvKfkhCOizdjx8VhJ1KdsTmT4LFhoQKvyNtvCb7ftvFzf6kqDCeSdHAdjQsY1TY4GV1
         Og+jZ4i2SNGp3eDfCac4T7W7GHwEDuA+dp6EYJ/cXeM/sZ/PFtK5RlqfC3KqYv92YeVp
         uLKg==
X-Forwarded-Encrypted: i=1; AJvYcCX+R5A2N6OUWkyYfsK0Kgb1HWxutt6Gh6igpJS0P+j9MmmNyvRu/k50laPk2usnENqLL8QuDl43Zr9XZDk=@vger.kernel.org, AJvYcCXnM/9KvJfKpvI/4K3LG4ebDwWqMbytC847B1QexHDw6OIsXNTtjAwWlep50L2u41NBdsrPth5oGbpgqmTl@vger.kernel.org
X-Gm-Message-State: AOJu0YyhhQnRcf75ZvXcKA8CZ2hpwzls4iYl9qBwUHESNKuGf1lPOECY
	HBSs4qEEunZxMNdEWCDYs+sdJLZnDZJ3fXQDgQcLiI0Bs540ffaD9+O/
X-Gm-Gg: ASbGncuXDdnWhxaEfAQ/JqTLopqE/8tNfWDwiBWnJzts1NiHRxB+r/jbjvM45yLhy8c
	x5K5koPD88CrhVm4Qo1uNFnV+1+cbp6cU+mCi+opa7RVVXFxjpIMxXmEkm+lF0JVWBciUSB63hq
	UnZkOrJGF1R76EdYE9TLFFtsQ2YXP0+VBj9cQHpkDMOIgE6t/0gHMS6afjngTqIjaF14q+aY7zT
	vKRQYbhdgQTC7oPoUqfNRac0c1xnUU4XqK/I+QGKQJy+nH3g/wblOFI0VTJRy9mVZ3cwPXrRC6x
	lcqiyj8ojO1i+Vh1YahwOeNWGrW8sxnnktohJfNj9/w1cdJOS6UhtMPLZkpb+zUcHoqU7AGpmMl
	0y+zm+vku1vxWE/YoTuJGb/jCkinqWa+NX+EUIvG8VJCi
X-Google-Smtp-Source: AGHT+IFVMpRzBsmi4JxaTIrSD5qdn6LF3a/HZb80zXbTgRnBpIOBBAGYwh5jd/sYemoWSplteKfu3A==
X-Received: by 2002:a05:600c:3b28:b0:456:201a:99f with SMTP id 5b1f17b1804b1-45b8730d443mr85114285e9.18.1756819380078;
        Tue, 02 Sep 2025 06:23:00 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:22:59 -0700 (PDT)
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
Subject: [PATCH v3 4/9] crypto: sun8i-ce - add a new function for dumping task descriptors
Date: Tue,  2 Sep 2025 16:21:29 +0300
Message-ID: <20250902132134.3287515-5-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
References: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
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

