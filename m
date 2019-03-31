Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C84C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0650721726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="qBvMAxNw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbfCaDQJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:16:09 -0400
Received: from mail.nic.cz ([217.31.204.67]:37859 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbfCaDPm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:42 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id EE1DE63521;
        Sun, 31 Mar 2019 05:15:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002139; bh=B/TpvfHvTFNpjJx5rPCicAY3K4ayOqi1nl+RinKdt/c=;
        h=From:To:Date;
        b=qBvMAxNwiyTXYOSuGx4V+2qFuDjYwBt78d+vApTKcq1ZuFZVzuXlsqdl5XiOKw/8y
         T2+xcyVRHgyzyeIx5YssXi7Tngq7BpFbWEQcWDQGzEA7Gsrae4v/0647fx0q7Ybj5t
         W8bX/9WERKph68kpwDKmkBJWbHuT4HervFLRSYg8=
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
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 1/6] dt-bindings: mailbox: Document armada-3700-rwtm-mailbox binding
Date:   Sun, 31 Mar 2019 05:15:32 +0200
Message-Id: <20190331031537.10626-2-marek.behun@nic.cz>
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

This adds device tree binding documentation for the rWTM BIU mailbox
driver on the Armada 37xx SOC (EspressoBin, Turris Mox).

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../mailbox/marvell,armada-3700-rwtm-mailbox.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/marvell,armada-3700-rwtm-mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/marvell,armada-3700-rwtm-mailbox.txt b/Documentation/devicetree/bindings/mailbox/marvell,armada-3700-rwtm-mailbox.txt
new file mode 100644
index 000000000000..282ab81a4ea6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/marvell,armada-3700-rwtm-mailbox.txt
@@ -0,0 +1,16 @@
+* rWTM BIU Mailbox driver for Armada 37xx
+
+Required properties:
+- compatible:	must be "marvell,armada-3700-rwtm-mailbox"
+- reg:		physical base address of the mailbox and length of memory mapped
+		region
+- interrupts:	the IRQ line for the mailbox
+- #mbox-cells:	must be 1
+
+Example:
+	rwtm: mailbox@b0000 {
+		compatible = "marvell,armada-3700-rwtm-mailbox";
+		reg = <0xb0000 0x100>;
+		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+		#mbox-cells = <1>;
+	};
-- 
2.19.2

