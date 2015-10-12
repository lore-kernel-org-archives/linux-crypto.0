From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: mxs-dcp is an stmp device
Date: Mon, 12 Oct 2015 15:52:34 +0200
Message-ID: <6543300.PJNp8A08gY@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Vasut <marex@denx.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57222 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbJLNxH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 09:53:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The mxs-dcp driver relies on the stmp_reset_block() helper function, which
is provided by CONFIG_STMP_DEVICE. This symbol is always set on MXS,
but the driver can now also be built for MXC (i.MX6), which results
in a built error if no other driver selects STMP_DEVICE:

drivers/built-in.o: In function `mxs_dcp_probe':
vf610-ocotp.c:(.text+0x3df302): undefined reference to `stmp_reset_block'

This adds the 'select', like all other stmp drivers have it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: a2712e6c75f ("crypto: mxs-dcp - Allow MXS_DCP to be used on MX6SL")

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab7e3b668890..2569e043317e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -430,6 +430,7 @@ endif
 config CRYPTO_DEV_MXS_DCP
 	tristate "Support for Freescale MXS DCP"
 	depends on (ARCH_MXS || ARCH_MXC)
+	select STMP_DEVICE
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_AES
