From: =?ISO-8859-1?Q?Szilveszter_=D6rd=F6g?= <slipszi@gmail.com>
Subject: [PATCH] crypto: hash - Fix handling of small unaligned buffers
Date: Mon, 2 Aug 2010 14:45:37 +0200
Message-ID: <AANLkTinj0tPGa1ZVEs2JZ1Hvg9YOq7qx56LZJrOs4WPc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45703 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0HBMpi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Aug 2010 08:45:38 -0400
Received: by gwb20 with SMTP id 20so1253406gwb.19
        for <linux-crypto@vger.kernel.org>; Mon, 02 Aug 2010 05:45:38 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If a scatterwalk chain contains an entry with an unaligned offset then
hash_walk_next() will cut off the next step at the next alignment point.

However, if the entry ends before the next alignment point then we will want to
process more data than it is available.

Fix this by checking whether the next aligment point is before the end of the
current entry.
---
 crypto/ahash.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b8c59b8..f669822 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -47,8 +47,11 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	walk->data = crypto_kmap(walk->pg, 0);
 	walk->data += offset;

-	if (offset & alignmask)
-		nbytes = alignmask + 1 - (offset & alignmask);
+	if (offset & alignmask) {
+		unsigned int unaligned = alignmask + 1 - (offset & alignmask);
+		if (nbytes > unaligned)
+			nbytes = unaligned;
+	}

 	walk->entrylen -= nbytes;
 	return nbytes;
-- 
1.5.5.6
