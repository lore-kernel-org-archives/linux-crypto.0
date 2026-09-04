Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F14138A706
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 23:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562908; cv=none; b=P4dO2PbsQIfmC4PyyMFa/P77LGhxYl0nTGMxcCUVmfhttUQyMff5LWBEaRhtfTyXcQM93QztAAJVM4VX5QmX1Ox6VCU2pp4Xs3zQBNi0FskIyfT8CxmB8ughYJ8yfr/np9ZSXUJkfrsZOyKhSA6lnXyWJL93z5321fCsHhO6hy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562908; c=relaxed/simple;
	bh=ktEUA4I/QOWBXJdkm7apRaIMx8G1N83lADeV3M8pSqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QbiWJjTfxbmzL6sw9CK4Wm8Y05aWCs4SmXThRhTD19NiQtRW/BlMUo1NTSW/l942eUcquJikeWwaKW9CclcekuiVtA2wVVMaRrF9rf1IY36yV2kzUFemUNu6GOdZios6/FdjIwam8VhzTuJPVKpaIPOsJDznyTn5/7dMBZL+YJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSkenvss; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSkenvss"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84faf0fa17eso1553901b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2026 16:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788562906; x=1789167706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mj6rkiDUr48HOONfvJQ87MDV9HV1+Ud30doXtyCj4Sk=;
        b=MSkenvssU/QEs5XARmvXVoaFykK5PHhnQ4l+dsLaoIjs2gHIhp9N7gYNsmRO04FVva
         FHB1tTJfh7vknW2QHO5QfncSX49e7R+Dm0RCQy0QpSPgnRmZ7aV/ERCgRc/2ql54u1xH
         G803GbKXv1uTzeuPONVGmWKdwQ7aGmxzbe5pQkdO0p/wMSc0V46WWxVsNOvYC4QtCYUV
         9f10i9R7KSIms7YQ0sYPJECyvuuhwywX4szXuQGYtUn7IeQaZSn3v8Y4BSR+OQhgmc34
         oG2we796NQe9kCfWdwmHq/B3ta+dFb58zyMnV7pb2+EISFafnT3QS9Z007Lif+nzbITG
         G4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562906; x=1789167706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mj6rkiDUr48HOONfvJQ87MDV9HV1+Ud30doXtyCj4Sk=;
        b=J594LflSEIDY/HfcrROTnK5uTGA2Fqfhz2J9Yx/Y1SG2eJPTXC2OfmJVels+sCue4I
         t4vu0NY3899YLS2Eszo1TZXVZkLFay25UlNfif48coH4zyqyhXYuxOdhKwMLZBdz3eVg
         PldrawEFkv1CON2J8HHuct7II/n3g886AmSOw51k4ctqhN82fHPDxbwGIP5HjsGnGU5h
         EeASmPWNC2azUWd8ugfsc9PrU5ErxfsHDCGJrjjJXgPfkQkFbPnEqhYEgvVZ/MeG5SCM
         Y5HYVTfP8MBxhpYltWhqal9UFewL4TeWd2otWEGd3QO/+E8LASi3n0tksnwBmGVRW4+b
         OD1g==
X-Gm-Message-State: AFuF++lyECWDQB4OJQGa7/Zdg7rmyj7N2bDVieZER8hKS7E0WcYx5fho
	1FiW8FsowkKEsDPucO69v8zdbfL5Um57v/8rgtrrPsIswd2BNiOu6qHgtxCNLg==
