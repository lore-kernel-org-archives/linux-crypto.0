Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:2145
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbeKHBEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 20:04:24 -0500
From: Leonard Crestez <leonard.crestez@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller " <davem@davemloft.net>,
        Marek Vasut <marek.vasut@gmail.com>
CC: Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND 0/2] Port mxs-dcp to imx6ull and imx6sll
Date: Wed, 7 Nov 2018 15:33:30 +0000
Message-ID: <cover.1541604742.git.leonard.crestez@nxp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DCP block is present on 6sll and 6ull but not enabled. The hardware is
mostly compatible with 6sl, the only important difference is that explicit
clock enabling is required.

All patches already have review tags from a few weeks ago. No changes
relative to v4: https://lore.kernel.org/patchwork/cover/1001134/

Patches 3/4 were already accepted by Shawn Guo for the imx tree, this
resend is just for the crypto parts now that the merge window is over.

Leonard Crestez (2):
  dt-bindings: crypto: Mention clocks for mxs-dcp
  crypto: mxs-dcp - Add support for dcp clk

 .../devicetree/bindings/crypto/fsl-dcp.txt    |  2 ++
 drivers/crypto/mxs-dcp.c                      | 28 +++++++++++++++++--
 2 files changed, 27 insertions(+), 3 deletions(-)

--=20
2.17.1
