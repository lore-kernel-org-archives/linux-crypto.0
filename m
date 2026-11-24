Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521686;
	b=dHpx4M80yBYaf1y0u2caUbezzJfkzz3QyRVqmbCMBJR2VrO7qduiDzIVeORD5zGVHwIU
	 dUWfYZRbsNGW+lZ3TJd8+e3zYohweLuzN6XSezYGkWLcfkpTz42FbM9thAXMuczW5MxD2
	 47EAlfRAM8IxfamCS22LOzMWmsfQF2sLnDpFhbSfuXICVS8JFfcYote6dUsV8L+I8zQ8j
	 5W12TcC2jf/vGzwlOfUDAV439hkjLElntLH6jGW7CRPDzUKAqIA6ykRsINR2slxMWSUtx
	 2NBd80XuKqDa+ijTQ8KEo+Ciy1+J3eHJ7bAnhJN5zZJLaeA4NhVmF/aMVbF6F57OCrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CDAQStyWgKcZ7NhQpA8umAE/0UiMfEQBZb32WBCGfB4=;
	b=gAmJTel7uNtgLNlcbfw0QlGd+mHtNOjZOAbelavbUVR7/vy0PT6VEsZyMIxIPkYyRi4Y
	 h1rhej4ISgUVQZlprVZs28u6IRIubZL50Ie+qXhgdSHI+K7lcb69WBFltnf5QnS2C6426
	 8CveXdNgfo8F+AhzPJKzxN8S5yYy61fzrad8v2yd6UhAlIJYPqPeLjxsDe3rZysq6raew
	 aw8DPMyBvke+leR1xsNTDFtyO1TxOk8NJN3SUxkK4snYgBz1tFgp349yykv6TfC6N4SJe
	 73+WhsuG22SCmoeDDJdEvsbR4DR9RXcsq9vOXOdAu6cSRnBNPp5vrwxVWxA7ie7Af9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xq6+5H5G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A2DC5606A322;
	Tue, 24 Nov 2026 12:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xq6+5H5G
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9FFE01F000D3;
	Tue, 24 Nov 2026 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521686;
	bh=CDAQStyWgKcZ7NhQpA8umAE/0UiMfEQBZb32WBCGfB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xq6+5H5GeYfS2Dxuvcqco6sF+8sPhxtwN5Vgo2oeFH61wr8XRX0qqJ1wk1jIaveAM
	 0941x1Ppdgon/2BPcFVU7y1vzOZ61Awf2blaiog6DtcWKWyh2eHydsRUZd83C2511J
	 G/Evlve3Fs5GlqX/mFKAXQFeOVW9vam+Gk1F0X/daCVM1PtStICWuA59FRmz0IAO46
	 OA21HCvi5BLV14GtY+yaZ1u0T6T4p8HJTTl3csfXcurxcLh6WXaEbKgr9Fj4n3kE1B
	 TykibEmnxdQYIMMPGX82XxTotKCuplWM6YF68FPHLmXCGWJgWhODMQ+dqQctGyC8DN
	 0fH+raHOToxaA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4/9] tpm: Add persistent hierarchies to tpm2_create_primary()
Date: Tue, 24 Nov 2026 14:00:39 +0200
Message-ID: <20261124120044.1481752-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124120044.1481752-1-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TPMKey files can specify a 0x40 MSO permanent handle as parent, requiring
TPM2_CreatePrimary with the TCG H-2 NIST P-256 template [1].

Populate chip->null_ec_key_{x,y} in tpm2_parse_create_primary() only for
TPM2_RH_NULL.

Verify the returned key name against the locally computed TPMT_PUBLIC
digest, and flush the transient handle on validation failure.

[1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html#section-3.1.8

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm2-sessions.c | 104 +++++++++++++++++--------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index b3b4f7a89d9d..98f668874c3e 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1118,10 +1118,11 @@ int tpm2_sessions_init(struct tpm_chip *chip)
 	return rc;
 }
 #endif /* CONFIG_TCG_TPM2_HMAC */
+
 /*
- * A mask containing the object attributes for the kernel held null primary key
- * used in HMAC encryption. For more information on specific attributes look up
- * to "8.3 TPMA_OBJECT (Object Attributes)".
+ * A mask containing the object attributes for the TCG mandated H-2 ECC P-256
+ * primary storage key template. For more information on specific attributes
+ * look up "8.3 TPMA_OBJECT (Object Attributes)".
  */
 #define TPM2_OA_NULL_KEY ( \
 	TPM2_OA_NO_DA | \
@@ -1151,15 +1152,14 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 {
 	struct tpm_header *head = (struct tpm_header *)buf->data;
 	off_t offset_r = TPM_HEADER_SIZE, offset_t;
-	u16 len = TPM_HEADER_SIZE;
+	u8 resp_name[SHA256_DIGEST_SIZE + 2];
 	u32 total_len = be32_to_cpu(head->length);
 	u32 val, param_len, keyhandle;
+	u16 len = TPM_HEADER_SIZE;
 
 	keyhandle = tpm_buf_read_u32(buf, &offset_r);
-	if (handle)
-		*handle = keyhandle;
-	else
-		tpm2_flush_context(chip, keyhandle);
+	if (buf->flags & TPM_BUF_INVALID)
+		return -EINVAL;
 
 	param_len = tpm_buf_read_u32(buf, &offset_r);
 	/*
@@ -1170,85 +1170,87 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	param_len += TPM_HEADER_SIZE;
 
 	if (param_len + 8 > total_len)
-		return -EINVAL;
+		goto err;
 	len = tpm_buf_read_u16(buf, &offset_r);
 	offset_t = offset_r;
 	if (offset_r + len > tpm_buf_length(buf))
-		return -EINVAL;
-	if (name) {
-		/*
-		 * now we have the public area, compute the name of
-		 * the object
-		 */
-		put_unaligned_be16(TPM_ALG_SHA256, name);
-		sha256(&buf->data[offset_r], len, name + 2);
-	}
+		goto err;
+
+	/*
+	 * Now we have the public area, compute the name of the object.
+	 */
+	put_unaligned_be16(TPM_ALG_SHA256, resp_name);
+	sha256(&buf->data[offset_r], len, resp_name + 2);
+	if (name)
+		memcpy(name, resp_name, sizeof(resp_name));
 
 	/* validate the public key */
 	val = tpm_buf_read_u16(buf, &offset_t);
 
 	/* key type (must be what we asked for) */
 	if (val != TPM_ALG_ECC)
