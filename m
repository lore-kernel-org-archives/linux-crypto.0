Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45261C33C8C
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16904208C4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSROXP2l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAFT27 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 14:28:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45546 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFT27 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 14:28:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so50980829wrj.12;
        Mon, 06 Jan 2020 11:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AziF7hcwzVCmI73+l3mqMfAODTCcsFcTOISK9zRuWzY=;
        b=aSROXP2lkWI/C9fl2SqMVw9evFILtdhYEVPVZUzRc3ncDWQXNwcf4RlxNP5aqA9fd3
         xb3ddQp9t1lR6p+valkq/xouFxdI+MZztRSefI6+FMOh0ZeZQrlxx1urYoeUyXpzn1jT
         7bJHUbL/52gBhhkMkrWX9dJ7A9dL5MgqBWsB9XMTyMGOl1ysknh6+RaozibxmdGPX6R5
         Zt58WVRSu7bmBTRCNuSOv4VQzTM9n4hrtDV8RI0AUbj41xEpl+62p7/gRfaQibbcs1MZ
         o8i1mvD3l0uLPmzo1S4LTCDIomQ+3UwzqBiLU+dYDstFWDxy+plcidxMslqFP2Khb9YT
         fsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AziF7hcwzVCmI73+l3mqMfAODTCcsFcTOISK9zRuWzY=;
        b=rg2XZQdq2y68V+ove0TCxhhbwq/FjaFa3qpSEZGeQ3ibpJ9H4N0LCKAlJxdlpb6eUp
         MTeIXAwQu31wiROF2M95H3JLXCLZOwYMK42jEr6PjryH8MZfPi7UlOv9DD3WYj67yeaX
         gCokA9/icUL4a58aHIc5cKF6BT+KG+xB8UwUVQIsVCPnmMqp0Fme6zcPxkzafsDa2x+B
         HM79kY3QHKWVBH+vi+EPpQomqWt0zRAe5YhdeE5QRzgOKcbtBV9JlbuNZ/uDUucb3Bhi
         YAvIxlI0RrO2qBs0kRNvGIaxP/tnCJ/KeOMsqtUzO1q+Jo2TJdt9kGKk25rrhbJW6fNS
         H2xQ==
X-Gm-Message-State: APjAAAXDoNuQzVhk8Osu/SIFMdNXE6bkTKMxPu5lxFSvGOuW8wO58MEr
        D4XxP+7j9D5roJKVA2ZUq1Q=
X-Google-Smtp-Source: APXvYqywVjaNHfMTcQIiAZDYGOrIjcrpw2RwsIL4gX3S+GCkaLSIREZ99J0IRjkI0JEyP/pvDTouaw==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr98653964wrx.253.1578338937062;
        Mon, 06 Jan 2020 11:28:57 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a133sm23883482wme.29.2020.01.06.11.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 11:28:56 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun8i-ss: fix removal of module
Date:   Mon,  6 Jan 2020 20:28:52 +0100
Message-Id: <20200106192852.9218-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.
Fixes: f08fcced6d00 ("crypto: allwinner - Add sun8i-ss cryptographic offloader")

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 90997cc509b8..6b301afffd11 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -595,7 +595,7 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 error_irq:
 	sun8i_ss_pm_exit(ss);
 error_pm:
-	sun8i_ss_free_flows(ss, MAXFLOW);
+	sun8i_ss_free_flows(ss, MAXFLOW - 1);
 	return err;
 }
 
@@ -609,7 +609,7 @@ static int sun8i_ss_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(ss->dbgfs_dir);
 #endif
 
-	sun8i_ss_free_flows(ss, MAXFLOW);
+	sun8i_ss_free_flows(ss, MAXFLOW - 1);
 
 	sun8i_ss_pm_exit(ss);
 
-- 
2.24.1