X-Gm-Gg: AYBFou0TwOrRV8rFXVWhKXfG10dC1LHfCMNGZ+XRXGNwO5Tr/pN7I1TuZWbJl+/MDkN
	2qhi3+LHYo/F1mnv8uBKg596PC2HvTpDXls79+GBdKJn376/7Sj4iqur9U9TrhxGwCn6f7em/Bj
	otUZVJ8IL9Pwy1lmEBMZREYDahq7rmfnapxivWIaMQ5jzu55ibTHDXSYiSba/Ou2+UWibvk0tsI
	cGs9UxeLhC3Z0a9JZVYX9DqQbT6bKZPAq+zhR3vvazv8R2/Fe37cpD8J7VHJL5R6NqMVNvnUiNW
	94Zwab7pi5Fln3tlqB+cOe+ce+UdgAoJFu9gPlUnD1y2YLmoCuEX6P3MWQnMlBOXQ972hE2D0/i
	o54Dpc/Y8cG2X1Q/H9mmk9gDZFGsuo5HOTNddMjXaTEil8vQ1BorY6G5d71Uk5fpbQHaWhOgzBc
	zLTh0C9+ktsaBXzb26C0qCZn7O4JGFChkJBGdOk4atpJjUvIfC4yMuUB2+8eEB8W9A5CZ404vx8
	ptZ4c60WxbtIyiRiqxyTJzEo0yDJqFJ+KYxYhD4VoiPXlX1i087TTpWJ4vQoJhRl5c0cQJ/Gpnl
	nuBrSZj4QInAKaku+FWV1ebIyzsIIpGk3PUGrg==
X-Received: by 2002:a05:6a00:10d4:b0:857:7337:5db4 with SMTP id d2e1a72fcca58-8616a26166amr10487230b3a.18.1788562906198;
        Fri, 04 Sep 2026 16:01:46 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86265451951sm723957b3a.50.2026.09.04.16.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 16:01:45 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc: trng: use int for ppc4xx_trng_probe()
Date: Fri,  4 Sep 2026 16:01:44 -0700
Message-ID: <20260904230144.127071-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass an error message to crypto4xx_probe() , which will allow handling
failure. The inline function returns 0 as trng is optional
functionality. Same with the of_node.

Add an extra goto in crypto4xx_probe() to unregister algs as registering
them happens before trng.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |  6 +++++-
 drivers/crypto/amcc/crypto4xx_trng.c | 15 ++++++++++-----
 drivers/crypto/amcc/crypto4xx_trng.h |  6 +++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index a044dce65cf4..acf18b71e54d 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1315,9 +1315,13 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (rc)
 		goto err_irq;
 
-	ppc4xx_trng_probe(core_dev);
+	rc = ppc4xx_trng_probe(core_dev);
+	if (rc)
+		goto err_crypto;
 	return 0;
 
+err_crypto:
+	crypto4xx_unregister_alg(core_dev->dev);
 err_irq:
 	free_irq(core_dev->irq, core_dev);
 err_tasklet:
diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index cfd66b779ce1..83e9353529fc 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -68,7 +68,7 @@ static const struct of_device_id ppc4xx_trng_match[] = {
 	{},
 };
 
-void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
+int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 {
 	struct crypto4xx_device *dev = core_dev->dev;
 	struct device_node *trng = NULL;
@@ -79,17 +79,21 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
 	if (!trng || !of_device_is_available(trng)) {
 		of_node_put(trng);
-		return;
+		return 0;
 	}
 
 	dev->trng_base = of_iomap(trng, 0);
 	of_node_put(trng);
-	if (!dev->trng_base)
+	if (!dev->trng_base) {
+		err = -EINVAL;
 		goto err_out;
+	}
 
 	rng = kzalloc_obj(*rng);
-	if (!rng)
+	if (!rng) {
+		err = -ENOMEM;
 		goto err_out;
+	}
 
 	rng->name = KBUILD_MODNAME;
 	rng->data_present = ppc4xx_trng_data_present;
@@ -105,13 +109,14 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 			err);
 		goto err_out;
 	}
-	return;
+	return 0;
 
 err_out:
 	iounmap(dev->trng_base);
 	kfree(rng);
 	dev->trng_base = NULL;
 	core_dev->trng = NULL;
+	return err;
 }
 
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev)
diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
index 7356716274cb..1030c3cfafd0 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -13,11 +13,11 @@
 #define __CRYPTO4XX_TRNG_H__
 
 #ifdef CONFIG_HW_RANDOM_PPC4XX
-void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
+int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
 #else
-static inline void ppc4xx_trng_probe(
-	struct crypto4xx_core_device *dev __maybe_unused) { }
+static inline int ppc4xx_trng_probe(
+	struct crypto4xx_core_device *dev __maybe_unused) { return 0; }
 static inline void ppc4xx_trng_remove(
 	struct crypto4xx_core_device *dev __maybe_unused) { }
 #endif
-- 
2.55.0

