Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793039689;
	b=v00ehj7z+gfLMRjbmJjePE8gFpHVW0yCIwgr1NiNCFRuIQHjZQ8JSung7dcmfkzCO315
	 6cvr99/AXLCjuQERcVS7kaWoW9xskX/Cr4GaN41j5HNdCiuwq3WnwWPB6Th4c31Dg398H
	 1rC6AUygcXuhZxf70YS20FcxwTYRDZpHlkWvOGPbQ5zTh+OCRj9TOM3kPqxLgZD8Y1jV8
	 mVVxrY5GToiVwrO/FD7k0COOsxSTRa2LTQJU2VOuYjk9KZE5dwN5DIZ9EYP4tfd10335b
	 YLT7nvB0rXjKD8TFg/empuzeg3CLsxUp4e/hgsS/xzSXylwZAPXWbWzqPEAahXDOq8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793039689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aGzG0QpAF2uTJsPe43SZB3cxZu6kZDSmRDiHhPcoLgE=;
	b=0Le2b94GEtW0mULptQfjwuP8ohmtdGdP0YfvWJ+ZKXqkZqvQKw5p0Dg2av9FpVGNCHQY
	 rVKp3cIU+4tBUi4iVrjfeMvst30wUOHEmvfAajS5jMVpQBvlQC3jiTDQSCEhxvPw0d/Pw
	 Dr9rQzkZGB/pigYv4GsQ6sk8CfujW58svlJeT6tSOUReTRZVPr6rird3TVr2REg5AvahP
	 9Y6sMy3v63eqxWF5agJsEPd4+gnUX314Ffkflmuecfp8bltMvacQ8OtYtvwayTGi/XvAa
	 2Qyo/nV3B530KKhg1itMQvQeY/iPETHDA/p08+Wnvoht1G3FexHCF2Fs+aPJmfnRE7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WYxKKJF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DC9606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WYxKKJF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793251F01825;
	Mon, 26 Oct 2026 18:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793039688;
	bh=aGzG0QpAF2uTJsPe43SZB3cxZu6kZDSmRDiHhPcoLgE=;
	h=From:To:Cc:Subject:Date;
	b=WYxKKJF+IK1ufCsKC5cBhDWGdGp8zUBUVquJB4KntguVzyswRwpalMZstbS02mviZ
	 JNt66aW7xE25Kly1OniazpSaDp9kJgham5uoAoyhnGSMnY+MHIxhuI7dj+2X0XcFUE
	 rmhMIrsyks4DIl3QGo8fTV+0B5plgmX1GNHzNVFfHjarJIlykhqNsOUxyHUwrOeMyW
	 B/JQ4fSFJTsqItRuE75zWGleMBfBVHoqbIMxOR82zIo2Xmr9nODEEGfremNs47BRMR
	 ZPJzpc+GLuNkjcfvAWoppPJ+woi5govtiuxXUNejsjnhLnrDvU7wyLETPsuda2BM9N
	 PM5DYHX+VUIWg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: stdrng - Mitigate FIPS RNG failures
Date: Mon, 26 Oct 2026 11:33:32 -0700
Message-ID: <20261026183332.11402-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This applies on top of
https://lore.kernel.org/linux-crypto/20261018204618.104876-1-ebiggers@kernel.org/

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

base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
prerequisite-patch-id: 4c318ab271fa6443e9fe0ac47537515cc2dc6999
prerequisite-patch-id: 5992995f4dea89d9332b0e33ca1248e3dd672bd8
prerequisite-patch-id: c38f29a49c34d0fdfdc8466fd64c3d69fb4f0626
prerequisite-patch-id: 424590a4282a04c94a095d4f059ac0d3a8af44b1
prerequisite-patch-id: b5e762e41f7f6a68e70f6540ab07ff2a23ae6880
prerequisite-patch-id: bc08a9f0be6e4f1e25c0e6ab0881f39df60aa632
prerequisite-patch-id: 487bd5a23a597d190e2794e178266fcb6fc92849
prerequisite-patch-id: 3c6f92ab77fee4702702f8760514a1bb55a409cb
prerequisite-patch-id: 1536028517d2aa0bcbc4ec601c18cd8cf5f7d0ad
prerequisite-patch-id: cb214555f3c44cf2a2e610adfbf60311a3647aa5
prerequisite-patch-id: cc0998aae8d75e7b09562f8623c132bc21e77a2b
prerequisite-patch-id: 351a1bcfe1ac87d42c5aa46b867f291aba49caa0
prerequisite-patch-id: f71bbeee6d6644ca1b464e22f4df891bab45680f
prerequisite-patch-id: 2f726ebd0df8d5a420cf4a870e0b6973248bf6be
-- 
2.56.0

