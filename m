Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020CB3D1716
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241817; cv=none; b=hecjcB91MHyG03XCMQ044L+kHV+IDcePSo+mIxqYZG9TCyMEsXT1AzUhdbv0dZsIRKp09sBi+B5eYOeMRY4ReIvT4XZXsGFWfcqr+FWgAegEJOoGdeDIJaABNMEAel5AWlwn2OKE5YdTPsYkQpnebf6c4QjsDdA4NVh5qhBRcG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241817; c=relaxed/simple;
	bh=iG015FVCN7oPWGVVn9a39BqVhRv1LNNupCbGtz9cTtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wtd6Wm+T02Q8WAFyHCCjH8r3qb8hOskbysUvt8pmlzmjCEb40T6yDM/GO1+7t56kFPBhzS4Bi+zNZ6yc4v7YMij/x6RO7ixg6Q3MYKZrBgtGbmJhv66FV8EjPvFj9kW3OntxDTSplsk5zPFF24jNG6HqkPks6kyzu1Ee9xWWaU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GK3fS4w1; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GK3fS4w1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773241810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y050AoUlwUvE4JwnOIvUs9WWS/VlkQtCxi3b0zHeXK0=;
	b=GK3fS4w1p586rGFvb7W0Kx91572o8m6OQ+CSVZnCR9ApTUCQ8yrd77df/GhVoSJ/oFVAyr
	3cGZFlVwYR8QJLgg66nLiMpi63XJ4jex51Kz/y3Z94JTC3moVU2HrAJ1+rMesFP3VkEbjQ
	dZYlcJAUool8HeK4P2fdtfVvtzxkdZU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Streetman <ddstreet@ieee.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: nx - fix memory leaks in nx842_crypto_{alloc,free}_ctx
Date: Wed, 11 Mar 2026 16:09:24 +0100
Message-ID: <20260311150922.382941-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1901; i=thorsten.blum@linux.dev; h=from:subject; bh=iG015FVCN7oPWGVVn9a39BqVhRv1LNNupCbGtz9cTtI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkbWxe7bCtbbHHYJ3xFb6NL37Kd5yvdrmtMrL9xvfaGG 1937bHUjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjIhRUM/5PqbKvWzPma3PaS 43L5/oz4hYF8y0z2XXKfujJOQ+fF0SeMDC8iZ21rnO+tpM+t9fBq6Z3bLW1/v/DxP+BKWFN4L0G JiwcA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The bounce buffers are allocated with __get_free_pages() using
BOUNCE_BUFFER_ORDER (order 2 = 4 pages), but both the allocation error
path and nx842_crypto_free_ctx() release the buffers with free_page().
Use free_pages() with the matching order instead.

Also, since the scomp conversion, nx842_crypto_alloc_ctx() allocates the
context separately, but nx842_crypto_free_ctx() never releases it. Add
the missing kfree(ctx) in nx842_crypto_free_ctx(), and reuse
nx842_crypto_free_ctx() in the allocation error path.

Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
Fixes: 980b5705f4e7 ("crypto: nx - Migrate to scomp API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/nx/nx-842.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index b61f2545e165..a61208cbcd27 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -115,10 +115,7 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
-		kfree(ctx->wmem);
-		free_page((unsigned long)ctx->sbounce);
-		free_page((unsigned long)ctx->dbounce);
-		kfree(ctx);
+		nx842_crypto_free_ctx(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -131,8 +128,9 @@ void nx842_crypto_free_ctx(void *p)
 	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
-	free_page((unsigned long)ctx->sbounce);
-	free_page((unsigned long)ctx->dbounce);
+	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
+	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
