Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252843;
	b=b++vJaPxQM8trDdmsTdBqjdfXMVZtW7rdB1at3PQQ7pQfubaCkA5PGaMYp3BxuD0LAOm
	 LofW26En9/UWxqtmjkTGbZYpMSUcdefljBgvEbIgjnMWPW4/6xSqntieJsxCXH82egluD
	 eJ14TdDd8ZaYviL5nuMMG9jeY0PwnqwZC0XDrWnDjrSLHkPDIkiat2kknY+Q02C4j01ST
	 F+cqRbqRBpnNViB4h03QBfpWv/VRSK0wR1dML4/H2ZWi3WElaOtl/MHglOIwZQ3oK9kck
	 akqJipkcwgYvWET3KUE8FC64aQo9pJjC+pjyz7k9Tc9fTVfNImrs9XWZA4kD1y4rYCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wMS4W2gcvBN1w7vtAgXrycq5bRlMXjX2llFm4uRkvys=;
	b=E99diDOf+QFeWxMc52D75wKx4c2vdqIGA+zpPQgZTpjMxiZhGYhJ/igOGB7F/1b3yOaS
	 HWjtvPnNmyu4v2vCi9oYLj9IhT60e0t3fO6CyQNKCs9l7nsDslKgDzXsH2BiVQMznI6tx
	 OYgnpsKqYTDOiCbS8ApaAUx8AUi1li0S5jQwlTj3iQxVLiu2jI6PP9BgQdYjVS3SAkYof
	 OHkqAq+7OVmcOhLcTpGL34mfMmHOjC2hzSeUiTSFSMxD98pvsaDpw8MSegds5aFC06gI2
	 y1aMToJ5UAMbiR8wCK1RiqOKIRc2JnbGCYd931Ijy2zaahfy+l24hJ6crYvwtYHQZ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=It2QZc0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55641606A323
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=It2QZc0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B376D1F01829;
	Thu, 29 Oct 2026 05:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793252842;
	bh=wMS4W2gcvBN1w7vtAgXrycq5bRlMXjX2llFm4uRkvys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=It2QZc0Oc2Jn3LYyJkOAcpid5dQSxltpdVwJ5dxe60UDkEF4XZyVK2gm2Uc3yAkV7
	 UDGG6WHjFEFKLmnbla+FDXDdvSCMm8UHbndkKaekkvbQUKuVAwr2P4Xke3imoeWnUL
	 eZcjMe5CwcvwaBCH2JJByzChNIsMJT6wWouSbkhj4P2cXMeXuUYaaj5kHjW3EUEhHk
	 S9KyTNDMLN91S+TC79swKfqulGkf+IpJBvITnM0bd3cWmdHlq9M8V+bpLQb5C9SHUd
	 NmvCBDrNUUzN9OJLlujsarY55FxJVD+U6YLHCWFoHG6x0QxAymcjVEAVDvmm6VV7Fb
	 38Zqb5JrubArw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] lib/crypto: mldsa: Add __must_check to mldsa_verify()
Date: Wed, 28 Oct 2026 22:45:34 -0700
Message-ID: <20261029054534.68481-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029054534.68481-1-ebiggers@kernel.org>
References: <20261029054534.68481-1-ebiggers@kernel.org>
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

Signature verification status always must be checked.  Add __must_check,
for consistency with e.g. the AES-GCM and ChaCha20Poly1305 functions.

No effect on current callers, who always check the return value.

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/mldsa.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/crypto/mldsa.h b/include/crypto/mldsa.h
index e0754879e7452..b156f166a1413 100644
--- a/include/crypto/mldsa.h
+++ b/include/crypto/mldsa.h
@@ -52,8 +52,9 @@ enum mldsa_alg {
  * * -EKEYREJECTED if the signature is invalid but otherwise well-formed
  * * -ENOMEM if out of memory so the validity of the signature is unknown
  */
-int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
-		 const u8 *msg, size_t msg_len, const u8 *pk, size_t pk_len);
+int __must_check mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
+			      const u8 *msg, size_t msg_len, const u8 *pk,
+			      size_t pk_len);
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST)
 /* Internal function, exposed only for unit testing */
-- 
2.56.0

