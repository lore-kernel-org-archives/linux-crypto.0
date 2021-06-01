Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCABC47092
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D227E61378
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhFAPNj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 11:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbhFAPN1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 11:13:27 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8DC06138A
        for <linux-crypto@vger.kernel.org>; Tue,  1 Jun 2021 08:11:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h5-20020a05600c3505b029019f0654f6f1so1298313wmq.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Jun 2021 08:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s8v8Jp0/rfEPlkp9XhdnLdHk722YQ+tq+nr0R2AwQ5s=;
        b=TQzJ8IV1oQ36hKJrP1tDjXvJDcPCTaVcyBJqwLQWXW4i/J/12PfueR1gE8GYcq5dkD
         jfvkX2yIEwKS9b3A4LYcp/moCf2tUVPsLHqEVaZsFbnuwrqPTW5FWEx+avAv/p7MKNSz
         5jOYPruEUp0T+PPZ/HSTkQwGDSoNEiSO0KbpK1OxWDkBcev9plIVfOw5XwdHe1XEwC3d
         mc0TvRJeIHn9yS81HNBAutCwuzi1SlJlk3YnCvP1qiegKv2EybrX4NpWlvYR3581k4UO
         2A8Ow/ljvM9c8WvQYh1mmgIBLgBOi2OhEYOIy37SBoewjI1UnTWFq+So6F+QkIEpnwiF
         QFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8v8Jp0/rfEPlkp9XhdnLdHk722YQ+tq+nr0R2AwQ5s=;
        b=mucSmNaRQj7CYC5LDJBzCowFXKryCRFMLQwEAOGtPQSbKINRpi6M1BIbX2WyDJCWrj
         +VX3tnC0IXUuwX39pTDARfUG21r2u0uIIl1uAXry7VA8kEF6zb1wW9lrGVeW8r7QIzzw
         tpkqvYr+WAkdTy9amg0Bg5uKEsXenctNXIaZeR712ObKR08Bi+04slPfIW87wW45f1HN
         n1MaMafqU2f2sAZGWr4HZnC/3asgFzRF2Ccm5NauYXv05T4CDQdeeACtZ9R6xnfHhojM
         BIHFY1OKLBBUMl0oQ6Fw4cJ9frTlCNrq0PM04FQdv24Y3aka2Ir/ghlzCpvHlQoYHYEY
         NeDw==
X-Gm-Message-State: AOAM5324fMAubVKdwJvvR1LNuFShfEBXkfKfs5hSV8iJfUBQPuDijQHJ
        NQmOmsb02ZUcwUdCnkJXLK6YKg==
X-Google-Smtp-Source: ABdhPJxz/yuFedQdkot/kQXyn3h2pRCCVDsiCuT4xOdxYDDNxG6gNMvMdESkKDFopMfgqdvdo96R7A==
X-Received: by 2002:a1c:f213:: with SMTP id s19mr11482590wmc.61.1622560303019;
        Tue, 01 Jun 2021 08:11:43 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id f20sm22344163wmh.41.2021.06.01.08.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 08:11:42 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 5/5] MAINTAINERS: add gemini crypto sl3516-ce
Date:   Tue,  1 Jun 2021 15:11:32 +0000
Message-Id: <20210601151132.1893443-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601151132.1893443-1-clabbe@baylibre.com>
References: <20210601151132.1893443-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add myself as maintainer of gemini sl3516-ce crypto driver.
Add also the driver to the list of files for gemini SoC.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d8648ee43199..439e353539de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1812,6 +1812,7 @@ F:	Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
 F:	Documentation/devicetree/bindings/pinctrl/cortina,gemini-pinctrl.txt
 F:	Documentation/devicetree/bindings/rtc/faraday,ftrtc010.txt
 F:	arch/arm/mach-gemini/
+F:	drivers/crypto/gemini/
 F:	drivers/net/ethernet/cortina/
 F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
@@ -7589,6 +7590,12 @@ M:	Kieran Bingham <kbingham@kernel.org>
 S:	Supported
 F:	scripts/gdb/
 
+GEMINI CRYPTO DRIVER
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/gemini/
+
 GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
2.31.1

