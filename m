Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE2539E176;
	Wed,  3 Jun 2026 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514870; cv=none; b=I8iF18IvqkUctWV3IJRZfrMn0ozLpIMgUbkUdjqLQRirlWkOrAOkQ+wr4eZwISpLNKhYHNEA3dvfY/2K471/PbxDgOWjQcqB9CvtG/ShF/WiTu8mCxLPlpjaqjYjfBmBiaWHdCpEPO0ELILML4y5cHPNLOkraoznWgpcI/pg+Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514870; c=relaxed/simple;
	bh=WDSgSckh8g9+f4668nJMYJAMuCO0geaqbEBfilh+t5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHhbh5g7Beq/YIO7T8Fvp8+mra/F4hVNhS8OXvpuCEa3SZlLR/CV2GFJjWysJjG/yRui5wbqlz4xWd7ESidZVjVVoNKDQYQEbjIbXW1y8dPmeQqI0wr8XrFhX+BnE9l9jA+2XULFvGUoKgVnXPcP/b50/Ia5IlC9wL0B6OFB/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nvMkxRvD; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nvMkxRvD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780514865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIccNETEsaVgsXVsdiNeLcJNTcvR+VVsNEPVr66vAb8=;
	b=nvMkxRvD7yo2PyPijIONheRnh1BM02mO+6I2SyIc6xYmyyAV0ZEgzVCKKrRszpNdBDBfge
	2Hb4op9LlXbKxpK34ef2PEnXTQmXQ1eS55pjY+6Cwn/0+RgDGE3EQHT/2j03NXuJn86XHj
	0mHhbN1cHOuXSncOn2L/CZP2JCz7jvs=
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
Subject: [PATCH 2/2] crypto: atmel-ecc - clean up and improve ECDH comments
Date: Wed,  3 Jun 2026 21:27:11 +0200
Message-ID: <20260603192708.1237715-5-thorsten.blum@linux.dev>
In-Reply-To: <20260603192708.1237715-4-thorsten.blum@linux.dev>
References: <20260603192708.1237715-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5151; i=thorsten.blum@linux.dev; h=from:subject; bh=WDSgSckh8g9+f4668nJMYJAMuCO0geaqbEBfilh+t5Y=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkKDWK+ksLXE/4vnCKmNDnYqP+stWHS1Yi8oA3eZ2J7H u8UW1zaUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABPJXsrwi+n8gysNu9ZZVVl/ zojiNzY+93LbiyS9Y5/f6f5m3jxBxZeRYWXfPfWHztn3fyhVLLIrOjftrMdpw8XXL5mdaGy7dpM rgw8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Improve the kerneldoc for struct atmel_ecdh_ctx by removing the stale
"unsupported curves" wording, since the device only supports a single
curve (P-256), and move the set_secret() constraint to the description.

In atmel_ecdh_set_secret(), clarify that the device generates the
private key, and drop the redundant "only supports NIST P256" comment.

In atmel_ecdh_done() and atmel_ecdh_generate_public_key(), clarify the
truncation comments. Also note that a P-256 public key consists of two
32-byte coordinates in atmel_ecdh_compute_shared_secret(), and remove
the unnecessary fall-through comment and other redundant comments.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9387eea4513d..1443e18a9cee 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -27,15 +27,15 @@ static struct atmel_ecc_driver_data driver_data;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
- * @client     : pointer to i2c client device
- * @fallback   : used for unsupported curves or when user wants to use its own
- *               private key.
- * @public_key : generated when calling set_secret(). It's the responsibility
- *               of the user to not call set_secret() while
- *               generate_public_key() or compute_shared_secret() are in flight.
+ * @client     : I2C client device
+ * @fallback   : ECDH fallback used for caller-provided private keys
+ * @public_key : cached public key corresponding to the device-generated
+ *               private key
  * @curve_id   : elliptic curve id
- * @do_fallback: true when the device doesn't support the curve or when the user
- *               wants to use its own private key.
+ * @do_fallback: true when ECDH operations should use @fallback
+ *
+ * The caller must not invoke set_secret() while generate_public_key()
+ * or compute_shared_secret() are in flight.
  */
 struct atmel_ecdh_ctx {
 	struct i2c_client *client;
@@ -55,7 +55,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 	if (status)
 		goto free_work_data;
 
-	/* might want less than we've got */
+	/* copy only as much as requested, capped at 32 bytes */
 	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
 
 	/* copy the shared secret */
@@ -64,15 +64,15 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 	if (copied != n_sz)
 		status = -EINVAL;
 
-	/* fall through */
 free_work_data:
 	kfree_sensitive(work_data);
 	kpp_request_complete(req, status);
 }
 
 /*
- * A random private key is generated and stored in the device. The device
- * returns the pair public key.
+ * If no private key is provided, generate one in the device and cache
+ * the corresponding public key. The generated private key never leaves
+ * the device.
  */
 static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 				 unsigned int len)
@@ -83,9 +83,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct ecdh params;
 	int ret = -ENOMEM;
 
-	/* free the old public key, if any */
 	kfree(ctx->public_key);
-	/* make sure you don't free the old public key twice */
 	ctx->public_key = NULL;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
@@ -94,7 +92,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	}
 
 	if (params.key_size) {
-		/* fallback to ecdh software implementation */
 		ctx->do_fallback = true;
 		return crypto_kpp_set_secret(ctx->fallback, buf, len);
 	}
@@ -103,11 +100,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (!cmd)
 		return -ENOMEM;
 
-	/*
-	 * The device only supports NIST P256 ECC keys. The public key size will
-	 * always be the same. Use a macro for the key size to avoid unnecessary
-	 * computations.
-	 */
 	public_key = kmalloc(ATMEL_ECC_PUBKEY_SIZE, GFP_KERNEL);
 	if (!public_key)
 		goto free_cmd;
@@ -120,7 +112,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (ret)
 		goto free_public_key;
 
-	/* save the public key */
 	memcpy(public_key, &cmd->data[RSP_DATA_IDX], ATMEL_ECC_PUBKEY_SIZE);
 	ctx->public_key = public_key;
 
@@ -149,7 +140,7 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 	if (!ctx->public_key)
 		return -EINVAL;
 
-	/* might want less than we've got */
+	/* copy only as much as requested, capped at 64 bytes */
 	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
 
 	/* public key was saved at private key generation */
@@ -175,7 +166,7 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 		return crypto_kpp_compute_shared_secret(req);
 	}
 
-	/* must have exactly two points to be on the curve */
+	/* A P-256 public key must contain two 32-byte coordinates */
 	if (req->src_len != ATMEL_ECC_PUBKEY_SIZE)
 		return -EINVAL;
 
