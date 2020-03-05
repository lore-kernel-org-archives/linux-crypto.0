Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42FDC3F2D8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 14:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74E52166E
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 14:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgCEN7m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:59:42 -0500
Received: from inva021.nxp.com ([92.121.34.21]:49196 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCEN7m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 08:59:42 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7E2462006FA;
        Thu,  5 Mar 2020 14:59:40 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 70B4820057C;
        Thu,  5 Mar 2020 14:59:40 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DDE322059D;
        Thu,  5 Mar 2020 14:59:39 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: dts: imx: use generic name for crypto node
Date:   Thu,  5 Mar 2020 15:59:04 +0200
Message-Id: <20200305135909.8180-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set aligns / fixes the naming of the crypto node
(and its child nodes) for sahara, dcp and caam crypto engines
used in i.MX SoCs.

Horia Geantă (4):
  dt-bindings: crypto: sahara: use generic node name
  dt-bindings: crypto: dcp: use generic node name
  dt-bindings: crypto: caam: use generic node name
  ARM: dts: imx: align name for crypto node and child nodes

Silvano di Ninno (1):
  arm64: dts: imx8mn: align name for crypto child nodes

 Documentation/devicetree/bindings/crypto/fsl-dcp.txt      | 2 +-
 .../devicetree/bindings/crypto/fsl-imx-sahara.txt         | 2 +-
 Documentation/devicetree/bindings/crypto/fsl-sec4.txt     | 2 +-
 arch/arm/boot/dts/imx23.dtsi                              | 2 +-
 arch/arm/boot/dts/imx27.dtsi                              | 2 +-
 arch/arm/boot/dts/imx28.dtsi                              | 2 +-
 arch/arm/boot/dts/imx6qdl.dtsi                            | 6 +++---
 arch/arm/boot/dts/imx6sl.dtsi                             | 2 +-
 arch/arm/boot/dts/imx6sll.dtsi                            | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi                             | 6 +++---
 arch/arm/boot/dts/imx6ul.dtsi                             | 8 ++++----
 arch/arm/boot/dts/imx7s.dtsi                              | 8 ++++----
 arch/arm/boot/dts/imx7ulp.dtsi                            | 4 ++--
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                 | 6 +++---
 14 files changed, 27 insertions(+), 27 deletions(-)

-- 
2.17.1

