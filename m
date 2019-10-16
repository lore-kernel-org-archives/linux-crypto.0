Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE9CFA372B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8460E218DE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGLnN2wb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392769AbfJPPBx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40825 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392725AbfJPPBw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so3128776wmj.5;
        Wed, 16 Oct 2019 08:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=hGLnN2wbqzjUWYMYe8XYApr0ASx80B8BAD0rdumLrqT5gUGWH3QNtpUOaD9/EQtuG4
         rPiG7+TK/xTsteZ+sUZ/aH58g7wTO7x9Tn7+Dswe+dXwVb6MrW2Hy15tEpYZ7YZdccXE
         3Y9FPj3AK15cCRBQ52zd9W4L9KXPlUyC100rr8HgMyKmTV7NH6EKESyn+uVUpPV2YAWO
         NXYIP+bPKp8A5JzDtQXiCd/VrjDZYTcB+UHTi6PQWrfKHl3g+FvEBtRf/ZtCFX+GLlwn
         BBRJgH5iM0OQUyHSO+Bdnb6AGKhwLfGyG6ipzNjSWgLI8He3rhQZp8WVlP4CUY2r5Juu
         viMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=H1S4uRyEpUW5RjSTWSvqPXKLra8nTLaUcHdDXrIDLubek4hJBSZ4VIG4rfHlY69x8l
         WyvFN6ObK8Tr1oy6q9jQszTaXnE7YwzM3XlcysZyBC89422Wjffqwy7ofi+b9se6I1fo
         7SYcCmBeJl90JUDnFdJEz0ZVcffVUiocVjCgSw/LN6WP8zK0/P9sXbbN5olSL/SVeNuG
         hLH5dVgg5z1Yo5ZBf2mGYwPb5lo8vrbr5bE8MormntdF9clw2TT1apzrlaFZnSefaIpC
         1KWuhAd/6J8KK3BIsnjKsxLflXUBwqMXPgidFifZbaSEEgwCzVU5DimexhRUYz356CvS
         +oVQ==
X-Gm-Message-State: APjAAAVUbp4ktx28C0Hqo+y2fyd3ISj6dQmaN6BdRo4IVvKw0yzvs12m
        ZmpyCymyHAQ6LPoud5g9Se0=
X-Google-Smtp-Source: APXvYqxl3T3uwG5aP5qnrKKLv/pkvE+DgPTNy74QVnvBMf3pd7lADd34jdBhjW7d9AlIdJKHZJEPFQ==
X-Received: by 2002:a1c:7c13:: with SMTP id x19mr3768680wmc.80.1571238110118;
        Wed, 16 Oct 2019 08:01:50 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:49 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 09/11] sunxi_defconfig: add new Allwinner crypto options
Date:   Wed, 16 Oct 2019 17:01:29 +0200
Message-Id: <20191016150131.15430-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the new Allwinner crypto configs to sunxi_defconfig

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/configs/sunxi_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index df433abfcb02..d0ab8ba7710a 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -150,4 +150,6 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_FS=y
+CONFIG_CRYPTO_DEV_ALLWINNER=y
+CONFIG_CRYPTO_DEV_SUN8I_CE=y
 CONFIG_CRYPTO_DEV_SUN4I_SS=y
-- 
2.21.0

