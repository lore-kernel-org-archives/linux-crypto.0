Received: from outbound.ms.icloud.com (ms-2003e-snip4-11.eps.apple.com [57.103.72.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255DE314B9D
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.72.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779659380; cv=none; b=YY7jToEQs3jIr2Nw7c5Ukr48ja5Gj3DkWfBxndRUsaXCdBoK+swzQoJ3SyvjxXNeBk12aVS0QZxQaO42vqZKLl7HXavFMuBWMcUHadzHt4emtV5Xg3ixeamcbTQwv8gjtAduzfx78lX0VKOkuxge70frTKtTXDK3sf3iTYAyHtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779659380; c=relaxed/simple;
	bh=IIBCH6ptmgQHv1SDRa4yl26HmcZuF5f4ffCLhg9IUIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6Vyt6SJAeWCjPZ0By6WOaizUMP1h28EqmteHZ0lFhWoNSqEydTLP/noT8HPnFKnj/u7agaLAbrfgNFFfwZW62xJnEt+GHI7bshaHaTOPKprMXab4bfvdMJtxS/+Im0ksqJBXMyFITwJUhxTiuBQZ5HDpqBmwairn32uFiUFdkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=EApFImie; arc=none smtp.client-ip=57.103.72.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="EApFImie"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPS id 60F7518000B9;
	Sun, 24 May 2026 21:49:37 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKBkMGXwteCE8EQwVZBVBcHA4FQhlACVQZXV8FWgAwUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZaEhhcFFxQWB5GElYNXQkZBkFeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwYVC04KXVJfH0UPTVBAA1tUFhQZBgwARlZBDk0HC1UKAkNdTnMEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779659378; x=1782251378; bh=3yDmhTZJmpqaczhBUy2TX7zdpnWoGdUQ55ccG8khxV0=; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme; b=EApFImiePd9RPRLX/yeo6jKg2hsE04+pLXJe0TdIOQDka2I8NxaGDIsvPsxu3wRh6DXFX/vm2qZkpKhBnUcUanbRZ1uszy+9T6D1e8X/ckZEKNtXWZDogEWLdADGmR6NLJ0F2kpIVswYZWkiWnqA0S6gyYlVLZH18FjV+d4baXzlyPWKyb0fMl7IotTVBFpDE9KIunj+dTqkg8MvBqv4Ed85PYOHkn9iy4zK8hHbMXk+5KokiFnWEGmK25Pov2K7+tcvCUBGxOlZcT2WPM34viO5kX9poDLVa6QuelGlhBOb3ilO45Kjak8A2ZGVjtvk4X/e/gm4jS5TL8FTxSo0qA==
Received: from [192.168.89.2] (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-7 (Postfix) with ESMTPSA id 1671B1800093;
	Sun, 24 May 2026 21:49:34 +0000 (UTC)
Message-ID: <4e2690e4-565c-40ff-a5a7-d1754fba03d6@icloud.com>
Date: Mon, 25 May 2026 06:49:32 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] crypto: eip93: return IRQ request errors from probe
To: Aleksander Jan Bajkowski <olek2@wp.pl>,
 Jihong Min <hurryman2212@gmail.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Richard van Schagen <vschagen@icloud.com>,
 linux-kernel@vger.kernel.org, Benjamin Larsson
 <benjamin.larsson@genexis.eu>, Mieczyslaw Nalewaj <namiltd@yahoo.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
 <20260524194528.3666383-2-hurryman2212@gmail.com>
 <ddb3ad67-5125-457a-b033-8804f08b4439@wp.pl>
Content-Language: en-US
From: Jihong Min <hurryman2212@icloud.com>
In-Reply-To: <ddb3ad67-5125-457a-b033-8804f08b4439@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0tkoMmssD7leauY8IX8sLfl0u0ZTBzZs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI0MDIxOCBTYWx0ZWRfXwxr0FEnnkIRR
 RsIigoOfhALk5wIA/SobtORoTbX6EvyUXgIh3cXAnbeysOhc3hq8N5PI9RIAXWHlleNQIm9Giwy
 32OSpuPYg81k/PCrjSGqPcNhYg+XzPOpQ1UbbGKnrrBLinCRVess/NnHUWTHP2zocua7zv+i2js
 ZGDVqHehDu1NVdlBlkebfRFrK3RwpTAJCmiMwy0a2NcIJkYFC0PtBrnHPRh7rQAII+1M7nWAzRg
 HjARUX1yddnI/IiqDodnM3vjssGDPDe8H+wNkjsmi8375yd22LtxJa3Y1nnjuqmkBBYo4wXyht1
 e+RJlLYjnVwSAx9vj2WH5GV9tn35On3t450adw1ObvZl3yOplQb7eNoHk8p1Ms=
X-Authority-Info-Out: v=2.4 cv=TuHrRTXh c=1 sm=1 tr=0 ts=6a137272
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=5jDBv52wX64A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=CjxXgO3LAAAA:8 a=pGLkceISAAAA:8
 a=EsG-66shvG4mn6RJVvsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0tkoMmssD7leauY8IX8sLfl0u0ZTBzZs



On 5/25/26 06:09, Aleksander Jan Bajkowski wrote:
> Hi Jihjong,
> I sent same patch a few days ago. You can find it on Patchwork[1].
> 
> 1. https://patchwork.kernel.org/project/linux-crypto/
> patch/20260518212506.292170-1-olek2@wp.pl/
> Best regards,
> Aleksander
> 

Hi Aleksander,

I missed that patch. Thanks for pointing it out.

I will drop this one from my next submission.


Sincerely,
Jihong Min

> On 24/05/2026 21:45, Jihong Min wrote:
>> devm_request_threaded_irq() can fail, but eip93_crypto_probe()
>> continues as if the interrupt handler was installed. Return the error
>> immediately so the driver does not register algorithms for a device that
>> cannot signal completions.
>>
>> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel
>> EIP-93 crypto engine support")
>> Originally-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
>> Assisted-by: Codex:gpt-5.5
>> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
>> ---
>>   drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/
>> drivers/crypto/inside-secure/eip93/eip93-main.c
>> index 7dccfdeb7b11..276839e1a515 100644
>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
>> @@ -433,6 +433,8 @@ static int eip93_crypto_probe(struct
>> platform_device *pdev)
>>       ret = devm_request_threaded_irq(eip93->dev, eip93->irq,
>> eip93_irq_handler,
>>                       NULL, IRQF_ONESHOT,
>>                       dev_name(eip93->dev), eip93);
>> +    if (ret)
>> +        return ret;
>>         eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93-
>> >ring), GFP_KERNEL);
>>       if (!eip93->ring)

