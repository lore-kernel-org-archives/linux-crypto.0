Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C3EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245326AbiDYU1C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245345AbiDYUZi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9205B13134D
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:03 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u3so22499941wrg.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=JoZr9AP6SZcjiUJhmOxsn7XFck2Je49++JUfwOn0/WL4wwIYd9P9yS+ZO3YNEoCPOA
         9ljPGCqM6kqisX/b9e3AC5LqX3X3YfFkkeV4tSuZJvJH6Tb8yT0z4Yp0IAcUOpDHUutI
         s+/BrKhMci0l9O2OO2WrljSEYplmGnsfoIVbZW/AruSar6/Lty++Me4DUX3+0tc1FGNe
         9MLONW2KcW346DEB9538Ub1LO+uWH+M9ZkpWSUlLFFDQNZZso0D0QNRxDnph/lyDLpuQ
         3HKqVFvsK3rGq7ngWoN8zUGZFpml29o4BuBdK+IxxLYgqnagTnbSIkRGi2CKm6LLbH7H
         V2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=QVLXgjslToPsOBkN9xQdUNxRYSb9O0gEkcgbFjDw2vJwRbj4Cos58FrXusZ0P8ig9x
         5k9i97JiH0agurtXcXjo827wDScmvsBZ2jxJziUW60mAZshqLn1F/kCvxD/SZsL3A1sh
         Miw7ieaaVRL4YV8i3wsLj7i9h+pG94Va00BQJ5+A973x0hbH6HLc55ovfSW/KrHs10VU
         lAs8qvRU3sYLrb4BtRkP1YulcGtj0ItRzhrG1RMM2d1sJUntRGNv7P2hxg5RB66CwRPt
         AH1Wp9AeZaI6rcB45xC/Beuw/1ALqfQExF+Rr77bCE86UpgMresmEiS0IRcrBgqgah0X
         1Atw==
X-Gm-Message-State: AOAM531wsjIoWvZhKSW8KkozwGT7/aA1dXBeaXlFx5jHZsoQMVQWDgCC
        BBs51AosKkToFrdjMWeqJ3SyDg==
X-Google-Smtp-Source: ABdhPJygPkLqys/y+U39Fu7BGJLLDi0mCvGvvIU8zZqRlYMrXn+sA3kU/XgMURJjA1MVzRZj2Sm/IQ==
X-Received: by 2002:a5d:6d48:0:b0:20a:d9e8:57cf with SMTP id k8-20020a5d6d48000000b0020ad9e857cfmr6236832wri.245.1650918112759;
        Mon, 25 Apr 2022 13:21:52 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:52 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 26/33] clk: rk3399: use proper crypto0 name
Date:   Mon, 25 Apr 2022 20:21:12 +0000
Message-Id: <20220425202119.3566743-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
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

