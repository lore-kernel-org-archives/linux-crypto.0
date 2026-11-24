Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549291;
	b=oSXfwo2cbWe8xoe5jGhm0QkgCNCeuRaXdXnPNNjXGehHth1KjSw+OuM8X5afdCBO/EnK
	 dxxP+j1XquGVLVPtZ/dHJPiCSyycRd2PH0iJ28tZJs21G85OtwYgaS3310/pZ+AL5Woyl
	 YKsp9IZHR+lWOydEsYWd7K29wNpvq8K04kB7pn4gwB8JqjJHZqmx9OBPAci7neQUirdAl
	 AhvoFpcYYw8isbUHKGWfch2KLnW9cLZIYytCsEIQ3hSjN3uJUXEvbRjk1QKzEDF2Vltxy
	 89QMUqEuy40whnrBLUoakFuqPGvQsUeU/2n+aaIpC2Q9DIsn/V/2buXOf90QHQDKrzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PX3i3hH295kpPITkBNpPh3BYSu3sTmhYQoMN/a0axpA=;
	b=HqyxxAcGuHdxpfDuDG8WeAAfOCaOu/hH+HN48Ouq8z5mG3BPaGksaod0g6HWs7Uhea/V
	 7UM8WQc/Z6L6qMOokxqJq5C7RyarqPU8fhkuVXygDQX1YlKY6I3gaIxUULm5Zc+343j93
	 sk3iK5FmusCbECAdik+C54EsZpinePtfRad2p7Rk73WchTznZ5dObkRMHbZu7wyQVkZuP
	 rDP+HZF2bHfDmMCAZq8sW/tKjIwBlB4kVopDm0iyeUsQ728XqgRPFeRaqJGiAw5gktbNk
	 //1RLFk42WRgHGnESdtTxT6/7Dcx9PLhEDnC8v7Od523NZWZM/AbwpiswiAu/CYbovQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fD0eozic;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C40B4606A683;
	Tue, 24 Nov 2026 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fD0eozic
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AADB01F00A36;
	Tue, 24 Nov 2026 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795549291;
	bh=PX3i3hH295kpPITkBNpPh3BYSu3sTmhYQoMN/a0axpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fD0eozicQgCaqiae59PgJA+c7bcWWwjN0Jtj0Jdipn3nnyktnralLwjG3GXBOt/23
	 DqcA+NItY3hPEmsEecptvoenpwdKOg0rlmdAjcdveMgnLukDVk2ZOq0YM5VxEGbBng
	 NdY8bE0eticEic5dYQ413jyEgCv/MnCblD6RzXAnT6tLarP8t5J1KpGogCY5UV1QVs
	 4KcMnJSXBjtxTbtPeLI9aYu+3qWVGnUlVCnUheqdyuTXGftuz2GU6JO1vyWc9agwhi
	 II+olB2Lm+PTC+qgOH2jHwch1971QlN/IDihVcDri5IO/oURUfv2JB6kHMRw+/vZQh
	 LEqsGeWbFUiGw==
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
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
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
Subject: [PATCH v2 8/9] KEYS: trusted: Factor out TPM2 blob loading
Date: Tue, 24 Nov 2026 21:40:42 +0200
Message-ID: <20261124194043.1651679-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124194043.1651679-1-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
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

Factor out TPM2 blob loading:

1. tpm2_key_decode() from trusted_key_options.
2. tpm2_load_blob() and tpm2_buf_append_key_auth() from tpm2_load_cmd()
   and tpm2_unseal_cmd().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/keys/trusted-type.h               |   1 +
 security/keys/trusted-keys/trusted_core.c |  18 +-
 security/keys/trusted-keys/trusted_tpm2.c | 210 ++++++++++++----------
 3 files changed, 131 insertions(+), 98 deletions(-)

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 3db61b57cf73..790ffabb0d18 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -33,6 +33,7 @@ struct trusted_key_payload {
 	unsigned int blob_len;
 	unsigned char migratable;
 	unsigned char old_format;
+	void *private;
 	unsigned char key[MAX_KEY_SIZE + 1];
 	unsigned char blob[MAX_BLOB_SIZE];
 };
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 3721980ed83a..b8f980da606d 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -149,6 +149,14 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	return p;
 }
 
+static void trusted_payload_free(struct trusted_key_payload *p)
+{
+	if (!p)
+		return;
+	kfree_sensitive(p->private);
+	kfree_sensitive(p);
+}
+
 /*
  * trusted_instantiate - create a new trusted key
  *
@@ -223,7 +231,7 @@ static int trusted_instantiate(struct key *key,
 	if (!ret)
 		rcu_assign_keypointer(key, payload);
 	else
-		kfree_sensitive(payload);
+		trusted_payload_free(payload);
 	return ret;
 }
 
@@ -232,7 +240,7 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 	struct trusted_key_payload *p;
 
 	p = container_of(rcu, struct trusted_key_payload, rcu);
-	kfree_sensitive(p);
+	trusted_payload_free(p);
 }
 
 /*
@@ -269,7 +277,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = datablob_parse(&datablob, new_p);
 	if (ret != Opt_update) {
 		ret = -EINVAL;
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -283,7 +291,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = static_call(trusted_key_seal)(new_p, datablob);
 	if (ret < 0) {
 		pr_info("key_seal failed (%d)\n", ret);
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -322,7 +330,7 @@ static long trusted_read(const struct key *key, char *buffer,
  */
 static void trusted_destroy(struct key *key)
 {
-	kfree_sensitive(key->payload.data[0]);
+	trusted_payload_free(key->payload.data[0]);
 }
 
 struct key_type key_type_trusted = {
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 482b76d933fe..e3cd02e19857 100644
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
@@ -527,6 +595,9 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (private_len + 2 + public_len + 2 > blob_len)
 		return -E2BIG;
 
+	if (public_len < 8)
+		return -EINVAL;
+
 	pub = blob + 2 + private_len + 2;
 	/* key attributes are always at offset 4 */
 	attrs = get_unaligned_be32(pub + 4);
@@ -541,56 +612,40 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
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
@@ -611,13 +666,10 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			   u32 blob_handle)
 {
 	struct trusted_key_tpm *private = options->private;
-	struct tpm_header *head;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	u16 data_len;
-	int offset;
 	u8 *data;
 	int rc;
-
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		return rc;
@@ -635,35 +687,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
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

