Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759003;
	b=Ae+61gUJpiVeR4n2JiZ1rWUzLLtnwEduVS7mzKMmI07aY0V2eD3YrZOyxeiIQFNdfAlE
	 MhnsQLeZLLnCBbgJSzOu4iVOSbT2Hv4nqyhb41hq4Mmljl5xiSK7d+XR+fOuKsd6X8h9P
	 mty8bgjlIQCzlwynAkbUybkx5fWJev0IHtUQ5PJRBXkEPDzayk72B+Ok1gB7WBKk2hzUF
	 iazXCftF0Lr3VdpMX7Qy95NMoVNwFXxx+XbMaF2bF0P5v/nqSxsBH/5uadOKJ3hxot3iP
	 GB+7dnzvMARrfHziFRMJ268Vs5NyOtOjNT9l+drmv6hK082chbG7bn8bBCZ4zyZITBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AtF2qzZ7rmkoXnzCfZofK9OEr6911X+e742q2Z3bW2A=;
	b=xF4jmknaScG5f7uYsDHwqMcm1ItIm4+WGgvy3edxbxynKkOPnDnEIk7rknVCsTxey70X
	 /bMb8h+EepWzlMgbdL6cNRop0CN1LInqJ+o1nkWHpteDZtcNHh+pHs4OVXNK9GqbkkzPw
	 ws9v2u+/ACDFVud17ZDJ/DzC8ljoXXi0ayDp2JhtiT7DhtH7/oa12rcxHEjsYvz+/K/IK
	 BV2+WjSq357+53rLn0r/NlfPjSzPrts4TnLcjtvP8BEH9Ai80qDOgFse9EyX+oEWqTgD6
	 vg44EEOG3jFOA48JELI3plmWfFa2p7wd1ZEPzow6pH+qfI3QGk582LGkLqykkxwjd+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8xCN6Nw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3BB93606A31C;
	Fri, 27 Nov 2026 05:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8xCN6Nw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4BCB1F00899;
	Fri, 27 Nov 2026 05:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759002;
	bh=AtF2qzZ7rmkoXnzCfZofK9OEr6911X+e742q2Z3bW2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8xCN6NwG+mDksjutVBFeXcuzUCUkkSqXLBc8YNi1Qy3c4L/dqxluRxiGCd6rvAEZ
	 h5YiY652muoXtNkjlwdAwML9BjeYt60R4s/8veoYFLVPbdszr1cKJcwm9E1WipjuC8
	 CERWrILyyMXBWw83mfQPPzPG+ltiZjESwAjdzFuiiYoPEfAlqKrTuZECueSn8/fZUj
	 vB2Z4x+Tpx+6wcWKy8piOSlgknjpOxgPdVzhSdAMyYhMF5BMJaBKDuxrLbbnYRmGL7
	 06jkpdRtawdpmWTPhviMlBwbi9/Tk+HB3Y/9rMFRP9AjHDHemt1nLT0oDDHBB/X849
	 2FbydJqJbN+FA==
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
Subject: [PATCH v5 07/17] tpm-buf: Make tpm_buf_read*() fallible
Date: Fri, 27 Nov 2026 07:55:52 +0200
Message-ID: <20261127055602.2357884-8-jarkko@kernel.org>
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

Make tpm_buf_read_u8(), tpm_buf_read_u16() and tpm_buf_read_u32() flows
unambiguous, and fallible by writing the updated offset to @offset.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm-buf.c                |  56 ++++---
 drivers/char/tpm/tpm2-sessions.c          | 188 ++++++++++++++++------
 include/linux/tpm_buf.h                   |   6 +-
 security/keys/trusted-keys/trusted_tpm2.c |  10 +-
 4 files changed, 178 insertions(+), 82 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 233e81d3f149..a2d79b3a9385 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -204,39 +204,35 @@ void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle)
  * @offset:	offset within the buffer
  * @count:	the number of bytes to read
  * @output:	the output buffer
+ *
+ * Return: true on success, and @offset is advanced by @count bytes, or false
+ * if the read would cross the end of the buffer.
  */
