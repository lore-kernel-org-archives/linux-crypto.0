Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B0AC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbiCBVMf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245113AbiCBVMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40B6DD959
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id p9so4705145wra.12
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mEFtl1Tv/8nxJX+EKBZcS0Lbq1ln6/kUirDV/Y73Tsk=;
        b=BGC8nrmMzBNASLXkYa2JNo0/+8z6t4pK8iDFZsnFwNbRNywY9MSW+in1XAfzhpduHG
         M90eCf634zQDtoqa+KxYP+4Q/F9NrnUwkV0Hq71kfygDD9iDFhDTHeVYM8n8ancu8Wro
         q9/ekreyuQmJOIiEAHj2lugGcj8qN6donBz7TnBgMRMjnxKurRav02a5XZt0s7bdm37f
         jOPee5RfiLPG/58Cp4IT85T9UADV/4UDPF/HI21FDDDpr6paXJoX+WUysCA/MpY9mPG4
         ow3IXPTXuH8j0L7sjRZWe+DrZywMI/VqaQ9slo4SDoglDlfHEfFdESIhiJ1pYZCEv+VJ
         JhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mEFtl1Tv/8nxJX+EKBZcS0Lbq1ln6/kUirDV/Y73Tsk=;
        b=8DOx0acwu6qgWLggy6MkUyysTjqIvTxTV4kxFMwyjKLEENn10rZbfi5+ETtZnSlxxy
         w9Rt7XCrvehgTITOdQZ1u6XJ96R+n1OQ8Qapfd0dkvyJXdLhTHDwbkewAf3/IQJL/k3r
         j1exfDVYSh1gnW2LAHYOYvYFcP56wWsuG320jKF8WvWqZREMmcnmRrBvbhHgilTLMSL+
         5+sDovga6o6hBx9g8GeIkhP8yw6NvzmpCSEN4I6nBxeqcL0NqJ1GMvqBut3os/j0WlRt
         9MfnfbJYTeVRl0CLb+tBhSwL/N64XLKFH2XTEednV743/kgYRI56sC0I2Skc+SWbq2BY
         IbfA==
X-Gm-Message-State: AOAM533x1le5xgI0qtDuAZBwEyMgGVLmhGpW92Owhi+SmTLn5+91VpP9
        aYChScKgONqyq4kqtpXM1g6N5Q==
X-Google-Smtp-Source: ABdhPJy3A1W9tLBSCIWiQnLMKAnn7XqQUscUgC/xxLeQMr8lptDLl6mme9vRIINzoq6iIM5uwmaMFg==
X-Received: by 2002:a5d:64c4:0:b0:1f0:36ee:15c with SMTP id f4-20020a5d64c4000000b001f036ee015cmr3143058wri.126.1646255486175;
        Wed, 02 Mar 2022 13:11:26 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:25 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 04/18] crypto: rockchip: fix privete/private typo
Date:   Wed,  2 Mar 2022 21:10:59 +0000
Message-Id: <20220302211113.4003816-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
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

