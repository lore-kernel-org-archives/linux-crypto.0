Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BEA2BE05F;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066318; cv=none; b=oFd81qcrUD0iY2iG641f3urvrDhsIIz9qeaE9/6q5F+9QYknfo1DKinWs+A3VcDWJWbbuITdYDEc8xMajh5lxM0zPGBEk2MdERQl2I7STQhAc2d6uEKf/chJs0cBLGMJkNx7Xnm19QS9Z0hdTVExMPIhVQmAQFHA6YIqSy5cNZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066318; c=relaxed/simple;
	bh=y/3un15qteBURfKcq9gIDYwg3DO/kIiH8GH2drBtg8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jroX7fU6Faj2eDyI1ahniMCBU3jsl1szp8q/2Lx9n9YJdwQ/YqZXRMun4mHTA8cnAmHmZfjb2pPgdrr0kPBT10qmNX2wS3P03yM62DNhpB0CjCA4VZrXD0cLwleCO+jsCtCHeYlJCkv7+kW33pv32st/w3LeFkN76nmEF7NSwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsLA5d17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsLA5d17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16162C19425;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066318;
	bh=y/3un15qteBURfKcq9gIDYwg3DO/kIiH8GH2drBtg8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsLA5d17opcaIkl94J2l95BEsSIVek2NJMQtNN7rxEInVMyW0bbawElreA1i4iQs6
	 g+B54mANxslsTKe5cyTc+36PdFlRKrWF2WUi0o31a2KZRjaUefll7XuP0n769C0OV8
	 yqvMZ/k0L2XibEFWudtKFq4FfWHluPhF3ur2Z65nuD5gfAFPiq5RmCGZsulPH9ZVQ+
	 MLO0QaViqPGjUyQZO9hOhvS/cMKlXtc+HElCLn2fD0Sd5wzVgKBOx9WSSP3ROj0sfP
	 JSkMixtBFOXKNZjpQuiZepSNAS3IAWpW6/3fESFjPoSu1TOo2/uJ46voavWCP4PItF
	 5nRo/4WpNCnZg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 01/12] crypto: sm3 - Fold sm3_init() into its caller
Date: Fri, 20 Mar 2026 21:09:24 -0700
Message-ID: <20260321040935.410034-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fold sm3_init() into its caller to free up the name for use in a library
API mirroring the other hash function APIs.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sm3.h      | 13 -------------
 include/crypto/sm3_base.h | 12 +++++++++++-
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index c8d02c86c298..c09f6bf4c0bf 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -44,21 +44,8 @@ struct sm3_state {
  * amounts of data as those APIs may be hw-accelerated.
  *
  * For details see lib/crypto/sm3.c
  */
 
-static inline void sm3_init(struct sm3_state *sctx)
-{
-	sctx->state[0] = SM3_IVA;
-	sctx->state[1] = SM3_IVB;
-	sctx->state[2] = SM3_IVC;
-	sctx->state[3] = SM3_IVD;
-	sctx->state[4] = SM3_IVE;
-	sctx->state[5] = SM3_IVF;
-	sctx->state[6] = SM3_IVG;
-	sctx->state[7] = SM3_IVH;
-	sctx->count = 0;
-}
-
 void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
 
 #endif
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index 7c53570bc05e..9fa995617495 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -19,11 +19,21 @@
 
 typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
 
 static inline int sm3_base_init(struct shash_desc *desc)
 {
-	sm3_init(shash_desc_ctx(desc));
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SM3_IVA;
+	sctx->state[1] = SM3_IVB;
+	sctx->state[2] = SM3_IVC;
+	sctx->state[3] = SM3_IVD;
+	sctx->state[4] = SM3_IVE;
+	sctx->state[5] = SM3_IVF;
+	sctx->state[6] = SM3_IVG;
+	sctx->state[7] = SM3_IVH;
+	sctx->count = 0;
 	return 0;
 }
 
 static inline int sm3_base_do_update_blocks(struct shash_desc *desc,
 					    const u8 *data, unsigned int len,
-- 
2.53.0

