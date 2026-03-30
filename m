Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5978C301471
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881535; cv=none; b=U0Z8/6fb3QHAPMwHLbVM/F5vHyC4o9+TdhHcjaWJXTbnAdVFOBKvIt1LUNG8n0ENEqufIAl9T3yH0d/QqIlvIfVOlvaRUGSxtvMBkL+GSUxyxH61UqeW5Zklj7JRgIh9W+yeMdv54qIi5SSKP3DgvhWr54TXeZ/nV3Z8mR5uvxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881535; c=relaxed/simple;
	bh=koix8bOEomZhxXXqSljRHzrLE4EdrdQWjNIZqocOroI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=W6hqUz4o99GcWjej7aCr8lnOunIyt/eRAD1AFHlxCFoaVjrel5v6U2B9azZSj0qpF3lOXnHkrQwUNYNj2MhMyXem7SKQUjcU4LdM5Ro76zQBVqfz3N3r01YXQO1T69OoBlx2E8Pw58LgKNS5VgnkwSTS3TNTFvxpGSts9iMTUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GdAsOAK2; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdAsOAK2"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fd5c4891so5014785e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774881532; x=1775486332; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ig7fKYjfwkrimY9Uw52BzM2CblH3tO3yAFQK+rKl0qE=;
        b=GdAsOAK2dSnJuDuhV4LG++DtX3frXATlaQQyeutv7A8dl6nj2JxRQa6hbZUdzb3FZG
         GXXKWJgNlepXtKHDHm4OLCmmJXBeRLfgRUMZAy9oMNSI2z/k7V1oFhNsgz6IKklnKu87
         UwrqmV85K/X3A61EG/Zd1BYUO6MPxetMKvXpJvaCb/3o9hIdufndBQIG5itR39wzd6Te
         u0fAAe35szsotJEvLyZPVvctl9HMzH36OhaKpWvgDMZI39HcV03thKq64HwQT12ei5FZ
         ehzQD2Pe/9w6oemGGNhbhd52+eZanCLqYv9TvGE3yFLZh2t57ia7lm2gQKHzoCCkexQl
         B/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881532; x=1775486332;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ig7fKYjfwkrimY9Uw52BzM2CblH3tO3yAFQK+rKl0qE=;
        b=hCB8Dq22gx30BNOtERE0R5bPquWB6q9mhAJXH2tZj7kA4wsKewbaniEFd3SLtL4AcT
         V+GGiejJo6FxX5ZkFVmpzBO7rLeJbKquLihyVQ+EE3KW/CBuEWbFuilUDS5Xw9+pdfVa
         7pzK91OqDAbrddHFnGypscP3Wv8M4olHsmtys6/zo0kbGLaX7o/7d74fmEkEvb9VDu9l
         +VPA3MxlOJN97SrEb9sW8jVyg2pAj1IUcqOOJ83/SEKdj1gzistgV24bvS8cHnUTWCmT
         IG/Z0oXJ1vT3JIF0PlsofAlR/iLK+H2zOlXpBkJEsYDawfjlpoPciaYoWdcqjQoQgo5Q
         7mkA==
X-Forwarded-Encrypted: i=1; AJvYcCWroqHX1mmZw212bGQSWodXZPik7b6mY313cw3Ks1TYsWtoyPgUIRVgbkbPl5kEUzN424La7utDS2lF7XM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZwrmW3gpCiZjjovna1LBF1CfSR004Cqu1Fzx+92GgSgTz+o+N
	jh5GN9jnyoSGviOsYpiGN8z/YVDdKseI8Fpbfk+sAHIy8Fg1882FfbYU
X-Gm-Gg: ATEYQzwUyWVqpZRy7gAHLP/LTb1tRkT6GF5y4R1mr+jz/kxmhFJMGnRonXZhi8TGzEv
	nznMI/wDRSNMEbfc4xkFCCy2Wnr0ypZ+YNllC0OLtFzLhKzGHnG2u27s0vPRDQCQ0EhYXgw1d3N
	x8yHSCcqmJgdbFVBjGo4sujoCc/ruECuFd9cNW+4AkUdv9KMe3M1fvtNMXK8YDo9oj87z0pAfP8
	9sd6fg+rQsona4Vem8vdRb+WSwmdqW2+t+aF4nq9AruvG3uIggafuHnfBnXx3OkHK8n7Wny4WIx
	CrjGJTmDCYIklXPT3DVfvV2Un6IoAsa+JX0Hce4RQG2V879OUK/YIwF3n537vdb1oHhDJUj0FdZ
	46XmrGTYkWu7cpD7S/5pWgWXW1GKVHExOp7VcrmI2lQ0l2b8W9/9VwFvUC9ypKgd/Hn7tDuxbxN
	6N9yhlLw+IDEnNpO1HZe95riRxigJSWNqpJc0phbb0W69WFALCrmJlXknm5NzAAnnkVw==
