Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF56199FBA;
	Thu,  2 Jan 2025 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735822205; cv=none; b=fpZo0CcDVRLahgxgPSXSjyxh4mvFqcvVVtKrHvYqznuMoNNPBJwdY4QAm1dmlqTHl6F89kTqOELh8eiTCac1z7fXSqOAIk7UGgDpcL44HDWi2SZkanvuGvppCBFte1G8Q0bPw1eXmA2dVLpsGcrjWSSRQmuMMzcAKiQM8G/KWUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735822205; c=relaxed/simple;
	bh=6ZPOzpvYsAqlz7hdFo+/nt9VXVrrtsVFa6L3sxM17J0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ip8+vdNnBxBqUsnIWmP0r7wDM3HFcqX4Jr/3RgyW2ZAyOw7r4vPgAFNycdxbVMk/jqWNfZ0ZZ5ioVQf/fGNRR4LnDMVR1e+kuQ+B4AbBWwUgpJhoi/MVyno2oAxQ9ejk7KYTMV9esV1u7GzDG9zaEenymO6z5bP2qWv+/ZWUSKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4YP4lv3gC6z9shx;
	Thu,  2 Jan 2025 12:50:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qCix7nZ6SYKj; Thu,  2 Jan 2025 12:50:51 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4YP4lv2m0zz9shw;
	Thu,  2 Jan 2025 12:50:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4E98E8B767;
	Thu,  2 Jan 2025 12:50:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id Oius1QCwqKti; Thu,  2 Jan 2025 12:50:51 +0100 (CET)
Received: from [192.168.232.97] (unknown [192.168.232.97])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BDC3E8B763;
	Thu,  2 Jan 2025 12:50:50 +0100 (CET)
Message-ID: <ec3515f1-f93a-4520-a9da-6ad14f9a6fe0@csgroup.eu>
Date: Thu, 2 Jan 2025 12:50:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/29] crypto: powerpc/p10-aes-gcm - simplify handling
 of linear associated data
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Danny Tsen <dtsen@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Naveen N Rao <naveen@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
References: <20241230001418.74739-1-ebiggers@kernel.org>
 <20241230001418.74739-11-ebiggers@kernel.org>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241230001418.74739-11-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 30/12/2024 à 01:13, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> p10_aes_gcm_crypt() is abusing the scatter_walk API to get the virtual
> address for the first source scatterlist element.  But this code is only
> built for PPC64 which is a !HIGHMEM platform, and it can read past a
> page boundary from the address returned by scatterwalk_map() which means
> it already assumes the address is from the kernel's direct map.  Thus,
> just use sg_virt() instead to get the same result in a simpler way.
> 
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Danny Tsen <dtsen@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Naveen N Rao <naveen@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch is part of a long series touching many files, so I have
> limited the Cc list on the full series.  If you want the full series and
> did not receive it, please retrieve it from lore.kernel.org.
> 
>   arch/powerpc/crypto/aes-gcm-p10-glue.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> index f37b3d13fc53..2862c3cf8e41 100644
> --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> @@ -212,11 +212,10 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
>   	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
>   	u8 databuf[sizeof(struct gcm_ctx) + PPC_ALIGN];
>   	struct gcm_ctx *gctx = PTR_ALIGN((void *)databuf, PPC_ALIGN);
>   	u8 hashbuf[sizeof(struct Hash_ctx) + PPC_ALIGN];
>   	struct Hash_ctx *hash = PTR_ALIGN((void *)hashbuf, PPC_ALIGN);
> -	struct scatter_walk assoc_sg_walk;
>   	struct skcipher_walk walk;
>   	u8 *assocmem = NULL;
>   	u8 *assoc;
>   	unsigned int cryptlen = req->cryptlen;
>   	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
> @@ -232,12 +231,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
>   	memset(ivbuf, 0, sizeof(ivbuf));
>   	memcpy(iv, riv, GCM_IV_SIZE);
>   
>   	/* Linearize assoc, if not already linear */
>   	if (req->src->length >= assoclen && req->src->length) {
> -		scatterwalk_start(&assoc_sg_walk, req->src);
> -		assoc = scatterwalk_map(&assoc_sg_walk);
> +		assoc = sg_virt(req->src); /* ppc64 is !HIGHMEM */
>   	} else {
>   		gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>   			      GFP_KERNEL : GFP_ATOMIC;
>   
>   		/* assoc can be any length, so must be on heap */
> @@ -251,13 +249,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
>   
>   	vsx_begin();
>   	gcmp10_init(gctx, iv, (unsigned char *) &ctx->enc_key, hash, assoc, assoclen);
>   	vsx_end();
>   
> -	if (!assocmem)
> -		scatterwalk_unmap(assoc);
> -	else
> +	if (assocmem)
>   		kfree(assocmem);

kfree() accepts a NULL pointer, you can call kfree(assocmem) without 'if 
(assocmem)'


>   
>   	if (enc)
>   		ret = skcipher_walk_aead_encrypt(&walk, req, false);
>   	else

