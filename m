Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD642A32
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365602; cv=none; b=qJkEFBAnrDv/LrGbVoQtw20pDb2PsM/cJByMcKqNQDJwhobFeJR2Ma5f2rQWBO3z4aCLsxo+/Di5y2/H+tYVsl8+HPvxNu6CYCPtPlq6etCz5KBbEegPnxa6YQ8qGDSJqyAfv5e/RkVfsrNNjKagYZ8d0jQHyDYUe++Q73HLaI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365602; c=relaxed/simple;
	bh=MgVpVTCst9hwc9gKAuAfShZLKdlzquKc21eW3AbZFyA=;
	h=Date:Message-Id:From:Subject:To; b=AWMn7Svz3WHYwMTyKmnmjoHKU+re3UPhziqWBk91hg0UU1+gxdsGzx3s1Z13+zOtJ6/pwbBeRfeoS/oiORaDBQb2N5Uz8b6pLLDZUOT4404IYcmLvlL2DH5B90F1eWk7MQE1P1qnShWLfA1QxBx0Z0ECEYSJ4Fhv0/hfiM+cq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HetAzT1y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HetAzT1y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e0o2tw8QhpZiv3/8x5tsmRCZ35By9zi2Pr3d8qy6WJU=; b=HetAzT1yFJpGj7x8T4ZVE06cO8
	g+sekR2Js3Dprw5YmCfXD8kg1/ovAh1USSdKRn97sXD45rtKndNKn6d3tyHNL3lStakme2XpAEc0g
	/fuKl/YI1kxOvly/c7qNhRBn5zMorhJo5IWdKQllqKXEC9M7oasSIFI1ncvBlpTE/kdzFiLbbD0Ot
	oZyyMy60PJQqHtzljaD77Pu/7aVl6CGesEYoTF8oqjOppeFMup0ybypaYLnH0MQjZFj9IPhu65TU0
	MM5sgmbw8EECtsuDsShZmNlMTiq6kGfiTkVC9rJBe9ovREVX+fbUUwAweojR6ifbFIRr834okzQlT
	jRP5fc1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZT0-003EvE-0T;
	Sun, 04 May 2025 21:33:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:14 +0800
Date: Sun, 04 May 2025 21:33:14 +0800
Message-Id: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/6] crypto: shash - Cap state size to HASH_MAX_STATESIZE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all shash algorithms have converted over to the generic
export format, limit the shash state size to HASH_MAX_STATESIZE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c        | 2 ++
 include/crypto/hash.h | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index c4a724e55d7a..44a6df3132ad 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -479,6 +479,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	if (alg->descsize > HASH_MAX_DESCSIZE)
 		return -EINVAL;
+	if (alg->statesize > HASH_MAX_STATESIZE)
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index c2497c300a28..e0321b5ec363 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -167,8 +167,11 @@ struct shash_desc {
 
 #define HASH_MAX_DIGESTSIZE	 64
 
+/* Worst case is sha3-224. */
+#define HASH_MAX_STATESIZE	 200 + 144 + 1
+
 /*
- * Worst case is hmac(sha-224-s390).  Its context is a nested 'shash_desc'
+ * Worst case is hmac(sha3-224-s390).  Its context is a nested 'shash_desc'
  * containing a 'struct s390_sha_ctx'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
-- 
2.39.5

