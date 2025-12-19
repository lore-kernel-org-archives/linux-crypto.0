Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD033A6E5
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 14:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155909; cv=none; b=SImGHEjlK6WsoDtsZZ/WWQOXxVbjnxIwASkmCzqHIctsfoBOcokOgBI/lk1CrM/4tdvC8H63x3wU5YP1n8H/kEEXcoTMCet7WrBf6Exk8rIffr/lfPOsh/XlyEV84mnj3QtAgX7WchKUbxEtme40Nh92WHe1ww8El3XgBgqsBac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155909; c=relaxed/simple;
	bh=IUY//uiY6kSRb9N9b8JG2dT9aiiL2FyAVEsQGqQRf6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhMNRfzMgEWRiyEoabTjACaLlOoYEgQMiG99uFZcnUzAgRjieS4zTSqQ3dJVFdQnj4/Ww+LYjW+Q/H76BUgOAVsHEab0EfYmVnLsTWgpUlzdySRFamxTsF0pGWy+/5vfOIf3nXIoBfDf6qeTRlrT9K4NePelQATbhzshdy7hLLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p/ol9PuN; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p/ol9PuN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkcHYEXjQo4RUdQaTPJPE51LQaJVHyd2gEy8jjWWb38=;
	b=p/ol9PuNVkMt9YQVmCgz31qYUke+u3mjxpgnNz7Tef0uYUz1MnMTkAR+IfDMhpGg4KSbsE
	VRFdgHPdhPrLZSQvqEoKQQubtiWndljmbdfcfWoDxmP78ugdLpzQqJvncSyR/kTtypSSt4
	adlbRP4urz4D9ZBfqrxKuIT4EEyF/D4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] crypto: skcipher - Use unregister_skciphers in register_skciphers
Date: Fri, 19 Dec 2025 15:51:20 +0100
Message-ID: <20251219145124.36792-4-thorsten.blum@linux.dev>
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

Replace the for loop with a call to crypto_unregister_skciphers().
Return 'ret' immediately and remove the goto statement to simplify the
error handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/skcipher.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 14a820cb06c7..09f1ba82f99a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -741,17 +741,13 @@ int crypto_register_skciphers(struct skcipher_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_skcipher(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_skciphers(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_skcipher(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_skciphers);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

