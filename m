Return-Path: <SRS0=MPTL=A2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DF0C433EC
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 15:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257542071B
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jul 2020 15:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgGOP1a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:27:30 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33086 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgGOP1S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jul 2020 11:27:18 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 813111A0BD9;
        Wed, 15 Jul 2020 17:27:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 741031A048B;
        Wed, 15 Jul 2020 17:27:15 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 97F0C2035C;
        Wed, 15 Jul 2020 17:27:14 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] dt-bindings: rng: add RNGB compatibles for i.MX6 SoCs
Date:   Wed, 15 Jul 2020 18:26:00 +0300
Message-Id: <20200715152604.10407-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715152604.10407-1-horia.geanta@nxp.com>
References: <20200715152604.10407-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RNGB block is found in some i.MX6 SoCs - 6SL, 6SLL, 6ULL, 6ULZ.
Add corresponding compatible strings.

Note:

Several NXP SoC from QorIQ family (P1010, P1023, P4080, P3041, P5020)
also have a RNGB, however it's part of the CAAM
(Cryptograhic Accelerator and Assurance Module) crypto accelerator.
In this case, RNGB is managed in the caam driver
(drivers/crypto/caam/), since it's tightly related to
the caam "job ring" interface, not to mention CAAM internally relying on
RNGB as source of randomness.

On the other hand, the i.MX6 SoCs with RNGB have a DCP
(Data Co-Processor) crypto accelerator and this block and RNGB
are independent.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/rng/imx-rng.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/imx-rng.txt b/Documentation/devicetree/bindings/rng/imx-rng.txt
index 405c2b00ccb0..659d4efdd664 100644
--- a/Documentation/devicetree/bindings/rng/imx-rng.txt
+++ b/Documentation/devicetree/bindings/rng/imx-rng.txt
@@ -5,6 +5,9 @@ Required properties:
                "fsl,imx21-rnga"
                "fsl,imx31-rnga" (backward compatible with "fsl,imx21-rnga")
                "fsl,imx25-rngb"
+               "fsl,imx6sl-rngb" (backward compatible with "fsl,imx25-rngb")
+               "fsl,imx6sll-rngb" (backward compatible with "fsl,imx25-rngb")
+               "fsl,imx6ull-rngb" (backward compatible with "fsl,imx25-rngb")
                "fsl,imx35-rngc"
 - reg : offset and length of the register set of this block
 - interrupts : the interrupt number for the RNG block
-- 
2.17.1

