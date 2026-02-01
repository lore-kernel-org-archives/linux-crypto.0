Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524CE1D5170
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769968648; cv=none; b=MzDnrROTitmPdbeW+HfSTSddbBvK7PIfXtJJN9gKtALR3if+dn4THnLv92nP6wNmCYr/UHB9SxG4Ej4JAmWKT1TyxgwTZLLYMeE1YlQEs2izCglG/ipbL6MOsYgb0pExHFiIVWyCYf3RqR1M9eNM5L6aNeU84F0Xk2EcZ25kC4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769968648; c=relaxed/simple;
	bh=HRBBj0nPq7qU55R3IPHOngXEvBb3wwpPQ7k4n533wrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csJculBFqjrp4RL9N/Yet8fwIXshWoM4jUeG/0rOh4xr7VxsTEoQ03wP2kgwp9NzGntcsu/6qJLQBx5goC4LacCCJCHAe35vI/ZHiuVtWabvkMz3nM5s6q9gSdp9moUwbcKIvCbcA0+WDSWltSQ+f6oU77WMU2N5WSkpUZ4ZGcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DsN4ltz4; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DsN4ltz4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769968644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pWD89ORk2rwOefxQ8yqPj9t/reTFvE2D7mE1erXtzWc=;
	b=DsN4ltz47LFzz+FP/6VNpbbyaIEC9zf/s79KNqe87N94SixmnHa3t6G7J79WVBeF7LDMm+
	NwuY13MHSZD0DoKuTEdDT+jafWLoxAyTO7NjekmNnx0O5uQw9lgaXMUM4cR0OVHN3dLT2r
	VWz+jgBnnGYQ9Rf81ITJ4aZADyxVlIs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: img-hash - Use unregister_ahashes in img_{un}register_algs
Date: Sun,  1 Feb 2026 18:56:33 +0100
Message-ID: <20260201175632.662976-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loops with calls to crypto_unregister_ahashes(). In
img_register_algs(), return 'err' immediately and remove the goto
statement to simplify the error handling code.

Convert img_unregister_algs() to a void function since its return value
is never used.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/img-hash.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index f22c12e36b56..7195c37dd102 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -870,25 +870,18 @@ static int img_register_algs(struct img_hash_dev *hdev)
 
 	for (i = 0; i < ARRAY_SIZE(img_algs); i++) {
 		err = crypto_register_ahash(&img_algs[i]);
-		if (err)
-			goto err_reg;
+		if (err) {
+			crypto_unregister_ahashes(img_algs, i);
+			return err;
+		}
 	}
-	return 0;
 
-err_reg:
-	for (; i--; )
-		crypto_unregister_ahash(&img_algs[i]);
-
-	return err;
+	return 0;
 }
 
-static int img_unregister_algs(struct img_hash_dev *hdev)
+static void img_unregister_algs(struct img_hash_dev *hdev)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(img_algs); i++)
-		crypto_unregister_ahash(&img_algs[i]);
-	return 0;
+	crypto_unregister_ahashes(img_algs, ARRAY_SIZE(img_algs));
 }
 
 static void img_hash_done_task(unsigned long data)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

