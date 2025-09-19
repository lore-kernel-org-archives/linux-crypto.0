Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA822A4D8;
	Fri, 19 Sep 2025 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758288021; cv=none; b=gC1r5GwHoxN+s/bWfJmLWJ0FM7y7BDeY5f6ar2lhmdoP/3TxFMCeZFij6vhhqvDDgF5+GRNT0RMquQxw5aclTzn3N90vZPQylcbQUUgyUt7JWtNv8HVkPoz/nHhg65J5atm1Ggtg1qlIM7ph6+bKB5+Nmh52pzdX7zwhQnqA7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758288021; c=relaxed/simple;
	bh=9zpwxe4kX7gYqebQEftmwp9mQw9hylEf3bwiFg15TaI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YlvXNaHrrpeQQWJ7PWW9XopLcxN1xkj6VdY+m9O6QT8ysEhMGMneLHJsw5utBCUmuP/nQZ+r0COpcMAYgwLKZnldHmiuEIMmZWt4FJjrnMW2iEy7FBy22f+S0SEQPbqnfLdAsoufCqUNnROJjXQB5lE0F2cxBNdNZwYpYGzTKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=iv8b5G//; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="iv8b5G//"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58JDK6tN716885;
	Fri, 19 Sep 2025 08:20:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1758288006;
	bh=z671kKLEutPGUAyNw4Pf3Y/MwQIZ9sbhw2E4Riors/U=;
	h=From:To:CC:Subject:Date;
	b=iv8b5G//5Wf9o/1Qjw8Z9AnNa/dkMd3ean0aP3aISfxKaArWN8c8t6I7FgdcgrOZT
	 ea1Xi9HaXKOZVWbFVWKFumQ7gIAUmGO8SxbwBUSHnJcDR4KZwcWP79XQsEGI98ud5b
	 jxx9+pzsPdZj0xvDnYiPnvydyMbyDfMGN1oMQM5M=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58JDK67Z3178766
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Fri, 19 Sep 2025 08:20:06 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Fri, 19
 Sep 2025 08:20:05 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 19 Sep 2025 08:20:05 -0500
Received: from localhost (uda0133052.dhcp.ti.com [128.247.81.232])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58JDK5VI2624682;
	Fri, 19 Sep 2025 08:20:05 -0500
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>
CC: Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Alexander Sverdlin
	<alexander.sverdlin@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] hwrng: fix division by zero in ks_sa_rng_init
Date: Fri, 19 Sep 2025 08:20:02 -0500
Message-ID: <20250919132002.180874-1-nm@ti.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Fix division by zero in ks_sa_rng_init caused by missing clock
pointer initialization. The clk_get_rate() call is performed on
an uninitialized clk pointer, resulting in division by zero when
calculating delay values.

Add clock initialization code before using the clock.

Fixes: 6d01d8511dce ("hwrng: ks-sa - Add minimum sleep time before ready-polling")
Signed-off-by: Nishanth Menon <nm@ti.com>

 drivers/char/hw_random/ks-sa-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)
---

Noticed this when looking at kci logs:
https://dashboard.kernelci.org/log-viewer?itemId=ti%3A0af42187f4b24261b0c102f0&org=ti&type=test&url=http%3A%2F%2Ffiles.kernelci.org%2F%2Fti%2Fmainline%2Fmaster%2Fv6.17-rc6-43-g8b789f2b7602%2Farm%2Fmulti_v7_defconfig%2BCONFIG_EFI%3Dy%2BCONFIG_ARM_LPAE%3Dy%2Bdebug%2Bkselftest%2Btinyconfig%2Fgcc-12%2Fbaseline-nfs-boot.nfs-k2hk-evm.txt.gz

Fixed version boot:
https://gist.github.com/nmenon/0996e5f7bdbcd3b014cee9921a60d88c

 drivers/char/hw_random/ks-sa-rng.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index d8fd8a354482..9e408144a10c 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -231,6 +231,10 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(ks_sa_rng->regmap_cfg))
 		return dev_err_probe(dev, -EINVAL, "syscon_node_to_regmap failed\n");
 
+	ks_sa_rng->clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(ks_sa_rng->clk))
+		return dev_err_probe(dev, PTR_ERR(ks_sa_rng->clk), "Failed to get clock\n");
+
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-- 
2.47.0