-static void tpm_buf_read(struct tpm_buf *buf, off_t *offset, size_t count, void *output)
+static bool tpm_buf_read(struct tpm_buf *buf, off_t *offset, size_t count, void *output)
 {
 	off_t next_offset;
 
-	if (buf->flags & TPM_BUF_INVALID)
-		return;
-
 	next_offset = *offset + count;
-	if (next_offset > buf->length) {
-		WARN(1, "tpm_buf: read out of boundary\n");
-		buf->flags |= TPM_BUF_INVALID;
-		return;
-	}
+	if (next_offset > buf->length)
+		return false;
 
 	memcpy(output, &buf->data[*offset], count);
 	*offset = next_offset;
+	return true;
 }
 
 /**
  * tpm_buf_read_u8() - Read 8-bit word from a TPM buffer
  * @buf:	&tpm_buf instance
  * @offset:	offset within the buffer
+ * @value:	returns the 8-bit word
  *
- * Return: next 8-bit word
+ * Return: true on success, and @offset is advanced, or false if the read
+ * would cross the end of the buffer.
  */
-u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset)
+bool tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset, u8 *value)
 {
-	u8 value = 0;
-
-	tpm_buf_read(buf, offset, sizeof(value), &value);
-
-	return value;
+	return tpm_buf_read(buf, offset, sizeof(*value), value);
 }
 EXPORT_SYMBOL_GPL(tpm_buf_read_u8);
 
@@ -244,16 +240,20 @@ EXPORT_SYMBOL_GPL(tpm_buf_read_u8);
  * tpm_buf_read_u16() - Read 16-bit word from a TPM buffer
  * @buf:	&tpm_buf instance
  * @offset:	offset within the buffer
+ * @value:	returns the 16-bit word
  *
- * Return: next 16-bit word
+ * Return: true on success, and @offset is advanced, or false if the read
+ * would cross the end of the buffer.
  */
-u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset)
+bool tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset, u16 *value)
 {
-	u16 value = 0;
+	__be16 value_be;
 
-	tpm_buf_read(buf, offset, sizeof(value), &value);
+	if (!tpm_buf_read(buf, offset, sizeof(value_be), &value_be))
+		return false;
 
-	return be16_to_cpu(value);
+	*value = be16_to_cpu(value_be);
+	return true;
 }
 EXPORT_SYMBOL_GPL(tpm_buf_read_u16);
 
@@ -261,16 +261,20 @@ EXPORT_SYMBOL_GPL(tpm_buf_read_u16);
  * tpm_buf_read_u32() - Read 32-bit word from a TPM buffer
  * @buf:	&tpm_buf instance
  * @offset:	offset within the buffer
+ * @value:	returns the 32-bit word
  *
- * Return: next 32-bit word
+ * Return: true on success, and @offset is advanced, or false if the read
+ * would cross the end of the buffer.
  */
