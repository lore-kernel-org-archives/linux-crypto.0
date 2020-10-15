Return-Path: <SRS0=zNo2=DW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5380CC43457
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 11:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB242206CA
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 11:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgJOLCo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Oct 2020 07:02:44 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50452 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgJOLCo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Oct 2020 07:02:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UC69Kcq_1602759761;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UC69Kcq_1602759761)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Oct 2020 19:02:42 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: ecrdsa - use subsys_initcall instead of module_init
Date:   Thu, 15 Oct 2020 19:02:41 +0800
Message-Id: <20201015110241.89676-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All templates and generic algorithms have been registered in
subsys_initcall instead of module_init. The ecrdsa algorithm
happened to be missed. Here is a fix for it.

Cc: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/ecrdsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 6a3fd09057d0..ca9a34356f80 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -288,7 +288,7 @@ static void __exit ecrdsa_mod_fini(void)
 	crypto_unregister_akcipher(&ecrdsa_alg);
 }
 
-module_init(ecrdsa_mod_init);
+subsys_initcall(ecrdsa_mod_init);
 module_exit(ecrdsa_mod_fini);
 
 MODULE_LICENSE("GPL");
-- 
2.19.1.3.ge56e4f7

