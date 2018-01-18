From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH 4/5] crypto: bfin_crc: Add empty hash export and import
Date: Thu, 18 Jan 2018 19:34:03 +0100
Message-ID: <20180118183404.12583-5-k.konieczny@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183440eucas1p2d435e0100eaf03d3967b28c29a2c91b3@eucas1p2.samsung.com>
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
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44313 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755733AbeARSeo (ORCPT
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
depends on them.
Add empty hash export and import, with the same behaviour as in framework
and expose this directly in driver. This can also prevent OOPS when config
option in Cryptographic API 'Disable run-time self tests' will be enabled.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/bfin_crc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index a118b9bed669..65a8e07835e8 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -450,6 +450,16 @@ static int bfin_crypto_crc_digest(struct ahash_request *req)
 	return bfin_crypto_crc_finup(req);
 }
 
+static int bfin_crypto_crc_noimport(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
+static int bfin_crypto_crc_noexport(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
 static int bfin_crypto_crc_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -487,6 +497,8 @@ static struct ahash_alg algs = {
 	.final		= bfin_crypto_crc_final,
 	.finup		= bfin_crypto_crc_finup,
 	.digest		= bfin_crypto_crc_digest,
+	.export		= bfin_crypto_crc_noexport,
+	.import		= bfin_crypto_crc_noimport,
 	.setkey		= bfin_crypto_crc_setkey,
 	.halg.digestsize	= CHKSUM_DIGEST_SIZE,
 	.halg.base	= {
-- 
2.15.0
