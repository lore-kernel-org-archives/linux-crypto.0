Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C123ED12C;
	Sun, 13 Sep 2026 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789303912; cv=none; b=DigI6pstT/lFeqBNxqZAD1PsZ0GogOeIGvqwEWvs3hPiCop8EZIf1XESKUmo7Tx721m+g9nH+vWa1H0v+UXIAzq88vzTLmDfMp8sexexKzIEgI3bJMT/EpJkeaybn2y+1zWnHdJwYdJs50bUWB/CogAjeF/QMfJ2stf7zGiGeko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789303912; c=relaxed/simple;
	bh=I0abtY63JnHqUWf39GYDy9cvT7uvAL0KviaHu7OuF+U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sXMTnZZr33WaxI9twEFP478mZJkg8sNw1IlEpSQVXC0fsJlGhomOSpUVB9mJXwTtzmCMSG7PKJe3Uxuw0+R1O17zQXDHIi7AHcbIj/EwVSnA6eUsqbmUZ3Zrsmku5hpnI70IQRMrM1jS9D0FCuvm40WOvk11DrLgLb3HC6G1daU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=SAUv33o3; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="SAUv33o3"
Received: from seu.edu.cn (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d907a3de;
	Sun, 13 Sep 2026 20:51:45 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH] crypto: atmel-sha: reject initialization without a device
Date: Sun, 13 Sep 2026 20:51:43 +0800
Message-Id: <20260913125143.109897-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa09ad2db4903a1kunm3fb934b6251186
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTEtJVkIYGR5LSEpOQh1OHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0
	NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=SAUv33o3N0M2U3MEQ98jrETLPHgCQDktyroJKoOmzGE2qUrUNNC0WZKZ8CCEk86B5mH8PdpflSDu3D+i6ybXeDT3USPuWvgPW6UC0gnAsj8kcfgQmj+PyzYfjEQNpkwPwPEuHwUVkTiB9DqAZalEsfjlnoH7otGwZQQrPIv7/DI=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=u56UvOMtNFwTEkpB4tij+Y0DkppGFXqA7XZx7fKlDwA=;
	h=date:mime-version:subject:message-id:from;

A transform may be initialized for the first time after the last
device has been removed from the driver list. Return -ENODEV when the
lookup is empty, before the debug message reads dd->dev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/crypto/atmel-sha.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 48f54b615504..d2338e731d56 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -422,6 +422,9 @@ static int atmel_sha_init(struct ahash_request *req)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
 
+	if (!dd)
+		return -ENODEV;
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
