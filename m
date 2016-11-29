From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 04/10] crypto/chcr: Fixes Unchecked dereference inside function
Date: Tue, 29 Nov 2016 19:00:37 +0530
Message-ID: <6f9c37c7fca3bab16dd176c0bbac0e230f2979e3.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>, Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:39211 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932645AbcK2NbP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:15 -0500
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes 324429d74127, Unchecked dereference inside function.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index d24b7ce..0ae1b09 100644
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
