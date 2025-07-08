Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658EF239E99;
	Tue,  8 Jul 2025 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752005344; cv=none; b=XT3wFzWTMOnJHtfipR6LU2lZyGbPWs9KEuhoqdXFFR0QWwEvFWeLItxgq0Y6YWxshrHRqmxLWB3spFVyDMNRPPUlGtODDfBM1PfPbs99+ThvoZXGOcBuXAg0c01CpQpGOsyvh4KNcNZbHb48/klsrabh8GLDjNhExcdN/smwVwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752005344; c=relaxed/simple;
	bh=wGIW3vTTNsPMFwa66S33gP0jJPz9vag5fqV6TgNMRkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X10Uxk95PPO0FbDWlVQ5HX3NBUWwM2TkrQQ2rMuI1hFq/EvbxDRuBOFKj6aWJglBnss07wHYT/7SXB01DqP2WcL5gKjNV9DjoSWXczNGKsk6y1CDRcQjPCn5uLZcgjDYTqsLjFMfmxv5lERyO3bzRKOdRhfO6JI8DKKdYkuilVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtB/W5mV; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtB/W5mV"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-607cf70b00aso9337200a12.2;
        Tue, 08 Jul 2025 13:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752005341; x=1752610141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SJoKGMixdxbuoBQZf38SMFzcAORtomA8uvkcfR18me0=;
        b=VtB/W5mVq01kTEQZiJRu51ghIlT8oD89+3a0m2/5T3BOxp7IKoFEo6g29DEesI7QwL
         yVoTxGC5MnglxfTG5QZHXx0UZ0zruAv2Vgn6HyRwKaSSJv6uc33KFMHuMuZxy+DpjSCX
         WVpbH/WnApepBDJ65BeRx5a9iBNu0KnnOe/kO78q3bZg29tZ91L26vxKDYKmHMxECcC9
         ToBS8fuweLMTrqwOG+PoPymSBLeIv+4rGqkgANq2gw/qFoKw1mr8b/3oITSn4uz9W/A7
         8pOm09CaVA2JWJjwgyAXd1R7Q3OFXmqr+SChrRhkLkxi2yzBKQ7Zb2QkCV+NyVIEpFgT
         zRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752005341; x=1752610141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJoKGMixdxbuoBQZf38SMFzcAORtomA8uvkcfR18me0=;
        b=Lt2PmvDMpT19A4+WuE7mKdTTej5SiKJbDCRXwyTnKHON73aYXVZDXAG+UtBP/vGamu
         en7ztenobo0Q14w3EeqEEtNuro9WwjwOCGHCnJtTo6LB9PUOlcqnhztPB26m1MrlCYMR
         2NQwYWObIySaK0WvODedXmwt0hPH/i1B7NmdliGKWJf6eeMeVxcf5GN5e1chEDj1soJ1
         lXEqR6lE+rpEOwWQALlDKKo5I4+dDrSMvk4tffWJ0DSQpfall8OqBEmbykh9YvcVeztW
         FxpZiLtrL/Ty+he8ktUL72rsmc7JDRjarsRcKUvaOfjDaC45RRPvWHqpuEinvQngLDCQ
         GK7g==
X-Forwarded-Encrypted: i=1; AJvYcCWm5h0n+lP3O1qXLTQqG5VxY/RigXxVJ2+KHnjG0txprJSkZCRbLUezcOCtJn+ykgBevR/9Wen2ashilQM=@vger.kernel.org, AJvYcCXN6EgcSLjCeAm5dsb4MKvZYuTgz+QP//RfMbhyWDSQ7vNyKWxL72dfe/YLLtpcVUSvNU1PpS29p1UYxASo@vger.kernel.org
X-Gm-Message-State: AOJu0YxKfk5CEWfiZNZ2gJcvpi/T0mQKCX3CIt/Znw3p4eC09jhERLRX
	irotiEwkEB2TjLCQyEL1/sI+8BdTgr8y3FOJzWRuUZvCOCIiL7TDSahO
