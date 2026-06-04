Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43E466B53;
	Thu,  4 Jun 2026 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780576282; cv=none; b=C62Kbv8mfhO8EI41gYWgMNFyXTz+WxenDNwvEFHeZ1KBNE73V+vOsh0GVmyFS31CuK7XWeA/vcZcwuLBeVeQWvX+MMuao+wAyMRHyzUJnySjGlIVXdCARrsG+YfIEKFmDNkplEMiM4F7gs/cRA/0iLy6DcVGe+hwtwWyLE3pXbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780576282; c=relaxed/simple;
	bh=EnFkQk3LxiNsMfD93m64Ers8/6AYXJ/leKCPtAg4fcU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=ZGv+9OtFm4pz9gfSsOHEyJk6HfMcpPAD0A1It4Rvsk6mkn3ZelT1FXmCw/ZUoC048DS5mezbba2OJsar3oHJ87pBA3gXSvPyij19Ecxng5YuNFcaqmAWLB8qMdRqAimax37Az/l9U8dCF6AnylRHWZgjPDvpd5Bdn2SMJE0aQGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=sGD2RfK9; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="sGD2RfK9"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 20BF31A05EF;
	Thu,  4 Jun 2026 12:31:09 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D77F35FEF7;
	Thu,  4 Jun 2026 12:31:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8A680106A1A3F;
	Thu,  4 Jun 2026 14:31:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780576268; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=+V+g1ZiC1a18PSSBICf9HP6hRSYEBU+TIP7OHs/mFlw=;
	b=sGD2RfK9xp/caipRCqP/kqJQSih2RtORt44Mpz5f7madXNIGYuk53s/svemfNdkmhVxMct
	ShZPTeXJc6+w3trtPdufEjDymza6z22qt3UKTEEe8fWwK8pk/98UJu3Jtn5GrccUn3NLpR
	voToncE2zXG2dDMhoOY8/yHe5dpMfKHpPrAr6tUmb7iDZAg9oq3RKEoHZHHJ3Wbq+peKBx
	HS/ZO2X/g2l1T8RC1YrSmH+mTqi7qiN+xRCWHwyIrzsAT/EKjxcW3VPdWVXTDXmhCb4k8o
	0tuY0f2egHhi8SzN4/VB9DYTdzkgZnCl8QFAeyPndmiEJfWX5Madi+t4WxycRg==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jun 2026 14:31:03 +0200
Message-Id: <DJ09LV6A4NR7.1UB7BPJ0GKA8K@bootlin.com>
Subject: Re: [PATCH 07/29] crypto: talitos/hash - Move into separate file
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-7-cb1ad6cdea49@bootlin.com>
 <6a5ec43a-b05a-431c-9ace-2f7b58523895@kernel.org>
In-Reply-To: <6a5ec43a-b05a-431c-9ace-2f7b58523895@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

On Mon Jun 1, 2026 at 1:47 PM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Move the ahash algorithm implementations from talitos.c into a dedicated
>> talitos-hash.c file.
>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>
> While at it, (maybe another patch) the problem with size 0 hash on SEC1=
=20
> is not a driver bug but a hardware bug, it is therefore probably not=20
> worth a pr_err() because there is nothing the user can do about it and=20
> it is transparent as there is a workaround in the driver.

I was considering doing it differently too.
Instead of having a special case inside common_nonsnoop_hash(), handle it a=
t the
beginning in ahash_process_req() or ahash_update() : if nbytes =3D=3D 0 &&
first_request && last_request, create a scatterlist with a single entry. Th=
is
entry would be the static array with the padded bit.
It seems to me that it belongs more to the request preparation than to the
common_nonsnoop_hash() function, which is more about mapping the buffers an=
d
preparing the descriptor.

Anyway, I agree with the call to pr_err_once().

