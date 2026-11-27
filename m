Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758978;
	b=NYBt9pu0LXICgRAOXK9J/GhKWd2Oc8v15BO9fjxdH8++CTBHRlviRHglGvMGuRyeBW9w
	 GKMQ0WV34vyNjnF2NRXaqIv1qnAg6I9doFxsnxShefhNBXAa90cgEIBRVOGCyuIxvvW6W
	 kc7AOqPgfUC6aRNIVH2CWgq1gPb7bQcgXlzwrCo9gr1xxtLxQmqiF7CV9hNU8lCJplm23
	 MUTZZiygjJPJkGKw1JDr+0yuuQPt2z2nBCDA9GRp1KIAZKPIzFaZKqsw3SQPzAWrvuL+T
	 ef+bUvp0U0NABP+npnG5zfbNnqSs4T+fPBdf76KE0Y8eymn7TMkdRpAfxwCG/BeIybQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zznQ3eIIt4MXzH550xMn/VqtHsMWKy2RUWA2dY4XBXs=;
	b=Aqnv0LtWE2qxwgRGHtzrMQM8w1hNWZhKRJkHfsPH6NAMxcUBu0uBAJZLpXSKi8DCz2gV
	 hoCQKfqdEKgNItQPs+jAQ+YwwWbEy6lWAvPbDs7Cegf9frH6QpNPzjWDrMSvDUlzp7iJu
	 9nDV9cjIsDUidpTdh3g5oB/X5bF/M2KlOA8VZboyxdZMZPT/CK8QB17QQbjWnI7MUpuTF
	 0GVuoi2RIDp3MvPAfqqT/m+0xAqCeLBO5oyDckDZO0PdtCtiyzNlygXhh4G1SriPM92nm
	 DKMpDmbUqzV3VkutFmQIRbo/2DSGEBYEG2OZrpYAhuq7RoTHMDwt+AQPL2mHFXjkLDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzS4f7NL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 55C93606A31C;
	Fri, 27 Nov 2026 05:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzS4f7NL
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F48A1F00897;
	Fri, 27 Nov 2026 05:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758978;
	bh=zznQ3eIIt4MXzH550xMn/VqtHsMWKy2RUWA2dY4XBXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzS4f7NLY2T+Lu6Om1nql1IaxKijTMk4hPoXXvRSfVBxos0n4wIEd9rLsGBqOtw9k
	 rE7WkQKKL8VQsnJhL9A1Dsuu7sAdrd8Ce11mU7j6r3ZJx3F96ANj+th4WUYytDsTFz
	 T1do5deH7VpWY9kZ3mavc3br1PAhEQaATCllalbi4bYgs5thydeAkItJ4HjY4JRdzB
	 zdTwsP3n1ol5CqYAo7qsGmgLI941sLHFhsgdNoCKr7HJddT9fwdc3jB5eiMXqj2sGT
	 /EVMo2wcXpCEYLbkSyHgIOSRcIGFDuYZ17wCVKTsCSb6AQPZyV15jWBjOdlWq4CuA1
	 byaA25/O7CBxQ==
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
	stable@vger.kernel.org
Subject: [PATCH v5 01/17] KEYS: trusted: Validate public_len before reading key attributes
Date: Fri, 27 Nov 2026 07:55:46 +0200
Message-ID: <20261127055602.2357884-2-jarkko@kernel.org>
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

tpm2_load_cmd() reads the 32-bit objectAttributes field at pub + 4
without checking that public_len is at least 8 bytes. Reject blobs with
public_len < 8 before dereferencing pub + 4.

Cc: stable@vger.kernel.org
Fixes: e5fb5d2c5a03 ("security: keys: trusted: Make sealed key properly interoperable")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 30188a0ec676..621f8ffba17e 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -425,6 +425,9 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (private_len + 2 + public_len + 2 > blob_len)
 		return -E2BIG;
 
+	if (public_len < 8)
+		return -EINVAL;
+
 	pub = blob + 2 + private_len + 2;
 	/* key attributes are always at offset 4 */
 	attrs = get_unaligned_be32(pub + 4);
-- 
2.47.3

