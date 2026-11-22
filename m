Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795361342;
	b=wLzG7iRQ3yiIzhVFy21kBR/YYc3BPss/l4U/HfwQ0aLl9Sy1TUbeak1rtcwWUKo14o8W
	 /6OuXcgGG281cv9/Hu2v9hPLHegIqr0+I/YUNVhiTz/lXIJ2pc4ccFhls5xuGJRZiP6vV
	 Gq6WZQJEtzH03rFtkETv6NUfzXTT/lL1O0DgZ3KrOHyJHcRlFGn4Ly5dXAteCvPcpBGPd
	 8R9bsqEu72t4LZTINGYU7QwU2XgbFWbVTGF7cUbjtFd+ldxfDQm2dHsTpJOX7wo7zbbgP
	 MRquOIj9dcP9krFsezWQaTsL/4yDjc/ES7kjhoC3beipipNvaWWja9nUdsDrcnjvHVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795361342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9nQxnYz6UO1nf9mlNBh/7UX1qcC/Uwn0p+mA44C2aF0=;
	b=q0BFeEnxigbTDNFf7OnRu+9YOmnfZ1eqUL73x1g5l41JrAWCPnaE31YWn3ggOxNzhXkF
	 3fbkGiKAzdwrYDMYJoT9f1K9BhF0AjM+3mXu9ISeFCrbXpmUFe2tqbWCEHCxRj6jEWoxM
	 pnk0ntsdxgbK3xDkO5d/+4V1ahkYvia6XMR5+p83zGrDZcFNlrGpviaA2JL9k38XdZGW0
	 ARdT928fB0CxfusruMAwP7W6wvT6nt5kfE0bhCe20H08TkiABOwYtbe87o+ipADaFKjZ9
	 69h9oR5KHTGiE8r6nuoDl5FcK1JeQSMW4Sb1AdMIGrncZL72fpIsCdLS17m9C5f830g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMPu4rp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79778606A684;
	Sun, 22 Nov 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMPu4rp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D231F000EC;
	Sun, 22 Nov 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795361342;
	bh=9nQxnYz6UO1nf9mlNBh/7UX1qcC/Uwn0p+mA44C2aF0=;
	h=From:To:Cc:Subject:Date;
	b=NMPu4rp8zjewDlvkpylD75SJ9oDVhEKn1UTPVjZqujtU5Z6dAg30GKLvJ4PIaYq93
	 uzDp8WTcNGkG+m/Xk4DqLWYEY3ebBZhPf/s1rhDDYrUuMuBSbQQ+nefqb6DH2HRtSm
	 jvCSPA3ndKtq+dIXqcVHVGvka63J9BOuQYoRR2H3d2l6oer0Lqu+nC0TfyBvA8KzqU
	 d/ZLZFA75MOY9j5cd2EJPZUCymlBYdDmy6ghTGh7OyIbToBR6wBnhyEt4qNi6WsjS9
	 MH9+mDV4PWcihzPUvwqzii4Qni6HdCeModUux7Dc7xylCoC0SDhAEwylbD5rHK39IE
	 T7feX07qPm3sA==
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Shreesh Adiga <16567adigashreesh@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crc: Use uint64_t for the new NEON crc64 fold constants
Date: Sun, 22 Nov 2026 10:29:00 -0500
Message-ID: <20261122152900.1113961-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

Commit ff049836f05f ("lib/crc: Don't include <linux/types.h> in NEON intrinsics
code") in mainline switched the arrays passed to vld1q_u64() to uint64_t, since
u64 and the uint64_t that vld1q_u64() takes are different types on arm64 once
<linux/types.h> is gone. The two arrays added by commit ef4102757fdd ("lib/crc:
Add 4-way folding in NEON crc64_nvme implementation") still use u64, so the
combination fails to build with clang:

  lib/crc/crc64-neon.c:66:40: error: incompatible pointer types assigning
  to 'const unsigned long *' from 'const u64 *' (aka 'const unsigned long
  long *') [-Werror,-Wincompatible-pointer-types]

Use uint64_t for them too. This builds with and without ff049836f05f.

Fixes: ef4102757fdd ("lib/crc: Add 4-way folding in NEON crc64_nvme implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

crc-next is based on v7.4-rc2 and ff049836f05f went into mainline after
rc3, so linux-next will hit this once it merges the two. all-next hit
it already.

Tested on arm64: lib/crc/crc64-neon.o builds with clang and gcc on
crc-next, and with clang on crc-next merged with mainline 4843f6873f7c.
Without this patch the merged tree fails as above.

 lib/crc/crc64-neon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
index 03b46d0abcc41..f36389789fe65 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -11,11 +11,11 @@
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
 /* x^575 mod G, x^511 mod G */
-static const u64 fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
-					   0x62242240ace5045aULL };
+static const uint64_t fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
+						0x62242240ace5045aULL };
 /* x^319 mod G, x^255 mod G */
-static const u64 fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
-					   0xe1e0bb9d45d7a44cULL };
+static const uint64_t fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
+						0xe1e0bb9d45d7a44cULL };
 /* x^191 mod G, x^127 mod G */
 static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 					0x21e9761e252621acULL };

base-commit: ef4102757fdd84b0b6189260780ac5faf132edc7
-- 
2.53.0

