Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4C239D6E5;
	Fri, 22 May 2026 05:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779427871; cv=none; b=e7owNSqzVw8S02EJ9iFGpdg06NPf26rjn3f/ZFuBJfY49PSYZ7jtuStYhGmPxYf5pziUZkHM4l9PXIpRCj8YPRsflbPu180s4Sr4nCY+Of+dnLBYCTI0v2PZl3KXrbA1if0AKV6S3LOAGyH67TcJVMFf+EJfx+W80vwiNFf7AJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779427871; c=relaxed/simple;
	bh=AR2nEb1BVonvAdMGkQZ1BqhRzgsbWMLcsp9YHHUC2O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch/efxii4hjRYMgVCDgJonYy4+bA3B+en7yU7o1ZqKkZBHEDPnyC8x0uvgMMMcPv0cESBKw3uxnWFKsCHCVJD0CAfq0IWmfNSxnnt5j8ISHf7ZJ0TMf173VRenR9aVCE/Vq/cy14hrPSsvqDEtPY69RxTY1dlI1LpbwgNwk7N7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzSnbTOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzSnbTOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B798F1F0155C;
	Fri, 22 May 2026 05:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779427867;
	bh=4QQndDPWvh1YB8HkexAm4q1eabiEB73T4wQ84oA0onE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzSnbTOn/XMNlD3+tQdExBgv0rIz2RsTJ1n3mmbofXN96ZKum/3ACo0ckijqWeXCm
	 Xn/bBS8YCxV92B5V5HaGg5FqoOTOSZ41kyQFOG+ZaAuH6OuqhatSLOe2sBRp64uZJi
	 Fvx9+ASKE8pJB144ytI3gDNnbX7GQAWEsd+UbBUeDQ4BzK5SkBfoRrgrnL1forjnLu
	 GBHGRNgr80qDumtsM7cLdE2m/3zPVM+ntny/ot4AXn18Ab4538v4k637Izf9883w0V
	 /YyQg9QWxXKUOyDwGf1pbbd/khpC5dfC8ZVl2anoXdNtTDzU6tk8/ee9rgIbVKN4u1
	 49sSrAmk/5Oeg==
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
Subject: [PATCH net-next 5/6] crypto: api - Fold __crypto_alloc_tfmgfp() into __crypto_alloc_tfm()
Date: Fri, 22 May 2026 00:30:27 -0500
Message-ID: <20260522053028.91165-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522053028.91165-1-ebiggers@kernel.org>
References: <20260522053028.91165-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit fa3b3565f3ac ("crypto: api - Add
__crypto_alloc_tfmgfp").

Fold __crypto_alloc_tfmgfp() into its only remaining caller,
__crypto_alloc_tfm().  Previously __crypto_alloc_tfmgfp() was called by
crypto_clone_cipher(), but crypto_clone_cipher() was removed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/api.c      | 13 +++----------
 crypto/internal.h |  2 --
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index be9ee104ffc2..5bd0db7fa665 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -403,19 +403,19 @@ void crypto_shoot_alg(struct crypto_alg *alg)
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
-struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
-					 u32 mask, gfp_t gfp)
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
+				      u32 mask)
 {
 	struct crypto_tfm *tfm;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
 	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
-	tfm = kzalloc(tfm_size, gfp);
+	tfm = kzalloc(tfm_size, GFP_KERNEL);
 	if (tfm == NULL)
 		goto out_err;
 
 	tfm->__crt_alg = alg;
 
@@ -432,17 +432,10 @@ struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
 out_err:
 	tfm = ERR_PTR(err);
 out:
 	return tfm;
 }
-EXPORT_SYMBOL_GPL(__crypto_alloc_tfmgfp);
-
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask)
-{
-	return __crypto_alloc_tfmgfp(alg, type, mask, GFP_KERNEL);
-}
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
 /*
  *	crypto_alloc_base - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
diff --git a/crypto/internal.h b/crypto/internal.h
index b6e437f463d4..b0a10986f61e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -117,12 +117,10 @@ void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
-struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
-					 u32 mask, gfp_t gfp);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
 
-- 
2.54.0

