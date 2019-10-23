Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D015CA9EBD
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32234222C1
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ/WXXua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407394AbfJWUFg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35442 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407380AbfJWUFf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10so23031078wrb.2;
        Wed, 23 Oct 2019 13:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=IJ/WXXuaGsjV2nbd3uPDj/HBGcNT2h0oWqgN61iNwEn65bldac6rkXzSKUel8YgC2+
         GMR+RuocKR33GXbKVDwIJBcN5ydjN11MXZOJtzFyJJ4+gC73q2q75geAyMy/vvTM0hON
         FsMNrHdrwe3BQLN4i43tX7YcLkCOFDfrtmS81RbmJ1qQZnL00GAwXyA6DCugsnYfDNZX
         Cm0OwpCCrFozTaLAvMhmrmq0tRP7YPraNd5+d20nPIaL7DYN7oX+wvLTWHArBIagCG+O
         XSL8BmyPvO3YHKpMjmecm388oQMcMu0XCxI1U8FGSVmdnLCDI5Zpa/atM0hmOwRbqF+7
         1kXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=QMH0PzuLAP+OGcyJRMhm0Op8eXaExquaN/ak6Amj1HNHkIImrD2RQKHNtaD5nUpV9Z
         QY3EFYxrHMYmgJH22jj7bmlY3du0Z+LxR5btDojsJlys1JS2WKyLVYeLWeTLlaEwb6AF
         7v+97ru9xDKjRee023IOpnzI9PDp7sNmYbqThr3yKvvuXI1xsXFFRg82kmDoCmQ7IiIM
         H60FSiNPW+QRqXMBcLbnjyD8IUOB7qWbJQlNvPlocWaFAqIq40UgsEEAAuHz+BrCjoKz
         xZ+CI+8BWIRDIIYsNDIdm3Cb3ieaQU8JYANp4xqNLz7MmTRMyuLyqpFqTwTQgu3BAVpf
         lSWg==
X-Gm-Message-State: APjAAAUTRZ1uOVMbCmSuq7wR/Utsvn/kOwloKrvlEzHjP3psNzRHw7b0
        bYhGiTEFuJe9ExDr+H0Sai4=
X-Google-Smtp-Source: APXvYqzn7VyibbZQTzr5picGAXpdNbro7k173sZWJw4EMmfTFdRA0KSHMI/3UG8KcQb2AkIzZM0SCw==
X-Received: by 2002:adf:9101:: with SMTP id j1mr401777wrj.71.1571861133138;
        Wed, 23 Oct 2019 13:05:33 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:32 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 10/11] arm64: defconfig: add new Allwinner crypto options
Date:   Wed, 23 Oct 2019 22:05:12 +0200
Message-Id: <20191023200513.22630-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the new allwinner crypto configs to ARM64 defconfig

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index c9adae41bac0..c45fb6822e4a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -114,6 +114,8 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
 CONFIG_CRYPTO_CHACHA20_NEON=m
 CONFIG_CRYPTO_AES_ARM64_BS=m
+CONFIG_CRYPTO_DEV_ALLWINNER=y
+CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
-- 
2.21.0

