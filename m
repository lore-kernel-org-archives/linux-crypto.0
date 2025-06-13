Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C279E1;
	Fri, 13 Jun 2025 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749810800; cv=none; b=cFDAy6NatbKrH9FqD5N29zD/NSZoaSn6piONf9FJTHIWSpylS46nLUNtrZJtd9OD8NtlrTbl2BNVmwxoYmbzX0zP7aPrvFIueRoMQkClzBKRULH2qpfRxPC0W8yZy6N7agj7Kju+jWuyW6qc/SJq6Gu0fyUFt63XGzxeCtL83OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749810800; c=relaxed/simple;
	bh=DA/GpmXgrYZDR1Jokw6r2RFpNDpiElINfqhDc1jBzZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m2s3IVCo2QkgLdTOdW2pIu8gZK+YL/Vrz7qGrJvADdg9J3zS7ufUc7d0i6QR+mtJKbnCQnqlvyS5JQD4JZWNZ29iLkwpWAzHhQDx/VyoeWKgbFGYFFqnUj+Md182d8veBnxCssosyLE/9hW67KGywG7IImci1XKCyb+heOWEEf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYSoxEzB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYSoxEzB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749810799; x=1781346799;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DA/GpmXgrYZDR1Jokw6r2RFpNDpiElINfqhDc1jBzZE=;
  b=gYSoxEzBgb+iBgQ1qRPgNcSUe2A929abnllmw8nSz57FwHCsDsK68T0f
   Fbjgjwe0lzyT8o/faO8ddzI61VTRJgl52TYO7XhA1R031Xz8MC43fCEWm
   kt01xMoZQFn4bO8qdluezSM4oPOaWtMBpWz8z2gmHiNSxKyHnKGJGLfkh
   7TSzSsB5tVaSZ3tN5CCiHuPt1PrysNSR9nqeDGIecMm1QlIxTetLLJG22
   74Ho5NB7glZvdxQWthJ5hj4cdvZbojYFbMux2pvB3czxRm4kLkhkp4VpB
   YA1Le54GKEWkV63D2a3i2GFfUtJh8+HkVDmFyFkbkzjVGFdhZp33rqki2
   A==;
X-CSE-ConnectionGUID: QPsNl8FIT5SnGHq+rd06SQ==
X-CSE-MsgGUID: upwFH8p1Qv69NXDmA7Hzsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="55695736"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="55695736"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 03:33:17 -0700
X-CSE-ConnectionGUID: l8eTIZgDTUWpx5Zx4PRHGg==
X-CSE-MsgGUID: Awor3s5vQSmA8lh5BWGMKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="148680699"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa009.fm.intel.com with ESMTP; 13 Jun 2025 03:33:15 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: ebiggers@kernel.org,
	linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: qat - lower priority for skcipher and aead algorithms
Date: Fri, 13 Jun 2025 11:32:27 +0100
Message-ID: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Most kernel applications utilizing the crypto API operate synchronously
and on small buffer sizes, therefore do not benefit from QAT acceleration.

Reduce the priority of QAT implementations for both skcipher and aead
algorithms, allowing more suitable alternatives to be selected by default.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Link: https://lore.kernel.org/all/20250613012357.GA3603104@google.com/
Cc: stable@vger.kernel.org
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 3c4bba4a8779..d69cc1e5e023 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1277,7 +1277,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1294,7 +1294,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1311,7 +1311,7 @@ static struct aead_alg qat_aeads[] = { {
 	.base = {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
-		.cra_priority = 4001,
+		.cra_priority = 100,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
@@ -1329,7 +1329,7 @@ static struct aead_alg qat_aeads[] = { {
 static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
@@ -1347,7 +1347,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 }, {
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
@@ -1365,7 +1365,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 }, {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
-	.base.cra_priority = 4001,
+	.base.cra_priority = 100,
 	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
 			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
-- 
2.49.0

