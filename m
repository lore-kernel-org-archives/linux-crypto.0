Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053AF33A9C4
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155911; cv=none; b=tOr3E348Cg74nbypb1L8SdFtakXzr7oQ+0GFsyCm8jNAOmaE1Yb3BlDmw/qgFRmzyWy/VJsiDtKO3qhrDRLdubF/C5l+bWxRYAv1meLjQSF+Gh2aTtnb4oI0pMFLcteSODfNEldb9KCHkO/wPerWNOAfXbdN22D/wtztxk9Saqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155911; c=relaxed/simple;
	bh=7K9g/y2VPlRnWHhvkJjzCWrLc+MC7PWX3De99gB3sV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd5vDfjIZnWlfsXSNg/0dTfaYlGXwgck7GT8Z32e/Sb12eDJgbSSkSFgpBGcTwKMASp0axZZmo+mr2a8U3Ozvdr0BgVT9s4u1gZN55lUDgr/QVkuGT+T/gKrYt+1vyThfIyAc8OUI2/KoozBl38pR9E1JwoQb6kwadnhwRWltwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BY9VGMQC; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BY9VGMQC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xn3obJvOjfZoo+hUjansuWJp2nk8MblmyaKHgSIsFcE=;
	b=BY9VGMQCwIDo1SVgslgaiEP27zIoCZXWcFgGIjI7+yozUFvSTqjweHygKtgb+MJzhn6dqt
	bbOD6s5hlcDSp25ImJujL0oddxMg3dXtJeb4bm9SDC/4LZ4sqnbPJZOvAJXOk6zh4XRPlN
	DOLPMjJN2MtxkKKWcwCVjltV2k9Iz3o=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] crypto: engine - Use unregister_* in register_{aeads,ahashes,skciphers}
Date: Fri, 19 Dec 2025 15:51:22 +0100
Message-ID: <20251219145124.36792-6-thorsten.blum@linux.dev>
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

Replace the for loops with calls to unregister_aeads(),
unregister_ahashes(), and unregister_skciphers(), respectively. Return
'ret' immediately and remove the goto statements to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/crypto_engine.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 18e1689efe12..e124bb773958 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -524,16 +524,13 @@ int crypto_engine_register_aeads(struct aead_engine_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_engine_register_aead(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_engine_unregister_aeads(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	crypto_engine_unregister_aeads(algs, i);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_aeads);
 
@@ -566,16 +563,13 @@ int crypto_engine_register_ahashes(struct ahash_engine_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_engine_register_ahash(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_engine_unregister_ahashes(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	crypto_engine_unregister_ahashes(algs, i);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_ahashes);
 
@@ -638,16 +632,13 @@ int crypto_engine_register_skciphers(struct skcipher_engine_alg *algs,
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_engine_register_skcipher(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_engine_unregister_skciphers(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	crypto_engine_unregister_skciphers(algs, i);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_skciphers);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

