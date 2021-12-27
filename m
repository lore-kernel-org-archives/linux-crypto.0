Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDACC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 18:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhL0SdE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 13:33:04 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45332
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231719AbhL0SdD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 13:33:03 -0500
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0878D407AD
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640629981;
        bh=RFPGHmjdhJ/hloNRhgmml05wd4YHMhrSG+GgHjMTnJk=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HQ1Q1ffIVZ3P096TtzqefxHYRdw0644TBHJOzETcALpXuxfwO/U0uAheYuc7va/PL
         zWxxZZsCg60arLZDe/bmzB47qu3As06yJDrE2jou/cjSJTZBFvvQ29A6YxW/+/zjg2
         QGFFZEKwOWITnTtQ6Pu+V73+rLo0LnmaevjvHoND5Yx/MQzzK29tvAvWGRyonoacnG
         FdsWBxkw61UjMdxtU1BuRRfqAOKZp9IV6Pe3yxuQccAHFvaOXgDHfM0CVOHhnpwkpn
         rvuCnYI14yY4YtcsQm1AaAQf5dCHLtVrjszvj7ERAYWolUSdUUMJKFH8oV112CMOZ3
         9oQ7NHTXYWXgA==
Received: by mail-lj1-f199.google.com with SMTP id r20-20020a2eb894000000b0021a4e932846so5289778ljp.6
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 10:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RFPGHmjdhJ/hloNRhgmml05wd4YHMhrSG+GgHjMTnJk=;
        b=DE54+BiQFVqHvKawR2uokDdB31pv0qVddFosYAf27jdg5RtSu6JfCp7vLm75EXuNB4
         O/uF3kyWacNfy1jBCPENB+BBmurC6MsCw+lx7QXZeM10MV3UvhEkdUKo2H1HLZb/v9EH
         EYphqAUYFpTiS/Oh3GtnnJLU44ftr+87snKb3LaPUh5yD4/UEPWA4NMD3CgXzRjTGSS9
         1kz4Yu0bWd3zPUbl3xJEb9B+/I/ld44q8D0G5RjjXpF7Tig7zsON9A6jXfD/gHhlin41
         +CIH8Kd7t8WItPU9q6MFbIMlRsSNEq+rVsJXFBV28n0KbXMoI8xZqzruVykFHFKTZrIz
         5RTA==
X-Gm-Message-State: AOAM531Z1+siaLE2wFQvst3p6KfRdEJO6nNs++3tT0GK+wN8v0qph/Jn
        osdJ5P5RXf8cgfVOGCrdHfE1G7oumcyZHizjDRczhTwP3EjyNS3CxXFfjcRHXyuwZTSAN8ftkNT
        aF0RbkguGhwJeJjrHCC41NFOTiDSvDOG9/RCtVDg6LQ==
X-Received: by 2002:a05:6512:168b:: with SMTP id bu11mr15627651lfb.401.1640629979256;
        Mon, 27 Dec 2021 10:32:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/Gt49kywYk1krG8CoXR3xfc8T8Tm6VqX8pnxg2OeXzFbjocvCOPPW2+Ds+ALgMTQuQ1xw9g==
X-Received: by 2002:a05:6512:168b:: with SMTP id bu11mr15627620lfb.401.1640629978994;
        Mon, 27 Dec 2021 10:32:58 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o12sm1299622ljc.5.2021.12.27.10.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 10:32:58 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: [PATCH 3/8] dt-bindings: rng: atmel,at91-trng: document sama7g5 TRNG
Date:   Mon, 27 Dec 2021 19:32:46 +0100
Message-Id: <20211227183251.132525-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
References: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add compatbile for Microchip sama7g5 TRNG.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/rng/atmel,at91-trng.yaml      | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index 0324e863dab8..c1527637eb74 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -13,9 +13,14 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - atmel,at91sam9g45-trng
-      - microchip,sam9x60-trng
+    oneOf:
+      - enum:
+          - atmel,at91sam9g45-trng
+          - microchip,sam9x60-trng
+      - items:
+          - enum:
+              - microchip,sama7g5-trng
+          - const: atmel,at91sam9g45-trng
 
   clocks:
     maxItems: 1
-- 
2.32.0

