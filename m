Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E572DECC6;
	Tue,  9 Dec 2025 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765319707; cv=none; b=FqWK+Z3xdCS88ny8IOv0Itc82RIuD+gMvU2fEBBE6gmlIAo0k195c9Qm7xNlihTt5cXyMEZacm8I6qf8RNeQUq+/tYLfC3kX2a08gNYJjpSWT7llJuPm3QHZlgQRaeVQai+eQ1ztOkP42JgN45wYVRCQVhPgvn6D6QSiRadaaIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765319707; c=relaxed/simple;
	bh=E3ZY5GrmUasYc7LNtlvHAHgQyO5fJCHZUGxegGCcdyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blHGGkSvGuT14/xaW7/EiouCevIunVnlwY5rZ5g508bY38bHwA0r2q7kO59ee7St6NBsrg+Jvd5bZZyyLeHe5Fw2hRLfysZMGR9D4XfjXWzAIDUqQLJuA6Zcott/QaxgK7OtruJnI0IQdy7whFUh0ddw0f81PoY1DTlx7zrmFB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6pKhJtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6pKhJtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66852C4CEF5;
	Tue,  9 Dec 2025 22:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765319706;
	bh=E3ZY5GrmUasYc7LNtlvHAHgQyO5fJCHZUGxegGCcdyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6pKhJtk2coLOHazLr8r43p7gqFd3uwLSXvX+usbee0GsRzK+15Dz46TSOkyIuH2f
	 TmXKb2aqvW2Lsp78EASY9/Xc0kpETlELrBgOqwPmg81ODw53Od1mLvm68Q2fkDwh9g
	 nJfC3xMVHPpjPtQOBRT3tmOOulYiqs65R1T4LKejfx8C4dpr5FRBTQQnmDi3QUCBPR
	 iOjFtXojHwCOwN877kZTE4QXBoHUHhRfKCUPw0lwYNhekNUVIXiuQsfLIli09izfIx
	 w7Y0MRe/uYko2LAcSth729Fg8bN6BXbOcByHOjmxNY5/QLKT5OGfllbjO59GFjF++W
	 fly38mbKT4Y2Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: [PATCH] crypto: arm64/ghash - Fix incorrect output from ghash-neon
Date: Tue,  9 Dec 2025 14:34:17 -0800
Message-ID: <20251209223417.112294-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
handling") made ghash_finup() pass the wrong buffer to
ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
outputs when the message length isn't divisible by 16 bytes.  Fix this.

(I didn't notice this earlier because this code is reached only on CPUs
that support NEON but not PMULL.  I haven't yet found a way to get
qemu-system-aarch64 to emulate that configuration.)

Fixes: 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block handling")
Cc: stable@vger.kernel.org
Reported-by: Diederik de Haas <diederik@cknow-tech.com>
Closes: https://lore.kernel.org/linux-crypto/DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com/
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

If it's okay, I'd like to just take this via libcrypto-fixes.

 arch/arm64/crypto/ghash-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 7951557a285a..ef249d06c92c 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -131,11 +131,11 @@ static int ghash_finup(struct shash_desc *desc, const u8 *src,
 
 	if (len) {
 		u8 buf[GHASH_BLOCK_SIZE] = {};
 
 		memcpy(buf, src, len);
-		ghash_do_simd_update(1, ctx->digest, src, key, NULL,
+		ghash_do_simd_update(1, ctx->digest, buf, key, NULL,
 				     pmull_ghash_update_p8);
 		memzero_explicit(buf, sizeof(buf));
 	}
 	return ghash_export(desc, dst);
 }

base-commit: 7a3984bbd69055898add0fe22445f99435f33450
-- 
2.52.0

