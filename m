Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E9726F443
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765294273; cv=none; b=fDOcbxbxktkJjUDkaRRfCRPGBzqG0AGCzsTXbBrc0/09X+EfSujSoIKLt9NXCV5mNbqsRtBqGRBJlfGOyFO4LF3ftQTj0QhJWTqan1sgNobkVNH4Hl0CHukO5eSDkYCrliJ9yrFk2iDaTYS8wgUSDmwv39iJL338Nh4NoBHxkOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765294273; c=relaxed/simple;
	bh=bJN65gY6giKFu5Hrvj15qyRLsJ7kUce0SDLwJOguP6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dkbg3ga4u8s7N3e+GSjsrngmtrXn8/gyyEq8qF3HYgUz9gGCZTskUtXVOCFRl/C844se8wooNUaDnejOOjZRM13CaW+m8RPuhMxldiMU8zs+I5jdd6k0fgpYobvAZJvWlz4QM9RACn/moF6R+k7Cs0aGxmbnpqd3Va5SAZE0fKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GX7JYClW; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GX7JYClW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765294257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QogldAY8o/J4mynBEBOsNtgJwwEQdVm7q8XblZZv1qI=;
	b=GX7JYClWzmtOeVO6OqYsIw7zNEUpFv5bv1kPpdmFi1TTbACgauTfHtDX65qSOg1trrtN/+
	eIzDDrpFQcTd2hJzpoZolcxwWLtQooO3hcUeQVaqvYCoU2tzf+krYeyfC8Uamow5J1O+fN
	E8hSOUUn0d/YFEZDLGBXBfhDauNXyxQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: scompress - Remove forward declaration of crypto_scomp_show
Date: Tue,  9 Dec 2025 16:30:43 +0100
Message-ID: <20251209153044.432883-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __maybe_unused attribute to the crypto_scomp_show() definition
and remove the now-unnecessary forward declaration.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/scompress.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1a7ed8ae65b0..70ceb2fe3d7f 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -58,10 +58,8 @@ static int __maybe_unused crypto_scomp_report(
 		       sizeof(rscomp), &rscomp);
 }
 
-static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__maybe_unused;
-
-static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
+static void __maybe_unused crypto_scomp_show(struct seq_file *m,
+					     struct crypto_alg *alg)
 {
 	seq_puts(m, "type         : scomp\n");
 }
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

