Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488078;
	b=edoMdX1NJTzTAgYak58kRJZbJS2rcdiTYAfe10Cre6HNFDZWhUFB1zg5424hCaBhib5t
	 w/qjoArgRitndl2lT9bfaJV0HaruVC71ULpbu9YriM6aP1++T5Kbu2kKrrQ8bjyWPihaI
	 5ODj+0YgkXzOS7lMnhbFoUVqG6zsUPZXY1IryRC0muEW0EEvZpi2JHuwuVg1MG0BFdiyI
	 7Wl5JWl3oRke7yL8PsdJV10WxAfQ4Je5Dgm76b0n/RoTnEM7pYuv/GxV6cObBsLFZOE5a
	 dgwftq2iR/AeMSnj1P0KoNM5ihnIQ6wFx39/PvDR0JdPPKmCgQEh5Dp97aJSodEKwgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488078;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/XPKyRbOKLK9zGjWna3gyS6/643zwGnWsk8Z2UPxAjI=;
	b=n5ADIj1b+5OR5GK9Om16utuxil64bXfzvBaROViXIjgtK8Lsrn93dFiYV0DK4Hc5DKLN
	 q8wP3RwSO1RBhezlbW4d6RgXnbpk1jUd2cFxePPynFK/opW7wEuDcQ1Hlau/nXM8iFXQu
	 BewRDvrI7aeSwoTUYFOh3/q165YtyWUgF3JTH3Pe5/pqgVt5YaEyaYTjsAfgH0G+0Fb79
	 jbJC3wMkJy5+cscIxeX34zMENUGyzK288TCEYgTiykSkSCmOtiS+jrnRYY1X5wie1VUUv
	 2HxjmrbOxBMR36GKHWhL0bHtnS4dM6JC2+hY9GcOT4Emb70rtpJl5Y1UioPXVdXPKRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=PLiX7oeG;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACD5606A331
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EACD5606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=PLiX7oeG
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e47347279so2682448f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488076; x=1795092876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/XPKyRbOKLK9zGjWna3gyS6/643zwGnWsk8Z2UPxAjI=;
        b=PLiX7oeGP+94CxNjGSuuzIVQX5T/khDoKc/oXuUnbgsBe3x07lo/KneUHWm5bgY/8h
         T1HzHC3wWaxFg5IVE0zTZ3MmZ1MY7jC7n3rcvmS81w5ebBF8gymy1Ln3KffRYUuYmGO7
         Jyfp1160tZUG1ZvoaEBp3xKgqnwQppAB0qCgf5AuZwSDO5yNGzVOK5yLwHnc7OMe0ABo
         jUvPE7ySL7oasneKUrCo3eeb02bakKwDOuRYnbbscYweQrPRgJ0pyrq4UbbV4azotaYg
         8O4T5Yl/yn1hUSGfmjYphrLzIz2K5AzBCOJgJnANtoE1aP1odzOcY1aH0j6109J6D0+J
         gcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488076; x=1795092876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/XPKyRbOKLK9zGjWna3gyS6/643zwGnWsk8Z2UPxAjI=;
        b=dqs7Dm45hU8IDreG0VLdZ2qFm7Lsd6gmPrSwLeZqHXiXkEKVsQGZQb2hUiTFVw901v
         ZkgVps7Tg5tnMacIgfD6U5yQYveM4bPnWLD/RyKN/Rzf0py0T75ctiIYs1Gw4IK1kDuY
         gGZkRSKNlrpvXnm3M6jzRE8PgOfgPdcPhcnuqofeD6R91Sm8QWIzQ7jARSG7WLZXtpDA
         QUO/JDA7aRsei4y2r+qbqVmo/866updBEx8DddD+mC082Fbv724nhgFNrb6z+KEb/XjA
         ycjDbQ5suF8h8q4knR+/CvPyJG1Zl4mHVajhCj+LbkFEbH7R9LHbvHQc5lSe8pAy5xL3
         0LbA==
