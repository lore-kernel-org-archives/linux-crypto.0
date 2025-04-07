Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EA72A8C1;
	Mon,  7 Apr 2025 06:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744007182; cv=none; b=W2NdnKVT+3C5H38jgVH3G76j16O7/wHPJm85XcS2uFJvK/cq5X+bAQbiBGM/g5ahdX/2DiAVpMvOreE4gVVDOTMFd6jfX+8LpTd2Q/Iu5N6DxqoKcMFzCQRdBABW074mO28Mlwqg4+5AfvjdVsWI3F5Ti8dZospKZpSBaNV+k2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744007182; c=relaxed/simple;
	bh=k8YYOPh/3JkuLOMn/Hj98STqPu3UvcIJ1IzVOh1TAOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jsJ92awq78QcSgGJb1zhxISzzBfx80LoxCKpmu/SqcKPj7eKsA88atrBbbDU2MoVYVw98qI/AJKLblajWn00uWW0fYDk2k60AwwNqsIYlnLYtcbwXemYdlQqQmuQxXWmU0hM7wdP93NlMOXjxzNoBk+HxmAuGAoRKuKQsm3SMOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V//rwAjW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V//rwAjW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso42704085e9.3;
        Sun, 06 Apr 2025 23:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744007179; x=1744611979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7vcZaHtT0Bdp7jhNpBVwgeNyTw0QbyKnO+4kb1PkgZw=;
        b=V//rwAjWBfRLbFdQ4NmYutnEKNJP6XdGcRTo5ckph0Kcqf2qHslEQsNNJI67WTG6KA
         AlzPIYC5PZLUwyo772JtYFzXFq4iyLobzjEzmp1XSwmQnSdZRzaHzU7g2wSIoG9BNrNg
         6ysZs0COspIFREZksUvaOK2pOvjjN1XFcxCwzk0YhOOl4OYQsRPAlg10sjwPWbzY6/xG
         vuAbSbKSHwctG30f9KNuTZsr1/apAHUijw++0BNZLVNa8L5dOdwz+STgKjFi/fne6BKc
         Mgj5gr3TfTLlvkmjSHf9+HgmozuZAqcolWtyXspg95OEZS9NV9Hh2mP3k05ExzKWdsXx
         04Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744007179; x=1744611979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vcZaHtT0Bdp7jhNpBVwgeNyTw0QbyKnO+4kb1PkgZw=;
        b=AgjXRlwuGKW6xauMtU/d0iv9V+U2jtXJxBHg6dYCW8LbvnXj8e3pvT8O+jVpogpb4p
         9+re4Dh2pEWycWLMUIni05g2PO4MdL7IFrnjyCkMxEiaIioFiZcHH2t3HUv0/CTxKLwP
         SriQC57jrt8rwUxM9sUAtV9qx0OOq2Z6wjyut+aK9bh2btx0lfhhc/11wwKVhD80Hprm
         BiOv935f9+o1cPOkLzI9hBrtBA8bUoI7et9qsQ3IbDnkePZPni361bzuG8bQaXbB5tsw
         WD6dfC59Xw1eS902TqUwAa3vbao1tidEMpqB0qc79ZKJiSna9bD4i/cc6zrmRFUNNs6o
         i94A==
X-Forwarded-Encrypted: i=1; AJvYcCWxjy5WjyNvibQHaF3lNSOTHTLWmfUgA21yTT/Vv1xrI1EcjPwKoGlPaCvWC/cg7B5vS2Ut4eWowNg4rClu@vger.kernel.org, AJvYcCWxvCf1sOLIE+ccTVk1UmX6hd5MjvnZzOTNBe+JTX+1E5X5DzSNd4LxcX/cen48tg/7GJUOtAijdmokAdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ6U1/TA8IIKGH7cuBnkY+nBLhMvUnP/GviF+RRmefCS4Lg+Cd
	+qk5MbVf9EldIG3fI5ste0NtvOmBQf47XNPoEAgQNsMSIkG88aGLWLCaHQ==
X-Gm-Gg: ASbGncuQrfWblU6YUdPpMvs6zcMyCiCPbfUSzOS550GKcPKDFKQs2ioGinxnMWeLFya
	V1WDF29wFNXrmIkqAAZ3SQ4k/XD/47gOQltfQceaW2eqG3I66f+XIo1873QhzcBL+Rjk8EjkKcy
	7vKznBHMduKNw6peQ2yw74tLcCp9m+7LxBEKN55wBjpKsBbFct8/bpDASk+qq4VuAY08WsbKs7R
	eqBUqi+apHVNNExASvL5XWkj3l/u4h2B2//LGjOp0cU0QFUy9vyruv7iLT/KRYWYcj6H2r/s3L5
	pX/laSvRIyAFih19CZrdaKxRROzPkAoHSPt9SRErrMv5T0svn/CUtosi/3KgU1pbRn7Qt6SNVgB
	srRiC+3ewRqobrfib0XHvGjhBo71lgg==
X-Google-Smtp-Source: AGHT+IGNAbuqm5FmxluF5wtjWawmF2WQ5tcvDHorTjnjuiAauWPbvFZ5uA5beNY4uy00YPPjFwGD/g==
X-Received: by 2002:a05:600c:a04:b0:43c:efed:733e with SMTP id 5b1f17b1804b1-43ee06401a7mr54753425e9.14.1744007178599;
        Sun, 06 Apr 2025 23:26:18 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6? ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a9da1sm10916991f8f.22.2025.04.06.23.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Apr 2025 23:26:18 -0700 (PDT)
Message-ID: <115a9838-faf0-4607-87f9-c952b43bca78@gmail.com>
Date: Mon, 7 Apr 2025 09:26:17 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] crypto: sun8i-ce-hash - drop
 CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG ifdefs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
 linux-crypto@vger.kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
 samuel@sholland.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
 <20250401192321.3370188-4-ovidiu.panait.oss@gmail.com>
 <Z_NM9LnUF6Gpv_iz@gondor.apana.org.au>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <Z_NM9LnUF6Gpv_iz@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 4/7/25 6:56 AM, Herbert Xu wrote:
> On Tue, Apr 01, 2025 at 10:23:19PM +0300, Ovidiu Panait wrote:
>> 'struct sun8i_ce_alg_template' is always defined, even with
>> CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled, so the ifdef guards
>> are not needed.
>>
>> Make sure the statistics have IS_ENABLED() checks instead.
>>
>> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
>> ---
>>   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
>> index b0959d8218cb..530c5181d73c 100644
>> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
>> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
>> @@ -31,9 +31,7 @@ static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
>>   
>>   		algt = container_of(alg, struct sun8i_ce_alg_template,
>>   				    alg.hash.base);
>> -#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
>>   		algt->stat_fb++;
>> -#endif
> 
> Should this go under IS_ENABLED as well?
> 

This is already part of an IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG) 
block, so no need to add an extra IS_ENABLED() check here. Just the 
ifdef was dropped:

	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
		struct sun8i_ce_alg_template *algt __maybe_unused;
		struct ahash_alg *alg = crypto_ahash_alg(tfm);

		algt = container_of(alg, struct sun8i_ce_alg_template,
				    alg.hash.base);
#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
		algt->stat_fb++;
#endif
	}

Thanks,

> Thanks,

