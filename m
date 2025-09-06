Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A42D130A;
	Sat,  6 Sep 2025 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194628; cv=none; b=hOF/0KhpbHT1xZqE6UdbNj1vhNRW9FWwCzt5ICsY1r6R+Enq5tztFMNkBQHR62+6zaLtZLx5URMzGpcAlXM7uFLkewPVBkAr5UOhtvnZ3645SUrP17u1FsmljvA3H6FohCsSYULQsQEZ5EYr5GjWIDsu2ugZey8X6OJ/QR8YmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194628; c=relaxed/simple;
	bh=JTwVCxO7VQKt0pRSCgeHeHvmX5quhsNXXzZV2f26Bs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soG70zQYBtjrnTbPRgmDCCBjRNHJbnsHWTQkW3J12Xiuu1c4EZHM5n8j/WAbM+/8Y8A1T3ZkMpcFFTt37Nck8gtFro9CHuSxLHJEQlsdAeZoTFpraCRBqi3mQe33U0DKwXxBy9R6DpG+L2uvBzKorJ5YcWhiKiEH++CJdAB/9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIjnKxH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIjnKxH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D6FC4CEE7;
	Sat,  6 Sep 2025 21:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194628;
	bh=JTwVCxO7VQKt0pRSCgeHeHvmX5quhsNXXzZV2f26Bs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIjnKxH09OTN1s3TO5OkyZTYLxVqeC7VxU8nQKQBpGN/Fp3rPUrW0n+2bbZB8zzHO
	 AM3Jbi3sTFeW+TtxRT/DDlpUtp2nU3AsNxgqi3J9QOr95cH4ApNZisj4U8uyWcTX9J
	 oIUv1b9OFpCv+lF6lcDbX7MRLUeU9QQQf3jMAwVmuUuVNZ4nBBi2E9UrIgfPoWqKks
	 rp25asjGBdt0WoQPVjykGqKwMURs6fc94N8vFJE6fVqLvc6WjT4BBmwHtxgcDe8YcQ
	 6/frNrko95cghzRkUomIuPn5fGIpDZcwvymzk8m+EMawZ4vDT4WQb8PO0vmvXDURHL
	 twswbfGWpHfKw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 12/12] wireguard: kconfig: Simplify crypto kconfig selections
Date: Sat,  6 Sep 2025 14:35:23 -0700
Message-ID: <20250906213523.84915-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the kconfig entry for WIREGUARD:

- Drop the selections of the arch-optimized ChaCha20, Poly1305, BLAKE2s,
  and Curve25519 code.  These options no longer exist, as lib/crypto/
  now enables the arch-optimized code automatically.

- Drop the selection of CRYPTO.  This was needed only to make the
  arch-optimized options visible.  lib/crypto/ now handles these options
  internally, without any dependency on CRYPTO.

- Drop the dependency on !KMSAN.  This was needed only to avoid
  selecting arch-optimized code that isn't compatible with KMSAN.
  lib/crypto/ now handles the !KMSAN dependencies internally.

- Add a selection of CRYPTO_LIB_UTILS, since WireGuard directly calls
  crypto_memneq().  This gets selected indirectly by
  CRYPTO_LIB_CURVE25519 and CRYPTO_LIB_CHACHA20POLY1305 anyway, but it's
  best to make this dependency explicit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/Kconfig | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b29628d46be9b..ac12eaf11755d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -74,28 +74,15 @@ config DUMMY
 
 config WIREGUARD
 	tristate "WireGuard secure network tunnel"
 	depends on NET && INET
 	depends on IPV6 || !IPV6
-	depends on !KMSAN # KMSAN doesn't support the crypto configs below
 	select NET_UDP_TUNNEL
 	select DST_CACHE
-	select CRYPTO
 	select CRYPTO_LIB_CURVE25519
 	select CRYPTO_LIB_CHACHA20POLY1305
-	select CRYPTO_CHACHA20_X86_64 if X86 && 64BIT
-	select CRYPTO_POLY1305_X86_64 if X86 && 64BIT
-	select CRYPTO_BLAKE2S_X86 if X86 && 64BIT
-	select CRYPTO_CURVE25519_X86 if X86 && 64BIT
-	select CRYPTO_CHACHA20_NEON if ARM || (ARM64 && KERNEL_MODE_NEON)
-	select CRYPTO_POLY1305_NEON if ARM64 && KERNEL_MODE_NEON
-	select CRYPTO_POLY1305_ARM if ARM
-	select CRYPTO_BLAKE2S_ARM if ARM
-	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
-	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
-	select CRYPTO_POLY1305_MIPS if MIPS
-	select CRYPTO_CHACHA_S390 if S390
+	select CRYPTO_LIB_UTILS
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
 	  designed to be fairly general purpose and abstract enough to fit most
 	  use cases, while at the same time remaining extremely simple to
-- 
2.50.1

