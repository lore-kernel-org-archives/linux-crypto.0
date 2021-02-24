Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C59C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC08064EDD
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhBXIXW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhBXIXU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 03:23:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D539C06178A;
        Wed, 24 Feb 2021 00:22:39 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id n4so1002016wrx.1;
        Wed, 24 Feb 2021 00:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ac17W/RFAz2jRZ/sm5JRiVI6S5DH8b5zS9TE/bBd19M=;
        b=moS9TVL9GK0sXwGMDwaOR4IwscfeeogH1xO/Mv8S24MTAnt6j6mcRO7JXnr8Ao/OW5
         CAaQPEvZ7i1kfT4e3QwZKb2oLEXRNKkNgSGnD5vlBg+mdWx5h+Qty3kLa5N8VnJwD7OP
         73ltrkfc8lxjpS7bCfBvwupULhvktKklUsWNeQqMi7u/jbE2PPsWBqCMuM/98ttRr8qt
         R8oleL7NzCeWGVm5f6ENGfJQ+8Vwga5lg9s8dnKHY6CGqyXbzTROOndKBM3Iw2HJnEd1
         A71p+9SdS0QgNFkIMzLJlIAU5t4lqtsiuwZOs0a25CB1HCiLkO+t7aKRKSfeqj6S26pL
         xcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ac17W/RFAz2jRZ/sm5JRiVI6S5DH8b5zS9TE/bBd19M=;
        b=a9Qh+PCRLqvUhVWTzhqv4wnoyOg3aBTstDFg6aR++IH7v00Y27OzKZ/GEDg2hchj+8
         YRLqR76v3jJOM/uIU3fHF0k4TEIIeoO86URO7N7TDHdZphtWCLS7nbjGR8y0EFKq8Z6I
         ODD2cgRDTXDh/qWjShYXm3JnI9TEALnz5/cyzC8Diu5SRdIYhxgNPbqV6L+51Yq/YKkb
         BWDooHJ8nh2dddgWo2M8pwMzIdIaeWotg9g+C37sRYNxWBCzmFV2o65XdlOv1Fd6GiPg
         u/rxog1TBR1Ox7HGUvHZLKhmEfmbCRj/GCxrRmHSTbqeaVCM3j/YjYG9XATc76bwxwC7
         VHiw==
X-Gm-Message-State: AOAM5335EI1cYhje8DYmkv7VSEp6vk5yKISJKA3OEGCfujen3YgS0fwM
        hztJxSZCQMUw6gEXHK22wrM=
X-Google-Smtp-Source: ABdhPJxawiDKibks9m28Qgw5Plx4R5YXgSyl+D26YpLeIWpdTosjS0K8WI2kZhKFOK8ugiUMjOMfGw==
X-Received: by 2002:a05:6000:1208:: with SMTP id e8mr31159055wrx.131.1614154958269;
        Wed, 24 Feb 2021 00:22:38 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id u19sm1501628wmm.46.2021.02.24.00.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:22:37 -0800 (PST)
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
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] dt-bindings: rng: bcm2835: document reset support
Date:   Wed, 24 Feb 2021 09:22:29 +0100
Message-Id: <20210224082230.29015-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210224082230.29015-1-noltari@gmail.com>
References: <20210223160131.29053-1-noltari@gmail.com>
 <20210224082230.29015-1-noltari@gmail.com>
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
 v4: pass dt_binding_check.
 v3: make resets required if brcm,bcm6368-rng.
 v2: document reset support.

 .../devicetree/bindings/rng/brcm,bcm2835.yaml      | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
index c147900f9041..9a74b5af1dbd 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -31,12 +31,24 @@ properties:
   interrupts:
     maxItems: 1
 
+  resets:
+    maxItems: 1
+
 required:
   - compatible
   - reg
 
 additionalProperties: false
 
+if:
+  properties:
+    compatible:
+      enum:
+        - brcm,bcm6368-rng
+then:
+  required:
+    - resets
+
 examples:
   - |
     rng@7e104000 {
@@ -58,4 +70,6 @@ examples:
 
         clocks = <&periph_clk 18>;
         clock-names = "ipsec";
+
+        resets = <&periph_rst 4>;
     };
-- 
2.20.1

