Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA96DCA9EBB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD3E420650
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSlRQWrU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391338AbfJWUK0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:10:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55954 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391312AbfJWUKZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:10:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id g24so273183wmh.5;
        Wed, 23 Oct 2019 13:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YeVIHo25aNxqgkPFtqlcHgTXA3cBcyk3epMZWtBEgr4=;
        b=CSlRQWrU1abnaj7duzwPLvaB3wvFZktGMyzXA4ZNgSqVbF1EE8voO5A1ZxKAxEIQ7E
         31NY8Yrr5V2EDd23obZF/8PsD+hbx+jv5AJUEsJl5jL8XN8qyKKh5TKTgo+0lEhprka5
         t6YeZBB6zUythbHjHTwW5Nhtr1uXBqa/RY75Qyiui6eEJ02b56N6Aaurpkl1FWB1lbfk
         r6PwNKZ7RQwglYL/kn98ieJf2rKPFn1gNjpQ9304vyqZKNwuAlWQD9rETQ3TTafOt/Dl
         PsBjoLvVjU1QrnLcmvI6I82ATgiGgQYsU4XWnT1JaPMJNfbwXnvPS+w26l5e0Od6XnyT
         GVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeVIHo25aNxqgkPFtqlcHgTXA3cBcyk3epMZWtBEgr4=;
        b=DigdIQD4hQnewz5CGFaV/P+TzlkPCA19fMY0sDMp9R0ZMW0rOiCYR9wR7+fL58KmCj
         nvsML/N3mg5To95yBELd6aMp4pgFC4RZgtbIEMXVZ0wHtIyyAfi/9uYw5LLJN2N46yG7
         aR+u0ecJHtWwsuFny/6zkYlz4oHYSEwr6VbsYnYYmVlHUxLKPoEnBTWjJ65E0P08uLhb
         dn5GJt3Gz5x9mVKmnHr4MKYwHnqEIKCjPvUV2DHDyBwncbOh00+Rz3QKs9W4bhM0k/EL
         tgD3G3DQYkFFqGKKo0A7knleKgEdKH/8ObfLTTGX1r0ctS7EHp+d+wJkaXzucJebamzw
         +hYg==
X-Gm-Message-State: APjAAAW+eMTsPj0KW16lRJRgWl1vmrI3LyHJ567uAkjud4H9KnQHoS8m
        ChnNcZ+SBmUddP9uuZzm3iGBZuES
X-Google-Smtp-Source: APXvYqy3VTLbFkblzNKQITLeEDXFOdssTr3+YocP/wu2kW9aOOPYQhEfer3K5vXbAsxW7BrlSM4Caw==
X-Received: by 2002:a1c:d8:: with SMTP id 207mr1464356wma.65.1571861422914;
        Wed, 23 Oct 2019 13:10:22 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id h17sm277261wmb.33.2019.10.23.13.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:10:22 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/4] dt-bindings: crypto: Add DT bindings documentation for sun8i-ss Security System
Date:   Wed, 23 Oct 2019 22:10:14 +0200
Message-Id: <20191023201016.26195-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
References: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings of the
Security System cryptographic offloader driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../bindings/crypto/allwinner,sun8i-ss.yaml   | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
new file mode 100644
index 000000000000..99b7736975bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ss.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner Security System v2 driver
+
+maintainers:
+  - Corentin Labbe <corentin.labbe@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - allwinner,sun8i-a83t-crypto
+      - allwinner,sun9i-a80-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Bus clock
+      - description: Module clock
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: bus
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/sun8i-a83t-ccu.h>
+    #include <dt-bindings/reset/sun8i-a83t-ccu.h>
+
+    crypto: crypto@1c15000 {
+      compatible = "allwinner,sun8i-a83t-crypto";
+      reg = <0x01c15000 0x1000>;
+      interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+      clock-names = "bus", "mod";
+      resets = <&ccu RST_BUS_SS>;
+      reset-names = "bus";
+    };
+
-- 
2.21.0

