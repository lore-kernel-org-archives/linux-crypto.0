Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA329C2BA12
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A92E2077D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="zNYI2Bz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgDCTuy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgDCTuy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id c195so2893048wme.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6dyRuU0qv/GfpSwaUpO6HqsZ5FNV24sN7mKJHA69ZbQ=;
        b=zNYI2Bz2ZZvxRiGQWc2aqfXuQwlHzVy/1JcTsIrA5fNpzW1UBC2MNvUaEIJH/MeS0R
         b4NbRNp5RSpQVi6DIwGBkW0nzYlv+8ulLfhvFYhiqcTS7l0WRwpDS1T5InYY4hUUWdU4
         GIH/RmJUL5QP1ejC0BPdEr2eLrm+oOVUgIf8xIr8M0nDHbcof2qdD0U/Hh+9Jp0PMYel
         iG1Yds8CmordrP3frOlREDxf09MxB53pUr7RCAlkL3arlQlX9bXAClR6IjBJzTGoAMgL
         bKah+oTIGcEAFbim7HTaEiZKAd6EoieAGKqL76O/mYidEdUL/Matv98UArNfDudYrZ6C
         E8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6dyRuU0qv/GfpSwaUpO6HqsZ5FNV24sN7mKJHA69ZbQ=;
        b=pVHiOZ9xWFWtgRYIuurwFWrLZJhQP4IXm1FcvThD47I1/k8xgDUL5zYhv58x4iL375
         lRQWjQDbmIIPkpakwhXhMMLN5la42tR9TTBAYB942Zpj5QV9L5jULdMedkXb+xq6VCWs
         89mpAUFW2+L2wymgkn+6WOHdqjLaPZbdeBBa8Sd1efgcEhg1LePJTGpCU74PBhsxMRfw
         FB1MtsUP2D1uu0w7s8y1cf+iPPgYU2b9DPBPMUFfdekfQlL2i0F1fEdoE4H5+xrONEhx
         jJgqXU7OqlVRFxnt9ArXiKhzyVJVLff2cvDGtG/hSWHAuGMT1x8YrKjwCpFiO0J6/liZ
         7YsQ==
X-Gm-Message-State: AGi0PuaYavXyMixStqTlIhJLlHScm/SdRENTLV7e3r98nvbUwLnQ2kHB
        Q4E7KmEJNkMXEhumXQ3Wh+NTFw==
X-Google-Smtp-Source: APiQypK1L403HNRMCm4e7EzTNVx3G7MJ++mQkJ655tG116RXQ/l009JoC493CMtHX26eyzZI0Iznlg==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr10639456wmm.137.1585943452353;
        Fri, 03 Apr 2020 12:50:52 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:51 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 5/7] crypto: sun8i-ss: fix a trivial typo
Date:   Fri,  3 Apr 2020 19:50:36 +0000
Message-Id: <1585943438-862-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
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
index 350a611b0b9e..056fcdd14201 100644
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
2.24.1

