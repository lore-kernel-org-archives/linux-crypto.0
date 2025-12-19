Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B533122C
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155909; cv=none; b=kf0Xmc1hFwSa/bxTPQyb4hRa0apumDQZlLv2ccVInTyvv8syfgMjMQIX++8PAHD8Vg3FZ/FE7XyDXhslms85pqJqLgxqSzOyUTPyUxSU7yKFKnEsJjeOBc18qI5RB6J8FlDNfOy/ikfPr9YNeU4nnt5hcC2Yaqy/fJEOa8Q3KGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155909; c=relaxed/simple;
	bh=+xYCaFbgpj2x2SQOaYddL5nivVJ8A64jCcd+7vstq8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npL2hb9gQBC4uSJehUU8VA5LWS483NQ1nTc2a/FBGuLjBNNXjkNcXm7BO89ZRpr51el3SqN7hny49PY02PoUh/at7WDDk47QnRvOcmaSAZQ9QJ787awxZ5/eDhxhq5d/9KvtqinR/8aRaRlQyhEYr2k0Td/BoGmtfELd9y0WNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JCRjFT31; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JCRjFT31"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knDSOa7MidsroQW+TfyXONaTJywg/pyTzOhqwzn2evk=;
	b=JCRjFT31cSS2UoURjMry9dgL4wacazzzz7vdhyyUS/HY2ytpZGXxXsC99LyB5bOdYURXfu
	iUQtZNZAiW58L9K26cc91w9SP4GZV7kgqAF6RTRnOxOx3dikr4Cqv0M9eQGYglP1HjYVL1
	fdfgBRzVizUKZSZ51ziWsQnH0tvVft4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] crypto: shash - Use unregister_shashes in register_shashes
Date: Fri, 19 Dec 2025 15:51:19 +0100
Message-ID: <20251219145124.36792-3-thorsten.blum@linux.dev>
In-Reply-To: <20251219145124.36792-1-thorsten.blum@linux.dev>
References: <20251219145124.36792-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loop with a call to crypto_unregister_shashes(). Return
'ret' immediately and remove the goto statement to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/shash.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4721f5f134f4..5238e0def4fd 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -542,17 +542,13 @@ int crypto_register_shashes(struct shash_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_shash(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_shashes(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_shash(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_shashes);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

