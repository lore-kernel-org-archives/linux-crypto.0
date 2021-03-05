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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B313C433E6
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED18065000
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEHBm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCEHBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 02:01:39 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEB9C061574;
        Thu,  4 Mar 2021 23:01:37 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u14so905841wri.3;
        Thu, 04 Mar 2021 23:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ua2t/yBcyeLhQb6et5ovZpSh5qBfeyV1CmPe3Ubpqw4=;
        b=dXPG05Y3q9M56ir9GDeAlCeIp/gQGc54yedo7eS5nYaF4/V64Iz0BAMB8A9o4D237Z
         P1u/Uo/LHtyqzYqDN/5qZ+YDyObVH+WoDTit4aae0nZAggUmWiTX2wAl/Ske8lTTDZ4C
         +FN8OqjLhLcKGD3nUba0mmIM5PkKsyGXvgZ+QrQGYM7hL+yyuvc2FWR/ZLXdJAS+A0C5
         22fA8X+rbrs8nAfcdQge8QF7848zbFjxz1ljcKJbCURqG1Hn3Iyh2gIZs1HUKtz96ayQ
         ANU5XmY5hoBG0hH393O++kSU2sRparpxHQappf24mTc2EibnPGukDJeSKFk7igjG+ROt
         2iBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ua2t/yBcyeLhQb6et5ovZpSh5qBfeyV1CmPe3Ubpqw4=;
        b=FnOZEZAKVrN6mN1hqiTDrDnBozhULZSS9GPn4IUY9WRqtG4L6xQ6KIcBCPExO/jBE+
         XISN7cehKe8mA7rG/UFm+4cf7TVV3lQP8/Wee91tFo8CUrI2vbMe4ML5lyyke9JKynu4
         t89xgrvRvfpnjuXEKTdu5yrDWYElW9HliRdkO/7aZ/9pOnLnY4N+xHPdY8ULbWh3pFB2
         LkH0y9qvdSEKFxJLcOz0pAWtKNCR/TOoAdyMT6FwcyfgzblDEtGc/HaovzmUgUtPYGK5
         b0pRlL2sK+KNxT7NXFn8RsXVWto6bc4mWJUpSxzBxtAx3HQZ8jIyJxwcXzvwxPMYIoUH
         MdQQ==
X-Gm-Message-State: AOAM530w1p5NlwDuMNgr3DyG6ucxyPfJlAKGTGv4BmPoMR6elW5rQxrg
        YbYwccKNyEgY3/NrP66byVQ=
X-Google-Smtp-Source: ABdhPJxo+xAiAsPRqicUOz3h36tqGtCljoVRmcJ8qeVK1QdDaq0WIAPMLT0eQkaKK4xWueYmKmezsg==
X-Received: by 2002:adf:a302:: with SMTP id c2mr7664961wrb.212.1614927695824;
        Thu, 04 Mar 2021 23:01:35 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id y18sm2799220wrq.61.2021.03.04.23.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 23:01:35 -0800 (PST)
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
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/3] dt-bindings: rng: bcm2835: add clock constraints
Date:   Fri,  5 Mar 2021 08:01:30 +0100
Message-Id: <20210305070132.2986-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210305070132.2986-1-noltari@gmail.com>
References: <20210305070132.2986-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

brcm,bcm6368-rng controllers require enabling the IPSEC clock in order to get
a functional RNG.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v6: add new patch making clocks mandatory for BCM6368.

 .../devicetree/bindings/rng/brcm,bcm2835.yaml          | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
index c147900f9041..5174492e22f3 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -35,6 +35,16 @@ required:
   - compatible
   - reg
 
+if:
+  properties:
+    compatible:
+      enum:
+        - brcm,bcm6368-rng
+then:
+  required:
+    - clocks
+    - clock-names
+
 additionalProperties: false
 
 examples:
-- 
2.20.1

