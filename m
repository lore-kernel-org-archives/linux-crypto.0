Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEECFC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353088AbiCUUKz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiCUUKS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:10:18 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E563018461D
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso171509wmz.4
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4gMoepUVOvRDAwTmdAmkWkLiyH53f2JJghRF0kAYUp8=;
        b=RDx+GXVUtpQmfbr16DO6Yq2LL7DbfVvfRBqBwtb6SSusIn9ZBx50PKSTikg0mRz6tc
         6oxmv4dy2wKCWPdKx9D7rxLiZbRgyRs/vQu1V2merbLQjyFP/G0iT7zz/q3t9N7A6jt3
         YLFAynrGGAnpEVVGUhBzCoA6t5wBknbzxTFFi0Gdy8lpKDyGwBOK3bdgMY8oY4/hMxB9
         fOXBdOAkwGQhaLdRNWRHd66hiC+vndiHtkb158AufTRG3S2JhvwCYPagu93Xie5VkfJr
         k7eDzzS4x/f6cQ8uj4b/dNiRFrPoEyy+9+s1/r+A8XFZh+aXGywRjmweWthRxEpScRA+
         QbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gMoepUVOvRDAwTmdAmkWkLiyH53f2JJghRF0kAYUp8=;
        b=EOOObI/8HxLu88T7puo2oANgx+z9HKrUe9j4RSzS4VyhO38wrUtNapInq1zqT7UEaJ
         3oNrOCUa5Lb7LFe4tKLnIwwlXPBH8oHqnBT6Q76w96tKkO9pnas7a5nEThYqrReHn54x
         0ozHMD9A9nQamX2DKptkv3xpuID2Y+IaZPwwTg+YYLXDNDoZQPrxDGep1o7D5smGPlwM
         poZK94cqxveGQNOCKQmDOUsfnYp+QDqTSIpFphE/5ukTg8f9+57W+k15o1dzDoJqtf0s
         fuTd63YZgA5IMQG1qdtLg9ZshTrpph/VtwLtmcTv2Jy90x3rfuKmcZmLQ0bvABIUek7M
         TxUg==
X-Gm-Message-State: AOAM530MWSJdrBHR0zV4nMOCk9pHLQv+oV9RhJBLdAJ1gUYdw04ySl+4
        yIGRXq3kGW0x26KToT5y1mywPA==
X-Google-Smtp-Source: ABdhPJwulLc2e95bjKUvggoQfu0QNbRnAFa6ydl55NbQ/vrr36S8Y+UYDhSh6EwwXvT6NSWfbKDUdg==
X-Received: by 2002:a05:600c:5110:b0:38c:9521:8ef1 with SMTP id o16-20020a05600c511000b0038c95218ef1mr650466wms.107.1647893288443;
        Mon, 21 Mar 2022 13:08:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:08:08 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 24/26] crypto: rockchip: add myself as maintainer
Date:   Mon, 21 Mar 2022 20:07:37 +0000
Message-Id: <20220321200739.3572792-25-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
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
index c520915a3222..df4c72d37116 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16937,6 +16937,13 @@ F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
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
2.34.1

