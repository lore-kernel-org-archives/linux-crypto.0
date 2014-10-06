From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] crypto: Remove unnecessary KERN_INFO from testmgr.c
Date: Tue,  7 Oct 2014 00:37:54 +0900
Message-ID: <1412609874-22311-1-git-send-email-standby24x7@gmail.com>
Cc: Masanari Iida <standby24x7@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch remove unncessary KERN_INFO from pr_info within testmgr.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 crypto/testmgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9459dfd..9d57e3f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3710,8 +3710,7 @@ test_done:
 		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
 
 	if (fips_enabled && !rc)
-		pr_info(KERN_INFO "alg: self-tests for %s (%s) passed\n",
-			driver, alg);
+		pr_info("alg: self-tests for %s (%s) passed\n", driver, alg);
 
 	return rc;
 
-- 
2.1.1.273.g97b8860
