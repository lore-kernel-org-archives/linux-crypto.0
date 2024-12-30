Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73361369A8;
	Mon, 30 Dec 2024 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517761; cv=none; b=iTbaacasC0sXjPrLg2ZtpHrZKq9c79YvBfmwK7eRsnVFEKxSPBvH+zFfvzsNrWw+dwRkxI2feqzAQxjxWsMAJodD6lHf8w7L6Ctr5Rm3Ok/S6gWuktimwMp/txax1zXHLU5pMV80QdFifkEmsTlkgLwbJ/Ct5MdKpoBtwv9VlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517761; c=relaxed/simple;
	bh=6EPGGWMvq5sU1DZayuB4lsmsIXL+PbHsRHle3o9unzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toxzF+NZv+A2+ZI71TwHy1e4LfzW2gCF9apafy/y5Klw4sRwnr1hDUrWbsaiYCxU/Q74wQbWTLOYPawL3SBaKdmrUrR+JepvrcQLKoxgSlR9NwXBOxGWgfmeEuFA9cOjck4Aj6GIyIYAqqsqIvxD0VtkIWZHaVEbP/8a7m91y+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJT7yIN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJT7yIN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09F7C4CED7;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517761;
	bh=6EPGGWMvq5sU1DZayuB4lsmsIXL+PbHsRHle3o9unzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJT7yIN/x8Vbgl7vzKa9DUFxpKxXjlDYqBOoweuzubcg++adAVauicPe2irkETNiy
	 N9V9A9vWCBKLle2tPEBRkbJDUoHnOWyELog2V+VF7GXYDTJBXlvMM5LqI3Y/YVVPdZ
	 1pgUPOSEngfZ7gg4Rxu/QCdGCMfWuyODgVEgfQMU/g89XOhx2ytO0wvQR6RiT0lYlX
	 O11YiZT1b737V4FIn7qc64mgHq42Uk5CBY12oOH9kld/VUC/pjUiG2QZa0S2HuAOz/
	 Ajefs/fJHAXmfUgBLX81s4v3i7n8gYaYIvjz/H3vw/jAJ0VNgIN1ESbeyR8zS3SrZl
	 OS2Qu2BGpTSnw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/29] crypto: skcipher - optimize initializing skcipher_walk fields
Date: Sun, 29 Dec 2024 16:13:56 -0800
Message-ID: <20241230001418.74739-8-ebiggers@kernel.org>
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

The helper functions like crypto_skcipher_blocksize() take in a pointer
to a tfm object, but they actually return properties of the algorithm.
As the Linux kernel is compiled with -fno-strict-aliasing, the compiler
has to assume that the writes to struct skcipher_walk could clobber the
tfm's pointer to its algorithm.  Thus it gets repeatedly reloaded in the
generated code.  Therefore, replace the use of these helper functions
with staightforward accesses to the struct fields.

Note that while *users* of the skcipher and aead APIs are supposed to
use the helper functions, this particular code is part of the API
*implementation* in crypto/skcipher.c, which already accesses the
algorithm struct directly in many cases.  So there is no reason to
prefer the helper functions here.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e54d1ad46566..7ef2e4ddf07a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -306,12 +306,12 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 }
 
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req, bool atomic)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	const struct skcipher_alg *alg =
+		crypto_skcipher_alg(crypto_skcipher_reqtfm(req));
 
 	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
@@ -326,13 +326,13 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->ivsize = crypto_skcipher_ivsize(tfm);
-	walk->alignmask = crypto_skcipher_alignmask(tfm);
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->ivsize = alg->co.ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
@@ -342,11 +342,11 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
 static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 				     struct aead_request *req, bool atomic)
 {
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aead_alg *alg = crypto_aead_alg(crypto_aead_reqtfm(req));
 
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
@@ -364,14 +364,14 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
 
 	scatterwalk_done(&walk->in, 0, walk->total);
 	scatterwalk_done(&walk->out, 0, walk->total);
 
-	walk->blocksize = crypto_aead_blocksize(tfm);
-	walk->stride = crypto_aead_chunksize(tfm);
-	walk->ivsize = crypto_aead_ivsize(tfm);
-	walk->alignmask = crypto_aead_alignmask(tfm);
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->stride = alg->chunksize;
+	walk->ivsize = alg->ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	return skcipher_walk_first(walk);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-- 
2.47.1

