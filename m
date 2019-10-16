Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07037FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D338A21E6F
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DmFIZIf+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405407AbfJPNdz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:33:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50590 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405388AbfJPNdy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 09:33:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so2969800wmg.0;
        Wed, 16 Oct 2019 06:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xz+yYfMplPu5ZIKk6Ng0nX8uGkHzojnBY7LEEfSaIYQ=;
        b=DmFIZIf+THi7WPBbG/i/CRNriv5YFiA24wHXA6g1GiMFYbbyz8jqKf86Y8uaVNV/su
         3LOOj7TcTnlQeTCEnfQMggAoYM9iRSlMm7E+VYq7i4oAYHPcGtccOVNej7b91SDKOx9u
         C+h0GjnzJ0giM+eFpfAWpZwwtCtguqMfUwOYzphIJfoqGGtzozyAgxUtfhkD0WhohbQw
         pNrDuKoBADVRHFS2jVowoYS2B88ZYQRdUoCe8MpIlJ1W7ndJwjE3YFVWKQ/9/bMKLb+w
         zKOky9PLoi2tofWKtifOjZZ3PbD95KgkQvI6nY9AkjxAuExo3hjB40XI3tg3EIDM8vK9
         dhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xz+yYfMplPu5ZIKk6Ng0nX8uGkHzojnBY7LEEfSaIYQ=;
        b=pIXU50pxMfvf0m++CGpCAyTMHZ0iDXhHZlqRLm4HQbvl2MoZjGDUJjY2SGAPgVqBHF
         ByV0VdESRiPyBh0lJp1edPzfkKus/0IqfjCydRA4Piu6eEVWaVI6PZ0cG6DW0PPqAEE+
         QtMkWm0SPCJJn68sxeBNPX34a4gVZscoGEiKmB7FW4FwApIeUS+tBKJ4lrZdtcxgTO9i
         zci1148ycSI50vExaTmwrtxuEEPtMCARslrAL/q3z/HK6rdw2XG3jWw1CXdEZyc3eKuZ
         M8tSVXWCMzwUrJaOlDbtYeR08NGnoC53Fwbiw2rrN0K6tLajdGLJrLT9BmNO5hs71c2G
         a6Jw==
X-Gm-Message-State: APjAAAXGhypD9SoRP8C218Eiizr9zXA06l3yGRKZZ8rdOQeCI6VAcbw/
        UBG8kmNdD70v6YqK0s/reUc=
X-Google-Smtp-Source: APXvYqzHn6a4ciMCJZauwXTbi0pWSpMXVrle+/rUMgpkY6yicaV+dI5kVV6yIABkDSgfVOxPNviYSA==
X-Received: by 2002:a1c:9dc7:: with SMTP id g190mr3497325wme.115.1571232832926;
        Wed, 16 Oct 2019 06:33:52 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm3139998wme.6.2019.10.16.06.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 06:33:52 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/4] dt-bindings: crypto: Add DT bindings documentation for sun8i-ss Security System
Date:   Wed, 16 Oct 2019 15:33:43 +0200
Message-Id: <20191016133345.9076-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
References: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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

