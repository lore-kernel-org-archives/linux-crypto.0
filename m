Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252839;
	b=YCMus3jcJO0gIL7VpTXi2wC36ctsp0bXF1As4+yov2a6Xc0ePqVo+X8S9h85yjxqL3rV
	 l1ttsydTBBjxhsx9g7ylW0VVMJ7eV/jAo6RRXoIcY0X/uaxAylFwYG1vQyH/EAuJO2GP0
	 ISzGUVVPoMQJeuuHVip/auUuNhWkrg1DHPk2bA+99w4EexD+rfcJYYgTQ5OW6t0ypp1zI
	 TLMU7CFOUqbN8sHrRvNfC420cUQcs9dUDqnKEH4EAuPkw/txKOqScZ42ZAQYgudB06voF
	 O2hY0VmweUpOiUdkozh5abW+yY8IusuuuoCJ0YofFPfWec7R8WJ7sqMKwsepMaeZpiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/5ZDaewqsi8FdIST/12h+7nlerMAwlEDPHmCSuffT2o=;
	b=Al24FbQ0ZAlSxhNKuaC2hVOFXy4N9AlV/e1miLD+r+9WL5IPYanrGgZkqekf1Zv/4dR0
	 7KBljQTmQaiSmCds5DE8ML1+PzcyMYrW3XeL7vuIOHMwDb8Hspav905nKOYB1g4FkM2CA
	 VWLcTFVGpRf0atV3YSbX1UUn6mQENzlp2CuAX9hSGsMSBpX/+V4OoT4vFK2TAgtx2+IVW
	 O99CnQQ/ojh/dvjvvFGJfOcDCPBLXZ/D0oVBcqIg5xsppA2UwXF0yFpIvD/8mEHcynpH6
	 FZgWrpFuLB/908PQk0Bbj6kFBUCnJy336O15yhim5ZIhMHS/Y/SDM90OV86Wp7uQHXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGeSNTdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1A606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGeSNTdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C4D1F01825;
	Thu, 29 Oct 2026 05:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793252838;
	bh=/5ZDaewqsi8FdIST/12h+7nlerMAwlEDPHmCSuffT2o=;
	h=From:To:Cc:Subject:Date;
	b=OGeSNTduuS7zXsovstTNfToOdcZBlW6lMXk7i1tZqEBYSi5wyhROYwjdcW+p5+pLz
	 iP5mgRGRXQNZqxxOs4e0EmHJR3PwmAeZ40fFV+KxIdXxKpjfIGTz8THhf3RBF7Wsbj
	 9JfEUD3VPnKbvKBWsSUs0vn0zrLAr/5mQUcH4l1CKlGUJIs/RGndmP8mlSPzu02tLD
	 OdDm1MMOasF23X1l9T0lXKgQqlq0MBL8KLfAOO8P8MA8z8B0OeqbvEKmNlOUunKEgR
	 8d4ouvgKXqLDn6zUUkWjC7YLmyyV6JKTFbM4PG5HozuYvH7GltKuuYdCNYSkSVpAUt
	 TT8vJVR6ZHR2w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] lib/crypto: mldsa: Address some minor nits
Date: Wed, 28 Oct 2026 22:45:31 -0700
Message-ID: <20261029054534.68481-1-ebiggers@kernel.org>
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

A few pedantic fixes for issues found by LLMs.

Eric Biggers (3):
  lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
  lib/crypto: mldsa: Explicitly check that 'alg' is a valid value
  lib/crypto: mldsa: Add __must_check to mldsa_verify()

 include/crypto/mldsa.h         |  6 ++++--
 lib/crypto/mldsa.c             | 15 +++++++++++----
 lib/crypto/tests/mldsa_kunit.c |  9 +++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)


base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.56.0

