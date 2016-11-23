From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: acomp - don't use stack buffer in test_acomp()
Date: Wed, 23 Nov 2016 10:24:35 -0800
Message-ID: <1479925475-13732-1-git-send-email-ebiggers@google.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34541 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752404AbcKWS1I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2016 13:27:08 -0500
Received: by mail-pf0-f176.google.com with SMTP id c4so4729641pfb.1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2016 10:27:08 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With virtually-mapped stacks (CONFIG_VMAP_STACK=y), using the
scatterlist crypto API with stack buffers is not allowed, and with
appropriate debugging options will cause the
'BUG_ON(!virt_addr_valid(buf));' in sg_set_buf() to be triggered.
Use a heap buffer instead.

Fixes: d7db7a882deb ("crypto: acomp - update testmgr with support for acomp")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ded50b6..aca1b7b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1448,17 +1448,21 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
 	unsigned int i;
-	char output[COMP_BUF_SIZE];
+	char *output;
 	int ret;
 	struct scatterlist src, dst;
 	struct acomp_req *req;
 	struct tcrypt_result result;
 
+	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
+
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
 
-		memset(output, 0, sizeof(output));
+		memset(output, 0, dlen);
 		init_completion(&result.completion);
 		sg_init_one(&src, ctemplate[i].input, ilen);
 		sg_init_one(&dst, output, dlen);
@@ -1507,7 +1511,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = dtemplate[i].inlen;
 
-		memset(output, 0, sizeof(output));
+		memset(output, 0, dlen);
 		init_completion(&result.completion);
 		sg_init_one(&src, dtemplate[i].input, ilen);
 		sg_init_one(&dst, output, dlen);
@@ -1555,6 +1559,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 	ret = 0;
 
 out:
+	kfree(output);
 	return ret;
 }
 
-- 
2.8.0.rc3.226.g39d4020
