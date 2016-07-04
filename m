From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: testmgr - Set err before proceeding
Date: Mon,  4 Jul 2016 10:52:34 +0100
Message-ID: <1467625954-2707-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14700 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbcGDJwn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:52:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Report correct error in case of failure

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8ea0d3f..769cc2a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1941,6 +1941,7 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	if (err)
 		goto free_req;
 
+	err = -ENOMEM;
 	out_len_max = crypto_akcipher_maxsize(tfm);
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
-- 
2.7.4