-		return -EINVAL;
+		goto err;
 	val = tpm_buf_read_u16(buf, &offset_t);
 
 	/* name algorithm */
 	if (val != TPM_ALG_SHA256)
-		return -EINVAL;
+		goto err;
 	val = tpm_buf_read_u32(buf, &offset_t);
 
 	/* object properties */
 	if (val != TPM2_OA_NULL_KEY)
-		return -EINVAL;
+		goto err;
 
 	/* auth policy (empty) */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != 0)
-		return -EINVAL;
+		goto err;
 
 	/* symmetric key parameters */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != TPM_ALG_AES)
-		return -EINVAL;
+		goto err;
 
 	/* symmetric key length */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != AES_KEY_BITS)
-		return -EINVAL;
+		goto err;
 
 	/* symmetric encryption scheme */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != TPM_ALG_CFB)
-		return -EINVAL;
+		goto err;
 
 	/* signing scheme */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != TPM_ALG_NULL)
-		return -EINVAL;
+		goto err;
 
 	/* ECC Curve */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != TPM2_ECC_NIST_P256)
-		return -EINVAL;
+		goto err;
 
 	/* KDF Scheme */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != TPM_ALG_NULL)
-		return -EINVAL;
+		goto err;
 
 	/* extract public key (x and y points) */
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != EC_PT_SZ)
-		return -EINVAL;
+		goto err;
 #ifdef CONFIG_TCG_TPM2_HMAC
-	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
+	if (hierarchy == TPM2_RH_NULL)
+		memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
 #endif
 	offset_t += val;
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != EC_PT_SZ)
-		return -EINVAL;
+		goto err;
 #ifdef CONFIG_TCG_TPM2_HMAC
-	memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
+	if (hierarchy == TPM2_RH_NULL)
+		memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
 #endif
 	offset_t += val;
 
@@ -1257,38 +1259,38 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 
 	/* should have exactly consumed the TPM2B public structure */
 	if (offset_t != offset_r)
-		return -EINVAL;
+		goto err;
 	if (offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/* creation data (skip) */
 	len = tpm_buf_read_u16(buf, &offset_r);
 	offset_r += len;
 	if (offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/* creation digest (must be sha256) */
 	len = tpm_buf_read_u16(buf, &offset_r);
 	offset_r += len;
 	if (len != SHA256_DIGEST_SIZE || offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/* TPMT_TK_CREATION follows */
 	/* tag, must be TPM_ST_CREATION (0x8021) */
 	val = tpm_buf_read_u16(buf, &offset_r);
 	if (val != TPM2_ST_CREATION || offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/* hierarchy */
 	val = tpm_buf_read_u32(buf, &offset_r);
 	if (val != hierarchy || offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/* the ticket digest HMAC (might not be sha256) */
 	len = tpm_buf_read_u16(buf, &offset_r);
 	offset_r += len;
 	if (offset_r > param_len)
-		return -EINVAL;
+		goto err;
 
 	/*
 	 * finally we have the name, which is a sha256 digest plus a 2
@@ -1296,19 +1298,25 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	 */
 	len = tpm_buf_read_u16(buf, &offset_r);
 	if (offset_r + len != param_len + 8)
-		return -EINVAL;
+		goto err;
 	if (len != SHA256_DIGEST_SIZE + 2)
-		return -EINVAL;
+		goto err;
 
-#ifdef CONFIG_TCG_TPM2_HMAC
-	if (memcmp(chip->null_key_name, &buf->data[offset_r],
-		   SHA256_DIGEST_SIZE + 2) != 0) {
-		dev_err(&chip->dev, "NULL Seed name comparison failed\n");
-		return -EINVAL;
+	if (memcmp(resp_name, &buf->data[offset_r], sizeof(resp_name)) != 0) {
+		dev_err(&chip->dev, "primary key name comparison failed\n");
+		goto err;
 	}
-#endif
+
+	if (handle)
+		*handle = keyhandle;
+	else
+		tpm2_flush_context(chip, keyhandle);
 
 	return 0;
+
+err:
+	tpm2_flush_context(chip, keyhandle);
+	return -EINVAL;
 }
 
 /**
@@ -1420,7 +1428,7 @@ int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy, u32 *handle,
 	tpm_buf_append_u32(buf, 0);
 
 	rc = tpm_transmit_cmd(chip, buf, 0,
-			      "attempting to create NULL primary");
+			      "attempting to create primary key");
 
 	if (rc == TPM2_RC_SUCCESS)
 		rc = tpm2_parse_create_primary(chip, buf, handle, hierarchy,
-- 
2.47.3

