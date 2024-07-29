Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFA17407A;
	Mon, 29 Jul 2024 11:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722253025; cv=none; b=rnVWVf4Y21wPJk1bpsuxS27cSI17iiviZ+8DzhC9IUw/hvuWihPyH6RE7JpYwvR57+GVF4pIIC/gF5BCIKJR2Mz5wM6n4ytRJbkcF8OGKA0enYXT6qCGwo3Tz/QjoyDwuYquKetMzzWbTlCA50vWUe+7TyPgbnNp2qY3t3wOjJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722253025; c=relaxed/simple;
	bh=1W5UIcdPoK+NePJMJieDHP1eAe7EME5he1r83areTWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H7wCl6AHgiJ5jS/wwzBvkt88JNYBFlelpXGr7qadYqyJRui06bRd2ZGcndUxSolYQH9DOwkgCcOGTamxtc94kOVfglxydcJ47shaiiKdsdj5+Er2Jz940ObubKA3z8eyhJkdxJX+UutVBM+G67wgAptEPFEl9Oi9TAebcHneVa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ZvJ/tYUA; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ZvJ/tYUA"
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id B43031F920;
	Mon, 29 Jul 2024 13:36:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1722253010;
	bh=K/bo3Ipb62C2hODBX6nyPyGkbUhr+aMg0fKTyQeqMk8=; h=From:To:Subject;
	b=ZvJ/tYUACGsAbiJwo2U7CwjVBTdFyG3JUaa6xSBrYFj4y2ZGUdW6izwC8lqq7El0b
	 RnB1+O59A++PfrN29l33e3LjStcXHivKmwlV37JEOPSgJIvSifiN3uO/LEFJzqewu8
	 G8R7SBDezYKKQ2+NuPuRTpresr5sgOiPKJz3ShCVouIneJ82TVqDJtLvJOgJLkvEV0
	 IBhVuOrQTfUfprGHqetrUhHR/kAA+pggfo7+2Gn7SHI8tpDlHcBAtmqGB272TuJugY
	 YFKLGWFQg/bJ1g4/9QZppX0NHlm1TtY846EjJHOZcb6clFvoVpFj6BGNHlFl0VZfpe
	 59xsKD7BiG7Iw==
From: Francesco Dolcini <francesco@dolcini.it>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Francesco Dolcini <francesco.dolcini@toradex.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH v1] hwrng: Kconfig - Enable by default CN10K driver if Thunder SoC is enabled
Date: Mon, 29 Jul 2024 13:36:40 +0200
Message-Id: <20240729113640.36031-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Before commit addea5858b66 ("hwrng: Kconfig - Do not enable by default
CN10K driver") the Marvell CN10K Random Number Generator was always
enabled when HW_RANDOM was enabled.

This was changed with that commit to prevent having this driver being
always enabled on arm64. To prevent introducing regression with some old
defconfig enable the driver when ARCH_THUNDER is enabled.

Fixes: addea5858b66 ("hwrng: Kconfig - Do not enable by default CN10K driver")
Closes: https://lore.kernel.org/all/SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 01e2e1ef82cf..ae5f3a01f554 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -555,6 +555,7 @@ config HW_RANDOM_ARM_SMCCC_TRNG
 config HW_RANDOM_CN10K
        tristate "Marvell CN10K Random Number Generator support"
        depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
+       default HW_RANDOM if ARCH_THUNDER
        help
 	 This driver provides support for the True Random Number
 	 generator available in Marvell CN10K SoCs.
-- 
2.39.2

