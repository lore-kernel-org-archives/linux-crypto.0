Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FBCECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E2E21929
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kr8hUZA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfJJSYM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46140 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfJJSYM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so9017077wrv.13;
        Thu, 10 Oct 2019 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=Kr8hUZA75c1Bnf/XsiOtbPU0uR36AeEFj/LojWcMhcPK0PTEKY5Mk/Z/fe19InSyTl
         XfNFzKHocC9RsOGeC4k2ydCDBO5nZtWu2RXNN3MW21uLPAb2udgcoqc3Olgy0MnTvojO
         9no0tm0g37RlurDNA1JSCCxgrTFYblyVbsU1x9bAd5FnP+txB67ICOyFCfNAIXrJP/KP
         JvH2h+R5F4jewjvg08955UsdCdr+BUvUnZUuyOPV/EN1R+G+b7Z2ukroUKP+0yKdXLCC
         9QXsK2AVRbFS8wFFKF/pnpaGaceWzAx9GDZwxI23NqAo2vsERZsJsvplbtabukotAn+f
         R6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYi1VSAulK4JfPFywnxCiz/tj4/4Gu/YnXW7odKIbWU=;
        b=Am/OJHkVdG2DMeXnnzxrfWUk07BcpEyKENIMSdpUfrFQuJHZEla83QLu38rz/zIi5D
         HLuPSlKstwRIIVTqFPLOCrhOCnddEXdslxlT5Qp4LpTTVad+evNHyQ4lwd+0XHWAiZzN
         FSrznAnUiGJ0AvHA5V5hET+Ybbmspil+o43fg6DoY7aiFCIGMGYGV+AyaUxU8Um+ILme
         izvmdDQElN9bGdimKeZovqx3okCJdneot0dRMazV+ElOK0p3MnqlVkQej1q1MXrDenZi
         dhLbeovIuN43XQ1lMATEMYLSktPD1WP7WXQ4HbZatw+C1HUi/stUAhHiS0HUjF2vaf0p
         oH5A==
X-Gm-Message-State: APjAAAU8b8uTZpDuGi+4NVZ3S/nM/6jjstAbQslJmuegdHHSYF8565tS
        3ZO5WJNmOy5GCKf0zWFRTEc=
X-Google-Smtp-Source: APXvYqwP53ZvChovIvqkdm1RA2MyQqS2h1Qym7zVKohHbFRKdqrev/tdPed99iIgdJQF05D1SS7O4A==
X-Received: by 2002:a5d:428c:: with SMTP id k12mr9800113wrq.184.1570731850062;
        Thu, 10 Oct 2019 11:24:10 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.24.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:24:09 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 10/11] arm64: defconfig: add new Allwinner crypto options
Date:   Thu, 10 Oct 2019 20:23:27 +0200
Message-Id: <20191010182328.15826-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
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

