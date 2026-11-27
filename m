Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759025;
	b=JIAbOdaAWbYMZjltjnBSgTaGB/0CAIZT1iCPvBRmqYjF1p8/Ma/WSmDU3L1YUz4c6rmS
	 XyPTdp2ys5yipSqfra/Ibd/LRijEqtcDl96u0v7gmdzWuC9z7sgTsSmDPyGHybLd7jMVj
	 q/FIaelW1WHDA8fJvtLH9QdLDd+vXXZtZJ+wSN7gM5ptefiAkOfJepoHhdL5V4fLRMoY7
	 ITsHOY2JFn49KcBz3xOc2jLkI/5DjMHuIH6Sd9b75/EhwBBkxjCrVTG8k5XuVf6Nhu0av
	 twKjclBUFJu+CsrUOzsqsa/e+kWzdaCyjUaph5kKRnHd6/sSGCf7UwOreEOX7SAEFqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=etqoy9yNsWp0CY30c7GHUtLFo53UMCQx5uvy0nrb7Zc=;
	b=yoAC2/lweT/59xjVw7GT/G73lWFKKzBOiEixe8iXOw53CcmyD69VS0lObc2IZSmgNICO
	 GfFsI/N29pbcJ+SpUUv8DI1PHWahKDF8RR4GVeMSvvqoq4FOBhIAnU1TX3WC8iNEFnghf
	 VIs2xqMfbZlOi+lN/BbMWXhizpQchc0O2qpAWDVUhOiRCRG8uDpMbPu5hO6gPkwo/V/oL
	 wf7GlAxKyqpYb5JLC0ZNnNYXOIKIW/g3raaEJv/D+dG6ZDHXeMBIF+f6OEFZTPCPf82B/
	 NZ3mGaje1xh3ZBBFMPNZwtj+acopvPiZ4eiKkI+sHqdPGWun2h7KcImt6VSUiHAtn0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Od3Nwdjm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2437A606A329;
	Fri, 27 Nov 2026 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Od3Nwdjm
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EF7A1F00927;
	Fri, 27 Nov 2026 05:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759024;
	bh=etqoy9yNsWp0CY30c7GHUtLFo53UMCQx5uvy0nrb7Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Od3NwdjmMc1Gar/nxkpoyb9TgREoeGQvlUnlxhFC03HAmJf4NY6xIS6m5OI4F5a4j
	 DHp5a0Y66XoBhD+hXfWDqBM1VL9g7XQ4defpNZWSkTc8/z/54LioniRZOPEjCROp1X
	 cPlQwqsY7ZImeh6sWAHAojh3hMbCodZx2qgiCus/81uRxO8jdUN2h3lj3g6ie4O2co
	 ll9lyOd+0oeqmDtbxvfnb3AUTBnKvE5d1RxS3lyvT4xqFuz32zz2YV8XYrTDa6OYJQ
	 ic53MsTm4IKhbqKCfpnkKqtUJuMiQUWhyKrj47YAHqhnL6oKbRC10MsM/QIJFn+Gs2
	 cppYV8UJSqB9A==
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
Subject: [PATCH v5 12/17] KEYS: trusted: Extend TPMKey support
Date: Fri, 27 Nov 2026 07:55:57 +0200
Message-ID: <20261127055602.2357884-13-jarkko@kernel.org>
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

Extend tpm2key.asn1 with the optional [1] policy, [2] secret, [3]
authPolicy, [4] description, and [5] rsaParent fields.

Create a temporary TCG H-2 NIST P-256 primary key in tpm2_seal_trusted()
and tpm2_load_cmd() when the parent handle is TPM2_RH_OWNER, TPM2_RH_NULL,
or TPM2_RH_PLATFORM.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 .../security/keys/trusted-encrypted.rst       |  18 ++-
 include/keys/trusted_tpm.h                    |   1 -
 include/linux/tpm_command.h                   |   2 +
 security/keys/trusted-keys/tpm2key.asn1       |  19 +++
 security/keys/trusted-keys/trusted_tpm2.c     | 150 +++++++++++++++---
 5 files changed, 161 insertions(+), 29 deletions(-)

diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index ddff7c7c2582..c6a507ef228a 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -561,6 +561,11 @@ policy::
     TPMKey ::= SEQUENCE {
         type		OBJECT IDENTIFIER
         emptyAuth	[0] EXPLICIT BOOLEAN OPTIONAL
+        policy		[1] EXPLICIT SEQUENCE OF TPMPolicy OPTIONAL
+        secret		[2] EXPLICIT OCTET STRING OPTIONAL
+        authPolicy	[3] EXPLICIT SEQUENCE OF TPMAuthPolicy OPTIONAL
+        description	[4] EXPLICIT UTF8String OPTIONAL
+        rsaParent	[5] EXPLICIT BOOLEAN OPTIONAL
         parent		INTEGER
         pubkey		OCTET STRING
         privkey		OCTET STRING
@@ -592,12 +597,13 @@ phrase.  This is used by most user space consumers to decide whether
 to prompt for a password.
 
 parent represents the parent key handle, either in the 0x81 MSO space,
-like 0x81000001 for the RSA primary storage key.  Userspace programmes
-also support specifying the primary handle in the 0x40 MSO space.  If
-this happens the Elliptic Curve variant of the primary key using the
-TCG defined template will be generated on the fly into a volatile
-object and used as the parent.  The current kernel code only supports
-the 0x81 MSO form.
+like 0x81000001 for a persistent primary storage key, or a hierarchy
+handle in the 0x40 MSO permanent handle space (TPM_RH_OWNER 0x40000001,
+TPM_RH_NULL 0x40000007, or TPM_RH_PLATFORM 0x4000000c).  When a 0x40
+MSO hierarchy handle is used without rsaParent, the Elliptic Curve
+variant of the primary key using the TCG defined H-2 NIST P-256 template
+is generated on the fly into a volatile object, used as the parent, and
+flushed afterwards.
 
 pubkey is the binary representation of TPM2B_PRIVATE excluding the
 initial TPM2B header, which can be reconstructed from the ASN.1 octet
diff --git a/include/keys/trusted_tpm.h b/include/keys/trusted_tpm.h
index 9a83269821e5..b8b1f5c8fbc3 100644
--- a/include/keys/trusted_tpm.h
+++ b/include/keys/trusted_tpm.h
@@ -26,5 +26,4 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options);
-
 #endif
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 9ea1ee3cbef1..6576a7df6d8c 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -259,8 +259,10 @@ enum tpm2_cc_attrs {
 };
 
 enum tpm2_permanent_handles {
+	TPM2_RH_OWNER		= 0x40000001,
 	TPM2_RH_NULL		= 0x40000007,
 	TPM2_RS_PW		= 0x40000009,
+	TPM2_RH_PLATFORM	= 0x4000000C,
 };
 
 /* Most Significant Octet for key types  */
diff --git a/security/keys/trusted-keys/tpm2key.asn1 b/security/keys/trusted-keys/tpm2key.asn1
index f57f869ad600..d15dfcf593a5 100644
--- a/security/keys/trusted-keys/tpm2key.asn1
+++ b/security/keys/trusted-keys/tpm2key.asn1
@@ -5,7 +5,26 @@
 TPMKey ::= SEQUENCE {
 	type		OBJECT IDENTIFIER ({tpm2_key_type}),
 	emptyAuth	[0] EXPLICIT BOOLEAN OPTIONAL,
+	policy		[1] EXPLICIT TPMPolicySequence OPTIONAL,
+	secret		[2] EXPLICIT OCTET STRING OPTIONAL ({tpm2_key_secret}),
+	authPolicy	[3] EXPLICIT TPMAuthPolicySequence OPTIONAL,
+	description	[4] EXPLICIT UTF8String OPTIONAL,
+	rsaParent	[5] EXPLICIT BOOLEAN OPTIONAL ({tpm2_key_rsa_parent}),
 	parent		INTEGER ({tpm2_key_parent}),
 	pubkey		OCTET STRING ({tpm2_key_pub}),
 	privkey		OCTET STRING ({tpm2_key_priv})
 	}
