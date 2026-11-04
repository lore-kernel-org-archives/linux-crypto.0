Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780480;
	b=S3g5uZB9sbJd/kH2z0i1eof8o0e2VdiXPIy7ydDloAWyB3hMhTJXcO7JqLHEMV/11KIM
	 CiJ+//+dzhWTFNCidBqWDXDnIU/SqizGBStzG3jmMBM7l73xWaun043lclHpfT2LD+CJV
	 fZJ9b3wba8kOIuxKxu/GIQMD/X3bl4TVEZwh9kzvqr2uG5f0vJo+/ExF69HrxKwtj29bf
	 Wbm7idAB//GnbjP26CC5YBSHVfs51GEVY4gXGNbu/5H2nsb/QaIbOF0Et2GmFslOKo68Y
	 4AbV2ijv2QV6a0zuyhntrIETjB7wea8eetggJDk4NtL3NhVt7H2ynOPHOSWhNLBIeMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=ac3vQm60eefOjTiS1SnXPDH3n3Aophdy9eMgLKQ4HvE=;
	b=fjALaaXVLOGRzlP3rkCaI5acMCFJX32nlYd/x4JEFDULeF7fR8NuqCmD5BIOJKCF1PFh
	 ZzqiT3UtjIiXqPtINP9iVWdGe6urImMwTAUAhr7mMyIbcK16zTEV4BzRsifxCp5uWsmuQ
	 VWi29WMJeOCbWsc6wYhMB1ojBc94m+vlL6BYRczrxQ6sUMWTFQ+VPaypBtkm6W9W6x41Y
	 7jYal+VmvYttHZRoUmQbJOvNDzWsbnD4X+eU0+7eKOU8PhEUKK/gYlyj6dMc+4HoASx7p
	 i+kvxErjLKW8UQn2fgMXkLclmHx4pNPqiAf+zBlY4b/P9grrPf7hHS7KxBRQfVB2fiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq5J93LY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E177D606A31B;
	Wed,  4 Nov 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq5J93LY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4451F000C1;
	Wed,  4 Nov 2026 08:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780479;
	bh=ac3vQm60eefOjTiS1SnXPDH3n3Aophdy9eMgLKQ4HvE=;
	h=From:To:Cc:Subject:Date;
	b=Dq5J93LYAM2DwA7K33i4YNT0Hnn+pZmpDX/nL6S8RCkJeN7lj4HLeAIRwsSdvblbH
	 L/S8N3JejdFfBtPq9TelFXZ9LRUjQh9KHooxe+us4/ly6vTWhVYoo8nmMtlMz5q6Ng
	 fDIt/rMHOymn1OjBnbOWzLixQh2p2Gd0CI2BUOeiJAYv9LpzwUMs6Ur0O3RWDUA8T3
	 JHeDcUDaXIfd32InS/PfFwczEKsBUuV8xUHa9nnBUAALxU9m5CeYqo1wKqRNoKLhRk
	 a89yX0MPQLwRGabpsX1kx6ZL3Sni6LeXtrpPTiyXWDBKZwxYorc/Qwo5BbStpzgi7e
	 vt9p8rAZVJvMQ==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sa2ul - avoid rollback in sa_init_ctx_info()
Date: Wed,  4 Nov 2026 09:20:56 +0100
Message-ID: <20261104082056.47165-2-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1484; i=blum@kernel.org; h=from:subject; bh=0yXTZDXZZWHCigMPCujSW0HTsjL0Fpp21XVCUGS8grY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvXr3I3h958WV44T+JXN5Fi7T1b3sV23+f4b/wlim/C V/3yyKtjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZgIlwfDLybPy1o3bTZPLpl7 tT+zreyq8eE6PlHhCaKrhKY/MJq2UZnhr5DsvyPTLh9TzXB4v3cdZ6Vt7jEFQ9amxOCZhxOun3i ynhcA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Allocate the security context before reserving a security context ID to
avoid the rollback on allocation failure. Remove the now-unused local
error variable.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/sa2ul.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index e026fc14a411..964ddadaa211 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -748,7 +748,12 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 			    struct sa_crypto_data *data)
 {
 	unsigned long bn;
-	int err;
+
+	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
+	if (!ctx->sc) {
+		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
+		return -ENOMEM;
+	}
 
 	spin_lock(&data->scid_lock);
 	bn = find_first_zero_bit(data->ctx_bm, SA_MAX_NUM_CTX);
@@ -758,22 +763,7 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 
 	ctx->sc_id = (u16)(data->sc_id_start + bn);
 
-	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
-	if (!ctx->sc) {
-		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
-		err = -ENOMEM;
-		goto scid_rollback;
-	}
-
 	return 0;
-
-scid_rollback:
-	spin_lock(&data->scid_lock);
-	__clear_bit(bn, data->ctx_bm);
-	data->sc_id--;
-	spin_unlock(&data->scid_lock);
-
-	return err;
 }
 
 static void sa_cipher_cra_exit(struct crypto_skcipher *tfm)
