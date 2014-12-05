From: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: crypto: fixed style errors in ablkcipher.c
Date: Fri,  5 Dec 2014 14:06:16 +0900
Message-ID: <1417755976-19514-1-git-send-email-Joshua@cybercrimetech.com>
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64704 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLEFGa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 00:06:30 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so19483199pab.20
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2014 21:06:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style errors reported by checkpatch.

WARNING: Missing a blank line after declarations
+       u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+       return max(start, end_page);

WARNING: line over 80 characters
+               scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));

WARNING: Missing a blank line after declarations
+               int err = ablkcipher_copy_iv(walk, tfm, alignmask);
+               if (err)

ERROR: do not use assignment in if condition
+       if ((err = crypto_register_instance(tmpl, inst))) {

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 crypto/ablkcipher.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 40886c4..7bbc8b4 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -69,6 +69,7 @@ static inline void ablkcipher_queue_write(struct ablkcipher_walk *walk,
 static inline u8 *ablkcipher_get_spot(u8 *start, unsigned int len)
 {
 	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+
 	return max(start, end_page);
 }
 
@@ -86,7 +87,8 @@ static inline unsigned int ablkcipher_done_slow(struct ablkcipher_walk *walk,
 		if (n == len_this_page)
 			break;
 		n -= len_this_page;
-		scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));
+		scatterwalk_start(&walk->out, scatterwalk_sg_next(
+			walk->out.sg));
 	}
 
 	return bsize;
@@ -284,6 +286,7 @@ static int ablkcipher_walk_first(struct ablkcipher_request *req,
 	walk->iv = req->info;
 	if (unlikely(((unsigned long)walk->iv & alignmask))) {
 		int err = ablkcipher_copy_iv(walk, tfm, alignmask);
+
 		if (err)
 			return err;
 	}
@@ -589,7 +592,8 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 	if (IS_ERR(inst))
 		goto put_tmpl;
 
-	if ((err = crypto_register_instance(tmpl, inst))) {
+	err = crypto_register_instance(tmpl, inst);
+	if (err) {
 		tmpl->free(inst);
 		goto put_tmpl;
 	}
-- 
1.9.1
