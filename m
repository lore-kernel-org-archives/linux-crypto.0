From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 3/9] crypto/chcr: Fixes Unchecked dereference inside function
Date: Mon, 21 Nov 2016 21:30:49 +0530
Message-ID: <48e81416bbc726b7ea22669baa081e9ca2cdbc09.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>, Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:35720 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754453AbcKUQBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 11:01:39 -0500
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes 324429d74127, Unchecked dereference inside function.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5918e1e..ff1c4e8 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -439,8 +439,9 @@ static inline void write_buffer_to_skb(struct sk_buff *skb,
 	skb->len += count;
 	skb->data_len += count;
 	skb->truesize += count;
+
 	while (count > 0) {
-		if (sg && (!(sg->length)))
+		if (!sg || (!(sg->length)))
 			break;
 		spage = sg_page(sg);
 		get_page(spage);
-- 
1.8.2.3
