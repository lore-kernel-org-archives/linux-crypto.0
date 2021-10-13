Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C19C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED3960F94
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhJMN76 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 09:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbhJMN7x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 09:59:53 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A6EC061769
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 06:57:49 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y26so12229116lfa.11
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFsM9Ei6gS0+k7pOO8LFkCGjMbL5J05nWd842ORwlvo=;
        b=bakgxwHfosywcDZp3vMHev/J4RM6bPLRo/dfXh/5UK2leDCo15AUTppvS+39yC7i2N
         AiNw8D+GTPVeu57Vq9P3qRgiKvzqS9bFOZ2XaYRV8YOnvpiiKV8Io+D8CNGF6WVqOsiv
         4QDlg156HdyP7ze2ZlmuEs8/yM1BIa2cpkREtlw2dPkrxxTSfId2PEAxbNo5grOAtc2t
         zez0j6XDWKzYKJ62kpx06yhQ8FYrSCWxhVYKxTUyiJ4RLpgjtnFFBfp6TfsOKbQ3UIV2
         1L7u5XIHOqf+QVhiJhMTJcDSmuF7dgDY2HfEtvpdZPKSVxLUKIc69qFjhJDjsHBN8FTW
         olUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFsM9Ei6gS0+k7pOO8LFkCGjMbL5J05nWd842ORwlvo=;
        b=5D8tjBD7sx/1y5SoqdiAiTh+S/0sh8Gw6Ht6TXeVnkNyEfW6CVTx3xXLHZryg5q5lD
         6If9/knFrBatYVxvqqpSXtkQOF3QModCkvaHCUMUQnQUKpZ/EJF6mdZbp8bcvj1I45e0
         tpe8486QdYFld5icUNrBQhHqkv+duZwOJBLbPRAXYsCMl6UNbrRSGGiYq+U3jcGMQX5r
         nih5X7AiZE4BL0CJhOb/3cjoHmdBlIFCNnvrBRDiSl6Xc7BMi6lYn/pOEDk6nliDWghe
         V2KqL9AagKPjRBMt7Aizx42HYfMGhCnUQ4pAcKt6P5c9yJzk7fbEA78DrjOkbC5yjBO8
         pRHQ==
X-Gm-Message-State: AOAM533yoaKjUpFyUgsYjjNmlHsaxAsHkeYisn4Z4/xQOIePrfDQVP04
        p9F4sB4pzkHZwwtthF7xEjXKnA==
X-Google-Smtp-Source: ABdhPJwZhc4AfAcz46mBH0bDMlI3rEw082MyBrgaexGv8eU7y2Cw/wy3lYVccAe+lZM0MMzv73xu4g==
X-Received: by 2002:ac2:4f02:: with SMTP id k2mr39851314lfr.265.1634133467547;
        Wed, 13 Oct 2021 06:57:47 -0700 (PDT)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id z20sm1336791lfh.306.2021.10.13.06.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:57:47 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] include: marvell: octeontx2: build error: unknown type name 'u64'
Date:   Wed, 13 Oct 2021 15:57:43 +0200
Message-Id: <20211013135743.3826594-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building an allmodconfig kernel arm64 kernel, the following build error
shows up:

In file included from drivers/crypto/marvell/octeontx2/cn10k_cpt.c:4:
include/linux/soc/marvell/octeontx2/asm.h:38:15: error: unknown type name 'u64'
   38 | static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
      |               ^~~

Include linux/types.h in asm.h so the compiler knows what the type
'u64' are.

Fixes: af3826db74d1 ("octeontx2-pf: Use hardware register for CQE count")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 include/linux/soc/marvell/octeontx2/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index 0f79fd7f81a1..d683251a0b40 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -5,6 +5,7 @@
 #ifndef __SOC_OTX2_ASM_H
 #define __SOC_OTX2_ASM_H
 
+#include <linux/types.h>
 #if defined(CONFIG_ARM64)
 /*
  * otx2_lmt_flush is used for LMT store operation.
-- 
2.33.0

