Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B91CDFAC
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105697; cv=none; b=N3eLtNh5FPf9GvZ4A7jDZhpMdeCe1C9z5IyU9/lcEpt+viLv08LxReMR73WNfPEb4fjjuPG5/pBC5AsUwmw8C+Wu2IUGMrCoFO7p6stDccY9aCLVNnaSr+65g3RSGKKpTEUHAgINdardVY+6/DlMbb0D8OFnOXq1mmBifIdLh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105697; c=relaxed/simple;
	bh=8yRyZ1QAEdW46ahp8GvBm7MgvLA8k+bDmW4nCd3mjks=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+drioRNP7i4+Jsm6YpMzPsGjQ/8BLIHNmN88yeObChMlDlU84rlllH5NiNEazz11/Sz/6X+FqkcE/JAcomuEBVHfiQVsFPEcFf6+QAs/gb97EQj3VwbMpoSHA4xclikczr/c0OGNkur7F3pplnqOo26bV5QbPZf08VQQ+28pgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzyD+Jq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzyD+Jq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBA6C4CEE3
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105696;
	bh=8yRyZ1QAEdW46ahp8GvBm7MgvLA8k+bDmW4nCd3mjks=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FzyD+Jq8YC1G0UEFNZcWMZafBMEgVKGtLeN+EdPSuh3abriRbsDRWc6RB+d9qgj2/
	 CpOSua1fyj1avfYrQvhTPVOGdubNnXTzypkB6pVMChAVn5nJXWclag/SycFUngzWcu
	 UYqzjx5vNMe5AljaGqQzU+MQGBJLsYT4ofoAZPwd0kPUiU/6BWjlQF4vB+vcii+p+E
	 +wa9oOxdhxUxIQxtZkeRC2ea2QQ6ZDfq5IaALMqdx8tCIx7FjvyCdsMyw3+YXdu1Ug
	 8857GSbvann7ThXqGhEihnXVTudYYOmbDC/GO5eK5XH3oi0YP0UIo6s3Ma3YInaXWA
	 weuuCb0Qx2YPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 7/8] crypto: skcipher - optimize initializing skcipher_walk fields
Date: Sun,  5 Jan 2025 11:34:15 -0800
Message-ID: <20250105193416.36537-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250105193416.36537-1-ebiggers@kernel.org>
References: <20250105193416.36537-1-ebiggers@kernel.org>
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
 crypto/skcipher.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e54d1ad46566..6b62d816f08d 100644
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
@@ -326,13 +326,18 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->ivsize = crypto_skcipher_ivsize(tfm);
-	walk->alignmask = crypto_skcipher_alignmask(tfm);
+	/*
+	 * Accessing 'alg' directly generates better code than using the
+	 * crypto_skcipher_blocksize() and similar helper functions here, as it
+	 * prevents the algorithm pointer from being repeatedly reloaded.
+	 */
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->ivsize = alg->co.ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
@@ -342,11 +347,11 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
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
@@ -364,14 +369,19 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
 
 	scatterwalk_done(&walk->in, 0, walk->total);
 	scatterwalk_done(&walk->out, 0, walk->total);
 
-	walk->blocksize = crypto_aead_blocksize(tfm);
-	walk->stride = crypto_aead_chunksize(tfm);
-	walk->ivsize = crypto_aead_ivsize(tfm);
-	walk->alignmask = crypto_aead_alignmask(tfm);
+	/*
+	 * Accessing 'alg' directly generates better code than using the
+	 * crypto_aead_blocksize() and similar helper functions here, as it
+	 * prevents the algorithm pointer from being repeatedly reloaded.
+	 */
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->stride = alg->chunksize;
+	walk->ivsize = alg->ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	return skcipher_walk_first(walk);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-- 
2.47.1

