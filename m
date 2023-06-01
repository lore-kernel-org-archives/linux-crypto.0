Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398A4C77B7E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjFAKTS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjFAKSg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:18:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C481210D
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 03:16:00 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKZ-0004WP-69; Thu, 01 Jun 2023 12:14:55 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKY-004KWR-A3; Thu, 01 Jun 2023 12:14:54 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1q4fKW-001V4T-N5; Thu, 01 Jun 2023 12:14:52 +0200
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
Subject: [PATCH v1 6/7] dt-bindings: clock: imx6q: Allow single optional clock and add enet_ref_pad
Date:   Thu,  1 Jun 2023 12:14:50 +0200
Message-Id: <20230601101451.357662-7-o.rempel@pengutronix.de>
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

All clocks for this driver are optional, so this change allows the
'clocks' and 'clock-names' properties to accept a single clock.
Additionally, 'enet_ref_pad' clock is added. This resolves the following
dtbs_check warning:
  imx6dl-alti6p.dtb: clock-controller@20c4000: clocks: [[24]] is too short
  From schema: Documentation/devicetree/bindings/clock/imx6q-clock.yaml

  imx6dl-alti6p.dtb: clock-controller@20c4000: clock-names:0: 'osc' was
    expected
  From schema: Documentation/devicetree/bindings/clock/imx6q-clock.yaml

  imx6dl-alti6p.dtb: clock-controller@20c4000: clock-names:
    ['enet_ref_pad'] is too short
  From schema: Documentation/devicetree/bindings/clock/imx6q-clock.yaml

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/clock/imx6q-clock.yaml    | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
index bae4fcb3aacc..ed65d19c2e0e 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.yaml
@@ -28,20 +28,23 @@ properties:
     const: 1
 
   clocks:
+    minItems: 1
     items:
       - description: 24m osc
       - description: 32k osc
       - description: ckih1 clock input
       - description: anaclk1 clock input
       - description: anaclk2 clock input
+      - description: enet_ref_pad
 
   clock-names:
-    items:
-      - const: osc
-      - const: ckil
-      - const: ckih1
-      - const: anaclk1
-      - const: anaclk2
+    enum:
+      - osc
+      - ckil
+      - ckih1
+      - anaclk1
+      - anaclk2
+      - enet_ref_pad
 
   fsl,pmic-stby-poweroff:
     $ref: /schemas/types.yaml#/definitions/flag
-- 
2.39.2

