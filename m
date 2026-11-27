Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759020;
	b=bO3Lr67izwgckssrbyzzQ23M87FWOUFZnRe46ht24KzIPRBSbiA06Ir220rLKguLL9wd
	 9VnV7VRDfgYOjYyGCO1AeliE5WNEeuS0Pidnt78za3h9U90UjTw2DDZdFQIcrKrdnBeA7
	 YhWF9+/BbZLescYmSHbuqR4QofIZWX93LVdJ9KZ3nfEnvsUABhcMGRaqmAl79EA+1p3iz
	 pEpw2rFAa6R5B7AzNkNWg5zifrqnG7SlQ3KGxP8M/PjxpjiwuG5izPn3C16Hz+R+N5xWG
	 H0jFW6NFWX6ag2ViSiWWLcUNGzsHVPROAIQpfzv8wgOSAZ6LNkCCCWhVtmS10tKFrVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Tvs2zLIZOpLGtd3xMqa9/o4Wk7Ypa5RCIXOxsiEf0MQ=;
	b=QISZ879zdNi1/hNNBVxv3hdrdmOCzVi/Zfzh/2RhhX7GFF4C533dD2jCPEQS0pMsB5Fm
	 WBa/2BWdvUtM1umKQcNDIFRN/7N2iQ14Lm37xQWBn8JJZCSLFDE94NJGwCnc0+ZlHO3ic
	 qUfiYfXYfJHW+rNtpiAtx2Or7C2768/hfNTbVxtZGK4l6cPneBEwCbHy4wnZAHR4rq+fi
	 OvAqA2/hyvF5pbRK5ob0Wn9xgo7E912VaMp3NPQULVksKdG7Z3iLZBKxXZQBDDokEg0vX
	 H4TprzggeStiRKM2cC9aB8wa+PrtBBDIihhYMvspnfiZlMRtvbSGDxGY8ODwBYLFdeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncN2QTi4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6D6BB606A31C;
	Fri, 27 Nov 2026 05:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncN2QTi4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 488651F000C1;
	Fri, 27 Nov 2026 05:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759020;
	bh=Tvs2zLIZOpLGtd3xMqa9/o4Wk7Ypa5RCIXOxsiEf0MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncN2QTi4vKl3TK9auxHiFxBttubEgN7+9lQ22wJwMs1hxAWM3oWZK56a1SL7sooDq
	 KUKZNXy0MqxKw/d5luRQsPHoPIKcgyBBWIx/G6TExLX1LojPTe6VsQuKthvjpY7ndu
	 sQL/UB4e1jf/TWHBlCR6/PNV0zF9MXU6KA03htRJi+rYLnxxHVBcEKra8H8gIML/h/
	 yM+70aOyQNwbmJMNMR70FG1Kh9I8Bsc0b9tGja0lbq6pOdZRdq4lEN9L1lncvaVu7z
	 7p1hs+zm3aQGsgpiHTW7X/0jqa+Tf1gEaZJG3rz8GR4uVdaIGq1oqpxaYxbHcYiiAt
	 gja4irPdKKXbw==
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
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v5 11/17] tpm: Add persistent hierarchies to tpm2_create_primary()
Date: Fri, 27 Nov 2026 07:55:56 +0200
Message-ID: <20261127055602.2357884-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127055602.2357884-1-jarkko@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
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
 drivers/char/tpm/tpm2-sessions.c | 191 ++++++++++++++++---------------
 1 file changed, 97 insertions(+), 94 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 4b827112be4d..40fbe6fde091 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1124,10 +1124,11 @@ int tpm2_sessions_init(struct tpm_chip *chip)
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
@@ -1157,21 +1158,23 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 {
 	struct tpm_header *head = (struct tpm_header *)buf->data;
 	off_t offset_r = TPM_HEADER_SIZE, offset_t;
-	u16 len = TPM_HEADER_SIZE;
+	u8 resp_name[TPM2_NULL_NAME_SIZE];
 	u32 total_len = be32_to_cpu(head->length);
 	u32 val32, param_len, keyhandle;
-	u16 val;
+#ifdef CONFIG_TCG_TPM2_HMAC
+	const u8 *ec_x, *ec_y;
+#endif
+	int rc = -EIO;
+	u16 val, len;
 
 	if (!tpm_buf_read_u32(buf, &offset_r, &keyhandle))
 		return -EIO;
 
-	if (handle)
-		*handle = keyhandle;
-	else
-		tpm2_flush_context(chip, keyhandle);
-
 	if (!tpm_buf_read_u32(buf, &offset_r, &param_len))
-		return -EIO;
+		goto err;
+	if (total_len < TPM_HEADER_SIZE + 8 ||
+	    param_len > total_len - TPM_HEADER_SIZE - 8)
+		goto err_inval;
 
 	/*
 	 * param_len doesn't include the header, but all the other
@@ -1180,185 +1183,185 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	 */
 	param_len += TPM_HEADER_SIZE;
 
-	if (param_len + 8 > total_len)
-		return -EINVAL;
-
 	if (!tpm_buf_read_u16(buf, &offset_r, &len))
-		return -EIO;
-
+		goto err;
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
+	if (offset_r > param_len || offset_r > tpm_buf_length(buf))
+		goto err_inval;
+
+	/*
+	 * Now we have the public area, compute the name of the object.
+	 */
+	put_unaligned_be16(TPM_ALG_SHA256, resp_name);
+	sha256(&buf->data[offset_t], len, resp_name + 2);
 
 	/* validate the public key */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
+		goto err;
 
 	/* key type (must be what we asked for) */
 	if (val != TPM_ALG_ECC)
-		return -EINVAL;
+		goto err_inval;
 
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
+		goto err;
 
 	/* name algorithm */
 	if (val != TPM_ALG_SHA256)
-		return -EINVAL;
+		goto err_inval;
 
 	if (!tpm_buf_read_u32(buf, &offset_t, &val32))
-		return -EIO;
+		goto err;
 
 	/* object properties */
 	if (val32 != TPM2_OA_NULL_KEY)
-		return -EINVAL;
+		goto err_inval;
 
 	/* auth policy (empty) */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != 0)
