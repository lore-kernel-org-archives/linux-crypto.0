Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C658C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAAB321670
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltWL/0NI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392774AbfIFSqW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42901 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436555AbfIFSqS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id q14so7580052wrm.9;
        Fri, 06 Sep 2019 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mk9iiyM0WHriMjrKTK53bNyVyznn052YfKhoDOFj8+M=;
        b=ltWL/0NIoHGYNechlthfrItQ9BFEmloFHpTqEw3/M6HvdjFLXytt74OL7kTCA8j1Kt
         JHn+D+sUBJdHoDRjaVU1YaoFRb38IdxLNfKvEm3kAEKssc+XeChc/duhYWZT1SkRCORu
         m6U4l5HOC43ynNqIsNp6530iR3Pi9dAh4p9ZOTGjrk1YQE9D8dUsgEtiI3KiZ6wKdd4C
         M+uwyEpQ3Ouyt6jEaZwpOcoyqgAFr2rRSsungYDLbMAR5Zqe6lCfqZI7g4ZFDcCMhT5H
         JDNDLv/I8/CbVz6ePJWjHZDgJI6aVkrb2fJoz/1gnqpoLuKUNmpLfIpzNurmi1mCzdC/
         vR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mk9iiyM0WHriMjrKTK53bNyVyznn052YfKhoDOFj8+M=;
        b=mKlcAwernL6r051jN/nR40NP5PaisRxy7rxbiI0cOkNykzHVRrLLzRGiASlqyfM6gi
         IGPADMwG+4HICJ11wpzA14LjiFVjLx+MI7sMc+J5t4Rtjj/CYGjXDfktSCtF4HSxnf+g
         Dtn6U8kZs30L4EqDopAgJjQqUJ6eWwxhCi6uQeLT/LjcVMt/YfF6w4NPXJBlXn6htsHH
         YJYpAType+c+8jhf7RJRNe1NmLNfrC0kCYwYF/2RMCHN+/sgJ1P5ErqEomjt8cRC3/8u
         bES+RNY+p5JNIeM7th4WzbHqomcuYl1ZGPnBbdEbH6+xCdmue/unVpaMbOG3tkexVH6Q
         8cYA==
X-Gm-Message-State: APjAAAW5Va3n+V/KXJXInQOhOOxu8e1fQpAR9ZIApaFnr5AYS0cKK7OS
        nCIcF1Y027j8baG4IGRoWD0=
X-Google-Smtp-Source: APXvYqz0nobviNLqKZBy3ZK1oFqnw7zZh1G8l7RuxSpcJpXKnUegVQyaWqWl8zGGBhx++hogOT/Jdw==
X-Received: by 2002:adf:e392:: with SMTP id e18mr9008949wrm.87.1567795576314;
        Fri, 06 Sep 2019 11:46:16 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:15 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 9/9] sunxi_defconfig: add new crypto options
Date:   Fri,  6 Sep 2019 20:45:51 +0200
Message-Id: <20190906184551.17858-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the new allwinner crypto configs to sunxi_defconfig

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

