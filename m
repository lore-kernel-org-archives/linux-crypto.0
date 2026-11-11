Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794388037;
	b=vlMuEXidZ9UoiaE3SZOoAXwD9gyZNAf93Lgf5dlJb28YaJXQts3vy55/LrXG7jM/hCn3
	 Mi8QYDLsp0nXGnPp53hohF+eYLBe7wI/XFfy/fF6WhRBWSaNckm+sqyo5UhQVGRwriMJM
	 7KRfPW6SUr7Kyk9wF4m4WMZi3Nht5U6W8V8NLyfXncVbqjeco6jdPLOyi6f1phLkPGuT9
	 9dvGIZGKhT/IyMWEscUfmvym4fbao/Aj+F7wSIEPpyHH3ztSmytHMGkBDurunwc3lXc4S
	 jeci7Omhx/G0/jK5FiH32NcVXGiXSo5eqOtHQmJwOU0ISgrFnRXOvOWwQoKSAjfyaQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794388037;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fHtFP+NVXyvsN6ITWWkjYjJM/RPu/qVC92ggaa9RMvE=;
	b=x0k/jRsQA0Do6z/+BolvboF9ZQGDnJA3Q17hirIDQQIaN1fRWmY9WY9qZpI8WEhOlgSp
	 SbLmDNVlnZtGpXHLVQcVpAPX8NLEv+k2zTUc4G5PEEbEpJ4h7nTTt3RZky9RD/GhtZy76
	 LufM8mo7E1GEUwTG7cwNOMfNinLzWMnRTEvWHugdJPK+eMMNz5gZfnksAfWDMnWAQOYK0
	 7gxAGEWvw3ssx7CIsNNgFaKOKBNmx0539YEfQcR1EkiGjCCGGkt2mmm44fqHNRRHpqD+n
	 BZ845spZdIXTtwTp9ZsrrsY0iwCeASy2aXXJ2uSu7QoNd7WGxemUF+ZZj1fWcUAk3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=XdjE2l36;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E15606A332;
	Wed, 11 Nov 2026 09:07:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3E15606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=XdjE2l36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=XdjE2l36sM4Vm1rzlbD/G4UC6gX3GowulXpbgYS9kD3HGxPbVwx+Scbrc7JjcA2in48nUVWv67xD0
	 GzFMTHJHwrjVma9j4OXjtVVX5D1/V+2B8FWTzjytd3lidzH0Ip6Kr1mPY2lFCADkSfC06UfAwv69MQ
	 ThRygG8wtNllwz1o=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86af43041188-77369;
	Wed, 11 Nov 2026 17:07:14 +0800 (CST)
X-RM-TRANSID:2ee86af43041188-77369
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66af4303a7e7-d684f;
	Wed, 11 Nov 2026 17:07:14 +0800 (CST)
X-RM-TRANSID:2ee66af4303a7e7-d684f
From: Gu Bin <gubin@cmss.chinamobile.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] hwrng: mtk - enable runtime PM before registering the RNG
Date: Wed, 11 Nov 2026 17:06:59 +0800
Message-ID: <20261111090704.1699-3-gubin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261111090704.1699-1-gubin@cmss.chinamobile.com>
References: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
 <20261111090704.1699-1-gubin@cmss.chinamobile.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mtk_rng_probe() registers the RNG before setting up runtime PM (and
before dev_set_drvdata()). devm_hwrng_register() immediately exposes
the RNG: hwrng_register() makes it current when it has the best
quality and starts the hwrng_fillfn kthread right away, so
mtk_rng_read() can run in the window where runtime PM is not enabled
yet - pm_runtime_resume_and_get() then fails with -EACCES.

On unbind the devres teardown runs in reverse order: the RNG is
unregistered after runtime PM has been disabled, so the same failure
is possible during teardown.

Move the drvdata assignment and the runtime PM setup above
devm_hwrng_register(). The runtime PM resume callback needs the
drvdata, so the assignment has to come first anyway, and with this
order the devres teardown also unregisters the RNG before it disables
runtime PM, closing both windows. The SMC variant keeps skipping
runtime PM.

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Gu Bin <gubin@cmss.chinamobile.com>
---
 drivers/char/hw_random/mtk-rng.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 1e8e458dab25..f337473ba99f 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -212,13 +212,6 @@ static int mtk_rng_probe(struct platform_device *pdev)
 		priv->rng.read = mtk_rng_read;
 	}
 
-	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register rng device: %d\n",
-			ret);
-		return ret;
-	}
-
 	if (!(priv->flags & MTK_RNG_SMC)) {
 		dev_set_drvdata(&pdev->dev, priv);
 		pm_runtime_set_autosuspend_delay(&pdev->dev,
@@ -229,6 +222,13 @@ static int mtk_rng_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register rng device: %d\n",
+			ret);
+		return ret;
+	}
+
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
 	return 0;
-- 
2.55.0.windows.3