-u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset)
+bool tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset, u32 *value)
 {
-	u32 value = 0;
+	__be32 value_be;
 
-	tpm_buf_read(buf, offset, sizeof(value), &value);
+	if (!tpm_buf_read(buf, offset, sizeof(value_be), &value_be))
+		return false;
 
-	return be32_to_cpu(value);
+	*value = be32_to_cpu(value_be);
+	return true;
 }
 EXPORT_SYMBOL_GPL(tpm_buf_read_u32);
 
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index fa107719b4f9..185bae525519 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -179,6 +179,7 @@ int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 	off_t offset = TPM_HEADER_SIZE;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	int rc, name_size_alg;
+	u16 size;
 
 	if (mso != TPM2_MSO_PERSISTENT && mso != TPM2_MSO_VOLATILE &&
 	    mso != TPM2_MSO_NVRAM) {
@@ -199,8 +200,10 @@ int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 		return tpm_ret_to_err(rc);
 
 	/* Skip TPMT_PUBLIC: */
-	rc = tpm_buf_read_u16(buf, &offset);
-	offset += rc;
+	if (!tpm_buf_read_u16(buf, &offset, &size))
+		return -EIO;
+
+	offset += size;
 
 	/*
 	 * Ensure space for the length field of TPM2B_NAME and hashAlg field of
@@ -209,18 +212,20 @@ int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 	if (offset + 4 > tpm_buf_length(buf))
 		return -EIO;
 
-	rc = tpm_buf_read_u16(buf, &offset);
+	if (!tpm_buf_read_u16(buf, &offset, &size))
+		return -EIO;
+
 	name_size_alg = name_size(&buf->data[offset]);
 	if (name_size_alg < 0)
 		return name_size_alg;
 
-	if (rc != name_size_alg)
+	if (size != name_size_alg)
 		return -EIO;
 
-	if (offset + rc > tpm_buf_length(buf))
+	if (offset + size > tpm_buf_length(buf))
 		return -EIO;
 
-	memcpy(name, &buf->data[offset], rc);
+	memcpy(name, &buf->data[offset], size);
 	return name_size_alg;
 }
 EXPORT_SYMBOL_GPL(tpm2_read_public);
@@ -618,21 +623,41 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 	handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
 	offset_s += handles * sizeof(u32);
 
-	val = tpm_buf_read_u32(buf, &offset_s);
+	if (!tpm_buf_read_u32(buf, &offset_s, &val)) {
+		ret = -EIO;
+		goto err;
+	}
+
 	/* point offset_p to the start of the parameters */
 	offset_p = offset_s + val;
 	for (i = 1; offset_s < offset_p; i++) {
-		u32 handle = tpm_buf_read_u32(buf, &offset_s);
+		u32 handle;
 		u16 len;
 		u8 a;
 
+		if (!tpm_buf_read_u32(buf, &offset_s, &handle)) {
+			ret = -EIO;
+			goto err;
+		}
+
 		/* nonce (already in auth) */
-		len = tpm_buf_read_u16(buf, &offset_s);
+		if (!tpm_buf_read_u16(buf, &offset_s, &len)) {
+			ret = -EIO;
+			goto err;
+		}
+
 		offset_s += len;
 
-		a = tpm_buf_read_u8(buf, &offset_s);
+		if (!tpm_buf_read_u8(buf, &offset_s, &a)) {
+			ret = -EIO;
+			goto err;
+		}
+
+		if (!tpm_buf_read_u16(buf, &offset_s, &len)) {
+			ret = -EIO;
+			goto err;
+		}
 
-		len = tpm_buf_read_u16(buf, &offset_s);
 		if (handle == auth->handle && auth->attrs == a) {
 			hmac = &buf->data[offset_s];
 			/*
@@ -665,7 +690,11 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 			  auth->tpm_nonce, AES_KEY_BYTES + AES_BLOCK_SIZE,
 			  auth->scratch);
 
-		len = tpm_buf_read_u16(buf, &offset_p);
+		if (!tpm_buf_read_u16(buf, &offset_p, &len)) {
+			ret = -EIO;
+			goto err;
+		}
+
 		aes_prepareenckey(&auth->aes_key, auth->scratch, AES_KEY_BYTES);
 		aescfb_encrypt(&auth->aes_key, &buf->data[offset_p],
 			       &buf->data[offset_p], len,
@@ -740,7 +769,10 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 	struct sha256_ctx sctx;
 	struct hmac_sha256_ctx hctx;
 	u16 tag = be16_to_cpu(head->tag);
-	int parm_len, len, i, handles;
+	u32 parm_len;
+	int i, handles;
+	u8 session_attrs;
+	u16 len;
 
 	if (!auth)
 		return rc;
@@ -770,26 +802,38 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 
 	/* point to area beyond handles */
 	offset_s = TPM_HEADER_SIZE + handles * 4;
-	parm_len = tpm_buf_read_u32(buf, &offset_s);
+	if (!tpm_buf_read_u32(buf, &offset_s, &parm_len))
+		goto out;
+
 	offset_p = offset_s;
 	offset_s += parm_len;
 	/* skip over any sessions before ours */
 	for (i = 0; i < auth->session - 1; i++) {
-		len = tpm_buf_read_u16(buf, &offset_s);
+		if (!tpm_buf_read_u16(buf, &offset_s, &len))
+			goto out;
+
 		offset_s += len + 1;
-		len = tpm_buf_read_u16(buf, &offset_s);
+		if (!tpm_buf_read_u16(buf, &offset_s, &len))
+			goto out;
+
 		offset_s += len;
 	}
 	/* TPM nonce */
-	len = tpm_buf_read_u16(buf, &offset_s);
+	if (!tpm_buf_read_u16(buf, &offset_s, &len))
+		goto out;
+
 	if (offset_s + len > tpm_buf_length(buf))
 		goto out;
 	if (len != SHA256_DIGEST_SIZE)
 		goto out;
 	memcpy(auth->tpm_nonce, &buf->data[offset_s], len);
 	offset_s += len;
-	attrs = tpm_buf_read_u8(buf, &offset_s);
-	len = tpm_buf_read_u16(buf, &offset_s);
+	if (!tpm_buf_read_u8(buf, &offset_s, &session_attrs))
+		goto out;
+
+	if (!tpm_buf_read_u16(buf, &offset_s, &len))
+		goto out;
+
 	if (offset_s + len != tpm_buf_length(buf))
 		goto out;
 	if (len != SHA256_DIGEST_SIZE)
@@ -831,8 +875,8 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 			  auth->our_nonce, AES_KEY_BYTES + AES_BLOCK_SIZE,
 			  auth->scratch);
 
-		len = tpm_buf_read_u16(buf, &offset_p);
-		if (offset_p + len > tpm_buf_length(buf)) {
+		if (!tpm_buf_read_u16(buf, &offset_p, &len) ||
+		    offset_p + len > tpm_buf_length(buf)) {
 			rc = -EINVAL;
 			goto out;
 		}
@@ -888,7 +932,7 @@ static int tpm2_parse_start_auth_session(struct tpm2_auth *auth,
 	struct tpm_header *head = (struct tpm_header *)buf->data;
 	u32 tot_len = be32_to_cpu(head->length);
 	off_t offset = TPM_HEADER_SIZE;
-	u32 val;
+	u16 val;
 
 	/* we're starting after the header so adjust the length */
 	tot_len -= TPM_HEADER_SIZE;
@@ -897,8 +941,12 @@ static int tpm2_parse_start_auth_session(struct tpm2_auth *auth,
 	if (tot_len != 4 + 2 + sizeof(auth->tpm_nonce))
 		return -EINVAL;
 
-	auth->handle = tpm_buf_read_u32(buf, &offset);
-	val = tpm_buf_read_u16(buf, &offset);
+	if (!tpm_buf_read_u32(buf, &offset, &auth->handle))
+		return -EIO;
+
+	if (!tpm_buf_read_u16(buf, &offset, &val))
+		return -EIO;
+
 	if (val != sizeof(auth->tpm_nonce))
 		return -EINVAL;
 	memcpy(auth->tpm_nonce, &buf->data[offset], sizeof(auth->tpm_nonce));
@@ -1070,15 +1118,20 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	off_t offset_r = TPM_HEADER_SIZE, offset_t;
 	u16 len = TPM_HEADER_SIZE;
 	u32 total_len = be32_to_cpu(head->length);
-	u32 val, param_len, keyhandle;
+	u32 val32, param_len, keyhandle;
+	u16 val;
+
+	if (!tpm_buf_read_u32(buf, &offset_r, &keyhandle))
+		return -EIO;
 
-	keyhandle = tpm_buf_read_u32(buf, &offset_r);
 	if (handle)
 		*handle = keyhandle;
 	else
 		tpm2_flush_context(chip, keyhandle);
 
-	param_len = tpm_buf_read_u32(buf, &offset_r);
+	if (!tpm_buf_read_u32(buf, &offset_r, &param_len))
+		return -EIO;
+
 	/*
 	 * param_len doesn't include the header, but all the other
 	 * lengths and offsets do, so add it to parm len to make
@@ -1088,7 +1141,10 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 
 	if (param_len + 8 > total_len)
 		return -EINVAL;
-	len = tpm_buf_read_u16(buf, &offset_r);
+
+	if (!tpm_buf_read_u16(buf, &offset_r, &len))
+		return -EIO;
+
 	offset_t = offset_r;
 	if (offset_r + len > tpm_buf_length(buf))
 		return -EINVAL;
@@ -1102,64 +1158,88 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	}
 
 	/* validate the public key */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
 
 	/* key type (must be what we asked for) */
 	if (val != TPM_ALG_ECC)
 		return -EINVAL;
-	val = tpm_buf_read_u16(buf, &offset_t);
+
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
 
 	/* name algorithm */
 	if (val != TPM_ALG_SHA256)
 		return -EINVAL;
-	val = tpm_buf_read_u32(buf, &offset_t);
+
+	if (!tpm_buf_read_u32(buf, &offset_t, &val32))
+		return -EIO;
 
 	/* object properties */
-	if (val != TPM2_OA_NULL_KEY)
+	if (val32 != TPM2_OA_NULL_KEY)
 		return -EINVAL;
 
 	/* auth policy (empty) */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != 0)
 		return -EINVAL;
 
 	/* symmetric key parameters */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != TPM_ALG_AES)
 		return -EINVAL;
 
 	/* symmetric key length */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != AES_KEY_BITS)
 		return -EINVAL;
 
 	/* symmetric encryption scheme */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != TPM_ALG_CFB)
 		return -EINVAL;
 
 	/* signing scheme */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != TPM_ALG_NULL)
 		return -EINVAL;
 
 	/* ECC Curve */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != TPM2_ECC_NIST_P256)
 		return -EINVAL;
 
 	/* KDF Scheme */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != TPM_ALG_NULL)
 		return -EINVAL;
 
 	/* extract public key (x and y points) */
