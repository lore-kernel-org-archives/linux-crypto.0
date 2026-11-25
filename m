Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630011;
	b=TI2epHSocd2FHSPSdGUk5NmbkzbAkP+z2KDGdknGmiJZ37sc8RsgJL2754+KyzPiJxQz
	 6f7NyfVGxhH89JE2G7fTP81NCtiqNuxsFIGCtEDW+dG9q2Q5J8aoV7QNdtIDTH5jSk9+0
	 7xPGLcOxO4EhCODXOf/J4ALXapGfWF7YQ728u1IuekL+yeYawCwnDNFS+ugeuJ8T1fW5/
	 wFq7bbhutPjbDQU9JAImICWNJ+27vHrgGpXicFobUaOYIsMGWKSDxWgjd6KZwBUME3Z0V
	 64upmn8w0mrxgmskWgkwr6GeCnUVLCK1bHLXgD+M3eA7xBTIkpuovDcUQYcbX4mzGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nLyjKszxDxf0Z7d66Bl/V5iPNaKlz2X0D1ZETIU6Ae4=;
	b=R5Bd4MKhY45NCUR86SSXg4fkVoDm05VSMyqnPY2uKE+Z/I05MCgvNBRS2mWGFVtzjFNV
	 DJtAFB+0ACZEMzDzsBhJVJ5d4j7dk4seRimDWXgBb3+MGvZuRQzVhTfW3LQR4B+T+Hoic
	 VTKY940j+2RCjrR3HxToJEhgpFyyQgJdQ1LxPCOJ8ednkyrSzyo/8K7DsyVLf39ypcQCL
	 lWUmp8MzueHFHpW8py9OOgERivbsnXjL+DQ61JnXVK4Zg+g3NArWagYQMQt0od4YoT6Ia
	 +wx6QLZzB9oSytQTIZ4vLuvcmTXZ2f7EGoJ3LaiRTV+hucLkLbx245A3cE69sWS7GmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idouuzr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 735B3606A32D;
	Wed, 25 Nov 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idouuzr4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14DE11F000C0;
	Wed, 25 Nov 2026 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630010;
	bh=nLyjKszxDxf0Z7d66Bl/V5iPNaKlz2X0D1ZETIU6Ae4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idouuzr42qJJppqU+HVZ7qQOSIwnfMVobURVyiJcWozqdHzNewtEazfWCO5KLg6dw
	 7fDE17ZXkOu5Aoj5b6ssFeg3vBojNY1OlkfhJ1xkn53kzR9KA1YUosBe3lo+6XAfk7
	 TM5yZqW3Tjvk05JTlRJ6YLRyLaX7x1bKCGkdP7Nbco8RlwrxXqVhKr75zn/AsPNsAj
	 wZogvpsoX5c+WQduZL9WjZOSCC4Gi95C9D7/Td34NdsvG36jH7kZ/67ok3zrpVYgRE
	 SyZX/r8qd5CvN5QuXMZGt0a0F57U41EplRNxNWYdYJn0sCJToM7OO6Xu/Cm0AGbKN5
	 K9qXg4ROvT3AQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v3 5/9] tpm: Add persistent hierarchies to tpm2_create_primary()
Date: Wed, 25 Nov 2026 20:06:11 +0200
Message-ID: <20261125180616.1854753-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125180616.1854753-1-jarkko@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
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
 drivers/char/tpm/tpm2-sessions.c | 136 ++++++++++++++++++-------------
 1 file changed, 80 insertions(+), 56 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index b3b4f7a89d9d..23f086de1f5d 100644
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
@@ -1151,17 +1152,23 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 {
 	struct tpm_header *head = (struct tpm_header *)buf->data;
 	off_t offset_r = TPM_HEADER_SIZE, offset_t;
-	u16 len = TPM_HEADER_SIZE;
+	u8 resp_name[SHA256_DIGEST_SIZE + 2];
 	u32 total_len = be32_to_cpu(head->length);
 	u32 val, param_len, keyhandle;
+#ifdef CONFIG_TCG_TPM2_HMAC
+	const u8 *ec_x, *ec_y;
+#endif
+	u16 len;
 
 	keyhandle = tpm_buf_read_u32(buf, &offset_r);
-	if (handle)
-		*handle = keyhandle;
-	else
-		tpm2_flush_context(chip, keyhandle);
+	if (buf->flags & TPM_BUF_INVALID)
+		return -EINVAL;
 
 	param_len = tpm_buf_read_u32(buf, &offset_r);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    param_len > total_len - TPM_HEADER_SIZE - 8)
