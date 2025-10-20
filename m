Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9C23E320;
	Mon, 20 Oct 2025 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921619; cv=none; b=C5JjdyW6S5JoHrphHJZ+oJWzAFmCWL6GA8TiTyoEAn7BWEp1MSRNzAife3QbBdveN+n5D7e0t3EyD1zzBnf5hzqIGgMUCl8fb6DQ5YzCc0ORsQl7MtzK03lrfP0Bm0wY/61XlyvqISKaWFX+eKTFTxyHI40Cw04Q1plPlxJo3BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921619; c=relaxed/simple;
	bh=C2S+qsv86X6YHw0RsYoz1ghvx9MVynx7qbxPFYMhHRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh+B59XlZelUgt5qK0O9r6RXRvnJrJ5w/E8a6qj8UVpg/5sTR0+JpFvTh5YKwswAGbmn8TvcwApFl7JFxLdnA9yexr5cQSwHa+OKenKOHu6jG2FrofEhJzEpj4Dd7ULFJM6/6lqohc5Su/QxnmvgABrlcb/uVjx5sS4DGGhT134=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btBxdSoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btBxdSoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F10C116D0;
	Mon, 20 Oct 2025 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921618;
	bh=C2S+qsv86X6YHw0RsYoz1ghvx9MVynx7qbxPFYMhHRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btBxdSoKK8eYo3dLvauelp0i1L3qqEStWYUk3UWxMcbn+VLvQcBpCicN0lqNtUvfL
	 b72Ofqo+Qobk3gyo8/SYRFBVjb16+TEDVc3e07Nd59SbNJzZDJSldkTWua7lXgvYZ7
	 hGA+RnNVhh2BLaQq+Jgb5Z0J5KfF6LNb3dqpaZ/wPhq43KGEI+tqDGvnrsTewNKnk/
	 Mqr4vRGZSUv4+FZPZ5P0hJs4Fjwh+ogDkkZU2Kirgcvdj4DLOYhY083846AAWRmvet
	 kMnHKLRVfhGnz+nw1FZJJOWyBLlYRpmRZM0tF4aMQ/HTl2J0ExvYgonVCIrZQJorMs
	 axuWAhPVFSguw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/17] crypto: jitterentropy - use default sha3 implementation
Date: Sun, 19 Oct 2025 17:50:37 -0700
Message-ID: <20251020005038.661542-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make jitterentropy use "sha3-256" instead of "sha3-256-generic", as the
ability to explicitly request the generic code is going away.  It's not
worth providing a special generic API just for jitterentropy.  There are
many other solutions available to it, such as doing more iterations or
using a more effective jitter collection method.

Moreover, the status quo is that SHA-3 is quite slow anyway.  Currently
only arm64 and s390 have architecture-optimized SHA-3 code.  I'm not
familiar with the performance of the s390 one, but the arm64 one isn't
actually that much faster than the generic code anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index a53de7affe8d1..7c880cf34c523 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -46,11 +46,11 @@
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
 
 #include "jitterentropy.h"
 
-#define JENT_CONDITIONING_HASH	"sha3-256-generic"
+#define JENT_CONDITIONING_HASH	"sha3-256"
 
 /***************************************************************************
  * Helper function
  ***************************************************************************/
 
@@ -228,19 +228,11 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	struct shash_desc *sdesc;
 	int size, ret = 0;
 
 	spin_lock_init(&rng->jent_lock);
 
-	/*
-	 * Use SHA3-256 as conditioner. We allocate only the generic
-	 * implementation as we are not interested in high-performance. The
-	 * execution time of the SHA3 operation is measured and adds to the
-	 * Jitter RNG's unpredictable behavior. If we have a slower hash
-	 * implementation, the execution timing variations are larger. When
-	 * using a fast implementation, we would need to call it more often
-	 * as its variations are lower.
-	 */
+	/* Use SHA3-256 as conditioner */
 	hash = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
 	if (IS_ERR(hash)) {
 		pr_err("Cannot allocate conditioning digest\n");
 		return PTR_ERR(hash);
 	}
-- 
2.51.1.dirty

