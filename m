Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371974E77F7;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840685; cv=none; b=b2reXlxy6PNkSHmHKyX/LmDr90XSGvGKHy51f64oIfPGRUezyKIh8JsXD8CAiU0cg3fot7GC3DbPrQDq+LUvlMoku0aTo/gyCiwIF16Z5+yvrmYdhaXk+m2058a53cbzu44jNimJ//QBt2HpW1b4Sy/Ewi81enjSNCFYe0IhQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840685; c=relaxed/simple;
	bh=mBu7Oq1ksHKrEeE3KFUtGY0v5te7tndDJiHHavVhxtY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SAeqDdrASlr9159KqZIDCPr5SVVnDXfLvqMoMnXqmtLucK3q6iEvixbpkiZRX3lN5ygY8Pjvma+DeDBdVe5YuzMAcdNneSPXw0li9vWuOkRGZmKxtf27CbafEYAxCkE9CINYMj2gW0TIZb928sNlTMwe2whBTYrzesmgFzA6eUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwiXslqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwiXslqL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0351FC2BD05;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791840685;
	bh=mBu7Oq1ksHKrEeE3KFUtGY0v5te7tndDJiHHavVhxtY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DwiXslqLQhT2H4iV2jX95r4uiJB+cjSUfLV7ND/NsW/yDUt2lr4C+Gc/hdrpsIjUx
	 qvxumJXNJjt60XuIJMymXD06avfyE00TWST/8Qt3pJ+62m0MgDrB1+R+FmkJpc6Jg9
	 bTfAfbVPsahbVnCg1QLGL1t2y6gd9yVo+iRWviDycwUtHi+bzJ/LmsFD8DFM8OxH2T
	 5SU33W8YygPFjY5ciDkC6GtFLvCcCrPpy9lM1AJtXFPp6mF70RUu+JxQmz8oH2VXh6
	 jIsGG5N05FcUxl5IZh7fYDuujdut4c2+ya85AD5SXziIWnlywHrRksT5xDvxL8OIbx
	 MsNbjHQm2gZpA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED7ECA9EDC;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Mon, 12 Oct 2026 21:31:21 +0000
Subject: [PATCH 4/5] lib/crypto: poly1305: Take a size_t length in
 poly1305_update()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-libcrypto-4gib-lengths-v1-4-ea566c129a2e@genproof.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791840683; l=3486;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=irCOLOTna2CXuGsURd0U3lbRTs2zb4VOPdikvUV7L0c=;
 b=jY+PQ0zlS+9OJjn9T3kdcCRBgGV28HNvJjB2ixzkfeUmh+Ma4InANaqzMq+kuvcWyMZO/wWEi
 cx/WIK1ifXcDSrHbzVx5E5Hbcu4s1B8Z2UT5NVvAj72UHqIMj8RKzrI
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

poly1305_update() adds desc->buflen and nbytes as unsigned int values
to check for a full block.  With 1 to 15 bytes in the buffer and
nbytes >= 2^32 - desc->buflen, the sum wraps.  The tail path then copies
nbytes bytes into the 16-byte desc->buf.

For example, these calls trigger the bug:

    poly1305_update(&desc, p, 1);
    poly1305_update(&desc, p + 1, 0xffffffff);

Commit b646b782e522 ("lib/crypto: poly1305: Consolidate into single
module") introduced this addition.  The previous BLOCK_HASH_UPDATE()
code used size_t for the addition.

The unsigned int nbytes parameter also truncates the size_t lengths
from lib/crypto/chacha20poly1305.c.  For associated data or messages of
4 GiB or more, poly1305_update() authenticates only the first
(length mod 2^32) bytes.  Other hash-like library functions, including
sha256_update() and blake2s_update(), take size_t lengths.

Change nbytes to size_t and compare it with the space left in the
buffer.  poly1305_blocks() takes an unsigned int length, so pass it at
most UINT_MAX bytes per call, rounded down to a whole number of blocks.
On 64-bit MIPS and RISC-V, this relies on the preceding patches, which
make their assembly handle lengths of 2 GiB or more.

No in-tree caller passes inputs this large, so this is an ABI robustness
improvement.  I found the bugs while writing a Coq/VST proof of this
code with LLM agents.  I reproduced the overflow in userspace with
AddressSanitizer, and the truncation by comparing MACs with OpenSSL.

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 include/crypto/poly1305.h |  2 +-
 lib/crypto/poly1305.c     | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 190beb427c6d..bf53b1df9aa3 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -61,7 +61,7 @@ struct poly1305_desc_ctx {
 void poly1305_init(struct poly1305_desc_ctx *desc,
 		   const u8 key[at_least POLY1305_KEY_SIZE]);
 void poly1305_update(struct poly1305_desc_ctx *desc,
-		     const u8 *src, unsigned int nbytes);
+		     const u8 *src, size_t nbytes);
 void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest);
 
 #endif
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index f313ccc4b4dd..f04c4cc2f55c 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -35,11 +35,9 @@ void poly1305_init(struct poly1305_desc_ctx *desc,
 EXPORT_SYMBOL(poly1305_init);
 
 void poly1305_update(struct poly1305_desc_ctx *desc,
-		     const u8 *src, unsigned int nbytes)
+		     const u8 *src, size_t nbytes)
 {
-	if (desc->buflen + nbytes >= POLY1305_BLOCK_SIZE) {
-		unsigned int bulk_len;
-
+	if (nbytes >= POLY1305_BLOCK_SIZE - desc->buflen) {
 		if (desc->buflen) {
 			unsigned int l = POLY1305_BLOCK_SIZE - desc->buflen;
 
@@ -52,12 +50,14 @@ void poly1305_update(struct poly1305_desc_ctx *desc,
 			desc->buflen = 0;
 		}
 
-		bulk_len = round_down(nbytes, POLY1305_BLOCK_SIZE);
-		nbytes %= POLY1305_BLOCK_SIZE;
+		while (nbytes >= POLY1305_BLOCK_SIZE) {
+			/* poly1305_blocks() takes an unsigned int length. */
+			unsigned int bulk_len = round_down(min(nbytes, UINT_MAX),
+							   POLY1305_BLOCK_SIZE);
 
-		if (bulk_len) {
 			poly1305_blocks(&desc->state, src, bulk_len, 1);
 			src += bulk_len;
+			nbytes -= bulk_len;
 		}
 	}
 	if (nbytes) {

-- 
2.43.0


