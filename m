Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0CBC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiDYUYj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245205AbiDYUYh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:24:37 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4B1240E9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j15so9233006wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=cjdUL5ziwMdVVzxEZfjvHaBI6lZy+g4kq+A+FnrRkmEkrc1OCo1c8EOePImy851jRh
         VtX6/UqmPqERLcaYk7hQUdHDg/s12FxN3i5UtlSfCAkMklTiyFCXjfj42xGgCic9g/nX
         bUZzne+cMIxyiImXuVpHZWU9rYO9rgS99eCwtWZvNymgjGqQWEqibDQIHjTCZ+lfjcus
         NhZDP6bEC32OZSBmgcQp76ToZliVUG5jBSMPXKUeK7hTUPSePsFXyGNqa56shlptqGQF
         ok0UC9qZerwTR6GhsZ2B4vzKk17v+JS1MM4dO1v2ht5xnVgCrJb3PjAWcCCIG43qYn/p
         p3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=OWci/YRi1jsSJiG7mbsXRXwHmSLyw+HAMWkr/I4i1W7m7FwwxdtHqtk0Ry5dTggfFP
         SgL2+9wamXBggEH9krq4WT4Qnb16BPb+NEpYsSUSZjJlG43nZY8YgVuDasqNHH/xD0Rk
         FTA1NA6zpQP3IXKR2LykBziDh+TIXByGo4t3M2GefYDbtpi2Nqj4u9ZG7vGHz1FK/Yhz
         0R/xekPnYCA6b6XqyrqqqjTRRxH+NM4xmDMphOFu1fSG95h+UzNHKaUC8nMbE4ROJrON
         cPIz+BHplXpX19bKkTA5kPiYrYhvOlh37UtZ5AnhnCAg5TwGIoQBsuUS/E3kHf3c996I
         bIuA==
X-Gm-Message-State: AOAM531CMmi5a3u2yERJxubkCUPa22ZQ5gqh0qaDtHW5FHej6jNnRuAJ
        Mh/4yXZG9R/1b18TLb4208xu4w==
X-Google-Smtp-Source: ABdhPJzL6+kxK9MVCVjQ4Y/GIq9uyP+e4ezvDNb7cOKbfr1jUlJXTmUrz7NENZTHhyxXzHwxo+k7QQ==
X-Received: by 2002:adf:c64c:0:b0:20a:79c7:4bf2 with SMTP id u12-20020adfc64c000000b0020a79c74bf2mr15549306wrg.587.1650918091538;
        Mon, 25 Apr 2022 13:21:31 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:31 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 04/33] crypto: rockchip: fix privete/private typo
Date:   Mon, 25 Apr 2022 20:20:50 +0000
Message-Id: <20220425202119.3566743-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
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
2.35.1

