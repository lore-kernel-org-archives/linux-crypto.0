Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB5C5B57D
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 07:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF0A21479
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 07:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfGBH7G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 03:59:06 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:38275 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfGBH7F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 03:59:05 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 03:59:04 EDT
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 83CAB182EC;
        Tue,  2 Jul 2019 09:53:35 +0200 (CEST)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id LkaPNXZJqsvy; Tue,  2 Jul 2019 09:53:34 +0200 (CEST)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id 261EC18095;
        Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C66BB1E07D;
        Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA6001E078;
        Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
Received: from thoth.se.axis.com (unknown [10.0.2.173])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
Received: from lnxartpec.se.axis.com (lnxartpec.se.axis.com [10.88.4.9])
        by thoth.se.axis.com (Postfix) with ESMTP id AE67027BE;
        Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
Received: by lnxartpec.se.axis.com (Postfix, from userid 10564)
        id 96D0A801D8; Tue,  2 Jul 2019 09:53:33 +0200 (CEST)
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Whitchurch <rabinv@axis.com>
Subject: [PATCH] crypto: cryptd - Fix skcipher instance memory leak
Date:   Tue,  2 Jul 2019 09:53:25 +0200
Message-Id: <20190702075325.27940-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

cryptd_skcipher_free() fails to free the struct skcipher_instance
allocated in cryptd_create_skcipher(), leading to a memory leak.  This
is detected by kmemleak on bootup on ARM64 platforms:

 unreferenced object 0xffff80003377b180 (size 1024):
   comm "cryptomgr_probe", pid 822, jiffies 4294894830 (age 52.760s)
   backtrace:
     kmem_cache_alloc_trace+0x270/0x2d0
     cryptd_create+0x990/0x124c
     cryptomgr_probe+0x5c/0x1e8
     kthread+0x258/0x318
     ret_from_fork+0x10/0x1c

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 crypto/cryptd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1ce1bf6d3bab..5f76c6e222c6 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -388,6 +388,7 @@ static void cryptd_skcipher_free(struct skcipher_instance *inst)
 	struct skcipherd_instance_ctx *ctx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ctx->spawn);
+	kfree(inst);
 }
 
 static int cryptd_create_skcipher(struct crypto_template *tmpl,
-- 
2.20.0

