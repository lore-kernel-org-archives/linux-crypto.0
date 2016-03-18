From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] crypto: n2 - Remove return statement from void function
Date: Fri, 18 Mar 2016 19:08:48 +0530
Message-ID: <20160318133848.GA25643@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: julia.lawall@lip6.fr
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34540 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbcCRNi6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 09:38:58 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return statement at the end of a void function is useless.

The Coccinelle semantic patch used to make this change is as follows:
//<smpl>
@@
identifier f;
expression e;
@@
void f(...) {
<...
- return
  e;
...>
}
//</smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/crypto/n2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index b85a7a7..c5aac25 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1598,7 +1598,7 @@ static void *new_queue(unsigned long q_type)
 
 static void free_queue(void *p, unsigned long q_type)
 {
-	return kmem_cache_free(queue_cache[q_type - 1], p);
+	kmem_cache_free(queue_cache[q_type - 1], p);
 }
 
 static int queue_cache_init(void)
-- 
1.9.1
