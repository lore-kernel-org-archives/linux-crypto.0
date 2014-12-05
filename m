From: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: crypto: fixed style error in ahash.c
Date: Fri,  5 Dec 2014 14:44:54 +0900
Message-ID: <1417758294-22850-1-git-send-email-Joshua@cybercrimetech.com>
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58580 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaLEFo7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 00:44:59 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so7784pad.27
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2014 21:44:59 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style error identified by checkpatch.

WARNING: Missing a blank line after declarations
+               unsigned int unaligned = alignmask + 1 - (offset & alignmask);
+               if (nbytes > unaligned)

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 crypto/ahash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f6a36a5..dd28906 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -55,6 +55,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 
 	if (offset & alignmask) {
 		unsigned int unaligned = alignmask + 1 - (offset & alignmask);
+
 		if (nbytes > unaligned)
 			nbytes = unaligned;
 	}
-- 
1.9.1
