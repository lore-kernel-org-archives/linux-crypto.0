Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B3FC43460
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775E4611AD
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350203AbhERPS6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350135AbhERPSg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:18:36 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A85C061345
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j14so8919222wrq.5
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jFCTwlOzCyGkFT+jpzYIcUq3/Vy+8ZcKhpBW1I0qho0=;
        b=QNhV1BvaQgIDlqYOu20oD6rPDmFXuFuPf2oT6DIEnRAl5lOYnVdsgZQuMRwPAKcVav
         jvIbTn4r7ouzUyBBIuQNaklvSSrZvC/ZW1/u6i6emLdXElxJrcH/nPoFgyCesOe2f0nI
         m2nmgYrpdwQE2gcQ+cibPLTGQ4JE/9OyVZSgXBc9YXacKSint6HQkXzZn7QV90a8ZvmZ
         OHHtX1D0f2NPqBUpFF1bQ652JJR4EHymTVjBUPMlOpyFMuN36zr5YEuk/gu8cKYXOXYB
         97H5uDaF927vWJKghF8qjLh6DJSOYRs8sx54vscpwMFnbIwrx+znxXPxWDiBSKwfY6QC
         X0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jFCTwlOzCyGkFT+jpzYIcUq3/Vy+8ZcKhpBW1I0qho0=;
        b=eQ083AG6VUI8Bytu6UrOoL7R1791OF84GYLPlqYJDsTPoR/44BTGwBNgNRf1nWHCbz
         TDmdoYT+ClVgZXe+plMsF+crnZ0RzdK1F1w0TjzvOCcD3XBqDH3AweML04tvKQTxtxW/
         ZCfbuscrxYvCloSrvCdWCZO4ddW0DklNzxMGeEzg4TcO+gCdGbH482bcTTdAy/PWXG8+
         LaQRgt9aR+hwmgKbv1d6/4FDKETyxsuxcctZCPyEu8lPyb/lF1eTQPWy/IyK5kh9o6eS
         k9Uz3cMfko6NdUkEvmWblIMaM7l4z9mLwuVatf+f5QoQbXt+j5m0I82hWVDws8pui2Dj
         zbJA==
X-Gm-Message-State: AOAM533+XdCfFQozz9CTjUB+z+dIOmrm7YAt+8zaBrUrsXTkINJ1I59A
        tkY3Kh4n7TK8lAP8yx/QZld5Fw==
X-Google-Smtp-Source: ABdhPJxPJqHny592cAapeXLJaUXqv+A5HRhiWeBXGl3Moieomn1uTTIYi7gK7C/OFgKAaMvPdFwmHg==
X-Received: by 2002:adf:fd04:: with SMTP id e4mr7598116wrr.116.1621351032180;
        Tue, 18 May 2021 08:17:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z9sm18005808wmi.17.2021.05.18.08.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:17:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 5/5] MAINTAINERS: add gemini crypto sl3516-ce
Date:   Tue, 18 May 2021 15:16:55 +0000
Message-Id: <20210518151655.125153-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518151655.125153-1-clabbe@baylibre.com>
References: <20210518151655.125153-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add myself as maintainer of gemini sl3516-ce crypto driver.
Add also the driver to the list of files for gemini SoC.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c59e8d6a3862..2d5495e21d0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1811,6 +1811,7 @@ F:	Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
 F:	Documentation/devicetree/bindings/pinctrl/cortina,gemini-pinctrl.txt
 F:	Documentation/devicetree/bindings/rtc/faraday,ftrtc010.txt
 F:	arch/arm/mach-gemini/
+F:	drivers/crypto/gemini/
 F:	drivers/net/ethernet/cortina/
 F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
@@ -7567,6 +7568,12 @@ M:	Kieran Bingham <kbingham@kernel.org>
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
2.26.3

