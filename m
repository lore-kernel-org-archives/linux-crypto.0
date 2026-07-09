Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC625B084
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 13:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602372; cv=none; b=mR9rBB/Rft6x0AIw8kYcSP9TNOERn5+RNSpaCLTZy8KPmTS9m5jUN1RciCVGUYtADRH92G+ZaFqQujzhQoz6tSpO+OGuq/tkngy23aY3xNjAhcWlwca71PRx4gYKhUaaj4QV9/pKgfgie/waLbclvA1eY4vABbmczgo/ZVRm3XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602372; c=relaxed/simple;
	bh=LDysymO6z45BAwPxjT+9G6mfkoaNFOSQRLkjMgIQq8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XqLFQfsvEfgIR3ZLnki/cPP++1mtmfINYiNkDs9o60DJSArvtte4b0oa4D9Ie9nVa060GpyCzCaYPtcek6FeYi/AKsZEunQ2Dv6Bk+eImLA1ngD50K0MbkHiY3Qftg+2xBkGvldD+KmWA/BF/Nywa5yyN6uh+orp5UkG1KScVHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Py6d+vdr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WTWIHNL4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Py6d+vdr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WTWIHNL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783602369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/ctGAGPnVJhK8C2yhWjcdu/Dfmm55UMOGakv3PCDE+A=;
	b=Py6d+vdrtnz6Vx3DaCv9A4o87juxq8io4UN6GKPRWVC5WXjNel2E6FhMVhYBfBJp8jDfGF
	FU3roeEdVYOdPCQzA9fHtS6pbDDwDlqtpkanwoY4+pfZfO1WiqW31fBb7rqlL9JODzQQ7h
	mw3E/hQ1ulbhsIhJKfx0JoIMVNhcavI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-_qJ0ynUOOzatkqHBa1A39w-1; Thu, 09 Jul 2026 09:06:07 -0400
X-MC-Unique: _qJ0ynUOOzatkqHBa1A39w-1
X-Mimecast-MFC-AGG-ID: _qJ0ynUOOzatkqHBa1A39w_1783602367
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493e260e62bso12483375e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 06:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783602366; x=1784207166; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ctGAGPnVJhK8C2yhWjcdu/Dfmm55UMOGakv3PCDE+A=;
        b=WTWIHNL4xD4e03FCSa1X16Iv8BA+AOEqJS0NRdHEi+9awddX5cFceuM6crkhSgSUOa
         UP18g14jtTsx1/3Dtdzhsm2xyuNjtwVvFXRIUPf9lrwbzC7WluUrtoG0TgZWWNIFbfUU
         mrmSBxod6FR6nK8NQP63QD9V+az9RsXGburPnnOn2CYqXt4v1DmcJWfvp+2JR0VGyOs6
         +oOBl2IO8OvuVuApWm3xsmhfE0pz6QMaI9xn4pvqQy1meIJ8V/Y3/PTv/GNGnkyNNbiO
         VcflRSLzOIlGBaIZdv9y+pZ+MaDHPyY6RfOjnboivdqstBko/F/eHCxQoJJoCfY5AcJA
         kCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783602366; x=1784207166;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ctGAGPnVJhK8C2yhWjcdu/Dfmm55UMOGakv3PCDE+A=;
        b=OjrLVO2ahKmNF7TUVRqwnLd3zTccaTsczbaOp4Ohhpzx0U+SfgkjXIk8/O/4ISKJKP
         0Y0SgQh0hc0CfriT1gOV85SnoDWdkqv/gCgCOEPAXy7QH3uOB6LWUAr9SysTjFLzScxQ
         rbu0JN/T+qKCWceeMceMnEW3ZEB+dgUAEDxAXhCAWIvsrKVEstq3Dn3bLkvVSvql3H2E
         Pplw2/ze0LAtu2YC/d7LvE6bennig0b4FDuf5LZlURBCwaQd3Y/1MlbHg/A1pV0gg+oI
         8k956DcpfO1jFJdWvuKGhp/x3qyb7oFteukCrmBceyJSWIMGAyzhy/ithGgDteepNqTd
         T2Lw==
X-Forwarded-Encrypted: i=1; AHgh+Rq8syqiL+IBiJujSn1lqaiRyqgIwAhN7BAKoqby71Vdm3MhW9evsy427HaNryNDRYfnwhJDUmkx3aQUKHY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7sqMGKXJ1Jk4opUC5SygVWystgVzr3GOijbXqqd3U2Kkc1sD0
	4Jr5qiHS1q3RtPiCJja0MVONpyiGowHuySXUyXul6gEbmloNkINEQ5xXCtL+DeWOSmLiyDRJzPl
	joLtWUHKgrziES55SNFEL9tU/SE45ITOllktlh/uXsknpZ1Mb1o5zk+jt/qN7fKUvGA==
