From: megha.dey@linux.intel.com
Subject: [PATCH 6/6] crypto: tcrypt - Add new mode for sha512_mb
Date: Thu, 24 Mar 2016 13:27:29 -0700
Message-ID: <1458851249-3491-7-git-send-email-megha.dey@linux.intel.com>
References: <1458851249-3491-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tim.c.chen@linux.intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458851249-3491-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Add a new mode to calculate the speed of the sha512_mb algorithm

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a2172e8..480bb75 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1892,6 +1892,12 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		if (mode > 400 && mode < 500)
 			break;
 
+	case 422:
+		test_mb_ahash_speed("sha512", sec,
+						generic_hash_speed_template);
+		if (mode > 400 && mode < 500)
+			break;
+
 	case 499:
 		break;
 
-- 
1.9.1
