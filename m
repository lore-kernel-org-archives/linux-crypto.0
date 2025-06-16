Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227931684B4;
	Mon, 16 Jun 2025 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750036140; cv=none; b=WYTvOK1ipmjQVnE1vVEK6W3gh11iLu9PGl6chpsk+o7GXTbu3hWq0EqxS2Fh4JDRuq4vl7xKOHnqqe3ADpKbthpyZlsYPYdOmeXtR4CArvbS9DwubMsGtW7iD83fUV3c/cX1GyzmaVaTQnn7An7A35DvIZ2PDzxUyxFipqeBYz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750036140; c=relaxed/simple;
	bh=OcGhC0/lwGuhRZjjubRH24r65WOYjJN+RLthQl7NbaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uCxGrOXREsavA21FduqtlNrnF4z0FzJwFhx8khudrxHH4Per3y3blVSOcuGRTnG3gXHywwHuUOubR5tvvOJKVSYrm5cfMAuqntR8wd48UqgzWnRW/077NGQCtQdqtPQmNPCpH7g84eeHT/LpyvF8/e5/xWCtpnUGxh4h2ua8Mlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhOkLjP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhOkLjP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7154AC4CEE3;
	Mon, 16 Jun 2025 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750036139;
	bh=OcGhC0/lwGuhRZjjubRH24r65WOYjJN+RLthQl7NbaI=;
	h=From:To:Cc:Subject:Date:From;
	b=NhOkLjP8gQhIVU1evklDKXIz5QVnCaZf3tnjaKeIyVtZJK2DSbRn5RI1OgMMHrXsq
	 fbcOs620RSNlh9JQecb7rhoNQSOqrQg8fvhf+LzgOjgn3G2gshOqftI344VE/3Y62f
	 5NT+Hu5abZz8Nc7qqn/nk4PxzIoZxVf8CqqSMMnq5FYxCMBClpbEgVrNcRRIx8Si0i
	 hQw+sea6xgQwGAxT4TZrP681aqUteYfrUkePUbhaVOe7U5fsq20zgOYc9IQBdNWjHK
	 H8sYWExRs3+RdbY2KujaS8wJHS/5co+Nv2eEII4CawwJ0rjA5JcF4W0TPW7r9p3h5G
	 MMyk+uOcSS24A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
Date: Sun, 15 Jun 2025 18:06:54 -0700
Message-ID: <20250616010654.367302-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

For some reason arm64's Poly1305 code got changed to ignore the padbit
argument.  As a result, the output is incorrect when the message length
is not a multiple of 16 (which is not reached with the standard
ChaCha20Poly1305, but bcachefs could reach this).  Fix this.

Fixes: a59e5468a921 ("crypto: arm64/poly1305 - Add block-only interface")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/lib/crypto/poly1305-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
index 6a661cf048213..c9a74766785bd 100644
--- a/arch/arm64/lib/crypto/poly1305-glue.c
+++ b/arch/arm64/lib/crypto/poly1305-glue.c
@@ -36,18 +36,18 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 	if (static_branch_likely(&have_neon)) {
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 
 			kernel_neon_begin();
-			poly1305_blocks_neon(state, src, todo, 1);
+			poly1305_blocks_neon(state, src, todo, padbit);
 			kernel_neon_end();
 
 			len -= todo;
 			src += todo;
 		} while (len);
 	} else
-		poly1305_blocks(state, src, len, 1);
+		poly1305_blocks(state, src, len, padbit);
 }
 EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
 bool poly1305_is_arch_optimized(void)
 {

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0

