Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00271FC7F2
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080310; cv=none; b=JE786UfCosfTQoGdGa3zFPGiSdj0H8ZFgZsE2Znn6XmD8LaA6JFMYFqufjljnK7xMVeLHGW8gBdXr5dJKXiVahh4WeOPb4ow+qymg92tlQfEby397vacsHUKr+4Mkunfcm1KpK14nSdgH+1l8+Vl7wThyKmUPj0I2Ux5H0xLg7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080310; c=relaxed/simple;
	bh=H9d4sjspXyLk7uR7M2QVJROg2ijF9AQijBvLbGfq5Ow=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=qdLm3MuKyMk4Wiv/kFpcArXTUbTT2qwitRh7dvHzuDTpsHcWZ6Qk9oWZMXe3n2tRYAMXCC9ySGEoxWDjEhzwd0nCiGL4mbV4XvDhQidsya0LNgJvt9m0ohJLvuU9bEe4eFp4ADQ34lepZAI2hNEz6Xc//zoqNT2YnCGI7SdY4nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=euheJy/j; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="euheJy/j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OoqpE0SkD7kTh5lf/A0RjqC+kdgsA27dsiXVeZ3yVdI=; b=euheJy/jNLG9lofIrRVrWR2dfD
	MOmfVs0l+IXKFAp7m7G+qgpNhKp49YC2RAIkulAVSS2wgfBHQzuAQD4MLOlRjgmj080gKt00YtOd0
	5NkzK5yO4v+w3EdvZkhtF4Owl2+NuRnt0zg3ykmBy8URLAQRLDA+Pz66oQEJfRcp4i3X+kGF8cfzB
	2yKhs5Sd79/uC801DZNJrwZJUDpAvXUfll0j31S7Qpt7+1aDXlmPT4USsit3+QnsuTuHYIScCUguK
	fFntRiIey0qjd5PAyvyB4iQuSzFBD/c7NqBuhVNK7hIqWWdAXwbIlVvPkrDqU8p71Tz8gpDBJBzQb
	EZ/YPNmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpOWN-003a2K-2e;
	Tue, 04 Mar 2025 17:25:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 17:25:03 +0800
Date: Tue, 04 Mar 2025 17:25:03 +0800
Message-Id: <3c3c20451382a4e17f2179d436f5841fa1cc3a28.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/7] crypto: api - Add cra_type->destroy hook
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a cra_type->destroy hook so that resources can be freed after
the last user of a registered algorithm is gone.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c   | 9 +++++++++
 crypto/internal.h | 6 ++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e7a9a2ada2cf..8f72dd15cf9c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -89,6 +89,15 @@ static void crypto_destroy_instance(struct crypto_alg *alg)
 	schedule_work(&inst->free_work);
 }
 
+void crypto_destroy_alg(struct crypto_alg *alg)
+{
+	if (alg->cra_type && alg->cra_type->destroy)
+		alg->cra_type->destroy(alg);
+
+	if (alg->cra_destroy)
+		alg->cra_destroy(alg);
+}
+
 /*
  * This function adds a spawn to the list secondary_spawns which
  * will be used at the end of crypto_remove_spawns to unregister
diff --git a/crypto/internal.h b/crypto/internal.h
index 08d43b40e7db..11567ea24fc3 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -40,6 +40,7 @@ struct crypto_type {
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
 	void (*free)(struct crypto_instance *inst);
+	void (*destroy)(struct crypto_alg *alg);
 
 	unsigned int type;
 	unsigned int maskclear;
@@ -127,6 +128,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
 void *crypto_clone_tfm(const struct crypto_type *frontend,
 		       struct crypto_tfm *otfm);
+void crypto_destroy_alg(struct crypto_alg *alg);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
@@ -163,8 +165,8 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
-	if (refcount_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
-		alg->cra_destroy(alg);
+	if (refcount_dec_and_test(&alg->cra_refcnt))
+		crypto_destroy_alg(alg);
 }
 
 static inline int crypto_tmpl_get(struct crypto_template *tmpl)
-- 
2.39.5

