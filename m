Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817E0C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 11:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594F360F24
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 11:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhIKLJU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Sep 2021 07:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLJT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Sep 2021 07:09:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C466C061574;
        Sat, 11 Sep 2021 04:08:07 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so4341424pgl.10;
        Sat, 11 Sep 2021 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P4es3kUrpxlo/ai9htg725cFtyTD4npguzIjRNqpnOo=;
        b=o+uEAr2oRiDOkAyc1jJ2bzoRuCcI2PDjMAKgqcWA96V3LJeMbCsTaKxdb8prnGIsid
         HbrtfwQnXHKOwIm+ys544iny6W+FnQX4URYzdl+3mG07y4ekaJYDVrgo4dkyKkIeJNJT
         Aa5Irzpdfmf+MNB51mgC7p4tFTASgZc5yPuUlFXlRWRx6AwrEEOD5/EAZtn5PIiBpE//
         7vcunVeWLPthLvWWh+yuEIDs2IIdLV4u9d/aVbCuRoq8e2FTFLR61nb5ULOlOAVIa6gf
         WxGywjWfJ8+HNjmecaO3Ee36ermJP0fYCAhGPfiEI8gX9ifAJWU7Bp7yIeCvfV5/E8Om
         EsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P4es3kUrpxlo/ai9htg725cFtyTD4npguzIjRNqpnOo=;
        b=JaaY4XHpgoQkOPt2AsmpXtFMqrvNZhhc3/30Kvfl5HoamaJFC00ldbsb8pj4ifJE9T
         GW1+ZkFIN3c+0RWCDpzRgzYbBjsNRmIEheuGMLZfaMuBICT5TogkBaBkumurnJBBUDsd
         XewizmhN2fC2PeAa46kGkCmtq4m81GaFk9U75eHLWS/xN7UTAjfi3X6hiDVIztOW18YR
         ohiTLhv5ZUy1qsHdcZjp4vNHfJGEJkJv624/fvTyxHrPlMOvj02fZnvJTAuqDJvR9q3x
         65XwYRxykMlzq8msxDFNnFtQvAtamoAjETD17QuGCrR/GlEN556R4n/kf5K13WMnyrB8
         otzQ==
X-Gm-Message-State: AOAM532PTtDeH0ESiOYq7pr4JwkYnwSXtW8EMjygPSYU1FYfbWETZ/kB
        7fkLomaZWbqY2h0C23/bn1I=
X-Google-Smtp-Source: ABdhPJwhBd31PovJLTa8a4R4C95M3f3fFQwbD7fw46AVnlLzsshCZuRCf1GJmDC3LKQsm0yrCaC/hw==
X-Received: by 2002:a63:5f08:: with SMTP id t8mr2043564pgb.353.1631358486984;
        Sat, 11 Sep 2021 04:08:06 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6f15:d26f:133e:cd11:90dd])
        by smtp.googlemail.com with ESMTPSA id d4sm1558839pjo.12.2021.09.11.04.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:08:06 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] crypto: x86/aes-ni - check walk.nbytes instead of err
Date:   Sat, 11 Sep 2021 16:37:59 +0530
Message-Id: <20210911110759.40911-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the code for xts_crypt(), we check for the err value returned by
skcipher_walk_virt() and return from the function if it is non zero.
However, skcipher_walk_virt() can set walk.nbytes to 0, which would cause
us to call kernel_fpu_begin(), and then skip the kernel_fpu_end() call.

This patch checks for the walk.nbytes value instead, and returns if
walk.nbytes is 0. This prevents us from calling kernel_fpu_begin() in
the first place and also covers the case of having a non zero err value
returned from skcipher_walk_virt().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0fc961bef299..e09f4672dd38 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -866,7 +866,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		req = &subreq;
 
 		err = skcipher_walk_virt(&walk, req, false);
-		if (err)
+		if (!walk.nbytes)
 			return err;
 	} else {
 		tail = 0;
-- 
2.31.1

