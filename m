Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CB6C43462
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 11:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C5B611BD
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 11:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhERLYe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 07:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhERLYT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 07:24:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649CEC061756
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 04:23:01 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z137-20020a1c7e8f0000b02901774f2a7dc4so1408447wmc.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 04:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oaLFELdmsSuj6jGUpLjdC3C6Wd7IWhp+KmWoppj+Ots=;
        b=VKSM0kO2iOln9CQUfzNDIsaTFKxbenOaoUvS60FBMhhB5nYExLkbpuY82iCC+ohbQX
         F7cHamO4ub1tlhjaLWntbt8A677LWvQxZWIWTWuKA2x6L9yFn+IFCd43RLTbl4mW3RhI
         whmFtFv3pH0pvFuKOKFL8HveAo1pQPXXjIB1/x54gENVkwDGlwCPT4H94WN3/B4dm0V0
         U8iT7kCQ+m1pxzgvAYMYqIVbvl/I5vB22MaaAJnGZdczQh01NYNY6deiijmc6zJNcgcb
         4fx66hXYMQzIfDyZ9mVjCtIh7T/bpJkidlDjcaiFvK1kVRsDxzK59s29Y7sfTYt7fpcu
         AObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaLFELdmsSuj6jGUpLjdC3C6Wd7IWhp+KmWoppj+Ots=;
        b=iLHAo5jo+ZOEMm1ZWhavULtWggFlO8lhdJnz8174XxLEot/nRLd9q6s28tmXKPa4Sa
         RbRFK4eLW8hRPr0ytdbdCSMbhQk+kbn/5aezTXbmwYAsFCp1o1djL7tSMZOI5uSyl6kI
         GKuFc4B54XcpqeDwNBcr9x6FwlA4ozIrjaXbOFKcHL3HPk2aEV9xQalIwO5uTKgXE/w7
         YhwLy+ww+J/an18LCaYJYBK37kwSbG2/b4P6bk4HP3HZDlzxuxkToZWUCsbK/bdu6zpK
         ovcAMW/3c6FUJKJX34JRej0Ae9cM/oYiqxZLB7796X1IOOQ2tof/C8gJ9TO9sf+7Sjso
         dOtg==
X-Gm-Message-State: AOAM5301q+QnhrcaS4u1MeJwtbpLJMdQm8CX4Rw/ek6D3hOQd73yO08b
        Pdi6+oG+70UHAOaw9MrDxRYn25oQfLNNSA==
X-Google-Smtp-Source: ABdhPJzl2Utkm0LkpJMg42RFFaMV0xPUsR/PlhE1Hxe69g5OBNLG/XNR5HueBpJgHnFR0O56vHEiXg==
X-Received: by 2002:a05:600c:4a23:: with SMTP id c35mr4408392wmp.130.1621336980047;
        Tue, 18 May 2021 04:23:00 -0700 (PDT)
Received: from localhost.localdomain ([88.160.162.107])
        by smtp.gmail.com with ESMTPSA id y20sm2881337wmi.0.2021.05.18.04.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 04:22:59 -0700 (PDT)
From:   Fabien Parent <fparent@baylibre.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     mkorpershoek@baylibre.com, Fabien Parent <fparent@baylibre.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: rng: mediatek: add mt8365 to mtk rng binding
Date:   Tue, 18 May 2021 13:22:50 +0200
Message-Id: <20210518112250.2146819-2-fparent@baylibre.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518112250.2146819-1-fparent@baylibre.com>
References: <20210518112250.2146819-1-fparent@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add RNG binding for MT8365 SoC.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
---
 Documentation/devicetree/bindings/rng/mtk-rng.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
index d9731f0ae47d..ccff10b27f73 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -20,6 +20,9 @@ properties:
       - items:
           - const: mediatek,mt7629-rng
           - const: mediatek,mt7623-rng
+      - items:
+          - const: mediatek,mt8365-rng
+          - const: mediatek,mt7623-rng
       - items:
           - const: mediatek,mt8516-rng
           - const: mediatek,mt7623-rng
-- 
2.31.1

