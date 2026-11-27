Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759037;
	b=t3+1qz0CqA4BfANT/Lo7NLq3tIQ7lV85+EPD8hqrcwgNTTYH2F0zQ1CtNjEwouAF6Q9a
	 a2lEDxiXeqs7ZqOYJeXszosafwQWouOmkfrM1E5tERawR1rHHtuMeH4rPowqAqFwiAonG
	 6Qd8UiVrjkNYN0OYC8gb/as8Wnx3xb6DWkhq2dS7AFts6s0kWK015xIxzntr1SY2sxD8D
	 lijLRgdPFYWBlAqjBu6I1/TWmObsBXFMER8Aj5b5Prp790noRdxmc/ZCVB52lQrrjSGof
	 sw/GtV6kcTG2IrBQLMslg/H4J2a5lMFoLIAu6qmpgfNUOTQ/qKa3xzodtyZVms8GtdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uWPcUqz5k/uge5a16jdanKc2GXuf5PeJatus/+YBask=;
	b=YQ62820dCROwNcJP5TQnnSt4QbeOUmQr34lqk8PmOXrMjYLtk7cw7+3WYjCn3HOf96Fb
	 cAx8iLUCVrJDy1fCtnonLSF/yuptP2P0l+iXTDfhU8QLyEDYPSxvfdL/MZv3wXbp7lL2M
	 uLaAw77I3aEMNsYKLgsbaKYt3O9CuqKLxA0PFw3vkoBX2JNtiqxK9J8uFUYKI0mbi8bE8
	 pQnloURbDsl+frLqmvs6fMil/Q1YEVwKqiC8KFpgytg3AwfyZ5jiw8jelF7+qJvpsewdq
	 w3Pt6p2o9+9h9G/bU0ig0Euf4L4G4PE24uYWRx04eTW1ESyjfA4Dl25PIc4H38hkOEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJYHjy4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C7180606A32E;
	Fri, 27 Nov 2026 05:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJYHjy4O
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 82DB21F0092A;
	Fri, 27 Nov 2026 05:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759037;
	bh=uWPcUqz5k/uge5a16jdanKc2GXuf5PeJatus/+YBask=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJYHjy4OEh+fN0d9HFUdrvdj208RBP59xHzYfJJ389YSmsvkKU0VuO8H2F0KlqF7p
	 Slj6vgvalR3JGHRSa+VvVEsUeKEXUOeubIwEt63q1LQp7cKmCEliCyLD7QS1sifRcQ
	 spQzbIvWcMo6Clw8VDVIhMSAOcUBgVQDv8WL82fzVnR6OwatVScBmv2JvKhNw0NLYY
	 cXm/Qr9wJIl2LtohpdMtr1ZQJ1ZfucSdUsYs6/7TXZMaheL2Rp7j6NAK+haoTnogRV
	 MA+BWe6s7haupRpbg7oM7gs2iet89J/i5zpXGEFa4kHtTwXRahPByHOJCBZrdGAtnL
	 tw4dzfm8ZX95A==
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
Subject: [PATCH v5 15/17] KEYS: trusted: Factor out TPM2 blob loading
Date: Fri, 27 Nov 2026 07:56:00 +0200
Message-ID: <20261127055602.2357884-16-jarkko@kernel.org>
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

Prepare for asymmetric TPM2 key operations, which reload the TPM key blob
and append key authorization on each pkey call, by factoring out common
helpers:

