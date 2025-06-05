Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739841D5ADC
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141742; cv=none; b=r33JO1RvNPZYXurYRxaT2stylMi+gIaajGz0/fQlT6quXJRIoEDbhrEl+9mmpqqoTaJgcb3oNOOK3bxDZqiN31OrhvHw01aImLC59lKN7MVpvIQmD+zTU+y/iBs1UOGt/4mEcxVw3SkRrcado7OA9DvGxvkRcy+amNdJnoFcyMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141742; c=relaxed/simple;
	bh=2Zhs+M9ZnxmxCp9BVNfqsWyO+h4AB/KaW9U1uT5qhP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nksm+v2o2tRQPTQut7De2AhR6eRnizwGG+jxJhEVewfZ0HDtLllWrMj2R1rFVu/GGOfsMf36CokcnDg6fLuBhVQMWl1VV+JxgREWmrlUuRUxMt93+QgCzLSnGo/5Q9lVVBHZNMljJw0dHll+V0aDnB2+FngZEntBI5fkVFJ6R+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=Bz/ygEwv; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="Bz/ygEwv"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5533302b49bso1316057e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jun 2025 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1749141738; x=1749746538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PFO6uqE3omBPZMM2RRJAUzPXA8e6WjqOavvxq7pzHeU=;
        b=Bz/ygEwvNmjcnmureWwQTkGArhrQAh94MzwjzVZZ9BwL1CuAy0RzBnrW73NiAMlhrT
         h5l80AChfNXgb7B+SmZT3uWxZncBuQWu2vd6YzFYT9+IZdSaaFwJqLzc/PWWUd7wQv+0
         ABGFg1HQHrESHeNJGqZ7C8Ugo8gxmaJvj40IN52Hvu7MEqeWBiJoa0++tiUe3OWuWIo9
         8LDhCyH2e7WQE5bMAz/yjmAq6a6mE+rhZ13BCmjS9k/N6DzpkiM+g51NLj6Ib8sdEeI9
         EAxPBIyBZ2AiHjy7rK+ffYVX8YYoXb760XtaJJISkcLCdQpwJMxUhYrpjktyL/wGU08/
         HZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141738; x=1749746538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PFO6uqE3omBPZMM2RRJAUzPXA8e6WjqOavvxq7pzHeU=;
        b=RGM3RDkkPXHpuaFD9OKOsTESqHRUKv2yqRJAVgTrPgEfOUfek6SJi7R1LpaEwDHjfQ
         tlxa05iuEc4msohIeP0/+qalaglbxOuJaUEsHlHLmpqPwc3WeP8Znk0FUNhY7ljfLsbe
         Lgupazc3Nvyz2q6FeLsT6lMcIle170rdsGjF4RHOOuG1hQEh5Z/PjxLMZOYKlxW8P3AA
         XqkvzyEjfUx2X/pRDO4JqDTfj9o+7ozTHBcDWrY6rLfGc2QZK/r94Ymvm4GSl/49Nt6i
         aPyBwOsEGZb5nuUsGVVLF2F7fYZKnpr9Iw7pzNXlrg58rnBTo4IRwpv5EKwH+AsZDFvI
         /E+A==
X-Forwarded-Encrypted: i=1; AJvYcCWtNBfJjcasOmmn4GtFhDqgF5h3LfdlFRQB/D4ZJVMKjCUq5AxyIoG2jDxENS60gu6qPgOETj7Py3zjgFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvPsRzeweOrhBq0xPB9F4OTDCN2iG8ilX67f0ULF+mfXku72as
	uoLUZ0+UTqHZDGkxQQCIw6/TV+hVnZe+vMlUKdDWwVwwphivoseQFKmly65KZrIRILY=
X-Gm-Gg: ASbGncuIgmtW5YYxdlFEn6kQgmPKO1tNQ75yw6k/M0x3vFUm1ofkGtPJxIIZ5mKu0Ho
	VjSWYz0J3FIRYA/LnWBLw71elW4ofUa63xDeZsles+PXXbJz1z0aJO76GRu7T3VWB5jFxUkNgtR
	1q2ePMiqZA6BamZlsDxXvGDSiF7V6TWEo4ZysteMIb8rvqbLqgIxFmwgKH8Jkiej4n/aFXrBOz4
	OwDVf0eSYzPbGYEza7eM7DBF9mFud1KJJOn88TmqwrmSutLx4QE0zRwGwQ9ewOmZgBvN0aeq+Cb
	k91026v2A2imu7uhPoicIcklmp99GeXeNDA84rvXuz3ArXOgw2MUeclZjCVsRNq8F6ov7P4o+tH
	tM/j+Un+BfN/sisQHys4=
