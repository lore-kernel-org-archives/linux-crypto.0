From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in crypto_null.c
Date: Wed, 10 Feb 2010 02:33:08 +0100
Message-ID: <1265765589-25878-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33973 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab0BJBdl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:33:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/crypto_null.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index cb71c91..07a8a96 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -1,11 +1,11 @@
-/* 
+/*
  * Cryptographic API.
  *
  * Null algorithms, aka Much Ado About Nothing.
  *
  * These are needed for IPsec, and may be useful in general for
  * testing & debugging.
- * 
+ *
  * The null cipher is compliant with RFC2410.
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
@@ -163,7 +163,7 @@ MODULE_ALIAS("cipher_null");
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
-	
+
 	ret = crypto_register_alg(&cipher_null);
 	if (ret < 0)
 		goto out;
@@ -180,7 +180,7 @@ static int __init crypto_null_mod_init(void)
 	if (ret < 0)
 		goto out_unregister_digest;
 
-out:	
+out:
 	return ret;
 
 out_unregister_digest:
-- 
1.6.6.1

