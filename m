Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4A15234
	for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2024 07:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713166484; cv=none; b=D2D0c/ClXnmmd9n2bJ3yD8MU6cg4MaL9mm+HgzDGAODz/JwNVYpQwZATHfKsHWQ5DWIpOlTDKX6blaevX3b5HZPO63DX5QTe7+7PlR3vmF1VJ4gUm7mAV/oRHcSN0zfeFoHcQIeowuA4SO8bMj2ar6yY+w5trgsIr+BG450prjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713166484; c=relaxed/simple;
	bh=5isFHpAGXS03RTMvHOsYw9l5fqPNaCy0+jqRrziaY0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sPBQszuUGy4t9fi6gPqoM2ZEAUr6BCeXDo9b95b8J6vQMbgZqaQS/+FjzagIvxAnxCpuCo7LADhtrEBJ3rXbKs4tnETF3MRjvUqAiMOmzYmFuZTJTfo5iWlZHIjG5bhShoD8RaWpB+u1VmFCQTR++1qzGEVqvQj4QMIcJWNFSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rwGrJ-00031r-N6; Mon, 15 Apr 2024 09:34:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rwGrG-00CNju-8i; Mon, 15 Apr 2024 09:34:30 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1rwGrG-001QZJ-0a;
	Mon, 15 Apr 2024 09:34:30 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH] crypto: tegra-se - Convert to platform remove callback returning void
Date: Mon, 15 Apr 2024 09:34:21 +0200
Message-ID: <20240415073422.8274-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2294; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=5isFHpAGXS03RTMvHOsYw9l5fqPNaCy0+jqRrziaY0g=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBmHNh+Jbd6cOc4yBSd0RKvPTE6Fa+WSB63WNW1+ 3//umzHr52JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZhzYfgAKCRCPgPtYfRL+ Toq/B/9TU1pyaUnyAzYDZHmSeNQyk5+ChIKMdgR1iKuPHgfYsTCHPP/UJD5ks3tXcrp5sIIJxlr sgU3yOt/h8RgFByOGFj+Bm78mdMuVIy/R+Mh4uugk4HOJ+3kwXrYtqUE6I+MP9Pb1s/KzBOfWBJ dnmp4xlTGTkDdqP1VwOeQDRfiTIs1t0KJ2TwPL16JH5/d/PVswEHIdhnc9MTmTpV0+uQ2/PMECy fG59uaN9jNtX+IGr+/7eR1F//j2/VuNmNNcn2M61VGm1pb1vEwcnr3bC7utSlB2ZKo5hPyO28+i /u74ycrNBNhaJyuP6LavBmWIn+Z0UDBMRIiDR0Sx/yLVt655
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this driver appeared in today's next. Given that I want to change struct
platform_driver::remove soon (probably in next after the upcoming merge
window), it would be great if the driver could be adapted immediately.

Best regards
Uwe

 drivers/crypto/tegra/tegra-se-main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index f4758e320615..9955874b3dc3 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -320,7 +320,7 @@ static int tegra_se_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int tegra_se_remove(struct platform_device *pdev)
+static void tegra_se_remove(struct platform_device *pdev)
 {
 	struct tegra_se *se = platform_get_drvdata(pdev);
 
@@ -328,8 +328,6 @@ static int tegra_se_remove(struct platform_device *pdev)
 	crypto_engine_exit(se->engine);
 	iommu_fwspec_free(se->dev);
 	host1x_client_unregister(&se->client);
-
-	return 0;
 }
 
 static const struct tegra_se_regs tegra234_aes1_regs = {
@@ -390,7 +388,7 @@ static struct platform_driver tegra_se_driver = {
 		.of_match_table = tegra_se_of_match,
 	},
 	.probe		= tegra_se_probe,
-	.remove		= tegra_se_remove,
+	.remove_new	= tegra_se_remove,
 };
 
 static int tegra_se_host1x_probe(struct host1x_device *dev)

base-commit: 6bd343537461b57f3efe5dfc5fc193a232dfef1e
-- 
2.43.0

