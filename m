Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3910FD
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736104884; cv=none; b=DpO6XscrztsiL9b/7PL/xjqsqwyyvkextByfs0pqymdpVSja8uVWcphHxUz0E+32DkfSOOpAU7tX/FVnOsgaRUjcHsG0e6utobh4cctqTR02Vu9c25qnjkEewDljBjutAe+8UKSEF8giv8XdQiZ9FLMPkKNYXqQgZ7TvGHn2L78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736104884; c=relaxed/simple;
	bh=Ui7IP2Y8Ot5SeE3bpeVS9SLWPY7zGqsAyHDmSDNQjUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJGSvdeffH7tRfzHuZqHLM3FsG6LqGRnGYqTRDuYUloPizZWFIj3hb1bGDHScwvEDH5nBiZq7iZAK/dDRRoYmIq1pJRXlSAMOVtV0YnaFLCMRc60mFZhSKLLcWZ1uLE2s2pGaZBOFauQMdZLMJKGXnrr202g4+3g7JRmp3zc6tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ef+5CRUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ef+5CRUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94256C4CED0;
	Sun,  5 Jan 2025 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736104883;
	bh=Ui7IP2Y8Ot5SeE3bpeVS9SLWPY7zGqsAyHDmSDNQjUY=;
	h=From:To:Cc:Subject:Date:From;
	b=Ef+5CRUDBX1sVIG1LRy0sX5H5p++a8k8WX4mvsL9oKH4nG4qPHL8HZMAFIpg2xZGA
	 Y+s66F9S41XCqrGIcNe9g+lnkp/tjue//GczN/8BVrdi2kG5WvpUh60fkfZ+hSQZjc
	 jz6KYN/mc9dCXM3/RbMLDb32bBNDFV4W82wFtOUdAKPO5/KyqPZq0r3FtfkIcgVPRs
	 IKy2Z6/Gu8N6wVCrl4EaKlw3Lun9exkEhJXYbwo4P95v+bKbQt+P0crW5Q16evgWps
	 IWvWjPHGYD7oWqAd0PU62PzASwGlb4Ldz4SV2kZ+ElsGefQJWC5vvuwqpkiBbzr7xQ
	 A46SvJygMG1CQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Danny Tsen <dtsen@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3] crypto: powerpc/p10-aes-gcm - simplify handling of linear associated data
Date: Sun,  5 Jan 2025 11:21:10 -0800
Message-ID: <20250105192110.34634-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

p10_aes_gcm_crypt() is abusing the scatter_walk API to get the virtual
address for the first source scatterlist element.  But this code is only
built for PPC64 which is a !HIGHMEM platform, and it can read past a
page boundary from the address returned by scatterwalk_map() which means
it already assumes the address is from the kernel's direct map.  Thus,
just use sg_virt() instead to get the same result in a simpler way.

Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Danny Tsen <dtsen@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v3: don't check for NULL before calling kfree(),
    and resent this patch as a standalone patch.

 arch/powerpc/crypto/aes-gcm-p10-glue.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index f37b3d13fc53..679f52794baf 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -212,11 +212,10 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
 	u8 databuf[sizeof(struct gcm_ctx) + PPC_ALIGN];
 	struct gcm_ctx *gctx = PTR_ALIGN((void *)databuf, PPC_ALIGN);
 	u8 hashbuf[sizeof(struct Hash_ctx) + PPC_ALIGN];
 	struct Hash_ctx *hash = PTR_ALIGN((void *)hashbuf, PPC_ALIGN);
-	struct scatter_walk assoc_sg_walk;
 	struct skcipher_walk walk;
 	u8 *assocmem = NULL;
 	u8 *assoc;
 	unsigned int cryptlen = req->cryptlen;
 	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
@@ -232,12 +231,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 	memset(ivbuf, 0, sizeof(ivbuf));
 	memcpy(iv, riv, GCM_IV_SIZE);
 
 	/* Linearize assoc, if not already linear */
 	if (req->src->length >= assoclen && req->src->length) {
-		scatterwalk_start(&assoc_sg_walk, req->src);
-		assoc = scatterwalk_map(&assoc_sg_walk);
+		assoc = sg_virt(req->src); /* ppc64 is !HIGHMEM */
 	} else {
 		gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 			      GFP_KERNEL : GFP_ATOMIC;
 
 		/* assoc can be any length, so must be on heap */
@@ -251,14 +249,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
 	vsx_begin();
 	gcmp10_init(gctx, iv, (unsigned char *) &ctx->enc_key, hash, assoc, assoclen);
 	vsx_end();
 
-	if (!assocmem)
-		scatterwalk_unmap(assoc);
-	else
-		kfree(assocmem);
+	kfree(assocmem);
 
 	if (enc)
 		ret = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
 		ret = skcipher_walk_aead_decrypt(&walk, req, false);

base-commit: 7fa4817340161a34d5b4ca39e96d6318d37c1d3a
-- 
2.47.1

