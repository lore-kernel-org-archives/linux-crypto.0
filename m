From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 17/25] crypto: testmgr - Don't crash if CPRNG test result is large
Date: Sun,  7 Dec 2014 07:26:25 -0500
Message-ID: <d1fea6f576325fdcbb03a7dca6df79165f20516f.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:35612 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753183AbaLGM1E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:04 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The idea is to catch as many programmer mistakes as possible.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9faf265f..6bf43682 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1459,6 +1459,11 @@ static int test_cprng(struct crypto_rng *tfm,
 	u8 result[32];
 
 	for (i = 0; i < tcount; i++) {
+		if (template[i].rlen > sizeof(result)) {
+			printk(KERN_CRIT "alg: cprng: Cannot test %s\n", algo);
+			err = -EOVERFLOW;
+			break;
+		}
 		memset(result, 0, sizeof result);
 
 		err = crypto_rng_reset(tfm, template[i].seed, template[i].slen);
-- 
2.1.3
