Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1E239066;
	Tue, 18 Feb 2025 10:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739875855; cv=none; b=G83GzGyF9Yi4tkGs3hLUZfCZyMJdzZK8Zs5qxZV+lJMVQhEM5EdcB2KMDaOMLKhqPRLG3gOzCVD17fe1HnQIKvSjRcdtcMgrTgv3KnIwb2l5rhC49818EIvAV4ZH9aU9W15CDLr9nfFQ6U++CaIBqEMzNoQtj2MW4ipbOiyHhYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739875855; c=relaxed/simple;
	bh=oCwNWZI/n6K/e0KeD0KECH58mj3BowZrbon38IxBlxQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acMqIJtAmiHXBIkJb4ofdRf7y5AU/F1fVVcsayyMk8rPtWASM/wfvxZH4YXLPqrnaXSowFu253lMF2A3H1iSx/cPdSHz4IczO3L+AXI0TfJqorzHShWa08VHzHxe2PbkOYTMJgJP61RtapEmwPGUgfhFBKEeqzrFvDnlQfw0RQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=uc6tII9z; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="uc6tII9z"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 51IAonM1841376
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 18 Feb 2025 04:50:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1739875849;
	bh=TDl/MlAWM7RZZrWvhYbB3Rt/Ey4V28+9NkFSVKszwOI=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=uc6tII9z0D4gFcudlm0OtGDthvVmRegD5YtEy/WZZX3S16wU67C2EsKKPtZ8ACBEh
	 2SC8HE6KHCMR9V7lJoq2bjLL3GM0cemJQFT0WCZzsP7HKEx8zDG0ax4Oi0rBtVI7qN
	 OZbBlLHHWlJvFDS4XcuajbcvZgu5YXEjtIvVJdFI=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51IAonnI034528;
	Tue, 18 Feb 2025 04:50:49 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 18
 Feb 2025 04:50:48 -0600
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 18 Feb 2025 04:50:49 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51IAolbJ095035;
	Tue, 18 Feb 2025 04:50:48 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, T Pratham <t-pratham@ti.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 2/2] crypto: ti: Add support for MD5 in DTHE V2 Hashing Engine driver
Date: Tue, 18 Feb 2025 16:19:43 +0530
Message-ID: <20250218104943.2304730-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250218104943.2304730-1-t-pratham@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add support for MD5 algorithm of the hashing engine of DTHE V2 crypto
accelerator driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig  |  1 +
 drivers/crypto/ti/dthev2.c | 56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 39d9d8cb6b78..ab4da73dffc4 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHE_V2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_MD5
 	help
 	  This enables support for the TI DTHE V2 hw crypto accelerator
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2.c b/drivers/crypto/ti/dthev2.c
index d5ed0f4621f5..ff2d5ef47c2a 100644
--- a/drivers/crypto/ti/dthev2.c
+++ b/drivers/crypto/ti/dthev2.c
@@ -25,6 +25,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 
 #include <linux/delay.h>
@@ -363,6 +364,25 @@ static int dthe_sha224_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int dthe_md5_cra_init(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.hash_ctx)
+		return -ENOMEM;
+
+	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_MD5;
+	ctx->ctx_info.hash_ctx->block_size = MD5_BLOCK_WORDS * 4;
+	ctx->ctx_info.hash_ctx->digest_size = MD5_DIGEST_SIZE;
+	ctx->ctx_info.hash_ctx->phash_size = MD5_DIGEST_SIZE;
+	return 0;
+}
+
 static void dthe_hash_cra_exit(struct crypto_tfm *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -602,6 +622,8 @@ static int dthe_hash_update(struct ahash_request *req)
 				memcpy(sctx->phash, sha256_zero_message_hash, sctx->digest_size);
 			else if (sctx->mode == DTHE_HASH_SHA224)
 				memcpy(sctx->phash, sha224_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_MD5)
+				memcpy(sctx->phash, md5_zero_message_hash, sctx->digest_size);
 		}
 
 		return 0;
@@ -736,6 +758,8 @@ static int dthe_hash_final(struct ahash_request *req)
 			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
 		else if (sctx->mode == DTHE_HASH_SHA224)
 			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_MD5)
+			memcpy(req->result, md5_zero_message_hash, sctx->digest_size);
 	}
 
 	memcpy(req->result, sctx->phash, sctx->digest_size);
@@ -774,6 +798,8 @@ static int dthe_hash_finup(struct ahash_request *req)
 				memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
 			else if (sctx->mode == DTHE_HASH_SHA224)
 				memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_MD5)
+				memcpy(req->result, md5_zero_message_hash, sctx->digest_size);
 		}
 		return 0;
 	}
@@ -870,6 +896,8 @@ static int dthe_hash_digest(struct ahash_request *req)
 			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
 		else if (sctx->mode == DTHE_HASH_SHA224)
 			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_MD5)
+			memcpy(req->result, md5_zero_message_hash, sctx->digest_size);
 		return 0;
 	}
 
@@ -1366,6 +1394,34 @@ static struct ahash_alg hash_algs[] = {
 			}
 		}
 	},
+	{
+		.init	= dthe_hash_init,
+		.update	= dthe_hash_update,
+		.final	= dthe_hash_final,
+		.finup	= dthe_hash_finup,
+		.digest	= dthe_hash_digest,
+		.export = dthe_hash_export,
+		.import = dthe_hash_import,
+		.halg	= {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_ctx),
+			.base = {
+				.cra_name	 = "md5",
+				.cra_driver_name = "md5-dthe_v2",
+				.cra_priority	 = 400,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY,
+				.cra_blocksize	 = MD5_BLOCK_WORDS * 4,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_module	 = THIS_MODULE,
+				.cra_init	 = dthe_md5_cra_init,
+				.cra_exit	 = dthe_hash_cra_exit,
+			}
+		}
+	},
 };
 
 static struct skcipher_alg cipher_algs[] = {
-- 
2.34.1

