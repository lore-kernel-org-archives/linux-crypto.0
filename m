Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758998;
	b=HUUooYIkNQhRxJnhsHtwUM3K5bUok3RxotbLAsZpOxLIOhsTgqbcGo3ymJnqQX/e8wWR
	 sHC2pcB4ya3A76t1cR+yHH6to7FVJnSlC2MU0hfnl7Kee+EIt7p7fs+wUl7aNvQ0auvVR
	 /M8D1iotySlB/gym4ih5G0hWz/y2jXXFGJM+QvH5ofn1QbshZRO6cSDRYZTw2TsY8mSln
	 QGJPE7MWvIcW/Yc3O/FpatvsMeKzf1ndq7eH+9pL99e5QNiLfZOP4ZyM93wQGqLa47Tar
	 jIpldYA8VTCPtuGiAc2dOICHlc/57RkZIvwH+Px7hweb2QJILPcqNd9+k4zewg7Luzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=X/IxXSPHyI5BomDwMgbK0BSrFRKLMzUE7IWClFzPgIk=;
	b=kpQRH3lM7kAtXGrJaPG0r++17ztOWvMH0q3UwdINupl2E0Qmdud7jNOUOqI7dYxCVEvk
	 huLHZYedha5rCDZY9rgC1Bd0yeso3bMwVhKQ3rZsC8MPxlU5OAkfN58q3ZpNEBqyLKV4i
	 q8g7WO26N78FAYpjuUNtWuz0AF5Px72cY1B3NoDxLLcQhBwgRS9Y5xqT1NH1j0W3V0PTu
	 jH6049nb+QtWaBxz5a/3oq9Dm2nhaVb3G8G7BE0vHHNsvBjRTBLZFMPYUJeityA1zXVCc
	 wKoqw1EoJUu90x0wxcnEE2gnootrY/FVJU/LLN7DJ+2igcBJNYRg18+UougniBhH9HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbXis3Dg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 837BB606A31E;
	Fri, 27 Nov 2026 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbXis3Dg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9931E1F00A15;
	Fri, 27 Nov 2026 05:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758998;
	bh=X/IxXSPHyI5BomDwMgbK0BSrFRKLMzUE7IWClFzPgIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbXis3Dg5kkiudP1r/nuVx4Bhwt7dqwHHntKI0HHalTmO6xiLlanoVCuJk8hrbo5h
	 NK1l51S5wDOEPjPArj/2SxrBtZgTcQs3qBpQsZzDZfVyEMcNdVO8u3T6VdvhKo/V+4
	 3qOQ32mDJYzXaFKzKnVem755WyG9OB6Q74sbEorSM5HnF0/XNOh/E/e0ncuJivrtSu
	 3fQJMdB4wWtEHHYzZo3lPIZ+zRYMda6fm8e4PEwXO4khEwItQknj9ow7dMS41Idcxr
	 HeCVKTsotiFbESgdCcssCsGKQt222n8vwNnpA6GU7U24lG7YCOXkc10ijG59Az2dbg
	 oAZtcosBr0zKQ==
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
Subject: [PATCH v5 06/17] tpm2-sessions: Re-orchestrate tpm2_read_public() use
Date: Fri, 27 Nov 2026 07:55:51 +0200
Message-ID: <20261127055602.2357884-7-jarkko@kernel.org>
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

Move TPM handle name resolution out of tpm_buf_append_name(), so that
callers resolve object names explicitly before constructing HMAC-protected
commands:

1. Export tpm2_read_public(), so that trusted_tpm2 can resolve handle
   names, and store non-object handles in big-endian byte order matching
   the TPM 2.0 handle Name definition.
2. Call tpm2_read_public() explicitly in tpm2_seal_trusted(),
   tpm2_load_cmd(), and tpm2_unseal_cmd() before starting the auth
   session, and pass the pre-resolved name and size to
   tpm_buf_append_name().
3. Rework tpm_buf_append_name() and tpm_buf_fill_hmac_session() to use
   the caller-supplied name and size directly.

