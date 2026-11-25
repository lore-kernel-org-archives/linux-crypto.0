Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630006;
	b=4ImV5An5qlvflZWTPmqd27E1swi9UxQc7oDMtsik+dnO/13zLSCI6ha+W8gOm6+uz/wP
	 xsWFp2Z5xkSZBkhskhOAOJtzeWbYJa9LX1fOayDVLzk8nfIB47q1o7kClbxrKmhngdYJo
	 Zsu3DZOtEoDXJkCORN/g0qzMeHpnqRnaNW0cXWnmEbHJw47VWIHSZXZlsFUR6tuULBriY
	 yq6ltX8yu30g5mHKK8LO0fRkNNu4SHmT7hCaHG80zjjP2HX0oEUR5mBtRSfn1LZ6D29Cm
	 5pqkabYcTu+/6yY6N4CfNi4LgXe6o5O1gzvfY/cbHjmHRx39TQRSjK/aEc7v/wgQ+Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uUpvOGYNFN9QNrznrG1lEyBJy5u3G08L4DNdjGeR9dE=;
	b=p5NiWPnz7wqFK/wLZymToVXAx8sInTejvYoN00Sk1MzQudhJ8wfb0VhCCpZ5VDdtfzI2
	 UVT4SG/UyVIY9z6xSmuA4o/xpAejp86fcpo16PMQD+nG+KnbnWtSZliOoRrm2SGRx65HR
	 tbNOTsbCu/STq2EsM8dRuCambOWr+QwEGFAXJyDTKaUVzOeLNIJ2ejIqDNy1/Dh6mP40v
	 1GF1AXWnQQPwvFRUfHmOrsF54vkF98+g05/b2iTLtossendeV7bp3xDu2+tpj1YvsrBKD
	 kggjjOkUQX8XLjIwSYcYhuAbXaYGUd1RVOeU2ceTi0DeHNwCGDvq1xAcPB8jSEW7gvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YxW23uMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CBFD1606A331;
	Wed, 25 Nov 2026 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YxW23uMR
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D6021F00AD3;
	Wed, 25 Nov 2026 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630006;
	bh=uUpvOGYNFN9QNrznrG1lEyBJy5u3G08L4DNdjGeR9dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxW23uMRLabiEdWMBEacwa8wcGWwpfrp2CaEcH7iKMarPePRdLhBHZ3SoViT3YtpE
	 pA1+zplBtP1N57AAXFenEg+rAEYCtvRySWXP55KrlhdntHEVjpSrSQWmW8fDFFxjyH
	 yWtF8IIpFlrWpxbLAfqyEOGXwvJBRVahX0motKMeaTvZMiUXy79idejkuab+XUk1Ap
	 VNbNTAZDiUgAGt94t6O1o0EdkIi5WanAM8GIxe2mYnPQ7vLeMTqa2x57JpdAIlimhV
	 HQLntTUInzSzD8GOs1ActnoulmLxf5DM2MK9MktpUOYseJakG7ul3AZVfgkgtoz5qr
	 2Vrs8kvaPVeMQ==
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
Subject: [PATCH v3 4/9] tpm: Export tpm2_create_primary()
Date: Wed, 25 Nov 2026 20:06:10 +0200
Message-ID: <20261125180616.1854753-5-jarkko@kernel.org>
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

Move tpm2_create_primary() outside CONFIG_TCG_TPM2_HMAC and export it for
callers such as trusted keys.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/Kconfig         |   2 +-
 drivers/char/tpm/tpm2-sessions.c | 103 ++++++++++++++++---------------
 include/linux/tpm.h              |   2 +
 3 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 35aff3003a32..7481f2c8c768 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -9,6 +9,7 @@ menuconfig TCG_TPM
 	imply SECURITYFS
 	select CRYPTO
 	select CRYPTO_HASH_INFO
+	select CRYPTO_LIB_SHA256
 	help
 	  If you have a TPM security chip in your system, which
 	  implements the Trusted Computing Group's specification,
@@ -32,7 +33,6 @@ config TCG_TPM2_HMAC
 	default n
 	select CRYPTO_ECDH
 	select CRYPTO_LIB_AESCFB
-	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_UTILS
 	help
 	  Setting this causes us to deploy a scheme which uses request
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 9608e545602c..b3b4f7a89d9d 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -421,9 +421,6 @@ EXPORT_SYMBOL_GPL(tpm_buf_append_hmac_session);
 
 #ifdef CONFIG_TCG_TPM2_HMAC
 
