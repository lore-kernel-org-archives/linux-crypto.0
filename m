Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF3813E8AE
	for <linux-crypto@vger.kernel.org>; Sat, 12 Oct 2024 08:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728721451; cv=none; b=mZNsFXN9v+Zw8VD7UO6OgccGJvhabYi7NGO0pdD6mBOHp5Mv4JORi3G84Nl0ubC3axCD5n6hVXYUCGxKJc8NMpdZTE0JDAc3ZdFy/j4rNdMlSomxKWW6AHoRuqNFOk1/qWn2ZM/pHRzZmm8Y/9yYFuAM9/kQE1tlpkSBzoY8grA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728721451; c=relaxed/simple;
	bh=O1XrseMxKPU3CSygOcpj6EQy4x8ye3XrJ2wkPTMw+Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOOexWMlvFh7sLXYKdd2uFR6ydKFxkrjeOt63B0zJb77RFrgO2tWY0rZNj7MxtYVPxT8DyF+K6nIheCmoawSc9w/Dk3ignRSjXJsokV2CcAt46BidHpagSpt22q65J6X3Oa3bc8EqM1fcnKb1wSQ6aBTUeSEBqMKVNQ3kUcYEKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hkHYWU4A; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hkHYWU4A"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71e4244fdc6so874909b3a.0
        for <linux-crypto@vger.kernel.org>; Sat, 12 Oct 2024 01:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1728721448; x=1729326248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iQ0uJFCIUzT5iNpWEa5laAuFLJ9LFFMlsGAFCSG8b8k=;
        b=hkHYWU4Avxi60h+/2Xexun7J3RCvyIwGHDUyXbjJ3kFPqSEPTLbzIOU/Wkhc8uO25V
         wYeaqoF4QqDFZNQK2qctaINZl7hc376LqAgWMmBp0/kmZ51z3AIcSmB9HQXXXIdxHhop
         hQ+oMZA2CN5b5MCRzAK/N3CUN1B2XltOyxOQXX4SIy4Uc/lS2Ja4/gnWxeIh8ZxmVdBs
         F3O+QcN4WGUGBL2XqOTkB864gINGgCykEPi+70tliIx8+6vo7MIMh5t/NKqs++BJIBMd
         GMkwRJdZOhHheNkbC5heiNibxOoNDD1M9ku5fmdcBmm4MMWfEvgle7FeVw0W6lZNWOPM
         lmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728721448; x=1729326248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQ0uJFCIUzT5iNpWEa5laAuFLJ9LFFMlsGAFCSG8b8k=;
        b=pEW2Zoj/3jf+opVW/sFwn8FUlKECfIwShHdNZeFHzvbeqQqUB0I1bat8qr/zQRKf0v
         LMwh/mXDXKD/lYEiGLaWJdrtwvyzuBKaiDL9aDcssvWFED+EjEFtzr8YPt/XDkS72Jw4
         XeywZEDoI68Hp02/mKaaJtny7z4Ghi6MhAMmyeX/nq1nB2hh4WA2V0UYM0iGYjPma3mo
         fMvvNRTbHfrZ5b71iEPaT/flGAvK2Fcyt+hl6ZrizrgMWOU5MOXcbyINkBYTiblSXoPr
         maMGcRxNZ4RJGlItMjKCUsXvQMJG2+0ZHgVo7pVd0QkDMXu+lWK+Z3TYpg9e9G2q+8Wd
         8XQw==
X-Forwarded-Encrypted: i=1; AJvYcCWUxTFibIybQH8hV1SfjRnv9ldRG6i9G2dI7O5uywBmPPyI29e2T3LsFzr0WZmNQ8NP1sDcIQ5H3qHBoX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF3KWUOhMaSODmGeW4MBw6T151ZtDLowQnO8tKd8QDyoE+Hftn
	GpvtpeDg6hhS02rPrtQb780Qv0ZlJqp65d2RsG7AMjIUJ3EdWD2SLXw+VamQbd0=
X-Google-Smtp-Source: AGHT+IGIAD2RleNINJaOlV1Ndb7siGou9hMwoYmXRnCufbaqLw2AzkPv1vfWjneW5pepG/UvMddXsg==
X-Received: by 2002:a05:6a21:1304:b0:1d4:e56e:93b5 with SMTP id adf61e73a8af0-1d8c9594fa2mr2733839637.16.1728721447658;
        Sat, 12 Oct 2024 01:24:07 -0700 (PDT)
Received: from [10.3.43.196] ([61.213.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2a9f6982sm3764098b3a.77.2024.10.12.01.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2024 01:24:07 -0700 (PDT)
Message-ID: <870327e4-2391-4f42-82ad-2d9593a70ebe@bytedance.com>
Date: Sat, 12 Oct 2024 16:24:01 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: virtio/akcipher - Move a pointer assignment in
 virtio_crypto_rsa_set_key()
To: Markus Elfring <Markus.Elfring@web.de>, Gonglei <arei.gonglei@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Nathan Chancellor
 <nathan@kernel.org>, virtualization@lists.linux.dev,
 lei he <helei.sig11@bytedance.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, "David S. Miller" <davem@davemloft.net>
References: <80b91321-138c-41de-95c7-47c3be07fe76@web.de>
Content-Language: en-US
From: zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <80b91321-138c-41de-95c7-47c3be07fe76@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/12/24 16:06, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 12 Oct 2024 09:51:58 +0200
> 
> Move the reset of the data structure member “n” to a null pointer
> into an if branch so that this assignment will be performed only after
> a key parsing failure.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 48fee07b7e51..56557d4778b0 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -355,7 +355,6 @@ static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
> 
>   	/* mpi_free will test n, just free it. */
>   	mpi_free(rsa_ctx->n);
> -	rsa_ctx->n = NULL;
> 
>   	if (private) {
>   		keytype = VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
> @@ -365,8 +364,10 @@ static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
>   		ret = rsa_parse_pub_key(&rsa_key, key, keylen);
>   	}
> 
> -	if (ret)
> +	if (ret) {
> +		rsa_ctx->n = NULL;
>   		return ret;
> +	}
> 
>   	rsa_ctx->n = mpi_read_raw_data(rsa_key.n, rsa_key.n_sz);
>   	if (!rsa_ctx->n)
> --

Hi,

This change only reduces a single assignment on a key parsing failure, 
however it breaks the original "free a pointer, and set it to NULL".
I prefer the original style.

Lei, what's your opinion?


> 2.46.1
> 