X-Received: by 2002:a05:600c:4f84:b0:486:fcf9:5ba with SMTP id 5b1f17b1804b1-48727f774b5mr127792725e9.7.1774881531411;
        Mon, 30 Mar 2026 07:38:51 -0700 (PDT)
Received: from [128.93.82.131] (wifi-pro-82-131.paris.inria.fr. [128.93.82.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873bbcac33sm85585965e9.15.2026.03.30.07.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 07:38:51 -0700 (PDT)
Message-ID: <6c016af0-718c-4986-b707-c4ce74b72739@gmail.com>
Date: Mon, 30 Mar 2026 16:38:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Thomas Fourier <fourier.thomas@gmail.com>
Subject: Re: [PATCH] crypto: eip93 - Fix dma_unmap_single() direction in
 eip93_hash_handle_result()
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Richard van Schagen <vschagen@icloud.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260330091817.25797-2-fourier.thomas@gmail.com>
 <69ca4458.050a0220.3569e7.2980@mx.google.com>
Content-Language: en-US, fr
In-Reply-To: <69ca4458.050a0220.3569e7.2980@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 30/03/2026 11:37, Christian Marangi wrote:
> On Mon, Mar 30, 2026 at 11:18:14AM +0200, Thomas Fourier wrote:
> 
> Hi,
> 
> was this tested with the crypto self test?
This was only compile tested. The change is based on the documentation which 
states that dma_map_single() and dma_unmap_single() should take all the same 
parameters. From what I understand, it could cause issues with bounce buffers 
and IOMMU permission if it is activated.
>
> I need to check the code again but in theory with handle result, we should
> get the data from device in sa_state and cache should be invalidated. If we
> want to use matching maybe we should change to BIDIRECTIONAL?
Yes, sa_state is set before the mapping for the device and read after the 
unmapping so I think the BIDIRECTIONAL tag is required.

Should I split the changes between eip93-common.c which seem good regarding that 
as is, and eip93-hash.c and change the direction to BIDIRECTIONNAL?
> 
> The mismatched flag was to invalidate relevant cache on tramissing to device and
> then invalidate relevant cache when reading it.
> 
>> ---
>>   drivers/crypto/inside-secure/eip93/eip93-common.c | 4 ++--
>>   drivers/crypto/inside-secure/eip93/eip93-hash.c   | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
>> index f4ad6beff15e..75659a45ea5a 100644
>> --- a/drivers/crypto/inside-secure/eip93/eip93-common.c
>> +++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
>> @@ -687,12 +687,12 @@ void eip93_handle_result(struct eip93_device *eip93, struct eip93_cipher_reqctx
>>   	if (rctx->sa_state_ctr)
>>   		dma_unmap_single(eip93->dev, rctx->sa_state_ctr_base,
>>   				 sizeof(*rctx->sa_state_ctr),
>> -				 DMA_FROM_DEVICE);
>> +				 DMA_TO_DEVICE);
>>   
>>   	if (rctx->sa_state)
>>   		dma_unmap_single(eip93->dev, rctx->sa_state_base,
>>   				 sizeof(*rctx->sa_state),
>> -				 DMA_FROM_DEVICE);
>> +				 DMA_TO_DEVICE);
>>   
>>   	if (!IS_ECB(rctx->flags))
>>   		memcpy(reqiv, rctx->sa_state->state_iv, rctx->ivsize);
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
>> index 2705855475b2..19a41a0db667 100644
>> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
>> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
>> @@ -67,7 +67,7 @@ void eip93_hash_handle_result(struct crypto_async_request *async, int err)
>>   	int i;
>>   
>>   	dma_unmap_single(eip93->dev, rctx->sa_state_base,
>> -			 sizeof(*sa_state), DMA_FROM_DEVICE);
>> +			 sizeof(*sa_state), DMA_TO_DEVICE);
>>   
>>   	/*
>>   	 * With partial_hash assume SHA256_DIGEST_SIZE buffer is passed.
>> -- 
>> 2.43.0
>>
> 

