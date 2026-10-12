Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB94F55DF;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840685; cv=none; b=CFQ77JgKqWn20j+VyNDi+hXplv7MjzwQGoeOKmIortgMUs12juSTlg7RipgfNtyZj1mPq9BoWit8PdHE6OJNE05WR9ToXaSUj78W2WXFXgJ61/8Sle0lWvF/4hXUAuAAN2ct6nrJSXnQURF3Ipk4RlpOA+cTS1hcaPvUXZ7iFZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840685; c=relaxed/simple;
	bh=DdnDOuSawbe5nNcJRQbCzcdh3QuvWeXEUVeyBmzwMLE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sjnOebYePcMHqFUa0fnSTGcEPblPGKzrIdxho7HwyFGUPlqN3m3anUqABLUyJCm0RNh1PVTVaU3cozaDzIL8KRcjcJpmcp8VCKUnXD7f40eGmfkqYZ8fB8fpFVHXE3QUfRjJn6mIvIz8zFnsxom4xVW8PBtjXXG6wFUl8a5UyaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVtSCspt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVtSCspt"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BBDCC32782;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791840685;
	bh=DdnDOuSawbe5nNcJRQbCzcdh3QuvWeXEUVeyBmzwMLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VVtSCsptaFnucxj7jlU7T3aLpGdFDdj7JetIVBWk3kNxQcnP/KZLf4I8w33QgKlow
	 o09jhSEzhcopVdAzhA4zRLPwMKNE2xvLVDsm8CPv+H/YllYbzC2VTI8BIe+WsM3im7
	 Wxg3DLK7Jz8ahEBiHoIu9pG8kSajqt7X3iX1RDCWkYXr71JoeKX2crKmpL4kzo3YaH
	 Dw/PghpS634n0Ts9W1jN3gts3/pYb/uZY2EsBc8D5VNh77HK5KUe0b4UOYVSyD/oJ5
	 iQVvfhj26s/4+fZeGiQqn5VE+qe8HI4LLFQLEEZdfDWJAIGRyEErj9zuXSm0tepCuN
	 BSLsidwt0eDSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B1CA9ED0;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Mon, 12 Oct 2026 21:31:22 +0000
Subject: [PATCH 5/5] lib/crypto: chacha: Take a size_t length in
 chacha_crypt()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-libcrypto-4gib-lengths-v1-5-ea566c129a2e@genproof.com>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
In-Reply-To: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791840683; l=3015;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=EeWzQrmZlf68OfajrkB+W/t3+tJsiZ8lDU4fkz0igMY=;
 b=/ZTtirlILLZ+d+u1I7hRscr5gq2jf876h7ZB9XwqO0kZdL3/9zpYE3Jyvj7zgU5YdUH/8YzTT
 Vtshyrqsd45AR52IOsPPgryK4vOhyYiganDS1gkEOv9pttEVqP2Rb4H
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

chacha20poly1305_encrypt(), chacha20poly1305_decrypt() and the
xchacha20poly1305 variants take size_t lengths.  They pass these lengths
to chacha20_crypt(), which takes an unsigned int.

For a message of 2^32 + k bytes, chacha20_crypt() processes only the
first k bytes.  In-place encryption leaves the remaining bytes as
plaintext.  Until poly1305_update() took a size_t, those bytes were not
authenticated either.  Commit ed20078b7e33 ("crypto: chacha20poly1305 -
import construction and selftest from Zinc") introduced this behavior.

Change chacha_crypt() and chacha20_crypt() to take size_t lengths, as
poly1305_update() and the other library functions do.  The architecture
code takes an unsigned int length.  Split inputs larger than UINT_MAX
into chunks of at most UINT_MAX bytes.  Round each non-final chunk down
to a multiple of CHACHA_BLOCK_SIZE to keep the keystream continuous.

Lengths up to UINT_MAX make the same single call as before.  The
RFC 8439 limit of 2^38 - 64 bytes per message still applies.

No in-tree caller passes messages this large, so this is an ABI
robustness improvement.  I found the bug while writing a Coq/VST proof
of this code with LLM agents, and reproduced it in userspace.

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 include/crypto/chacha.h |  4 ++--
 lib/crypto/chacha.c     | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 1cc301a48469..4c18e99eb4f7 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -86,10 +86,10 @@ static inline void chacha_init(struct chacha_state *state,
 }
 
 void chacha_crypt(struct chacha_state *state, u8 *dst, const u8 *src,
-		  unsigned int bytes, int nrounds);
+		  size_t bytes, int nrounds);
 
 static inline void chacha20_crypt(struct chacha_state *state,
-				  u8 *dst, const u8 *src, unsigned int bytes)
+				  u8 *dst, const u8 *src, size_t bytes)
 {
 	chacha_crypt(state, dst, src, bytes, 20);
 }
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index 86e5d382a4e0..ffa0c75ce501 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -39,8 +39,21 @@ chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
 #endif
 
 void chacha_crypt(struct chacha_state *state, u8 *dst, const u8 *src,
-		  unsigned int bytes, int nrounds)
+		  size_t bytes, int nrounds)
 {
+	/*
+	 * chacha_crypt_arch() takes an unsigned int length.  Process longer
+	 * messages in chunks that are a multiple of CHACHA_BLOCK_SIZE, so that
+	 * the keystream continues correctly from one chunk to the next.
+	 */
+	while (bytes > UINT_MAX) {
+		unsigned int l = round_down(UINT_MAX, CHACHA_BLOCK_SIZE);
+
+		chacha_crypt_arch(state, dst, src, l, nrounds);
+		dst += l;
+		src += l;
+		bytes -= l;
+	}
 	chacha_crypt_arch(state, dst, src, bytes, nrounds);
 }
 EXPORT_SYMBOL_GPL(chacha_crypt);

-- 
2.43.0


