Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E6F298CA5;
	Sun, 26 Oct 2025 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457990; cv=none; b=o6JFKDsfsE6CyBxFb1PTphPCNorHOfOS7gCW512klsZtPf8A1H2iB4qZ5pwJs+mGhQpHy6qMO+4aAvW6kzg5+7gotrsDbOMPgGYBP6cT9obeG4zh2OCJ6+iivR54TkvVze00sG16iFELOTZp10cC1SuRk4abAMs4fDoFLhJeCOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457990; c=relaxed/simple;
	bh=J3m+RqWldOSAlbAr+elclDhB5NSc/+pHmiWDmVt7Zz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNQmTLdwVymRe40RyU0Lb2ztocO+Qs64K5NXCG4dcmrp0KeNn71floBRlA49QmBKAShzJWH1BgxGg0i9KtXg8L3ZPTBR2pypYsUgR4+XL3J/t3Fdy4RhkWc1upUn26QXE3xl+inZrUgCpduilX7//vFo8308xvbOXp79pmYM4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJWEPIXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJWEPIXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBC1C4CEE7;
	Sun, 26 Oct 2025 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457989;
	bh=J3m+RqWldOSAlbAr+elclDhB5NSc/+pHmiWDmVt7Zz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJWEPIXQJVdiF8om1EtHzN8GX9OBPNVfzf2bgq3sTdtKwrz3f5gMcKWNV3fJW3aId
	 FQgVyV5Nq8FwB4EVlMSZ2dgwXr6JWPzyQpRysrgBNptPeidPWzySe9sCEcAzCHgd46
	 wmFyiTVTrbUTd9lnxhdBncQ6tpkZ5wwQKND0af8Oo5rpoFoPMKAY2UBbkh/ExT620y
	 mon9WeI8757GA5SKwNN9FC4UJ6gz853GlVrykUPmtNQ3pE0FwFGtVQ1lypnXh26l85
	 yY+p7BuEsxsmvbc2PS0erCbH1bB4KZYL1AigdrHD1iPXQkMHFMRXFqy4wayfpB9cJu
	 N2dD2j64H0kvQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/15] crypto: jitterentropy - Use default sha3 implementation
Date: Sat, 25 Oct 2025 22:50:30 -0700
Message-ID: <20251026055032.1413733-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
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

Note that jitterentropy should just use the library API instead of
crypto_shash.  But that belongs in a separate change later.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
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

