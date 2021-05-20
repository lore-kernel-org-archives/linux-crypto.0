Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79140C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 12:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E0661355
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 12:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhETMXJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 08:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhETMXG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 08:23:06 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44E6C09F5F5
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 04:17:04 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4859318wmc.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 04:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFbC/8AD0LOFNwNu9BRgUtFruC/G1IwePtG3av6RsOY=;
        b=k1LNclxtiP6W7x7zqryjIF2j1zX5LVI89E2F+ZC0OosAJK+edKHkMljCHDcNA4W6r9
         oo4eZKxNjGjNVEJ8BFhLlpoqnPMwuEiPyWw0EOz4IxxVlKUgsrlswX/caR97z6QS70oV
         NZ3/faNHyMCstTucEuXIupFp8etwQE4J3yqi0J69jZcU0Mx7BKVpa2T7q24WhNiKWtvb
         PU5LpeN250fH9rB8YtK5Dy/MNYmxcDZJKb5GKWG8MkZ5EEWxsJ6BFLPncstIQhXlrfUP
         vHUQIPzmn+0TEAFURxP+OL/A4Cij2M4dnT2BPNlHbT0nR+8xyCyGrpl/dPtQmw2IqIcV
         nkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFbC/8AD0LOFNwNu9BRgUtFruC/G1IwePtG3av6RsOY=;
        b=geWPHwzSMuce1IJgUQP6cTWpJCD/YTwnSFNL+dJrIomjzRldNESLRKyjvb07D5HZH3
         019RGTiYoPdQ8kVdOR9QwfhfuQwFKoRx7xJw2WaW+ijeEsHT6iYlz5W/AxO3nrctely2
         461qinBGBz2bKTPLLBOgBzZeTLMCRgdddsX8oeFKQ13hLsSWRto/ICeCJW2mA/7P9JjF
         ols/1y/v24i1SCqTd1BD/fXFIo8bLZNWrEZ7NyG70S3e6H6D/F3QZUExJJdBkJkG9IcF
         7Uet2a1h8xK61+dXkEUvMNJ1WzKTbd2PcdyXTAVlbi7PBIvfnAJpOwo+OG6EKiIQKfB2
         cjow==
X-Gm-Message-State: AOAM531nzRAOdwcbr4RyNz8t+Furzk6PNta22gOS/5L4qRu79ISo6SAz
        cXdHOVCqR6XqaMQC5nSUFMbzUQ==
X-Google-Smtp-Source: ABdhPJy170kk8Q53GOuLn6l2Mf+w5xTtNMkRzkP4oBTF3ZetnMbI5rV9xgKJjjvpwPsSs4pLxpDMAw==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr3222583wmh.42.1621509423424;
        Thu, 20 May 2021 04:17:03 -0700 (PDT)
Received: from localhost.localdomain ([88.160.162.107])
        by smtp.gmail.com with ESMTPSA id a19sm2310757wmb.40.2021.05.20.04.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 04:17:02 -0700 (PDT)
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
Subject: [PATCH v2 2/2] dt-bindings: rng: mediatek: add mt8365 to mtk rng binding
Date:   Thu, 20 May 2021 13:16:56 +0200
Message-Id: <20210520111656.66017-2-fparent@baylibre.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520111656.66017-1-fparent@baylibre.com>
References: <20210520111656.66017-1-fparent@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add RNG binding for MT8365 SoC.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
---

v2: Write the compatible in a more compact way

 Documentation/devicetree/bindings/rng/mtk-rng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
index 4be5fc3c1409..61888e07bda0 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
@@ -21,6 +21,7 @@ properties:
           - enum:
               - mediatek,mt7622-rng
               - mediatek,mt7629-rng
+              - mediatek,mt8365-rng
               - mediatek,mt8516-rng
           - const: mediatek,mt7623-rng
 
-- 
2.31.1