+
+TPMPolicySequence ::= SEQUENCE OF TPMPolicy ({tpm2_key_policy})
+
+TPMPolicy ::= SEQUENCE {
+	commandCode	[0] EXPLICIT INTEGER,
+	commandPolicy	[1] EXPLICIT OCTET STRING
+	}
+
+TPMAuthPolicySequence ::= SEQUENCE OF TPMAuthPolicy ({tpm2_key_auth_policy})
+
+TPMAuthPolicy ::= SEQUENCE {
+	name		[0] EXPLICIT UTF8String OPTIONAL,
+	policy		[1] EXPLICIT TPMPolicySequence
+	}
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 6b4cd07176cb..a19ab2a62f65 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -101,6 +101,7 @@ struct tpm2_key_context {
 	u32 pub_len;
 	const u8 *priv;
 	u32 priv_len;
+	bool has_policy;
 };
 
 static int tpm2_key_decode(struct trusted_key_payload *payload,
@@ -119,6 +120,9 @@ static int tpm2_key_decode(struct trusted_key_payload *payload,
 	if (ret < 0)
 		return ret;
 
+	if (ctx.has_policy && !private->policyhandle)
+		return -EOPNOTSUPP;
+
 	if (ctx.priv_len + ctx.pub_len > MAX_BLOB_SIZE)
 		return -EINVAL;
 
@@ -128,7 +132,8 @@ static int tpm2_key_decode(struct trusted_key_payload *payload,
 
 	*buf = blob;
 	*blob_len = ctx.priv_len + ctx.pub_len;
-	private->keyhandle = ctx.parent;
+	if (!private->keyhandle)
+		private->keyhandle = ctx.parent;
 
 	memcpy(blob, ctx.priv, ctx.priv_len);
 	blob += ctx.priv_len;
@@ -138,13 +143,58 @@ static int tpm2_key_decode(struct trusted_key_payload *payload,
 	return 0;
 }
 
+int tpm2_key_policy(void *context, size_t hdrlen,
+		    unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	struct tpm2_key_context *ctx = context;
+
+	ctx->has_policy = true;
+	return 0;
+}
+
+int tpm2_key_secret(void *context, size_t hdrlen,
+		    unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	return -EOPNOTSUPP;
+}
+
+int tpm2_key_auth_policy(void *context, size_t hdrlen,
+			 unsigned char tag,
+			 const void *value, size_t vlen)
+{
+	return -EOPNOTSUPP;
+}
+
+int tpm2_key_rsa_parent(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	const u8 *v = value;
+
+	if (vlen != 1)
+		return -EBADMSG;
+	if (*v)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 int tpm2_key_parent(void *context, size_t hdrlen,
 		  unsigned char tag,
 		  const void *value, size_t vlen)
 {
 	struct tpm2_key_context *ctx = context;
 	const u8 *v = value;
-	int i;
+	size_t i;
+
+	if (vlen > 1 && v[0] == 0) {
+		v++;
+		vlen--;
+	}
+	if (!vlen || vlen > sizeof(u32))
+		return -EBADMSG;
 
 	ctx->parent = 0;
 	for (i = 0; i < vlen; i++) {
@@ -172,7 +222,6 @@ int tpm2_key_type(void *context, size_t hdrlen,
 
 	return 0;
 }
-
 int tpm2_key_pub(void *context, size_t hdrlen,
 	       unsigned char tag,
 	       const void *value, size_t vlen)
@@ -197,6 +246,48 @@ int tpm2_key_priv(void *context, size_t hdrlen,
 	return 0;
 }
 
+/**
+ * tpm2_load_parent() - resolve a parent handle for TPM 2.0 child operations
+ *
+ * @chip: TPM chip to use
+ * @parent: persistent/volatile object handle or hierarchy handle
+ * @handle: returned usable parent handle
+ * @name: buffer populated with the parent handle name
+ * @name_size: returned byte length of @name
+ * @created: set to true if a temporary primary key was created and must be flushed
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+static int tpm2_load_parent(struct tpm_chip *chip, u32 parent, u32 *handle,
+			    u8 name[TPM2_MAX_NAME_SIZE], u16 *name_size,
+			    bool *created)
+{
+	int rc;
+
+	*created = false;
+	if (tpm2_handle_mso(parent) != TPM2_MSO_PERMANENT) {
+		*handle = parent;
+		rc = tpm2_read_public(chip, parent, name);
+		if (rc < 0)
+			return rc;
+		*name_size = rc;
+		return 0;
+	}
+
+	if (parent != TPM2_RH_OWNER &&
+	    parent != TPM2_RH_NULL &&
+	    parent != TPM2_RH_PLATFORM)
+		return -EINVAL;
+
+	rc = tpm2_create_primary(chip, parent, handle, name);
+	if (rc)
+		return tpm_ret_to_err(rc);
+
+	*name_size = TPM2_NULL_NAME_SIZE;
+	*created = true;
+	return 0;
+}
+
 /**
  * tpm2_seal_trusted() - seal the payload of a trusted key
  *
@@ -215,7 +306,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	off_t offset = TPM_HEADER_SIZE;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	struct tpm_buf *sized __free(kfree) = NULL;
+	bool created_parent = false;
 	u16 parent_name_size;
+	u32 parent_handle;
 	int blob_len = 0;
 	u32 size;
 	int hash;
@@ -233,21 +326,20 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		return rc;
 
-	rc = tpm2_read_public(chip, private->keyhandle, parent_name);
-	if (rc < 0)
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &parent_name_size, &created_parent);
+	if (rc)
 		goto out_put;
 
-	parent_name_size = rc;
-
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
-		goto out_put;
+		goto out_parent;
 
 	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (!buf) {
 		rc = -ENOMEM;
 		tpm2_end_auth_session(chip);
-		goto out_put;
+		goto out_parent;
 	}
 
 	tpm_buf_init(buf, TPM_BUFSIZE);
@@ -257,19 +349,18 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (!sized) {
 		rc = -ENOMEM;
 		tpm2_end_auth_session(chip);
-		goto out_put;
+		goto out_parent;
 	}
 
 	tpm_buf_init_sized(sized, TPM_BUFSIZE);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, parent_name,
+	rc = tpm_buf_append_name(chip, buf, parent_handle, parent_name,
 				 parent_name_size);
 	if (rc)
 		goto out;
 
 	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_DECRYPT,
 				    private->keyauth, TPM_DIGEST_SIZE);
-
 	/* sensitive */
 	tpm_buf_append_u16(sized, private->blobauth_len);
 
@@ -342,6 +433,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (!rc)
 		payload->blob_len = blob_len;
 
+out_parent:
+	if (created_parent)
+		tpm2_flush_context(chip, parent_handle);
 out_put:
 	tpm_put_ops(chip);
 	return tpm_ret_to_err(rc);
@@ -369,16 +463,23 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	struct trusted_key_tpm *private = options->private;
 	u8 parent_name[TPM2_MAX_NAME_SIZE];
 	struct tpm_buf *buf __free(kfree) = NULL;
+	bool created_parent = false;
 	u16 parent_name_size;
 	unsigned int private_len;
 	unsigned int public_len;
 	unsigned int blob_len;
+	u32 parent_handle;
 	u8 *blob, *pub;
 	int rc;
 	u32 attrs;
 
 	rc = tpm2_key_decode(payload, options, &blob, &blob_len);
 	if (rc) {
+		if (rc != -EBADMSG ||
+		    (payload->blob_len &&
+		     payload->blob[0] == (ASN1_CONS_BIT | ASN1_SEQ)))
+			return rc;
+
 		/* old form */
 		blob = payload->blob;
 		blob_len = payload->blob_len;
@@ -423,29 +524,29 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm2_read_public(chip, private->keyhandle, parent_name);
-	if (rc < 0)
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &parent_name_size, &created_parent);
+	if (rc)
 		return rc;
 
-	parent_name_size = rc;
-
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
-		return rc;
+		goto out;
 
 	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (!buf) {
 		tpm2_end_auth_session(chip);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	tpm_buf_init(buf, TPM_BUFSIZE);
 	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, parent_name,
+	rc = tpm_buf_append_name(chip, buf, parent_handle, parent_name,
 				 parent_name_size);
 	if (rc)
-		return rc;
+		goto out;
 
 	tpm_buf_append_hmac_session(chip, buf, 0, private->keyauth,
 				    TPM_DIGEST_SIZE);
@@ -454,12 +555,13 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 
 	if (buf->flags & TPM_BUF_INVALID) {
 		tpm2_end_auth_session(chip);
-		return -E2BIG;
+		rc = -E2BIG;
+		goto out;
 	}
 
 	rc = tpm_buf_fill_hmac_session(chip, buf);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = tpm_transmit_cmd(chip, buf, 4, "loading blob");
 	rc = tpm_buf_check_hmac_response(chip, buf, rc);
@@ -467,6 +569,10 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		*blob_handle = be32_to_cpup(
 			(__be32 *)&buf->data[TPM_HEADER_SIZE]);
 
+out:
+	if (created_parent)
+		tpm2_flush_context(chip, parent_handle);
+
 	return tpm_ret_to_err(rc);
 }
 
-- 
2.47.3

