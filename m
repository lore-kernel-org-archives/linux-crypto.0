Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D246C63797
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Jan 2023 08:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjAQIBT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Jan 2023 03:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbjAQIBQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2023 03:01:16 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60F61BADF;
        Tue, 17 Jan 2023 00:01:12 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4Nx1YL0N2Bz4xpyC;
        Tue, 17 Jan 2023 16:01:10 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
        by mse-fl1.zte.com.cn with SMTP id 30H815we005478;
        Tue, 17 Jan 2023 16:01:05 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Tue, 17 Jan 2023 16:01:08 +0800 (CST)
Date:   Tue, 17 Jan 2023 16:01:08 +0800 (CST)
X-Zmail-TransId: 2af963c655c4ffffffff87b29564
X-Mailer: Zmail v1.0
Message-ID: <202301171601080312252@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <herbert@gondor.apana.org.au>
Cc:     <davem@davemloft.net>, <mpe@ellerman.id.au>, <npiggin@gmail.com>,
        <christophe.leroy@csgroup.eu>, <linux-crypto@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIGNyeXB0bzogcDEwLWFlcy1nY20gLSByZW1vdmUgZHVwbGljYXRlIGluY2x1ZGVkIGhlYWRlciBmaWxlcw==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30H815we005478
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63C655C6.000/4Nx1YL0N2Bz4xpyC
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

crypto/algapi.h is included more than once.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 arch/powerpc/crypto/p10-aes-gcm-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/crypto/p10-aes-gcm-glue.c b/arch/powerpc/crypto/p10-aes-gcm-glue.c
index 777e6b5254da..a17d3e8d8f3c 100644
--- a/arch/powerpc/crypto/p10-aes-gcm-glue.c
+++ b/arch/powerpc/crypto/p10-aes-gcm-glue.c
@@ -8,7 +8,6 @@
 #include <asm/unaligned.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/b128ops.h>
-- 
2.25.1
