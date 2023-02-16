Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA17C64ED6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjBPNOv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjBPNOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:39 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A97353553
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:38 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id b30so1909664ljf.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8Dshvhn/u6JxIEsr1GHQ58ZptmtCs5B/Gl7LxOGqZU=;
        b=EGhvTziYsFm7oahPnP1OkeV+Vwy1O4j5rpvmA67G0FkQ7h+lWM+v9lYck948g1rshd
         k7L/m9J/+24+TzJQr0j0XMW97XCiAnfRFBbc1fzMEyt7B7GC10q3oLIhHeDozqkf2JlO
         WVAWyfC4JjIjiwa9Cwo3rQOKwdVZYBxDG+UkoQkK29eOkArEsmMVPf07luruOVXJpeme
         g0aivotitBH7by2qVt19YTJv5oeSJRUeh0/YjcktYhdWRHvf92tu4NkBWCciKIXl9Bqw
         l2KRX4CiEjfPltzBoppxfLCHp/UnKy24gy8TJCPELuU8b41Bmq3HMnnLbYwwN1eg7ug4
         lStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8Dshvhn/u6JxIEsr1GHQ58ZptmtCs5B/Gl7LxOGqZU=;
        b=f0blhd0oQyoPzuu6wTJC8ezNUOhpNtJaY6hsG2NMNg2fWdHBL69VolOQiuT9TTK/6s
         j/7EJ6H+iyzFyVIyZ2r9yDIm2Jd+3unT6Yba/9uUDIdhNqQgILteoInw3gzgsXVkkqbf
         TkrRISPO4W35tkKXwFRQTXTn5DURek4oiE/gCo8n/2sngQlIYuT/V0UjqWS8InG1t3fH
         WGF7uWC0Uo9/udU2cbFmF+xil2/yFQUJSNpGmUCXl4aKEiW/sThs8XGUMk1ahdfno/Eq
         RBzon45vcUCrtW10i+Cmp/7iBMbxqfbZC5+4RYnpH+dVHQZUr+X1OopyEP6DAr0I0mA/
         qJrQ==
X-Gm-Message-State: AO0yUKU5gYtXcK4mN4WCBx0pcmkk4iHC+xbHqkH857Ls/WR8rtH5P0vM
        j3xoLZx2rGnxQlAsFgEv1CDDoA==
X-Google-Smtp-Source: AK7set9uMYvXdjN7EkZNCcEXNePvuhN+rv+yPlRbDXytheBC2JAOp4/tMtVRGt2cwIyF7vxxEgOZ5w==
X-Received: by 2002:a2e:be0a:0:b0:293:1696:a042 with SMTP id z10-20020a2ebe0a000000b002931696a042mr2018625ljq.4.1676553276325;
        Thu, 16 Feb 2023 05:14:36 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:35 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v10 02/10] MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS section
Date:   Thu, 16 Feb 2023 15:14:22 +0200
Message-Id: <20230216131430.3107308-3-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add the entry for 'Documentation/devicetree/bindings/crypto/qcom-qce.yaml'
to the appropriate section for 'QUALCOMM CRYPTO DRIVERS' in
MAINTAINERS file.

Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0abf3589423b..e93f0d45b400 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17272,6 +17272,7 @@ M:	Thara Gopinath <thara.gopinath@gmail.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/qcom-qce.yaml
 F:	drivers/crypto/qce/
 
 QUALCOMM EMAC GIGABIT ETHERNET DRIVER
-- 
2.33.0

