Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23450C07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiI0H7s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiI0H6K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:58:10 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23110ABD60
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:29 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l8so5988024wmi.2
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=V0VQZblY3ilqDl88ksU7sNdmpCxvXcKe3g1VMncWlyM=;
        b=1PX3SXj7VPF0pe7fhlNFB9cxwIRGoeeqcKLXCn49u5WMzeqSM0T09nj6e3A6DOKU8q
         tGcMs5u7Y80omnaGO5Bqw4gPL5/YObdpQYk4sXIQc+Bv6xJobf1FIeT//nhZ8Z9tiu4g
         dJo4c3LyA1MIScZWHvRYHWrDq2fDzTcKsEmlBe76Bbu916t+kk3MP+dzVtZGxyIb7N7D
         LyDyu6wDzZXY5DIBWytQLu3dfejqbgNgJ7dx0MPJqPpOX3TJ2iSA+eY2PS7Y+uZCqkh0
         K1pGmnB3scOqO6nbgmogm3dFqMkElIzaBqI8+x73RdpMpCYZDjqwP1Z703xvRCt/2P1/
         dYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=V0VQZblY3ilqDl88ksU7sNdmpCxvXcKe3g1VMncWlyM=;
        b=HwC64lnIsctT7EE2JIyhBDKeRF3JyLAp+wrk5UF+yBmoUCnaBuRDW+02Y8dXCN7/FU
         /sZx3w1D3utler6O6yM2pjeawLW5/yG2Danhw7P7bMqyGfGyzvF58iMkQK6ZtKycuEp1
         Mzs1/E9Xw7iwEoNNkwT/En8xP5KfW9SvrK5G27O9971WD/Z2RqvkYOIUD0s5fsEGA+CY
         OzANiXQdgQXVC5ulPB6JOmPKXv1vloXnE5rU4b93ySHgp5SpfdvIqEhm5IRcw0b10slc
         0h5Gt+1yRnQjihsph/g0eG0YCj/EmaohmQ9ymKK6SykzNmB4LMOEipYcdd6bK1ZA+kpr
         gQHg==
X-Gm-Message-State: ACrzQf2RfsyAP3kpuH6eTMe/17SrFR+EVvxJL0OT1TrIuCQXQohFdi7x
        T+PyT4aO36+qp17yFGFwbAV+Kg==
X-Google-Smtp-Source: AMsMyM6frkTpArL1ymbs5PR7cpgsCIvMZ4EbT+UIaulpCw2vJIN/ofpo1m8tRMkH7XX/NfYVj+uOOQ==
X-Received: by 2002:a05:600c:1da2:b0:3b4:856a:162c with SMTP id p34-20020a05600c1da200b003b4856a162cmr1578572wms.28.1664265354557;
        Tue, 27 Sep 2022 00:55:54 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:55:54 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v10 19/33] crypto: rockchip: add support for rk3328
Date:   Tue, 27 Sep 2022 07:54:57 +0000
Message-Id: <20220927075511.3147847-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3328 could be used as-is by the rockchip driver.

Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index a635029ac71d..c92559b83f7d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -202,6 +202,7 @@ static void rk_crypto_unregister(void)
 
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
+	{ .compatible = "rockchip,rk3328-crypto" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, crypto_of_id_table);
-- 
2.35.1

