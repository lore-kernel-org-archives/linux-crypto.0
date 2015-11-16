From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 1/2] crypto: api - use list_first_entry_or_null and list_next_entry
Date: Mon, 16 Nov 2015 22:37:14 +0800
Message-ID: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:36882 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbbKPOhg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Nov 2015 09:37:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Simplify crypto_more_spawns() with list_first_entry_or_null()
and list_next_entry().

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 crypto/algapi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 59bf491..7be76aa 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -93,16 +93,15 @@ static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
 {
 	struct crypto_spawn *spawn, *n;
 
-	if (list_empty(stack))
+	spawn = list_first_entry_or_null(stack, struct crypto_spawn, list);
+	if (!spawn)
 		return NULL;
 
-	spawn = list_first_entry(stack, struct crypto_spawn, list);
-	n = list_entry(spawn->list.next, struct crypto_spawn, list);
+	n = list_next_entry(spawn, list);
 
 	if (spawn->alg && &n->list != stack && !n->alg)
 		n->alg = (n->list.next == stack) ? alg :
-			 &list_entry(n->list.next, struct crypto_spawn,
-				     list)->inst->alg;
+			 &list_next_entry(n, list)->inst->alg;
 
 	list_move(&spawn->list, secondary_spawns);
 
-- 
2.5.0
