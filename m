Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3395C433EC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0479206E3
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="uOQX4Rem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgGUTGy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgGUTGs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ED6C0619E0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:47 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z2so22269458wrp.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FT+2gDwi+eo+TtESsfWRD1fT3NbLCZL+Gr5RVIpvd9A=;
        b=uOQX4RemIlR0j2HEHYAaSyo3IqUDYdlmOlxPQ8DlFtEKtOE53r7MP7XCcOEHMkMcHH
         Ulh3ZeeY73gxeE74lSsmmWLXvrX0EeRl6W8bVRrphQEBYd9ce0TLQdQYffZ11LXNWCyi
         VFMmDZlpQCtHTwnuCaH+oCq19pVS/bfFtW7MUVbnGLSqo0l/OFyN+0FoFP2gH9nbiN19
         qGdb6mgA27UMGMGglxrim2z6f9en91J858w8rai7XZzzRTxZfHOTIJa2RPi0eB8Vt9d2
         cCOeWcwe2ITKSyw/jnn8xkY/97eZXUktTy3hl0AqijRVwmbkgYecCtABCp6bO31rT5hF
         LxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FT+2gDwi+eo+TtESsfWRD1fT3NbLCZL+Gr5RVIpvd9A=;
        b=i0XO4C0bD9MBstXq2NT64uy2xOxnQWgFQf4MBb9ceQ5n2GBSZQqwnyB/ahzcNDGdX7
         WkV8YhvVpKv8y86okIpfIO36QvOjKkDNLl9V7BzjmEutGD6gf/Km1+QblksFsG0ZH4Dg
         DS6ni4AjHiUYK8fqlylq6xbzYMBz+3T9ZiY5PI+ZYN0ELnYAWtDMqzCXgk+JnrzznjuI
         LHn5ZmIBIHg3oFE1s+vP4UzXk+fFw3dslllbMtdEa4/bgmHI8BAkCTGCSvvWQBu1/YgO
         FvCv670h3JQKHVqd79wRYOTUlWM9Q/i8WDDJKg6EUZt/xgWuiwQ/LNyxTOcTbsMlpsVO
         Yq6w==
X-Gm-Message-State: AOAM532uTKERE44v/YwFITXC2MZre5M7XuBZhFVHNneqJGA7T9oxK8rQ
        setVBLFwLvx5WvKkIojrTClXVA==
X-Google-Smtp-Source: ABdhPJz58pWhTIJIjUQBlthHYEQooH2Rg4duKviDGhSiJw15kYwqUhlPOF/VCsElr8LdruZUhIeb/w==
X-Received: by 2002:adf:e704:: with SMTP id c4mr345406wrm.81.1595358405986;
        Tue, 21 Jul 2020 12:06:45 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:45 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 04/17] crypto: sun8i-ss: fix a trivial typo
Date:   Tue, 21 Jul 2020 19:06:18 +0000
Message-Id: <1595358391-34525-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes a trivial typo.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 377ea7acb54d..da71d8059019 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -100,7 +100,7 @@ struct ss_clock {
  * @alg_hash:	list of supported hashes. for each SS_ID_ this will give the
  *              corresponding SS_ALG_XXX value
  * @op_mode:	list of supported block modes
- * @ss_clks!	list of clock needed by this variant
+ * @ss_clks:	list of clock needed by this variant
  */
 struct ss_variant {
 	char alg_cipher[SS_ID_CIPHER_MAX];
-- 
2.26.2

