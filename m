Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327C9C43217
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiDMTOR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbiDMTL7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:11:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDD9716E8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:51 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c7so4045761wrd.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=4qpG+wPcWlV9H9McNW/hf7VgduGQi//EfkzzVnJkwiWrdA1qy0fZjNBenGYQhb4KIz
         ZI/rK/jiVBms6A5n98XFq0U2AgGhfrXXwqpm2r7tMySiOD/9dWS9zjhGg+E2ebfqrlo0
         J+mz0FrIgnp41e3iAdCquF0DXaoBnKjxbT+d76dk2yHyLOxVllirausymvjwpJz4Q41Q
         S4o2GegL3njFzUdOm68i1VMVLAzvRtHHFGdU+PJ0N6FvGnYU3LiEumwcax32Ec2WJNwL
         e7VUWlNDJIpePsvHTcMPfcO/5p6Mlm3R0a8b/FAR9EEDKXm8U2EJjjh+VqRYWAiG/LKF
         f9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=LpuPEdL9bDQoSK+0x2xr9wfb870U43o5IhfIyPw9PfZhlCsUUnLMg2pxXYqx+UhORp
         zEuGIufCsMFvFmSYrAAaj1vMVOEfjK7tVRof9AWqqSMRne9GNc1xYNFXuSZM/TjwsJdg
         emIhafIpob6+982gzUymLnUTULNVEZeEiYYFg67vrp5k4ufodHPrzFSgSz+DFEpplEXF
         cJbvj3XaWfHLFJwmiqPOLQPQiGfQSzegImh1BU1giPNDTikp1MB/vO+mcFftQ6l6dZyz
         8BThnYhEhp2/dT3VPvHPSFhOccg9k6p4bU0kgczwqbZJBwlKAMCXf6nnhbqXdydrRYXb
         hMMg==
X-Gm-Message-State: AOAM5335jU4bpzsc3KnVS8OJKrxYt9EeG0sfj5ZpoCN7aQsTRF/E/akJ
        IN/9P7cah6RSFLiXNDcC4AqnjQ==
X-Google-Smtp-Source: ABdhPJyrIgrtc9/ftutZeGYOaxutVIoFcU43Mu2qQQ9sJOihz8w+iWn8GtmNQotyL8RG32NjdF5GLA==
X-Received: by 2002:a5d:4cce:0:b0:207:a1f1:6f50 with SMTP id c14-20020a5d4cce000000b00207a1f16f50mr229342wrt.139.1649876870075;
        Wed, 13 Apr 2022 12:07:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 26/33] clk: rk3399: use proper crypto0 name
Date:   Wed, 13 Apr 2022 19:07:06 +0000
Message-Id: <20220413190713.1427956-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
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

