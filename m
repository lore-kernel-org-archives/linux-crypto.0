Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C63F1EE7A3;
	Thu, 30 Jan 2025 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254748; cv=pass; b=QBmHy/cHTy8CIVNzezRJiZq1royu8NYy/8W2jvNHtjn25ol2+JvKrjTKiJLj5w12t73p7cQnAD1iubPBi9QfJpwVpb1OYkJM2IvVz3ToTcdLONUSC4nP3ohmcLv8SRoMLDcIxfv5jW2c6tdo578k9Qjg9SOpo81QXOQMaXfGS3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254748; c=relaxed/simple;
	bh=+aoTSAqZWyBztrtWeswEXHKLUWxHkKbIOzBq8UNVOh8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D+vOFUv5UiVTJr077SG4EIITdT493vw1NxRJCbKoVOwF8nTGB8D20/jZf2RwqJ7r6fIBdkAYgI6FgXsg7rGv7+ORlB0sg7SthLwrYSBj+AdVJNaMNhOuB4d5tQ/W+EhsPYrwAHUd7IsDqyircGENbOoFGV37l5xuZ+xl7S7V5uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=jrbgPFnh; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="jrbgPFnh"
ARC-Seal: i=1; a=rsa-sha256; t=1738254722; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dgRw0i3M6lBsoph2Ys9X6dgTTttInW9M6YmkfP84fZQJepzRx8JjYi9L0TqMdc2syWEQcjAK9DXAP4X7pd1JZDxeVpUW2VHLhfs9gLzjdGGGsGXbm1RZfI7Cuu5xw73ChDZ0BwcTMX7nOc4WJq7xU3iYx4tM0tdjehCY98wueZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254722; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ee+aIEbx0Uoz73M7xvQb4aORnr+guJuf8bM3GRunjkY=; 
	b=kMx/8vKRVf0g0fZCbt3zJzi3LLKHLTfTFOvzKWvsgzMUmEZL4ws0z/A5ZIqMeA31g3n3rvU3sGaGXNBv+n5Ydzhx2DV4edfs5VkpNhVqgmZk83qvn49SYpIJaHq6h5tnFxTclJq228qggCxhpwF281MP67pydcA3roiaUFPp6ag=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254722;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=ee+aIEbx0Uoz73M7xvQb4aORnr+guJuf8bM3GRunjkY=;
	b=jrbgPFnhGYYxKjDhpN+1Qj7ZhWH2bSuVFnZNrgdzYRp5c0n3eCT49zi42BU4e0g7
	mT9BZOfeZ3pr7/rSAPIHWiAyuvLCi7qK0PbrJWbnweo1T458De+kIL5xqHgYqCuMIaZ
	9fxaSVEhTgS02Q5j/s2Uf1CrMEA4kDeDEcVRWhhU=
Received: by mx.zohomail.com with SMTPS id 1738254717518381.9011915428704;
	Thu, 30 Jan 2025 08:31:57 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:18 +0100
Subject: [PATCH 4/7] hwrng: rockchip: eliminate some unnecessary
 dereferences
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-4-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

Despite assigning a temporary variable the value of &pdev->dev early on
in the probe function, the probe function then continues to use this
construct when it could just use the local dev variable instead.

Simplify this by using the local dev variable directly.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/char/hw_random/rockchip-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index b1b510087e5862b3b2ed97cefbf10620bcf9b020..082daea27e937e147195070454f9511a71c8c67e 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -148,7 +148,7 @@ static int rk_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, rk_rng->clk_num,
 				     "Failed to get clks property\n");
 
-	rst = devm_reset_control_array_get_exclusive(&pdev->dev);
+	rst = devm_reset_control_array_get_exclusive(dev);
 	if (IS_ERR(rst))
 		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
 
@@ -171,11 +171,11 @@ static int rk_rng_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(dev);
 	ret = devm_pm_runtime_enable(dev);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Runtime pm activation failed.\n");
+		return dev_err_probe(dev, ret, "Runtime pm activation failed.\n");
 
 	ret = devm_hwrng_register(dev, &rk_rng->rng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to register Rockchip hwrng\n");
+		return dev_err_probe(dev, ret, "Failed to register Rockchip hwrng\n");
 
 	return 0;
 }

-- 
2.48.1

