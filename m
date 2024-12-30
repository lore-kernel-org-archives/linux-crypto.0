Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9F919D89B;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517765; cv=none; b=tBYYfSafFiCT6vhQxxjOWoUTEsr3O4MX20nmzC0JBMAzI0qUsk339wKnLMT2q9jDZ6ICLfMwEjIrirdhEMRZZ4ncFsN22UJilHtYJIuOAQxaboN95/AJaqi7Qbui3Lx2FxgL00evqbV3ZeDXHpczaViG+bKko7eZe87ahUZ5Pnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517765; c=relaxed/simple;
	bh=ouuUySUoLhMrrlBcXOe8B+9HrJzjwC7w9DOOQhZHjCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3gqEX8Z1ybg0wJYi3uQsWQBaolDAXNh3QeAY9c5NMHOByaVa+1vn9akb3jJyrDxMgbGkfFRf2NaqAQKKezWoio1PrHdeK6Q6E7I7GShpyP0CNHVKyQM/2+dXPckajoz/U5n0Enk95fCkTQxxwpvjMplf/dkltDVjbh37WdJvbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0MaNvjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0MaNvjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A798AC4CEDC;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517764;
	bh=ouuUySUoLhMrrlBcXOe8B+9HrJzjwC7w9DOOQhZHjCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0MaNvjWDn5EygCKZDuBSrXH9cuut+CXK5MMrnjLuPZPxISLNyN+xGBZj7m5WGgTj
	 gouA3Dy+g+1qJAbmU6Ilf84nvIluzwGuXuQBnEephADIj0iaHc79hZdceRz04abiw0
	 k9uLxF0HCLe/2Vyh1XR1PWcc9Y6u4u0yDLG2IcAq7nj/BmEFYMN5r6cOokThLkFXpK
	 KWgvlQsEPSVumt2pUKeDwRPdj4GtU3QrjTxdzYqb5vmgpwsKUncU8QGPQOoXP5uIUT
	 LfrLCUF88jsRMubvRfag9dEex2Gd4mNFlaPDLUkB3gNoUTU6eL954Bpx6Cf3cs8AEj
	 e2D9+s2b9P/tA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/29] crypto: aegis - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:06 -0800
Message-ID: <20241230001418.74739-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aegis128-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 6cbff298722b..15d64d836356 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -282,14 +282,14 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 	union aegis_block buf;
 	unsigned int pos = 0;
 
 	scatterwalk_start(&walk, sg_src);
 	while (assoclen != 0) {
-		unsigned int size = scatterwalk_clamp(&walk, assoclen);
+		unsigned int size;
+		const u8 *mapped = scatterwalk_next(&walk, assoclen, &size);
 		unsigned int left = size;
-		void *mapped = scatterwalk_map(&walk);
-		const u8 *src = (const u8 *)mapped;
+		const u8 *src = mapped;
 
 		if (pos + size >= AEGIS_BLOCK_SIZE) {
 			if (pos > 0) {
 				unsigned int fill = AEGIS_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
@@ -306,13 +306,11 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 		memcpy(buf.bytes + pos, src, left);
 
 		pos += left;
 		assoclen -= size;
-		scatterwalk_unmap(mapped);
-		scatterwalk_advance(&walk, size);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, mapped, size);
 	}
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS_BLOCK_SIZE - pos);
 		crypto_aegis128_update_a(state, &buf, do_simd);
-- 
2.47.1

