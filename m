Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5814A4D6
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270866; cv=none; b=hXOXkWQTTNyAII7OLymZQCMqHGkNVsqmzFoVh7yf+UtuQYRf0ObLLKGQrN+7Uxhl0/Q54r4L5PxADoWU+4hZCuQH+D1pJR8ppQ3xkV5fWSEMbUlWxqLFFKABBQRcMG7gjBsUIUSyXKWFWWjV/s/GjW13CR7Jtpk1VLb/KdRymL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270866; c=relaxed/simple;
	bh=GoEKPa893/uCpEr4kvBAb6d9NOuE80jGKn8VC/j1+mc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Ao1Fyc9qpRXqntHXBwporQ0+MXQFFuUbOciPt52PQP8ronM14RqtQv8N68Uqyk3l2OaugLTCFApZNFvpBWGFN376p1gPiYdwfNkntvhTElAFvjyePfoL1KhxU+Rkvs/9oaFrR/oIqMwZk4CEHDPG0B4yw5s80Xs8sDyuqhiAw8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfKo-003ipZ-2p;
	Sat, 10 Aug 2024 14:21:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:20:59 +0800
Date: Sat, 10 Aug 2024 14:20:59 +0800
Message-Id: <1399d770a75f0e8b0097fd9499a01d34960ee3d4.1723270405.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1723270405.git.herbert@gondor.apana.org.au>
References: <cover.1723270405.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/4] crypto: dh - Check mpi_rshift errors
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that mpi_rshift can return errors, check them.

Fixes: 35d2bf20683f ("crypto: dh - calculate Q from P for the full public key verification")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/dh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 68d11d66c0b5..afc0fd847761 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -145,9 +145,9 @@ static int dh_is_pubkey_valid(struct dh_ctx *ctx, MPI y)
 	 * ->p is odd, so no need to explicitly subtract one
 	 * from it before shifting to the right.
 	 */
-	mpi_rshift(q, ctx->p, 1);
+	ret = mpi_rshift(q, ctx->p, 1) ?:
+	      mpi_powm(val, y, q, ctx->p);
 
-	ret = mpi_powm(val, y, q, ctx->p);
 	mpi_free(q);
 	if (ret) {
 		mpi_free(val);
-- 
2.39.2

