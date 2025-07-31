Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FE15533F;
	Thu, 31 Jul 2025 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991510; cv=none; b=MC6mOEZeJgjBw/d8qLPiR4FK6ffr+Bb6KgCmOAPjvrn7OzRjBB4gi5wYBCLPLiWSFOvZCC5//Am+2yPBAgUocxRAi2hLvSlbycXmvy+7HSGpfpYXMwa9shGDmIUUfbJXXYuzIW5+w9/4MnqeN32djeGWo2CF6FPT1tgh1VI+WuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991510; c=relaxed/simple;
	bh=1qfpjMOR5vF3iZR9DfglRY8NdvKOMGgslvAE/13smbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FGOux3QHcW9ysNc/rKn2l2F9c1Pfjq+OZA5s4x6mM5K+pNO3MKKZYO8TijTkHpSRafJaSs9oyKfwDlzxz/uLCaiZszoDZTuJUbsAj5pEHOjkOPnDMtI8iFiQGBVDKAMCJedoPMq716jg5pk44GdVSN3P9vIRIFglh5EqPs6w2jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMh8iAjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMh8iAjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87110C4CEEF;
	Thu, 31 Jul 2025 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753991510;
	bh=1qfpjMOR5vF3iZR9DfglRY8NdvKOMGgslvAE/13smbI=;
	h=From:To:Cc:Subject:Date:From;
	b=fMh8iAjJIY9hpRrLsQi9rcA2U5YxO6+Q3GXsKqXbR5eZ8epkFgScT7KlWdhF5gUNl
	 wd5tO3+hyOa/b6L3280JZsr0crgiuSUoaDCBYUYCz+zfmUyx8Zvd2LvhUndIIIdvMG
	 cWSD6zmJetD82vubKyF3wLBVowt2gIDpumaacSZQxUg8ZtndGUVBr7aweB1zf/+NuR
	 N8RgffbURpsVWynN5YksLekyDkprDgdFXRbd1IcvxvpYfV70IIz3+S0Ex+vp24FP0G
	 2UYBvXh0JtI0drr4/NHyg8gVDgwgd5EGHm7Pwtit88TnC0Xz2hG1TQTTfj00F62ptK
	 u6MX2Zmw1DJ+g==
From: Eric Biggers <ebiggers@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	netdev@vger.kernel.org,
	mptcp@lists.linux.dev
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net] mptcp: use HMAC-SHA256 library instead of open-coded HMAC
Date: Thu, 31 Jul 2025 12:50:54 -0700
Message-ID: <20250731195054.84119-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there are easy-to-use HMAC-SHA256 library functions, use these
in net/mptcp/crypto.c instead of open-coding the HMAC algorithm.

Remove the WARN_ON_ONCE() for messages longer than SHA256_DIGEST_SIZE.
The new implementation handles all message lengths correctly.

The mptcp-crypto KUnit test still passes after this change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mptcp/crypto.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index b08ba959ac4fd..31948e18d97da 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -20,11 +20,10 @@
  *       Brandon Heller <brandonh@stanford.edu>
  */
 
 #include <linux/kernel.h>
 #include <crypto/sha2.h>
-#include <linux/unaligned.h>
 
 #include "protocol.h"
 
 #define SHA256_DIGEST_WORDS (SHA256_DIGEST_SIZE / 4)
 
@@ -41,43 +40,13 @@ void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn)
 		*idsn = be64_to_cpu(*((__be64 *)&mptcp_hashed_key[6]));
 }
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 {
-	u8 input[SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE];
-	u8 key1be[8];
-	u8 key2be[8];
-	int i;
+	__be64 key[2] = { cpu_to_be64(key1), cpu_to_be64(key2) };
 
-	if (WARN_ON_ONCE(len > SHA256_DIGEST_SIZE))
-		len = SHA256_DIGEST_SIZE;
-
-	put_unaligned_be64(key1, key1be);
-	put_unaligned_be64(key2, key2be);
-
-	/* Generate key xored with ipad */
-	memset(input, 0x36, SHA256_BLOCK_SIZE);
-	for (i = 0; i < 8; i++)
-		input[i] ^= key1be[i];
-	for (i = 0; i < 8; i++)
-		input[i + 8] ^= key2be[i];
-
-	memcpy(&input[SHA256_BLOCK_SIZE], msg, len);
-
-	/* emit sha256(K1 || msg) on the second input block, so we can
-	 * reuse 'input' for the last hashing
-	 */
-	sha256(input, SHA256_BLOCK_SIZE + len, &input[SHA256_BLOCK_SIZE]);
-
-	/* Prepare second part of hmac */
-	memset(input, 0x5C, SHA256_BLOCK_SIZE);
-	for (i = 0; i < 8; i++)
-		input[i] ^= key1be[i];
-	for (i = 0; i < 8; i++)
-		input[i + 8] ^= key2be[i];
-
-	sha256(input, SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE, hmac);
+	hmac_sha256_usingrawkey((const u8 *)key, sizeof(key), msg, len, hmac);
 }
 
 #if IS_MODULE(CONFIG_MPTCP_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(mptcp_crypto_hmac_sha);
 #endif

base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

