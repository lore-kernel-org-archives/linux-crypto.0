Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEE3C64994
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 11:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241747AbiHYLeR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 07:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241679AbiHYLdw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 07:33:52 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9588BAF4B3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 04:33:46 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n15so6738965lfe.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 04:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uAj6PCuWD0Jdh8SbbVYKmqZvEbRpC9H1z0Nl20Cruac=;
        b=fvXfXXHh5BGdtsz5EycnPawDsbQFYVSc5NIkbHOCBoaR5sbVKjYhKf0riJxZtsJPn0
         yLkXyOcZ7O7JIzBtCuFXAdx1hymKNbd4gs+d7nj0e4VvWl4XrfrySGc/UWWzKKDZEhIK
         PMz9IhmKovNl6wE5mKmlZCJbkOZLvYujeJ9+Z+PdLEovtKAiynUSGlYTdFQH+L9I1o33
         aPzbFi0vyGjMUfUK4pO5yOoysBDhVf7GAzunWBiJtmNBaA9A23nonR7Uj/jAlkl5+u/w
         Pqke31tLYylGnmywof9M0uE0+6i88SzV9fj6yOGafWmodh1kwDgsqFgTQIZDW9VnaqaW
         R9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uAj6PCuWD0Jdh8SbbVYKmqZvEbRpC9H1z0Nl20Cruac=;
        b=AmjB9PriczlMLJuoBG/fCqjX/hgHXmwC+66RRrUV+KENJY9khpTmMzyixOKoqB+bJq
         DDdgBUt/Wb1As/KskST/XSH/iRLdhv7d2/cJ7Nkj2EwLxNDaK0gmZIRH78j3KQEQWnwe
         d8CPJBtzTt/sUNrAYEBdHR1NeDh/yeV6PNKgPvs/lGrex0DO+Qjv0aKcFmqvPFfD3omm
         TOcQ8EE1ATRc3ktcP6IdXwKNc27hLuUGXg02RPxUAyBkK1+EnfGYY2UMkjS5KIUB7OsI
         d6sPgWHKbeGRWXSF7Pr4dwR9SpGeGzasH2moJcZlwxlGGuTbJdZdr+IKqF8k8h9f7X78
         Z6dA==
X-Gm-Message-State: ACgBeo2x4Mmd3Tp+Po9MIKhxh/uD2OghKu1DJnaO3hylDZIK9kodqMta
        vi8fd7E2UM5Y5X2BuxNSwhrTjA==
X-Google-Smtp-Source: AA6agR712qcvmFpt50SIccfBNtYn9ngIdkzCeLBRl3LE4oSeWQnKcFPJ0lH5Lj37t8pI5y2uiTBTEw==
X-Received: by 2002:a05:6512:3f06:b0:492:f6b6:ad8b with SMTP id y6-20020a0565123f0600b00492f6b6ad8bmr993416lfa.544.1661427223942;
        Thu, 25 Aug 2022 04:33:43 -0700 (PDT)
Received: from krzk-bin.starman.ee (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id e18-20020a195012000000b0048b0aa2f87csm446764lfb.181.2022.08.25.04.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 04:33:43 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>, Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Marek Vasut <marex@denx.de>,
        Krishna Manikandan <quic_mkrishn@quicinc.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 3/5] dt-bindings: clock: drop minItems equal to maxItems
Date:   Thu, 25 Aug 2022 14:33:32 +0300
Message-Id: <20220825113334.196908-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825113334.196908-1-krzysztof.kozlowski@linaro.org>
References: <20220825113334.196908-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

minItems, if missing, are implicitly equal to maxItems, so drop
redundant piece to reduce size of code.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml   | 1 -
 .../devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.yaml  | 2 --
 Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml    | 1 -
 3 files changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml b/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
index 0abd6ba82dfd..82836086cac1 100644
--- a/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
+++ b/Documentation/devicetree/bindings/clock/cirrus,cs2000-cp.yaml
@@ -23,7 +23,6 @@ properties:
   clocks:
     description:
       Common clock binding for CLK_IN, XTI/REF_CLK
-    minItems: 2
     maxItems: 2
 
   clock-names:
diff --git a/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.yaml b/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.yaml
index 6eaabb4d82ec..81f09df7147e 100644
--- a/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.yaml
+++ b/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.yaml
@@ -47,7 +47,6 @@ properties:
     maxItems: 1
 
   clocks:
-    minItems: 4
     maxItems: 4
 
   clock-names:
@@ -64,7 +63,6 @@ properties:
     maxItems: 1
 
   resets:
-    minItems: 2
     maxItems: 2
 
   reset-names:
diff --git a/Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml b/Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml
index 9248bfc16d48..d5296e6053a1 100644
--- a/Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml
+++ b/Documentation/devicetree/bindings/clock/samsung,s2mps11.yaml
@@ -34,7 +34,6 @@ properties:
     const: 1
 
   clock-output-names:
-    minItems: 3
     maxItems: 3
     description: Names for AP, CP and BT clocks.
 
-- 
2.34.1

