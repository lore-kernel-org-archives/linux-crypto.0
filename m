From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/4] crypto: caam - add Job Ring support for DPAA2 parts
Date: Tue, 18 Jul 2017 18:30:46 +0300
Message-ID: <20170718153050.15330-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0052.outbound.protection.outlook.com ([104.47.33.52]:18723
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751338AbdGRPbX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 11:31:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for CAAM's legacy Job Ring backend / interface
on platforms having DPAA2 (Datapath Acceleration Architecture v2), like
LS1088A or LS2088A.

I would like to get the DT patches through the crypto list (to make sure
they don't end up merged before driver support).

Thanks,
Horia

Horia Geantă (4):
  crypto: caam/jr - add support for DPAA2 parts
  arm64: dts: freescale: ls208xa: share aliases node
  arm64: dts: freescale: ls208xa: add crypto node
  arm64: dts: freescale: ls1088a: add crypto node

 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     | 43 ++++++++++++
 arch/arm64/boot/dts/freescale/fsl-ls2080a-qds.dts  |  5 --
 arch/arm64/boot/dts/freescale/fsl-ls2080a-rdb.dts  |  5 --
 arch/arm64/boot/dts/freescale/fsl-ls2080a-simu.dts |  5 --
 arch/arm64/boot/dts/freescale/fsl-ls2088a-qds.dts  |  5 --
 arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts  |  5 --
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     | 46 ++++++++++++
 drivers/crypto/caam/caamhash.c                     |  7 +-
 drivers/crypto/caam/ctrl.c                         | 45 +++++++-----
 drivers/crypto/caam/ctrl.h                         |  2 +
 drivers/crypto/caam/jr.c                           |  7 +-
 drivers/crypto/caam/regs.h                         |  1 +
 drivers/crypto/caam/sg_sw_qm2.h                    | 81 ++++++++++++++++++++++
 drivers/crypto/caam/sg_sw_sec4.h                   | 30 ++++++--
 14 files changed, 237 insertions(+), 50 deletions(-)
 create mode 100644 drivers/crypto/caam/sg_sw_qm2.h

-- 
2.12.0.264.gd6db3f216544
