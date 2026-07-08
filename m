Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E522DAFBD
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 20:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543452; cv=none; b=MohDE9KQSQawSJfBsDFRllf3IdZTOPfz84YPuMKtSPNdPofXICs8+pnlfEzcD/yd5IfHMWbDRgceSzWJ8y5RX7HPGcoeoYJALIhCOkhsUUzpgZmXtRHGyprAXuq8oFfCXb2Bq0172D5HO8XK03MPYXMBCJpKcn0rpcdn/AEdhYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543452; c=relaxed/simple;
	bh=u0RSxyH8Xd8Y3jHK6Cc9dkxQ6q5M+yZwuUINqDYDHpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXQhQ8ckOu687/NncLtwoCl1JKhBJ6Q4rqOfVdNvqZpnQkaZ6P0ufk9wFwmAoPnuVuC5+XmZg43KwxjUQO81FiRfFepbm+QGQNp0RKk7eMpzOOTSy/SnBPmUorLKreEVAtzWTYCIswgEemeDwRJeGEmsLY62ycLEevxwtdlCpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2c919te; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2c919te"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783543438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m/mfJtV8SIp3h7L8ILogP/clEi69csXyOP+b1FDLVho=;
	b=f2c919te5xEb7CtU5E95oz8aX+FoZy8oSwjH8d00ajXv+c4i05zFQ+H+jR3oUv+kXvPVF6
	Hfahqe7A7qqwBM9U1EgVqWj9cgHznW0O5sdCr4aAIaE64WdcJW2ayeYHWBlwkBAkHsHnmp
	HmJCBBzz3Xc3JtxYBNHkoyJJW1CAmUc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - avoid stale fallback key after set_secret failure
Date: Wed,  8 Jul 2026 22:42:48 +0200
Message-ID: <20260708204246.618591-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1654; i=thorsten.blum@linux.dev; h=from:subject; bh=u0RSxyH8Xd8Y3jHK6Cc9dkxQ6q5M+yZwuUINqDYDHpE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl+29weLf4w/Y19FFe218IXptuTTDaUv7iucMpnuazmx KtfYiZzd5SyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEklgZ/kpnq3aL7iv1Pyh3 SbBpqmj6b1OZm7vkV8dW+MnPXFk3P57hn2mxlxR3wkeTrfwTGdVzi+e9mWObUnBzV9vOTWGaryT amAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Clear ->do_fallback before decoding a new ECDH secret and enable it only
after the software fallback accepts a caller-provided private key. This
avoids using a stale fallback key should crypto_kpp_set_secret() fail.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 8e13aeccf011..4add3b2ddd0b 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -82,6 +82,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
 	kfree(ctx->public_key);
 	ctx->public_key = NULL;
+	ctx->do_fallback = false;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(&ctx->client->dev, "crypto_ecdh_decode_key failed\n");
@@ -89,8 +90,9 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	}
 
 	if (params.key_size) {
-		ctx->do_fallback = true;
-		return crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ret = crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ctx->do_fallback = !ret;
+		return ret;
 	}
 
 	cmd = kmalloc_obj(*cmd);
@@ -101,8 +103,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (!public_key)
 		goto free_cmd;
 
-	ctx->do_fallback = false;
-
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);

base-commit: e264401ce4776a288524e5b87593d4d864147115
