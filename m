From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH 4/7] crypto: marvell: Moving the tdma chain out of
 mv_cesa_tdma_req
Date: Thu, 16 Jun 2016 14:02:42 +0200
Message-ID: <57629562.9030908@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
 <1466018134-10779-5-git-send-email-romain.perier@free-electrons.com>
 <20160615224249.3e1e477b@bbrezillon>
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
Received: from down.free-electrons.com ([37.187.137.238]:44099 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbcFPMCp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 08:02:45 -0400
In-Reply-To: <20160615224249.3e1e477b@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 15/06/2016 22:42, Boris Brezillon a =E9crit :
> On Wed, 15 Jun 2016 21:15:31 +0200
> Romain Perier <romain.perier@free-electrons.com> wrote:
>
>> Actually the only way to access the tdma chain is to use the 'req' u=
nion
>
> Currently, ...

ok

> Now that the dma specific fields are part of the base request there's=
 no
> reason to keep this union.
>
> You can just put struct mv_cesa_req base; directly under struct
> mv_cesa_ablkcipher_req, and move mv_cesa_ablkcipher_std_req fields in
> mv_cesa_ablkcipher_req.


Well, I think that I might keep the changes related to mv_cesa_tdma_req=
=20
in this commit (+ put struct mv_cesa_req base; direct under struct=20
mv_cesa_ablkcipher_req) and move the changes related to=20
mv_cesa_ablkcipher_std_req into another commit. What do you think ?


> Initialize basereq earlier and pass it as the first argument of
> mv_cesa_dma_process().

ok



>> @@ -174,9 +174,9 @@ static inline void
>>   mv_cesa_ablkcipher_dma_prepare(struct ablkcipher_request *req)
>>   {
>>   	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(re=
q);
>> -	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma;
>> +	struct mv_cesa_req *dreq =3D &creq->req.base;
>
> You named it basereq in mv_cesa_ablkcipher_step(). Try to be
> consistent, no matter the name.

ack

>
>>
>> -	mv_cesa_dma_prepare(dreq, dreq->base.engine);
>> +	mv_cesa_dma_prepare(dreq, dreq->engine);
>>   }
>>
>>   static inline void
>> @@ -199,7 +199,7 @@ static inline void mv_cesa_ablkcipher_prepare(st=
ruct crypto_async_request *req,
>>   	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(ab=
lkreq);
>>   	creq->req.base.engine =3D engine;
>>
>> -	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
>> +	if (mv_cesa_req_get_type(&creq->req.base) =3D=3D CESA_DMA_REQ)
>>   		mv_cesa_ablkcipher_dma_prepare(ablkreq);
>>   	else
>>   		mv_cesa_ablkcipher_std_prepare(ablkreq);
>> @@ -302,14 +302,13 @@ static int mv_cesa_ablkcipher_dma_req_init(str=
uct ablkcipher_request *req,
>>   	struct mv_cesa_ablkcipher_req *creq =3D ablkcipher_request_ctx(re=
q);
>>   	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>   		      GFP_KERNEL : GFP_ATOMIC;
>> -	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma;
>> +	struct mv_cesa_req *dreq =3D &creq->req.base;
>
> Ditto.

ack


>> @@ -256,9 +256,9 @@ static int mv_cesa_ahash_std_process(struct ahas=
h_request *req, u32 status)
>>   static inline void mv_cesa_ahash_dma_prepare(struct ahash_request =
*req)
>>   {
>>   	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
>> -	struct mv_cesa_tdma_req *dreq =3D &creq->req.dma.base;
>> +	struct mv_cesa_req *dreq =3D &creq->req.base;
>
> Ditto.

ack

>> @@ -340,7 +340,7 @@ static void mv_cesa_ahash_prepare(struct crypto_=
async_request *req,
>>
>>   	creq->req.base.engine =3D engine;
>>
>> -	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
>> +	if (mv_cesa_req_get_type(&creq->req.base) =3D=3D CESA_DMA_REQ)
>>   		mv_cesa_ahash_dma_prepare(ahashreq);
>>   	else
>>   		mv_cesa_ahash_std_prepare(ahashreq);
>> @@ -555,8 +555,7 @@ static int mv_cesa_ahash_dma_req_init(struct aha=
sh_request *req)
>>   	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
>>   	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>   		      GFP_KERNEL : GFP_ATOMIC;
>> -	struct mv_cesa_ahash_dma_req *ahashdreq =3D &creq->req.dma;
>> -	struct mv_cesa_tdma_req *dreq =3D &ahashdreq->base;
>> +	struct mv_cesa_req *dreq =3D &creq->req.base;
>
> Ditto.

ack

>
>>   	struct mv_cesa_ahash_dma_iter iter;
>>   	struct mv_cesa_op_ctx *op =3D NULL;
>>   	unsigned int frag_len;
>> @@ -662,11 +661,6 @@ static int mv_cesa_ahash_req_init(struct ahash_=
request *req, bool *cached)
>>   	struct mv_cesa_ahash_req *creq =3D ahash_request_ctx(req);
>>   	int ret;
>>
>> -	if (cesa_dev->caps->has_tdma)
>> -		creq->req.base.type =3D CESA_DMA_REQ;
>> -	else
>> -		creq->req.base.type =3D CESA_STD_REQ;
>> -
>
> Hm, where is it decided now? I mean, I don't see this test anywhere
> else in your patch, which means you're now always using standard mode=
=2E

It has been replaced by mv_cesa_req_get_type() + initializing=20
chain.first to NULL in std_init. So, that's the same thing, no ?

>
>>   	creq->src_nents =3D sg_nents_for_len(req->src, req->nbytes);
>>   	if (creq->src_nents < 0) {
>>   		dev_err(cesa_dev->dev, "Invalid number of src SG");
>> @@ -680,7 +674,7 @@ static int mv_cesa_ahash_req_init(struct ahash_r=
equest *req, bool *cached)
>>   	if (*cached)
>>   		return 0;
>>
>> -	if (creq->req.base.type =3D=3D CESA_DMA_REQ)
>> +	if (mv_cesa_req_get_type(&creq->req.base) =3D=3D CESA_DMA_REQ)
>
> Should be
>
> 	if (cesa_dev->caps->has_tdma)
>
>>   		ret =3D mv_cesa_ahash_dma_req_init(req);

Why ? mv_cesa_req_get_type() tests mv_cesa_req->chain and returns a cod=
e=20
depending on its value. This value is initialized according to what is=20
set un "has_tdma"...


Thanks,
Regards,
Romain
--=20
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
