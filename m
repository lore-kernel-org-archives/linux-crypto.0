Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB69C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F83764E88
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBHJNH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:13:07 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43132 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231398AbhBHJL2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:11:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UOAH5lm_1612775440;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UOAH5lm_1612775440)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 17:10:40 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] crypto: sha: remove unneeded semicolon
Date:   Mon,  8 Feb 2021 17:10:38 +0800
Message-Id: <1612775438-126031-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eliminate the following coccicheck warning:
./arch/powerpc/crypto/sha1-spe-glue.c:110:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/powerpc/crypto/sha1-spe-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/sha1-spe-glue.c b/arch/powerpc/crypto/sha1-spe-glue.c
index b1e577c..88e8ea7 100644
--- a/arch/powerpc/crypto/sha1-spe-glue.c
+++ b/arch/powerpc/crypto/sha1-spe-glue.c
@@ -107,7 +107,7 @@ static int ppc_spe_sha1_update(struct shash_desc *desc, const u8 *data,
 
 		src += bytes;
 		len -= bytes;
-	};
+	}
 
 	memcpy((char *)sctx->buffer, src, len);
 	return 0;
-- 
1.8.3.1

