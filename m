Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2F3FA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 470A720659
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgLyQQry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403812AbfJPPCB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:02:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50735 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392381AbfJPPBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so3314117wmg.0;
        Wed, 16 Oct 2019 08:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=JgLyQQryj0eA+sYJtGOd12dQE65/3+WYlU76GRGWL7QYq3MSbeGICg6hIApF4bvduG
         W+tYtqFHuq6VI8P4adJmdZlX/RkW+fzMZZTlQLllAwi0k2PmffKE8ghw+t9bz9L2YXV/
         0DGhcMmW5bnowWzG9qPewqWGqbrCe3HRX5nDdw3w44kibHN1Q7hT0V+JPIRjGZrG/94A
         qa21HzCMxV9t23MsCevXCVTa3kqDaa/l38wvimxRLHz2EphDkW58auw+gOdsys1Cv4Gg
         KUwZYFc+Uy1AJ97hL994asr3En3evwKv1FYvOBvKOa+3bcrS0lqElx9u0MSCGr9wFoAP
         kvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=FGo23Y8MouMkLTIUrMZxvmjo960dQR6MH/COpB7YOE6LHYOvthqYtN3Um+w1Qedz6p
         CORxJE/v/OCn4shd9CA30Jz8uW1tugbDzTokd9P5ljc08N5ky6QHJ1hHFhE/GeZ2R2si
         dbPjjvj9Et2vkgBe9foQdWsh0O4H2aJZMvtd/W7BY1Md2qq4s3vy7utuL2IMP1opIVb9
         p529yC2Z9QTQtery7GRU3NIoZ/tACZGKUzyYjD3tjN/EzFJ3dztR3GzlnKbSTSqFTEQs
         kP8r8ESBCHAyRkiy4w77wG3FmeL3MGD+vApB7QapbDRo5uQD0GKU/ABQkdi+3qWOljzR
         H3uw==
X-Gm-Message-State: APjAAAVuSJS3lNqgdiqez7/+gLliezIukWSGjDF9TxadStJHBJB0hvII
        ovfP+djOieDF0p50CvUkS3c=
X-Google-Smtp-Source: APXvYqySmiyI+SjaCQ9qvcdnpi+1OK1iWpN+8PVkIUj8XtwO46/B1h3rmjMqKlapvIwJYFQCgxTFIA==
X-Received: by 2002:a1c:b4c2:: with SMTP id d185mr3497704wmf.159.1571238111734;
        Wed, 16 Oct 2019 08:01:51 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:51 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 10/11] arm64: defconfig: add new Allwinner crypto options
Date:   Wed, 16 Oct 2019 17:01:30 +0200
Message-Id: <20191016150131.15430-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
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

