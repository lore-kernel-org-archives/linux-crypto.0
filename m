From: yjin <yanjiang.jin@windriver.com>
Subject: Re: [PATCH 3/4] crypto: caamhash: add two missed dma_mapping_error
Date: Tue, 3 Mar 2015 14:57:22 +0800
Message-ID: <54F55B52.60006@windriver.com>
References: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com> <1425103234-31129-3-git-send-email-yanjiang.jin@windriver.com> <54F44F4C.8050604@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<jinyanjiang@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F44F4C.8050604@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 2015=E5=B9=B403=E6=9C=8802=E6=97=A5 19:53, Horia Geant=C4=83 wrote:
> On 2/28/2015 8:00 AM, yanjiang.jin@windriver.com wrote:
>> From: Yanjiang Jin <yanjiang.jin@windriver.com>
>>
>> Add two missed dma_mapping_error() after dma_map_single().
>>
>> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
>> ---
>>   drivers/crypto/caam/caamhash.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/ca=
amhash.c
>> index f347ab7..f6ad322 100644
>> --- a/drivers/crypto/caam/caamhash.c
>> +++ b/drivers/crypto/caam/caamhash.c
>> @@ -160,6 +160,10 @@ static inline dma_addr_t map_seq_out_ptr_result=
(u32 *desc, struct device *jrdev,
>>   	dma_addr_t dst_dma;
>>  =20
>>   	dst_dma =3D dma_map_single(jrdev, result, digestsize, DMA_FROM_DE=
VICE);
>> +	if (dma_mapping_error(jrdev, dst_dma)) {
>> +		dev_err(jrdev, "unable to map dst dma\n");
>> +		return -ENOMEM;
>> +	}
>>   	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
>>  =20
>>   	return dst_dma;
> Value returned by map_seq_out_ptr_result() - dst_dma - is always fed =
to
> dma_mapping_error().
> Note that using an invalid dst_dma in append_seq_out_ptr() doesn't br=
eak
> anything, so it's ok to check dst_dma later.
>
>> @@ -173,6 +177,10 @@ static inline dma_addr_t buf_map_to_sec4_sg(str=
uct device *jrdev,
>>   	dma_addr_t buf_dma;
>>  =20
>>   	buf_dma =3D dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
>> +	if (dma_mapping_error(jrdev, buf_dma)) {
>> +		dev_err(jrdev, "unable to map buf dma\n");
>> +		return 0;
>> +	}
>>   	dma_to_sec4_sg_one(sec4_sg, buf_dma, buflen, 0);
>>  =20
>>   	return buf_dma;
>>
> These functions are expected to return dma_addr_t, not an error code.
> If dma_mapping_error() is needed within their scope, the return type
> will have to change. And return value will need to be checked by thei=
r
> callers.
>
System run well without the above changes, so abandoned this patch in=20
V2. Will do more test in the future.

Thanks!
Yanjiang
>
>
