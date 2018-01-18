From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v3 1/5] crypto: mxs-dcp: Add empty hash export and import
Date: Thu, 18 Jan 2018 19:34:00 +0100
Message-ID: <20180118183404.12583-2-k.konieczny@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183438eucas1p27a0802d5d4ce9013cff72e0ddaccd630@eucas1p2.samsung.com>
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
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33200 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755325AbeARSem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 13:34:42 -0500
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
---
 drivers/crypto/mxs-dcp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 764be3e6933c..a10c418d4e5c 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -759,6 +759,16 @@ static int dcp_sha_digest(struct ahash_request *req)
 	return dcp_sha_finup(req);
 }
 
+static int dcp_sha_noimport(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
+static int dcp_sha_noexport(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
 static int dcp_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
@@ -829,6 +839,8 @@ static struct ahash_alg dcp_sha1_alg = {
 	.final	= dcp_sha_final,
 	.finup	= dcp_sha_finup,
 	.digest	= dcp_sha_digest,
+	.import = dcp_sha_noimport,
+	.export = dcp_sha_noexport,
 	.halg	= {
 		.digestsize	= SHA1_DIGEST_SIZE,
 		.base		= {
@@ -853,6 +865,8 @@ static struct ahash_alg dcp_sha256_alg = {
 	.final	= dcp_sha_final,
 	.finup	= dcp_sha_finup,
 	.digest	= dcp_sha_digest,
+	.import = dcp_sha_noimport,
+	.export = dcp_sha_noexport,
 	.halg	= {
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.base		= {
-- 
2.15.0
