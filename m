Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BD63A1E7D
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765896956; cv=none; b=hKnHvUDcn8y59b6iAOned05r7iAAY/gTPIaACnZyjH8phwDhwVo7V2E2NSC++vq0JktJoRWsQ6WyIeitxJI0rjDsxfFVOeqLxxNNuSWIxvTYpW/SRuGjnrg/oyuYbZUdjNd3l987XsXxg/aM9JU7Ia39MDgEfeK/wEHKmv0TwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765896956; c=relaxed/simple;
	bh=9Mzr9Kp6iUDqkLsOvFMCJChlzf+xSHbQoUSJggDZJUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Or1ywksH8pKKA5AsLfqreo4t8u9p4DbDrFp/UtyREFg5wEmVFATwlBRIOS8zdYwUsoLdW0q6clNU3jUCCq2S9IALu05C14O3+ikWJTvla9yYFg1bsuPHZv8yZk5VKjYW4bBSyM4ixy7CwcV8ucpJPX/BEEScKjKcvZXWKkGR3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PaswUORp; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PaswUORp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765896945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D+B9zFhnTMtmifIA4SPnM34433YcZcD1kDd+0n/9FIg=;
	b=PaswUORpWXU0PaPlcgirLn34zwA/Wtl6dD5ubiTgrGtxPy10HwFzlI3eb7fR+UxHcnyGQr
	aYmYz46Op/wNzAqm27SYHPHhOD+BqBFFEI2ghsEsR5ukTgsud7tB17K/4WAJtdPCBq6yVY
	PBj4jr1U2h9o1G7/z7+TxxjC2QCdNdI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: khazad - simplify return statement in khazad_mod_init
Date: Tue, 16 Dec 2025 15:55:35 +0100
Message-ID: <20251216145536.44670-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return the result of calling crypto_register_alg() directly and remove
the local return variable.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/khazad.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/khazad.c b/crypto/khazad.c
index 024264ee9cd1..dee54ad5f0e4 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -859,10 +859,7 @@ static struct crypto_alg khazad_alg = {
 
 static int __init khazad_mod_init(void)
 {
-	int ret = 0;
-	
-	ret = crypto_register_alg(&khazad_alg);
-	return ret;
+	return crypto_register_alg(&khazad_alg);
 }
 
 static void __exit khazad_mod_fini(void)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

