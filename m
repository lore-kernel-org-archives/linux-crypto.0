Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB032B131;
	Fri, 10 Jul 2026 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783707647; cv=none; b=NKaTRISesd9HG+tF6oS5cjHMtSqeolIWYWKm+oNjZMj7a8BRSA38iAs9q3/JMCkv5fXZy/nmbdnbphPp9UT0Jo4d4Qq4K3e0aSbnolPd99B9IxdEAbiqSD2g1AFcdMm3t/USWux+e/C/c5013p8XZ9lILfJAcVU1Yh9BNjwqsBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783707647; c=relaxed/simple;
	bh=mbQxtt1ALjk0JvV6wV15sO1f3XGFfupV0DCtzCzjJ+k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TkEkAzKmPb8zI8i7ipTJLN5Nq32k2+aafvfsT0HmUbDRtjB5z0kH3AyMOFjE7fD7KaCUA3/ouKO2IVX98Dxcjf+Gms0yWxVCuJe+9LkEtYSrGJs2SOMpb/wC8L9veJGypT5HnvFaXSJCyX2yzcX6UUX/g+BDKUS+oOMdyBpnT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Z4iNCDMG; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Z4iNCDMG"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 95614C2C64F;
	Fri, 10 Jul 2026 18:20:59 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B201160342;
	Fri, 10 Jul 2026 18:20:44 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AAB6711BD2C19;
	Fri, 10 Jul 2026 20:20:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783707644; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=qIwLuGSfIQ/QUKLXBSGXK1KP3kjjLQaoLNXsHMJEXfk=;
	b=Z4iNCDMGM2mvrlT4En6yYDESWPlhEzakgo8aWSZqmkU6QHFnkTqqYZT0sxAW2PHUkQT9jp
	hapGaP3GXYoZ/zTdxbHvwsCL+cDeIaRu57owkBbighXDrPSb8jl9D8O/hnnQ3jo0wNG4eU
	2pk3OLaA+HmR6XX929kYK/pc0L/y/1xT/D1/VRvCK7W9gFbydQDJsZyQcXqGjfHWLBq7Z9
	fWp1Yn+QxLhJp8Hpe063KrBauIq4XgOLw/lXv42RiSKjHxqsj2KCbGqO03tyjFCecaNSTt
	vM+q/nttSILr8mm4MSMC0ySv8MSxaudyQ6U/tg23NsdQw7aTol01yHI2xLen6Q==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 10 Jul 2026 20:20:33 +0200
Subject: [PATCH v2 2/2] hwrng: omap: Enable on Renesas RZ/N1D
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-2-4eab557b0e70@bootlin.com>
References: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>
In-Reply-To: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jayesh Choudhary <j-choudhary@ti.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

The Kconfig symbol and associated seem to be badly named as they have
nothing OMAP specific but instead refer to Inside Secure Safexcel
devices which have been used in many SoCs from different
manufacturers (like OMAP, Marvell but also eg. Renesas).

The Renesas RZ/N1D features this IP, so add this architecture to the
dependency allow list. In practice this dependency list does not seem
very relevant and could be entirely dropped, given the fact that this IP
has been implemented by many different vendors and seems to be
architecture agnostic.

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index a5bcef4a54ee..2f1e3a77c948 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -193,7 +193,7 @@ config HW_RANDOM_IXP4XX
 
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
-	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU || ARCH_K3 || COMPILE_TEST
+	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU || ARCH_K3 || ARCH_RZN1 || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number

-- 
2.54.0

