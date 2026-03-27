Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE4395276;
	Fri, 27 Mar 2026 20:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642274; cv=none; b=AtPT011aqnn32aYNfJknMVh6EllcDP/kU3+qncPUQZdgZ1MUFxKXGrfTNZjpn0sQyAEvQd5IsmIWs6YVW6j1IRF+ZZZj0ZRJybhLD/W/2UJOd7i5Isf4NAy2vnO5pHF3MYRBZD+2iUjXptABajSV9t9HdIXOP84ZagIY+o0e7aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642274; c=relaxed/simple;
	bh=DN7wXHstW0a9Eh6qCjSIqfRfPKM+Y2CDrcIA4SlXgdc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ENwOnfH5mVf/oWA1BT1LmPeqcZfhN2mk5FYwf8hUKj6qLXCwSJOkPyUbb3pCtt+MDJNMypHPWdHVXP4iaXPGA0I2LdtV9YNMbinq9EDgZewYG8SlP39YeDe1l/2OPIFvaO7bF51OlZ1NFLmZerqE1jIyNN0G4qcuLTrq6bZVdxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DaemZSFK; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DaemZSFK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id C93671A3033;
	Fri, 27 Mar 2026 20:11:11 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9F69960268;
	Fri, 27 Mar 2026 20:11:11 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A7B3610451AF7;
	Fri, 27 Mar 2026 21:11:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642270; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=U5hIhzF+ik0my8XUFw36mXDKRSbF8EqUsA35jiAXhuk=;
	b=DaemZSFK1ljRDABW16g6POqTJ8KJoTvF1UnN7wETtZ3356iAEDkuIj96uD7xXcxmOKduqZ
	tYivP1ewmu+UG8UadV5OnSDtJ1+qzh0vPldc3gRPn8c8fs34NdHXo/c1tWzViHTtXbuUiQ
	4QqEaZCi2H9oyxgIty/wMpyAzybSw1ptDGrjmIWQnozTHSsK9sSFUI/+lhbuOSayCVwfjE
	YxzpZJM9nCzlUX4im1MH1x8SBWtq/XpqMV6xM7rRokf3mtMX4XePk8U9ByL07J6LYY6am2
	0nqSbxnP3Vot2xIVRnr8iE774nYaMRf5xYfMfDtAV5uWRb8cxpED0qgWtWA6TA==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:36 +0100
Subject: [PATCH 14/16] crypto: Group Inside-Secure IPs together and align
 the titles
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-14-5e6ff7853994@bootlin.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jayesh Choudhary <j-choudhary@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

There are several drivers from the SafeXcel family already, the EIP-93,
the EIP-97 and EIP-197. We will soon also have the EIP-28.

Group them in the Kconfig menu and both titles to make explicit that
these components are from the same family and mimic the string used for
the Intel components (above in the menu).

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 drivers/crypto/Kconfig                     | 45 +++++++++++++++---------------
 drivers/crypto/inside-secure/eip93/Kconfig |  2 +-
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8..b3a6bbf0aacf 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -782,28 +782,6 @@ config CRYPTO_DEV_BCM_SPU
 
 source "drivers/crypto/stm32/Kconfig"
 
-config CRYPTO_DEV_SAFEXCEL
-	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on (OF || PCI || COMPILE_TEST) && HAS_IOMEM
-	select CRYPTO_LIB_AES
-	select CRYPTO_AUTHENC
-	select CRYPTO_SKCIPHER
-	select CRYPTO_LIB_DES
-	select CRYPTO_HASH
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
-	select CRYPTO_CHACHA20POLY1305
-	select CRYPTO_SHA3
-	help
-	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
-	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
-	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
-	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
-	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.
-
 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
 	depends on ARM && (ARCH_ARTPEC || COMPILE_TEST)
@@ -876,6 +854,29 @@ config CRYPTO_DEV_SA2UL
 
 source "drivers/crypto/aspeed/Kconfig"
 source "drivers/crypto/starfive/Kconfig"
+
+config CRYPTO_DEV_SAFEXCEL
+	tristate "Support for Inside Secure's SafeXcel EIP-97/EIP-197"
+	depends on (OF || PCI || COMPILE_TEST) && HAS_IOMEM
+	select CRYPTO_LIB_AES
+	select CRYPTO_AUTHENC
+	select CRYPTO_SKCIPHER
+	select CRYPTO_LIB_DES
+	select CRYPTO_HASH
+	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select CRYPTO_CHACHA20POLY1305
+	select CRYPTO_SHA3
+	help
+	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
+	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
+	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
+	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
+	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.
+
 source "drivers/crypto/inside-secure/eip93/Kconfig"
 source "drivers/crypto/ti/Kconfig"
 
diff --git a/drivers/crypto/inside-secure/eip93/Kconfig b/drivers/crypto/inside-secure/eip93/Kconfig
index 8353d3d7ec9b..8a671b709a11 100644
--- a/drivers/crypto/inside-secure/eip93/Kconfig
+++ b/drivers/crypto/inside-secure/eip93/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 config CRYPTO_DEV_EIP93
-	tristate "Support for EIP93 crypto HW accelerators"
+	tristate "Support for Inside Secure's SafeXcel EIP93"
 	depends on SOC_MT7621 || ARCH_AIROHA ||COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_DES

-- 
2.51.1

