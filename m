Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC24EC43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A99DA21726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="Se/2+3er"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbfCaDPl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:15:41 -0400
Received: from mail.nic.cz ([217.31.204.67]:37873 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbfCaDPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:41 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 2215D635D4;
        Sun, 31 Mar 2019 05:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002139; bh=K8ZClC8lq/LMOr9HmDpgfWCKd0LITZAPiREs/Lcu0XI=;
        h=From:To:Date;
        b=Se/2+3erFBeXUaFXUlh7LhSvYSJSFmd55TBQKppGgNX4lt+MUPmC3xlH2fm+DYAbl
         abWeXME8QvsKYEyPzJJ87BTQLy5SGWdXSfVpAAaYmiI5dh7t4JGnQBqXbOv0YRHxPk
         Z5ntKBl5qlnfC7vJrPbbpH0oqOsBY5JCAaKtq6J8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Jassi Brar <jassisinghbrar@gmail.com>
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 3/6] arm64: dts: marvell: armada-37xx: add mailbox node
Date:   Sun, 31 Mar 2019 05:15:34 +0200
Message-Id: <20190331031537.10626-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190331031537.10626-1-marek.behun@nic.cz>
References: <20190331031537.10626-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.99.2 at mail
X-Virus-Status: Clean
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds the rWTM BIU mailbox node for communication with the secure
processor.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index f43c43168b00..7f69e3dfcb13 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -419,6 +419,13 @@
 				clocks = <&nb_periph_clk 15>;
 			};
 
+			rwtm: mailbox@b0000 {
+				compatible = "marvell,armada-3700-rwtm-mailbox";
+				reg = <0xb0000 0x100>;
+				interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+				#mbox-cells = <1>;
+			};
+
 			sdhci1: sdhci@d0000 {
 				compatible = "marvell,armada-3700-sdhci",
 					     "marvell,sdhci-xenon";
-- 
2.19.2

