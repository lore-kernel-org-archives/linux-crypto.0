Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3C1FAE
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrbdFQ6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CBEC433C9;
	Wed, 22 Nov 2023 01:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700616575;
	bh=RpIunAZsbi17XYTLNqesJHhN+XFXcX0D4F+MccBdkJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JrbdFQ6bgw6z7RfWZ45V2si4KCzEBQBQGNtYt+ijIY0vU2ZyG5yoLqrd10A3ZQYk6
	 PaQn8LxCVvuVH8DQScs7rtrAhF+4vXJkdkF/BKVJzBBxeDoEUxUxddctrxqo9kaqa9
	 FP0s2LUG+VOQ/zMn34itUt3qFv3mdLZnDLU6yUK/YpdS+L6kRyz+NaaOPnK4N32h4T
	 m8SNMDlcEa4MXDgpTG3pTLvWEJ7GeZMZurLJKlKCIIM5ZGZv21x+OY7yMc7EICMoms
	 WUEoKBkMAZCEBg3Wfrz4/RW+dPymXm7HTwya4ChSJja62mGU024QnF9t1m/FBQPi3r
	 FWJQkNhUYPOHQ==
Date: Tue, 21 Nov 2023 17:29:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231122012933.GG2172@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025183644.8735-13-jerry.shih@sifive.com>

On Thu, Oct 26, 2023 at 02:36:44AM +0800, Jerry Shih wrote:
> diff --git a/arch/riscv/crypto/chacha-riscv64-glue.c b/arch/riscv/crypto/chacha-riscv64-glue.c
> new file mode 100644
> index 000000000000..72011949f705
> --- /dev/null
> +++ b/arch/riscv/crypto/chacha-riscv64-glue.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Port of the OpenSSL ChaCha20 implementation for RISC-V 64
> + *
> + * Copyright (C) 2023 SiFive, Inc.
> + * Author: Jerry Shih <jerry.shih@sifive.com>
> + */
> +
> +#include <asm/simd.h>
> +#include <asm/vector.h>
> +#include <crypto/internal/chacha.h>
> +#include <crypto/internal/simd.h>
> +#include <crypto/internal/skcipher.h>
> +#include <linux/crypto.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +
> +#define CHACHA_BLOCK_VALID_SIZE_MASK (~(CHACHA_BLOCK_SIZE - 1))
> +#define CHACHA_BLOCK_REMAINING_SIZE_MASK (CHACHA_BLOCK_SIZE - 1)
> +#define CHACHA_KEY_OFFSET 4
> +#define CHACHA_IV_OFFSET 12
> +
> +/* chacha20 using zvkb vector crypto extension */
> +void ChaCha20_ctr32_zvkb(u8 *out, const u8 *input, size_t len, const u32 *key,
> +			 const u32 *counter);
> +
> +static int chacha20_encrypt(struct skcipher_request *req)
> +{
> +	u32 state[CHACHA_STATE_WORDS];

This function doesn't need to create the whole state matrix on the stack, since
the underlying assembly function takes as input the key and counter, not the
state matrix.  I recommend something like the following:

diff --git a/arch/riscv/crypto/chacha-riscv64-glue.c b/arch/riscv/crypto/chacha-riscv64-glue.c
index df185d0663fcc..216b4cd9d1e01 100644
--- a/arch/riscv/crypto/chacha-riscv64-glue.c
+++ b/arch/riscv/crypto/chacha-riscv64-glue.c
@@ -16,45 +16,42 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-#define CHACHA_KEY_OFFSET 4
-#define CHACHA_IV_OFFSET 12
-
 /* chacha20 using zvkb vector crypto extension */
 asmlinkage void ChaCha20_ctr32_zvkb(u8 *out, const u8 *input, size_t len,
 				    const u32 *key, const u32 *counter);
 
 static int chacha20_encrypt(struct skcipher_request *req)
 {
-	u32 state[CHACHA_STATE_WORDS];
 	u8 block_buffer[CHACHA_BLOCK_SIZE];
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
 	unsigned int nbytes;
 	unsigned int tail_bytes;
+	u32 iv[4];
 	int err;
 
-	chacha_init_generic(state, ctx->key, req->iv);
+	iv[0] = get_unaligned_le32(req->iv);
+	iv[1] = get_unaligned_le32(req->iv + 4);
+	iv[2] = get_unaligned_le32(req->iv + 8);
+	iv[3] = get_unaligned_le32(req->iv + 12);
 
 	err = skcipher_walk_virt(&walk, req, false);
 	while (walk.nbytes) {
-		nbytes = walk.nbytes & (~(CHACHA_BLOCK_SIZE - 1));
+		nbytes = walk.nbytes & ~(CHACHA_BLOCK_SIZE - 1);
 		tail_bytes = walk.nbytes & (CHACHA_BLOCK_SIZE - 1);
 		kernel_vector_begin();
 		if (nbytes) {
 			ChaCha20_ctr32_zvkb(walk.dst.virt.addr,
 					    walk.src.virt.addr, nbytes,
-					    state + CHACHA_KEY_OFFSET,
-					    state + CHACHA_IV_OFFSET);
-			state[CHACHA_IV_OFFSET] += nbytes / CHACHA_BLOCK_SIZE;
+					    ctx->key, iv);
+			iv[0] += nbytes / CHACHA_BLOCK_SIZE;
 		}
 		if (walk.nbytes == walk.total && tail_bytes > 0) {
 			memcpy(block_buffer, walk.src.virt.addr + nbytes,
 			       tail_bytes);
 			ChaCha20_ctr32_zvkb(block_buffer, block_buffer,
-					    CHACHA_BLOCK_SIZE,
-					    state + CHACHA_KEY_OFFSET,
-					    state + CHACHA_IV_OFFSET);
+					    CHACHA_BLOCK_SIZE, ctx->key, iv);
 			memcpy(walk.dst.virt.addr + nbytes, block_buffer,
 			       tail_bytes);
 			tail_bytes = 0;
