From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: padlock-aes: constify x86_cpu_id
Date: Fri, 25 Aug 2017 23:53:42 +0530
Message-ID: <b9707729957fe75e016b7f99d11d801e7d993027.1503685229.git.arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38477 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756367AbdHYSXw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 14:23:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

x86_cpu_id are not supposed to change at runtime. MODULE_DEVICE_TABLE
and x86_match_cpu are working with const x86_cpu_id. So mark the
non-const x86_cpu_id structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/padlock-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index b386974..4b6642a 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -482,7 +482,7 @@ static struct crypto_alg cbc_aes_alg = {
 	}
 };
 
-static struct x86_cpu_id padlock_cpu_id[] = {
+static const struct x86_cpu_id padlock_cpu_id[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_XCRYPT),
 	{}
 };
-- 
2.7.4