-		return -EINVAL;
+		goto err_inval;
 
 	/* symmetric key parameters */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM_ALG_AES)
-		return -EINVAL;
+		goto err_inval;
 
 	/* symmetric key length */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != AES_KEY_BITS)
-		return -EINVAL;
+		goto err_inval;
 
 	/* symmetric encryption scheme */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM_ALG_CFB)
-		return -EINVAL;
+		goto err_inval;
 
 	/* signing scheme */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM_ALG_NULL)
-		return -EINVAL;
+		goto err_inval;
 
 	/* ECC Curve */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM2_ECC_NIST_P256)
-		return -EINVAL;
+		goto err_inval;
 
 	/* KDF Scheme */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM_ALG_NULL)
-		return -EINVAL;
+		goto err_inval;
 
 	/* extract public key (x and y points) */
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
-	if (val != EC_PT_SZ)
-		return -EINVAL;
+		goto err;
+	if (val != EC_PT_SZ || offset_t + val > offset_r)
+		goto err_inval;
 #ifdef CONFIG_TCG_TPM2_HMAC
-	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
+	ec_x = &buf->data[offset_t];
 #endif
 	offset_t += val;
 
 	if (!tpm_buf_read_u16(buf, &offset_t, &val))
-		return -EIO;
-
-	if (val != EC_PT_SZ)
-		return -EINVAL;
+		goto err;
+	if (val != EC_PT_SZ || offset_t + val > offset_r)
+		goto err_inval;
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
+		goto err_inval;
 
 	/* creation data (skip) */
 	if (!tpm_buf_read_u16(buf, &offset_r, &len))
-		return -EIO;
-
+		goto err;
 	offset_r += len;
 	if (offset_r > param_len)
-		return -EINVAL;
+		goto err_inval;
 
 	/* creation digest (must be sha256) */
 	if (!tpm_buf_read_u16(buf, &offset_r, &len))
-		return -EIO;
-
+		goto err;
 	offset_r += len;
 	if (len != SHA256_DIGEST_SIZE || offset_r > param_len)
-		return -EINVAL;
+		goto err_inval;
 
 	/* TPMT_TK_CREATION follows */
 	/* tag, must be TPM_ST_CREATION (0x8021) */
 	if (!tpm_buf_read_u16(buf, &offset_r, &val))
-		return -EIO;
-
+		goto err;
 	if (val != TPM2_ST_CREATION || offset_r > param_len)
-		return -EINVAL;
+		goto err_inval;
 
 	/* hierarchy */
 	if (!tpm_buf_read_u32(buf, &offset_r, &val32))
-		return -EIO;
-
+		goto err;
 	if (val32 != hierarchy || offset_r > param_len)
-		return -EINVAL;
+		goto err_inval;
 
 	/* the ticket digest HMAC (might not be sha256) */
 	if (!tpm_buf_read_u16(buf, &offset_r, &len))
-		return -EIO;
-
+		goto err;
 	offset_r += len;
 	if (offset_r > param_len)
-		return -EINVAL;
+		goto err_inval;
 
 	/*
 	 * finally we have the name, which is a sha256 digest plus a 2
 	 * byte algorithm type
 	 */
 	if (!tpm_buf_read_u16(buf, &offset_r, &len))
-		return -EIO;
+		goto err;
+	if (offset_r + len != param_len + 8 || len != sizeof(resp_name))
+		goto err_inval;
+	if (offset_r + len > tpm_buf_length(buf))
+		goto err;
 
-	if (offset_r + len != param_len + 8)
-		return -EINVAL;
-	if (len != SHA256_DIGEST_SIZE + 2)
-		return -EINVAL;
+	if (memcmp(resp_name, &buf->data[offset_r], sizeof(resp_name)) != 0) {
+		dev_err(&chip->dev, "primary key name comparison failed\n");
+		goto err_inval;
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
+			goto err_inval;
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
+err_inval:
+	rc = -EINVAL;
+err:
+	tpm2_flush_context(chip, keyhandle);
+	return rc;
 }
 
 /**
@@ -1470,7 +1473,7 @@ int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy, u32 *handle,
 	tpm_buf_append_u32(buf, 0);
 
 	rc = tpm_transmit_cmd(chip, buf, 0,
-			      "attempting to create NULL primary");
+			      "attempting to create primary key");
 
 	if (rc == TPM2_RC_SUCCESS)
 		rc = tpm2_parse_create_primary(chip, buf, handle, hierarchy,
-- 
2.47.3

