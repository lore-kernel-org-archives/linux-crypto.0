Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB60C3F0ABA
	for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 11:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783681661; cv=none; b=M8psl5nngchhC6LZIw9PksyP7a185qMLtM7+XmcRU/ipKWIsWXWXJUydXR4TJEhEvikzQhPTvzTCkiqTSFGHQ7n4L40tgWlwctEQY6B5USQh3R9cqrfGkhI+eqroGjmoGe1Rl7sbrR3t4SpB1yralEN3RfVlqgHSYSWem/Dpl4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783681661; c=relaxed/simple;
	bh=6Gv+2oCslqQ5EzPtqeoEWpOYC0FyyERn8hebctlNw5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hp+LgVb24ZFbMXgCWHQg7BJeEPOThwxRLG0Ohz2g01BoEzC3yYtPwXFwyODxTjCNO7RPtueTu6qyHHTpmRI5TDxCqz2aUAPVCSKO/BMguHf1JWTwwo7IJhbPMj8QF01CxSN4R1s4ol60GbvyWEmDi0lMHI4aAofSORgoA55Q4l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WsEVIenH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsEVIenH"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dbb3e08c4so35752a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 04:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783681659; x=1784286459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QMK3eVT0/oAQlr0eGKAyS3VOV21a/B1AmoQDrAJ9a3s=;
        b=WsEVIenHrZpp1DHI5ediOPXo+SasFkTmXjimPMVBiGXZm77XSDRArIunDFgB1D01ws
         cr8aGqmnOHIHbQHkNxpHFu0Fga0BfFvqMwflZBXpc7K0zG2pGBhEWNG0X996qHyD+UxU
         6nj28wt9tUxFe938bU9z24FFKqFG2Lp6AWwLvMT8/AAVPJ0sS6TWhDYSOm/a59l+Jkyv
         CICKQemCMLxaCAmxaJ0dke0UCTYIonm7m+iB4sNHGdd7chXx7eVJOCqoW8zsK52+2Mj3
         Z968zhd2ooVKI5Ll7lkDVtLQwG1YY/pzHfb1z3eE63LQDYRXLlpPe93JvUIRBW5sio5X
         l5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783681659; x=1784286459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QMK3eVT0/oAQlr0eGKAyS3VOV21a/B1AmoQDrAJ9a3s=;
        b=nyiA8jZutnL4WuAz2Yq1LTUn7nClkwlBblNOj+6pJTTF9lM8QIhGDQ//Jf/HhE+oya
         JGohUapjUR1v4N06cK4fxCcBLJS2DqWKTT8H9qY2+QTHXoBPvJW1556wvORbms8+aj9M
         vRlrt/kcwgp4PJaGeMQQ1cCMqhoA2oCkFKNDboEjVh2ySTNRDETNyLYuqZYoKfVrP9n5
         8ia6FcdPkDEtoM3j2VAp3qElVCx0PHc/ViwNShErWoKz8sdBfbmeoXEmWwGkZm9rPelo
         sgqIW+w/QXWmLVVh4nxnAnci9016DR3oOf/pLMsXQOIYJX3NKxUbkXvhO7w8iD4AaEcc
         nh6g==
X-Forwarded-Encrypted: i=1; AHgh+RrpRzXNZ27SRj4dXo16NENewfjp2joZx/YU89JeoqSaYmLpCREkh2G5/hTmc0L5P7ZsBBPZF4mNuclQ10I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsNd+Jf9hFb8FCv0orT+uQ2v5d2wiMATgfTEqv6UxXyU/CTQZ4
	t7xDkGsv6Jf/MBnOg3prSr2OfwCXu3xnUynq1lkU1Mkx9f6JeRn9ZkJ7
X-Gm-Gg: AfdE7ck3LL6p5AkteBwZ3s3whkLkLXBGm1hrny9fbyn7jgSK4Datto2rpOksCL3Z6jR
	Kd+yPXw9Icd7jXhpPo9kaH/Cw1KMD10IX4V4r07e5iZVWk1bBLyXeXNZBGzA3RloLo2Y9W9gBmi
	ELRK5AHNu4jauskA1+hMmp7Aa4rAA9BhWTeKpLCptAzf1QX/qNF31eiSEZyCZMIs9gqZoQOALm0
	NPO612JCSeYZROUa0yfm8XodaZ4qbkCdnaN24n9LQsw1IUOS9hpnDNEjUnHobfWTWWVl/nO4OLk
	WK9GK9rCydMpvpVjvrj1rffYnscQEKyg3LwiS0L+vcyVEw+fKMGDqksDIdpA05pvUbg3C6XP0aH
	eaHIs+wLRJQxzUmsPxpfRzJL3CizwWdNjhlF8DIHm/zk0N2uIJsLqOAtzGbX7hu9SqExK+1+Nek
	me6tOFOvzlRfjRiVE3OEUjpDnm1IQ=
X-Received: by 2002:a17:90b:564f:b0:37f:d6d5:8e8c with SMTP id 98e67ed59e1d1-3893d91fed4mr10524502a91.0.1783681659012;
        Fri, 10 Jul 2026 04:07:39 -0700 (PDT)
Received: from ahmi-PC.. ([2401:4900:88f4:a225:f83:5ab4:33ab:8313])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311838c9235sm35061109eec.21.2026.07.10.04.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 04:07:38 -0700 (PDT)
From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Neal Liu <neal_liu@aspeedtech.com>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	YueHaibing <yuehaibing@huawei.com>,
	linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Subject: [PATCH] crypto: aspeed: Propagate platform_get_irq() errors
Date: Fri, 10 Jul 2026 16:37:29 +0530
Message-ID: <20260710110729.224090-1-ahmisaranrao@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

platform_get_irq() returns a positive IRQ number on success and a negative
error code on failure. aspeed_acry_probe() and aspeed_hace_probe()
already detect negative returns, but both convert every failure to -ENXIO.

Return the original error code so callers can handle errors such as
-EPROBE_DEFER correctly.

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Fixes: 70513e1d6559 ("crypto: aspeed - Fix check for platform_get_irq() errors")
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 +-
 drivers/crypto/aspeed/aspeed-hace.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 5993bcba9716..301612556a76 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -728,7 +728,7 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 	/* Get irq number and register it */
 	acry_dev->irq = platform_get_irq(pdev, 0);
 	if (acry_dev->irq < 0)
-		return -ENXIO;
+		return acry_dev->irq;
 
 	rc = devm_request_irq(dev, acry_dev->irq, aspeed_acry_irq, 0,
 			      dev_name(dev), acry_dev);
diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 3fe644bfe037..1f9afa002ae8 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -127,7 +127,7 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 	/* Get irq number and register it */
 	hace_dev->irq = platform_get_irq(pdev, 0);
 	if (hace_dev->irq < 0)
-		return -ENXIO;
+		return hace_dev->irq;
 
 	rc = devm_request_irq(&pdev->dev, hace_dev->irq, aspeed_hace_irq, 0,
 			      dev_name(&pdev->dev), hace_dev);
-- 
2.43.0

