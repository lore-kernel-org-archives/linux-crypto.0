Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CA5C10F14
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 06:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90C94222BE
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 06:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJCGdB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 02:33:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:15228 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfJCGdB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 02:33:01 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x936WaDE024847;
        Wed, 2 Oct 2019 23:32:37 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        smueller@chronox.de
Cc:     atul.gupta@chelsio.com, ayush.sawal@chelsio.com
Subject: [Crypto chcr] crypto: af_alg - cast ki_complete call's ternary operator variables to long.
Date:   Wed,  2 Oct 2019 23:32:31 -0700
Message-Id: <20191003063231.8352-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ki_complete called from af_alg_async_cb use ternary operator to get
the value of second argument.As err is signed int while resultlen is
unsigned int, by the precedence rule err is also processed as unsigned
int and lose its original value.Hence, it is advised to cast both err
and resultlen as long which is expected by the definition of ki_complete
call as its 2nd argument. This will retain the original signed value of
err.

 Declaration of ki_complete in file linux/include/linux/fs.h  in struct
kiocb {...
	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
	...
 }

    Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index edca099..8e48d97 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1048,7 +1048,7 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 	af_alg_free_resources(areq);
 	sock_put(sk);
 
-	iocb->ki_complete(iocb, err ? err : resultlen, 0);
+	iocb->ki_complete(iocb, err ? (long)err : (long)resultlen, 0);
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
-- 
1.8.3.1

