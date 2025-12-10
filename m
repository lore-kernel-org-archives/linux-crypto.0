Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B13254B0
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765373184; cv=none; b=Z4EdMiwYPi5932wAYTqCrFMeRNA6u1epEGMVf7zZGeuZ3w0dO+Ajs+Spp8jt3QNLG2t0fK+CUl8TOBZKnQ3JzuUTo9gjOcAShuWGMeM+6eosZ2M72qsXdQlb5CiXCQOaO3/QpWqJiFk0973lJIpgy4lK6/BxdU7QFwHUYi+MFCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765373184; c=relaxed/simple;
	bh=RzzJQFSmpdq3ZSqyZ5ANenrhQzDOIUGBRt1+lLf/IO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L1I9Yh6hTVJYYb0CDfn0lNF3J2qQcrVO5Lpv2KP+QIka0s3NbCpux/7nDxpFa8MdOx+Z0SmOBWFJQqKY75ry6nwMmxUJRtbkBn/w9eOJGeZd5MaLvW2pSzIFdjn5MnIqpMWWq9EQyghbPQIJYitcs7tE/+Xc2XSQVUjp7r2kZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X6bYrlQC; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X6bYrlQC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765373169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n0xFNj1VFPm49dVLbTKO075wSDlGhm7tuOYw6CG1Yfc=;
	b=X6bYrlQC9N/Ra8xiqgntw3sbaY7gUkmMaHr9kzFi2h7KzXqZX//v2QVDim/WG9O7LAMAlZ
	xqm0bPGl3Zzc/s4LdU2GW6HL5zfOVT0v58laRLUoLDJ8Le7g/aT9W9EAzhierT8Orv1ZnN
	s3TkBzvi1eotZ9Re3yym4WqJW2E+Zws=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: scompress - Use crypto_unregister_scomps in crypto_register_scomps
Date: Wed, 10 Dec 2025 14:25:48 +0100
Message-ID: <20251210132548.569689-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Define crypto_unregister_scomps() before crypto_register_scomps() and
replace the for loop with a call to crypto_unregister_scomps().  Return
'ret' immediately and remove the goto statement to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/scompress.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1a7ed8ae65b0..3e026a6eefe8 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -377,34 +377,30 @@ void crypto_unregister_scomp(struct scomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
 
+void crypto_unregister_scomps(struct scomp_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_scomp(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_scomps);
+
 int crypto_register_scomps(struct scomp_alg *algs, int count)
 {
 	int i, ret;
 
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
 
-void crypto_unregister_scomps(struct scomp_alg *algs, int count)
-{
-	int i;
-
-	for (i = count - 1; i >= 0; --i)
-		crypto_unregister_scomp(&algs[i]);
-}
-EXPORT_SYMBOL_GPL(crypto_unregister_scomps);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous compression type");
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

