Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ve1eur01on0040.outbound.protection.outlook.com ([104.47.1.40]:42912
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbeJQUdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:31 -0400
From: Leonard Crestez <leonard.crestez@nxp.com>
To: Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/4] ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP
Date: Wed, 17 Oct 2018 12:37:55 +0000
Message-ID: <5ba9a89b881f6ce816262ce52f431e32e7fb85a7.1539779579.git.leonard.crestez@nxp.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539779579.git.leonard.crestez@nxp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This block is present in 6sl, 6sll and 6ull so it should be enabled in
the default imx kernel config.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6=
_v7_defconfig
index 1ad5736c8fa6..57928dff9bce 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -428,10 +428,11 @@ CONFIG_NLS_ISO8859_1=3Dy
 CONFIG_NLS_ISO8859_15=3Dm
 CONFIG_NLS_UTF8=3Dy
 CONFIG_SECURITYFS=3Dy
 CONFIG_CRYPTO_DEV_FSL_CAAM=3Dy
 CONFIG_CRYPTO_DEV_SAHARA=3Dy
+CONFIG_CRYPTO_DEV_MXS_DCP=3Dy
 CONFIG_CRC_CCITT=3Dm
 CONFIG_CRC_T10DIF=3Dy
 CONFIG_CRC7=3Dm
 CONFIG_LIBCRC32C=3Dm
 CONFIG_FONTS=3Dy
--=20
2.17.1
