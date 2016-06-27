From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 6/6] crypto: tcrypt - Add new mode for sha512_mb
Date: Mon, 27 Jun 2016 10:20:09 -0700
Message-ID: <1467048009-2826-7-git-send-email-megha.dey@intel.com>
References: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32075 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbcF0ROE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jun 2016 13:14:04 -0400
In-Reply-To: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Megha Dey <megha.dey@linux.intel.com>

Add a new mode to calculate the speed of the sha512_mb algorithm

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6ef7815..158c164 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1939,6 +1939,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 
+	case 424:
+		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
 	case 499:
 		break;
 
-- 
1.9.1
