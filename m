From: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: crypto: fixed style erro in algapi.c
Date: Fri,  5 Dec 2014 15:00:10 +0900
Message-ID: <1417759210-12904-1-git-send-email-Joshua@cybercrimetech.com>
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53919 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaLEGAT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 01:00:19 -0500
Received: by mail-pd0-f181.google.com with SMTP id v10so41463pde.12
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2014 22:00:19 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style error identified by checkpatch.

WARNING: Missing a blank line after declarations
+               int err = crypto_remove_alg(&inst->alg, &users);
+               BUG_ON(err);

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 crypto/algapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e8d3a7d..512730d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -473,6 +473,7 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 	list = &tmpl->instances;
 	hlist_for_each_entry(inst, list, list) {
 		int err = crypto_remove_alg(&inst->alg, &users);
+
 		BUG_ON(err);
 	}
 
-- 
1.9.1
