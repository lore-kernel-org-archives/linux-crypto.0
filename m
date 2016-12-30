From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: testmgr - use kmemdup instead of kmalloc+memcpy
Date: Fri, 30 Dec 2016 14:12:00 -0600
Message-ID: <20161230201200.31467-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34248 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbcL3UN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 15:13:26 -0500
Received: by mail-it0-f65.google.com with SMTP id 75so42381570ite.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2016 12:13:26 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

It's recommended to use kmemdup instead of kmalloc followed by memcpy.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 44e888b0b041..881176ebd8a8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1463,13 +1463,12 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		int ilen = ctemplate[i].inlen;
 		void *input_vec;
 
-		input_vec = kmalloc(ilen, GFP_KERNEL);
+		input_vec = kmemdup(ctemplate[i].input, ilen, GFP_KERNEL);
 		if (!input_vec) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
-		memcpy(input_vec, ctemplate[i].input, ilen);
 		memset(output, 0, dlen);
 		init_completion(&result.completion);
 		sg_init_one(&src, input_vec, ilen);
@@ -1525,13 +1524,12 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		int ilen = dtemplate[i].inlen;
 		void *input_vec;
 
-		input_vec = kmalloc(ilen, GFP_KERNEL);
+		input_vec = kmemdup(dtemplate[i].input, ilen, GFP_KERNEL);
 		if (!input_vec) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
-		memcpy(input_vec, dtemplate[i].input, ilen);
 		memset(output, 0, dlen);
 		init_completion(&result.completion);
 		sg_init_one(&src, input_vec, ilen);
-- 
2.11.0