+		goto err;
+
 	/*
 	 * param_len doesn't include the header, but all the other
 	 * lengths and offsets do, so add it to parm len to make
@@ -1169,146 +1176,163 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	 */
 	param_len += TPM_HEADER_SIZE;
 
-	if (param_len + 8 > total_len)
-		return -EINVAL;
 	len = tpm_buf_read_u16(buf, &offset_r);
 	offset_t = offset_r;
-	if (offset_r + len > tpm_buf_length(buf))
-		return -EINVAL;
-	if (name) {
-		/*
-		 * now we have the public area, compute the name of
-		 * the object
-		 */
-		put_unaligned_be16(TPM_ALG_SHA256, name);
-		sha256(&buf->data[offset_r], len, name + 2);
-	}
+	offset_r += len;
+	if ((buf->flags & TPM_BUF_INVALID) || offset_r > param_len)
+		goto err;
+
+	/*
+	 * Now we have the public area, compute the name of the object.
+	 */
+	put_unaligned_be16(TPM_ALG_SHA256, resp_name);
+	sha256(&buf->data[offset_t], len, resp_name + 2);
 
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
-	if (val != EC_PT_SZ)
-		return -EINVAL;
+	if ((buf->flags & TPM_BUF_INVALID) || val != EC_PT_SZ ||
+	    offset_t + val > offset_r)
+		goto err;
 #ifdef CONFIG_TCG_TPM2_HMAC
-	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
+	ec_x = &buf->data[offset_t];
 #endif
 	offset_t += val;
 	val = tpm_buf_read_u16(buf, &offset_t);
-	if (val != EC_PT_SZ)
-		return -EINVAL;
+	if ((buf->flags & TPM_BUF_INVALID) || val != EC_PT_SZ ||
+	    offset_t + val > offset_r)
+		goto err;
 #ifdef CONFIG_TCG_TPM2_HMAC
-	memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
+	ec_y = &buf->data[offset_t];
 #endif
 	offset_t += val;
 
-	/* original length of the whole TPM2B */
-	offset_r += len;
-
 	/* should have exactly consumed the TPM2B public structure */
 	if (offset_t != offset_r)
-		return -EINVAL;
-	if (offset_r > param_len)
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
 	 * byte algorithm type
 	 */
 	len = tpm_buf_read_u16(buf, &offset_r);
-	if (offset_r + len != param_len + 8)
-		return -EINVAL;
-	if (len != SHA256_DIGEST_SIZE + 2)
-		return -EINVAL;
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    offset_r + len != param_len + 8 ||
+	    len != SHA256_DIGEST_SIZE + 2)
+		goto err;
+
+	if (memcmp(resp_name, &buf->data[offset_r], sizeof(resp_name)) != 0) {
+		dev_err(&chip->dev, "primary key name comparison failed\n");
+		goto err;
+	}
 
 #ifdef CONFIG_TCG_TPM2_HMAC
-	if (memcmp(chip->null_key_name, &buf->data[offset_r],
-		   SHA256_DIGEST_SIZE + 2) != 0) {
-		dev_err(&chip->dev, "NULL Seed name comparison failed\n");
-		return -EINVAL;
+	if (hierarchy == TPM2_RH_NULL) {
+		if (name == chip->null_key_name) {
+			memcpy(chip->null_ec_key_x, ec_x, EC_PT_SZ);
+			memcpy(chip->null_ec_key_y, ec_y, EC_PT_SZ);
+		} else if (memcmp(chip->null_key_name, resp_name,
+				  sizeof(resp_name)) != 0) {
+			dev_err(&chip->dev,
+				"NULL Seed name comparison failed\n");
+			goto err;
+		}
 	}
 #endif
 
+	if (name)
+		memcpy(name, resp_name, sizeof(resp_name));
+
+	if (handle)
+		*handle = keyhandle;
+	else
+		tpm2_flush_context(chip, keyhandle);
+
 	return 0;
+
+err:
+	tpm2_flush_context(chip, keyhandle);
+	return -EINVAL;
 }
 
 /**
@@ -1420,7 +1444,7 @@ int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy, u32 *handle,
 	tpm_buf_append_u32(buf, 0);
 
 	rc = tpm_transmit_cmd(chip, buf, 0,
-			      "attempting to create NULL primary");
+			      "attempting to create primary key");
 
 	if (rc == TPM2_RC_SUCCESS)
 		rc = tpm2_parse_create_primary(chip, buf, handle, hierarchy,
-- 
2.47.3

