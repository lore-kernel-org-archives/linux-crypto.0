Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C2ECCA48B
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiGFJHu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiGFJGw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:06:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CF021E18
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:05:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id cl1so21071260wrb.4
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=SoR7Ux0on4nf1Qo15rxc7uNb2HO/RqGdhLcmgjl5TJEByBP0inejUpsOr/9+9c4VNe
         U116K/wfR+Ufafd45lYbdRzH3rmt6Y/5FzkewGjvyiK8q6SjpI6u+1dIUiDvyYyC4Mbi
         kwKhdmm9RZMnCRTTCcoYZdYu+JxdHWjrAX3I2fXsey51UGDw96iSQbH4mr2/lvmIjiGJ
         dVtw7lH3wQ4YX72TefVnwD85Nv4XoN2RiIX5+SqTM5bBc3XRAEYGPiLNCoMlJCcOo4LV
         cV79VDm8OAtCOf3BIV4j55ctG2COtEOh9mUkjNzSAs8uq1AHXUA3JSxfLnYfZh/13TP/
         oewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=KHkqB6sdJfF6F/AbUThD4PvZJZ34+9E5lvuYv0Es1Qvus8J3XQud9NTqn7RY8aV46T
         6HDG3q5HyhCHQ1Uy6wQQyLfSmVpdgSa/rXuQe+cEYeT5xvJhaGwtqU8EFgiYAGg2O9Wy
         /9emPRvgni+oU4PuiBtGDgxRyLpsum9OLMTcAWc5Unvd+ykvAzaDjLO0ySyhrmjdEmro
         DnPFMSNYbSOyQ46tfZJw54WXoy3UqtlPSEdqNcsTD+ECxkoyfzNd7/ZssT3OmG9tHo4o
         Tah8EHXw9zsMTR3RXCcqWURZaPIOLhMNt0V40G8P8F7+9cPf4MhXrirVjHwHB0ADJ3RO
         fTNg==
X-Gm-Message-State: AJIora9dmKtkK9SRWmTaHZbO2PFR2CFbMFNqSdT8HZPvDGqlFEGbAF9z
        lbXD8ovCn6R8/yUDC0n9UHf7qg==
X-Google-Smtp-Source: AGRyM1s0NtrzbFsGKeEvThnAUtfR0Dz41YElbKBkLJkfRZht8Yko9gJ0WTqHFIVMkhaWXaYuStEsBg==
X-Received: by 2002:a5d:6e8d:0:b0:21d:7223:1e1b with SMTP id k13-20020a5d6e8d000000b0021d72231e1bmr7736406wrz.713.1657098300111;
        Wed, 06 Jul 2022 02:05:00 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:04:59 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v8 26/33] clk: rk3399: use proper crypto0 name
Date:   Wed,  6 Jul 2022 09:04:05 +0000
Message-Id: <20220706090412.806101-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RK3399 has 2 crypto instance, named crypto0 and crypto1 in the TRM.
Only reset for crypto1 is correctly named, but crypto0 is not.
Since nobody use them , add a 0 to be consistent with the TRM and crypto1 entries.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 include/dt-bindings/clock/rk3399-cru.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/dt-bindings/clock/rk3399-cru.h b/include/dt-bindings/clock/rk3399-cru.h
index 44e0a319f077..39169d94a44e 100644
--- a/include/dt-bindings/clock/rk3399-cru.h
+++ b/include/dt-bindings/clock/rk3399-cru.h
@@ -547,8 +547,8 @@
 #define SRST_H_PERILP0			171
 #define SRST_H_PERILP0_NOC		172
 #define SRST_ROM			173
-#define SRST_CRYPTO_S			174
-#define SRST_CRYPTO_M			175
+#define SRST_CRYPTO0_S			174
+#define SRST_CRYPTO0_M			175
 
 /* cru_softrst_con11 */
 #define SRST_P_DCF			176
@@ -556,7 +556,7 @@
 #define SRST_CM0S			178
 #define SRST_CM0S_DBG			179
 #define SRST_CM0S_PO			180
-#define SRST_CRYPTO			181
+#define SRST_CRYPTO0			181
 #define SRST_P_PERILP1_SGRF		182
 #define SRST_P_PERILP1_GRF		183
 #define SRST_CRYPTO1_S			184
-- 
2.35.1

