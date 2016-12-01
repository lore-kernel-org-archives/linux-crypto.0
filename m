From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] crypto: set error code when kcalloc fails
Date: Thu,  1 Dec 2016 10:04:43 +0800
Message-ID: <1480557883-18844-1-git-send-email-bianpan2016@163.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:41515 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754978AbcLACWS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 21:22:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix bug https://bugzilla.kernel.org/show_bug.cgi?id=188521. In function
skcipher_recvmsg_async(), variable err takes the return value, and its
value should be negative on failures. Because variable err may be
reassigned and checked before calling kcalloc(), its value may be 0
(indicates no error) even if kcalloc() fails. This patch fixes the bug
by explicitly assigning -ENOMEM to err when kcalloc() returns a NULL
pointer.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 crypto/algif_skcipher.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 28556fc..bfb0a1a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -566,8 +566,10 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 			 * need to expand */
 			tmp = kcalloc(tx_nents * 2, sizeof(*tmp),
 				      GFP_KERNEL);
-			if (!tmp)
+			if (!tmp) {
+				err = -ENOMEM;
 				goto free;
+			}
 
 			sg_init_table(tmp, tx_nents * 2);
 			for (x = 0; x < tx_nents; x++)
-- 
1.9.1
