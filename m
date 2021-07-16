Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15228C12002
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 16:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CBE613F2
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 16:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhGPQ5S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 12:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhGPQ5S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 12:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E375F613E8;
        Fri, 16 Jul 2021 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626454463;
        bh=kmbZq07zaBwPa71lnfLpbNt1AN+xqqvsizWn06LAvD8=;
        h=From:To:Cc:Subject:Date:From;
        b=Bp3/KC6298T+EQcaJzKw38IpT5aiisoVAeZ5hN0m0/ZoHmZ0oMZ+vxQHRItHGcsmO
         DoIb/zhuMprYNS1y3mYN7xhd/D0n2f1BOazdfsVWkIOH3T04VFpfJeIZR4YMnVyK2l
         mCMK6Vvto0oo9Bq3l+Is9Y/E+QqNFOPEEacFuOx3XgE28S7Pd1La4VxbHU063jBTns
         +/LZEZDVychiF77gGMbQYIg9p6yHZuwwozuRYL4Ti1goVMM7ChH30Ni6F+bfbtVupu
         ijfgPcGQ2uC2CuUXXC3gMF2et09XBCVwX0KvTfRTrijUKjgTsKbIZh0BkdCzioJe9a
         tYyJJ+30mwzQw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Subject: [PATCH] crypto: x86/aes-ni - add missing error checks in XTS code
Date:   Fri, 16 Jul 2021 18:54:03 +0200
Message-Id: <20210716165403.6115-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The updated XTS code fails to check the return code of skcipher_walk_virt,
which may lead to skcipher_walk_abort() or skcipher_walk_done() being called
while the walk argument is in an inconsistent state.

So check the return value after each such call, and bail on errors.

Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")
Reported-by: Dave Hansen <dave.hansen@intel.com>
Reported-by: syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2144e54a6c89..388643ca2177 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,6 +849,8 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
 		int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
@@ -862,7 +864,10 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		skcipher_request_set_crypt(&subreq, req->src, req->dst,
 					   blocks * AES_BLOCK_SIZE, req->iv);
 		req = &subreq;
+
 		err = skcipher_walk_virt(&walk, req, false);
+		if (err)
+			return err;
 	} else {
 		tail = 0;
 	}
-- 
2.30.2

