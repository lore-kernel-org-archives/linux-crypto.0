Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050134D4D3;
	Sat,  7 Mar 2026 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772923579; cv=none; b=OAAb0gLQ7DcRLg2bxrKNGH7g3pWOPwe8D3QbHgabXc54OS7jacd/5+xJ9NWunIHycfThAxk9//cUSlsNuiImqK+VUkOusz1qdHgWdxpFiBxRCaCKK9tlipVaHsqclrZEmIqmWRD0mj8z/l32Nc9w15GZlTPud2Itt8D4Nhw/6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772923579; c=relaxed/simple;
	bh=Tj1UiXBp5rN/yqKvjZfr5OUuq0XLn4r2ZzolzarWTFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYD3c3kRY9hjW+wYmdGvc04RbmSryy+x0YSu4KmgpX2y7yrTVCqlGpUlqWQRxalhmm0d5hSkuOaCa9Uhnur5P0yru5g17ZC+RdnDQAz2exdsF2urVSSbjyHUW6RqzygCmqhi6hp263mHNs2qbIdSt2RQS2dVWACLDQde+Uhnves=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hs6UvOXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hs6UvOXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685E3C2BC9E;
	Sat,  7 Mar 2026 22:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772923578;
	bh=Tj1UiXBp5rN/yqKvjZfr5OUuq0XLn4r2ZzolzarWTFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hs6UvOXAO5+xom5yAVnoxONW17fDxefETodyDnYCp/8x+3a285avpF52GigBP57PQ
	 bE2OyTvV++sAjdOYYGN0Oy12YtxOrs2cU3G1thmy/lh5YAci1ZzsplZXPsKvkUXTis
	 PMHTvpAoFaaMf9QDWgtXGPOtR5P0aQud+bJ9FW0YJy9bpYjv6g4CEPOK3qTezao+L1
	 vlSg27rr7S9VA2IMKO76Xu8iKf7etEX1E8OlLr57Uc/tk2T6UyFg7AZcf1w0HZoM3Z
	 RoWww5UVyMwZ/+7ue/tIE61nj/CygjmhdSQ+dXbj98HETaFHEn132WiYFcwv6G22YP
	 VEmpRfPDaOJ3g==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH 8/8] crypto: api - Remove core support for cloning tfms
Date: Sat,  7 Mar 2026 14:43:41 -0800
Message-ID: <20260307224341.5644-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307224341.5644-1-ebiggers@kernel.org>
References: <20260307224341.5644-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since all callers of crypto_clone_tfm() have been removed, remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/api.c      | 26 --------------------------
 crypto/internal.h |  2 --
 2 files changed, 28 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 74e17d5049c99..d019d1979857d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -558,36 +558,10 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 out:
 	return mem;
 }
 EXPORT_SYMBOL_GPL(crypto_create_tfm_node);
 
-void *crypto_clone_tfm(const struct crypto_type *frontend,
-		       struct crypto_tfm *otfm)
-{
-	struct crypto_alg *alg = otfm->__crt_alg;
-	struct crypto_tfm *tfm;
-	char *mem;
-
-	mem = ERR_PTR(-ESTALE);
-	if (unlikely(!crypto_mod_get(alg)))
-		goto out;
-
-	mem = crypto_alloc_tfmmem(alg, frontend, otfm->node, GFP_ATOMIC);
-	if (IS_ERR(mem)) {
-		crypto_mod_put(alg);
-		goto out;
-	}
-
-	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
-	tfm->crt_flags = otfm->crt_flags;
-	tfm->fb = tfm;
-
-out:
-	return mem;
-}
-EXPORT_SYMBOL_GPL(crypto_clone_tfm);
-
 struct crypto_alg *crypto_find_alg(const char *alg_name,
 				   const struct crypto_type *frontend,
 				   u32 type, u32 mask)
 {
 	if (frontend) {
diff --git a/crypto/internal.h b/crypto/internal.h
index 8fbe0226d48e2..96f84abfac91e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -124,12 +124,10 @@ struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
 					 u32 mask, gfp_t gfp);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
-void *crypto_clone_tfm(const struct crypto_type *frontend,
-		       struct crypto_tfm *otfm);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
 {
 	return crypto_create_tfm_node(alg, frontend, NUMA_NO_NODE);
-- 
2.53.0

