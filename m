Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA51B3B18;
	Wed, 21 Aug 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264024; cv=none; b=rwADdCdShv6OF7StI1rKksSkJOqI2/7sLCMPeYG9Jdi15MMIQuHKjc0xq/Wymvk4A/jzJiLiH6AJP/cR1THXyZCJtnOvsLVkaGipT4TlSiJ+UdtxYxpPZYfxAciEwgaIX8neTw/6o/xFKV84dXOoJXlzeHoa6pz80an6+L1q5T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264024; c=relaxed/simple;
	bh=e5p33RXehCrHIF9U3oiqRKTbWMg7f8C1fHMFAw+UJdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mc8vvD1AVrzoiY2tps2jjWkD26ZEn7bFDCx3bJcdJe7zByqOK1cBGyIFOwWnSya7gR630rGxD+6ek4qp+2jVwxz5SjEVP06KKN2UPHrf8KWWYxiGcfNqTzWIKEuAi5JC8ShfmBz2Vfgf7CxnL5e3M2mz1jsMJz3Z31UjFzSDh+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from dslb-178-004-206-174.178.004.pools.vodafone-ip.de ([178.4.206.174] helo=martin-debian-3.kaiser.cx)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <martin@kaiser.cx>)
	id 1sgppV-00227j-2m;
	Wed, 21 Aug 2024 20:13:09 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Golle <daniel@makrotopia.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 2/2] hwrng: rockchip - handle devm_pm_runtime_enable errors
Date: Wed, 21 Aug 2024 20:12:35 +0200
Message-Id: <20240821181235.22270-3-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240821181235.22270-1-martin@kaiser.cx>
References: <20240821181235.22270-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's unlikely that devm_pm_runtime_enable ever fails. Still, it makes
sense to read the return value and handle errors.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/rockchip-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index 0dff9de64bc5..289b385bbf05 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -169,7 +169,9 @@ static int rk_rng_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(dev);
-	devm_pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "Runtime pm activation failed.\n");
 
 	ret = devm_hwrng_register(dev, &rk_rng->rng);
 	if (ret)
-- 
2.39.2

