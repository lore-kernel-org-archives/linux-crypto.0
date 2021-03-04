Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E944C4332E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037F664F0D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 07:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCDHeW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 02:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCDHdx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 02:33:53 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BF7C061756;
        Wed,  3 Mar 2021 23:33:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l12so26464505wry.2;
        Wed, 03 Mar 2021 23:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZDWFW4D59r4xarZoIxLa/j/vBnqICsduu7IM4/DSrf4=;
        b=b2ZwyOBTI2YssCewCnmYBoM+ta8EIaOI8ht+SRQgxIsdSrNm/NBzk1zzDMKzMjnW1O
         kDyhfUVeN+v427rGi4HCgP5KBSyAnhcFDluRLQEsZPBVwhegQyyD9Gt711JOSIsylEF6
         HwJYbAPa8MkakkgKPk6eqzyxiRthDQDjmSFfKkse33cRIfsUoo3LzFyHUXdqfdtaC9cj
         3aE/Vo2NYQw0pTi+XLlr0DriMUCWabXDFGUKowsAu2s30IYO1Esto9PEdV6ik2M7ixoU
         W6hB6mWB80SofCUIKMVLTS8EE1UFVeuYU9CJzqnY8wclg9iNNtxTpOAO1ySNGZmjQeGe
         +Hbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZDWFW4D59r4xarZoIxLa/j/vBnqICsduu7IM4/DSrf4=;
        b=KTJqMRSAgG8tCktjPdzGegDz7y80F13qN1DCJ5w07NVdlaM5a5qbmqarDzx2ZXFiYH
         DMy3VOOrvStrguDrxJIb7tqEAVzBR711HHQQddydkYgZmfk+QdDPISBZeY/crjiy4E3O
         1wYTfOG6iLgMKKDc9qcchykJvrXO94Np1F+8l5nSov8q6j4mF7XBTdIl1KyV0Hf9R2Cv
         nISoqr0aAPcCuCAiU8YsZI/mjcFhiCR50BuBMDGdr6IVvIK9xlJDOBusDZVt/6KUPFR2
         w/XnD1MspK8PyYMPPHgMeafVad9VCCY9NKHgC/udVnS2qPJXKpDHj3eUtPAyPKDUhTVc
         V1+g==
X-Gm-Message-State: AOAM530UIk1wP73nVmeUUS+uCWtlOp/5z7RdBXRySKuAQ26mpUl9F9NL
        fWBcLy1p2u6C94a7XFs9hBg=
X-Google-Smtp-Source: ABdhPJwNam8gkxsOGlHGUb71EYTwmyUes8Yz141STO80JOn+6iaAdcFmh4IpCO1CNfA71CRk0VfYZA==
X-Received: by 2002:adf:f512:: with SMTP id q18mr2475250wro.61.1614843192006;
        Wed, 03 Mar 2021 23:33:12 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id j30sm18328811wrj.62.2021.03.03.23.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 23:33:11 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v5 1/2] dt-bindings: rng: bcm2835: document reset support
Date:   Thu,  4 Mar 2021 08:33:07 +0100
Message-Id: <20210304073308.25906-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304073308.25906-1-noltari@gmail.com>
References: <20210304073308.25906-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some devices may need to perform a reset before using the RNG, such as the
BCM6368.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v5: no changes.
 v4: pass dt_binding_check.
 v3: make resets required if brcm,bcm6368-rng.
 v2: document reset support.

 .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
index c147900f9041..11c23e1f6988 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -37,6 +37,21 @@ required:
 
 additionalProperties: false
 
+if:
+  properties:
+    compatible:
+      enum:
+        - brcm,bcm6368-rng
+then:
+  properties:
+    resets:
+      maxItems: 1
+  required:
+    - resets
+else:
+  properties:
+    resets: false
+
 examples:
   - |
     rng@7e104000 {
@@ -58,4 +73,6 @@ examples:
 
         clocks = <&periph_clk 18>;
         clock-names = "ipsec";
+
+        resets = <&periph_rst 4>;
     };
-- 
2.20.1

