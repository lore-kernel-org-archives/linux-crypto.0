Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6254289374
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 10:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765448181; cv=none; b=IWWKNRe2mNh9Iqbi0O3gqS/RCIE+um3irKXYfAGgVcaylgoD19DlaUneUHzL9+2GADlRNYoCxL7IOirCs9nGJ/N57rNjw88siUpDK5bKR+TAh3jOIqD8U/4FoGXnoiobpu94E+cJHi8KmCuJX5MuQIfo3GUR59jTiU6HjwAB6Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765448181; c=relaxed/simple;
	bh=lieRE9PA+dpJ6RIsXJqjPjVzqfQJAKvnPAI211ulA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W0NRfpLfFW/KqJM4RT7gbBPhCqzwMwMCuIi4J7806Z3BlBMxF3CxsPsiIhIaoYyZGBrMrQW2p9l3Mmmi5v6U1xob8lgr708s937iF2GO9CtLgNX6/ZLU+ErueiChXY9wiigJpDvjxWZhNEIgdEfGuSCg4RtRq3jKHn0rGD0gbtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IAGDXYN+; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IAGDXYN+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765448172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0Nasadk8k5y+YUBWDSlZruWHH/AR3DkJCbP/5WhuApk=;
	b=IAGDXYN+sdIpHGsW28HbOHAxw6TZI5NB9H9oF/BffVYW+hkVR+yvB0M/lPNVHFr2SqMhsw
	8i619fEtyuEGxJ+vy2p3BHWrpf/mi/XnRvMDcQbWQywlAu8CiNApTDspga46Put4TmxD0t
	wW0lbxuQ1MTHZLhaN5gj3ouywu92Nrc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: algapi - Use crypto_unregister_algs in crypto_register_algs
Date: Thu, 11 Dec 2025 11:15:55 +0100
Message-ID: <20251211101555.802559-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loop with a call to crypto_unregister_algs(). Return
'ret' immediately and remove the goto statement to simplify the error
handling code.

In crypto_unregister_algs(), unregister the algorithms in reverse order.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algapi.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e604d0d8b7b4..ac4fc790687e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -511,17 +511,13 @@ int crypto_register_algs(struct crypto_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_alg(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_algs(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_alg(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_algs);
 
@@ -529,7 +525,7 @@ void crypto_unregister_algs(struct crypto_alg *algs, int count)
 {
 	int i;
 
-	for (i = 0; i < count; i++)
+	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_alg(&algs[i]);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_algs);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