X-Google-Smtp-Source: AGHT+IH8iucMLKyB72iZJRp6Ja13mId54J+CJ3jYG3RVj0yucpe7n56kB9LK1qIF4RKWk44WVICr0g==
X-Received: by 2002:a05:6512:3e21:b0:553:2e82:400d with SMTP id 2adb3069b0e04-55357bacabbmr1937536e87.25.1749141738230;
        Thu, 05 Jun 2025 09:42:18 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-241-79.bbcust.telenor.se. [92.32.241.79])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553378b2684sm2648588e87.106.2025.06.05.09.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 09:42:17 -0700 (PDT)
Message-ID: <5dfc623d-eca6-45f7-aacf-8f775d03267a@cryptogams.org>
Date: Thu, 5 Jun 2025 18:42:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: zhihang.shao.iscas@gmail.com, linux-crypto@vger.kernel.org
Cc: linux-riscv@lists.infradead.org, herbert@gondor.apana.org.au,
 paul.walmsley@sifive.com, ou@eecs.berkeley.edu, alex@ghiti.fr
References: <20250605145634.1075-1-zhihang.shao.iscas@gmail.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20250605145634.1075-1-zhihang.shao.iscas@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
> implementation for riscv authored by Andy Polyakov.
> The file 'poly1305-riscv.pl' is taken straight from this upstream
> GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
> and this commit fixed a bug in riscv 64bit implementation.

Just in case for reference, the commit fixed a bug in the 32-bit code 
path when it's compiled for 64-bit architecture. For better/adequate 
performance on a 64-bit system the 64-bit code path should be used. And 
it was fine all along. It even passed an algorithmic verification, in 
other words confidence level goes beyond the unit tests.

> Also, this patch passed extra run-time self tests.
> 
> [0] https://github.com/dot-asm/cryptogams
> 
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> ---
>   arch/riscv/crypto/Kconfig           |  10 +
>   arch/riscv/crypto/Makefile          |  17 +
>   arch/riscv/crypto/poly1305-glue.c   | 202 +++++++
>   arch/riscv/crypto/poly1305-riscv.pl | 797 ++++++++++++++++++++++++++++
>   drivers/net/Kconfig                 |   1 +
>   lib/crypto/Kconfig                  |   2 +-
>   6 files changed, 1028 insertions(+), 1 deletion(-)
>   create mode 100644 arch/riscv/crypto/poly1305-glue.c
>   create mode 100644 arch/riscv/crypto/poly1305-riscv.pl
> 
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index c67095a3d669..228bb3c6940d 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -38,6 +38,16 @@ config CRYPTO_GHASH_RISCV64
>   	  Architecture: riscv64 using:
>   	  - Zvkg vector crypto extension
>   
> +config CRYPTO_POLY1305_RISCV
> +	tristate "Hash functions: Poly1305"
> +	select CRYPTO_HASH
> +	select CRYPTO_ARCH_HAVE_LIB_POLY1305
> +	help
> +	  Poly1305 authenticator algorithm (RFC7539)
> +
> +	  Architecture: riscv using:
> +	  - V vector extension

Implementation in question doesn't use RISC-V vector extension, only 
Integer Multiplication extension.

> +static void riscv64_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
> +				 u32 len, u32 hibit)
> +{
> +	if (unlikely(!dctx->sset)) {
> +		if (!dctx->rset) {
> +			poly1305_init_riscv(&dctx->h, src);
> +			src += POLY1305_BLOCK_SIZE;
> +			len -= POLY1305_BLOCK_SIZE;
> +			dctx->rset = 1;
> +		}
> +		if (len >= POLY1305_BLOCK_SIZE) {
> +			dctx->s[0] = get_unaligned_le32(src +  0);
> +			dctx->s[1] = get_unaligned_le32(src +  4);
> +			dctx->s[2] = get_unaligned_le32(src +  8);
> +			dctx->s[3] = get_unaligned_le32(src + 12);
> +			src += POLY1305_BLOCK_SIZE;
> +			len -= POLY1305_BLOCK_SIZE;
> +			dctx->sset = true;
> +		}
> +		if (len < POLY1305_BLOCK_SIZE)
> +			return;
> +	}
> +
> +	len &= ~(POLY1305_BLOCK_SIZE - 1);
> +
> +	poly1305_blocks(&dctx->h, src, len, hibit);
> +}

This interface doesn't make sense. It looks like it's supposed to 
accommodate concatenated key, nonce and data input of arbitrary length. 
However the data length is truncated to the multiples of poly1305 
blocks, in which case |hibit| is supposed to be 1 unconditionally. Or in 
other words, considered in isolation this subroutine shouldn't have 
|hibit| as a parameter, but simply pass 1 as the last argument to 
poly1305_blocks.

On a general note. The poly1305 implementation in question supports both 
32- and 64-bit architectures, so maybe riscv_ prefixes would be more 
appropriate. As opposed to riscv64_ that is :-)

Cheers.

