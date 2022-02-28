Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2277C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiB1Trb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiB1Tr3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:47:29 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1ADECB25
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:47 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so83134wmj.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mEFtl1Tv/8nxJX+EKBZcS0Lbq1ln6/kUirDV/Y73Tsk=;
        b=lQx2VbY+csJAyRFIt7eX5IaDOBUSlUvZt2a4k6mP7i9oFSuU1NpSPZPT3UjEEWpzwf
         3FRL8thZISZKU9o4hTP4wiuTTrK/BOfBbC1Dy94eU72AZnpZ7KVccfHPwLpL0NG+NKsg
         TMhNvapt7Mw2X+/IgEG5S1+gJlimzjha+FvLB/Solu0vabZAkAAXtf5cPnTcefa/VVz1
         hbbJYTsQh//MB+2TqZhHAzPEljRiaX5ydBw8Yl69/4HLp4au5KCeNB/CXOTLKfldQr0R
         CMlaeqCy1JhbCKIadokaJUGICFsQ7w8zqpaVrXbTK2FBgrrf+ESmvcBRbeJRAGB7aJws
         5Whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mEFtl1Tv/8nxJX+EKBZcS0Lbq1ln6/kUirDV/Y73Tsk=;
        b=DLJqXjB/xjjmnAQSMQIcto4LWmmq+lUb+e5CbFZd0bS3A+ligJtoxpG6l8gcy7OTEu
         Z0IacfIU6PM4TZXc6mCBrZVp5QsdXiF2g+6xZ9BpBYCQAF/ec8bCVCoblF6FVEhCOCtu
         wR7bVxT7a1i26V+Ifxm7voF3ruwT4Y9vuwHmrEOQ4APLCxNXiflfXYe8o29fjRxLf5un
         0H8sAlO/fXTROskmtwKqGwnhvXAuKx51c3u47m1N8LzzF25AyBUM1SUnxmIVDuLoCMvD
         idJvS+wnozyHMfDIr9EgMycV76a+HgoWJM8yNjdoi2sxjMnQe7WERcrDXLbaB/Defd9i
         VNow==
X-Gm-Message-State: AOAM530NcwMNHlZQMa/kABqBd20PchtOVxgtDDS0LfW9jnTa0AMue2xz
        zaBIMn925USPevMY9PGKGqWSWw==
X-Google-Smtp-Source: ABdhPJxdGc/N0K/WMNBAxdA2Xy90225k29BBt3Jrxn5PKmQwrQNvHXH7fJ0r/q2b37gubKletRecXw==
X-Received: by 2002:a05:600c:a51:b0:381:3dc6:c724 with SMTP id c17-20020a05600c0a5100b003813dc6c724mr12829847wmq.106.1646077246583;
        Mon, 28 Feb 2022 11:40:46 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:46 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 04/16] crypto: rockchip: fix privete/private typo
Date:   Mon, 28 Feb 2022 19:40:25 +0000
Message-Id: <20220228194037.1600509-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fix a simple typo on private word.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 2fa7131e4060..656d6795d400 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -235,7 +235,7 @@ struct rk_ahash_ctx {
 	struct crypto_ahash		*fallback_tfm;
 };
 
-/* the privete variable of hash for fallback */
+/* the private variable of hash for fallback */
 struct rk_ahash_rctx {
 	struct ahash_request		fallback_req;
 	u32				mode;
-- 
2.34.1

