Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726283;
	b=B4/tdAs5UgJ0vdKOpntpX82yhGuCERbkBK1+b5AXurApfWd0gElBnRNsmTUpJlw3KTW2
	 Fo5wIvZMl2gHuV1xIsR/Rhz1kj7vJgqC+spT7HT/tBtcGGfD2wkD6rL/IWRbFz3dzamoJ
	 wxh+l6sC6KE0uusJso8ZOY64w29KmZKqTzFECpetBebEEvrY2CjEGsdARyqs7LFeBOUtQ
	 P8oirBiXT5tlXkq//1fLtX/19Sj3xYa49xXg/qYKg9TeN/u3KTWYiHA3DycQ5GuEuEatm
	 ReiqZkKokJU8tfuoHqNdBU+3Gouxxs/EmfgBAipQStXHAXfSuzTcM3pYpzvrfL9BjuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ovE10ecPuuG4Q9OyRtgv4d61+DAHAD6pr+MnShX2Rv0=;
	b=JnyAA2KB8cJK2hXdpEse2l4z39xKTy7XJx7OEj6RzHJOPi+UpLyU+yv2l6fRquz6ZnvI
	 +7j5IJIGBzVsuDwFmrQ0b/dvp5QucFHM8ujGeDslw3oW4/vPrOyPZiwTv+ycVsIbzlIBX
	 v+nb3DZLnkystl3dSKD5sXh+4FwKHf/Bls6a6K0PmNF24WJKNabOk7TzwE+9degtCmbzA
	 IZE5Y/9GJH/kFU1x6yLVxQ+BkoSzPtji5W0hUji4te+783D6lezKQsmDJS+p2XII2CcPM
	 WscLFED51GpONVia45LFEErnln0xc/yuA9K1sZoP1Dmi3klruR7FZq6g/FQ7U9XSlVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uk+x+z9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2D3C6606A321;
	Thu, 26 Nov 2026 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uk+x+z9P
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 15F461F000C1;
	Thu, 26 Nov 2026 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726282;
	bh=ovE10ecPuuG4Q9OyRtgv4d61+DAHAD6pr+MnShX2Rv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uk+x+z9PvG6Yd5h8MXLve74FONlG7+wrxZlv2yNVg3o7vBNuu1A/SK3B8OrHxebYW
	 bbQzabvRlKz0WM+gSbq28UkLY62+TfbVONQN/09t2ivONhkeKgynDAKoqdC+wChTJN
	 JNVlr9lK5YFUjUm6URoKHEyNOsukz59t9G5ekwSeCfTX6ccDiLk1czkgo4J5lRtOLJ
	 edQGarym0kG2792WvZzA9QswiVTEhTlvADHgn2WZ5R0sy6z17wkoc30BrT4CPMW+e/
	 ANraVjr/9pLu5fAtrdT47D5CzylLB4Zwr98bVquNCLd65wRGq25lrF927x16Hnl3FJ
	 7inhk/E+YWzCw==
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
Subject: [PATCH v4 10/11] KEYS: trusted: Factor out TPM2 blob loading
Date: Thu, 26 Nov 2026 22:50:20 +0200
Message-ID: <20261126205021.2200819-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126205021.2200819-1-jarkko@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
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
 security/keys/trusted-keys/trusted_tpm2.c | 207 ++++++++++++----------
 1 file changed, 114 insertions(+), 93 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 921d6fd9a024..231062fd17b6 100644
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
@@ -462,6 +469,68 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	return tpm_ret_to_err(rc);
 }
 
+static int tpm2_load_blob(struct tpm_chip *chip,
+			  struct trusted_key_tpm *private,
+			  const u8 *blob, unsigned int blob_len,
+			  u32 *blob_handle)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u8 parent_name[TPM2_NAME_SIZE];
+	bool created_parent = false;
+	u32 parent_handle;
+	int rc;
+
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &created_parent);
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
+	rc = tpm_buf_append_name(chip, buf, parent_handle,
+				 created_parent ? parent_name : NULL);
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
@@ -482,18 +551,15 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 {
 	u8 *blob_ref __free(kfree) = NULL;
 	struct trusted_key_tpm *private = options->private;
-	struct tpm_buf *buf __free(kfree) = NULL;
-	u8 parent_name[TPM2_NAME_SIZE];
-	bool created_parent = false;
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
@@ -507,6 +573,8 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	} else {
 		/* Bind for cleanup: */
 		blob_ref = blob;
+		if (!private->keyhandle)
+			private->keyhandle = parent;
 	}
 
 	/* new format carries keyhandle but old format doesn't */
