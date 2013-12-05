From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: scatterwalk - Use sg_chain_ptr on chain entries
Date: Thu, 5 Dec 2013 13:09:53 -0600
Message-ID: <20131205190953.16167.59879.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48100 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab3LETKR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 14:10:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that scatterwalk_sg_chain sets the chain pointer bit the sg_page
call in scatterwalk_sg_next hits a BUG_ON when CONFIG_DEBUG_SG is
enabled. Use sg_chain_ptr instead of sg_page on a chain entry.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 include/crypto/scatterwalk.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 64ebede..6a626a5 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -44,7 +44,7 @@ static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 	if (sg_is_last(sg))
 		return NULL;
 
-	return (++sg)->length ? sg : (void *)sg_page(sg);
+	return (++sg)->length ? sg : sg_chain_ptr(sg);
 }
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
