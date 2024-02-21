Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91533A35
	for <linux-crypto@vger.kernel.org>; Wed, 21 Feb 2024 05:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708492756; cv=none; b=lDqRqzaOpCfKwb8IjJb/Du6kVGLlKvyx9oiIuthMipTLC9RyCfPoAUieTsA2mc+EksFejbifdY0UcZOuNBaFRMnDoOC7DOv8aRYwW5rgztMt9u9TpTEXTcyvZEIDv9GQhmfR+2jgC8VtBAlFwRRO+uAVe3KU1e55idmn912qNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708492756; c=relaxed/simple;
	bh=a630WBtM15Lun9BatAeO/yXInRGZCfYm0X/zw7kuh2s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ahdd8w4x+PUZEznAgkAieshCHnjAXVcx+rBr2EJiihC62blngvjaQVXnHEj3k3VD9qYCrQRPN3WxYSke6n2H4lXAZjUpvL5PTAr5yTu7pIZSjuBJBiWZFnoDQ9PfU/SGkhlqruHu2dKO/PJN73OLfnH2L05cQ7itDsxFZo0Gnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rcf0X-00FwdQ-7G; Wed, 21 Feb 2024 13:19:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 Feb 2024 13:19:15 +0800
Date: Wed, 21 Feb 2024 13:19:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Nicolai Stange <nstange@suse.de>, Hannes Reinecke <hare@suse.de>,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: dh - Make public key test FIPS-only
Message-ID: <ZdWH02dVyhgw7fmr@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The function dh_is_pubkey_valid was added to for FIPS but it was
only partially conditional to fips_enabled.

In particular, the first test in the function relies on the last
test to work properly, but the last test is only run in FIPS mode.

Fix this inconsistency by making the whole function conditional
on fips_enabled.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/dh.c | 63 +++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 0fcad279e6fe..68d11d66c0b5 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -106,6 +106,12 @@ static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
  */
 static int dh_is_pubkey_valid(struct dh_ctx *ctx, MPI y)
 {
+	MPI val, q;
+	int ret;
+
+	if (!fips_enabled)
+		return 0;
+
 	if (unlikely(!ctx->p))
 		return -EINVAL;
 
@@ -125,41 +131,36 @@ static int dh_is_pubkey_valid(struct dh_ctx *ctx, MPI y)
 	 *
 	 * For the safe-prime groups q = (p - 1)/2.
 	 */
-	if (fips_enabled) {
-		MPI val, q;
-		int ret;
-
-		val = mpi_alloc(0);
-		if (!val)
-			return -ENOMEM;
-
-		q = mpi_alloc(mpi_get_nlimbs(ctx->p));
-		if (!q) {
-			mpi_free(val);
-			return -ENOMEM;
-		}
-
-		/*
-		 * ->p is odd, so no need to explicitly subtract one
-		 * from it before shifting to the right.
-		 */
-		mpi_rshift(q, ctx->p, 1);
-
-		ret = mpi_powm(val, y, q, ctx->p);
-		mpi_free(q);
-		if (ret) {
-			mpi_free(val);
-			return ret;
-		}
-
-		ret = mpi_cmp_ui(val, 1);
+	val = mpi_alloc(0);
+	if (!val)
+		return -ENOMEM;
 
+	q = mpi_alloc(mpi_get_nlimbs(ctx->p));
+	if (!q) {
 		mpi_free(val);
-
-		if (ret != 0)
-			return -EINVAL;
+		return -ENOMEM;
 	}
 
+	/*
+	 * ->p is odd, so no need to explicitly subtract one
+	 * from it before shifting to the right.
+	 */
+	mpi_rshift(q, ctx->p, 1);
+
+	ret = mpi_powm(val, y, q, ctx->p);
+	mpi_free(q);
+	if (ret) {
+		mpi_free(val);
+		return ret;
+	}
+
+	ret = mpi_cmp_ui(val, 1);
+
+	mpi_free(val);
+
+	if (ret != 0)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
