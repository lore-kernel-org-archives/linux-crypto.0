Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726272;
	b=pqgIqa+l28CTCRsbJwcBDa+cj7+YHYKU/955x0zDjV8L8Yl7VRNsp+NTZtW9n8FVnO54
	 2TCtcaXJsBBeoDWnWQyJ/CAvypQjARTHYXQaBB1dPPSD17ohbmfLhFeSiSMZ0gDyGtF94
	 VBLsX7oFfL8j771ZYhd28KCBYQtI4dumMjAPKUX6Blrox9lpQOn0Hx1bXI1Cr5gk4Jjh0
	 UeQlbVapQtSpGeQNlR4y0N8+pLo55vakOaDKGWsUGNZSRTXymvhWaUel4XJraMEApddrJ
	 wh0HClkiP7hzI/EwtVWo70uscsMsMHzG1Q5Hwlv0Rt8XmWgDnjt31mFY9Cflyx3UvpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JjxdA+ICiOJ0Wg6CSzXiQhGpb64/Am7VOcn2gR5imiQ=;
	b=uYuXVv51H99aBSzIPTtWoAnhNxd+s3N0muv1Ho9Z4ThWAs/QdUFrlbuvgoO6Kxeab9Iq
	 y+7L9kdp60Men46XPDuBrdfv65GZ85w8emnnaom+YPs0N1+hJxPKSSjDQn3et/tg9wTad
	 sFXlLchkkHw7yI7pGASlmUNX80upxEomO2JmP8ocg8c5rcx6SckpOsIokqcmU83uqCGqh
	 +AdfzpQ2QqURdiHRv0H9z/Y6zmje55SvjUz+saS+9RFVJnYMJLL36aW2qfzEu1vF5r0ZY
	 sONv+lkhc53GqmplGDcNc1yw0BftaadW3oy1JCuu/SmsaOa2/ty05SvBQOxnv8Lorgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oB1duy3j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 14FAE606A31E;
	Thu, 26 Nov 2026 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oB1duy3j
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C83781F000C1;
	Thu, 26 Nov 2026 20:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726271;
	bh=JjxdA+ICiOJ0Wg6CSzXiQhGpb64/Am7VOcn2gR5imiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB1duy3js0VHn0A7nDui4WkLfmcEIpGMUnRxYv6e44OWkm9hV5v6InxTuhUO3k4tU
	 RikUci7rnPxspoodYGRDHlnEAhj2WG04oz1xwR3zAAXzlqR3qEZ376yLzSbZ7Ha29i
	 pwzyWNkNbATvAVLVLZOQI3dyJsQ/Sbyen1uScm29yVs1VkuQ6od1jYfugUsP8FelN+
	 uKeZHJvnXJekXoRg24PLlJar1tBSLkA3Sv/oP9iZPRvTtDCbICoMHpjOMQ4lvjrVxt
	 8fBWFR52XNQ1w0Y5OY+YoFzobND84wst4ELJffYF2kLtszKCkjx03bHSLPWkcZqeD2
	 Nm+Xa0Qs35wLA==
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
Subject: [PATCH v4 07/11] KEYS: trusted: Extend TPMKey support
Date: Thu, 26 Nov 2026 22:50:17 +0200
Message-ID: <20261126205021.2200819-8-jarkko@kernel.org>
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
 security/keys/trusted-keys/trusted_tpm2.c     | 142 ++++++++++++++++--
 5 files changed, 161 insertions(+), 21 deletions(-)

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
index d2c74ef8844b..921d6fd9a024 100644
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
@@ -197,6 +246,40 @@ int tpm2_key_priv(void *context, size_t hdrlen,
 	return 0;
 }
 
+/**
+ * tpm2_load_parent() - resolve a parent handle for TPM 2.0 child operations
+ *
+ * @chip: TPM chip to use
+ * @parent: persistent/volatile object handle or hierarchy handle
+ * @handle: returned usable parent handle
+ * @name: buffer populated with the primary key name when @created is true
+ * @created: set to true if a temporary primary key was created and must be flushed
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+static int tpm2_load_parent(struct tpm_chip *chip, u32 parent, u32 *handle,
+			    u8 name[TPM2_NAME_SIZE], bool *created)
+{
+	int rc;
+
+	*created = false;
+	if (tpm2_handle_mso(parent) != TPM2_MSO_PERMANENT) {
+		*handle = parent;
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
+	*created = true;
+	return 0;
+}
 /**
  * tpm2_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
  *
@@ -244,6 +327,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	off_t offset = TPM_HEADER_SIZE;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	struct tpm_buf *sized __free(kfree) = NULL;
+	u8 parent_name[TPM2_NAME_SIZE];
+	bool created_parent = false;
+	u32 parent_handle;
 	int blob_len = 0;
 	int hash;
 	u32 flags;
@@ -260,15 +346,20 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		return rc;
 
-	rc = tpm2_start_auth_session(chip);
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &created_parent);
 	if (rc)
 		goto out_put;
 
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out_parent;
+
 	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (!buf) {
 		rc = -ENOMEM;
 		tpm2_end_auth_session(chip);
-		goto out_put;
+		goto out_parent;
 	}
 
 	tpm_buf_init(buf, TPM_BUFSIZE);
@@ -278,18 +369,18 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (!sized) {
 		rc = -ENOMEM;
 		tpm2_end_auth_session(chip);
-		goto out_put;
+		goto out_parent;
 	}
 
 	tpm_buf_init_sized(sized, TPM_BUFSIZE);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, NULL);
+	rc = tpm_buf_append_name(chip, buf, parent_handle,
+				 created_parent ? parent_name : NULL);
 	if (rc)
 		goto out;
 
 	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_DECRYPT,
 				    private->keyauth, TPM_DIGEST_SIZE);
-
 	/* sensitive */
 	tpm_buf_append_u16(sized, private->blobauth_len);
 
@@ -363,6 +454,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (!rc)
 		payload->blob_len = blob_len;
 
+out_parent:
+	if (created_parent)
+		tpm2_flush_context(chip, parent_handle);
 out_put:
 	tpm_put_ops(chip);
 	return tpm_ret_to_err(rc);
@@ -389,15 +483,23 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	u8 *blob_ref __free(kfree) = NULL;
 	struct trusted_key_tpm *private = options->private;
 	struct tpm_buf *buf __free(kfree) = NULL;
+	u8 parent_name[TPM2_NAME_SIZE];
+	bool created_parent = false;
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
@@ -442,22 +544,29 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm2_start_auth_session(chip);
+	rc = tpm2_load_parent(chip, private->keyhandle, &parent_handle,
+			      parent_name, &created_parent);
 	if (rc)
 		return rc;
 
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out;
+
 	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (!buf) {
 		tpm2_end_auth_session(chip);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	tpm_buf_init(buf, TPM_BUFSIZE);
 	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
 
-	rc = tpm_buf_append_name(chip, buf, private->keyhandle, NULL);
+	rc = tpm_buf_append_name(chip, buf, parent_handle,
+				 created_parent ? parent_name : NULL);
 	if (rc)
-		return rc;
+		goto out;
 
 	tpm_buf_append_hmac_session(chip, buf, 0, private->keyauth,
 				    TPM_DIGEST_SIZE);
@@ -466,12 +575,13 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 
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
@@ -479,6 +589,10 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
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

