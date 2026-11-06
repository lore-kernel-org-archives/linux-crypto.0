Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793993860;
	b=VBIumM8NTC3+twGThzRYPoqLoRLvC/GrXZl6dXwjtJQhcIUEk0LaP6qQpom/0XII8vsS
	 acR1iNbWPIcqmKqmC24s8n1dkG9rqWQDQ7CQ1rmwbCsnDzObVCOMqe7LHucgeNmeYCVH0
	 /0i5EX5/F40g82t/6EATzPa6eV6Phu+oy28otrTPMqMWKfyOnb0y3qOUX6V5uFGWqo2QV
	 /NIXhmySXktSKXUuesmV0m37t7TNjaf38lTsLs4zFK5ErVODHWgXWCqwNedmACkjDsonn
	 FvmtZFUL8LPs9h1FfxhdKT2FKv1QIMy6InCWfUITPc9c6CwZun58lXgeRAD1joQjLug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793993860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=txcVrWbZJNGQgIRFktLb+ZB5oOcdDRDT3vhkyLNTOGc=;
	b=KgOX9Rqh5cx8hW4et57E6ovR6aDZFI9K0si+MjpvhARGqM91LTBkwP24ZRay6b4RPIDC
	 KlVXBCv0V+hGWxaV+3oEFYGYxrU1KP2Wvhk6uSpMYQ5phmJUXP05MeBZmqKTFG2v9dqyn
	 DROluaYQeQWOTP2pT5WXN6CyQo0Rl+ZED6qCd4NDJbprpjsrSGYt7nx/zMQJELIol552q
	 5J4A/P43fCm77q7PiYaOGZEsVphskzlubaS9Cn9Qx/E+n8naKvCeRGg1J4ZAqPDXL2Sgl
	 Etn4uNW60vgadch8c5L4uA/4JJ7MUkoQ+Xy5B05QULXQReYlLJS2g4H5/iiSUO8xLkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtqSkDYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EADC606A329
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtqSkDYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAB91F0089F;
	Fri,  6 Nov 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793993860;
	bh=txcVrWbZJNGQgIRFktLb+ZB5oOcdDRDT3vhkyLNTOGc=;
	h=From:To:Cc:Subject:Date;
	b=DtqSkDYSQ2DInvoKasg9x675jEqPxEcPBFewszZVDMm1kaS8G8n94gj94/jG3zs+d
	 Iv/mb8wGJglfNx3f4vzGwwXTmlm9U6uzHadlvkX0vO43krzahkCQS8j9lC7+FXTikH
	 WpBR1O8zqyAmw8/zc3jCX3nX1+F1N0+njeLPNztDsElbFBQobRS67ddAv9NP1NWr/u
	 XUhQBkd7V4Or1pPAdCCVZ5VQrh6oNyQIMPjhaIfrAcXAHsQ2w/JkLoLE4UVrbw02KV
	 xMNnEumm7IDeG7Y5P1xkPCl6M3WMspkjwnY0BhIEyIRSyjRgE0ArPAe6wmmWOLBSgA
	 qK/HjG5Lws/7w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] crypto: stdrng - Mitigate FIPS RNG failures
Date: Fri,  6 Nov 2026 19:37:11 +0000
Message-ID: <20261106193711.3844890-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
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

If the kernel is booted with fips=1 and jitterentropy fails its health
check, crypto_stdrng_get_bytes() can return an error and leave its
output buffer uninitialized.

While the fallibility of the FIPS RNG is by design, leaving the output
buffer uninitialized lacks practical defense-in-depth, as callers can
forget to check the error code.  For example, the TPM2 driver didn't
check the error code from ECDH private key generation
(https://lore.kernel.org/r/20261025211119.138277-1-ebiggers@kernel.org/).
Thus, fips=1 mode (ironically) caused a vulnerability.

Mitigate such bugs by filling the buffer with get_random_bytes_wait() in
case of failure.  This helps in practice.  (For FIPS certifiability it
makes no difference, as no "approved" entropy is claimed on failure.)

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: Resending this because Sashiko failed to apply it earlier, despite
    my use of prerequisite-patch-id.  Its prerequisites are merged now,
    so Sashiko should review it now.  I also added Jarkko's Reviewed-by.
    This applies to cryptodev/master 82e91fe19fb8

 crypto/drbg.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index faa39045bdc6b..f3fed6ded5b5f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -561,10 +561,20 @@ int __crypto_stdrng_get_bytes(void *buf, size_t len)
 
 	err = crypto_get_default_rng();
 	if (err)
-		return err;
+		goto out;
 
 	err = crypto_drbg_get_bytes(crypto_default_rng, buf, len, NULL, 0);
 	crypto_put_default_rng();
+
+out:
+	/*
+	 * On failure, fill the buffer using the normal Linux RNG rather than
+	 * leave it uninitialized.  This provides practical defense-in-depth for
+	 * callers that forget to check the error code.  (It makes no difference
+	 * for FIPS certifications; no entropy is claimed on failure anyway.)
+	 */
+	if (err)
+		get_random_bytes_wait(buf, len);
 	return err;
 }
 EXPORT_SYMBOL_GPL(__crypto_stdrng_get_bytes);

base-commit: 82e91fe19fb838f235f7c8829afc1eb389c93bdf
-- 
2.56.0.455.g6c5a503b38-goog

