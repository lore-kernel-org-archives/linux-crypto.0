Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50262C352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A632133F
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pPsF/jPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfJASmF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38381 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfJASmF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:42:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so4354800wmi.3;
        Tue, 01 Oct 2019 11:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKpve1sS9k6PS7sXtW4xCBzfM/Fs/2OVeKaJ2VowDbI=;
        b=pPsF/jPDCHH4kgy+t57Wh+/nv1CmF+wwXU4PdRpDz/olg7q7n7RwsnQr8Ngfy+/4bZ
         gSRRXg1rC2fMZcHzThpdflc2e1K+pnNCMI7Nm/XoAxKoy5/PTafhzXYbQwmvbFa/y1mG
         p9EVTtVqVv3TWRZx6ZV336nL03wbyGh66rKPVkLKcdemXjLTNd4sRruXzilbhViSv2sj
         xScEKU380G/U4joZdO/Ikwrfvo2Rp+40RUtHle9tsOczHfrxP6gKKJL6d1dQuDYo0nbt
         t0sgiFJaU1xmtZ4jDYv51SpYas7g/bKBhAdtW2fGz5TL+wjXyD3IoAkjX3NBhs8oVWs5
         yY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKpve1sS9k6PS7sXtW4xCBzfM/Fs/2OVeKaJ2VowDbI=;
        b=SH1Yz5SjIlINpFbv3p4d4msH4uP7pb/0/30iybwqJaxG7ovnlq2jAuOoVfakBBiiCG
         y3MWTX27I/P7/ePpuvJ2ahANAZiOmrm4Z8PUYpN+/n4oj0SpoNirPR3zpcnWMWbmIazD
         hO/gLptDlb//19cZi6ivFQA3apQFTtTYYg9w+mIBBCSRtzmH36njO6Ew7/IuwcH7pcDL
         lUTylvI6jUlTfFFA3eCcJS6IgFkbJSwpgEvsAgbuHhLjaklyA8iMTpRaqUia1rVwOWxW
         54AI/H57YW7uyQNGbUcbwPxlGq0hseq2skdn/4drhJv0vHDlkkJGRu1ZFCNtzXlZYRVF
         EfEQ==
X-Gm-Message-State: APjAAAUY5O/vsm4tLPZPCgwTrc3nGrYI2BibOBoMQ1j4haxXrdCVrQOg
        It8y6MQ01Po+j8C4DN9ghKkkpEyq
X-Google-Smtp-Source: APXvYqxgXBaEZ4Oi9XqOXjZ6/1GiZLdJqUtyNHPoYb8WtG5vfuZymtGDldMwckx91XnnvDPXSPRkWg==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr4573787wmq.60.1569955323021;
        Tue, 01 Oct 2019 11:42:03 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.42.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:42:02 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 10/11] arm64: defconfig: add new Allwinner crypto options
Date:   Tue,  1 Oct 2019 20:41:40 +0200
Message-Id: <20191001184141.27956-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
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
index 8e05c39eab08..f2f330b8416d 100644
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

