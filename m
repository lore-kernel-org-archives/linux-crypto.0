Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D421D5CDE;
	Mon, 20 Oct 2025 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921614; cv=none; b=T6w4UtjcK4ydER4ia449githKCuCDKOiFTd4yKv2WbqZaSgL3aqIIys6sril6RFdWGByuVwalxohXhk97coCL9aLM7J89MRILMrfyU6lDAN91wIyViS9JKUzi9WZWKWGikk7lhnWPLZD5yYG7D/q432viEfeZd4R43kIZGvQSg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921614; c=relaxed/simple;
	bh=m4BeHgL3buDxrxSoDsgZ+7mjmPnxE72GJARRG8xIu+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsamaPobHt1sjOdFJeo+9y51X4N6OjAMGM434VR7+CJdO1EVgUEz2S6RQUKEkw9sw8WQMuqEM3H2KtdxAch2b772eyd3VXE1q/mlde/Sh19cS6hLk4qc0o3/AdlQ+4k4ds+2S0ZT3B4W0Ga6VGjqP7AuExl0F1c1TZUgKYrDx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBDV/pVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBDV/pVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AAAC113D0;
	Mon, 20 Oct 2025 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921613;
	bh=m4BeHgL3buDxrxSoDsgZ+7mjmPnxE72GJARRG8xIu+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBDV/pVMzGjHxm865ok1NZc5G0dnVmrH5vjolGOawgHxav/kKUrk6XzA1D4ecY0xk
	 HXmHZMhs53VAs8kTrnqZZZc73jstRhleO2L9s3EFJu2Ofpt8OutVure1oPYyvHkNuG
	 ochoya4yqoev0bLsEzNfOKdio6vxwAFucZngTY8rNPZf/s3mreh2JvVu8+pPd0z+la
	 4ECJTJwqB3Q7YwpMFBy3T6/rRREWZ3qUiC9Uic5Vb5SZ/G/aUe3WmA0Sy8JkMYW4ey
	 CeEZv1IOGjAIMKOCvsV4dAB/O2Y+W7Thdfv4evOrH/v6BQgj8ESXqpCwYmfFD7pIcN
	 c3eu3h8Lwg0UA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 04/17] lib/crypto: Move the SHA3 Iota transform into the single round function
Date: Sun, 19 Oct 2025 17:50:25 -0700
Message-ID: <20251020005038.661542-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

In crypto/sha3_generic.c, the keccakf() function calls keccakf_round() to
do most of the transforms, but not the Iota transform - presumably because
that is dependent on round number, whereas the Theta, Rho, Pi and Chi
transforms are not.

Note that the keccakf_round() function needs to be explicitly non-inlined
on certain architectures as gcc's produced output will (or used to) use
over 1KiB of stack space if inlined.

Now, this code was copied more or less verbatim into lib/crypto/sha3.c, so
that has the same aesthetic issue.  Fix this there by passing the round
number into sha3_keccakf_one_round_generic() and doing the Iota transform
there.

crypto/sha3_generic.c is left untouched as that will be converted to use
lib/crypto/sha3.c at some point.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
Link: https://lore.kernel.org/r/20251017144311.817771-5-dhowells@redhat.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/sha3.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 5f847a5eecdc7..2c292b0b3db34 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -46,11 +46,12 @@ static const u64 sha3_keccakf_rndc[24] = {
 };
 
 /*
  * Perform a single round of Keccak mixing.
  */
-static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state)
+static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state,
+						       int round)
 {
 	u64 *st = state->st;
 	u64 t[5], tt, bc[5];
 
 	/* Theta */
@@ -148,19 +149,19 @@ static SHA3_INLINE void sha3_keccakf_one_round_generic(struct sha3_state *state)
 	st[20] ^= bc[ 0];
 	st[21] ^= bc[ 1];
 	st[22] ^= bc[ 2];
 	st[23] ^= bc[ 3];
 	st[24] ^= bc[ 4];
+
+	/* Iota */
+	state->st[0] ^= sha3_keccakf_rndc[round];
 }
 
 static void sha3_keccakf_rounds_generic(struct sha3_state *state)
 {
-	for (int round = 0; round < SHA3_KECCAK_ROUNDS; round++) {
-		sha3_keccakf_one_round_generic(state);
-		/* Iota */
-		state->st[0] ^= sha3_keccakf_rndc[round];
-	}
+	for (int round = 0; round < SHA3_KECCAK_ROUNDS; round++)
+		sha3_keccakf_one_round_generic(state, round);
 }
 
 /*
  * Byteswap the state buckets to CPU-endian if we're not on a little-endian
  * machine for the duration of the Keccak mixing function.  Note that these
-- 
2.51.1.dirty

