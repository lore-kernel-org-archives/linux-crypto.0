Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503A629B8DD;
	Sat, 22 Nov 2025 19:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840565; cv=none; b=XG+mE1Nj9TdC+AYZU2SmlbAqcgHjnUrm9YEAKKZNfpiIzBX+RhHK8sU3fD+hrTjj/1m1LfFl3e/2q/JsVsEWoi5VNHcmd6OJwJaf+yAMdqwD7vX4GPuUybj+/Qcygu8IO5QQyngSyflhOpmQc1zIN81sAV8e4uAsdGIVW+OrDHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840565; c=relaxed/simple;
	bh=j83Je7jbHX6b3mi+GQbOOK1HmWQTp2TsTLV/ZZ/fn/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoCYcYdZXBnbAF+gy+lnzR+SOuzkbqBmI6+Pjk0wz6RjDsYdRtgZUrcKtrvIY12HgppQzatKNYxZmJvb8B9PVn3TR2Ds8t7BXGHZ+G1nLh8jgL8ug0oeugL5WjWjkOcsWuriqJ99m6D493r0vzaCzzjZ1E6tTTlpxwEzyeyaD70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4W3yqBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4W3yqBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10905C19421;
	Sat, 22 Nov 2025 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840564;
	bh=j83Je7jbHX6b3mi+GQbOOK1HmWQTp2TsTLV/ZZ/fn/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4W3yqBtn7Z5PLcVMbiEmjrfCMq96oUq2hsggAGhOUMfuDvjZQ6FG8zJ7gxrClTac
	 pcfhyLgy0MOkLTrjVWrN2zmh12B/DRMu/BCGqrI1J4u1rVfGZRAOtHBSEi6+4CkSFP
	 U29Pp3awnqdmg+4nyOYmXUVl94nCv4RmL6wuUIIf5Hv352zN4XOVYgUSSp2h+E8Nl5
	 f44FkNQS94ivvrVr6UVKrkIvDD9TZtw9x6JebhiWzBaaMWh0d0gy7bPe/meojh7e8Y
	 4q1Pd0NYMHNEZLWv9VSAaLQ+oBH+sJ0kv4UUBFlLtBcZ2FBdq803fEHrvoWFi2QgAb
	 7/e0hb4DVkk3A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/6] lib/crypto: chacha: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:01 -0800
Message-ID: <20251122194206.31822-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of the chacha library functions.  This causes clang to warn
when a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/chacha.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 38e26dff27b0..1cc301a48469 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -36,22 +36,22 @@
 struct chacha_state {
 	u32 x[CHACHA_STATE_WORDS];
 };
 
 void chacha_block_generic(struct chacha_state *state,
-			  u8 out[CHACHA_BLOCK_SIZE], int nrounds);
+			  u8 out[at_least CHACHA_BLOCK_SIZE], int nrounds);
 static inline void chacha20_block(struct chacha_state *state,
-				  u8 out[CHACHA_BLOCK_SIZE])
+				  u8 out[at_least CHACHA_BLOCK_SIZE])
 {
 	chacha_block_generic(state, out, 20);
 }
 
 void hchacha_block_generic(const struct chacha_state *state,
-			   u32 out[HCHACHA_OUT_WORDS], int nrounds);
+			   u32 out[at_least HCHACHA_OUT_WORDS], int nrounds);
 
 void hchacha_block(const struct chacha_state *state,
-		   u32 out[HCHACHA_OUT_WORDS], int nrounds);
+		   u32 out[at_least HCHACHA_OUT_WORDS], int nrounds);
 
 enum chacha_constants { /* expand 32-byte k */
 	CHACHA_CONSTANT_EXPA = 0x61707865U,
 	CHACHA_CONSTANT_ND_3 = 0x3320646eU,
 	CHACHA_CONSTANT_2_BY = 0x79622d32U,
@@ -65,12 +65,12 @@ static inline void chacha_init_consts(struct chacha_state *state)
 	state->x[2]  = CHACHA_CONSTANT_2_BY;
 	state->x[3]  = CHACHA_CONSTANT_TE_K;
 }
 
 static inline void chacha_init(struct chacha_state *state,
-			       const u32 key[CHACHA_KEY_WORDS],
-			       const u8 iv[CHACHA_IV_SIZE])
+			       const u32 key[at_least CHACHA_KEY_WORDS],
+			       const u8 iv[at_least CHACHA_IV_SIZE])
 {
 	chacha_init_consts(state);
 	state->x[4]  = key[0];
 	state->x[5]  = key[1];
 	state->x[6]  = key[2];
-- 
2.51.2