-	val = tpm_buf_read_u16(buf, &offset_t);
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != EC_PT_SZ)
 		return -EINVAL;
 	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
 	offset_t += val;
-	val = tpm_buf_read_u16(buf, &offset_t);
+
+	if (!tpm_buf_read_u16(buf, &offset_t, &val))
+		return -EIO;
+
 	if (val != EC_PT_SZ)
 		return -EINVAL;
 	memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
@@ -1175,30 +1255,40 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 		return -EINVAL;
 
 	/* creation data (skip) */
-	len = tpm_buf_read_u16(buf, &offset_r);
+	if (!tpm_buf_read_u16(buf, &offset_r, &len))
+		return -EIO;
+
 	offset_r += len;
 	if (offset_r > param_len)
 		return -EINVAL;
 
 	/* creation digest (must be sha256) */
-	len = tpm_buf_read_u16(buf, &offset_r);
+	if (!tpm_buf_read_u16(buf, &offset_r, &len))
+		return -EIO;
+
 	offset_r += len;
 	if (len != SHA256_DIGEST_SIZE || offset_r > param_len)
 		return -EINVAL;
 
 	/* TPMT_TK_CREATION follows */
 	/* tag, must be TPM_ST_CREATION (0x8021) */
-	val = tpm_buf_read_u16(buf, &offset_r);
+	if (!tpm_buf_read_u16(buf, &offset_r, &val))
+		return -EIO;
+
 	if (val != TPM2_ST_CREATION || offset_r > param_len)
 		return -EINVAL;
 
 	/* hierarchy */
