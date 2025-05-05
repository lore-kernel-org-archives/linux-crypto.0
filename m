Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA04C26FA40
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=pNwDyKIlkfLUWgpUsLbxfL2a1BM78Uewu+I4ZDP8ca0nYX2Ebe6s4DtLgEVKlI5piBezY2f37HteHWr59uKpAT71j58AjT4djsvjXL3K7GFBQ/gAKen9s9hwMQ6UrA4UaYdpCKbf//hHDh9TwltwvbDO2PIY68HRVryPZ11KdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=zadINjCerNEtZzA2gwp///+vanXky5GqozH+EKV6cvg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmUiUW8wOlo6taFVAX4Eu+bKZglNM/u3yP0m+mBgsPe+82PtF3mZ9jnAfupzvvPmrQLPtQsIR7yIzpYUbOPoj3hDhPV/alJ4e0QDUIpXm4I7K857JOpFdUfxOxn5okc47XnYiyPE61ne/5zW03Zx7Ia30Gc5VXicYV3Au4i1KeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuislPSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuislPSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E15C4CEF2
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=zadINjCerNEtZzA2gwp///+vanXky5GqozH+EKV6cvg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MuislPSAz7JPsiJpKg5MwsMnR+2FTuJRU7fLvgWT2kvq3C2Ptr7A8MHkg4OhXMT0n
	 sz6yI2KT/6dPFKAEm4ve9WeqjaQ82SkowbZ5lof5AVA9LXoRgZ9iX9Byy/0IuctE6I
	 vwL+Cks7j+YqNQc89PK32xuR88dqQvu5JBkycEpTE43SgkwYQI+ltFV7kK4i6cJMue
	 Xhj1gpnt90keMgCDWvGopEuKqnvEbb5WEZIS+w+M5h7VduaYiqV10og+szedr8BE8v
	 +YJZQtorAgdLOeljDPEXO9dELZViXWnZVxWfYQNqQzcgMFAOhGTEb3zCmkpFjki5Xw
	 3XCSi9T5a+rwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 4/8] crypto: geniv - use memcpy_sglist() instead of null skcipher
Date: Mon,  5 May 2025 12:10:41 -0700
Message-ID: <20250505191045.763835-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

For copying data between two scatterlists, just use memcpy_sglist()
instead of the so-called "null skcipher".  This is much simpler.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig                  |  1 -
 crypto/echainiv.c               | 18 +++---------------
 crypto/geniv.c                  | 13 +------------
 crypto/seqiv.c                  | 17 +++--------------
 include/crypto/internal/geniv.h |  1 -
 5 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 231791703594..f0c8cc5e30ae 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -813,11 +813,10 @@ config CRYPTO_GCM
 	  This is required for IPSec ESP (XFRM_ESP).
 
 config CRYPTO_GENIV
 	tristate
 	select CRYPTO_AEAD
-	select CRYPTO_NULL
 	select CRYPTO_MANAGER
 	select CRYPTO_RNG_DEFAULT
 
 config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 1913be8dfbba..e0a2d3209938 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -30,33 +30,21 @@ static int echainiv_encrypt(struct aead_request *req)
 	struct aead_request *subreq = aead_request_ctx(req);
 	__be64 nseqno;
 	u64 seqno;
 	u8 *info;
 	unsigned int ivsize = crypto_aead_ivsize(geniv);
-	int err;
 
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->child);
 
 	info = req->iv;
 
-	if (req->src != req->dst) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
-
-		skcipher_request_set_sync_tfm(nreq, ctx->sknull);
-		skcipher_request_set_callback(nreq, req->base.flags,
-					      NULL, NULL);
-		skcipher_request_set_crypt(nreq, req->src, req->dst,
-					   req->assoclen + req->cryptlen,
-					   NULL);
-
-		err = crypto_skcipher_encrypt(nreq);
-		if (err)
-			return err;
-	}
+	if (req->src != req->dst)
+		memcpy_sglist(req->dst, req->src,
+			      req->assoclen + req->cryptlen);
 
 	aead_request_set_callback(subreq, req->base.flags,
 				  req->base.complete, req->base.data);
 	aead_request_set_crypt(subreq, req->dst, req->dst,
 			       req->cryptlen, info);
diff --git a/crypto/geniv.c b/crypto/geniv.c
index bee4621b4f12..42eff6a7387c 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -7,11 +7,10 @@
  * Copyright (c) 2007-2019 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
 #include <crypto/internal/geniv.h>
 #include <crypto/internal/rng.h>
-#include <crypto/null.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
@@ -123,41 +122,31 @@ int aead_init_geniv(struct crypto_aead *aead)
 				   crypto_aead_ivsize(aead));
 	crypto_put_default_rng();
 	if (err)
 		goto out;
 
-	ctx->sknull = crypto_get_default_null_skcipher();
-	err = PTR_ERR(ctx->sknull);
-	if (IS_ERR(ctx->sknull))
-		goto out;
-
 	child = crypto_spawn_aead(aead_instance_ctx(inst));
 	err = PTR_ERR(child);
 	if (IS_ERR(child))
-		goto drop_null;
+		goto out;
 
 	ctx->child = child;
 	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(child) +
 				      sizeof(struct aead_request));
 
 	err = 0;
 
 out:
 	return err;
-
-drop_null:
-	crypto_put_default_null_skcipher();
-	goto out;
 }
 EXPORT_SYMBOL_GPL(aead_init_geniv);
 
 void aead_exit_geniv(struct crypto_aead *tfm)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher();
 }
 EXPORT_SYMBOL_GPL(aead_exit_geniv);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Shared IV generator code");
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index a17ef5184398..2bae99e33526 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -62,24 +62,13 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 
 	compl = req->base.complete;
 	data = req->base.data;
 	info = req->iv;
 
-	if (req->src != req->dst) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
-
-		skcipher_request_set_sync_tfm(nreq, ctx->sknull);
-		skcipher_request_set_callback(nreq, req->base.flags,
-					      NULL, NULL);
-		skcipher_request_set_crypt(nreq, req->src, req->dst,
-					   req->assoclen + req->cryptlen,
-					   NULL);
-
-		err = crypto_skcipher_encrypt(nreq);
-		if (err)
-			return err;
-	}
+	if (req->src != req->dst)
+		memcpy_sglist(req->dst, req->src,
+			      req->assoclen + req->cryptlen);
 
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
 		info = kmemdup(req->iv, ivsize, req->base.flags &
 			       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 7fd7126f593a..012f5fb22d43 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -13,11 +13,10 @@
 #include <linux/types.h>
 
 struct aead_geniv_ctx {
 	spinlock_t lock;
 	struct crypto_aead *child;
-	struct crypto_sync_skcipher *sknull;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb);
-- 
2.49.0

