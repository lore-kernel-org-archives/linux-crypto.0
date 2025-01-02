Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDB51F16B;
	Thu,  2 Jan 2025 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735838687; cv=none; b=VsPcSxK9sD1nkwhuqO2fXkaVnWPku/6TnLHbNHaL4TL/YiBl8EQtVyTSvbS/0dVyJNh5IagFUc1mxH/zqDjVCVKfrr1SkJe5tof59qCtYiIMPHZ5n/6JstlpJJM6Y6syH8ooxLEriU+RGjQSldjpdNZ/zEcrI8lEU3ehA+cmOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735838687; c=relaxed/simple;
	bh=dhAKobW2Sn3UJxdMEMFF+/VJXFN/vgYVY2Kdus9Irc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4taq6j8PSdGgb1DOuQfw41JzsiKEdtD2f0Ga35ep6ALDQ/BR5lzbOSnm1ZGPkknHQFnqtFfvU6R4z9jzEgPb5KSYgsGira/2qElLsueTt9zTcLnSDoCsRZH7GHmn3iciAtlG2odMekAcEgZGr7/zb1vU2X8lkCzeIgMcdyRRp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjRfdJPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjRfdJPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F20C4CED0;
	Thu,  2 Jan 2025 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735838686;
	bh=dhAKobW2Sn3UJxdMEMFF+/VJXFN/vgYVY2Kdus9Irc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AjRfdJPcjYi4nv0p4ONg/pmLvQ/6q9hbqdWm92KbRtJ9C0henHMq2lTFg21M9Gnj6
	 ZfWQYaJb+Ay0/MZaZj92C1BZjLCJJJBLqIBPrljMgam2Kl/6ViYf1/FSbzyW/3gkMV
	 H1wZBaskVXi2fJk+Cg8LoKdnuWwHsPN2Kl1oyhI14dKva46zqIFRLFHK6L2Vj7gTJE
	 QIIbI4uMo7HX6jCu/Ml/LePfxEpEic9/8kIfjwHNgMPBvnKlpB6hdo8JQppL3VA0Hl
	 A04pidWhCcnL3sMGhq0ThkAC5Y2Ksi62eqIo0dwKPxHqTNl1mHNPU82llGLsmFqg+x
	 B+kCaSt9e2EnA==
Date: Thu, 2 Jan 2025 17:24:44 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Danny Tsen <dtsen@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 10/29] crypto: powerpc/p10-aes-gcm - simplify handling
 of linear associated data
Message-ID: <20250102172444.GB49952@google.com>
References: <20241230001418.74739-1-ebiggers@kernel.org>
 <20241230001418.74739-11-ebiggers@kernel.org>
 <ec3515f1-f93a-4520-a9da-6ad14f9a6fe0@csgroup.eu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec3515f1-f93a-4520-a9da-6ad14f9a6fe0@csgroup.eu>

On Thu, Jan 02, 2025 at 12:50:50PM +0100, Christophe Leroy wrote:
> 
> 
> Le 30/12/2024 à 01:13, Eric Biggers a écrit :
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > p10_aes_gcm_crypt() is abusing the scatter_walk API to get the virtual
> > address for the first source scatterlist element.  But this code is only
> > built for PPC64 which is a !HIGHMEM platform, and it can read past a
> > page boundary from the address returned by scatterwalk_map() which means
> > it already assumes the address is from the kernel's direct map.  Thus,
> > just use sg_virt() instead to get the same result in a simpler way.
> > 
> > Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Cc: Danny Tsen <dtsen@linux.ibm.com>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Naveen N Rao <naveen@kernel.org>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > This patch is part of a long series touching many files, so I have
> > limited the Cc list on the full series.  If you want the full series and
> > did not receive it, please retrieve it from lore.kernel.org.
> > 
> >   arch/powerpc/crypto/aes-gcm-p10-glue.c | 8 ++------
> >   1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > index f37b3d13fc53..2862c3cf8e41 100644
> > --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > @@ -212,11 +212,10 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
> >   	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
> >   	u8 databuf[sizeof(struct gcm_ctx) + PPC_ALIGN];
> >   	struct gcm_ctx *gctx = PTR_ALIGN((void *)databuf, PPC_ALIGN);
> >   	u8 hashbuf[sizeof(struct Hash_ctx) + PPC_ALIGN];
> >   	struct Hash_ctx *hash = PTR_ALIGN((void *)hashbuf, PPC_ALIGN);
> > -	struct scatter_walk assoc_sg_walk;
> >   	struct skcipher_walk walk;
> >   	u8 *assocmem = NULL;
> >   	u8 *assoc;
> >   	unsigned int cryptlen = req->cryptlen;
> >   	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
> > @@ -232,12 +231,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
> >   	memset(ivbuf, 0, sizeof(ivbuf));
> >   	memcpy(iv, riv, GCM_IV_SIZE);
> >   	/* Linearize assoc, if not already linear */
> >   	if (req->src->length >= assoclen && req->src->length) {
> > -		scatterwalk_start(&assoc_sg_walk, req->src);
> > -		assoc = scatterwalk_map(&assoc_sg_walk);
> > +		assoc = sg_virt(req->src); /* ppc64 is !HIGHMEM */
> >   	} else {
> >   		gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
> >   			      GFP_KERNEL : GFP_ATOMIC;
> >   		/* assoc can be any length, so must be on heap */
> > @@ -251,13 +249,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
> >   	vsx_begin();
> >   	gcmp10_init(gctx, iv, (unsigned char *) &ctx->enc_key, hash, assoc, assoclen);
> >   	vsx_end();
> > -	if (!assocmem)
> > -		scatterwalk_unmap(assoc);
> > -	else
> > +	if (assocmem)
> >   		kfree(assocmem);
> 
> kfree() accepts a NULL pointer, you can call kfree(assocmem) without 'if
> (assocmem)'

The existing code did that too, but sure I'll change that in v3.

- Eric
