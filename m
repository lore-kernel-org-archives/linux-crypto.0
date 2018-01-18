From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH 3/5] crypto: ux500/hash: Add empty export and import
Date: Thu, 18 Jan 2018 19:34:02 +0100
Message-ID: <20180118183404.12583-4-k.konieczny@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183440eucas1p21e1a425cbafe3cbb3856d97fd94228e5@eucas1p2.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Vasut <marex@denx.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33220 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755571AbeARSeo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 13:34:44 -0500
In-reply-to: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Crypto framework requires export/import in async hash. If driver do not
implement them, wrapper functions in framework will be used, and it will
cause error during ahash alg registration (unless one disables crypto
internal tests). To make change in framework and expose this requirement,
I will remove wrappers from crypto/ahash.c , but this can broke code which
depends on them. Add empty hash export and import, with the same behaviour
as in framework and expose this directly in driver. This can also prevent
OOPS when config option in Cryptographic API 'Disable run-time self tests'
will be enabled.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 9acccad26928..2d0a677bcc76 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1403,6 +1403,16 @@ static int ahash_sha256_digest(struct ahash_request *req)
 	return ret1 ? ret1 : ret2;
 }
 
+static int ahash_noimport(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
+static int ahash_noexport(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
 static int hmac_sha1_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -1507,6 +1517,8 @@ static struct hash_algo_template hash_algs[] = {
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha1_digest,
+			.export = ahash_noexport,
+			.import = ahash_noimport,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1529,6 +1541,8 @@ static struct hash_algo_template hash_algs[] = {
 			.update	= ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha256_digest,
+			.export = ahash_noexport,
+			.import = ahash_noimport,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1553,6 +1567,8 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha1_digest,
 			.setkey = hmac_sha1_setkey,
+			.export = ahash_noexport,
+			.import = ahash_noimport,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
@@ -1577,6 +1593,8 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha256_digest,
 			.setkey = hmac_sha256_setkey,
+			.export = ahash_noexport,
+			.import = ahash_noimport,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.statesize = sizeof(struct hash_ctx),
 			.halg.base = {
-- 
2.15.0
