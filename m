Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0853A05CC;
	Fri, 22 May 2026 05:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779427870; cv=none; b=bcPwM1t5Cq1SUHudElbMJQrqU9wziJ9WI6UWkfW0X5qzWPQXtMrd44SlRO/vEy41OAJ2flnbdisyTlha60mGQO015Ve5/VXCRcVyPo9AaUf/E0P9y+vyK6pfPUXVwGjMb0NAlXNZOZtbNlMUo1TBxl1Q1mOPYneiiEv/MccLwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779427870; c=relaxed/simple;
	bh=odCxtkvpCQLnlVzA4Uh1Dn8AMGZiHF408qHVpzDK3CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjzNBzvrVc6EVGa8J7U9fBD4Ly3LOttHR6f9r629weB5R+EFjuTOZtBKWgvAXTAe5y/RLBOwVVRJGeaoERx0Vwwph00vPXoumj2e1DGfwsRSMc4kWdUZG4WuMyxKqML1t+WwBsO/tcNwzTeAIAprILmFVVle/y39mRJYMMxoh5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nkns0oAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nkns0oAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D7F1F00A3F;
	Fri, 22 May 2026 05:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779427869;
	bh=tFooZ+Qu8ZYwrwEty71u0yYcZtQRNdJkO8GXcz+8awE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nkns0oAT7e1svaNqyDx7lyvB90g6mEkZW+TWiCYjll65mFuEVPrcDS49y5YMTKWH7
	 kSOXeZeTrVfCVfuLXyzcnh3NrwasgQEiz+QDpLFopI4hBpAL7aoZu//o6LKO4j6YhG
	 NQY1RP0tmuip6Kgi1a5mMc7DrgAOwdxN8nFmnu6BZIq3iCdML0XyeTTrWPLbbaIBFW
	 IpUtzX9brpZPaaYKTHFB7Ivh/qdeVwGshNK3ES0soqUe4Pftw4ybBQkMKGmJrfGIRu
	 I0OejT2Q3CWq/KvCD1jwygFcF1Yygd+HA4ka3PDeXQUrHRvD6nwag1KxHR321Ojk01
	 n6HtoZJAL9aPg==
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
Subject: [PATCH net-next 6/6] crypto: api - Fold crypto_alloc_tfmmem() into crypto_create_tfm_node()
Date: Fri, 22 May 2026 00:30:28 -0500
Message-ID: <20260522053028.91165-7-ebiggers@kernel.org>
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

Fold crypto_alloc_tfmmem() into its only remaining caller,
crypto_create_tfm_node().  Previously crypto_alloc_tfmmem() was called
by crypto_clone_tfm(), but crypto_clone_tfm() was removed.

This rolls back the refactoring that was done in commit 3c3a24cb0ae4
("crypto: api - Add crypto_clone_tfm").

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/api.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 5bd0db7fa665..4349c2caa23a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -490,46 +490,27 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
-static void *crypto_alloc_tfmmem(struct crypto_alg *alg,
-				 const struct crypto_type *frontend, int node,
-				 gfp_t gfp)
-{
-	struct crypto_tfm *tfm;
-	unsigned int tfmsize;
-	unsigned int total;
-	char *mem;
-
-	tfmsize = frontend->tfmsize;
-	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg);
-
-	mem = kzalloc_node(total, gfp, node);
-	if (mem == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	tfm = (struct crypto_tfm *)(mem + tfmsize);
-	tfm->__crt_alg = alg;
-	tfm->node = node;
-
-	return mem;
-}
-
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			     const struct crypto_type *frontend,
 			     int node)
 {
 	struct crypto_tfm *tfm;
+	size_t size;
 	char *mem;
 	int err;
 
-	mem = crypto_alloc_tfmmem(alg, frontend, node, GFP_KERNEL);
-	if (IS_ERR(mem))
-		goto out;
+	size = frontend->tfmsize + sizeof(*tfm) + frontend->extsize(alg);
+	mem = kzalloc_node(size, GFP_KERNEL, node);
+	if (!mem)
+		return ERR_PTR(-ENOMEM);
 
 	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+	tfm->__crt_alg = alg;
+	tfm->node = node;
 	tfm->fb = tfm;
 
 	err = frontend->init_tfm(tfm);
 	if (err)
 		goto out_free_tfm;
-- 
2.54.0

