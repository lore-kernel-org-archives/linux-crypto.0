Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F85DC6FA83
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 08:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiI0IAm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 04:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiI0H7m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:59:42 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DADBABD6E
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:41 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c192-20020a1c35c9000000b003b51339d350so6487007wma.3
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=Hi/PfgX466QUwnJFm9k1zLSql6rT5CjE01/66twod+tuTI0yOR+7txzfcYZltmqEZ2
         WoO0mSzSJd1QcUwCvajDOwo4a8WSQNbYEOyBSkj05F+VRuK4K0dO02+IkF237XmXwmAn
         +85jsxrHxNkLEupTOLl/Jc3C4eY4I8wuGPll1rk0VnFMl+Ud1v4y64X4QhbPPZ0qQh1S
         Aaj2P3F7oWm3WCyuuWWx48rT5Aia8r85PLVZcHB+xB84TXvMckzUKZHCzyhWkm53PwR9
         EPOMevwrP9mbDOyu2MYuq/PCpengknDNrhgzZCtHleE/MywmhhlAeErCxGDOsn9r05M3
         ELzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZivRzjlDS3OoPoRTHkJnPDZ3sM1VA8uv4BaZC71qcQ0=;
        b=l0yvaN8N/mxAcwZ9pxtShG10GbpcwiS00HI77ADllk02Vg9RewY9mMR9GTu9B6c7tH
         PXiPGlAoxIDsout8v72pznIPPI9R4//msvO5jO4cDyJsYqw5KzXzv5EvzN+vhyq1OhP+
         dVbJ8Eofr9xGSaVqlqO48faTIHpgqAM/cGCMGAchXGASGY8mDaqz9MjlSHLYFvOJB/K9
         z9kBVEqGkVJjnADuKg3Sb8MXpFLNLuN3zCvBakhk2awuo30jZLICDb5VZLlBdm+srRbc
         KIiMQmUrrCZAnpUBdft6Z6COHjOQI8k9NKgzkAFPIprIFVAFvJbqN1kxpkdZICgFC6So
         1A4w==
X-Gm-Message-State: ACrzQf2zND90AuPh0pvZB/CsKV5tkit4BuRNH7XdhZZ/VmH4Ju0EhyeU
        vQOnAliIH67txYDyKcTD/drEdg==
X-Google-Smtp-Source: AMsMyM5TTwj3ckRPTtCPXJIEkijaJ3Io02K7CqsJQYSUJEPJ6vwCKX0TepgfinUTDLaNDeXwwOLTHg==
X-Received: by 2002:a05:600c:4e94:b0:3b4:b416:46c3 with SMTP id f20-20020a05600c4e9400b003b4b41646c3mr1645457wmq.149.1664265362733;
        Tue, 27 Sep 2022 00:56:02 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:02 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v10 26/33] clk: rk3399: use proper crypto0 name
Date:   Tue, 27 Sep 2022 07:55:04 +0000
Message-Id: <20220927075511.3147847-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
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

