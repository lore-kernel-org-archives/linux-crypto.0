Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC37C76194
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 15:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F19B204FD
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 15:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfGVPUc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 11:20:32 -0400
Received: from 212.199.177.27.static.012.net.il ([212.199.177.27]:39700 "EHLO
        herzl.nuvoton.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727036AbfGVPUc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 11:20:32 -0400
Received: from taln60.nuvoton.co.il (ntil-fw [212.199.177.25])
        by herzl.nuvoton.co.il (8.13.8/8.13.8) with ESMTP id x6MF2ida032710;
        Mon, 22 Jul 2019 18:02:44 +0300
Received: by taln60.nuvoton.co.il (Postfix, from userid 10070)
        id 50F9361FD3; Mon, 22 Jul 2019 18:02:44 +0300 (IDT)
From:   Tomer Maimon <tmaimon77@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, openbmc@lists.ozlabs.org,
        Tomer Maimon <tmaimon77@gmail.com>
Subject: [PATCH v1 1/2] dt-binding: hwrng: add NPCM RNG documentation
Date:   Mon, 22 Jul 2019 18:02:40 +0300
Message-Id: <20190722150241.345609-2-tmaimon77@gmail.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190722150241.345609-1-tmaimon77@gmail.com>
References: <20190722150241.345609-1-tmaimon77@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added device tree binding documentation for Nuvoton BMC
NPCM Random Number Generator (RNG).

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
---
 .../bindings/rng/nuvoton,npcm-rng.txt           | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
new file mode 100644
index 000000000000..a697b4425fb3
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
@@ -0,0 +1,17 @@
+NPCM SoC Random Number Generator
+
+Required properties:
+- compatible  : "nuvoton,npcm750-rng" for the NPCM7XX BMC.
+- reg         : Specifies physical base address and size of the registers.
+
+Optional property:
+- quality : estimated number of bits of true entropy per 1024 bits
+			read from the rng.
+			If this property is not defined, it defaults to 1000.
+
+Example:
+
+rng: rng@f000b000 {
+	compatible = "nuvoton,npcm750-rng";
+	reg = <0xf000b000 0x8>;
+};
-- 
2.18.0

