Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:2145
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727203AbeKHBEZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 20:04:25 -0500
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
Subject: [RESEND 1/2] dt-bindings: crypto: Mention clocks for mxs-dcp
Date: Wed, 7 Nov 2018 15:33:31 +0000
Message-ID: <e745d22e342726be9a96c2993d8a279d6c5dac6a.1541604742.git.leonard.crestez@nxp.com>
References: <cover.1541604742.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1541604742.git.leonard.crestez@nxp.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Explicit clock enabling is required on 6sll and 6ull so mention that
standard clock bindings are used.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/crypto/fsl-dcp.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt b/Documen=
tation/devicetree/bindings/crypto/fsl-dcp.txt
index 76a0b4e80e83..4e4d387e38a5 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
@@ -4,10 +4,12 @@ Required properties:
 - compatible : Should be "fsl,<soc>-dcp"
 - reg : Should contain MXS DCP registers location and length
 - interrupts : Should contain MXS DCP interrupt numbers, VMI IRQ and DCP I=
RQ
                must be supplied, optionally Secure IRQ can be present, but
 	       is currently not implemented and not used.
+- clocks : Clock reference (only required on some SOCs: 6ull and 6sll).
+- clock-names : Must be "dcp".
=20
 Example:
=20
 dcp@80028000 {
 	compatible =3D "fsl,imx28-dcp", "fsl,imx23-dcp";
--=20
2.17.1
