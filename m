From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 16/25] crypto: testmgr - Report failure on zero-length crypto_rng_get_bytes
Date: Sun,  7 Dec 2014 07:26:24 -0500
Message-ID: <62e1366f793c73930bc8cccda73ab9b47cd6756e.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:17519 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753219AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If crypto_rng_get_bytes returns an error code, returning it is a good
idea, but if it simply returns zero, the test shouldn't abort successfully.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0e179c72..9faf265f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1476,6 +1476,8 @@ static int test_cprng(struct crypto_rng *tfm,
 				       "the correct amount of random data for "
 				       "%s (requested %d, got %d)\n", algo,
 				       template[i].rlen, err);
+				if (err >= 0)
+					err = -EINVAL;
 				break;
 			}
 		}
-- 
2.1.3
