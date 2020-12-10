Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB477C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 20:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD67722D5A
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 20:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404567AbgLJUEL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:04:11 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45608 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404559AbgLJUEG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 15:04:06 -0500
Received: by mail-oi1-f193.google.com with SMTP id f132so7103513oib.12;
        Thu, 10 Dec 2020 12:03:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wYT6D6yOTVKMl9lCBQT5EHKzZ4TTN7Y8gqIdAhxWbzU=;
        b=lXfSDT+B816vq7GPV5aNcidW2P4KOPoR38uMftCfGU6WQuMQ4z+Jtn8kNVMJ8nQ1at
         xT6hbWbX3LbAY1JLClOmbM9Zc966gLh+7DrM0Yv98RmLr+3WvDFNd3s2+oCZoHb7i3dk
         ORgUI/zvyYjPl3FQlDasHh2xJYiVm59zlxm4uTqQbLjoX0dbEKyQP8cniT4nbBG734IO
         uLl7gFgtOu4bxOcsLKMwXANdNVMfWNQv/ndGrjpj51Ik6FeCy+39qJpGuuJY/5DUcA8i
         jX8P2e2BpP876xdrfK9Cq/fpDMsPjuzrIxuJBFydpPTBz4Jus9pGb5mByk+1AGmmMxBA
         m4lg==
X-Gm-Message-State: AOAM532K9G/3qvCTKv4Xt+5yAhEiPFZgDIWvR/1Qa779NIpgQxgHBt/S
        AK+6nnB3lXMPl1c/8zgJAA==
X-Google-Smtp-Source: ABdhPJxZ/fKWmJZJ0n2BGw8t4WfwQQfcXvuzPetiSTDtYG86R1HrAOQX1YNSu6f3c/T+vqBwQMbyaQ==
X-Received: by 2002:aca:2418:: with SMTP id n24mr6393172oic.62.1607630604964;
        Thu, 10 Dec 2020 12:03:24 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id o82sm1220636oih.5.2020.12.10.12.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 12:03:23 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
List-Id: <soc.lore.kernel.org>
To:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 4/4] dt-bindings: Remove PicoXcell bindings
Date:   Thu, 10 Dec 2020 14:03:15 -0600
Message-Id: <20201210200315.2965567-5-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201210200315.2965567-1-robh@kernel.org>
References: <20201210200315.2965567-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PicoXcell has had nothing but treewide cleanups for at least the last 8
years and no signs of activity. The most recent activity is a yocto vendor
kernel based on v3.0 in 2015.

Cc: Jamie Iles <jamie@jamieiles.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
I'll take this via the DT tree.

 .../devicetree/bindings/arm/picoxcell.txt     | 24 -------------------
 .../bindings/crypto/picochip-spacc.txt        | 21 ----------------
 .../devicetree/bindings/net/macb.txt          |  2 --
 .../bindings/timer/snps,dw-apb-timer.yaml     |  7 ------
 4 files changed, 54 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/picoxcell.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/picochip-spacc.txt

diff --git a/Documentation/devicetree/bindings/arm/picoxcell.txt b/Documentation/devicetree/bindings/arm/picoxcell.txt
deleted file mode 100644
index e75c0ef51e69..000000000000
--- a/Documentation/devicetree/bindings/arm/picoxcell.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-Picochip picoXcell device tree bindings.
-========================================
-
-Required root node properties:
-    - compatible:
-	- "picochip,pc7302-pc3x3" : PC7302 development board with PC3X3 device.
-	- "picochip,pc7302-pc3x2" : PC7302 development board with PC3X2 device.
-	- "picochip,pc3x3" : picoXcell PC3X3 device based board.
-	- "picochip,pc3x2" : picoXcell PC3X2 device based board.
-
-Timers required properties:
-    - compatible = "picochip,pc3x2-timer"
-    - interrupts : The single IRQ line for the timer.
-    - clock-freq : The frequency in HZ of the timer.
-    - reg : The register bank for the timer.
-
-Note: two timers are required - one for the scheduler clock and one for the
-event tick/NOHZ.
-
-VIC required properties:
-    - compatible = "arm,pl192-vic".
-    - interrupt-controller.
-    - reg : The register bank for the device.
-    - #interrupt-cells : Must be 1.
diff --git a/Documentation/devicetree/bindings/crypto/picochip-spacc.txt b/Documentation/devicetree/bindings/crypto/picochip-spacc.txt
deleted file mode 100644
index df1151f87745..000000000000
--- a/Documentation/devicetree/bindings/crypto/picochip-spacc.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Picochip picoXcell SPAcc (Security Protocol Accelerator) bindings
-
-Picochip picoXcell devices contain crypto offload engines that may be used for
-IPSEC and femtocell layer 2 ciphering.
-
-Required properties:
-  - compatible : "picochip,spacc-ipsec" for the IPSEC offload engine
-    "picochip,spacc-l2" for the femtocell layer 2 ciphering engine.
-  - reg : Offset and length of the register set for this device
-  - interrupts : The interrupt line from the SPAcc.
-  - ref-clock : The input clock that drives the SPAcc.
-
-Example SPAcc node:
-
-spacc@10000 {
-	compatible = "picochip,spacc-ipsec";
-	reg = <0x100000 0x10000>;
-	interrupt-parent = <&vic0>;
-	interrupts = <24>;
-	ref-clock = <&ipsec_clk>, "ref";
-};
diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 0b61a90f1592..46dc52c0739a 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -7,8 +7,6 @@ Required properties:
   Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
   Use "cdns,np4-macb" for NP4 SoC devices.
   Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
-  Use "cdns,pc302-gem" for Picochip picoXcell pc302 and later devices based on
-  the Cadence GEM, or the generic form: "cdns,gem".
   Use "atmel,sama5d2-gem" for the GEM IP (10/100) available on Atmel sama5d2 SoCs.
   Use "atmel,sama5d3-macb" for the 10/100Mbit IP available on Atmel sama5d3 SoCs.
   Use "atmel,sama5d3-gem" for the Gigabit IP available on Atmel sama5d3 SoCs.
diff --git a/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml b/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
index 2fc617377e2c..d65faf289a83 100644
--- a/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
@@ -38,13 +38,6 @@ properties:

   clock-frequency: true

-  clock-freq:
-    $ref: "/schemas/types.yaml#/definitions/uint32"
-    description: |
-      Has the same meaning as the 'clock-frequency' property - timer clock
-      frequency in HZ, but is defined only for the backwards compatibility
-      with the picoxcell platform.
-
 additionalProperties: false

 required:
--
2.25.1
