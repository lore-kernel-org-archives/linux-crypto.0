Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21660C4332B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8C565016
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEHBm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCEHBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 02:01:39 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B0FC061756;
        Thu,  4 Mar 2021 23:01:38 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id b18so892418wrn.6;
        Thu, 04 Mar 2021 23:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cpm1I6vNvcl3kiHD76Q0yTBdgdimTTTYjPonH8WEMdM=;
        b=TPc2LhWikM0HlIzyp8G+Z7A4JSdGI36TpxSDLCMjFqYBpJ+DHw+yq+awAVu4z7A7g+
         wJeANx9HDW8742DaWNDzxdaWWD7LzH4HNiZ5oLBMj4S3LREsQO2souLqhv4DcaAB9eo4
         R0umYixu2f9iVZDOz43UgviYGOa3Ql6PRsxyUqAFef1z8VzJ8kd8X1DPE4kNmgw4BcA0
         j3clZrbd+uDbT06MZjYLyuKlwLma9vV0vGF+i4UBK53nK1NP27/330zvL8+Omh3ZYqJ4
         G01tNdAfyQcRXhWyz5kdde2ypOwRu6xPnqORVDgQkaQ2CF8b1vuUpcL+we7vmvR8zRzm
         02DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpm1I6vNvcl3kiHD76Q0yTBdgdimTTTYjPonH8WEMdM=;
        b=DHj/7eYnpvnrlnDSKlJu6u1Y0yLpsV9Dk51tlJg1/YotbHBrITZ2kF2F+o7h5Fsiqf
         uEDQf3zSSe5ifOpxdU8qaNtJ8URftOi71aWi5Ctsn3IUSEcvpQ2XNdtbe0D4qcGxgOEM
         5fP05+4JNA+Zhg5JCAb/SfolAFlcBwiAmFSx+jOL6Uk6/aNb+MZ9QEFc+bIGCKdDWHXv
         Q/Qu25QzEX+A9puc1sCdeEvVl6esU/cWGlGXybe/+QNSbSF5pv6ghn4hEArvTKMc8F6L
         0G9DJvM4TmyYbJNS7vJWMY7tOFKxXvtRVLJa8IhgRtqe1C3X9bzNTvgnUtTZOJHx7UnD
         Cl3Q==
X-Gm-Message-State: AOAM531qGc6HDjt8p3sMp01aqAU2UMIHQ8vOGy2dDPBTWsMRpFDv4mtZ
        /ioFA+lq3PgFD2QLDFEkQ1Y=
X-Google-Smtp-Source: ABdhPJyETTsqP++VXP0jCDPXYUXNHuIEzrElpImRKuJZ6o7dZkQMRX1O1T+s7L6/DSY5UkvZEv58Lg==
X-Received: by 2002:a05:6000:245:: with SMTP id m5mr7909261wrz.284.1614927696736;
        Thu, 04 Mar 2021 23:01:36 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id y18sm2799220wrq.61.2021.03.04.23.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 23:01:36 -0800 (PST)
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
Subject: [PATCH v6 2/3] dt-bindings: rng: bcm2835: document reset support
Date:   Fri,  5 Mar 2021 08:01:31 +0100
Message-Id: <20210305070132.2986-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210305070132.2986-1-noltari@gmail.com>
References: <20210305070132.2986-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

brcm,bcm6368-rng controllers require resetting the IPSEC clock in order to get
a functional RNG.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v6: fix dt-bindings warnings.
 v5: no changes.
 v4: pass dt_binding_check.
 v3: make resets required if brcm,bcm6368-rng.
 v2: document reset support.

 .../devicetree/bindings/rng/brcm,bcm2835.yaml         | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
index 5174492e22f3..6da674666d45 100644
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -28,6 +28,12 @@ properties:
   clock-names:
     const: ipsec
 
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: ipsec
+
   interrupts:
     maxItems: 1
 
@@ -44,6 +50,8 @@ then:
   required:
     - clocks
     - clock-names
+    - resets
+    - reset-names
 
 additionalProperties: false
 
@@ -68,4 +76,7 @@ examples:
 
         clocks = <&periph_clk 18>;
         clock-names = "ipsec";
+
+        resets = <&periph_rst 4>;
+        reset-names = "ipsec";
     };
-- 
2.20.1

