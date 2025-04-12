Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C312198A29
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454868; cv=none; b=iYOx7rr4x0zgJEew4CgEZyMu4ABfDJOhubG6LFa9j3jYleVmSi0j7fmoiuYZJdJCkkG0OMbAxXQ/l5rnX6MN5ZgMJ2htkKg0ZdQuoeq++Rf8ZvsOn/lSX2Sdds6yTIF1EDA4nd9Kb98N1SsSwJnUEoFAAE3zLvGlv1ag+L7p6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454868; c=relaxed/simple;
	bh=5rbTlRmCm8XuFSjVDor08g8yC1BQB9kcDxUD7fOeC/E=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=L5IXJDi9ZBbZOTffekIWRsvn0bfEDit+dUIG9eYQ1etdMhYRokZi14nzIedpNQ3BdWtzb8+GYUgxjcyAqUtDjZLi+2+f1UgLyLWfV7+RbX/46uKjEMdL0S7R8t4hVOigla+T7O0zPNmYR7LnvfY2LtoK2DBGkGErambIY27MVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aoaNXpfV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aoaNXpfV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qzxY569fqD08vwtUYcGJeo5fR8j0nR4Idr4uaK59Tbc=; b=aoaNXpfVIqUTma7kE6A3ZjFOIB
	ckV0u/gIoV34p7jg7r2Ggh6TZ7Jn6pOjGGMq8Rv+QMznEiQ7oe+73ZY+KId+m7XTpuPhpnlZ6JaAw
	4iynUspXRyrO0em3ijco1qbrzfcyG1TfGVHJ+oy68/ev1hrx32z3l2tQbvyuSSd9kkHYgmY0WiA7X
	BIvVt7mbOe8GHVMB298ahdF9lKRqUzejM4IWu8WPJ105Sxge9V0mWBjlGV0/7COsy2HGutNGOO27h
	xLbHB9pu/E8K+E3HLC/sV6lEoUM/gpjTb0nWta0C5NXanj4ovuuHNOa5BnATo9HUVRFPeHlEt1Dgd
	0NkkEseQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YOi-00F5Dn-1P;
	Sat, 12 Apr 2025 18:47:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:47:40 +0800
Date: Sat, 12 Apr 2025 18:47:40 +0800
Message-Id: <89051af09414408c4970a701cceb4d3e3df70805.1744454589.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744454589.git.herbert@gondor.apana.org.au>
References: <cover.1744454589.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] crypto: padlock-sha - Make descsize an algorithm
 attribute
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than setting descsize in init_tfm, set it statically and
double-check it in init_tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/padlock-sha.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index db9e84c0c9fb..466493907d48 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -206,8 +206,14 @@ static int padlock_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 	}
 
+	if (crypto_shash_descsize(hash) < sizeof(struct padlock_sha_desc) +
+					  crypto_shash_descsize(fallback_tfm)) {
+		crypto_free_shash(fallback_tfm);
+		return -EINVAL;
+	}
+
 	ctx->fallback = fallback_tfm;
-	hash->descsize += crypto_shash_descsize(fallback_tfm);
+
 	return 0;
 }
 
@@ -228,7 +234,8 @@ static struct shash_alg sha1_alg = {
 	.import		=	padlock_sha_import,
 	.init_tfm	=	padlock_init_tfm,
 	.exit_tfm	=	padlock_exit_tfm,
-	.descsize	=	sizeof(struct padlock_sha_desc),
+	.descsize	=	sizeof(struct padlock_sha_desc) +
+				sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name		=	"sha1",
@@ -251,7 +258,8 @@ static struct shash_alg sha256_alg = {
 	.import		=	padlock_sha_import,
 	.init_tfm	=	padlock_init_tfm,
 	.exit_tfm	=	padlock_exit_tfm,
-	.descsize	=	sizeof(struct padlock_sha_desc),
+	.descsize	=	sizeof(struct padlock_sha_desc) +
+				sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name		=	"sha256",
-- 
2.39.5

