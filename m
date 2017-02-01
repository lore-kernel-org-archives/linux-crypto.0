From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 1/1] crypto:algif_aead - Fix kernel panic on list_del
Date: Wed,  1 Feb 2017 21:10:28 +0530
Message-ID: <3368ebb31bd1670b8ea8ff45c81807c8c0e6bc3b.1485948732.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: smueller@chronox.de, herbert@gondor.apana.org.au,
        atul.gupta@chelsio.com, harshjain.prof@gmail.com,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:11482 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdBAPmH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 10:42:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kernel panics when userspace program try to access AEAD interface.
Remove node from Linked List before freeing its memory.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f849311..533265f 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -661,9 +661,9 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 unlock:
 	list_for_each_entry_safe(rsgl, tmp, &ctx->list, list) {
 		af_alg_free_sg(&rsgl->sgl);
+		list_del(&rsgl->list);
 		if (rsgl != &ctx->first_rsgl)
 			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-		list_del(&rsgl->list);
 	}
 	INIT_LIST_HEAD(&ctx->list);
 	aead_wmem_wakeup(sk);
-- 
1.8.2.3
