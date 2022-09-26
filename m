Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796B7C07E9D
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Sep 2022 09:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiIZJgm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 05:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiIZJgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 05:36:37 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ABB25C76;
        Mon, 26 Sep 2022 02:36:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VQkQP6._1664184986;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VQkQP6._1664184986)
          by smtp.aliyun-inc.com;
          Mon, 26 Sep 2022 17:36:27 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 01/16] crypto: arm64/sm3 - raise the priority of the CE implementation
Date:   Mon, 26 Sep 2022 17:36:05 +0800
Message-Id: <20220926093620.99898-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220926093620.99898-1-tianjia.zhang@linux.alibaba.com>
References: <20220926093620.99898-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Raise the priority of the sm3-ce algorithm from 200 to 400, this is
to make room for the implementation of sm3-neon.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/arm64/crypto/sm3-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
index ee98954ae8ca..54bf6ebcfffb 100644
--- a/arch/arm64/crypto/sm3-ce-glue.c
+++ b/arch/arm64/crypto/sm3-ce-glue.c
@@ -84,7 +84,7 @@ static struct shash_alg sm3_alg = {
 	.base.cra_driver_name	= "sm3-ce",
 	.base.cra_blocksize	= SM3_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_priority	= 200,
+	.base.cra_priority	= 400,
 };
 
 static int __init sm3_ce_mod_init(void)
-- 
2.24.3 (Apple Git-128)