This reduces fallible exits from tpm2_buf_append_name().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c               |   9 +-
 drivers/char/tpm/tpm2-sessions.c          | 122 +++++++---------------
 include/linux/tpm.h                       |  10 +-
 security/keys/trusted-keys/trusted_tpm2.c |  33 +++++-
 4 files changed, 84 insertions(+), 90 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index d58c306f7d93..c5b66f470287 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -194,11 +194,12 @@ int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
 
 	if (!disable_pcr_integrity) {
-		rc = tpm_buf_append_name(chip, buf, pcr_idx, NULL);
-		if (rc) {
-			tpm2_end_auth_session(chip);
+		__be32 pcr_idx_be = cpu_to_be32(pcr_idx);
+
+		rc = tpm_buf_append_name(chip, buf, pcr_idx,
+					 (u8 *)&pcr_idx_be, sizeof(pcr_idx_be));
+		if (rc)
 			return rc;
-		}
 		tpm_buf_append_hmac_session(chip, buf, 0, NULL, 0);
 	} else {
 		tpm_buf_append_handle(buf, pcr_idx);
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 94c11135beb3..fa107719b4f9 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -136,8 +136,8 @@ struct tpm2_auth {
 	 * handle, but they are part of the session by name, which
 	 * we must compute and remember
 	 */
-	u32 name_h[AUTH_MAX_NAMES];
 	u8 name[AUTH_MAX_NAMES][TPM2_MAX_NAME_SIZE];
+	u16 name_size_tbl[AUTH_MAX_NAMES];
 };
 
 #ifdef CONFIG_TCG_TPM2_HMAC
@@ -163,7 +163,17 @@ static int name_size(const u8 *name)
 	}
 }
 
-static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
+/**
+ * tpm2_read_public() - Resolve TPM name for a handle
+ * @chip:	TPM chip to use.
+ * @handle:	TPM handle.
+ * @name:	Buffer for returning the name blob. Must have a capacity of at
+ *		least %TPM2_MAX_NAME_SIZE bytes.
+ *
+ * Return: Size of the TPM handle name on success, or a negative errno when
+ * TPM2_ReadPublic fails.
+ */
+int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 {
 	u32 mso = tpm2_handle_mso(handle);
 	off_t offset = TPM_HEADER_SIZE;
@@ -172,7 +182,7 @@ static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 
 	if (mso != TPM2_MSO_PERSISTENT && mso != TPM2_MSO_VOLATILE &&
 	    mso != TPM2_MSO_NVRAM) {
-		memcpy(name, &handle, sizeof(u32));
+		put_unaligned_be32(handle, name);
 		return sizeof(u32);
 	}
 
@@ -189,7 +199,8 @@ static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 		return tpm_ret_to_err(rc);
 
 	/* Skip TPMT_PUBLIC: */
-	offset += tpm_buf_read_u16(buf, &offset);
+	rc = tpm_buf_read_u16(buf, &offset);
+	offset += rc;
 
 	/*
 	 * Ensure space for the length field of TPM2B_NAME and hashAlg field of
@@ -212,39 +223,34 @@ static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 	memcpy(name, &buf->data[offset], rc);
 	return name_size_alg;
 }
+EXPORT_SYMBOL_GPL(tpm2_read_public);
 #endif /* CONFIG_TCG_TPM2_HMAC */
 
 /**
- * tpm_buf_append_name() - add a handle area to the buffer
- * @chip: the TPM chip structure
- * @buf: The buffer to be appended
- * @handle: The handle to be appended
- * @name: The name of the handle (may be NULL)
+ * tpm_buf_append_name() - Append a handle and store TPM name
+ * @chip:	TPM chip to use.
+ * @buf:	TPM buffer containing the TPM command in-transit.
+ * @handle:	TPM handle to be appended.
+ * @name:	TPM name of the handle.
+ * @name_size:	Size of the TPM name.
  *
  * In order to compute session HMACs, we need to know the names of the
- * objects pointed to by the handles.  For most objects, this is simply
- * the actual 4 byte handle or an empty buf (in these cases @name
- * should be NULL) but for volatile objects, permanent objects and NV
- * areas, the name is defined as the hash (according to the name
- * algorithm which should be set to sha256) of the public area to
- * which the two byte algorithm id has been appended.  For these
- * objects, the @name pointer should point to this.  If a name is
- * required but @name is NULL, then TPM2_ReadPublic() will be called
- * on the handle to obtain the name.
+ * objects pointed to by the handles. For permanent and PCR handles this is
+ * the 4-byte big-endian handle; for volatile objects, persistent objects
+ * and NV areas this is the name resolved with tpm2_read_public().
  *
  * As with most tpm_buf operations, success is assumed because failure
  * will be caused by an incorrect programming model and indicated by a
  * kernel message.
  *
- * Ends the authorization session on failure.
+ * Return: 0 on success, or -EIO when the authorization area state is
+ * malformed.
  */
 int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
-			u32 handle, u8 *name)
+			u32 handle, u8 *name, u16 name_size)
 {
 #ifdef CONFIG_TCG_TPM2_HMAC
-	enum tpm2_mso_type mso = tpm2_handle_mso(handle);
 	struct tpm2_auth *auth;
-	u16 name_size_alg;
 	int slot;
 	int ret;
 #endif
@@ -263,45 +269,26 @@ int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
 	}
 	auth = chip->auth;
 	if (auth->session != tpm_buf_length(buf)) {
-		dev_err(&chip->dev, "session state malformed");
+		dev_err(&chip->dev, "session state malformed\n");
+		ret = -EIO;
+		goto err;
+	}
+	if (name_size > TPM2_MAX_NAME_SIZE) {
+		dev_err(&chip->dev, "name too long: %u\n", name_size);
 		ret = -EIO;
 		goto err;
 	}
 	tpm_buf_append_u32(buf, handle);
 	auth->session += 4;
