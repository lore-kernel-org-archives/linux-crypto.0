Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74187C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B70F21726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="tyPRLXWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfCaDPl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:15:41 -0400
Received: from mail.nic.cz ([217.31.204.67]:37882 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731065AbfCaDPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:41 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 3D82F635EA;
        Sun, 31 Mar 2019 05:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002139; bh=ilqL0T1bXVJ2WTz11GZd56/0564HlruHA/JJZss7ZIc=;
        h=From:To:Date;
        b=tyPRLXWJSGta2VUS9CsvfFjiqbJhq0CdHZSlFnI4sn/16HpJiXHfvJZKe0EGxBrXo
         qLJ1MkFubGg2ECOfwC/AN6JWF117mTFaBO98rhJudl5uvI5N0FshBRF73lS2D9K74l
         l+RVha0FdpsOhgh0yMn09n7/tAJtf+fjQwGDMwvo=
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
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 4/6] dt-bindings: firmware: Document cznic,turris-mox-rwtm binding
Date:   Sun, 31 Mar 2019 05:15:35 +0200
Message-Id: <20190331031537.10626-5-marek.behun@nic.cz>
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

This adds device tree binding documentation for the driver communicating
with the rWTM firmware on Turris Mox.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../firmware/cznic,turris-mox-rwtm.txt        | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt

diff --git a/Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt b/Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt
new file mode 100644
index 000000000000..338169dea7bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt
@@ -0,0 +1,19 @@
+Turris Mox rWTM firmware driver
+
+Required properties:
+ - compatible		: Should be "cznic,turris-mox-rwtm"
+ - mboxes		: Must contain a reference to associated mailbox
+
+This device tree node should be used on Turris Mox, or potentially another A3700
+compatible device running the Mox's rWTM firmware in the secure processor (for
+example it is possible to flash this firmware into EspressoBin).
+
+Example:
+
+	firmware {
+		turris-mox-rwtm {
+			compatible = "cznic,turris-mox-rwtm";
+			mboxes = <&rwtm 0>;
+			status = "okay";
+		};
+	};
-- 
2.19.2

