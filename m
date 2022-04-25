Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34482C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245323AbiDYUZd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245333AbiDYUZV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B212C8CA
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:44 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q23so9599894wra.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QNKqn6GgSk4bpiHhHcjzWzAApOdvZObjZd/qjun9sbE=;
        b=W0+hzDsyXNRUErPDaVkKaOZ8ON7Row/GsuoUT13wsSaj2QnuxFUn/r5WvW7TNK9xF9
         YSQSKQH80ebP+iHZohlvr4f4lhpiFxEFnBB2um3EWBUifD2390UyrawEW3j0azci7XCR
         VZLV+62XxeC39WNCrZ0VuvBVXNfjAUJr4y7e8uplt++3ldMtWQTUSFAM+JcX/3qluFDG
         0sNkaQ3fPwZeNORGpS4HwZGfQcBgpXKRqd0Vajq024YRA2E53xRlOez6zJ6KGQ31r931
         27fK/PXwWOh1ngC/E4idPt2qNj/p3bb/pcHBQ1EwKoFUfU5+AagnLhO3zjb4UEKMluYM
         LpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QNKqn6GgSk4bpiHhHcjzWzAApOdvZObjZd/qjun9sbE=;
        b=tqr13KDuRZBxC7xJs3EjetMmKV95ZPkBHb7ZpKGGlTE67f4BZ4uu+K2s0GfAc/ieMK
         vEJZdHCmwIWO9WRu3vbui5LDl9eUdMCQPEhvz+LrOCes5Y4gJWPUfDLhQU5QzyXl+2PO
         X2iK10ooRjkZsf/UgC4zPbxyRUrLPtnBI5EXCKsZLO4/HNl55/DKFIX2choI5dwV/Wf/
         dyXl1wdWOu1IDczAROZA6Ityl1PxpIYMeY+tOC0PyWIpqbSZfsAqLLjESTeKB/9nhlrJ
         MMnRdL2WlGWXYnc3hPDBxNcROsZTFak3BOOvFMNL7yAXIHCABwjjIcOlsLEx9w2T68Kw
         NUbA==
X-Gm-Message-State: AOAM5309fQunsw24VCG+ZEzlj4cTmp+SGn3ScvZjLdss5bnt0srcPUwk
        3sJMVcouiQF1mKC0BDEB7e7oFw==
X-Google-Smtp-Source: ABdhPJxo1Ew0MzI0MJNR79IL+3D+t6orpWGHjYg0Sc5MxK8XNn3M5uHQCyKIgUGey+QsAY05sGQ88w==
X-Received: by 2002:adf:ce89:0:b0:20a:d917:5234 with SMTP id r9-20020adfce89000000b0020ad9175234mr6749610wrn.265.1650918102961;
        Mon, 25 Apr 2022 13:21:42 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:42 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 16/33] crypto: rockchip: add myself as maintainer
Date:   Mon, 25 Apr 2022 20:21:02 +0000
Message-Id: <20220425202119.3566743-17-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
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
index 6157e706ed02..1f3bd9b5827e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17005,6 +17005,13 @@ F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
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

