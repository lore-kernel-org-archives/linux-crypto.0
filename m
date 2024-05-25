Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B81429E;
	Sat, 25 May 2024 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716650639; cv=none; b=fvX+Gru6iNxO8+vPJHArqET6HcMv1/affvEkJYmuhjQitpLomM7LpsrAgiqeiste8F1Tgb4LxKWGKhdNkoJIulSMo2FycT5rBpobxVfp5geWA60BdylKbzf3g5xJ43dbG9rsj/z8ELf7WUjFF7jGSwXJvSCaidNbRLieQmHKzyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716650639; c=relaxed/simple;
	bh=Y1QbV1fVDvWYwh1mRKjVim+xdyrWT0f/WnYH38ND510=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NOU2QGAbtu/+ghiQ8HW4bVOGUoJKwMP4WqhmAYUQ3rAij8KNZViMPDEHj1nHTAGYCEsHn6MA9kVCWjXl5/vFXqgw64wJQokr7ZQp+Jw87PExKZk7Dg89Amsnnu+iGe5Kx3ITc8HYLF70F1hQNIUYNMfr6+yr5idw1N6ZjmK1a7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=UcNiW7vq; arc=none smtp.client-ip=80.12.242.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="UcNiW7vq"
Received: from fedora.home ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id At6asqDFCOBGCAt6asbEpr; Sat, 25 May 2024 17:14:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1716650087;
	bh=SsSnU22BLOw2sFJbi0JknTXepGNVkme9LGYumcyMsq0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=UcNiW7vqBL6W/uiJKJok9ctWJIJmgX2JZMruZnW+I5yvkB6lsgwEVFIa07qypLFq1
	 HWc7s94sRHNc7PwjCcHclfEeCFFuE0HZ+FRG1BZCZNZESKn2Jrda875XMEAESMpY6w
	 5+Ysr+/16CU3fUE2TEoz5OHshQGHoLZLYbTmszZuxpd9OPZ3Nvsowe+VuMoIkPBI7D
	 eOoWxtp/ePwL+D//ijSf/y+eFEDdSfKDVbWREi6NCihYDfaIVeLDjItTUibKkRibM/
	 qVSegiqnjva1HfXNG+dUC+TMg3xNO8iAv9fvqgENWbk4flNtwAOWa5MLW3NQ2SCaee
	 jXRW6ExbhnTtg==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 25 May 2024 17:14:47 +0200
X-ME-IP: 86.243.17.157
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org
Subject: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free() call in tegra_se_remove()
Date: Sat, 25 May 2024 17:14:35 +0200
Message-ID: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only iommu function call in this driver is a
tegra_dev_iommu_get_stream_id() which does not allocate anything and does
not take any reference.

More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in
the probe.

So there is no point in calling iommu_fwspec_free() in the remove function.

Remove this incorrect function call.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only

This patch is completely speculative. *Review with care*.
---
 drivers/crypto/tegra/tegra-se-main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index 9955874b3dc3..f94c0331b148 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -326,7 +326,6 @@ static void tegra_se_remove(struct platform_device *pdev)
 
 	crypto_engine_stop(se->engine);
 	crypto_engine_exit(se->engine);
-	iommu_fwspec_free(se->dev);
 	host1x_client_unregister(&se->client);
 }
 
-- 
2.45.1

