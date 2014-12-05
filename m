From: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: crypto: fixed style error in aead.c
Date: Fri,  5 Dec 2014 14:24:44 +0900
Message-ID: <1417757084-32155-1-git-send-email-Joshua@cybercrimetech.com>
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43714 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaLEFYw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 00:24:52 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so19452072pab.7
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2014 21:24:52 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style error identified by checkpatch.

ERROR: do not use assignment in if condition
+       if ((err = crypto_register_instance(tmpl, inst))) {

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 crypto/aead.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 547491e..2222710 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -448,7 +448,8 @@ static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
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
