Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62023624AB;
	Fri, 22 May 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779472936; cv=none; b=HVq19UW8xTWHpCCc8y8IMLE/LZ1oTfYFjiFvcugIfsbqfCsVVP9lm1Dw1ez9Cn4gQ0J0x9gtjuUJiv/WD7632aodwaZ1KyAf8dgS53kyp99JUU3nA9SSNWi95NkD+C2HK/OYTgQk2TQJhZpj6LG0fGXBWIYwvuipqg+IcvhIY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779472936; c=relaxed/simple;
	bh=BmsRP5oUvRO6Qp09aSpj64PyEh6RLCSiMRONgKSqVyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cl5rhZfKDPQgk3MRrGUBkM1DURgahyrhtiCwv1awnt8FBJXXJivTAVOfIIsVzXx6QK5IOSub72H7b7hxkBDtc3tqoOvWzC0NwPpbi4OMiCoz0f1l4bGkpUYF5LAXdP6cQ5bIi/QqPIUM0P5CjtL24lwaDHszB9kSYa0b40f6hKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from localhost (1.5.5.2.4.d.e.f.f.f.5.f.9.d.6.0.a.5.c.d.c.d.9.1.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:19dc:dc5a:6d9:f5ff:fed4:2551])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sam@gentoo.org)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 3EDE4342BD1;
	Fri, 22 May 2026 18:02:11 +0000 (UTC)
From: Sam James <sam@gentoo.org>
To: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Sam James <sam@gentoo.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Calvin Buckley <calvin@cmpct.info>,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: nx: fix nx_crypto_ctx_exit argument
Date: Fri, 22 May 2026 19:01:42 +0100
Message-ID: <a3e89c1e8342ffa415b0d29725a0571a4f355d34.1779472902.git.sam@gentoo.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nx_crypto_ctx_shash_exit calls nx_crypto_ctx_exit with crypto_shash_ctx(...)
but crypto_shash_ctx gives a nx_crypto_ctx *, not a crypto_tfm *.

Fix the type in nx_crypto_ctx_exit and drop the bogus crypto_tfm_ctx
call.

This fixes the following oops:

  BUG: Unable to handle kernel data access at 0xc0403effffffffc8
  Faulting instruction address: 0xc000000000396cb4
  Oops: Kernel access of bad area, sig: 11 [#15]
  Call Trace:
   nx_crypto_ctx_shash_exit+0x24/0x60
   crypto_shash_exit_tfm+0x28/0x40
   crypto_destroy_tfm+0x98/0x140
   crypto_exit_ahash_using_shash+0x20/0x40
   crypto_destroy_tfm+0x98/0x140
   hash_release+0x1c/0x30
   alg_sock_destruct+0x38/0x60
   __sk_destruct+0x48/0x2b0
   af_alg_release+0x58/0xb0
   __sock_release+0x68/0x150
   sock_close+0x20/0x40
   __fput+0x110/0x3a0
   sys_close+0x48/0xa0
   system_call_exception+0x140/0x2d0
   system_call_common+0xf4/0x258

.. which came from hardlink(1) opportunistically using AF_ALG.

The same problem exists with nx_crypto_ctx_skcipher_exit getting a context
it wasn't expecting, but apparently nobody hit that for years.

Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: bfd9efddf990 ("crypto: nx - convert AES-ECB to skcipher API")
Fixes: 9420e628e7d8 ("crypto: nx - Use API partial block handling")
Reported-by: Calvin Buckley <calvin@cmpct.info>
Tested-by: Calvin Buckley <calvin@cmpct.info>
Suggested-by: Brad Spengler <brad.spengler@opensrcsec.com>
Signed-off-by: Sam James <sam@gentoo.org>
---
 drivers/crypto/nx/nx.c | 4 +---
 drivers/crypto/nx/nx.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 78135fb13f5c..101e7fc7c1af 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -719,10 +719,8 @@ int nx_crypto_ctx_aes_xcbc_init(struct crypto_shash *tfm)
  * As crypto API contexts are destroyed, this exit hook is called to free the
  * memory associated with it.
  */
-void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
+void nx_crypto_ctx_exit(struct nx_crypto_ctx *nx_ctx)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
-
 	kfree_sensitive(nx_ctx->kmem);
 	nx_ctx->csbcpb = NULL;
 	nx_ctx->csbcpb_aead = NULL;
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 36974f08490a..6dfabfbf8192 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -153,7 +153,7 @@ int nx_crypto_ctx_aes_ctr_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_shash *tfm);
-void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
+void nx_crypto_ctx_exit(struct nx_crypto_ctx *nx_ctx);
 void nx_crypto_ctx_skcipher_exit(struct crypto_skcipher *tfm);
 void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
 void nx_crypto_ctx_shash_exit(struct crypto_shash *tfm);

base-commit: 758c807bb943138f887d42d986b645e12446ba9c
-- 
2.54.0

