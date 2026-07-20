Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4190339E176
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784589816; cv=none; b=Cb/545bl4nghsc2hMIxqTbJDPysD9b1Pc4epVo6+OMIixW/GlVOKkNU2sa2sm7jQKTuHOXHy7nehHdH6BFwHKCcWx5dprl/adWSCowO+ZB6cq8SRADs3zCA6xNkDN7DE1Bf86kzUKRpCYFOPRa158ujqhfUq9VbXRhC1XMvbD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784589816; c=relaxed/simple;
	bh=dvmbrLNLIZxd/SDtC6FzxhIyNSHuXHq+rxVrZp0tNLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b8Tn28XFoEj3P8UHAMZ/lsUO3h1BVUqB0w26J8+WVP6Q5T3agsrOLhuA/42Uly4HWf2g2S9YhdyVh5holZ49zXyr//0HVgAEf5SSk9Yay8yCbay5eEFtqrelxzeuZ+V8/cXDQKKLmYEAqKFRHahSuYvy9lEs0LBz8a7iRSJdJ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rbBRJtU8; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rbBRJtU8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784589812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WiUJblCoPlgRA6XQXE68Dw6o5oFLA874KMFylxYSEBo=;
	b=rbBRJtU8gZYW4HvH9L1vQbFVe95xJ8dgMFG1KRU/9D/JtTJcNEelLTQYgzYQmJCGhWYSTz
	vjSkGe8T4MnGa/PEvEtXcTOH5pViPNF+V5dI4LEsV/C2PHrMKJg+ALxoqyJVHWjgIw9mf1
	ReXLbpuSEhMk8GULlxWb27rtycrhS/U=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: bcm - use memcpy_and_pad in ahash_hmac_setkey
Date: Tue, 21 Jul 2026 01:22:50 +0200
Message-ID: <20260720232249.117992-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=thorsten.blum@linux.dev; h=from:subject; bh=dvmbrLNLIZxd/SDtC6FzxhIyNSHuXHq+rxVrZp0tNLY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlxa0/e9rbj4ftcfva1vIL5jCuxyoLn046ccwkR817UN mfF6vpXHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRpw8ZGR7VZjwJm6C1/NLE gpOlO5buiP+reDukfMmvv095fyxfY2jEyPDxm+LnptQ/wtm5pWKbXmUX3/1kNWv3lpe+J/NYOFq 0pDkB
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use memcpy_and_pad() instead of memcpy() followed by memset() to
simplify ahash_hmac_setkey().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/bcm/cipher.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 240b40ae9cd6..e9d9ca7441b6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2387,9 +2387,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 	 * outer hashing in software.
 	 */
 	if (iproc_priv.spu.spu_type == SPU_TYPE_SPUM) {
-		memcpy(ctx->ipad, ctx->authkey, ctx->authkeylen);
-		memset(ctx->ipad + ctx->authkeylen, 0,
-		       blocksize - ctx->authkeylen);
+		memcpy_and_pad(ctx->ipad, blocksize, ctx->authkey, ctx->authkeylen, 0);
 		ctx->authkeylen = 0;
 		unsafe_memcpy(ctx->opad, ctx->ipad, blocksize,
 			      "fortified memcpy causes -Wrestrict warning");