>> ---
>>   drivers/crypto/talitos/Makefile       |   2 +-
>>   drivers/crypto/talitos/talitos-hash.c | 832 ++++++++++++++++++++++++++=
++++++++
>>   drivers/crypto/talitos/talitos.c      | 807 +-------------------------=
-------
>>   drivers/crypto/talitos/talitos.h      |   4 +
>>   4 files changed, 847 insertions(+), 798 deletions(-)
>>=20
>> diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Ma=
kefile
>> index 901ec681f010..40d37f9364ef 100644
>> --- a/drivers/crypto/talitos/Makefile
>> +++ b/drivers/crypto/talitos/Makefile
>> @@ -1,3 +1,3 @@
>>   obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
>>  =20
>> -talitos-y :=3D talitos.o talitos-rng.o
>> +talitos-y :=3D talitos.o talitos-rng.o talitos-hash.o
>> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/tali=
tos/talitos-hash.c
>> new file mode 100644
>> index 000000000000..5792e7093392
>> --- /dev/null
>> +++ b/drivers/crypto/talitos/talitos-hash.c
>> @@ -0,0 +1,832 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +/*
>> + * Freescale SEC (talitos) hash implementation
>> + *
>> + * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
>> + */
>> +
>> +#include <linux/scatterlist.h>
>> +
>> +#include <crypto/hash.h>
>> +#include <crypto/internal/hash.h>
>> +#include <crypto/md5.h>
>> +#include <crypto/scatterwalk.h>
>> +#include <crypto/sha1.h>
>> +
>> +#include "talitos.h"
>> +
>> +#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
>> +#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_=
SHA512
>> +
>> +struct talitos_ahash_req_ctx {
>> +	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
>> +	unsigned int hw_context_size;
>> +	unsigned int swinit;
>> +	unsigned int first_request;
>> +	unsigned int last_request;
>> +	unsigned int to_hash_later;
>> +};
>> +
>> +struct talitos_export_state {
>> +	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
>> +	unsigned int swinit;
>> +	unsigned int first_request;
>> +	unsigned int last_request;
>> +	unsigned int to_hash_later;
>> +};
>> +
>> +static void common_nonsnoop_hash_unmap(struct device *dev,
>> +				       struct talitos_edesc *edesc,
>> +				       struct ahash_request *areq)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> +	bool is_sec1 =3D has_ftr_sec1(priv);
>> +	struct talitos_desc *desc =3D &edesc->desc;
>> +
>> +	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
>> +
>> +	if (edesc->last && req_ctx->last_request)
>> +		memcpy(areq->result, req_ctx->hw_context,
>> +		       crypto_ahash_digestsize(tfm));
>> +
>> +	if (edesc->src)
>> +		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
>> +
>> +	/* When using hashctx-in, must unmap it. */
>> +	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
>> +		unmap_single_talitos_ptr(dev, &desc->ptr[1],
>> +					 DMA_TO_DEVICE);
>> +
>> +	if (edesc->dma_len)
>> +		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
>> +				 DMA_BIDIRECTIONAL);
>> +}
>> +
>> +static void free_edesc_list_from(struct ahash_request *areq, struct tal=
itos_edesc *edesc)
>> +{
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(areq)=
);
>> +	struct talitos_edesc *next;
>> +
>> +	while (edesc) {
>> +		next =3D edesc->next_desc;
>> +		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
>> +		kfree(edesc);
>> +		edesc =3D next;
>> +	}
>> +}
>> +
>> +static void ahash_done(struct device *dev,
>> +		       struct talitos_desc *desc, void *context,
>> +		       int err)
>> +{
>> +	struct ahash_request *areq =3D context;
>> +	struct talitos_edesc *edesc =3D
>> +		 container_of(desc, struct talitos_edesc, desc);
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	bool is_sec1 =3D has_ftr_sec1(dev_get_drvdata(dev));
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct talitos_edesc *next;
>> +
>> +	if (is_sec1) {
>> +		free_edesc_list_from(areq, edesc);
>> +		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>> +	} else {
>> +		next =3D edesc->next_desc;
>> +
>> +		common_nonsnoop_hash_unmap(dev, edesc, areq);
>> +		kfree(edesc);
>> +
>> +		if (err)
>> +			goto out;
>> +
>> +		if (next) {
>> +			err =3D talitos_submit(dev, ctx->ch, &next->desc,
>> +					     ahash_done, areq);
>> +			if (err !=3D -EINPROGRESS)
>> +				goto out;
>> +			return;
>> +		}
>> +out:
>> +		if (err && next)
>> +			free_edesc_list_from(areq, next);
>> +		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>> +	}
>> +}
>> +
>> +/*
>> + * SEC1 doesn't like hashing of 0 sized message, so we do the padding
>> + * ourself and submit a padded block
>> + */
>> +static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
>> +			       struct talitos_edesc *edesc,
>> +			       struct talitos_ptr *ptr)
>> +{
>> +	static u8 padded_hash[64] =3D {
>> +		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> +		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> +		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> +		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> +	};
>> +
>> +	pr_err_once("Bug in SEC1, padding ourself\n");
>> +	edesc->desc.hdr &=3D ~DESC_HDR_MODE0_MDEU_PAD;
>> +	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
>> +			       (char *)padded_hash, DMA_TO_DEVICE);
>> +}
>> +
>> +static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>> +				 struct ahash_request *areq,
>> +				 unsigned int length)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct device *dev =3D ctx->dev;
>> +	struct talitos_desc *desc =3D &edesc->desc;
>> +	bool sync_needed =3D false;
>> +	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> +	bool is_sec1 =3D has_ftr_sec1(priv);
>> +	int sg_count;
>> +
>> +	/* first DWORD empty */
>> +
>> +	/* hash context in */
>> +	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
>> +		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
>> +					      req_ctx->hw_context_size,
>> +					      req_ctx->hw_context,
>> +					      DMA_TO_DEVICE);
>> +		req_ctx->swinit =3D 0;
>> +	}
>> +	/* Indicate next op is not the first. */
>> +	req_ctx->first_request =3D 0;
>> +
>> +	/* HMAC key */
>> +	if (ctx->keylen)
>> +		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
>> +			       is_sec1);
>> +
>> +	sg_count =3D edesc->src_nents ?: 1;
>> +	if (is_sec1 && sg_count > 1)
>> +		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
>> +	else if (length)
>> +		sg_count =3D dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
>> +
>> +	/*
>> +	 * data in
>> +	 */
>> +	sg_count =3D talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr=
[3],
>> +				  sg_count, 0, 0);
>> +	if (sg_count > 1)
>> +		sync_needed =3D true;
>> +
>> +	/* fifth DWORD empty */
>> +
>> +	/* hash/HMAC out -or- hash context out */
>> +	if (edesc->last && req_ctx->last_request)
>> +		map_single_talitos_ptr(dev, &desc->ptr[5],
>> +				       crypto_ahash_digestsize(tfm),
>> +				       req_ctx->hw_context, DMA_FROM_DEVICE);
>> +	else
>> +		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
>> +					      req_ctx->hw_context_size,
>> +					      req_ctx->hw_context,
>> +					      DMA_FROM_DEVICE);
>> +
>> +	/* last DWORD empty */
>> +
>> +	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) =3D=3D 0)
>> +		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
>> +
>> +	if (sync_needed)
>> +		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
>> +					   edesc->dma_len, DMA_BIDIRECTIONAL);
>> +}
>> +
>> +static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *ar=
eq,
>> +					       struct scatterlist *src,
>> +					       unsigned int nbytes)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +
>> +	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
>> +				   nbytes, 0, 0, 0, areq->base.flags, false);
>> +}
>> +
>> +static struct talitos_edesc *
>> +ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbyt=
es,
>> +			  unsigned int blocksize, bool is_sec1)
>> +{
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(areq)=
);
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct talitos_edesc *first =3D NULL, *prev_edesc =3D NULL, *edesc;
>> +	size_t desc_max =3D is_sec1 ? TALITOS1_MAX_DATA_LEN :
>> +				    TALITOS2_MAX_DATA_LEN;
>> +	struct scatterlist tmp[2];
>> +	size_t to_hash_this_desc;
>> +	struct scatterlist *src;
>> +	size_t offset =3D 0;
>> +
>> +	do {
>> +		src =3D scatterwalk_ffwd(tmp, areq->src, offset);
>> +
>> +		to_hash_this_desc =3D
>> +			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
>> +
>> +		/* Allocate extended descriptor */
>> +		edesc =3D ahash_edesc_alloc(areq, src, to_hash_this_desc);
>> +		if (IS_ERR(edesc)) {
>> +			if (first)
>> +				free_edesc_list_from(areq, first);
>> +			return edesc;
>> +		}
>> +
>> +		edesc->src =3D scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
>> +		edesc->desc.hdr =3D ctx->desc_hdr_template;
>> +		edesc->first =3D offset =3D=3D 0;
>> +		edesc->last =3D nbytes - to_hash_this_desc =3D=3D 0;
>> +
>> +		/* On last one, request SEC to pad; otherwise continue */
>> +		if (req_ctx->last_request && edesc->last)
>> +			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_PAD;
>> +		else
>> +			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_CONT;
>> +
>> +		/* request SEC to INIT hash. */
>> +		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
>> +			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_INIT;
>> +
>> +		/*
>> +		 * When the tfm context has a keylen, it's an HMAC.
>> +		 * A first or last (ie. not middle) descriptor must request HMAC.
>> +		 */
>> +		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
>> +				    (req_ctx->last_request && edesc->last)))
>> +			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_HMAC;
>> +
>> +		/* clear the DN bit  */
>> +		if (is_sec1 && !edesc->last)
>> +			edesc->desc.hdr &=3D ~DESC_HDR_DONE_NOTIFY;
>> +
>> +		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
>> +
>> +		offset +=3D to_hash_this_desc;
>> +		nbytes -=3D to_hash_this_desc;
>> +
>> +		if (!prev_edesc)
>> +			first =3D edesc;
>> +		else
>> +			prev_edesc->next_desc =3D edesc;
>> +		prev_edesc =3D edesc;
>> +	} while (nbytes);
>> +
>> +	return first;
>> +}
>> +
>> +static int ahash_process_req(struct ahash_request *areq, unsigned int n=
bytes)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct talitos_edesc *edesc;
>> +	unsigned int blocksize =3D
>> +			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
>> +	bool is_sec1 =3D has_ftr_sec1(dev_get_drvdata(ctx->dev));
>> +	unsigned int nbytes_to_hash;
>> +	unsigned int to_hash_later;
>> +	struct device *dev =3D ctx->dev;
>> +	int ret;
>> +
>> +	nbytes_to_hash =3D ALIGN_DOWN(nbytes, blocksize);
>> +	to_hash_later =3D nbytes - nbytes_to_hash;
>> +
>> +	if (req_ctx->last_request) {
>> +		nbytes_to_hash =3D nbytes;
>> +		to_hash_later =3D 0;
>> +	}
>> +
>> +	req_ctx->to_hash_later =3D to_hash_later;
>> +
>> +	edesc =3D ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
>> +					  is_sec1);
>> +	if (IS_ERR(edesc))
>> +		return PTR_ERR(edesc);
>> +
>> +	ret =3D talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
>> +	if (ret !=3D -EINPROGRESS)
>> +		free_edesc_list_from(areq, edesc);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ahash_init(struct ahash_request *areq)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct device *dev =3D ctx->dev;
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	unsigned int size;
>> +	dma_addr_t dma;
>> +
>> +	/* Initialize the context */
>> +	req_ctx->first_request =3D 1;
>> +	req_ctx->swinit =3D 0; /* assume h/w init of context */
>> +	size =3D	(crypto_ahash_digestsize(tfm) <=3D SHA256_DIGEST_SIZE)
>> +			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
>> +			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
>> +	req_ctx->hw_context_size =3D size;
>> +	req_ctx->last_request =3D 0;
>> +
>> +	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> +			     DMA_TO_DEVICE);
>> +	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * on h/w without explicit sha224 support, we initialize h/w context
>> + * manually with sha224 constants, and tell it to run sha256.
>> + */
>> +static int ahash_init_sha224_swinit(struct ahash_request *areq)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +
>> +	req_ctx->hw_context[0] =3D SHA224_H0;
>> +	req_ctx->hw_context[1] =3D SHA224_H1;
>> +	req_ctx->hw_context[2] =3D SHA224_H2;
>> +	req_ctx->hw_context[3] =3D SHA224_H3;
>> +	req_ctx->hw_context[4] =3D SHA224_H4;
>> +	req_ctx->hw_context[5] =3D SHA224_H5;
>> +	req_ctx->hw_context[6] =3D SHA224_H6;
>> +	req_ctx->hw_context[7] =3D SHA224_H7;
>> +
>> +	/* init 64-bit count */
>> +	req_ctx->hw_context[8] =3D 0;
>> +	req_ctx->hw_context[9] =3D 0;
>> +
>> +	ahash_init(areq);
>> +	req_ctx->swinit =3D 1;/* prevent h/w initting context with sha256 valu=
es*/
>> +
>> +	return 0;
>> +}
>> +
>> +static int ahash_update(struct ahash_request *areq)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +
>> +	req_ctx->last_request =3D 0;
>> +
>> +	return ahash_process_req(areq, areq->nbytes);
>> +}
>> +
>> +static int ahash_final(struct ahash_request *areq)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +
>> +	req_ctx->last_request =3D 1;
>> +
>> +	return ahash_process_req(areq, 0);
>> +}
>> +
>> +static int ahash_finup(struct ahash_request *areq)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +
>> +	req_ctx->last_request =3D 1;
>> +
>> +	return ahash_process_req(areq, areq->nbytes);
>> +}
>> +
>> +static int ahash_digest(struct ahash_request *areq)
>> +{
>> +	ahash_init(areq);
>> +	return ahash_finup(areq);
>> +}
>> +
>> +static int ahash_digest_sha224_swinit(struct ahash_request *areq)
>> +{
>> +	ahash_init_sha224_swinit(areq);
>> +	return ahash_finup(areq);
>> +}
>> +
>> +static int ahash_export(struct ahash_request *areq, void *out)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct talitos_export_state *export =3D out;
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct device *dev =3D ctx->dev;
>> +	dma_addr_t dma;
>> +
>> +	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> +			     DMA_FROM_DEVICE);
>> +	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_FROM_DEVICE);
>> +
>> +	memcpy(export->hw_context, req_ctx->hw_context,
>> +	       req_ctx->hw_context_size);
>> +	export->swinit =3D req_ctx->swinit;
>> +	export->first_request =3D req_ctx->first_request;
>> +	export->last_request =3D req_ctx->last_request;
>> +	export->to_hash_later =3D req_ctx->to_hash_later;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ahash_import(struct ahash_request *areq, const void *in)
>> +{
>> +	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> +	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> +	struct device *dev =3D ctx->dev;
>> +	const struct talitos_export_state *export =3D in;
>> +	unsigned int size;
>> +	dma_addr_t dma;
>> +
>> +	memset(req_ctx, 0, sizeof(*req_ctx));
>> +	size =3D (crypto_ahash_digestsize(tfm) <=3D SHA256_DIGEST_SIZE)
>> +			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
>> +			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
>> +	req_ctx->hw_context_size =3D size;
>> +	memcpy(req_ctx->hw_context, export->hw_context, size);
>> +	req_ctx->swinit =3D export->swinit;
>> +	req_ctx->first_request =3D export->first_request;
>> +	req_ctx->last_request =3D export->last_request;
>> +	req_ctx->to_hash_later =3D export->to_hash_later;
>> +
>> +	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> +			     DMA_TO_DEVICE);
>> +	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
>> +
>> +	return 0;
>> +}
>> +
>> +static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned in=
t keylen,
>> +		   u8 *hash)
>> +{
>> +	struct talitos_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm));
>> +
>> +	struct scatterlist sg[1];
>> +	struct ahash_request *req;
>> +	struct crypto_wait wait;
>> +	int ret;
>> +
>> +	crypto_init_wait(&wait);
>> +
>> +	req =3D ahash_request_alloc(tfm, GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	/* Keep tfm keylen =3D=3D 0 during hash of the long key */
>> +	ctx->keylen =3D 0;
>> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				   crypto_req_done, &wait);
>> +
>> +	sg_init_one(&sg[0], key, keylen);
>> +
>> +	ahash_request_set_crypt(req, sg, hash, keylen);
>> +	ret =3D crypto_wait_req(crypto_ahash_digest(req), &wait);
>> +
>> +	ahash_request_free(req);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
>> +			unsigned int keylen)
>> +{
>> +	struct talitos_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm));
>> +	struct device *dev =3D ctx->dev;
>> +	unsigned int blocksize =3D
>> +			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
>> +	unsigned int digestsize =3D crypto_ahash_digestsize(tfm);
>> +	unsigned int keysize =3D keylen;
>> +	u8 hash[SHA512_DIGEST_SIZE];
>> +	int ret;
>> +
>> +	if (keylen <=3D blocksize)
>> +		memcpy(ctx->key, key, keysize);
>> +	else {
>> +		/* Must get the hash of the long key */
>> +		ret =3D keyhash(tfm, key, keylen, hash);
>> +
>> +		if (ret)
>> +			return -EINVAL;
>> +
>> +		keysize =3D digestsize;
>> +		memcpy(ctx->key, hash, digestsize);
>> +	}
>> +
>> +	if (ctx->keylen)
>> +		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
>> +
>> +	ctx->keylen =3D keysize;
>> +	ctx->dma_key =3D dma_map_single(dev, ctx->key, keysize, DMA_TO_DEVICE)=
;
>> +
>> +	return 0;
>> +}
>> +
>> +static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>> +{
>> +	struct crypto_alg *alg =3D tfm->__crt_alg;
>> +	struct talitos_crypto_alg *talitos_alg;
>> +	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	talitos_alg =3D container_of(__crypto_ahash_alg(alg),
>> +				   struct talitos_crypto_alg,
>> +				   algt.alg.hash);
>> +
>> +	ctx->keylen =3D 0;
>> +				 sizeof(struct talitos_ahash_req_ctx));
>> +
>> +	return talitos_init_common(ctx, talitos_alg);
>> +}
>> +
>> +static struct talitos_alg_template hash_driver_algs[] =3D {
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D MD5_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "md5",
>> +				.cra_driver_name =3D "md5-talitos",
>> +				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_MD5,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA1_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "sha1",
>> +				.cra_driver_name =3D "sha1-talitos",
>> +				.cra_blocksize =3D SHA1_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA1,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA224_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "sha224",
>> +				.cra_driver_name =3D "sha224-talitos",
>> +				.cra_blocksize =3D SHA224_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA224,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA256_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "sha256",
>> +				.cra_driver_name =3D "sha256-talitos",
>> +				.cra_blocksize =3D SHA256_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA256,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA384_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "sha384",
>> +				.cra_driver_name =3D "sha384-talitos",
>> +				.cra_blocksize =3D SHA384_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUB |
>> +				     DESC_HDR_MODE0_MDEUB_SHA384,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA512_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "sha512",
>> +				.cra_driver_name =3D "sha512-talitos",
>> +				.cra_blocksize =3D SHA512_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUB |
>> +				     DESC_HDR_MODE0_MDEUB_SHA512,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D MD5_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(md5)",
>> +				.cra_driver_name =3D "hmac-md5-talitos",
>> +				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_MD5,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA1_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(sha1)",
>> +				.cra_driver_name =3D "hmac-sha1-talitos",
>> +				.cra_blocksize =3D SHA1_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA1,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA224_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(sha224)",
>> +				.cra_driver_name =3D "hmac-sha224-talitos",
>> +				.cra_blocksize =3D SHA224_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA224,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA256_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(sha256)",
>> +				.cra_driver_name =3D "hmac-sha256-talitos",
>> +				.cra_blocksize =3D SHA256_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUA |
>> +				     DESC_HDR_MODE0_MDEU_SHA256,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA384_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(sha384)",
>> +				.cra_driver_name =3D "hmac-sha384-talitos",
>> +				.cra_blocksize =3D SHA384_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUB |
>> +				     DESC_HDR_MODE0_MDEUB_SHA384,
>> +	},
>> +	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> +		.alg.hash =3D {
>> +			.halg.digestsize =3D SHA512_DIGEST_SIZE,
>> +			.halg.statesize =3D sizeof(struct talitos_export_state),
>> +			.halg.base =3D {
>> +				.cra_name =3D "hmac(sha512)",
>> +				.cra_driver_name =3D "hmac-sha512-talitos",
>> +				.cra_blocksize =3D SHA512_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +			}
>> +		},
>> +		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				     DESC_HDR_SEL0_MDEUB |
>> +				     DESC_HDR_MODE0_MDEUB_SHA512,
>> +	}
>> +};
>> +
>> +int talitos_register_hash(struct device *dev)
>> +{
>> +	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> +	struct ahash_alg *ahash_alg;
>> +	struct crypto_alg *alg;
>> +	size_t i;
>> +	int ret;
>> +
>> +	for (i =3D 0; i < ARRAY_SIZE(hash_driver_algs); i++) {
>> +		if (!talitos_hw_supports(dev,
>> +					 hash_driver_algs[i].desc_hdr_template))
>> +			continue;
>> +
>> +		ahash_alg =3D &hash_driver_algs[i].alg.hash;
>> +		alg =3D &ahash_alg->halg.base;
>> +
>> +		alg->cra_init =3D talitos_cra_init_ahash;
>> +		alg->cra_exit =3D talitos_cra_exit;
>> +		ahash_alg->init =3D ahash_init;
>> +		ahash_alg->update =3D ahash_update;
>> +		ahash_alg->final =3D ahash_final;
>> +		ahash_alg->finup =3D ahash_finup;
>> +		ahash_alg->digest =3D ahash_digest;
>> +		if (!strncmp(alg->cra_name, "hmac", 4))
>> +			ahash_alg->setkey =3D ahash_setkey;
>> +		ahash_alg->import =3D ahash_import;
>> +		ahash_alg->export =3D ahash_export;
>> +
>> +		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
>> +		    !strncmp(alg->cra_name, "hmac", 4)) {
>> +			/* not supported */
>> +			continue;
>> +		}
>> +
>> +		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
>> +		    (!strcmp(alg->cra_name, "sha224") ||
>> +		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
>> +			ahash_alg->init =3D ahash_init_sha224_swinit;
>> +			ahash_alg->digest =3D ahash_digest_sha224_swinit;
>> +			hash_driver_algs[i].desc_hdr_template =3D
>> +				DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> +				DESC_HDR_SEL0_MDEUA |
>> +				DESC_HDR_MODE0_MDEU_SHA256;
>> +		}
>> +
>> +		ret =3D talitos_register_common(dev, &hash_driver_algs[i]);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/t=
alitos.c
>> index 869739dcc4d7..b8bcb970d7d5 100644
>> --- a/drivers/crypto/talitos/talitos.c
>> +++ b/drivers/crypto/talitos/talitos.c
>> @@ -831,26 +831,6 @@ DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_D=
ONE, TALITOS2_ISR_CH_1_3_ERR,
>>    */
>>   #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
>>  =20
>> -#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
>> -#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_=
SHA512
>> -
>> -struct talitos_ahash_req_ctx {
>> -	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
>> -	unsigned int hw_context_size;
>> -	unsigned int swinit;
>> -	unsigned int first_request;
>> -	unsigned int last_request;
>> -	unsigned int to_hash_later;
>> -};
>> -
>> -struct talitos_export_state {
>> -	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
>> -	unsigned int swinit;
>> -	unsigned int first_request;
>> -	unsigned int last_request;
>> -	unsigned int to_hash_later;
>> -};
>> -
>>   static int aead_setkey(struct crypto_aead *authenc,
>>   		       const u8 *key, unsigned int keylen)
>>   {
>> @@ -1659,501 +1639,6 @@ static int skcipher_decrypt(struct skcipher_requ=
est *areq)
>>   	return common_nonsnoop(edesc, areq, skcipher_done);
>>   }
>>  =20
>> -static void common_nonsnoop_hash_unmap(struct device *dev,
>> -				       struct talitos_edesc *edesc,
>> -				       struct ahash_request *areq)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>> -	struct talitos_desc *desc =3D &edesc->desc;
>> -
>> -	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
>> -
>> -	if (edesc->last && req_ctx->last_request)
>> -		memcpy(areq->result, req_ctx->hw_context,
>> -		       crypto_ahash_digestsize(tfm));
>> -
>> -	if (edesc->src)
>> -		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
>> -
>> -	/* When using hashctx-in, must unmap it. */
>> -	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
>> -		unmap_single_talitos_ptr(dev, &desc->ptr[1],
>> -					 DMA_TO_DEVICE);
>> -
>> -	if (edesc->dma_len)
>> -		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
>> -				 DMA_BIDIRECTIONAL);
>> -}
>> -
>> -static void free_edesc_list_from(struct ahash_request *areq, struct tal=
itos_edesc *edesc)
>> -{
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(areq)=
);
>> -	struct talitos_edesc *next;
>> -
>> -	while (edesc) {
>> -		next =3D edesc->next_desc;
>> -		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
>> -		kfree(edesc);
>> -		edesc =3D next;
>> -	}
>> -}
>> -
>> -static void ahash_done(struct device *dev,
>> -		       struct talitos_desc *desc, void *context,
>> -		       int err)
>> -{
>> -	struct ahash_request *areq =3D context;
>> -	struct talitos_edesc *edesc =3D
>> -		 container_of(desc, struct talitos_edesc, desc);
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	bool is_sec1 =3D has_ftr_sec1(dev_get_drvdata(dev));
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct talitos_edesc *next;
>> -
>> -	if (is_sec1) {
>> -		free_edesc_list_from(areq, edesc);
>> -		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>> -	} else {
>> -		next =3D edesc->next_desc;
>> -
>> -		common_nonsnoop_hash_unmap(dev, edesc, areq);
>> -		kfree(edesc);
>> -
>> -		if (err)
>> -			goto out;
>> -
>> -		if (next) {
>> -			err =3D talitos_submit(dev, ctx->ch, &next->desc,
>> -					     ahash_done, areq);
>> -			if (err !=3D -EINPROGRESS)
>> -				goto out;
>> -			return;
>> -		}
>> -out:
>> -		if (err && next)
>> -			free_edesc_list_from(areq, next);
>> -		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>> -	}
>> -}
>> -
>> -/*
>> - * SEC1 doesn't like hashing of 0 sized message, so we do the padding
>> - * ourself and submit a padded block
>> - */
>> -static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
>> -			       struct talitos_edesc *edesc,
>> -			       struct talitos_ptr *ptr)
>> -{
>> -	static u8 padded_hash[64] =3D {
>> -		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> -		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> -		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> -		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
>> -	};
>> -
>> -	pr_err_once("Bug in SEC1, padding ourself\n");
>> -	edesc->desc.hdr &=3D ~DESC_HDR_MODE0_MDEU_PAD;
>> -	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
>> -			       (char *)padded_hash, DMA_TO_DEVICE);
>> -}
>> -
>> -static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>> -				 struct ahash_request *areq,
>> -				 unsigned int length)
>> -{
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct device *dev =3D ctx->dev;
>> -	struct talitos_desc *desc =3D &edesc->desc;
>> -	bool sync_needed =3D false;
>> -	struct talitos_private *priv =3D dev_get_drvdata(dev);
>> -	bool is_sec1 =3D has_ftr_sec1(priv);
>> -	int sg_count;
>> -
>> -	/* first DWORD empty */
>> -
>> -	/* hash context in */
>> -	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
>> -		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
>> -					      req_ctx->hw_context_size,
>> -					      req_ctx->hw_context,
>> -					      DMA_TO_DEVICE);
>> -		req_ctx->swinit =3D 0;
>> -	}
>> -	/* Indicate next op is not the first. */
>> -	req_ctx->first_request =3D 0;
>> -
>> -	/* HMAC key */
>> -	if (ctx->keylen)
>> -		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
>> -			       is_sec1);
>> -
>> -	sg_count =3D edesc->src_nents ?: 1;
>> -	if (is_sec1 && sg_count > 1)
>> -		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
>> -	else if (length)
>> -		sg_count =3D dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
>> -
>> -	/*
>> -	 * data in
>> -	 */
>> -	sg_count =3D talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr=
[3],
>> -				  sg_count, 0, 0);
>> -	if (sg_count > 1)
>> -		sync_needed =3D true;
>> -
>> -	/* fifth DWORD empty */
>> -
>> -	/* hash/HMAC out -or- hash context out */
>> -	if (edesc->last && req_ctx->last_request)
>> -		map_single_talitos_ptr(dev, &desc->ptr[5],
>> -				       crypto_ahash_digestsize(tfm),
>> -				       req_ctx->hw_context, DMA_FROM_DEVICE);
>> -	else
>> -		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
>> -					      req_ctx->hw_context_size,
>> -					      req_ctx->hw_context,
>> -					      DMA_FROM_DEVICE);
>> -
>> -	/* last DWORD empty */
>> -
>> -	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) =3D=3D 0)
>> -		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
>> -
>> -	if (sync_needed)
>> -		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
>> -					   edesc->dma_len, DMA_BIDIRECTIONAL);
>> -}
>> -
>> -static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *ar=
eq,
>> -					       struct scatterlist *src,
>> -					       unsigned int nbytes)
>> -{
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -
>> -	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
>> -				   nbytes, 0, 0, 0, areq->base.flags, false);
>> -}
>> -
>> -static struct talitos_edesc *
>> -ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbyt=
es,
>> -			  unsigned int blocksize, bool is_sec1)
>> -{
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(areq)=
);
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct talitos_edesc *first =3D NULL, *prev_edesc =3D NULL, *edesc;
>> -	size_t desc_max =3D is_sec1 ? TALITOS1_MAX_DATA_LEN :
>> -				    TALITOS2_MAX_DATA_LEN;
>> -	struct scatterlist tmp[2];
>> -	size_t to_hash_this_desc;
>> -	struct scatterlist *src;
>> -	size_t offset =3D 0;
>> -
>> -	do {
>> -		src =3D scatterwalk_ffwd(tmp, areq->src, offset);
>> -
>> -		to_hash_this_desc =3D
>> -			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
>> -
>> -		/* Allocate extended descriptor */
>> -		edesc =3D ahash_edesc_alloc(areq, src, to_hash_this_desc);
>> -		if (IS_ERR(edesc)) {
>> -			if (first)
>> -				free_edesc_list_from(areq, first);
>> -			return edesc;
>> -		}
>> -
>> -		edesc->src =3D scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
>> -		edesc->desc.hdr =3D ctx->desc_hdr_template;
>> -		edesc->first =3D offset =3D=3D 0;
>> -		edesc->last =3D nbytes - to_hash_this_desc =3D=3D 0;
>> -
>> -		/* On last one, request SEC to pad; otherwise continue */
>> -		if (req_ctx->last_request && edesc->last)
>> -			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_PAD;
>> -		else
>> -			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_CONT;
>> -
>> -		/* request SEC to INIT hash. */
>> -		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
>> -			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_INIT;
>> -
>> -		/*
>> -		 * When the tfm context has a keylen, it's an HMAC.
>> -		 * A first or last (ie. not middle) descriptor must request HMAC.
>> -		 */
>> -		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
>> -				    (req_ctx->last_request && edesc->last)))
>> -			edesc->desc.hdr |=3D DESC_HDR_MODE0_MDEU_HMAC;
>> -
>> -		/* clear the DN bit  */
>> -		if (is_sec1 && !edesc->last)
>> -			edesc->desc.hdr &=3D ~DESC_HDR_DONE_NOTIFY;
>> -
>> -		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
>> -
>> -		offset +=3D to_hash_this_desc;
>> -		nbytes -=3D to_hash_this_desc;
>> -
>> -		if (!prev_edesc)
>> -			first =3D edesc;
>> -		else
>> -			prev_edesc->next_desc =3D edesc;
>> -		prev_edesc =3D edesc;
>> -	} while (nbytes);
>> -
>> -	return first;
>> -}
>> -
>> -static int ahash_process_req(struct ahash_request *areq, unsigned int n=
bytes)
>> -{
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct talitos_edesc *edesc;
>> -	unsigned int blocksize =3D
>> -			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
>> -	bool is_sec1 =3D has_ftr_sec1(dev_get_drvdata(ctx->dev));
>> -	unsigned int nbytes_to_hash;
>> -	unsigned int to_hash_later;
>> -	struct device *dev =3D ctx->dev;
>> -	int ret;
>> -
>> -	nbytes_to_hash =3D ALIGN_DOWN(nbytes, blocksize);
>> -	to_hash_later =3D nbytes - nbytes_to_hash;
>> -
>> -	if (req_ctx->last_request) {
>> -		nbytes_to_hash =3D nbytes;
>> -		to_hash_later =3D 0;
>> -	}
>> -
>> -	req_ctx->to_hash_later =3D to_hash_later;
>> -
>> -	edesc =3D ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
>> -					  is_sec1);
>> -	if (IS_ERR(edesc))
>> -		return PTR_ERR(edesc);
>> -
>> -	ret =3D talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
>> -	if (ret !=3D -EINPROGRESS)
>> -		free_edesc_list_from(areq, edesc);
>> -
>> -	return ret;
>> -}
>> -
>> -static int ahash_init(struct ahash_request *areq)
>> -{
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct device *dev =3D ctx->dev;
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	unsigned int size;
>> -	dma_addr_t dma;
>> -
>> -	/* Initialize the context */
>> -	req_ctx->first_request =3D 1;
>> -	req_ctx->swinit =3D 0; /* assume h/w init of context */
>> -	size =3D	(crypto_ahash_digestsize(tfm) <=3D SHA256_DIGEST_SIZE)
>> -			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
>> -			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
>> -	req_ctx->hw_context_size =3D size;
>> -	req_ctx->last_request =3D 0;
>> -
>> -	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> -			     DMA_TO_DEVICE);
>> -	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
>> -
>> -	return 0;
>> -}
>> -
>> -/*
>> - * on h/w without explicit sha224 support, we initialize h/w context
>> - * manually with sha224 constants, and tell it to run sha256.
>> - */
>> -static int ahash_init_sha224_swinit(struct ahash_request *areq)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -
>> -	req_ctx->hw_context[0] =3D SHA224_H0;
>> -	req_ctx->hw_context[1] =3D SHA224_H1;
>> -	req_ctx->hw_context[2] =3D SHA224_H2;
>> -	req_ctx->hw_context[3] =3D SHA224_H3;
>> -	req_ctx->hw_context[4] =3D SHA224_H4;
>> -	req_ctx->hw_context[5] =3D SHA224_H5;
>> -	req_ctx->hw_context[6] =3D SHA224_H6;
>> -	req_ctx->hw_context[7] =3D SHA224_H7;
>> -
>> -	/* init 64-bit count */
>> -	req_ctx->hw_context[8] =3D 0;
>> -	req_ctx->hw_context[9] =3D 0;
>> -
>> -	ahash_init(areq);
>> -	req_ctx->swinit =3D 1;/* prevent h/w initting context with sha256 valu=
es*/
>> -
>> -	return 0;
>> -}
>> -
>> -static int ahash_update(struct ahash_request *areq)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -
>> -	req_ctx->last_request =3D 0;
>> -
>> -	return ahash_process_req(areq, areq->nbytes);
>> -}
>> -
>> -static int ahash_final(struct ahash_request *areq)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -
>> -	req_ctx->last_request =3D 1;
>> -
>> -	return ahash_process_req(areq, 0);
>> -}
>> -
>> -static int ahash_finup(struct ahash_request *areq)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -
>> -	req_ctx->last_request =3D 1;
>> -
>> -	return ahash_process_req(areq, areq->nbytes);
>> -}
>> -
>> -static int ahash_digest(struct ahash_request *areq)
>> -{
>> -	ahash_init(areq);
>> -	return ahash_finup(areq);
>> -}
>> -
>> -static int ahash_digest_sha224_swinit(struct ahash_request *areq)
>> -{
>> -	ahash_init_sha224_swinit(areq);
>> -	return ahash_finup(areq);
>> -}
>> -
>> -static int ahash_export(struct ahash_request *areq, void *out)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct talitos_export_state *export =3D out;
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct device *dev =3D ctx->dev;
>> -	dma_addr_t dma;
>> -
>> -	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> -			     DMA_FROM_DEVICE);
>> -	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_FROM_DEVICE);
>> -
>> -	memcpy(export->hw_context, req_ctx->hw_context,
>> -	       req_ctx->hw_context_size);
>> -	export->swinit =3D req_ctx->swinit;
>> -	export->first_request =3D req_ctx->first_request;
>> -	export->last_request =3D req_ctx->last_request;
>> -	export->to_hash_later =3D req_ctx->to_hash_later;
>> -
>> -	return 0;
>> -}
>> -
>> -static int ahash_import(struct ahash_request *areq, const void *in)
>> -{
>> -	struct talitos_ahash_req_ctx *req_ctx =3D ahash_request_ctx(areq);
>> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
>> -	struct talitos_ctx *ctx =3D crypto_ahash_ctx(tfm);
>> -	struct device *dev =3D ctx->dev;
>> -	const struct talitos_export_state *export =3D in;
>> -	unsigned int size;
>> -	dma_addr_t dma;
>> -
>> -	memset(req_ctx, 0, sizeof(*req_ctx));
>> -	size =3D (crypto_ahash_digestsize(tfm) <=3D SHA256_DIGEST_SIZE)
>> -			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
>> -			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
>> -	req_ctx->hw_context_size =3D size;
>> -	memcpy(req_ctx->hw_context, export->hw_context, size);
>> -	req_ctx->swinit =3D export->swinit;
>> -	req_ctx->first_request =3D export->first_request;
>> -	req_ctx->last_request =3D export->last_request;
>> -	req_ctx->to_hash_later =3D export->to_hash_later;
>> -
>> -	dma =3D dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_s=
ize,
>> -			     DMA_TO_DEVICE);
>> -	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
>> -
>> -	return 0;
>> -}
>> -
>> -static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned in=
t keylen,
>> -		   u8 *hash)
>> -{
>> -	struct talitos_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm));
>> -
>> -	struct scatterlist sg[1];
>> -	struct ahash_request *req;
>> -	struct crypto_wait wait;
>> -	int ret;
>> -
>> -	crypto_init_wait(&wait);
>> -
>> -	req =3D ahash_request_alloc(tfm, GFP_KERNEL);
>> -	if (!req)
>> -		return -ENOMEM;
>> -
>> -	/* Keep tfm keylen =3D=3D 0 during hash of the long key */
>> -	ctx->keylen =3D 0;
>> -	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> -				   crypto_req_done, &wait);
>> -
>> -	sg_init_one(&sg[0], key, keylen);
>> -
>> -	ahash_request_set_crypt(req, sg, hash, keylen);
>> -	ret =3D crypto_wait_req(crypto_ahash_digest(req), &wait);
>> -
>> -	ahash_request_free(req);
>> -
>> -	return ret;
>> -}
>> -
>> -static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
>> -			unsigned int keylen)
>> -{
>> -	struct talitos_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm));
>> -	struct device *dev =3D ctx->dev;
>> -	unsigned int blocksize =3D
>> -			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
>> -	unsigned int digestsize =3D crypto_ahash_digestsize(tfm);
>> -	unsigned int keysize =3D keylen;
>> -	u8 hash[SHA512_DIGEST_SIZE];
>> -	int ret;
>> -
>> -	if (keylen <=3D blocksize)
>> -		memcpy(ctx->key, key, keysize);
>> -	else {
>> -		/* Must get the hash of the long key */
>> -		ret =3D keyhash(tfm, key, keylen, hash);
>> -
>> -		if (ret)
>> -			return -EINVAL;
>> -
>> -		keysize =3D digestsize;
>> -		memcpy(ctx->key, hash, digestsize);
>> -	}
>> -
>> -	if (ctx->keylen)
>> -		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
>> -
>> -	ctx->keylen =3D keysize;
>> -	ctx->dma_key =3D dma_map_single(dev, ctx->key, keysize, DMA_TO_DEVICE)=
;
>> -
>> -	return 0;
>> -}
>> -
>>   static struct talitos_alg_template driver_algs[] =3D {
>>   	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> @@ -2737,235 +2222,6 @@ static struct talitos_alg_template driver_algs[]=
 =3D {
>>   		                     DESC_HDR_MODE0_DEU_CBC |
>>   		                     DESC_HDR_MODE0_DEU_3DES,
>>   	},
>> -	/* AHASH algorithms. */
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D MD5_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "md5",
>> -				.cra_driver_name =3D "md5-talitos",
>> -				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_MD5,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA1_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "sha1",
>> -				.cra_driver_name =3D "sha1-talitos",
>> -				.cra_blocksize =3D SHA1_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA1,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA224_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "sha224",
>> -				.cra_driver_name =3D "sha224-talitos",
>> -				.cra_blocksize =3D SHA224_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA224,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA256_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "sha256",
>> -				.cra_driver_name =3D "sha256-talitos",
>> -				.cra_blocksize =3D SHA256_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA256,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA384_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "sha384",
>> -				.cra_driver_name =3D "sha384-talitos",
>> -				.cra_blocksize =3D SHA384_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUB |
>> -				     DESC_HDR_MODE0_MDEUB_SHA384,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA512_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "sha512",
>> -				.cra_driver_name =3D "sha512-talitos",
>> -				.cra_blocksize =3D SHA512_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUB |
>> -				     DESC_HDR_MODE0_MDEUB_SHA512,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D MD5_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(md5)",
>> -				.cra_driver_name =3D "hmac-md5-talitos",
>> -				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_MD5,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA1_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(sha1)",
>> -				.cra_driver_name =3D "hmac-sha1-talitos",
>> -				.cra_blocksize =3D SHA1_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA1,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA224_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(sha224)",
>> -				.cra_driver_name =3D "hmac-sha224-talitos",
>> -				.cra_blocksize =3D SHA224_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA224,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA256_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(sha256)",
>> -				.cra_driver_name =3D "hmac-sha256-talitos",
>> -				.cra_blocksize =3D SHA256_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUA |
>> -				     DESC_HDR_MODE0_MDEU_SHA256,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA384_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(sha384)",
>> -				.cra_driver_name =3D "hmac-sha384-talitos",
>> -				.cra_blocksize =3D SHA384_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUB |
>> -				     DESC_HDR_MODE0_MDEUB_SHA384,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AHASH,
>> -		.alg.hash =3D {
>> -			.halg.digestsize =3D SHA512_DIGEST_SIZE,
>> -			.halg.statesize =3D sizeof(struct talitos_export_state),
>> -			.halg.base =3D {
>> -				.cra_name =3D "hmac(sha512)",
>> -				.cra_driver_name =3D "hmac-sha512-talitos",
>> -				.cra_blocksize =3D SHA512_BLOCK_SIZE,
>> -				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> -			}
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_MDEUB |
>> -				     DESC_HDR_MODE0_MDEUB_SHA512,
>> -	}
>>   };
>>  =20
>>   int talitos_init_common(struct talitos_ctx *ctx,
>> @@ -3014,22 +2270,6 @@ static int talitos_cra_init_skcipher(struct crypt=
o_skcipher *tfm)
>>   	return talitos_init_common(ctx, talitos_alg);
>>   }
>>  =20
>> -static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>> -{
>> -	struct crypto_alg *alg =3D tfm->__crt_alg;
>> -	struct talitos_crypto_alg *talitos_alg;
>> -	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> -
>> -	talitos_alg =3D container_of(__crypto_ahash_alg(alg),
>> -				   struct talitos_crypto_alg,
>> -				   algt.alg.hash);
>> -
>> -	ctx->keylen =3D 0;
>> -				 sizeof(struct talitos_ahash_req_ctx));
>> -
>> -	return talitos_init_common(ctx, talitos_alg);
>> -}
>> -
>>   void talitos_cra_exit(struct crypto_tfm *tfm)
>>   {
>>   	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> @@ -3128,6 +2368,12 @@ int talitos_register_common(struct device *dev,
>>   	t_alg->algt =3D *template;
>>  =20
>>   	switch (t_alg->algt.type) {
>> +	case CRYPTO_ALG_TYPE_AHASH:
>> +		alg =3D &t_alg->algt.alg.hash.halg.base;
>> +		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
>> +				       t_alg->algt.type);
>> +		ret =3D crypto_register_ahash(&t_alg->algt.alg.hash);
>> +		break;
>>   	default:
>>   		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
>>   		devm_kfree(dev, t_alg);
>> @@ -3193,37 +2439,6 @@ static struct talitos_crypto_alg *talitos_alg_all=
oc(struct device *dev,
>>   			return ERR_PTR(-ENOTSUPP);
>>   		}
>>   		break;
>> -	case CRYPTO_ALG_TYPE_AHASH:
>> -		alg =3D &t_alg->algt.alg.hash.halg.base;
>> -		alg->cra_init =3D talitos_cra_init_ahash;
>> -		alg->cra_exit =3D talitos_cra_exit;
>> -		t_alg->algt.alg.hash.init =3D ahash_init;
>> -		t_alg->algt.alg.hash.update =3D ahash_update;
>> -		t_alg->algt.alg.hash.final =3D ahash_final;
>> -		t_alg->algt.alg.hash.finup =3D ahash_finup;
>> -		t_alg->algt.alg.hash.digest =3D ahash_digest;
>> -		if (!strncmp(alg->cra_name, "hmac", 4))
>> -			t_alg->algt.alg.hash.setkey =3D ahash_setkey;
>> -		t_alg->algt.alg.hash.import =3D ahash_import;
>> -		t_alg->algt.alg.hash.export =3D ahash_export;
>> -
>> -		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
>> -		    !strncmp(alg->cra_name, "hmac", 4)) {
>> -			devm_kfree(dev, t_alg);
>> -			return ERR_PTR(-ENOTSUPP);
>> -		}
>> -		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
>> -		    (!strcmp(alg->cra_name, "sha224") ||
>> -		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
>> -			t_alg->algt.alg.hash.init =3D ahash_init_sha224_swinit;
>> -			t_alg->algt.alg.hash.digest =3D
>> -				ahash_digest_sha224_swinit;
>> -			t_alg->algt.desc_hdr_template =3D
>> -					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> -					DESC_HDR_SEL0_MDEUA |
>> -					DESC_HDR_MODE0_MDEU_SHA256;
>> -		}
>> -		break;
>>   	default:
>>   		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
>>   		devm_kfree(dev, t_alg);
>> @@ -3452,6 +2667,10 @@ static int talitos_probe(struct platform_device *=
ofdev)
>>   			dev_info(dev, "hwrng\n");
>>   	}
>>  =20
>> +	err =3D talitos_register_hash(dev);
>> +	if (err)
>> +		goto err_out;
>> +
>>   	/* register crypto algorithms the device supports */
>>   	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
>>   		if (talitos_hw_supports(dev,
>> @@ -3479,12 +2698,6 @@ static int talitos_probe(struct platform_device *=
ofdev)
>>   					&t_alg->algt.alg.aead);
>>   				alg =3D &t_alg->algt.alg.aead.base;
>>   				break;
>> -
>> -			case CRYPTO_ALG_TYPE_AHASH:
>> -				err =3D crypto_register_ahash(
>> -						&t_alg->algt.alg.hash);
>> -				alg =3D &t_alg->algt.alg.hash.halg.base;
>> -				break;
>>   			}
>>   			if (err) {
>>   				dev_err(dev, "%s alg registration failed\n",
>> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/t=
alitos.h
>> index afed9947f4c0..e703c18cb81f 100644
>> --- a/drivers/crypto/talitos/talitos.h
>> +++ b/drivers/crypto/talitos/talitos.h
>> @@ -530,3 +530,7 @@ int talitos_register_common(struct device *dev,
>>  =20
>>   int talitos_register_rng(struct device *dev);
>>   void talitos_unregister_rng(struct device *dev);
>> +
>> +/* Hash */
>> +
>> +int talitos_register_hash(struct device *dev);


Thanks,

Paul.




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

