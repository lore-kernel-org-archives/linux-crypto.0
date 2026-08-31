Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD730FF30;
	Mon, 31 Aug 2026 12:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180151; cv=none; b=IaUzQwNaF3ZuB/wSe5GILOyObMBC7/YekKkToWdonqXMTLtipqsZegJHjlWMZMaoBX1/WQhBOLvT/AHjVpZmYIXSgLIi8a9NMuXflQA4YX/bBaCxGG/OSKm45qjuX4lUKuMpCOydhtIYrah8N+jirmNbqwAQ3RU2crGdPJOLp7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180151; c=relaxed/simple;
	bh=daxP3oGckYB3ivKobHas0zhXFaP5ay/PwGt4t4Drra0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhVdM8oEOhZAqIsFfDFWMPmOw0Q1JEyx0ISQS69YqwL3A7Mtxmq4vPvJ3BSXnOmI0AApdX9vKo7XINhnU1N8kgOXPXEAeUfZW+J6LRc47z9BhL7muDEjqJ51IjMpl73ACackWU6UYhf+tNJ1MHFNw38N6ViIF9zSiHh2Zp2tTwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 69d7301ca53911f19a56ed5b684f684d-20260831
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c9ff823a-94c6-41c5-b850-44eeaaa89722,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:666a4fd82c97b30795e2ef1f5b60e771,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|136|865|898,TC:nil,Content:0|15|52
	,EDM:-3|-100,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 69d7301ca53911f19a56ed5b684f684d-20260831
X-User: lilinmao@kylinos.cn
Received: from [10.0.2.15] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 942591670; Mon, 31 Aug 2026 20:42:23 +0800
Message-ID: <6416cbee-35c7-4fc8-9a80-a25403eb1e6f@kylinos.cn>
Date: Mon, 31 Aug 2026 20:42:20 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: mxs-dcp: handle zero-length skcipher requests
To: Frank Li <Frank.li@oss.nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, Leonard Crestez <cdleonard@gmail.com>,
 Radu Solea <radu.solea@nxp.com>, Franck LENORMAND
 <franck.lenormand@nxp.com>, linux-crypto@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260828093209.3179074-1-lilinmao@kylinos.cn>
 <apHgn8-IcTshYnfv@SMW015318>
From: Linmao Li <lilinmao@kylinos.cn>
In-Reply-To: <apHgn8-IcTshYnfv@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/8/29 3:25, Frank Li 写道:
> On Fri, Aug 28, 2026 at 05:32:09PM +0800, Linmao Li wrote:
>> [You don't often get email from lilinmao@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
> Any document show it? if return 0 when cryptelen, it is async, no
> call crypto_request_complete.
   Yes. CRYPTO_ALG_ASYNC means that the implementation may complete a
   request asynchronously, not that every request must do so.

   A return value of 0 indicates synchronous completion.  Only
   -EINPROGRESS and -EBUSY cause crypto_wait_req() to wait for the
   completion callback.  The existing fallback path relies on the same
   semantics.

   There is also a direct precedent in commit 8a4e047c6cc0
   ("crypto: marvell/cesa - Handle zero-length skcipher requests").
   Marvell CESA registers asynchronous skcipher algorithms but handles a
   zero-length request with:

           if (!req->cryptlen)
                   return 0;


Thanks,
Linmao

>
> Frank
>
>> When such a request reaches the worker, last_out_len remains zero. The
>> CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
>> value when updating the IV, causing the offset to underflow. On
>> decryption, the resulting source address precedes aes_in_buf.
>>
>> Return success before enqueueing zero-length requests. This avoids the
>> invalid source access and leaves the IV unchanged for a no-op.
>>
>> Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
>> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
>> ---
>>   drivers/crypto/mxs-dcp.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
>> index 133ebc998236..60794b4d49fa 100644
>> --- a/drivers/crypto/mxs-dcp.c
>> +++ b/drivers/crypto/mxs-dcp.c
>> @@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
>>          struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
>>          int ret;
>>
>> +       if (!req->cryptlen)
>> +               return 0;
>> +
>>          if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
>>                  return mxs_dcp_block_fallback(req, enc);
>>
>>
>> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
>> --
>> 2.25.1
>>
>>