-
-	if (mso == TPM2_MSO_PERSISTENT ||
-	    mso == TPM2_MSO_VOLATILE ||
-	    mso == TPM2_MSO_NVRAM) {
-		if (!name) {
-			ret = tpm2_read_public(chip, handle, auth->name[slot]);
-		} else {
-			ret = name_size(name);
-		}
-
-		if (ret < 0)
-			goto err;
-
-		name_size_alg = ret;
-	} else {
-		if (name) {
-			dev_err(&chip->dev, "handle 0x%08x does not use a name\n",
-				handle);
-			ret = -EIO;
-			goto err;
-		}
-	}
-
-	auth->name_h[slot] = handle;
-	if (name)
-		memcpy(auth->name[slot], name, name_size_alg);
+	memcpy(auth->name[slot], name, name_size);
+	auth->name_size_tbl[slot] = name_size;
 #endif
 	return 0;
 
 #ifdef CONFIG_TCG_TPM2_HMAC
 err:
 	tpm2_end_auth_session(chip);
-	return tpm_ret_to_err(ret);
+	return ret;
 #endif
 }
 EXPORT_SYMBOL_GPL(tpm_buf_append_name);
@@ -629,22 +616,8 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 	attrs = chip->cc_attrs_tbl[i];
 
 	handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
+	offset_s += handles * sizeof(u32);
 
-	/*
-	 * just check the names, it's easy to make mistakes.  This
-	 * would happen if someone added a handle via
-	 * tpm_buf_append_u32() instead of tpm_buf_append_name()
-	 */
-	for (i = 0; i < handles; i++) {
-		u32 handle = tpm_buf_read_u32(buf, &offset_s);
-
-		if (auth->name_h[i] != handle) {
-			dev_err(&chip->dev, "invalid handle 0x%08x\n", handle);
-			ret = -EIO;
-			goto err;
-		}
-	}
-	/* point offset_s to the start of the sessions */
 	val = tpm_buf_read_u32(buf, &offset_s);
 	/* point offset_p to the start of the parameters */
 	offset_p = offset_s + val;
@@ -705,23 +678,8 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 	/* ordinal is already BE */
 	sha256_update(&sctx, (u8 *)&head->ordinal, sizeof(head->ordinal));
 	/* add the handle names */
-	for (i = 0; i < handles; i++) {
-		enum tpm2_mso_type mso = tpm2_handle_mso(auth->name_h[i]);
-
-		if (mso == TPM2_MSO_PERSISTENT ||
-		    mso == TPM2_MSO_VOLATILE ||
-		    mso == TPM2_MSO_NVRAM) {
-			ret = name_size(auth->name[i]);
-			if (ret < 0)
-				goto err;
-
-			sha256_update(&sctx, auth->name[i], ret);
-		} else {
-			__be32 h = cpu_to_be32(auth->name_h[i]);
-
-			sha256_update(&sctx, (u8 *)&h, 4);
-		}
-	}
+	for (i = 0; i < handles; i++)
+		sha256_update(&sctx, auth->name[i], auth->name_size_tbl[i]);
 	if (offset_s != tpm_buf_length(buf))
 		sha256_update(&sctx, &buf->data[offset_s],
 			      tpm_buf_length(buf) - offset_s);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 2eb17e1ccd58..042f36600db1 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -301,7 +301,7 @@ static inline struct tpm2_auth *tpm2_chip_auth(struct tpm_chip *chip)
 }
 
 int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
