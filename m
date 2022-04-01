Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C04C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352309AbiDAUVf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352307AbiDAUVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:21:15 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FB626FD
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:33 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c7so5896577wrd.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cR+Z8RB2co35LM6ASUB3urTOV74O7Pl6BmQw6qrgeVA=;
        b=F+b//7ebZG6SCRHXjH3fcWFvI4evbQH6PJM/pT+w539r892GHo348TQMdaMRMfNJEU
         ycStsmkvKpGsMvZcKrnBmcEGzx2cx2ShdH0u0MmZZ4cjd+CnfevBIHmPI2Gzh4JP0+eC
         hqG8Ftc9sXwA0mU/otz7fizhDV52kkniz5Mi4XP8JM+3QrSmkr+Gs5Og0wKr3ZKms1kH
         PCKVOOJwToj3KMGhfgxkS8ArFAMUqo4X/INfy20Pg+zH8+0ct8PxPGtsbU9Y3HdrYpWz
         xqtJbQ5o5vwkhJr2wkLharTSxiNLPoDgdES9dOlXcR4ZvBmuz6pAULXYuKzwSy7KG6Hu
         isdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cR+Z8RB2co35LM6ASUB3urTOV74O7Pl6BmQw6qrgeVA=;
        b=Jt65tFNYDyw49nMwN8KpjwVOm6SwOMQhogCjKi6BrnOdpZjkAf8TaXnIBDUWRBrnt0
         kFM3iauYt8YRkcO0KY9Pq7b9Nh8ho074SpwYUYnqE9TcxZNFnPtXrxh+06xUHMyaQc0l
         Zx+3lyGazu87LJJv8q288YBPYViqXFkt9Z8QXDSmLQ9VtSYNBmzBzbCug004BzKBbUTW
         NZP0Tvp7hHbtfAzah54a4gEwjzKRvzieDzeRctJWEAesSYHfrSV34rh0qqAbEgRun9bu
         L/Eqnb1VwBnTCFrvhJOhi95hgJUwoVP7kBG4Jf7mZFYjcLM9XLYuSSJDzbZIUAwrTA4X
         pX6w==
X-Gm-Message-State: AOAM5335mbev5M9e3gw1/9NlpgJ0dx2oFcoY1Ek7bsTXP9XvazHUW39d
        3VuQPUBa5TE768S4kUTZYK5tTQ==
X-Google-Smtp-Source: ABdhPJx7aIKPQJg3dNNasF8MG7dM+sdSO97S/xOctU0CE2QNY6+zyb9ZXNyg4h8USL9vf6hITMWslA==
X-Received: by 2002:a05:6000:18a7:b0:204:1bc0:45a with SMTP id b7-20020a05600018a700b002041bc0045amr8815545wri.119.1648844312181;
        Fri, 01 Apr 2022 13:18:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:31 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 29/33] clk: rk3399: use proper crypto0 name
Date:   Fri,  1 Apr 2022 20:18:00 +0000
Message-Id: <20220401201804.2867154-30-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RK3399 has 2 crypto instance, named crypto0 and crypto1 in the TRM.
Only reset for crypto1 is correctly named, but crypto0 is not.
Since nobody use them, add a 0 to be consistent with the TRM and crypto1 entries.

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

