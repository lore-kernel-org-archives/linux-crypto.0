Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70C7ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AAD2168B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqkvtcIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfJNFSs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:18:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44470 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfJNFSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:18:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so17996708wrl.11;
        Sun, 13 Oct 2019 22:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EBOdxnEDjlDgTl8vnBYCTotGM7/cUtbcpepjO3ITy9M=;
        b=HqkvtcIx4fKEctevUUEDQOTu5HEOMNeeAb9/shYTajmx2Re/0dOg1GgHRiGwRty25s
         SBXJQNvNb2cGCcm5Pr+mmn3TFcjitR29pNr5hTE5vHoaExHo8O3GchfAqK8qhCxwcp0M
         To+wZDV4lGbYpLkAXnxH4Y+TOzbDmZA5CBbj45dpvNfib4XDDh/qM+S/SQWi4SfmEmrD
         9tHxoOaHiMbQtyH49+CbHYjrOwcU2Ii4+hAdRWN8tmtzEHtWJi5/iGX2Y3EKm+TyvPNj
         rYhmL7eE99NfYYG6be3fuPNZU/N6+HPDQjBYtYFyDho9EIJYOP/CJ5ZOOn37Cg2iujeY
         YseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EBOdxnEDjlDgTl8vnBYCTotGM7/cUtbcpepjO3ITy9M=;
        b=pwCGZhvqs82QB6g+q+tcx148Fzxy/7uK1ne32Qr/oskPeCcSrn9eFtDf0vGMfs5q0b
         b3PS/d5vjfsjU6814VzZx7Fb2J89fSwVCE94BQ3Ypl7uHMytbMhYuoo296X/e6hYJVfU
         xmaiOd7BKrKRgKMnfmmlpyPHgdudK/D57gYXNGWXhkvFzDEDBNoKLdMtT3LTmiZyPqXt
         nZLvqNLnDeK9hirV2UlTkAdGoGs1DUmDL/CWX0ks02QdysSafWuej//bioR1ntaI00t2
         tUBz2SKDdgrHu/9+ZWupWKjm9VziPmyWEc95M3yQm5a5Hu9V639G8zrxnZwmmGYr7wvf
         R4pw==
X-Gm-Message-State: APjAAAVz1rjv3mqGq7CNGmx+9Totx5/6HFcfzlkHPN2Rmwu4E+otRGuh
        FX3O9hL+ZHZbzj56u7FZ5A8=
X-Google-Smtp-Source: APXvYqwQWNWKOAY7LNNHT2Gdp/MtDgCTCxVyDv07ozqa2/PmSE2211R5Hb8liynHEB7CXUTmglwy8Q==
X-Received: by 2002:adf:dd88:: with SMTP id x8mr13266930wrl.140.1571030325603;
        Sun, 13 Oct 2019 22:18:45 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 5sm14660340wrk.86.2019.10.13.22.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 22:18:45 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/4] dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
Date:   Mon, 14 Oct 2019 07:18:36 +0200
Message-Id: <20191014051839.32274-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
References: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
Amlogic GXL cryptographic offloader driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
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

