Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A38C77B7E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjFAKTp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjFAKTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:19:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFBA1720
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 03:16:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKZ-0004We-8g; Thu, 01 Jun 2023 12:14:55 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKY-004KWW-JW; Thu, 01 Jun 2023 12:14:54 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKW-001V4J-ME; Thu, 01 Jun 2023 12:14:52 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        Peng Fan <peng.fan@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Mark Brown <broonie@kernel.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Anson Huang <Anson.Huang@nxp.com>, Marek Vasut <marex@denx.de>,
        linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH v1 5/7] dt-bindings: clock: imx6ul: Support optional enet*_ref_pad clocks
Date:   Thu,  1 Jun 2023 12:14:49 +0200
Message-Id: <20230601101451.357662-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601101451.357662-1-o.rempel@pengutronix.de>
References: <20230601101451.357662-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend the 'clocks' and 'clock-names' properties to support optional
'enet1_ref_pad' and 'enet2_ref_pad' clocks to resolve the following
dtbs_check warning:
  imx6ul-prti6g.dtb: clock-controller@20c4000: clocks: [[17], [18], [19],
    [20], [21]] is too long
  From schema: Documentation/devicetree/bindings/clock/imx6ul-clock.yaml

  imx6ul-prti6g.dtb: clock-controller@20c4000: clock-names: ['ckil',
    'osc', 'ipp_di0', 'ipp_di1', 'enet1_ref_pad'] is too long
  From schema: Documentation/devicetree/bindings/clock/imx6ul-clock.yaml

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 Documentation/devicetree/bindings/clock/imx6ul-clock.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
index be54d4df5afa..d6a36fe575d3 100644
--- a/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6ul-clock.yaml
@@ -28,18 +28,24 @@ properties:
     const: 1
 
   clocks:
+    minItems: 4
     items:
       - description: 32k osc
       - description: 24m osc
       - description: ipp_di0 clock input
       - description: ipp_di1 clock input
+      - description: Optional lenet1_ref_pad or enet2_ref_pad clocks
+      - description: Optional lenet1_ref_pad or enet2_ref_pad clocks
 
   clock-names:
+    minItems: 4
     items:
       - const: ckil
       - const: osc
       - const: ipp_di0
       - const: ipp_di1
+      - enum: [enet1_ref_pad, enet2_ref_pad]
+      - enum: [enet1_ref_pad, enet2_ref_pad]
 
 required:
   - compatible
-- 
2.39.2

