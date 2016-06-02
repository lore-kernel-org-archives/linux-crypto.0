From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] crypto: skcipher - remove unused header cpumask.h
Date: Thu,  2 Jun 2016 13:48:38 +0800
Message-ID: <40677731b6e82e34c6f1f5b6d9456c6ed4c93234.1464844992.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35932 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbcFBFsv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 01:48:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unused header cpumask.h from crypto/ablkcipher.c.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 crypto/ablkcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index e5b5721..6b80516 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -14,7 +14,6 @@
  */
 
 #include <crypto/internal/skcipher.h>
-#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/rtnetlink.h>
-- 
1.9.1
