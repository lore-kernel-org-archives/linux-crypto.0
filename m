Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539DB176AC2
	for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2024 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719417455; cv=none; b=UjqQq6oE14GN/5sc4LvPEhplcBWShGWdax2fytbcIHZRMS27WBMeGiYyVlpnLopEbQyvR6KRrtDgcrKHgGDyTLUbXvusvyYxUR+CFd+62N+Q1YBEeJ2UelNUeu+4kA+7vI53YWt8cIw8QCXFJL2ftM4qKug9eno2A4Xbyg+yfH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719417455; c=relaxed/simple;
	bh=yvRja6TVvkxVgeMuQeeWaRBUJSNhWfzJj0oLDOwcKro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m0YQ5XnUCEASZe9zSiVbqalgad/8Z2IvkBA/C6Bhjc6fLsT3nsCPsvH55dZxrjcI0ZaPWwJPOG1qNjHm59afMLFnvVbF/RziB2b6NntvnjAYVmymDR39TLSJs54JWyywQoA60o4Yp1ZN8OLGh70dzOZywBog9a15QbZsj4ypSWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <m.felsch@pengutronix.de>)
	id 1sMV1X-0003mB-6v; Wed, 26 Jun 2024 17:57:31 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: "horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, Herbert Xu" <herbert@gondor.apana.org.au>
Cc: kernel@pengutronix.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam - enable hash api only on ARM platforms per default
Date: Wed, 26 Jun 2024 17:57:23 +0200
Message-Id: <20240626155724.4045056-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

Tests showed that ARMv8-A crypto extensions as implemented on the ARM
Cortex-A53 on the i.MX8M family of processors are substantially faster
than the same primitives offered by the CAAM.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index c631f99e415f..5828ac64c988 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -126,7 +126,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
 
 config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	bool "Register hash algorithm implementations with Crypto API"
-	default y
+	default y if ARM
 	select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
 	select CRYPTO_HASH
 	help
-- 
2.39.2