-			u32 handle, u8 *name);
+			u32 handle, u8 *name, u16 name_size);
 void tpm_buf_append_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf,
 				 u8 attributes, u8 *passphrase,
 				 int passphraselen);
@@ -315,6 +315,7 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf);
 int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 				int rc);
 void tpm2_end_auth_session(struct tpm_chip *chip);
+int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name);
 #else
 #include <linux/unaligned.h>
 
@@ -338,6 +339,13 @@ static inline int tpm_buf_check_hmac_response(struct tpm_chip *chip,
 {
 	return rc;
 }
+
+static inline int tpm2_read_public(struct tpm_chip *chip, u32 handle,
+				   void *name)
+{
+	put_unaligned_be32(handle, name);
+	return sizeof(u32);
+}
 #endif	/* CONFIG_TCG_TPM2_HMAC */
 
 #endif
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 32d90a1f8357..575b488a4f78 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -211,9 +211,11 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_options *options)
 {
 	struct trusted_key_tpm *private = options->private;
+	u8 parent_name[TPM2_MAX_NAME_SIZE];
 	off_t offset = TPM_HEADER_SIZE;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	struct tpm_buf *sized __free(kfree) = NULL;
+	u16 parent_name_size;
 	int blob_len = 0;
 	int hash;
 	u32 flags;
@@ -230,6 +232,12 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		return rc;
 
+	rc = tpm2_read_public(chip, private->keyhandle, parent_name);
+	if (rc < 0)
+		goto out_put;
+
+	parent_name_size = rc;
+
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		goto out_put;
@@ -253,7 +261,8 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 
 	tpm_buf_init_sized(sized, TPM_BUFSIZE);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, NULL);
+	rc = tpm_buf_append_name(chip, buf, private->keyhandle, parent_name,
+				 parent_name_size);
 	if (rc)
 		goto out;
 
@@ -358,7 +367,9 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 {
 	u8 *blob_ref __free(kfree) = NULL;
 	struct trusted_key_tpm *private = options->private;
+	u8 parent_name[TPM2_MAX_NAME_SIZE];
 	struct tpm_buf *buf __free(kfree) = NULL;
+	u16 parent_name_size;
 	unsigned int private_len;
 	unsigned int public_len;
 	unsigned int blob_len;
@@ -412,6 +423,12 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
+	rc = tpm2_read_public(chip, private->keyhandle, parent_name);
+	if (rc < 0)
+		return rc;
+
+	parent_name_size = rc;
+
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		return rc;
@@ -425,7 +442,8 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	tpm_buf_init(buf, TPM_BUFSIZE);
 	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, NULL);
+	rc = tpm_buf_append_name(chip, buf, private->keyhandle, parent_name,
+				 parent_name_size);
 	if (rc)
 		return rc;
 
@@ -470,11 +488,19 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			   u32 blob_handle)
 {
 	struct trusted_key_tpm *private = options->private;
+	u8 blob_name[TPM2_MAX_NAME_SIZE];
 	struct tpm_buf *buf __free(kfree) = NULL;
+	u16 blob_name_size;
 	u16 data_len;
 	u8 *data;
 	int rc;
 
+	rc = tpm2_read_public(chip, blob_handle, blob_name);
+	if (rc < 0)
+		return rc;
+
+	blob_name_size = rc;
+
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		return rc;
@@ -488,7 +514,8 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	tpm_buf_init(buf, TPM_BUFSIZE);
 	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
 
-	rc = tpm_buf_append_name(chip, buf, blob_handle, NULL);
+	rc = tpm_buf_append_name(chip, buf, blob_handle, blob_name,
+				 blob_name_size);
 	if (rc)
 		return rc;
 
-- 
2.47.3

