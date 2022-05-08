Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39A0C4167E
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiEHTWE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiEHTEh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:37 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE292F9
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t6so16715955wra.4
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=q/ppPaIIl+eqJvd8tj15Mlu/trxXjFCeCmxtUyJ5cmEHGhk0rr3TVqFtvFdE2vJYcn
         ElQ3xcAP5TfTxgz7TBisUq0CV2bqoIQ1IlukREGRA5lUKE4LBFGxovImG/SXa5XWw46m
         dLvmZ8is7gwVB9yVwJ4Kekq5/k3HhWUy7lRHeZgzoXuW3jTC/guENjHIyHB9Jom33MB5
         MGfsQK8Tf6Bet2xwwhKIfZYbBLPI3UO/hpwMUznRvhpBmdX/ImnGrp0YyiubDJ6xuaiw
         cJuc/v54Lxvr07H1zWNlyo6vONTs+gsd34B/MPNeAIRL5xpPRoIw/6ezdiQUJqlODTV6
         7b3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=zbPEaUsMhfhn2IyBY6gbLUPaEUhtRQgQb77Mh0pXVa1Tg/GgyX9Kh2kyOczw4GvgZb
         vAEzzb7pPb+xeKbm0Go0dQvIsFIOA9TXq+IB1VPVQLXf606NhV7WaMUOXFDXrv912lFi
         Vebe/GdgdexwJr+myfJs7L/m3nDSSsSIfb0t0pi6BIYojGqMZmnXl8bHHMvbzhz0H7aO
         e5A5KE4S9sMj61XD5LEsWz8pMR5wEPHW8expzGWGDsu7wrXJo/9xSiy2gZ/BsQWON3yE
         79x2mPkV/w9iB56FC7TKnuj1lBuue6xn2RPMZs8Np2KvYDQUgJ4A2H46xfbsoW4nu3TZ
         L7DA==
X-Gm-Message-State: AOAM530VSXQJjoF0KMfyHejmM5AqSXEpjWmoAP28dLkoZZikRpavA5T+
        wIEV8ATAbKdLqwBgM3IuIDVfug==
X-Google-Smtp-Source: ABdhPJzWk7REzNl7td89g1KNSNNFMCGphZgLl+KXy+0Kn28KbOpy+jUc008FX/AJp8UzERzAeDGPKw==
X-Received: by 2002:a05:6000:1707:b0:20c:660c:7c78 with SMTP id n7-20020a056000170700b0020c660c7c78mr11031410wrc.150.1652036432499;
        Sun, 08 May 2022 12:00:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 26/33] clk: rk3399: use proper crypto0 name
Date:   Sun,  8 May 2022 18:59:50 +0000
Message-Id: <20220508185957.3629088-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