-static int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy,
-			       u32 *handle, u8 *name);
-
 /*
  * assume hash sha256 and nonces u, v of size SHA256_DIGEST_SIZE but
  * otherwise standard tpm2_KDFa.  Note output is in bytes not bits.
@@ -1077,6 +1074,50 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL(tpm2_start_auth_session);
 
+static int tpm2_create_null_primary(struct tpm_chip *chip)
+{
+	u32 null_key;
+	int rc;
+
+	rc = tpm2_create_primary(chip, TPM2_RH_NULL, &null_key,
+				 chip->null_key_name);
+
+	if (rc == TPM2_RC_SUCCESS) {
+		unsigned int offset = 0; /* dummy offset for null key context */
+
+		rc = tpm2_save_context(chip, null_key, chip->null_key_context,
+				       sizeof(chip->null_key_context), &offset);
+		tpm2_flush_context(chip, null_key);
+	}
+
+	return rc;
+}
+
+/**
+ * tpm2_sessions_init() - start of day initialization for the sessions code
+ * @chip: TPM chip
+ *
+ * Derive and context save the null primary and allocate memory in the
+ * struct tpm_chip for the authorizations.
+ *
+ * Return:
+ * * 0		- OK
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
+ */
+int tpm2_sessions_init(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm2_create_null_primary(chip);
+	if (rc) {
+		dev_err(&chip->dev, "null key creation failed with %d\n", rc);
+		return rc;
+	}
+
+	return rc;
+}
+#endif /* CONFIG_TCG_TPM2_HMAC */
 /*
  * A mask containing the object attributes for the kernel held null primary key
  * used in HMAC encryption. For more information on specific attributes look up
@@ -1199,12 +1240,16 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != EC_PT_SZ)
 		return -EINVAL;
+#ifdef CONFIG_TCG_TPM2_HMAC
 	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
+#endif
 	offset_t += val;
 	val = tpm_buf_read_u16(buf, &offset_t);
 	if (val != EC_PT_SZ)
 		return -EINVAL;
+#ifdef CONFIG_TCG_TPM2_HMAC
 	memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
+#endif
 	offset_t += val;
 
 	/* original length of the whole TPM2B */
@@ -1255,11 +1300,13 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	if (len != SHA256_DIGEST_SIZE + 2)
 		return -EINVAL;
 
+#ifdef CONFIG_TCG_TPM2_HMAC
 	if (memcmp(chip->null_key_name, &buf->data[offset_r],
 		   SHA256_DIGEST_SIZE + 2) != 0) {
 		dev_err(&chip->dev, "NULL Seed name comparison failed\n");
 		return -EINVAL;
 	}
+#endif
 
 	return 0;
 }
@@ -1284,8 +1331,8 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
  * * -errno	- A system error
  * * TPM_RC	- A TPM error
  */
-static int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy,
-			       u32 *handle, u8 *name)
+int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy, u32 *handle,
+			u8 *name)
 {
 	struct tpm_buf *template __free(kfree) = NULL;
 	struct tpm_buf *buf __free(kfree) = NULL;
@@ -1381,48 +1428,4 @@ static int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy,
 
 	return rc;
 }
-
-static int tpm2_create_null_primary(struct tpm_chip *chip)
-{
-	u32 null_key;
-	int rc;
-
-	rc = tpm2_create_primary(chip, TPM2_RH_NULL, &null_key,
-				 chip->null_key_name);
-
-	if (rc == TPM2_RC_SUCCESS) {
-		unsigned int offset = 0; /* dummy offset for null key context */
-
-		rc = tpm2_save_context(chip, null_key, chip->null_key_context,
-				       sizeof(chip->null_key_context), &offset);
-		tpm2_flush_context(chip, null_key);
-	}
-
-	return rc;
-}
-
-/**
- * tpm2_sessions_init() - start of day initialization for the sessions code
- * @chip: TPM chip
- *
- * Derive and context save the null primary and allocate memory in the
- * struct tpm_chip for the authorizations.
- *
- * Return:
- * * 0		- OK
- * * -errno	- A system error
- * * TPM_RC	- A TPM error
- */
-int tpm2_sessions_init(struct tpm_chip *chip)
-{
-	int rc;
-
-	rc = tpm2_create_null_primary(chip);
-	if (rc) {
-		dev_err(&chip->dev, "null key creation failed with %d\n", rc);
-		return rc;
-	}
-
-	return rc;
-}
-#endif /* CONFIG_TCG_TPM2_HMAC */
+EXPORT_SYMBOL_GPL(tpm2_create_primary);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 0f97abc82846..381af99dad31 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -255,6 +255,8 @@ extern int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
 extern struct tpm_chip *tpm_default_chip(void);
 void tpm2_flush_context(struct tpm_chip *chip, u32 handle);
 int tpm2_find_hash_alg(unsigned int crypto_id);
+int tpm2_create_primary(struct tpm_chip *chip, u32 hierarchy, u32 *handle,
+			u8 *name);
 
 static inline void tpm_buf_append_empty_auth(struct tpm_buf *buf, u32 handle)
 {
-- 
2.47.3

