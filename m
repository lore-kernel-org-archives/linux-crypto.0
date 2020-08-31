Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B77C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77D2207BB
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHaHcE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 03:32:04 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41448 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgHaHcD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 03:32:03 -0400
Received: from ubuntu1804.c-home.cz (intra-239.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07V7VPlI005879;
        Mon, 31 Aug 2020 09:31:36 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 2/3] ARM: dts: sun8i: v3s: Enable crypto engine
Date:   Mon, 31 Aug 2020 09:31:00 +0200
Message-Id: <20200831073101.3608-3-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831073101.3608-1-m.cerveny@computer.org>
References: <20200831073101.3608-1-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

V3s contains crypto engine that is compatible with "sun4i-ss".

Tested-by: Martin Cerveny <m.cerveny@computer.org>
Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
---
 arch/arm/boot/dts/sun8i-v3s.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

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
-- 
2.17.1

