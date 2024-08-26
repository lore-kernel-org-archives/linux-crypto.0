Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624DF8F5B
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724636683; cv=none; b=NbW1dT3rLQclpQXafDfGZqnAhjxKvLlZr9SFKLVmF0s6nds2QhmkIvVxYcqjH/EQMCVKG8FGVIB0su3wrkF/jBbHDW4FxyzPnnsyUxWtWqBmaNwY26/3iscfmxY8TBaKy7lD9FK8q2C4/jO+bepNYXxwEovIHai7vfZu2IPnlko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724636683; c=relaxed/simple;
	bh=ROq5sW2XkfU2W4+eWPIi8WuRMBQlZwMaPyXL2Odi9Os=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GIHaPvfhWOHaXE5dl7iDp9djUkH43GyefYaIYR7OTpkS0zKEUJUxVJZBbSIfEe0FXexP7KnZu529tqV7oXIwh5jUgxBUCyPQZgtxIG1l4yehN2qvr1dOWKKYREZfrV06eJowXHkirEVZ+72qeaqIKgASmaIn24kIZHs3N41HsFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=tym4uvgG; arc=none smtp.client-ip=185.125.188.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="tym4uvgG"
Received: from laptop.lan (unknown [125.33.218.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 150733F20C;
	Mon, 26 Aug 2024 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1724636672;
	bh=Lmv4uiN3qZvU6/NgG4L5k3mc5szxVQmfiLjQ/I/duo4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=tym4uvgG9Udo5WNioWWSdBBcT46ciJcwfgAjFbHHnhfpyinKDvA0D1qk4ohr3Om9t
	 zkGJz7dNXG+zXKk/7tZqmizIkLOyycxGD9/57TqOdHNsUphMd+BVqRnD33WXdLoJ8H
	 NbhuYkoJqUT57do3uDvH+XYwiyXWdlaWPP6Ad3TyivT3GEsyHoQXsEXPNlqwR6LFQx
	 FLpLWsB0Sigd6KbtVR0TvjCujBf8cdPXIfQBQtDw3CTJt3ZA/HyDBQTTWyaviPTODc
	 nK3lqcMEjNpU2deoeEGfwCbJzml9QYy289HeBPeZE6nqyjoKtBDBVqlaGKq+eeON/I
	 m93QssRd3z0Fg==
From: Guoqing Jiang <guoqing.jiang@canonical.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] hwrng: mtk - Add remove function
Date: Mon, 26 Aug 2024 09:44:19 +0800
Message-Id: <20240826014419.5151-1-guoqing.jiang@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mtk_rng_remove function which calles pm_runtime relevant funcs
and unregister hwrng to paired with mtk_rng_probe.

And without remove function, pm_runtime complains below when reload
the driver.

mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!

Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
---
 drivers/char/hw_random/mtk-rng.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 302e201b51c2..1b6aa9406b11 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -149,6 +149,15 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static void mtk_rng_remove(struct platform_device *pdev)
+{
+        struct mtk_rng *priv = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	devm_hwrng_unregister(&pdev->dev, &priv->rng);
+}
+
 #ifdef CONFIG_PM
 static int mtk_rng_runtime_suspend(struct device *dev)
 {
@@ -186,6 +195,7 @@ MODULE_DEVICE_TABLE(of, mtk_rng_match);
 
 static struct platform_driver mtk_rng_driver = {
 	.probe          = mtk_rng_probe,
+	.remove_new	= mtk_rng_remove,
 	.driver = {
 		.name = MTK_RNG_DEV,
 		.pm = MTK_RNG_PM_OPS,
-- 
2.34.1

