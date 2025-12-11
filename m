Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D16303C85
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765443225; cv=none; b=Xym/LlCIdcVW0Tdf4s6ADZKrHIC1s0LFOhgQF/XGzP/Rn87n3S0K1P8pt1gktCqtsRaobgTtt5pWNm3rRgiAvW0jgJHJYvn6pWpBM3PIyHs4IQCp92CN6emvJb3ORwq7xfQ+GKcdfWLE/B9oj+gP9leqnTdGf+qfzHxURds1ltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765443225; c=relaxed/simple;
	bh=pOFcKPk5DQIfMlC2wHMkmX070SjBf47kHS0w4TqaQv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lMVKL3H0n0zcrOTJJZ3wYVWH0QLvEXjWD56RlfD4Ji0S15Bxyb6R645jdc60FY7YhVUGyGCsHYUWd3Py80iTmV1gVT9H1/b5EKrWNhoBDvoNd1kk05LfkSWmCX0UT1biC/y6+MjXVw2JC9WKIVy9qym999EcMj3QN7L98aeUBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HhTnm4SQ; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HhTnm4SQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765443211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wGL7AIJxmq201kkii3CXEVTm6gVDaQiDrS4KCLR0obs=;
	b=HhTnm4SQPrHpqnArhhmkiVdZ/XJSdy0J8d/zjaxhmoHitTOax5ViYpczSkiRCLzjfH1QHF
	8xxnsWTS8Dqc+wvYD9piDhXbj8OiuXAUinLkTQdDTb/A++FtpDdkXYNLBUQHERjsAdNFyA
	aSf4MpLfDGpQHxZd+ZWv4ZmHJgfaNIk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: scompress - Use crypto_unregister_scomps in crypto_register_scomps
Date: Thu, 11 Dec 2025 09:52:51 +0100
Message-ID: <20251211085251.799114-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loop with a call to crypto_unregister_scomps(). Return
'ret' immediately and remove the goto statement to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Leave crypto_unregister_scomps() as is (Herbert)
- Link to v1: https://lore.kernel.org/lkml/20251210132548.569689-2-thorsten.blum@linux.dev/
---
 crypto/scompress.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1a7ed8ae65b0..8d70c5ec6f8b 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -383,17 +383,13 @@ int crypto_register_scomps(struct scomp_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_scomp(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_scomps(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_scomp(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_scomps);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

