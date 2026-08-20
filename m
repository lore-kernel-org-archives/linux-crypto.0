Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E0C1A9FBC
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 04:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787201494; cv=none; b=GRecMSGjputij+2TfpZR191jMPhdqBDTwq297GmByQo1ZdedPKWuESwpTfaZ8/DTQ9QiCjjmm7aiKkMTXgY64paqJo2jc4uMo+GNKHlVNiIvlGCYqpourZTLUcNGcFjtQ7mWYYH1ssSQMkmHMToMu3yeZhVYlCPgcxH9fMH8OaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787201494; c=relaxed/simple;
	bh=3lHdil15QiCE9Kuc3lLu2AR/fo5ozuD90G0XzJ5dXI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lK2GIZm1b1GSEvO1wL6xmyi6/4pdjUkErEFamE2/OaWLzZzADefEmwK/1qJvfPB+FHIaQ51bRs6aOMJQxxcZ7BR28P2bhqu6bvWdXNG4EosuKmdNHp1+OALrOuZPuPecQAUdTrBAqvDRsqkD0oD3fKBTo+8rkodJDxZ1zFQkUUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6aqST2Z; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6aqST2Z"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84830c774a0so1586449b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 21:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787201492; x=1787806292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WC7fnfY6tlfCjE+QDReQnq82aSG/q+In/W9p+rlT/zo=;
        b=p6aqST2ZY8MoIPp+RKCG89WKl1nPr4t59Zgj82QckyrizIQEWo3JyPnV4oTwMz4OYj
         Pmxiq5jyqTfY7ghgyPDn2aYvUq2ipvyVAWmgVPRuDsA1tbFfIJ44pChBd61vMrZ+X6qy
         JDVMxu89PxdR0AB83pgLYPYscsbtB6ygivbC5NfjAau79wVCWx8eZncAHBvQc5x8DKOt
         aTJg4E5cq5t5w5KTJNd3J0DII3EeH6HpfwMjFWka4ElNEZEeTK6XFRTucS3pF1zDrVss
         bOjPeBn7Gasi+DKVpfbJumEuBs9Pyms3idOXfSdo5hL+jQ/JkxLQPvjDqoIQEYGe/Qrf
         XSlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787201492; x=1787806292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WC7fnfY6tlfCjE+QDReQnq82aSG/q+In/W9p+rlT/zo=;
        b=Efv2MuciVUJiNQ8+RFAsQulPFTYlu+uHt62g5yUunmFf5nTwnsNmpd0HAXQpkCLUfw
         MD1PC5Q1ZUxyZErMG4zOe+QGeeH7OuEuoRCplrf2FLliPPdYNyx6S4BTRCPoLRmwRJOA
         e3Ba17hl58sBI6+J73kXHSUe5/yKACRhsh/Qh0JCgihxNVXTeifmOvKKNaF5DEdjuDhn
         NvNn/PKDTfFpj62J9IlgItKkOhP7v0S/N9h8wTyY4R8EgWlPs5eYcsh29YLKG/PiV4vf
         /kGLZZdR3BtRhFRk1+dHsj+F8QuA5HqwaVVd0E4KsYQH9cwzw8Yz+4iur8bTkTUc/rOm
         UpJw==
X-Forwarded-Encrypted: i=1; AHgh+Rohklq3iBd/6NJQw0omyUviQFtzo5DMFwGUFkcOcoKagry5aDnthW/PnuDe8F1R0FJm+cZ63mEF3q6UbDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR/mLH2MK1EV8tgTMA3vGQrCsziAqnligYFwM/2CbQGglEuHnr
	WnVhuNxBNJ6YyKuvJRQ3bPHAy32lu2ysL41f7u5ZeM07q5xrusbKMjY=
X-Gm-Gg: AR+sD12+oVOEHx9+H13x4+otMBBeSk1d3eTQ9Xklbch6YkMDGSyhcZ3lTom/SaxEbRn
	6cruwbZ+H/gmf4lGBrZ3ia+/L81X7XOUuA0rNXUvftrpC87/omYNcRH7NpCFJ9i59JYpiQVvf3H
	/MDWdlttcXaT4ARmeI2djTUiiScQ3H7BxoAkg6yOhcH9fQNo/s6nRQH/e9WLW76A7Ze9NY/49BO
	PsuS+CC9BiN3AbrcqRWDQ8Ec6m6RuPAeri48Y/7g0D95OmGnR/0oct4vfIa1KoSwK5uOfYeOPBi
	r6fvDSCdWT6BvogMMVPUe2FBBxkvzW0mbKg1iGEekg+Gjo5hjMiIJZF2UWWswd8///2wxmCAczp
	hZzpdgGFykiVtx5NUuoB80iKtWhKWDVFAc9RvvPGL6kwBvZlOUoa4PFbRNrlRj71mdVtq1V4DCR
	XY6aaaHOFLBRmADfqbigytUakrTBPyrwvf/mXlBKsoi1usOpyoZNw5Eez96suAFpiUDkl4HcWkK
	A==
X-Received: by 2002:a05:6a00:4c0c:b0:845:e7ee:eae7 with SMTP id d2e1a72fcca58-851d387dc0cmr16690650b3a.5.1787201492015;
        Wed, 19 Aug 2026 21:51:32 -0700 (PDT)
Received: from DL2XHKPB4.dl.net ([103.63.104.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d3617434sm1237787b3a.29.2026.08.19.21.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 21:51:31 -0700 (PDT)
From: Triet Hoang <triet.hoang.dev@gmail.com>
To: dsaxena@plexity.net
Cc: olivia@selenic.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Triet Hoang <triet.hoang.dev@gmail.com>
Subject: [PATCH] omap-rng: Convert to DEFINE_SIMPLE_DEV_PM_OPS()
Date: Thu, 20 Aug 2026 11:51:27 +0700
Message-ID: <20260820045127.1960734-1-triet.hoang.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the deprecated SIMPLE_DEV_PM_OPS
to DEFINE_SIMPLE_DEV_PM_OPS and pm_sleep_ptr().

This lets us drop the __maybe_unused annotations from its suspend and
resume callbacks, and reduces kernel size in case CONFIG_PM or
CONFIG_PM_SLEEP is disabled.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
---
 drivers/char/hw_random/omap-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 9f0545c67774..22cde35ebe5d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -530,7 +530,7 @@ static void omap_rng_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->clk_reg);
 }
 
-static int __maybe_unused omap_rng_suspend(struct device *dev)
+static int omap_rng_suspend(struct device *dev)
 {
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
 
@@ -540,7 +540,7 @@ static int __maybe_unused omap_rng_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused omap_rng_resume(struct device *dev)
+static int omap_rng_resume(struct device *dev)
 {
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
 	int ret;
@@ -556,12 +556,12 @@ static int __maybe_unused omap_rng_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(omap_rng_pm, omap_rng_suspend, omap_rng_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(omap_rng_pm, omap_rng_suspend, omap_rng_resume);
 
 static struct platform_driver omap_rng_driver = {
 	.driver = {
 		.name		= "omap_rng",
-		.pm		= &omap_rng_pm,
+		.pm		= pm_sleep_ptr(&omap_rng_pm),
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-- 
2.53.0

