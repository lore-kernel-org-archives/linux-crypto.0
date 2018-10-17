Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:8163
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727292AbeJQUd2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:28 -0400
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
Subject: [PATCH v4 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Date: Wed, 17 Oct 2018 12:37:51 +0000
Message-ID: <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539779579.git.leonard.crestez@nxp.com>
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
