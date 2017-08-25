From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: padlock-sha: constify x86_cpu_id
Date: Fri, 25 Aug 2017 23:53:59 +0530
Message-ID: <65b824f997b05b65cdd76e41d2e6dda631d5b684.1503685310.git.arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36248 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758012AbdHYSYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 14:24:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

x86_cpu_id are not supposed to change at runtime. MODULE_DEVICE_TABLE
and x86_match_cpu are working with const x86_cpu_id. So mark the
non-const x86_cpu_id structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/padlock-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index bc72d20..d32c793 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -509,7 +509,7 @@ static struct shash_alg sha256_alg_nano = {
 	}
 };
 
-static struct x86_cpu_id padlock_sha_ids[] = {
+static const struct x86_cpu_id padlock_sha_ids[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_PHE),
 	{}
 };
-- 
2.7.4
