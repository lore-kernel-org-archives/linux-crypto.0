Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4047EC433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B48217F4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="y4G4LoaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbfHHIvs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:51:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37401 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731337AbfHHIvq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 04:51:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so1578698wmf.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aXu1nRy+aYfVaPMzwlTQ/4xQ6m4HH0lPk2OELcN4n/s=;
        b=y4G4LoaSpFBdBRVb/la1Vnwn6s+lQ50FXLlIU8QWaO4fMWqWShK50P4LvPLnCzgZGi
         wqp0YLJbzQEEb9IFfKWR/Cu5xI0XOZ7IXsuV/GDTqHAO6HPCzUms7+lNVceXPCIAEJXz
         60/tvmd+D5VkbnvUCwPv2YoY6Vfm7gCm+nMJMwTuU/De3bIlwk6pElZnKaUgsEZIo5iQ
         +tSNcETig87NGSOcW8y/lGblIU7Xs/vNlviwbm7of2JNzSAowmm4NPqgblRVbe7OfuKp
         mJkxH6BmgOS15rf8B4d7R4ClOGRkCwh1gAEBvvUvhOB/eVuftpiHAewC0h22b8RFIe2f
         3U5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXu1nRy+aYfVaPMzwlTQ/4xQ6m4HH0lPk2OELcN4n/s=;
        b=KwOZkReI8rNptGbk7vJSwvVRg0wj2bpvdKbTTyuh2ssJQDp/iR7JuG+wcXvEXPxb8/
         L2oOMoNKkRQSewA7qHvNAbNA/jJp1OpqL7VIK4KGGIHTlkxCXYSVOtxFWvSplnQ2ahwd
         JTCUyuboE02KWJvPE+LiyP0uaX/lyXM1WjZKoXdPeVj/z8jdPHl7FufPaxP5AIQkal0E
         DIv+KlS6wtpo461qnxQSCy1unHbJiiCPfwfkzyxChFftGGs93FdCbcPwzOqUgUe5wbxt
         qq0aG2ettTsBC1x87ODK9TyT+5DlZM12sTdi8Wan1+OSJ8+Si/NmE7fImRVQTYC+SGua
         5Q4Q==
X-Gm-Message-State: APjAAAUkndvgzofDz5Tg9NHAIa874qYmKHIycoeFzxYUmDDQ97zvw5bS
        O4mbJCYl5es4tJ3vxwoEf0yUMQ==
X-Google-Smtp-Source: APXvYqxTq0DTZdne0Hpdf61fadd2IYVjlm+wBmSqmsptWpUhR0qaNtA+06vzVTvzrupVkiJRZJ6tQA==
X-Received: by 2002:a1c:f918:: with SMTP id x24mr2918700wmh.132.1565254303546;
        Thu, 08 Aug 2019 01:51:43 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id i66sm3360031wmi.11.2019.08.08.01.51.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 01:51:43 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/9] dt-bindings: rng: amlogic,meson-rng: convert to yaml
Date:   Thu,  8 Aug 2019 10:51:32 +0200
Message-Id: <20190808085139.21438-3-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808085139.21438-1-narmstrong@baylibre.com>
References: <20190808085139.21438-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that we have the DT validation in place, let's convert the device tree
bindings for the Amlogic Random Number generator over to a YAML schemas.

Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../bindings/rng/amlogic,meson-rng.txt        | 21 -----------
 .../bindings/rng/amlogic,meson-rng.yaml       | 37 +++++++++++++++++++
 2 files changed, 37 insertions(+), 21 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
deleted file mode 100644
index 4d403645ac9b..000000000000
--- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Amlogic Meson Random number generator
-=====================================
-
-Required properties:
-
-- compatible : should be "amlogic,meson-rng"
-- reg : Specifies base physical address and size of the registers.
-
-Optional properties:
-
-- clocks : phandle to the following named clocks
-- clock-names: Name of core clock, must be "core"
-
-Example:
-
-rng {
-	compatible = "amlogic,meson-rng";
-	reg = <0x0 0xc8834000 0x0 0x4>;
-	clocks = <&clkc CLKID_RNG0>;
-	clock-names = "core";
-};
diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
new file mode 100644
index 000000000000..a9ff3cb35c5e
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/rng/amlogic,meson-rng.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic Meson Random number generator
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,meson-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: core
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    rng@c8834000 {
+          compatible = "amlogic,meson-rng";
+          reg = <0xc8834000 0x4>;
+    };
-- 
2.22.0

