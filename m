From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v3 4/4] crypto: Add the CRYPTO_ALG_BULK flag for ecb(aes) cipher
Date: Wed,  1 Jun 2016 12:58:07 +0800
Message-ID: <957907cb21cf096815c1defc4c95d88471eba1b2.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, baolin.wang@linaro.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since the ecb(aes) cipher does not need to handle the IV things for encryption
or decryption, that means it can support for bulk block when handling data.
Thus this patch adds the CRYPTO_ALG_BULK flag for ecb(aes) cipher to improve
the hardware aes engine's efficiency.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/crypto/omap-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce174d3..ab09429 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -804,7 +804,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_BULK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
-- 
1.7.9.5