-	val = tpm_buf_read_u32(buf, &offset_r);
-	if (val != hierarchy || offset_r > param_len)
+	if (!tpm_buf_read_u32(buf, &offset_r, &val32))
+		return -EIO;
+
+	if (val32 != hierarchy || offset_r > param_len)
 		return -EINVAL;
 
 	/* the ticket digest HMAC (might not be sha256) */
-	len = tpm_buf_read_u16(buf, &offset_r);
+	if (!tpm_buf_read_u16(buf, &offset_r, &len))
+		return -EIO;
+
 	offset_r += len;
 	if (offset_r > param_len)
 		return -EINVAL;
@@ -1207,7 +1297,9 @@ static int tpm2_parse_create_primary(struct tpm_chip *chip, struct tpm_buf *buf,
 	 * finally we have the name, which is a sha256 digest plus a 2
 	 * byte algorithm type
 	 */
-	len = tpm_buf_read_u16(buf, &offset_r);
+	if (!tpm_buf_read_u16(buf, &offset_r, &len))
+		return -EIO;
+
 	if (offset_r + len != param_len + 8)
 		return -EINVAL;
 	if (len != SHA256_DIGEST_SIZE + 2)
diff --git a/include/linux/tpm_buf.h b/include/linux/tpm_buf.h
index f8c105d8b8bf..d0f4c1c3ee2d 100644
--- a/include/linux/tpm_buf.h
+++ b/include/linux/tpm_buf.h
@@ -52,9 +52,9 @@ void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length);
 void tpm_buf_append_u8(struct tpm_buf *buf, const u8 value);
 void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value);
 void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
-u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
-u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
-u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
+bool tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset, u8 *value);
+bool tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset, u16 *value);
+bool tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset, u32 *value);
 void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
 
 #endif
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 575b488a4f78..e20e54203b83 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -217,6 +217,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	struct tpm_buf *sized __free(kfree) = NULL;
 	u16 parent_name_size;
 	int blob_len = 0;
+	u32 size;
 	int hash;
 	u32 flags;
 	int rc;
@@ -323,18 +324,17 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		goto out;
 
-	blob_len = tpm_buf_read_u32(buf, &offset);
-	if (buf->flags & TPM_BUF_INVALID) {
-		rc = -E2BIG;
+	if (!tpm_buf_read_u32(buf, &offset, &size)) {
+		rc = -EIO;
 		goto out;
 	}
 
-	if (buf->length - offset < blob_len) {
+	if (buf->length - offset < size) {
 		rc = -EFAULT;
 		goto out;
 	}
 
-	blob_len = tpm2_key_encode(payload, options, &buf->data[offset], blob_len);
+	blob_len = tpm2_key_encode(payload, options, &buf->data[offset], size);
 	if (blob_len < 0)
 		rc = blob_len;
 
-- 
2.47.3

