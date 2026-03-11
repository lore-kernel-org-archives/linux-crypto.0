Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF2C3DE435
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773244682; cv=none; b=jH909PrgzhaYyEOxYJuNfEViB5nauLS+zd9IMFytyjlw3+f36selZZY1WRoJukliBxocYJ03zOROrVpbmlb2Lf8IX3+wllQUzQm0AhHwfFXIfCicrrCIoL+nKEMhU29XVZc5OevwrKoUTVYVfs3Fl8gNZ9PEMgr/YndhjwSLUSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773244682; c=relaxed/simple;
	bh=0iwtMNI63Hs2PgwaAlMQcHtzeFgUFC5l6Bpz+slaTMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GojSJK/DYX18+yfMpMtJyB5r1AtFiSaVeZpvMGpQdabPXUWJ/Nc1GbT8KPiOkGcLG4nXC491TA9WtOpFRAKuBJDRK0OvXmxN59Li3ZPpcW5Rh1nziZsMurS6oGwitiZU9IIZkxMFRE51JhgQ068lekPYEp4e6jC9uND6w8d8vbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SJkP0Xj1; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SJkP0Xj1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773244667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=waVdawZ7reu9virZQC5u0WAfRzxcEnY69LNf+GxNlGc=;
	b=SJkP0Xj17dlhlRy4MzuUoYOTXtrg/cq+QhPBH7F0wWZdcjLVV1MGkoNGKSSL0SepvSOYd4
	0GbF1Xv8uDoSRoV/edJC+uv06RSfkXS1ksLaQ4QqOIn4ReWISopXdwLKCLf2xOjQzFGGBW
	E8M8XZ72vlGwyLFvhCOp95xAyMBUAQ8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Streetman <ddstreet@ieee.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx
Date: Wed, 11 Mar 2026 16:56:47 +0100
Message-ID: <20260311155645.397083-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1580; i=thorsten.blum@linux.dev; h=from:subject; bh=0iwtMNI63Hs2PgwaAlMQcHtzeFgUFC5l6Bpz+slaTMQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkbJ+wTbzm1KNJk18NJb5lVDewZ+re6nu1i11x1RaRv2 oSVmxN3dJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEfs5jZFjO/2xe2OLUd7lR Ukr7nkit/BOyzlS51mTW7XmZS1yjMxsZ/me+b/76o+YiT6mZefTi4+Gzvty9zX1np9oHlq+qz4K FzzICAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The bounce buffers are allocated with __get_free_pages() using
BOUNCE_BUFFER_ORDER (order 2 = 4 pages), but both the allocation error
path and nx842_crypto_free_ctx() release the buffers with free_page().
Use free_pages() with the matching order instead.

Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/nx/nx-842.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index b61f2545e165..661568ce47f0 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,8 +116,8 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
-		free_page((unsigned long)ctx->sbounce);
-		free_page((unsigned long)ctx->dbounce);
+		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -131,8 +131,8 @@ void nx842_crypto_free_ctx(void *p)
 	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
-	free_page((unsigned long)ctx->sbounce);
-	free_page((unsigned long)ctx->dbounce);
+	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
