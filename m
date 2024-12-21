Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0AC1F191F
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772293; cv=none; b=JW4HmHLp+GJL9lxjMEiyy0ga2lzwXr3/LLMErSD5czo5jFOG/8Q7CJV/VG9UX8KusakgEk8gKbfxhGeDb0dKhNHDfMRrKJ0jD+kz28fgLZObuqnk83+yxXk9Z3bp1wm2+swBqXIB/mWLNkslS84b+MNtBZQQ40awSO8rMZCpuX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772293; c=relaxed/simple;
	bh=l3mcIF8SEtYBua+ussMVqyNpUvcPBoNrQm89sO2KshY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuxR3uyYPw17DcnFIhhpgrQfB5rBWkd1fyOaHqYnxARLkEPux5IdGiezCH1iwqokyAw83lPFl+r/9/YiewnDipMfnagqTVrJea8MoFqUFPFLKUeTyEjM0LXhbOYs58bP8MjOU9+/TQAvGAihT+kavRuHoJq8zAKeiikDXjdDWq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPCAlzTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPCAlzTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB71C4CED6;
	Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772292;
	bh=l3mcIF8SEtYBua+ussMVqyNpUvcPBoNrQm89sO2KshY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPCAlzTLn/W65gAW/TitVUHpbJl+s+1DDEg/itXgrgIkSwyK2j4ddjr34saeXx/Lo
	 lhiPqNp/rwMt/PuOq4DrFrzKO2Y0cHTvxoB3QleRaAyw9l35Fp5ggbouBmOcPbMFEr
	 5QHdMaH2wivdWqDtMSn0r6aMQZWnCD3ldtBTcJcQoPQoUKeqdx4QtfcXCvXP4Dh8M7
	 JaewEW5EiNRJaB4i+W9BXWx8VggIvG+In98ebpKQOSihl5m9IPIElTH4bcepP+2MzR
	 yXljeZIySVQlendyQl2f5FtTZNctAjsmX3+2nK/EGGs0NwVOOV0jemWqYL1DIxf/bp
	 sbjl51d9JMjZQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Danny Tsen <dtsen@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 10/29] crypto: powerpc/p10-aes-gcm - simplify handling of linear associated data
Date: Sat, 21 Dec 2024 01:10:37 -0800
Message-ID: <20241221091056.282098-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 arch/powerpc/crypto/aes-gcm-p10-glue.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index f37b3d13fc53..2862c3cf8e41 100644
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
@@ -251,13 +249,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
 	vsx_begin();
 	gcmp10_init(gctx, iv, (unsigned char *) &ctx->enc_key, hash, assoc, assoclen);
 	vsx_end();
 
-	if (!assocmem)
-		scatterwalk_unmap(assoc);
-	else
+	if (assocmem)
 		kfree(assocmem);
 
 	if (enc)
 		ret = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
-- 
2.47.1

