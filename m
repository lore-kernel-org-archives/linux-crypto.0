Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7740030E853;
	Fri, 20 Jun 2025 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750447198; cv=none; b=F/CWHYWmltUsQ7bpwruSWUdRhrJahRK6wdBhWJHThND9Ro0nji7xtYLAIP7ze1Zss1H+QEu+6OvxApjZgFBWEMQJgxUxTVD0hATZdYWhaDmRyLKQAd2g9nM5xVErUiRRJ75/95MGw1BLBjjCFiDmPeWKNKSNW+RDMf2tWOg8sRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750447198; c=relaxed/simple;
	bh=YnPugOlKBkZsipaxpJUkRDOmptnSMllqfgNPFnEgzZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B0cSgtZGpSQIl0yHhpgT4hLrb5lzb8FQ1aQmvC4zQIyVVzuD9DwLVsKd4Z6sjW5uErbDjEocmnFEgmLEbUyqrCWQexdgONDLCLk/7DgUfJZ+PIoy+KVv68omaxEf4AR0lbbCvAfgzLhAy9weRknFMZ66MIMLiT5BjjiTCkwLnys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aw1gKd3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aw1gKd3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36E5C4CEE3;
	Fri, 20 Jun 2025 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750447198;
	bh=YnPugOlKBkZsipaxpJUkRDOmptnSMllqfgNPFnEgzZk=;
	h=From:To:Cc:Subject:Date:From;
	b=Aw1gKd3aQAHeWeQBb/M7frgwauHI2tsmUeB/zEdAd+7+Kp60+ypQTEQ/f50JSVD2H
	 /O5jxWEEjVpG0YZ1kh2Q5H1SgnbNkHdHz8V6xo2eSdwiPkLIILOuwZoy0veP6isgMG
	 Pe7S/cBRb4Ju0oEjj2QzSDu3u7KsopcjnUnyl7dIxxEDRZkPudrj5/922AihqRrZPv
	 1J7ylsCnfq83JstsbfpCPnhpru5j/Umuk8vOuSDvhPajVl5Nwz6acK3Mjf4si2rpw5
	 WwL0rMMQepzmJQ2qnh5dP6uM8N+CHHSodAE0o3J1lW2iHVAKqZ5M9we79fr1qBtd/v
	 6jgQ6sQ/3egNQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sha256 - mark sha256_choose_blocks as __always_inline
Date: Fri, 20 Jun 2025 21:19:40 +0200
Message-Id: <20250620191952.1867578-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

When the compiler chooses to not inline sha256_choose_blocks() in
the purgatory code, it fails to link against the missing CPU
specific version:

x86_64-linux-ld: arch/x86/purgatory/purgatory.ro: in function `sha256_choose_blocks.part.0':
sha256.c:(.text+0x6a6): undefined reference to `irq_fpu_usable'
sha256.c:(.text+0x6c7): undefined reference to `sha256_blocks_arch'
sha256.c:(.text+0x6cc): undefined reference to `sha256_blocks_simd'

Mark this function as __always_inline to prevent this, same as sha256_finup().

Fixes: ff8f037d394f ("crypto: sha256 - Use the partial block API for generic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This is likely compiler specific, I found it in randconfig testing using
gcc-9.5 on x86.
---
 include/crypto/internal/sha2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index b9bccd3ff57f..21a27fd5e198 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -25,7 +25,7 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks);
 
-static inline void sha256_choose_blocks(
+static __always_inline void sha256_choose_blocks(
 	u32 state[SHA256_STATE_WORDS], const u8 *data, size_t nblocks,
 	bool force_generic, bool force_simd)
 {
-- 
2.39.5

