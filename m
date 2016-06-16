From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH 3/7] crypto: marvell: Copy IV vectors by DMA transfers for
 acipher requests
Date: Thu, 16 Jun 2016 10:29:30 +0200
Message-ID: <5762636A.2020800@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
 <1466018134-10779-4-git-send-email-romain.perier@free-electrons.com>
 <20160615220716.6ad3b856@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38428 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753740AbcFPI3d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 04:29:33 -0400
In-Reply-To: <20160615220716.6ad3b856@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 15/06/2016 22:07, Boris Brezillon a =E9crit :
> On Wed, 15 Jun 2016 21:15:30 +0200
> Romain Perier <romain.perier@free-electrons.com> wrote:
>
>> Adding a TDMA descriptor at the end of the request for copying the
>> output IV vector via a DMA transfer. This is required for processing
>> cipher requests asynchroniously in chained mode, otherwise the conte=
nt
>
> 		  asynchronously
>
>> of the IV vector will be overwriten for each new finished request.
>
> BTW, Not sure the term 'asynchronously' is appropriate here. The
> standard (AKA non-DMA) processing is also asynchronous. The real reas=
on
> here is that you want to chain the requests and offload as much
> processing as possible to the DMA and crypto engine. And as you
> explained, this is only possible if we retrieve the updated IV using
> DMA.
>

What do you think of the following description ?
"
Adding a TDMA descriptor at the end of the request for copying the
output IV vector via a DMA transfer. This is a good way for offloading
as much as processing as possible to the DMA and the crypto engine.
This is also required for processing multiple cipher requests
in chained mode, otherwise the content of the IV vector would be
overwritten by the last processed request.
"

This point is true if multiple chained requests are processed via TDMA,=
=20
the content of the "global" IV output vector would be overwritten
by the last request.


>> diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/=
cesa.h
>> index 74071e4..74b84bd 100644
>> --- a/drivers/crypto/marvell/cesa.h
>> +++ b/drivers/crypto/marvell/cesa.h
>> @@ -275,6 +275,7 @@ struct mv_cesa_op_ctx {
>>   #define CESA_TDMA_DUMMY				0
>>   #define CESA_TDMA_DATA				1
>>   #define CESA_TDMA_OP				2
>> +#define CESA_TDMA_IV				4
>
> Should be 3 and not 4: TDMA_TYPE is an enum, not a bit field.

Ok

>
> Sometime it's better to offend the < 80 characters rule than doing
> funky stuff ;).

I just wanted to make checkpatch happy :D
Yeah, that's ugly, I agree. I will fix this.

>
>> +		memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);
>>   		return ret;
>> -
>> -	memcpy_fromio(ablkreq->info,
>> -		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
>> -		      crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq))=
);
>> -
>> -	return 0;
>> +	}
>
> Missing blank line.

ack

>
>> +	return mv_cesa_ablkcipher_std_process(ablkreq, status);
>
> This version is more readable IMHO:
>
> 	struct mv_cesa_tdma_req *dreq;
> 	unsigned int ivsize;
> 	int ret;
>
> 	if (creq->req.base.type =3D=3D CESA_STD_REQ)
> 		return mv_cesa_ablkcipher_std_process(ablkreq, status);
>
> 	ret =3D mv_cesa_dma_process(&creq->req.dma, status);
> 	if (ret)
> 		return ret;
>
> 	dreq =3D &creq->req.dma;
> 	ivsize =3D
> 	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
> 	memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);
>
> 	return 0;
>
>>
>>   static void mv_cesa_ablkcipher_step(struct crypto_async_request *r=
eq)
>> @@ -302,6 +307,7 @@ static int mv_cesa_ablkcipher_dma_req_init(struc=
t ablkcipher_request *req,
>>   	struct mv_cesa_tdma_chain chain;
>>   	bool skip_ctx =3D false;
>>   	int ret;
>> +	unsigned int ivsize;
>>
>>   	dreq->base.type =3D CESA_DMA_REQ;
>>   	dreq->chain.first =3D NULL;
>> @@ -360,6 +366,14 @@ static int mv_cesa_ablkcipher_dma_req_init(stru=
ct ablkcipher_request *req,
>>
>>   	} while (mv_cesa_ablkcipher_req_iter_next_op(&iter));
>>
>> +	/* Add output data for IV */
>> +	ivsize =3D crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req))=
;
>> +	ret =3D mv_cesa_dma_add_iv_op(&chain, CESA_SA_CRYPT_IV_SRAM_OFFSET=
,
>> +				    ivsize, CESA_TDMA_SRC_IN_SRAM, flags);
>> +
>> +	if (ret)
>> +		goto err_free_tdma;
>> +
>>   	dreq->chain =3D chain;
>>
>>   	return 0;
>> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/=
tdma.c
>> index d493714..88c87be 100644
>> --- a/drivers/crypto/marvell/tdma.c
>> +++ b/drivers/crypto/marvell/tdma.c
>> @@ -68,6 +68,9 @@ void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *=
dreq)
>>   		if (tdma->flags & CESA_TDMA_OP)
>
> I realize this test is wrong.
>
> It should be
> 		type =3D tdma->flags & CESA_TDMA_TYPE_MSK;
> 		if (type =3D=3D CESA_TDMA_OP)
>
>>   			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
>>   				      le32_to_cpu(tdma->src));
>> +		else if (tdma->flags & CESA_TDMA_IV)
>
> and here

I propose a separated commit to fix this problem. What do you think ?

> 		else if (type =3D=3D CESA_TDMA_IV)
>
>> +			dma_pool_free(cesa_dev->dma->iv_pool, tdma->data,
>> +				      le32_to_cpu(tdma->dst));
>>
>>   		tdma =3D tdma->next;
>>   		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
>> @@ -120,6 +123,32 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain =
*chain, gfp_t flags)
>>   	return new_tdma;
>>   }
>>
>> +int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_add=
r_t src,
>> +			  u32 size, u32 flags, gfp_t gfp_flags)
>> +{
>> +
>> +	struct mv_cesa_tdma_desc *tdma;
>> +	u8 *cache;
>
> Why do you name that one cache? iv would be a better name.

ok

>
>> +	dma_addr_t dma_handle;
>> +
>> +	tdma =3D mv_cesa_dma_add_desc(chain, gfp_flags);
>> +	if (IS_ERR(tdma))
>> +		return PTR_ERR(tdma);
>> +
>> +	cache =3D dma_pool_alloc(cesa_dev->dma->iv_pool, flags, &dma_handl=
e);
>> +	if (!cache)
>> +		return -ENOMEM;
>> +
>> +	tdma->byte_cnt =3D cpu_to_le32(size | BIT(31));
>> +	tdma->src =3D src;
>> +	tdma->dst =3D cpu_to_le32(dma_handle);
>> +	tdma->data =3D cache;
>> +
>> +	flags &=3D (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
>> +	tdma->flags =3D flags | CESA_TDMA_DATA | CESA_TDMA_IV;
>
> You should not mix 2 different types, it's either CESA_TDMA_DATA or
> CESA_TDMA_IV, and in this case it should be CESA_TDMA_IV.

good catch.

>
>> +	return 0;
>> +}
>> +
>>   struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chai=
n *chain,
>>   					const struct mv_cesa_op_ctx *op_templ,
>>   					bool skip_ctx,
>
>
>

Thanks,
Regards,
Romain
--=20
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
