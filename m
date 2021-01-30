Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05399C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Jan 2021 22:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C9864E18
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Jan 2021 22:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhA3W4j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Jan 2021 17:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhA3W4i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Jan 2021 17:56:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A16C06174A;
        Sat, 30 Jan 2021 14:55:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z9so179077pjl.5;
        Sat, 30 Jan 2021 14:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stXEhWN78gX0wZAuci159YKXelu5PMT12Nbz0FBmmqg=;
        b=sCbA5uJ3YPl1RDbG9qmR3CeRIV1aD5Gs71QcMHfswJExgQGWKuL6zxznHD+TyDactT
         9HJihYTpwtRcb0YCLKAPWo+zuY2b/w8m8amXRBMA+zxKYquzij7Eab7aQHGUDJaGXEgf
         9ocWtTFEZJ8IUgOpk5ZCnaGhrma2wFxp4x0drAWy+Rmi2umWZuSl7++A+M4o3HLXmsu1
         gBFKolze/cZbXJ7GMIC+6dtFiQVU4Vs4s5bYyfkbwiQhQelwT7QrsRlhGJ5MXLmLWyUz
         hmXGFeE1fjQWEPeJo/r/WTk2PUYGDH9pY2IdXXQ0zXmlvOLQrLuKdw0BZs54uaTnY95B
         ndCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stXEhWN78gX0wZAuci159YKXelu5PMT12Nbz0FBmmqg=;
        b=WzfnElwmtA1Gy2Ie15eBPsqOU06qMh+z5OiXaTLQcPLrOWku8zhdnIrnGqiOa4p91h
         +57AEk0uIeSYsl+IKael0ernaCBIP5Dt8yRJ7j0w46J2vgF3dGT1z+20j5GbtidC9Fbz
         ZcvRmwetnrMgcunEW48MA+//DD8Fm/iUvT2j6uORvUU3HVbmKlWT2VqTZHWA/DlOswjl
         dgmFA5O8Ganym514eDtBNDRK7TCj0+ID46WD/lD/Q1jl141R+LqcvP9e/WgffHAl6r+r
         3tOcsuI4YjAMPnQ70olF3AfUlW+nl2VzXh0CuyfOk6Q2bTt8kDCiq1vdrz3m7b0FPDat
         Ps1Q==
X-Gm-Message-State: AOAM530GxaiZ6SRTFFIxmwbkYToXXRxL/0eXn3vEiIEx2oPZzagS++5y
        nR2qCagOkxIMxCFTjr2fJGjFAKGphMc=
X-Google-Smtp-Source: ABdhPJzNlHrRcMfVuScNiyw939Ox1QwPsAE+geydGYM/euYpMITxt0FE6sprk/qDdFlmdo1Z0e1J9g==
X-Received: by 2002:a17:90a:bd0f:: with SMTP id y15mr10651561pjr.141.1612047357880;
        Sat, 30 Jan 2021 14:55:57 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 14sm12989104pfy.55.2021.01.30.14.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 14:55:57 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org, arndb@kernel.org
Cc:     kbuild-all@lists.01.org, Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API)
Subject: [PATCH 2/2] crypto: crypto4xx - Avoid linking failure with HW_RANDOM=m
Date:   Sat, 30 Jan 2021 14:55:38 -0800
Message-Id: <20210130225540.1639-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210130225540.1639-1-f.fainelli@gmail.com>
References: <20210130225540.1639-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is currently possible to build CONFIG_HW_RANDOM_PPC4XX=y with
CONFIG_HW_RANDOM=m which would lead to the inability of linking with
devm_hwrng_{register,unregister}. We cannot have the framework modular
and the consumer of that framework built-in, so make that dependency
explicit.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e535f28a8028..c833ac08ea81 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -348,7 +348,7 @@ config CRYPTO_DEV_PPC4XX
 
 config HW_RANDOM_PPC4XX
 	bool "PowerPC 4xx generic true random number generator support"
-	depends on CRYPTO_DEV_PPC4XX && HW_RANDOM
+	depends on CRYPTO_DEV_PPC4XX && HW_RANDOM=y
 	default y
 	help
 	 This option provides the kernel-side support for the TRNG hardware
-- 
2.25.1

