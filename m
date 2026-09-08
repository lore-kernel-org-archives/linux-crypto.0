Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B043A9605;
	Tue,  8 Sep 2026 07:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854086; cv=none; b=mf9CJQeMnbReii/Lc6HaeSIRyF9aHHKEHvWytuJolZxovQeIDWXth/BM7l4+wiXsO9zO9ozAZA8PcKl/b0JEE2OSiXa5f/2Bxogv12cfBSwkZlci2I9AyoghUYCE0FVmMtvOXks2ySoMT4pOpeds9ZeQSRSyCG6iUQLbwkM9OB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854086; c=relaxed/simple;
	bh=PPzNN39B7L/5123kefcOgUmHTJUIHSjPPl6fOtNhApQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oR+rzllRcBHgEsKEQSmA18xvdmbzgcLtBuVVz7sCf+64inbyaboG+0NYCnqW6n2rieoF8ysMkBXhVSYe+f0Wvs67mngmhrem91daHEthEFrbxv2JbhLWJyesLLN3g8NOxd42LDiXGkUxWZ7y2gC0gp3SsHOrvqoH84tDqRZcWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdL6EJMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdL6EJMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6101F00A3E;
	Tue,  8 Sep 2026 07:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788854085;
	bh=tES0q+TYNnYuVdAOmyqrMv/w+xs/tzZD1dDvpgip1pg=;
	h=From:To:Cc:Subject:Date;
	b=TdL6EJMolIsymQu0svjdSII2NkiWQlfkoqG5jZHPcnz7py7Xt/XHJJkbrF7CpTJ7u
	 9WOWQw3LXOGUb8QfmYoZRBCmLr5Gni2PTjxYmv00F2L/pDVJJjBpTqY5K3WL9Q2z+8
	 HxAS99E17yZAmobOxyyTiWhAynDcX8QUPL4tysoKyZyIjUMsqEXpRN5WF1WImKbi9I
	 2sp5GpvtdNJBN5OtTpKxHjO1sy3H45eV6wS1TB84i7THOFuNCrHEHOPscsYbDK548k
	 Go1RIYDOXNjvaz2SeKwUe3mCWGhO0KBp1a/wjsZW9efyUJboFTHRjb8Z5Ti5tYAHow
	 4Y4VbaUqMl2vg==
From: Thorsten Blum <blum@kernel.org>
To: Harsha <harsha.harsha@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: zynqmp-sha - fix NULL pointer dereference in init_tfm
Date: Tue,  8 Sep 2026 09:53:40 +0200
Message-ID: <20260908075339.396499-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1049; i=blum@kernel.org; h=from:subject; bh=PPzNN39B7L/5123kefcOgUmHTJUIHSjPPl6fOtNhApQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnz9zMfXPBuy+ODFzaLvazjecqfe8Xt/IsDa6erzulP+ Hf4w6enbR2lLAxiXAyyYoosD2b9mOFbWlO5ySRiJ8wcViaQIQxcnAIwkac+DP+9ObwqrZpc+JTX Bx7I/m1mJFgQm2jDYPtC3u64Ep/IplkM/yvK9Z4+WHjT7AHz1w/u9nsbU/gOyV+u0u+LtFh54Jh LHxMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

zynqmp_sha_init_tfm() checks crypto_shash_statesize(tfm_ctx->fbk_tfm)
before assigning the fallback transform to it, which dereferences a NULL
pointer since the transform context is zero-initialized. Use the local
fallback_tfm pointer for the size check instead.

Fixes: c1dd353d18e5 ("crypto: zynqmp-sha - Make descsize an algorithm attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 5813017b6b79..cd051e1f4275 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -59,7 +59,7 @@ static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 
 	if (crypto_shash_descsize(hash) <
-	    crypto_shash_statesize(tfm_ctx->fbk_tfm)) {
+	    crypto_shash_statesize(fallback_tfm)) {
 		crypto_free_shash(fallback_tfm);
 		return -EINVAL;
 	}
