From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: testmgr - Kill test_comp() sparse warnings
Date: Wed, 25 Mar 2009 16:17:17 +0100
Message-ID: <1237994238-3545-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59399 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757670AbZCYPRW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Mar 2009 11:17:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

make C=1:
| crypto/testmgr.c:846:45: warning: incorrect type in argument 5 (different signedness)
| crypto/testmgr.c:846:45:    expected unsigned int *dlen
| crypto/testmgr.c:846:45:    got int *<noident>
| crypto/testmgr.c:878:47: warning: incorrect type in argument 5 (different signedness)
| crypto/testmgr.c:878:47:    expected unsigned int *dlen
| crypto/testmgr.c:878:47:    got int *<noident>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b50c3c6..bfee6e9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -837,7 +837,8 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 	int ret;
 
 	for (i = 0; i < ctcount; i++) {
-		int ilen, dlen = COMP_BUF_SIZE;
+		int ilen;
+		unsigned int dlen = COMP_BUF_SIZE;
 
 		memset(result, 0, sizeof (result));
 
@@ -869,7 +870,8 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 	}
 
 	for (i = 0; i < dtcount; i++) {
-		int ilen, dlen = COMP_BUF_SIZE;
+		int ilen;
+		unsigned int dlen = COMP_BUF_SIZE;
 
 		memset(result, 0, sizeof (result));
 
-- 
1.6.0.4

