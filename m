Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE8C34D4C9
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2026 23:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783035569; cv=none; b=nFr8OmVxu2s+vp3ccTFbeJA29OFLBp4PZUt1N872YQ+MfuTvHFwzGaz8i2w76HajlgGCJXtM1IQg4LoIwTfiShNJPLXEQ8xUNh4mNWu4YoIteGXobZGX2ONuMWUCWGWi8eHqMEuXhwglyBGLKWSt9zLWicJFU6PR6U8nNKRKtTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783035569; c=relaxed/simple;
	bh=RMNYY3fjjV69/m+j/rX8VNshnfJkZr46jhy+RJtWjw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NIDQ1vGPl6h5vVNOEws0DY9o0sxQWSffLbfVx2iE3fW34UqNtA2FuUcM/rHncrRm30+3r3G50IXbF/XHk4aSQOX1YizdqRQhR0+LEY+l2UQ+2rs0Pcd0NKO/t6Q5vMQhqWxkSJgc00bznesFPIdl4UIEy5hWcj2rWbP+1/JKGKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XxdsEtnh; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XxdsEtnh"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e6391b114so189487685a.3
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 16:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783035568; x=1783640368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WNKDryeWnXSKKY8fUHk6zFjL8w+dDzKefQJ/uzoOjJU=;
        b=XxdsEtnh7Twxz798rYThkEQGzUeQ+dfJZenTFyKgm0ZuClEDdwTOVNzR8PcjgX4H5c
         ny8udbwDVeAFeY+tT2I9soLbsAB4cqmGaDaaTR54i7BnM93GKGJRVT32p7euwbfivGVl
         x0IDmBtDe9p103y5ZWBorI1b52Nkm5fpBijKpslht5HLNdTurQzZJ9+4TCyYRBLS/z75
         r9pMSn26JoX0Ls4TiAsiOZ/2I9YEk78IqnAUxlHDy6bFGw/eH+owtsmTY4n6vVFv2z0b
         zPqlU3nxd6xxcCn9ag9PnHfrM39KEDpDOATPMYpD3ZJxvWSKzRyweNdG48PkVER/6cuq
         mJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783035568; x=1783640368;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNKDryeWnXSKKY8fUHk6zFjL8w+dDzKefQJ/uzoOjJU=;
        b=Du02KtWH8KeJviBUOxqyj2ChuTzQ0qld6lV/Eh30eZrH4HO/uX4eXiygWe5atBt6BV
         MB553DHjZl3z0imzqE8jTvJ33VjhcLFYABmiTYSueLRqims1OB11fHQR8kFqPoDuQOkC
         lyX/9zyyArD8oW8eqhV+8weOqwoxqHApz1zHFEFmrX0MkWbutJingWgckFTTYYfLzkWt
         2cra9GoxPvU+A4sHht7oj+MzUs+0DXgCjY4cBJqJFoRhvi0mS/GbGKRow5+eOnRZ7fKQ
         g4sTdNarIWZ5Vfx+6zFWn4/tj4uo+ZPSc3gJgyRfSeWTgb+hipjRS/efrNDlDQbLJwlB
         oErA==
X-Forwarded-Encrypted: i=1; AFNElJ+lfWZ1OrvJ5VW3FSmtdUskGQYNP0sK31VNwgg1tzeiSlCiKJY7OTdO1AfdVk2o4jWQdRoeqBBs8S+xssY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya+qLbBs05pyQag+E9OTwiYzaCqryax2Z1p2no4XivM6pTrebK
	ZpY5UFdfldva1+M0OEUIvpJ6T+oNg9jtbwrW8FdDBp8vvVswTDt+kGD87qeLfwhIEy4=
X-Gm-Gg: AfdE7cmUx8iSEvm2+FHvZ4tubGLZHi1eCnTPMn5XSCEacDgdLNlraEeq638P3alPrUS
	BSQsZoS+VjPf7i6QD9LJ2SK4Fa9zs8EkX2xfKPWfxWTZ/DEYOlfvySDgq8iMRFyQU9YZvhJew8W
	Gpwge73pUJQMZhh1WzDMBPJ5wTgEQp5ih511Dn6xJmzEkdMYtVfSkv5BV1UJxq1ejy/b+qZuQOS
	nu7jRIWGNEtmMoCU2oUGM/6fVt1629O7NbVpLT08/HXw4joVYR1I/XNQVdN9I85E62cAeJcfR9B
	dfqrgPRp2v5GzVV1rUySKB0l7WOzNoTsQvqOIfNDXAJssR4E7qBSjHLchQRyJrjUFCQPOwILS99
	IbEqorcOozPlqEjkX55Y1XMBee/oxLnBTyaUZiHLWBkKFs25hm+n0TbugiYWWYIU/SQlwV2D8fw
	1FXq4rRYTYALBn5COHyY8Bc42s9pofkccQb9PsEwrGgG1jTP+vCrvrI1EKF449vcuCa1PoGXGW6
	yCCAdasJUu/Izo=
X-Received: by 2002:a05:620a:4628:b0:92e:5cfd:154e with SMTP id af79cd13be357-92e7afb156emr1054949485a.14.1783035567540;
        Thu, 02 Jul 2026 16:39:27 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46e84e1casm42310676d6.11.2026.07.02.16.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 16:39:27 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexander Sverdlin <alex@sverdlin.org>,
	Nishanth Menon <nm@ti.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] hwrng: ks-sa: Fix runtime PM cleanup on registration failure
Date: Thu,  2 Jul 2026 19:39:21 -0400
Message-ID: <20260702233921.100478-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ks_sa_rng_probe() enables runtime PM and resumes the device before
registering the hwrng. If devm_hwrng_register() fails, probe returns
without dropping the runtime PM usage count or disabling runtime PM.

Unwind the runtime PM state on the registration failure path, matching
the cleanup done by remove().

Fixes: e9009fb227fa ("hwrng: ks-sa - Use pm_runtime_resume_and_get() to replace open coding")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
---
 drivers/char/hw_random/ks-sa-rng.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index 9e408144a10c..4494f1e4ab4d 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -242,7 +242,14 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to enable SA power-domain\n");
 	}
 
-	return devm_hwrng_register(&pdev->dev, &ks_sa_rng->rng);
+	ret = devm_hwrng_register(dev, &ks_sa_rng->rng);
+	if (ret) {
+		pm_runtime_put_sync(dev);
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void ks_sa_rng_remove(struct platform_device *pdev)
-- 
2.43.0

