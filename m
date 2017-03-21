From: Ming Ma <mingma@micron.com>
Subject: [PATCH 1/1] crypto: If two strings are exact match, they must have same length.
Date: Tue, 21 Mar 2017 16:40:40 -0500
Message-ID: <1490132440-112761-1-git-send-email-mingma@micron.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ming Ma <mingma@micron.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:38222 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758281AbdCUVlW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 17:41:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When both "crct10dif-pclmul" algorithm and "crct10dif-generic" algorithm
exist in crypto_alg_list, "crct10dif-pclmul" should be selected, since it
has higher priority than "crct10dif-generic". However, both algorithms
have the same cra_name "crct10dif". If we use "crct10dif" to find a
matched algorithm in crypto_alg_list, it's possible "crct10dif-generic" is
selected, because the code calls strcmp to decide if two string are exact
match, but doesn't check if two strings have the same length.

exact = !strcmp(q->cra_driver_name, name);

So ,if "crct10dif-generic" is in front of "crct10dif-pclmul" in
crypto_alg_list, it will be picked as the matched algorithm, even if it has
lower priority than "crct10dif-pclmul".
Signed-off-by: Ming Ma <mingma@micron.com>
---
 crypto/api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index b16ce16..5b3d45a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -76,7 +76,8 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 		    ((struct crypto_larval *)q)->mask != mask)
 			continue;
 
-		exact = !strcmp(q->cra_driver_name, name);
+		exact = (strlen(name) == strlen(q->cra_driver_name)) &&
+				!strcmp(q->cra_driver_name, name);
 		fuzzy = !strcmp(q->cra_name, name);
 		if (!exact && !(fuzzy && q->cra_priority > best))
 			continue;
-- 
2.4.11
