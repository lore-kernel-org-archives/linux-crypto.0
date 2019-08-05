Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBF0C32751
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B45112086D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="EhN2WpYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfHEMDa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 08:03:30 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38590 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbfHEMD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 08:03:29 -0400
Received: by mail-wr1-f44.google.com with SMTP id g17so84144158wrr.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 05:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wq+NOUXuHn9W915kfej1QDLl0G8Catrb+/a+UkGjnNI=;
        b=EhN2WpYa+7ri803ml/bEjkzN1nY8BeU/AY+MMoupJpUIq2u1p69+yVQ7br/t7mH40P
         lp9VfG2N8pWv83c6lN9S33D5h3Mg/GgGrJTxktOOpRJc4Qs00Zm87PR/db7y2yW3eAM6
         uqOo8k7bHGd3mbezV1Dwr1KXDr0iOfekOTUrcq5m6jm0CTIKePQkNlLJNUaHWfovrAew
         +b6HUE0pNdRqO0/lmBNUKx++21+RPI0IeTwUD1yG1RRAViSfofe/w7WYXAKG/1Z/+xUG
         K4otNssxD3TWTfLz/MTLFN14SC5nJN6LkuPwF16Sd6vwDrXPfpogEAxW9ueLCgKxJYzS
         XhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wq+NOUXuHn9W915kfej1QDLl0G8Catrb+/a+UkGjnNI=;
        b=prpnWwpa+CaKN849zieHWmisVyCQOg3tdLoIXQzJlB50BIV5MVN3nqQ7N4p618RJe/
         tG7RwKOuDkKinqT9QB0mCKG+yahsSCtq5AJW4hpmuorHyLTAGRzxmsAl3DrUbQSmfWM1
         gx+1wclQ5kRgpk6/TxfIEN92s7coqLCI2UNrapb4CeLNznOgZ5Ftj/WVm6/toUvBXWOO
         ksUPsmiwkpHvrSkf7mWJ+z2FiLM5rIo8lC+SqkWa2qmpLQg/O+Lut3oDs1iIhAQso/UB
         ZVqKMhMJ5UyXIa4hh712yxKh5RbpY5EzfO30+CtH85eqgxEJ3ChJY9wXCEsVUfilq16e
         fMog==
X-Gm-Message-State: APjAAAUIPlyKe6+KtyR1Ak75C4dUi0KF/fZ4sCkAy9BhNTXsJdoUo8KD
        KYvBOcKYqaycDHdhtiR+T4ruSQ==
X-Google-Smtp-Source: APXvYqyz2oDf3zNhCGl1fmtqi/15XruskE/NYuyc7ppJN3wS25RsZliVSJ0Q+N3wlY6fZsbAF7WPyA==
X-Received: by 2002:a5d:4949:: with SMTP id r9mr24455367wrs.289.1565006607077;
        Mon, 05 Aug 2019 05:03:27 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id x6sm88683668wrt.63.2019.08.05.05.03.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 05:03:26 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [RFCv2 2/9] dt-bindings: rng: amlogic,meson-rng: convert to yaml
Date:   Mon,  5 Aug 2019 14:03:13 +0200
Message-Id: <20190805120320.32282-3-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805120320.32282-1-narmstrong@baylibre.com>
References: <20190805120320.32282-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that we have the DT validation in place, let's convert the device tree
bindings for the Amlogic Random Number generator over to a YAML schemas.

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