X-Gm-Gg: AfdE7ckkrOMcnaXA1YH/vX6Adb/ToNVd4fLqR9qgWz6Cnv2LqMHswQZVLSJ/167EJpD
	B3txtmIg3aLE6UtubDio7KfgaKmUmgrZOr9mdjb6u4zHHzuLkWOBjRhOfvFm2RWq31Ecg83RXCj
	AwgwJKUENejMeM5/q6I/+Y3rVlPWqG2GC+ZBMAWq5vTItrlMtQH1jkiyFy/VWwCX61lwOc5MJI/
	sy7FoQ4bPrwF0XIv1qvCCLdMYm6c0jP8hIu4+c/j5n5V3I5MlKhmaVQy1AS5aUt4wNVrcuMbEWG
	1W1qwMnUkFHrwinGqmgbpQOkCIaj0lklKlKgell9xlDOBgNEmnsLoPQtIX2uMuOswANXQHxjwKU
	eQaLXQkd6
X-Received: by 2002:a05:600c:3548:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-493e6874e06mr61958755e9.27.1783602366654;
        Thu, 09 Jul 2026 06:06:06 -0700 (PDT)
X-Received: by 2002:a05:600c:3548:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-493e6874e06mr61958365e9.27.1783602366177;
        Thu, 09 Jul 2026 06:06:06 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a61135sm88929005e9.1.2026.07.09.06.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 06:06:05 -0700 (PDT)
Message-ID: <2bbc6563-3328-4153-97fb-2d0a10ceefaf@redhat.com>
Date: Thu, 9 Jul 2026 15:06:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/33] lib/crypto: aes: Add CBC and CBC-CTS support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-4-ebiggers@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260707053503.209874-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 07.34, Eric Biggers wrote:
> Add support for AES-CBC and AES-CBC-CTS to the crypto library.
> 
> These will be used to provide streamlined implementations of the
> "cbc(aes)" and "cts(cbc(aes))" crypto_skcipher algorithms.  Most users
> of these crypto_skcipher algorithms will also be able to switch to the
> library, which as usual will be simpler and faster, e.g.:
> 
>      - block/blk-crypto-fallback.c (for AES-128-CBC-ESSIV)
>      - fs/crypto/crypto.c (for AES-128-CBC-ESSIV)
>      - fs/crypto/fname.c (for AES-256-CTS and AES-128-CBC)
>      - kernel/bpf/crypto.c
>      - net/ceph/crypto.c
>      - security/keys/encrypted-keys/encrypted.c
> 
> As usual, the architecture-optimized AES-CBC and AES-CBC-CTS code will
> be migrated into the library as well (using the hooks provided in this
> commit), eliminating lots of repetitive boilerplate code.
> 
> Initial test coverage is provided by the crypto_skcipher support added
> in a later commit.  I'm planning a KUnit test suite as well.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-unauth-encryption.rst    |   7 +
>   include/crypto/aes-cbc.h                      |  77 ++++++++
>   lib/crypto/Kconfig                            |   6 +
>   lib/crypto/aes.c                              | 174 ++++++++++++++++++
>   lib/crypto/tests/Kconfig                      |   1 +
>   5 files changed, 265 insertions(+)
>   create mode 100644 include/crypto/aes-cbc.h
...
> +void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
> +			 u8 iv[AES_BLOCK_SIZE], const struct aes_key *key)
> +{
> +	/* Offset to P[n] and C[n] (last plaintext and ciphertext block) */
> +	size_t pn_offset = round_down(len - 1, AES_BLOCK_SIZE);
> +	/* Length of P[n] and C[n], 1 <= pn_len <= AES_BLOCK_SIZE */
> +	size_t pn_len = len - pn_offset;
> +	u8 *pad;
> +
> +	if (WARN_ON_ONCE(len < AES_BLOCK_SIZE))
> +		return;
> +
> +	if (len == AES_BLOCK_SIZE) {
> +		aes_cbc_decrypt(dst, src, len, iv, key);
> +		return;
> +	}
> +	if (likely(aes_cbc_cts_decrypt_arch(dst, src, len, iv, key)))
> +		return;
> +
> +	/* Compute P[0]..P[n - 2]. */
> +	aes_cbc_decrypt(dst, src, pn_offset - AES_BLOCK_SIZE, iv, key);
> +
> +	/* Compute P[n] and P[n - 1], considering that src may equal dst. */
> +	pad = &dst[pn_offset - AES_BLOCK_SIZE];
> +	aes_decrypt(key, pad, &src[pn_offset - AES_BLOCK_SIZE]);
> +	crypto_xor_cpy(&dst[pn_offset], &src[pn_offset], pad,
> +		       pn_len); /* P[n] */
> +	crypto_xor(pad, &dst[pn_offset], pn_len);

Took me a while to understand why you'd use the above xor instead of a 
memcpy(pad, &src[pn_offset], pn_len) here, but that's because src and dst 
might point to the same buffer, right?

Anyway, patch looks good to me, so:

Reviewed-by: Thomas Huth <thuth@redhat.com>


> +	aes_decrypt(key, pad, pad);
> +	crypto_xor(pad, iv, AES_BLOCK_SIZE); /* P[n - 1] */
> +}
> +EXPORT_SYMBOL_GPL(aes_cbc_cts_decrypt);
> +#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
> +

