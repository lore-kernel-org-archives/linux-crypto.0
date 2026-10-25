Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792962781;
	b=2dgTeIA4Q6C63Ar9R4vTtkt4hpSh7g/R5cUMNON8zrRXelL/aENMTBKHc7aozpCtlMYy
	 mVHl7kDXZcuC7Zb05AvXXPevk4FVPehsZmBb1lLsTGaq+WNjZtoK+5F2xcdcaDJh8Pk/c
	 F2H3xyn/mm9eJ2onyGsXsnUCwOudJUBGvld+7PpP7LFjk0R5+rub5WHlwC+zLgba942MG
	 8LnNA3f+81ZaRKbffCdH7SEU+11xh3tbl5wb9OyM3AfZurY0SU5rR0volzkFGiKJ6DXdL
	 AK5vJyWnLJIHYTpFT3w4je6nSrAbPOqAqRxsT8XPyc2u9lqxpChBbrONjis8nRn1mgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792962781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mUa32GQ7mZ4BJLOWdMWsKmD7PZePHSIH7PdJ14EI5oU=;
	b=GjeKWJUX/kFYDtWBhJ3NbgJxUrq3Pcwf0xqGfk8wwQlYjJqEf1aSWJqJmYSYO1OVL/52
	 xknk2/0liTc+50kUBC2qCLdludMXggAU+08W0AlmiwGykKfiYUqnyYeVhNtmyp+sU4SuO
	 ds5bd4psRwq4jpPKDr2toPQz7XaErdS6szrrdy6IL3rUlhS2rNlIRYgJSSat/4s5P+yoQ
	 KiRilrH2HKAur9ujddb+q3RRnKsJfGTudtIcrNDaIG7PmPNlBtWMDPBk2x4oyoaXoeo8b
	 Gz7oOW2Jn8Yy9PDEjjFR0JY0CjoBSiuM24v1B+R7knap+bj1WIFhERfZ7PEXuotIn+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jb6aORsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FEE606A31A;
	Sun, 25 Oct 2026 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jb6aORsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E9E1F01825;
	Sun, 25 Oct 2026 21:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792962780;
	bh=mUa32GQ7mZ4BJLOWdMWsKmD7PZePHSIH7PdJ14EI5oU=;
	h=From:To:Cc:Subject:Date;
	b=Jb6aORsxYZ44zg+/Mp6nXU0Kz8ZhlMJOQG+pKhcB+PIopid+GvmsHsYs8GB2KemRB
	 wbz1aKsli1WZuox23PgIsVktCg8utm0B0Rze8XIvrfxXIf+QuESPfbPHjmlBLOmwMW
	 7r+qas50cQzAws6tjOF0Byi1yCC0dcEdQoa7PwB+h8DmpxsSZ2qmEhJeA8OdPYMUVj
	 lgspy9e6zKNn8NURsuoVB2cL0VAqRrAryK3iyxKf7phcTtoVGP1ogr9thTFHxgzVtf
	 rGGJ6ee7hsFyF+bs22Fy8A/38HU5wTZwEJFP/jnrrEbRJYsOOs1Z8HLIX8TaqZmhmN
	 n7TpeEja51VhA==
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Date: Sun, 25 Oct 2026 14:11:19 -0700
Message-ID: <20261025211119.138277-1-ebiggers@kernel.org>
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

crypto_kpp_set_secret() can fail, for example if the kernel is booted
with fips=1 and the broken-by-design FIPS RNG used for ECC private key
generation doesn't feel like generating random bytes at the moment.
Check for error, cancelling the TPM session creation rather than
proceeding with a zero or uninitialized private key.

Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/char/tpm/tpm2-sessions.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index ca1e2bf424e14..2aaaad69760dc 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
 	}
 	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
 	/* this generates a random private key */
-	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	if (rc)
+		goto err_free_kpp;
 
 	/* salt is now the public point of this private key */
 	req = kpp_request_alloc(kpp, GFP_KERNEL);

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