X-Gm-Gg: ASbGnctnEz7FBnsQ7LVu4BqKgucom9ciMigl3MpSRc1fJleWT6edT01Csrb9FQwAzRJ
	17FyCwv3vKI0n6GAdibqNpbiPXqxal6FRi5XFx1ljETJzAnRpCp6RmFAQI4Hj4DTvfpFNFkK0lf
	sWKNqvlQxLCOAG+1JzvkK2dgx6Su0RZRUWzXcIK/7GYTrLL7XAZy4CUI+QNLygL2cHBDY+qCMT/
	d5JmPnibyQsDQU6HR4uoLe/YMLN9FEj+lHAzec/UCSwKA7i5rkiWVuwMFcpqMIf8vlUDoGjRVLS
	DmyjwhwtCNBRWBrKH9Wk30fZbvWPGRZfd0otVwyv2/J+X9LitZxjYTy8pSGUd0HqoGUKMpJuBwT
	f1RALRaXbCU1PzqnLT4bUwWybRYoorxvYehOzN4iMVLJ8V0UF28GQixEIbQ==
X-Google-Smtp-Source: AGHT+IFMUIFhAFLtzXXbjGIvBhyVU4xR5NCQSkIi81NSZsJ4W1pu9KoFPlGV7XT3Rq6mPNLnbiIOLA==
X-Received: by 2002:a17:907:7e9c:b0:ae0:a483:39bc with SMTP id a640c23a62f3a-ae6c6cdfdabmr52787066b.46.1752005340445;
        Tue, 08 Jul 2025 13:09:00 -0700 (PDT)
Received: from ?IPV6:2a02:2f07:6009:b200:8bc2:7901:5231:7913? ([2a02:2f07:6009:b200:8bc2:7901:5231:7913])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f66e7f68sm961243066b.13.2025.07.08.13.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 13:09:00 -0700 (PDT)
Message-ID: <95f4ded3-f649-4bdc-a3ca-cade77aa2e92@gmail.com>
Date: Tue, 8 Jul 2025 23:08:58 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] crypto: sun8i-ce - move bounce_iv and backup_iv
 to request context
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
 samuel@sholland.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
 <20250626095813.83963-4-ovidiu.panait.oss@gmail.com> <aG1lN94feb4OJVsI@Red>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <aG1lN94feb4OJVsI@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/8/25 9:36 PM, Corentin Labbe wrote:
> Le Thu, Jun 26, 2025 at 12:58:06PM +0300, Ovidiu Panait a écrit :
>> Currently, the iv buffers are allocated once per flow during driver probe.
>> Having a single iv buffer for all requests works with the current setup
>> where requests are processed one by one, but it wouldn't work if multiple
>> requests are chained together and processed in one go.
>>
>> In preparation for introducing request batching, allocate iv buffers per
>> request, rather than per flow.
>>
>> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
>> ---
>>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c       | 18 +++++++++---------
>>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c  | 12 ------------
>>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h   |  8 ++++----
>>  3 files changed, 13 insertions(+), 25 deletions(-)
>>

[...]

>> @@ -273,6 +271,8 @@ struct sun8i_cipher_req_ctx {
>>  	int nr_sgd;
>>  	dma_addr_t addr_iv;
>>  	dma_addr_t addr_key;
>> +	u8 bounce_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
>> +	u8 backup_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
>>  	struct skcipher_request fallback_req;   // keep at the end
> 
> Hello
> 
> Are you sure you could do DMA on sun8i_cipher_req_ctx ?
> 

Yes, that is my understanding. Request ctx memory is allocated in
skcipher_request_alloc() by calling kmalloc(), which returns memory that
should be suitable for DMA.

Also, there are multiple drivers doing this already. You can grep for
____cacheline_aligned inside drivers/crypto to see other examples.

Ovidiu

> Regards

