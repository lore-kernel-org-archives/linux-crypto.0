Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128726F455
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472299; cv=none; b=IMkGmglZFyuql9uw9s1haQ9W0BFcLLLryy6509yY1ljYSkW3deNiXtsplfuwe6BagW4jjqg4xxmuRnKNNSHZdwjjkBcCpukuWAPDK29zwB4cEIqReZXG6x7p6PV1h2MGLtKyfGdhVGbJVs60MwqqdLGcXilsVfe/lSF5Z2M2hik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472299; c=relaxed/simple;
	bh=r3yDby7yXjsAVyww+MMw4x3EvzWVi2TUdNfMMl1qhKk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6wqP0JH2ET8PSFIIIIcijhEHgjhGu7LwuqO0yyY8UJz3aLRrFI7j3h5TOEBOGVs9VI+Jo+8huL/yz/jbgHNIL/KBZKk4QvKf6nmSnSaVvjqiP22H5OYIhGG0Egp3mYuyT6mLVZSeMEU/ZzPoR/PLUmodLbqc3yS3CBlZaWJLRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGJGjIGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGJGjIGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9DAC4CEF2
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=r3yDby7yXjsAVyww+MMw4x3EvzWVi2TUdNfMMl1qhKk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NGJGjIGN1fRERZAtIuvNY/XdLJCx27WoU2OpWX9cHrxItIfcRRg1n7pPiJlnojJ/8
	 2kNZqpIApFYB+5aK4FBlUGe+5DQgxkIcRDq5SvVRfI7ECQbx8N4fHiOOEmIVuSzoZS
	 9QoOGo10sO+qdbVZUMRE7yCKdlGuzlzuSHVTC3gj8ycvC/T1VBj34nSQmiE7VqSDNp
	 8inOKrZGwTMmxKIOLeRbq0/SRxYOPc5OGqundAuqg78LFaXSdwY0cO3sPaxdI55Hqh
	 D7Ql3P4ZEasKakQ91S87/BNN025fIdnUd7aDQhMCmVc3z2F4Zn12AnoEeZNaszF8nR
	 RjhsVlNqfaWtA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 8/8] crypto: null - use memcpy_sglist()
Date: Mon,  5 May 2025 12:10:45 -0700
Message-ID: <20250505191045.763835-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Make null_skcipher_crypt() use memcpy_sglist() instead of the
skcipher_walk API, as this is simpler.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_null.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 48c71b925f37..34588f39fdfc 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -13,10 +13,11 @@
  */
 
 #include <crypto/null.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 
 static int null_init(struct shash_desc *desc)
@@ -58,23 +59,13 @@ static void null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	memcpy(dst, src, NULL_BLOCK_SIZE);
 }
 
 static int null_skcipher_crypt(struct skcipher_request *req)
 {
-	struct skcipher_walk walk;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		if (walk.src.virt.addr != walk.dst.virt.addr)
-			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
-			       walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
+	if (req->src != req->dst)
+		memcpy_sglist(req->dst, req->src, req->cryptlen);
+	return 0;
 }
 
 static struct shash_alg digest_null = {
 	.digestsize		=	NULL_DIGEST_SIZE,
 	.setkey   		=	null_hash_setkey,
-- 
2.49.0

