Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988CCC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiDMTKG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbiDMTKC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:10:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E1B6EC43
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:40 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m14so3993839wrb.6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/EUIIfE60m4fjWffrZnRhJkHwQAH6pvzsFNjcyOjc+M=;
        b=OhXrjpQ7TkqgTzvU861G+Pk5dZhNtBHUkuXDGbH/m5gtuoYcPwFTR4OwwwHQTCSKnD
         rPUg/K6BusXVCrYS2aYITzkfnsnby/5ACm8IjqxOvp+N/WtQlZzLgtr+ERFpOuZAy7j6
         JTmNcjTrMIlelYCRL7+TiZ2qyNnWRVxPjoPu27CGJfbpn6TgSTYAsv3coIediTDo62Y9
         qxRqoonC/Mrw0nd2Oj6/4ZvTPgKdn+XVoXOkqZbWuvyANRDY9ph8dUjF0mAYCTL59Soi
         oa2+pkJhoxKe9lPo9VOtwZCvEs4niAxAe6+tepMftrJO6m2TmL995WBhKtSdLTumifXf
         0ojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EUIIfE60m4fjWffrZnRhJkHwQAH6pvzsFNjcyOjc+M=;
        b=h6WGLvHT5gvliuFDCOtlsQXZht8meojnTZUv3XZngoI2cxgSqOjHE1kHvx8tc4VtDA
         QhoGJWs3PtQZN8ONQTkKllbZyOCd+AJM0kJyM+uMtxxh/caM0oPoNekM/0CTzguIT4Oo
         fZrW7KBuHpr3h02781vRHhCKE6ORXfQI1ZgGOVS2O1K1kIC5mAwr31OMQ2kdnHIiSvHs
         8YTgkjj1lNaPwubed8EIfoDRXuWSQdzcV90+9EjZt2WN9wh3XkOT2pVCmpNLKfF2zb2W
         oy6XEWc0bdQ/TN2b+5UUBTYHrPDF5bjBvHAgXVTE3tXRH1CIECPZaK3QkbL7LeKz+n8j
         ZxSw==
X-Gm-Message-State: AOAM532XiuKn3GVGLOUyl6UrVJoZbKEQkDNlS+jCl1D3cguEJDHzhYU6
        bJ4zeuwufmCCFdOKy1KHbmqhPQ==
X-Google-Smtp-Source: ABdhPJyd7sC1T0PJCNTlLw2E2XQeYDeV+5s9CziMq9ZGLP70JZ+RghahoRyCVXcIK5APO0x4BRk/MQ==
X-Received: by 2002:a5d:558e:0:b0:206:f7e:4634 with SMTP id i14-20020a5d558e000000b002060f7e4634mr242269wrv.662.1649876858616;
        Wed, 13 Apr 2022 12:07:38 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:38 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 16/33] crypto: rockchip: add myself as maintainer
Date:   Wed, 13 Apr 2022 19:06:56 +0000
Message-Id: <20220413190713.1427956-17-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nobody is set as maintainer of rockchip crypto, I propose to do it as I
have already reworked lot of this code.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1699bb7cc867..4df40a40bcdf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16966,6 +16966,13 @@ F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 
+ROCKCHIP CRYPTO DRIVERS
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
+F:	drivers/crypto/rockchip/
+
 ROCKCHIP I2S TDM DRIVER
 M:	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
 L:	linux-rockchip@lists.infradead.org
-- 
2.35.1

