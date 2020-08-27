Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E974C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 18:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147DB22B4D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 18:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgH0SPJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 14:15:09 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41069 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgH0SPJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 14:15:09 -0400
X-Greylist: delayed 799 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 14:15:08 EDT
Received: from localhost.localdomain (intra-239.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07RI0T1G020164;
        Thu, 27 Aug 2020 20:00:34 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     clabbe.montjoie@gmail.com
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, mripard@kernel.org, wens@csie.org,
        m.cerveny@computer.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: sun8i: v3s: Enable crypto engine
Date:   Thu, 27 Aug 2020 20:00:27 +0200
Message-Id: <20200827180027.6254-1-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

V3S contains crypto engine that is compatible with "sun4i-ss".

Tested-by: Martin Cerveny <m.cerveny@computer.org>
Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
---
 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml    |  5 ++++-
 arch/arm/boot/dts/sun8i-v3s.dtsi                       | 10 ++++++++++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c      |  7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index fc823572b..180efd13a 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -25,6 +25,7 @@ properties:
           - const: allwinner,sun4i-a10-crypto
       - items:
           - const: allwinner,sun8i-a33-crypto
+      - const: allwinner,sun8i-v3s-crypto
 
   reg:
     maxItems: 1
@@ -59,7 +60,9 @@ if:
   properties:
     compatible:
       contains:
-        const: allwinner,sun6i-a31-crypto
+        oneOf:
+          - const: allwinner,sun6i-a31-crypto
+          - const: allwinner,sun8i-v3s-crypto
 
 then:
   required:
diff --git a/arch/arm/boot/dts/sun8i-v3s.dtsi b/arch/arm/boot/dts/sun8i-v3s.dtsi
index e5312869c..4fec84c40 100644
--- a/arch/arm/boot/dts/sun8i-v3s.dtsi
+++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
@@ -234,6 +234,16 @@
 			#size-cells = <0>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-v3s-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "ahb", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "ahb";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-h3-musb";
 			reg = <0x01c19000 0x0400>;
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index a2b67f7f8..d24496cac 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -31,6 +31,10 @@ static const struct ss_variant ss_a33_variant = {
 	.sha1_in_be = true,
 };
 
+static const struct ss_variant ss_v3s_variant = {
+	.sha1_in_be = true,
+};
+
 static struct sun4i_ss_alg_template ss_algs[] = {
 {       .type = CRYPTO_ALG_TYPE_AHASH,
 	.mode = SS_OP_MD5,
@@ -505,6 +509,9 @@ static const struct of_device_id a20ss_crypto_of_match_table[] = {
 	{ .compatible = "allwinner,sun8i-a33-crypto",
 	  .data = &ss_a33_variant
 	},
+	{ .compatible = "allwinner,sun8i-v3s-crypto",
+	  .data = &ss_v3s_variant
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
-- 
2.17.1

