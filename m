Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0574032A3CF
	for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766400190; cv=none; b=RSUwOpxsdw/UBsWvwaLsnTr20s5JOwZDNbDuGVd7geHH+uYTMRiEEFeD7ncItv/XnUV0VP7GWu1Tsf27NXd6/h+x7gRSZK//YeZ5L/BbseGYBxL+ofRKYEiSqEGIBb2ssRFl1E5IXQUn2V7e7aKU5RkxyVxgodXA0R/EsZvInAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766400190; c=relaxed/simple;
	bh=QGapEZB5vdOb5boVRSwmtgCOFRIoGWnnDtouxyN+ABc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RTI9ZkbIHPWTWU0Rx7U5mUgCRZArCskgB56OjqXLB2l3Of6jTWlljd7F9ZWyA/F0qdedXOfHbV6OdnhYOgnRvFwbJD3YKFh5vW7Kb+HZhQCFiA/JU9bk3m7g5vgj9xejbMbdxJkEm8+SSnK3fqL21PMGV3PAaf3dHcdbGbMa+D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xzpj+uem; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xzpj+uem"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766400180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KZiktEpjalRenDqTShts3L2gcVnxLW3nx9pxv/1q/Fo=;
	b=Xzpj+uemqrOoSzBYiqXVrDvDBpICGb9StC4f4TD3dh0Ss5u5MivJIhrCPjI5WkgL6IG0cw
	jVJq5nrHY1RwQ8NFe2Q/+QkmZPHrNz4zWn08yoxiWre2pSfafjxubxtVqdb5rHyivnrVXW
	UksoSOJPUduV1wjiA14qdDUVtJ7kHtA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: simd - Simplify request size calculation in simd_aead_init
Date: Mon, 22 Dec 2025 11:42:53 +0100
Message-ID: <20251222104254.635373-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fold both assignments into a single max() call to simplify the code.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/simd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index b07721d1f3f6..2a7549e280ca 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -352,8 +352,8 @@ static int simd_aead_init(struct crypto_aead *tfm)
 
 	ctx->cryptd_tfm = cryptd_tfm;
 
-	reqsize = crypto_aead_reqsize(cryptd_aead_child(cryptd_tfm));
-	reqsize = max(reqsize, crypto_aead_reqsize(&cryptd_tfm->base));
+	reqsize = max(crypto_aead_reqsize(cryptd_aead_child(cryptd_tfm)),
+		      crypto_aead_reqsize(&cryptd_tfm->base));
 	reqsize += sizeof(struct aead_request);
 
 	crypto_aead_set_reqsize(tfm, reqsize);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