@@ -544,56 +612,40 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
-			      parent_name, &created_parent);
-	if (rc)
-		return rc;
+	return tpm2_load_blob(chip, private, blob, blob_len, blob_handle);
+}
 
-	rc = tpm2_start_auth_session(chip);
-	if (rc)
-		goto out;
+static void tpm2_buf_append_key_auth(struct tpm_chip *chip,
+				     struct tpm_buf *buf,
+				     struct trusted_key_tpm *private,
+				     u8 hmac_attrs)
+{
+	struct tpm_header *head;
+	int offset;
 
-	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
-	if (!buf) {
-		tpm2_end_auth_session(chip);
-		rc = -ENOMEM;
-		goto out;
+	if (!private->policyhandle) {
+		tpm_buf_append_hmac_session(chip, buf, hmac_attrs,
+					    private->blobauth,
+					    private->blobauth_len);
+		return;
 	}
 
-	tpm_buf_init(buf, TPM_BUFSIZE);
-	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
-
-	rc = tpm_buf_append_name(chip, buf, parent_handle,
-				 created_parent ? parent_name : NULL);
-	if (rc)
-		goto out;
-
-	tpm_buf_append_hmac_session(chip, buf, 0, private->keyauth,
-				    TPM_DIGEST_SIZE);
-
-	tpm_buf_append(buf, blob, blob_len);
-
-	if (buf->flags & TPM_BUF_INVALID) {
-		tpm2_end_auth_session(chip);
-		rc = -E2BIG;
-		goto out;
+	/*
+	 * FIXME: The policy session was generated outside the kernel so we
+	 * don't know the nonce and thus can't calculate a HMAC on it.
+	 * Therefore, the user can only really use TPM2_PolicyPassword and we
+	 * must send down the plain text password, which could be intercepted.
+	 */
+	tpm2_buf_append_auth(buf, private->policyhandle, NULL, 0, 0,
+			     private->blobauth, private->blobauth_len);
+	if (tpm2_chip_auth(chip)) {
+		tpm_buf_append_hmac_session(chip, buf, hmac_attrs, NULL, 0);
+	} else {
+		offset = buf->handles * 4 + TPM_HEADER_SIZE;
+		head = (struct tpm_header *)buf->data;
+		if (tpm_buf_length(buf) == offset)
+			head->tag = cpu_to_be16(TPM2_ST_NO_SESSIONS);
 	}
-
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
-
-	return tpm_ret_to_err(rc);
 }
 
 /**
@@ -614,13 +666,10 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			   u32 blob_handle)
 {
 	struct trusted_key_tpm *private = options->private;
-	struct tpm_header *head;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	unsigned int data_len;
-	int offset;
 	u8 *data;
 	int rc;
-
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		return rc;
@@ -638,35 +687,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
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
-		tpm2_buf_append_auth(buf, private->policyhandle,
-				     NULL /* nonce */, 0, 0,
-				     private->blobauth, private->blobauth_len);
-		if (tpm2_chip_auth(chip)) {
-			tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT,
-						    NULL, 0);
-		} else  {
-			offset = buf->handles * 4 + TPM_HEADER_SIZE;
-			head = (struct tpm_header *)buf->data;
-			if (tpm_buf_length(buf) == offset)
-				head->tag = cpu_to_be16(TPM2_ST_NO_SESSIONS);
-		}
-	}
+	tpm2_buf_append_key_auth(chip, buf, private, TPM2_SA_ENCRYPT);
 
 	rc = tpm_buf_fill_hmac_session(chip, buf);
 	if (rc)
-- 
2.47.3

