Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C359D241696;
	Wed, 15 Jan 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946446; cv=none; b=r+9xsSTxqdtapuPqe5On1H65Fl8I/ZjRWwFW8EGS6YXxxIBqdtEqSuzaKX+4HUaU8qvJ6Vwvuevpf/vqR0eaKnoyU6Hp+LoeQW2KPUI/kUVAJO8CYUiIsoUrXT7RKNiNVEHYu83KcgD21Refy8ZQ7jEYg2ftzNg6a1PHamXte5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946446; c=relaxed/simple;
	bh=NJ+IK/V9xhosjbuIonSPKBSBom83qI2UMQnetlOXyyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cvgghg+w6NEdSdv8cctw3xFxvKF0MaRoDQIXgoY9Aoe4ZnCDHGfYSEAWIRbeRYh/VCUny03LK4jSqYBTqXwkejnmpU3eEYYN/oDZ/tKOVX8nGnxDTx1DchLZtk0ubZ+d35IyuBDYrpjVY7E036X+Ul8CBtmT+2s7wAOU+IM0O+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=UbrYQfv8; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="UbrYQfv8"
From: Dragan Simic <dsimic@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1736946442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8z8/gRN7DC+4Mj+pO8dEfzBc5pYw3dZZmEI7IcFQziw=;
	b=UbrYQfv8ruTOz+6irLtI2CDbKtav7lFqL/Cars1VvLDsLBSVmujqBzuUV1jFqaMwON8Vn8
	sRpx6T5am4lhE6L2MbhSSA6twzIfuiQCpA8rhh5Ysci/Ar/EnUHnORpPeKHdhkxWct2GT3
	tRwZKa32otaUFb3U/5QDCCtjOI+oKhnqarf3j+o98SlXEfi7GdE7J6WrwhiiYhmOgYmRgR
	kRjrHfUm3qi+Ijed44RTZryJYEVLNaZxUOwF+W++GoOKXWaTGRd/HkU1rTZBTb3mGlNQHT
	+w7ECw2DJxa6AtY3r87gBTGGDbNVyMz2g1MAuJt3yxTNTh0oMKGfFzyiDy/Rmw==
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	didi.debian@cknow.org,
	heiko@sntech.de,
	dsimic@manjaro.org
Subject: [PATCH 1/3] hwrng: Use tabs as leading whitespace consistently in Kconfig
Date: Wed, 15 Jan 2025 14:07:00 +0100
Message-Id: <7b83b40af74e5a7c5d3316d3c0f460370ea0313d.1736946020.git.dsimic@manjaro.org>
In-Reply-To: <cover.1736946020.git.dsimic@manjaro.org>
References: <cover.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Replace instances of leading size-eight groups of space characters with
the usual tab characters, as spotted in the hw_random Kconfig file.

No intended functional changes are introduced by this trivial cleanup.

Signed-off-by: Dragan Simic <dsimic@manjaro.org>
---
 drivers/char/hw_random/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 17854f052386..e0244a66366b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -579,10 +579,10 @@ config HW_RANDOM_ARM_SMCCC_TRNG
 	  module will be called arm_smccc_trng.
 
 config HW_RANDOM_CN10K
-       tristate "Marvell CN10K Random Number Generator support"
-       depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
-       default HW_RANDOM if ARCH_THUNDER
-       help
+	tristate "Marvell CN10K Random Number Generator support"
+	depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
+	default HW_RANDOM if ARCH_THUNDER
+	help
 	 This driver provides support for the True Random Number
 	 generator available in Marvell CN10K SoCs.
 