1. Decouple tpm2_key_decode() from struct trusted_key_options.
2. Factor out tpm2_load_blob() and tpm2_buf_append_key_auth() from
   tpm2_load_cmd() and tpm2_unseal_cmd().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 202 ++++++++++++----------
 1 file changed, 112 insertions(+), 90 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index a19ab2a62f65..467e8570b106 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -97,6 +97,7 @@ static int tpm2_key_encode(struct trusted_key_payload *payload,
 
 struct tpm2_key_context {
 	u32 parent;
+	enum OID oid;
 	const u8 *pub;
 	u32 pub_len;
 	const u8 *priv;
@@ -104,11 +105,11 @@ struct tpm2_key_context {
 	bool has_policy;
 };
 
-static int tpm2_key_decode(struct trusted_key_payload *payload,
-			   struct trusted_key_options *options,
-			   u8 **buf, unsigned int *blob_len)
+static int tpm2_key_decode(const struct trusted_key_payload *payload,
+			   const struct trusted_key_tpm *private,
+			   u32 *parent, u8 **buf, unsigned int *blob_len,
+			   enum OID *oid)
 {
-	struct trusted_key_tpm *private = options->private;
 	int ret;
 	struct tpm2_key_context ctx;
 	u8 *blob;
@@ -132,8 +133,10 @@ static int tpm2_key_decode(struct trusted_key_payload *payload,
 
 	*buf = blob;
 	*blob_len = ctx.priv_len + ctx.pub_len;
-	if (!private->keyhandle)
-		private->keyhandle = ctx.parent;
+	if (oid)
+		*oid = ctx.oid;
+	if (parent)
+		*parent = ctx.parent;
 
 	memcpy(blob, ctx.priv, ctx.priv_len);
 	blob += ctx.priv_len;
@@ -209,18 +212,22 @@ int tpm2_key_type(void *context, size_t hdrlen,
 		unsigned char tag,
 		const void *value, size_t vlen)
 {
+	struct tpm2_key_context *ctx = context;
 	enum OID oid = look_up_OID(value, vlen);
 
-	if (oid != OID_TPMSealedData) {
+	if (oid == OID_TPMSealedData) {
+		ctx->oid = oid;
+		return 0;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_KERNEL)) {
 		char buffer[50];
 
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
-		pr_debug("OID is \"%s\" which is not TPMSealedData\n",
-			 buffer);
-		return -EINVAL;
+		pr_debug("OID \"%s\" is not supported\n", buffer);
 	}
 
-	return 0;
+	return -EINVAL;
 }
 int tpm2_key_pub(void *context, size_t hdrlen,
 	       unsigned char tag,
@@ -441,6 +448,69 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	return tpm_ret_to_err(rc);
 }
 
+static int tpm2_load_blob(struct tpm_chip *chip,
+			  struct trusted_key_tpm *private,
+			  const u8 *blob, unsigned int blob_len,
+			  u32 *blob_handle)
+{
+	u8 parent_name[TPM2_MAX_NAME_SIZE];
+	struct tpm_buf *buf __free(kfree) = NULL;
+	bool created_parent = false;
+	u16 parent_name_size;
+	u32 parent_handle;
+	int rc;
+
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &parent_name_size, &created_parent);
+	if (rc)
+		return rc;
+
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf) {
+		tpm2_end_auth_session(chip);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
+
+	rc = tpm_buf_append_name(chip, buf, parent_handle, parent_name,
+				 parent_name_size);
+	if (rc)
+		goto out;
+
+	tpm_buf_append_hmac_session(chip, buf, 0, private->keyauth,
+				    TPM_DIGEST_SIZE);
+
+	tpm_buf_append(buf, blob, blob_len);
+
+	if (buf->flags & TPM_BUF_INVALID) {
+		tpm2_end_auth_session(chip);
+		rc = -E2BIG;
+		goto out;
+	}
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		goto out;
+
+	rc = tpm_transmit_cmd(chip, buf, 4, "loading blob");
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (!rc)
+		*blob_handle = get_unaligned_be32(&buf->data[TPM_HEADER_SIZE]);
+
+out:
+	if (created_parent)
+		tpm2_flush_context(chip, parent_handle);
+
+	return tpm_ret_to_err(rc);
+}
+
 /**
  * tpm2_load_cmd() - execute a TPM2_Load command
  *
@@ -461,19 +531,15 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 {
 	u8 *blob_ref __free(kfree) = NULL;
 	struct trusted_key_tpm *private = options->private;
-	u8 parent_name[TPM2_MAX_NAME_SIZE];
-	struct tpm_buf *buf __free(kfree) = NULL;
-	bool created_parent = false;
-	u16 parent_name_size;
 	unsigned int private_len;
 	unsigned int public_len;
 	unsigned int blob_len;
-	u32 parent_handle;
+	u32 parent = 0;
 	u8 *blob, *pub;
 	int rc;
 	u32 attrs;
 
-	rc = tpm2_key_decode(payload, options, &blob, &blob_len);
+	rc = tpm2_key_decode(payload, private, &parent, &blob, &blob_len, NULL);
 	if (rc) {
 		if (rc != -EBADMSG ||
 		    (payload->blob_len &&
@@ -487,6 +553,8 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	} else {
 		/* Bind for cleanup: */
 		blob_ref = blob;
+		if (!private->keyhandle)
+			private->keyhandle = parent;
 	}
 
 	/* new format carries keyhandle but old format doesn't */
@@ -524,56 +592,36 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
-			      parent_name, &parent_name_size, &created_parent);
-	if (rc)
-		return rc;
-
-	rc = tpm2_start_auth_session(chip);
-	if (rc)
-		goto out;
-
-	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
-	if (!buf) {
-		tpm2_end_auth_session(chip);
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	tpm_buf_init(buf, TPM_BUFSIZE);
-	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
-
-	rc = tpm_buf_append_name(chip, buf, parent_handle, parent_name,
-				 parent_name_size);
-	if (rc)
-		goto out;
-
-	tpm_buf_append_hmac_session(chip, buf, 0, private->keyauth,
-				    TPM_DIGEST_SIZE);
-
-	tpm_buf_append(buf, blob, blob_len);
+	return tpm2_load_blob(chip, private, blob, blob_len, blob_handle);
+}
 
-	if (buf->flags & TPM_BUF_INVALID) {
-		tpm2_end_auth_session(chip);
-		rc = -E2BIG;
-		goto out;
+static void tpm2_buf_append_key_auth(struct tpm_chip *chip,
+				     struct tpm_buf *buf,
+				     struct trusted_key_tpm *private,
+				     u8 hmac_attrs)
+{
+	if (!private->policyhandle) {
+		tpm_buf_append_hmac_session(chip, buf, hmac_attrs,
+					    private->blobauth,
+					    private->blobauth_len);
+		return;
 	}
 
-	rc = tpm_buf_fill_hmac_session(chip, buf);
-	if (rc)
-		goto out;
-
-	rc = tpm_transmit_cmd(chip, buf, 4, "loading blob");
-	rc = tpm_buf_check_hmac_response(chip, buf, rc);
-	if (!rc)
-		*blob_handle = be32_to_cpup(
-			(__be32 *)&buf->data[TPM_HEADER_SIZE]);
-
-out:
-	if (created_parent)
-		tpm2_flush_context(chip, parent_handle);
+	/*
+	 * FIXME: The policy session was generated outside the kernel so we
+	 * don't know the nonce and thus can't calculate a HMAC on it.
+	 * Therefore, the user can only really use TPM2_PolicyPassword and we
+	 * must send down the plain text password, which could be intercepted.
+	 */
+	tpm_buf_append_u32(buf, 9 + private->blobauth_len);
+	tpm_buf_append_u32(buf, private->policyhandle);
+	tpm_buf_append_u16(buf, 0);
+	tpm_buf_append_u8(buf, 0);
+	tpm_buf_append_u16(buf, private->blobauth_len);
+	tpm_buf_append(buf, private->blobauth, private->blobauth_len);
 
-	return tpm_ret_to_err(rc);
+	if (tpm2_chip_auth(chip))
+		tpm_buf_append_hmac_session(chip, buf, hmac_attrs, NULL, 0);
 }
 
 /**
@@ -625,33 +673,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	if (rc)
 		return rc;
 
-	if (!private->policyhandle) {
-		tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT,
-					    private->blobauth,
-					    private->blobauth_len);
-	} else {
-		/*
-		 * FIXME: The policy session was generated outside the
-		 * kernel so we don't known the nonce and thus can't
-		 * calculate a HMAC on it.  Therefore, the user can
-		 * only really use TPM2_PolicyPassword and we must
-		 * send down the plain text password, which could be
-		 * intercepted.  We can still encrypt the returned
-		 * key, but that's small comfort since the interposer
-		 * could repeat our actions with the exfiltrated
-		 * password.
-		 */
-		tpm_buf_append_u32(buf, 9 + private->blobauth_len);
-		tpm_buf_append_u32(buf, private->policyhandle);
-		tpm_buf_append_u16(buf, 0);
-		tpm_buf_append_u8(buf, 0);
-		tpm_buf_append_u16(buf, private->blobauth_len);
-		tpm_buf_append(buf, private->blobauth, private->blobauth_len);
-
-		if (tpm2_chip_auth(chip))
-			tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT,
-						    NULL, 0);
-	}
+	tpm2_buf_append_key_auth(chip, buf, private, TPM2_SA_ENCRYPT);
 
 	rc = tpm_buf_fill_hmac_session(chip, buf);
 	if (rc)
-- 
2.47.3

