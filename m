Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47A4C10F14
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1DDD2087E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmVN7x19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfJLStM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39662 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbfJLStM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so15258049wrj.6;
        Sat, 12 Oct 2019 11:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=XmVN7x19aNaggULUvSZupAZZMhzBhr48faHS49pLiyxHuLH7y5SM1o5T80Nh+jPNS7
         JR5KWuIxukmwkvtbXEGGfqkj94RL2aXIKQKgiGjTxJZzAT53BnpFryHT3edc8hpVitbq
         ohbLzYHBTiKONPpe+MLsNGZUoNyApYxRGAi0CWUObjxq8mo3GNnspczXPNqTwkHtcBAg
         fFmFb526ssToYKID1oL+DdlJwf/RtX1oNIv6wn4LCHm/oymv44myVjGjBNRvPu5/wmzK
         YGCsR2h/O48Ev5U9vzNNWxtULtzuCCZ96TRKNWnFMU/bN0WD0icKheXIre9hvmWrQ3+b
         W2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=Kl+DLT+/5w+PQpT1phzh1xMa0dx7KYf8rcACblBqWzt2AfWniH8vhQybQPxudB2JRK
         YvOms/uEz9tmg0jpnXCxo1jPGfEwytGAb2/jX8Az5Qo9Z2RSN2HyvwGUMPMT5A4lXrJN
         FNuDl8yK0BFvj4yWK+w8cWVRWjklPFRC8d8SRuNR1cs4QrUJRmhvX+OqCi/59jMl35Fa
         EcGtD9aWSRSaN39373GRDC400HLilxITro7t7yiMCYIUtbik7wXl0pMQSgJRiX3Q5k1/
         CCZhAFfR65dckYgfvT/cZRWimlMN2UjJb1S3kbDdLyI2unq7W7jOGu7tR/7AIo7rSbgN
         rHig==
X-Gm-Message-State: APjAAAWnIqDZYMtwdxyH6QNZgwjoGANnFsNtGFZQelVClOsUSN1GT6or
        A7SF/awmQH1k/F9jVUHNK70=
X-Google-Smtp-Source: APXvYqzdO5j+f9N+5yh9nGHTDJJd43DAyB+rEujCLac/sFJ/vzap0GKUIv3sFNCRLIQwWpquB/Yrvw==
X-Received: by 2002:adf:ff8b:: with SMTP id j11mr16749547wrr.299.1570906150269;
        Sat, 12 Oct 2019 11:49:10 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:09 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 10/11] arm64: defconfig: add new Allwinner crypto options
Date:   Sat, 12 Oct 2019 20:48:51 +0200
Message-Id: <20191012184852.28329-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
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

