Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758991;
	b=sSTMooJY+drgTRFGv3Py0TUIb72eum+66tER9WxnGKTC393xahSEc95SWD7xiLYstiMm
	 SH51y8vTz3ikTgdhBvqd9j7llgad3JtbQGQvPZvW+KoQ4LMCOiO+JUalwnSMvAtrs1FwV
	 +S6wfXlRgS5sZvB5MiK5D4ROBKKh5/xJ1HE1IBCf/wEHOv4r1mtsxNkuReqLABD78TSRx
	 qzq8m8bDLDx9FKYIQmTXuDTJ09BdA/MOYzZFMOiXc127PdIcDYrJqsDGHX3Oejb7aI8ad
	 o12B7UZGKcv3wa80E3aRudbACV1Y94GIdrd1D9DZfK+PLLpEgZtGHDcoMC6g1t4oFCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dfgO1RGrnv98J61ymk/ujJOkUWitq9+kj7YC0YWUmRQ=;
	b=jcLs04H0GoifodVVS1vM1p5v+Y3rMnN5W3V+LwLdtvBiw8+1zarCE6NrPV/Smd51MxT7
	 AldQjKCK46R2dGR2bbJKY7abzJ370V0MEnkIA+CD+m3/pIinUEil06xXNCmD63VsOTxrH
	 VNb7R5kMIXvs+e44QTwOPRGCXIkxRkzJpL6mfqyIJZwjzsnsxcrbgmdigbtJazXGPYc2t
	 aUOgj+/F4DET7botSiSfHmMo2+teLoodgRNEmf1HrZRHouiPk8YHuwXm1L6BNlozVSPFU
	 qwNzZ8oEmSY9a63SkU1Bjf5DDJFuIALnm8BS7ph5pdZcfYxuFKPM9X8thbVAvoxEuMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dp6VPuEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EE392606A31C;
	Fri, 27 Nov 2026 05:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dp6VPuEA
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 055CB1F00893;
	Fri, 27 Nov 2026 05:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758990;
	bh=dfgO1RGrnv98J61ymk/ujJOkUWitq9+kj7YC0YWUmRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dp6VPuEAsquEiLOPmBmYLBxegFaTHQBoI+/Seyvhw7sUrcTeNmkXwTdcWA3IEHBnp
	 ByMXQJtZXhnCu/Wbiav4bDzQnQDRu+Ag3b5ZFmhoxOASb3Lb0dtxcXh6o3Zv5+xbl3
	 uZwlAO9olRkR88JrFGYY3jhDg06+9otUmvpQVS7oek849nuEd4KIgYKJ2087eUN7oO
	 wz92vuefAXaYyCkGiuLk5V59IVu79lyh/BtLBBqA16U6q25M+h3BYqhO+c6FWIuuI9
	 XeYghYWpUHQBnJ3eiJ/5IyqxpRMm0dlT0frUS1B6DLcmh3YW54yz5K9mvLOUvEKcYH
	 J/nytgqSwLZ+w==
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
	Sumit Garg <sumit.garg@kernel.org>,
	Jonathan McDowell <noodles@earth.li>
Subject: [PATCH v5 04/17] KEYS: trusted: Open code tpm2_buf_append_auth()
Date: Fri, 27 Nov 2026 07:55:49 +0200
Message-ID: <20261127055602.2357884-5-jarkko@kernel.org>
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

tpm2_buf_append_auth() has a single call site and most of its parameters
are redundant. Open code it to the call site so that less cross-referencing
is required while browsing the source code.

Reviewed-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 40 ++++-------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 621f8ffba17e..2f7c8e571522 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -197,36 +197,6 @@ int tpm2_key_priv(void *context, size_t hdrlen,
 	return 0;
 }
 
-/**
- * tpm2_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
- *
- * @buf: an allocated tpm_buf instance
- * @session_handle: session handle
- * @nonce: the session nonce, may be NULL if not used
- * @nonce_len: the session nonce length, may be 0 if not used
- * @attributes: the session attributes
- * @hmac: the session HMAC or password, may be NULL if not used
- * @hmac_len: the session HMAC or password length, maybe 0 if not used
- */
-static void tpm2_buf_append_auth(struct tpm_buf *buf, u32 session_handle,
-				 const u8 *nonce, u16 nonce_len,
-				 u8 attributes,
-				 const u8 *hmac, u16 hmac_len)
-{
-	tpm_buf_append_u32(buf, 9 + nonce_len + hmac_len);
-	tpm_buf_append_u32(buf, session_handle);
-	tpm_buf_append_u16(buf, nonce_len);
-
-	if (nonce && nonce_len)
-		tpm_buf_append(buf, nonce, nonce_len);
-
-	tpm_buf_append_u8(buf, attributes);
-	tpm_buf_append_u16(buf, hmac_len);
-
-	if (hmac && hmac_len)
-		tpm_buf_append(buf, hmac, hmac_len);
-}
-
 /**
  * tpm2_seal_trusted() - seal the payload of a trusted key
  *
@@ -540,9 +510,13 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		 * could repeat our actions with the exfiltrated
 		 * password.
 		 */
-		tpm2_buf_append_auth(buf, private->policyhandle,
-				     NULL /* nonce */, 0, 0,
-				     private->blobauth, private->blobauth_len);
+		tpm_buf_append_u32(buf, 9 + private->blobauth_len);
+		tpm_buf_append_u32(buf, private->policyhandle);
+		tpm_buf_append_u16(buf, 0);
+		tpm_buf_append_u8(buf, 0);
+		tpm_buf_append_u16(buf, private->blobauth_len);
+		tpm_buf_append(buf, private->blobauth, private->blobauth_len);
+
 		if (tpm2_chip_auth(chip)) {
 			tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT,
 						    NULL, 0);
-- 
2.47.3

