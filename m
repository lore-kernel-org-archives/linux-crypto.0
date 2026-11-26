Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726256;
	b=TgzzyrebE32mztOdzPttBR97FFpWet0edeBBLSwcCiwXsA8CAbVJq5Ngq44h6/iKMRTW
	 zbj5oCCMplu+iC0PTKc66C2b+m4yKAWo7IUZ6wKskn6qJi3k/zBmBado2hX6Y/BV3c1Im
	 s2KD7+HUex27ZFJqOtP+9er+v59cZy7TGbwg8t40s9GVkW2JxeRv0hmjNF5s1XRvhPH6j
	 nQ5FvvqjIL/QNw1Zlhjtc8HEvalO1/vnLZ+oL32yuGJbjm4obje8hRYoAlKgncqjo+Sp/
	 xJYmnBE/61tBq74VRf2acZOi0ziLPJHCQXokouRV26SiOPa/LYqRZ9JIGM6M3jGobGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MCCeXGn8Or2Im1/w9TyBLehiPST7Mfk6qFmTWhVBMBQ=;
	b=w9YXcB5AZqfZeMcWQGSTDbZfuZQzIMZscay+ngksQ6pNSzkIkaF1PYZWyzQCtb1d1ddX
	 +/LvD8DXQNK3WfGiiCc44T2h6c1V86ljItgXY1JAYfe5u3nK+jKEtIqXbdR1S5P5sqvQy
	 iHMX7wMS7f0ox3jsAOksrULetYTpE7r8mRL1Ok2j6XTZR/+VFY0XWFlUpU3k/54ej9AbP
	 0LnhoAGGg0jhSBFI4UMMtn+ZZGpO0Q4OX8tmzXsSA8pplY4xrq/QvOnlde0OXsI76meim
	 sj1bAFyvuPr0FvB/BPqEeC5iVvGPVBby8QfBl51K6NxB10xSO5MkPTzOU9A19Ig3ZnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddx5xPJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7ECE7606A329;
	Thu, 26 Nov 2026 20:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddx5xPJP
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5F1681F0089C;
	Thu, 26 Nov 2026 20:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726256;
	bh=MCCeXGn8Or2Im1/w9TyBLehiPST7Mfk6qFmTWhVBMBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddx5xPJPcO4IwOL1kejTXhEgAMUtSjmWEH/k/uLy4bkcNJSKUygFbMfdVggRGSAkH
	 hECxUdQjQOlEZVrF7KfyCaNupAkQ9r9hEQyPuRB2Yv75uvO8xu1OV1id9ntKvoVDsQ
	 yr9iMA95lteGhvDOQlEOgcL1EHWcgM4WkkcRVm5vn7xDMwLd0VNNk6Q4x6JGAw0roV
	 6VPT4scK4SwjGxfORYTqQk3+rGQqwpNVBqlj8VNpOUq5oiOCwu9O7DHmoT4WBKs6KP
	 vvq4KBxa20vVjCf3U/lZC9UxF7a135gIvIRB3CTDR8DXhFIBWHFVg0BGB/v5+CVjxx
	 k8HfkApmq7aPw==
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
Subject: [PATCH v4 03/11] KEYS: trusted: Validate public_len before reading key attributes
Date: Thu, 26 Nov 2026 22:50:13 +0200
Message-ID: <20261126205021.2200819-4-jarkko@kernel.org>
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

tpm2_load_cmd() reads the 32-bit objectAttributes field at pub + 4
without checking that public_len is at least 8 bytes. Reject blobs with
public_len < 8 before dereferencing pub + 4.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 8c62342b2588..d2c74ef8844b 100644
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

