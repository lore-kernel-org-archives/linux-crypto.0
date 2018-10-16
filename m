Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:19693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbeJPXsu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:50 -0400
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
Subject: [PATCH v3 0/4] Port mxs-dcp to imx6ull and imx6sll
Date: Tue, 16 Oct 2018 15:57:40 +0000
Message-ID: <cover.1539705285.git.leonard.crestez@nxp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DCP block is present on 6sll and 6ull but not enabled. The hardware is
mostly compatible with 6sl, the only important difference is that explicit
clock enabling is required.

There were several issues with the functionality of this driver (it didn't
even probe properly) but they are fixed in cryptodev/master by this series:
    https://lore.kernel.org/patchwork/cover/994874/

---
Changes since v2:
 * Rename 6ull dcp node to crypto@*
 * Use clk_prepare_enable on probe
 * Fix not unpreparing on remove
 * Realign dcp_clk struct member with rest of attributes (using tabs)
 * Link to v2: https://lore.kernel.org/patchwork/cover/999795/

Changes since v1:
 * Add devicetree maintainers for dt-bindings
 * Add a patch enabling in imx_v6_v7_defconfig. Since tcrypt now passes thi=
s
shouldn't cause any issues
 * Link to v1: https://lore.kernel.org/patchwork/cover/994893/

Leonard Crestez (4):
  dt-bindings: crypto: Mention clocks for mxs-dcp
  crypto: mxs-dcp - Add support for dcp clk
  ARM: dts: imx6ull: Add dcp node
  ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP

 .../devicetree/bindings/crypto/fsl-dcp.txt        |  2 ++
 arch/arm/boot/dts/imx6ull.dtsi                    | 10 ++++++++++
 arch/arm/configs/imx_v6_v7_defconfig              |  1 +
 drivers/crypto/mxs-dcp.c                          | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

--=20
2.17.1
