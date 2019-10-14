Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993EAECE58C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7381C20882
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="FQ5ORjgo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfJNFcH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:32:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39534 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfJNFcH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:32:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so18047817wrj.6
        for <linux-crypto@vger.kernel.org>; Sun, 13 Oct 2019 22:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8ehlRfTi/fq+Oy1TzUxlpwPnlRkkcugNpCvrZknIDGg=;
        b=FQ5ORjgovekCk7XGqhyn+ke278DVw0wPlJaaxeMo1a5O4thnBrnZ0ux4qmb22O+ztr
         LI3Q5AyYGkd/u/6Fs5rfH7EUzCJeINMQpQ/2bREwujfr+jeoJMoo9uOLUytI3y0ox+Cw
         uvTm2edHXCe+7eBdbWbBS324u0Vad8Fqlmuv80+RA+Gw2Kgn3TYKPaEhy9KjpqZL6MM/
         0CYCelN+RFX8cJDSgVFnauAIpGNzozZ2XUgCFlOKxD2VYWBA6Z8O8XA+QL6Vyv4WEIbS
         O1ixREOhLQqgVB4B91diAct1NeWoynDToZTqm7ZeDbNIhfsS7wiUbfslNWZ6EOiJ5iBI
         H/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8ehlRfTi/fq+Oy1TzUxlpwPnlRkkcugNpCvrZknIDGg=;
        b=FncPbrpzkaIhOzWyFNPd++Tkw3pZXpoVj+623h+uucH1zXereJVDVn0lxaTXkRRfXN
         71C7lZ+c45j+GLSOdps8wESqUb9sWuAgXeNWAqACt19vqeT7VXSyi1CRqgFjeHSd+GC2
         dx4ocpB7INacywlt2EjDJ6mF1vqBJwinVKilnUEWGFjn1/Tfcgh+XOhCObGFHa95yvsq
         5qv/ND+Yy93Tx0ApY1QQi/W+8NmmGxzDgwD1nMWzlPLTplfw0MNJYhvL9pTS53rfySA/
         EzObE4aCmRHxK9+wCxAXaCIjac2/tzOrU4K+dtoSwihi/wDlnB7MuGT6TBAaGOVyghU0
         +o1g==
X-Gm-Message-State: APjAAAVbEzTZi2/QlztNmu0LL5sDyi+2FutzZ2jzPd2ZQLa7bmTGwqvP
        Aj9D3MRT2FHq3GyiXXiyhE3E9g==
X-Google-Smtp-Source: APXvYqzASzbmQ23svVZMfVmaqECJFtThTvyq6i0XHeqaL0MjTozTSVrjTQXBUc9//FwizHoJb6IEdw==
X-Received: by 2002:a5d:6581:: with SMTP id q1mr23513906wru.393.1571031124896;
        Sun, 13 Oct 2019 22:32:04 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id o18sm44238772wrw.90.2019.10.13.22.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Oct 2019 22:32:04 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 1/4] dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
Date:   Mon, 14 Oct 2019 05:31:41 +0000
Message-Id: <1571031104-6880-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571031104-6880-1-git-send-email-clabbe@baylibre.com>
References: <1571031104-6880-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
Amlogic GXL cryptographic offloader driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../bindings/crypto/amlogic,gxl-crypto.yaml   | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
new file mode 100644
index 000000000000..5becc60a0e28
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -0,0 +1,52 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/amlogic,gxl-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic GXL Cryptographic Offloader
+
+maintainers:
+  - Corentin Labbe <clabbe@baylibre.com>
+
+properties:
+  compatible:
+    items:
+    - const: amlogic,gxl-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: "Interrupt for flow 0"
+      - description: "Interrupt for flow 1"
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: blkmv
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
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/gxbb-clkc.h>
+
+    crypto: crypto@c883e000 {
+        compatible = "amlogic,gxl-crypto";
+        reg = <0x0 0xc883e000 0x0 0x36>;
+        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+        clocks = <&clkc CLKID_BLKMV>;
+        clock-names = "blkmv";
+    };
-- 
2.21.0

