Return-Path: <SRS0=pvly=O5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:39789 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbeLTP2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Dec 2018 10:28:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam/qi2 - add a CRYPTO_DEV_FSL_CAAM dependency
Date: Thu, 20 Dec 2018 16:28:08 +0100
Message-Id: <20181220152815.3613164-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

My previous bugfix was incomplete, we still have a broken kernel
with CRYPTO_DEV_FSL_CAAM=m and CRYPTO_DEV_FSL_DPAA2_CAAM=y:

drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_encap':
caamalg_desc.c:(.text+0x14): undefined reference to `caam_little_end'
drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_encap':
caamalg_desc.c:(.text+0x310): undefined reference to `caam_imx'
caamalg_desc.c:(.text+0x4a8): undefined reference to `caam_little_end'
drivers/crypto/caam/caamalg_desc.o: In function `cnstr_shdsc_aead_null_encap':
caamalg_desc.c:(.text+0x664): undefined reference to `caam_imx'

Everything is fine for the other combinations: if both are loadable
modules, or both are built-in, the flags work as expected, also if
only one of the two is enabled.

Add a dependency to enforce using one of the working configurations.
Overall, I'm still not happy with that dependency, but for now
it documents what the code requires.

Fixes: 52813ab24959 ("crypto: caam/qi2 - avoid double export")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/caam/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index c4b1cade55c1..4dff65e518e7 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -158,6 +158,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	tristate "QorIQ DPAA2 CAAM (DPSECI) driver"
 	depends on FSL_MC_DPIO
 	depends on NETDEVICES
+	depends on CRYPTO_DEV_FSL_CAAM || !CRYPTO_DEV_FSL_CAAM
 	select CRYPTO_DEV_FSL_CAAM_COMMON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
-- 
2.20.0