X-Gm-Message-State: APuU4Z9GPxeFHKlClpBtnA3Yp73yG36fmSOXof/4QDubsdt+7l5BIyHK
	gHgHRoIdFX/5z/MY2d5Am5defopggZp37XWYjJ30HiQ88uYC4wrE54euDMkxeYmE+L+Y9DotxcF
	5FQX7JZc08evjjCleRKaUH5AFsmg2qK/U9D1CQ5do1fvl+wNQP035PN7t+hoJVgWvFxr/6tW/
X-Gm-Gg: AYBFou17oclC+G1GQ8IFiU4KL944PbHqvwtdf2eK7iWXbAPnEbK/tNY3XXt8gX5EdZn
	TOVmfWYoQMvlAZqCP1oxXTtjLhMY60oWORTnWYR8zI5ESFfnq5xqB8YBau9WBLFT5E+9ylEcF3W
	QhdR2jT/PbBY5ouwjYm9CAce/mfkK0FkpYciumuxOmwtB4BbFvz1eYCo1EC2LMn3qUIg5hQY4aa
	BIXAZlM1YLfPRiVa1d/YccqjX7uwzyatifqMoz1iMOl67C3QI4lmXrnMaAhVe9ZmdIsJtzN9+dV
	atrjUZKYFSizXmECSURF1y5VwwEwYtmLaa51h0oyfrZ6aKtugKas3yR06QZpNISQZcpQSeEY4s3
	cBkA4ozSgrn+a3p9E/reDd+F4sPMjuOmqjF6EMr8IlcFyoYshjobx8Y294wEBpVj7PLtiF9qEKH
	U3IloQDzh7FAQga4R3VJ+BnFiHLQPhYmZj0ywkEfZ0EPjqbfVjBM9u3ZBAo/ZrW+kzdJjKy2PPC
	0EbPz7i4YxH3kUxyh3jswwPcxogEtudVItAbZ5DDUeti30RYC0IOPf02hKjgj9pVJ0ljU6jMB1j
	I+XytAQzrmtNLVGfEipXieMLwU6cVvwagaY7+lCZ2kr79zUlu2DFR4o7DZJXwcyuPTPTXTdYbbs
	=
X-Received: by 2002:a05:6000:2612:b0:48f:bbf3:cf52 with SMTP id ffacd0b85a97d-499c8f46e11mr9105197f8f.52.1794488076335;
        Thu, 12 Nov 2026 04:54:36 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:35 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 1/5] lib/crypto: tests: Make the AEAD dst clearing check effective
Date: Thu, 12 Nov 2026 13:54:26 +0100
Message-ID: <20261112125432.3064939-2-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
References: <20261112125432.3064939-1-antonio@openvpn.net>
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

From: Antonio Quartulli <antonio@mandelbit.com>

The basic validation test checks that decryption clears dst on
authentication failure, but its plaintext is all zeroes, so a
decryption that leaves the recovered plaintext in dst passes the check
too.  Use a random plaintext instead.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 lib/crypto/tests/aead-test-template.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/crypto/tests/aead-test-template.h b/lib/crypto/tests/aead-test-template.h
index 0c0138d2fa8a..894a927c6f39 100644
--- a/lib/crypto/tests/aead-test-template.h
+++ b/lib/crypto/tests/aead-test-template.h
@@ -257,6 +257,11 @@ aead_alloc_basic_validation_test_ctx(struct kunit *test)
 		alloc_buf(test, sizeof(*ctx));
 
 	memset(ctx, 0, sizeof(*ctx));
+	/*
+	 * Use a nonzero plaintext, so that the check that decryption clears
+	 * dst on authentication failure can actually fail.
+	 */
+	rand_bytes(ctx->pt, sizeof(ctx->pt));
 	ctx->raw_key_buf_end =
 		aead_alloc_random_data_guarded(test, AEAD_MAX_KEY_LEN) +
 		AEAD_MAX_KEY_LEN;
-- 
2.56.0

