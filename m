Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E463D565C;
	Thu, 11 Jun 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781175162; cv=none; b=M3Nxy2m8M2H0zSIcf54G1VUsu2nsVxTceAb6FYyDEaXe4W4JcDzzF2cUB8wYpoZtDvz7frwolDIDIGAzChdpEh8djGJGqT+sn8PHiVphxHdLRe34AXnHLL+Q01s6QPVXDnro/hnybEB643TizzwW10PPedIYnmooxglIHCovDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781175162; c=relaxed/simple;
	bh=Qu6LcM2KvLfw0lQYIuHm/kgXovCbBsOqYibtk8bQ6UA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hxhgi5vjwB8vHOcdrHeqlSCWw3xUoGlD74lLVL1b9RqZWmSh6eyTVngOIGWnlJEeXJz4lUzucnIUnmVqJxD9YEZyJkvNzaSnwl2vucdd1GLnmGe/qR/BFK88+/DxfZVk6ccIYVib3ar4qIbS2IomAXY4FONtYh5YAe7e/Q1ZIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a4fhU6UR; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a4fhU6UR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781175157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RmZrjg0Q3ZVv2NrQ57o9v2/owjwm0nO+Z9ZCILQ1szE=;
	b=a4fhU6URE5X9iJd0IpRNzX4jDyp2hwMqr/P4H5KJz1gYz9UxnwiAMr1T0LOT7WHIb2h29o
	ZcuZmudL+2qQVjP/2aL9umjpF5rdHnyig8KFTp21KwzAe703q2JNKKx1hNpOnpaYjK8nda
	xI4/6UGH6L1wSAfpDqCpgr9JVEgUJJo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - drop unused curve id from atmel_ecdh_ctx
Date: Thu, 11 Jun 2026 12:52:01 +0200
Message-ID: <20260611105159.460794-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1356; i=thorsten.blum@linux.dev; h=from:subject; bh=Qu6LcM2KvLfw0lQYIuHm/kgXovCbBsOqYibtk8bQ6UA=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlak/0vVYav2rf+/sz3bSv0dRK94oLytI+KX/ad+zdMf HJYUFlYRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExkyyFGhkWd050XLVnS0PPq yP6T0/58kVkjcE9T+9elM6f+L5jEqKTJyLBnUz4/m47Fi6rb/j/ll62Z4xOUf9qqs/hI7sa79ar Rk7kB
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

->curve_id is only set once, but never used - remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9da9dd6585df..93f219558c2f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -33,7 +33,6 @@ static struct atmel_ecc_driver_data driver_data;
  * @public_key : generated when calling set_secret(). It's the responsibility
  *               of the user to not call set_secret() while
  *               generate_public_key() or compute_shared_secret() are in flight.
- * @curve_id   : elliptic curve id
  * @do_fallback: true when the device doesn't support the curve or when the user
  *               wants to use its own private key.
  */
@@ -41,7 +40,6 @@ struct atmel_ecdh_ctx {
 	struct i2c_client *client;
 	struct crypto_kpp *fallback;
 	const u8 *public_key;
-	unsigned int curve_id;
 	bool do_fallback;
 };
 
@@ -250,7 +248,6 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct crypto_kpp *fallback;
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
-	ctx->curve_id = ECC_CURVE_NIST_P256;
 	ctx->client = atmel_ecc_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
