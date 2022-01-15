Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A80CC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jan 2022 10:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiAOKHX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Jan 2022 05:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiAOKHW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Jan 2022 05:07:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E862C06161C
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jan 2022 02:07:22 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k5so1505545wmj.3
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jan 2022 02:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHzaO4ONACqKvhGwj0tPEmx27kwwu6unLDfjaw5odQk=;
        b=QzXz5M+8FThc6YS7BTcBpaSjY2VQwMtyP2aWOFTgY6F3CG/wzIUPGc8S1rddf8lIwy
         0NJaylsB4zEmFToWvVObjj9xVDt78e+wRf5RyYnTktWNqNZ7wpOjFkZJM6PhcDg8hj37
         ZqbRy93uvxc1qxQ2m6dgFTzJFQ8z5tjm8ggH1Dw3eGtX+TiCptySjZ7dao8iEDCiKeZo
         e5ITXODfM/mhjWWfIzzl7bVfpF42p0C82rXjLblhMHEHOhdObgZxRjpxhwxRzLrYVjSp
         T6wCP6BwTvs26YzRPCk4M+b+MMnRJFUEpmNtM2HLfj/kI6QaSpImzW0dn/UPdgp2Dox7
         Xz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHzaO4ONACqKvhGwj0tPEmx27kwwu6unLDfjaw5odQk=;
        b=Mz7i1jC+PFdJeATUUXaXfPOxzurGIf4hQQPBNB1WAigHjHiFPOqqUVD9OVBiueroUK
         s7kDLXkO+Qnq/b0QPILCPfeuKX5esLAYAOakjcnFjel2wGRQURNZVSXeagsyKUfqQeYk
         4ZxQpZRsMkKGFXC116y5EcNs7r4ilwJJQAtHiZN0kyH3KjWZRIvgT4bVI7JLC3bSjXYe
         3JZyUgmzFbrYt2eX+1UnF/6/354gEx0N+BbQlFqsnPK80brLGgauWB3WUr1uirU67NZ0
         jdJFdUz1YnnHSVFZVUAWsyYNC7iY7TmcaHBYI5EbHbSw026gZb2u8Yq/fcRava3SgWpN
         ZPzA==
X-Gm-Message-State: AOAM533PfBDI5eTKGvsfTMI+LmpZVcqzPH8NgrtwvixMxETkki/9pLzX
        v1g0IFh25KhYwJdtDUKFDuYyrQ==
X-Google-Smtp-Source: ABdhPJwT9PpLZzfgM3b2ggNB5zCbHPDcVO71Y4bAF4rcgpahWKkHJ1bm1VqNAJA0DccSNUH3AVHGEQ==
X-Received: by 2002:a1c:7c13:: with SMTP id x19mr11934460wmc.78.1642241240658;
        Sat, 15 Jan 2022 02:07:20 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id w17sm9009436wmc.14.2022.01.15.02.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 02:07:20 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@gmail.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: sun8i-ss: really disable hash on A80
Date:   Sat, 15 Jan 2022 10:07:14 +0000
Message-Id: <20220115100714.3016838-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When adding hashes support to sun8i-ss, I have added them only on A83T.
But I forgot that 0 is a valid algorithm ID, so hashes are enabled on A80 but
with an incorrect ID.
Anyway, even with correct IDs, hashes do not work on A80 and I cannot
find why.
So let's disable all of them on A80.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 80e89066dbd1..319fe3279a71 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -30,6 +30,8 @@
 static const struct ss_variant ss_a80_variant = {
 	.alg_cipher = { SS_ALG_AES, SS_ALG_DES, SS_ALG_3DES,
 	},
+	.alg_hash = { SS_ID_NOTSUPP, SS_ID_NOTSUPP, SS_ID_NOTSUPP, SS_ID_NOTSUPP,
+	},
 	.op_mode = { SS_OP_ECB, SS_OP_CBC,
 	},
 	.ss_clks = {
-- 
2.34.1

