Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839013B637A
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 08:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932004; cv=none; b=hG/3KOCiNx2cprI64NN3kMl/a63Kw4chfK8R0tp9Cpyy/90cA7ZUJRsewzMklqOHU3t+8jnlOvCmrKNQvI8khiwTdv1J/iR/oaQa4+qwPUW+Rul5LW0k5eOaBufICUQnhZZ3yv3qCL7wNOv0y0Iwr2mz5SHbh47+nDMaqOBflRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932004; c=relaxed/simple;
	bh=+Mtn3X0BHI6s8bs8ek6FaCiutueHC06mLtlMxdFtuhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EesU51IBz/QxJaeJeUAT3mat94ZbD06m7j5xN1E614jQOZ+eost/gu2H9oaUUoBtxUbEYOdbS3dKAwWxRKGVCMGKj1s2GVHXdQSKPSjsvbGC/iHqBt8UfGUh4uAJSrIKcTVgVcbgrVRSDzMtjnDKrro3eZV/SuakRHr09vTici4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FmintECx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SR+LaoWb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FmintECx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SR+LaoWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783931999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TK7R3ngWTxCx7Mzn1bDl7P4Mutu3LWaKMkHVF3wBuj4=;
	b=FmintECx0gOGKJN0FSOttU7uQGEzfEz99oMJIcf21ROdYCFuP/q/5jpSS5q+JcfPuDyOUh
	zOqwVMddAqmk140Fjh1EK1BJ1yfMEFhXwn2vrvgp2ltrvfSxjRGb65wn4dyMS7XRyHbOuL
	LNNM6s/f+CzCilWIe3SfrJmnEedFxWg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-GCLiyZITP9GgWyRY6JvL2g-1; Mon, 13 Jul 2026 04:39:57 -0400
X-MC-Unique: GCLiyZITP9GgWyRY6JvL2g-1
X-Mimecast-MFC-AGG-ID: GCLiyZITP9GgWyRY6JvL2g_1783931996
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4731a357b0aso2945191f8f.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783931996; x=1784536796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TK7R3ngWTxCx7Mzn1bDl7P4Mutu3LWaKMkHVF3wBuj4=;
        b=SR+LaoWb6/t25XXQL8Ar5CSZQJB3Z09UNGdwa8qVDsNX8UFWbbr2RzBPVQiFvUfNyr
         zXUBlCmY4Uie5BmN9ntaSQncx17rM/Ih+yRlIaamXW7aTfWCQlGBVmFxUm/Heu0/N+6x
         VVQaqYgH3zXhczvnojDgr+Zihkgudg2jMJU7LSEuRSdcnKeE6wunTZoP43f44/Z8JKQv
         izMlfbigGnlqx2rMfG/h1s7vrWUAqjv9l9U1JxFysANlEbT7CBEadQHMhcYLt0kfqwD5
         omMxzWzGkp0aZS8huu4+y9qbZyzT5WfaL1pJAOMtB3DtxVtfgWj03nhwKb50I3bc9HKs
         4EzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783931996; x=1784536796;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TK7R3ngWTxCx7Mzn1bDl7P4Mutu3LWaKMkHVF3wBuj4=;
        b=JWnjd5/Nteq4LVW22BD5Hi/Ok0nTORE9KhYM3bA9jFh2Q+AseWMSJaxCkjhwgkczuw
         6m/KCog7RNu6pOrcU7+K1UzE4cVmVI+eOlYJqABoMT+Fo6qIw83diCHOitkk6ISxwEjr
         VUQj5f0BS1aLegF1f9/oDf/9WgpY+//AQ2U16X/B8m8XFgZU5ZMhTqxqoDEK6qrcJC5q
         UpC8E/uBgCb6xlhx/pP7c+tff5FjHLdybRr7fhHTEVBqFH5HyOOiWqmEonzXMKJtvLih
         gdIcUAIiEQqoE4CDv2RyxLkfoauXJEY53le4mo+ChPxRONpzju9sDQ8qNTrpCwe16qmp
         DMzg==
X-Forwarded-Encrypted: i=1; AHgh+RpEs2Bl9KYNqRImxYgU+w0dLnm8MGcTh9nLIv1saVAY0Pd5k79Ngg8V3Lo/nnfjDuA8v/dmlk57meOCUNs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu3ZbhIhyiPPh7V7R33zobLtQSMzqndx1CgNn8c3NE1xEOepnW
	mCgxXkeN9jMVKzZYp6h/rCh2/uaKqS5mQXYRjdNAozZdgMN5DQpdJDyVP+dI+tSfT7eNi5qsDwW
	zEUiwnGtLIGwECJ1XTf/Oz62n6IvfZZ4KnQuR5IFvu/ZgZKYT4OTr8ivjX2LYsS0S48GP1cm9wg
	==
X-Gm-Gg: AfdE7cmH7hPKE6F7TSCZircE5+bN7q8vPrN17g+Nm50rTZ0j3bwOJt2WisbvwK91Rm8
	eTp1lRbttt9nmn1mMKs/HnmPeWvvT8mt+JPXuxBNh8RfwMrFvuhVQ0OgszVAldeUGz0HB1zSV8G
	9FqmM6Dc9Xb6EpLSh25CJ26fCBk/p2/xA2+0LGRlm+SO6isQGVwn6/v20oPg+Sv1nqhtY3s/odp
	iSSbphBFvB/piSKOTBoY5Orn3UEYIPRrib1VTvkq3JZVivsSu35XncBL8cVpEBMOnfiCYtJHS50
	hpD0PfFVk+Mo5NaY3IyNZYfqiKq+WvaQV+ePnHIRF0UOGYZp7myTIvSVX7V8gfw8PUE+f+4+YI1
	hWAdber+8
X-Received: by 2002:a5d:5887:0:b0:47f:28e3:3f7e with SMTP id ffacd0b85a97d-47f2dd1f389mr8491831f8f.34.1783931996142;
        Mon, 13 Jul 2026 01:39:56 -0700 (PDT)
X-Received: by 2002:a5d:5887:0:b0:47f:28e3:3f7e with SMTP id ffacd0b85a97d-47f2dd1f389mr8491797f8f.34.1783931995618;
        Mon, 13 Jul 2026 01:39:55 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9b4d850dsm83995367f8f.0.2026.07.13.01.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 01:39:55 -0700 (PDT)
Message-ID: <40932e40-a909-4b95-b739-c4727c1cc153@redhat.com>
Date: Mon, 13 Jul 2026 10:39:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/33] lib/crypto: aes: Add CTR and XCTR support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-5-ebiggers@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260707053503.209874-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 07.34, Eric Biggers wrote:
> Add support for AES-CTR and AES-XCTR to the crypto library.
> 
> These will be used to provide streamlined implementations of the
> "ctr(aes)" and "xctr(aes)" crypto_skcipher algorithms.  Most users of
> "ctr(aes)" will also be able to switch to the library, which as usual
> will be simpler and faster, e.g.:
> 
>    - net/mac80211/fils_aead.c
>    - net/mac802154/llsec.c
> 
> As usual, the architecture-optimized AES-CTR and AES-XCTR code will be
> migrated into the library as well (using the hooks provided in this
> commit), eliminating lots of repetitive boilerplate code.
> 
> This is also a prerequisite for supporting AES-GCM, AES-CCM, and
> AES-HCTR2 in the crypto library.
> 
> Initial test coverage is provided by the crypto_skcipher support added
> in a later commit.  I'm planning a KUnit test suite as well.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-unauth-encryption.rst    |  7 ++
>   include/crypto/aes-ctr.h                      | 56 +++++++++++
>   lib/crypto/Kconfig                            |  6 ++
>   lib/crypto/aes.c                              | 93 +++++++++++++++++++
>   lib/crypto/tests/Kconfig                      |  1 +
>   5 files changed, 163 insertions(+)
>   create mode 100644 include/crypto/aes-ctr.h
> 
> diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
> index fb8106034089..6aca01d715da 100644
> --- a/Documentation/crypto/libcrypto-unauth-encryption.rst
> +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
> @@ -27,6 +27,13 @@ Support for AES in the CBC and CBC-CTS modes of operation.
>   
>   .. kernel-doc:: include/crypto/aes-cbc.h
>   
> +AES-CTR and AES-XCTR
> +--------------------
> +
> +Support for AES in the CTR and XCTR modes of operation.

I guess you already have this on your radar, but just in case: It would be 
nice to turn this into a full sentence, too.

> +.. kernel-doc:: include/crypto/aes-ctr.h
> +
>   AES-ECB
>   -------
>   
> diff --git a/include/crypto/aes-ctr.h b/include/crypto/aes-ctr.h
> new file mode 100644
> index 000000000000..fa2b7d303e55
> --- /dev/null
> +++ b/include/crypto/aes-ctr.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AES-CTR and AES-XCTR stream ciphers
> + *
> + * Copyright 2026 Google LLC
> + */
> +#ifndef _CRYPTO_AES_CTR_H
> +#define _CRYPTO_AES_CTR_H
> +
> +#include <crypto/aes.h>
> +
> +/**
> + * aes_ctr() - AES-CTR en/decryption
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to en/decrypt
> + * @ctr: The counter.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
> + * @key: The key
> + *
> + * This implements AES in counter mode with a 128-bit big endian counter.
> + *
> + * This supports incremental en/decryption.  The length of each non-final chunk
> + * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
> + * each time.

Maybe add some wording that ctr ideally should not be 0 for the first call, 
i.e. a "nonce" value?

> + * Context: Any context.
> + */
> +void aes_ctr(u8 *dst, const u8 *src, size_t len,
> +	     u8 ctr[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
> +
> +/**
> + * aes_xctr() - AES-XCTR en/decryption
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to en/decrypt
> + * @ctr: The block counter.  For the first call, set it to 1.  It will be
> + *	 incremented by ceil(@len / AES_BLOCK_SIZE).
> + * @iv: The initialization vector
> + * @key: The key
> + *
> + * This implements AES in XOR Counter mode, as specified in the paper
> + * "Length-preserving encryption with HCTR2"
> + * (https://eprint.iacr.org/2021/1441.pdf).
> + *
> + * This supports incremental en/decryption.  The length of each non-final chunk
> + * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
> + * each time.
> + *
> + * Context: Any context.
> + */
> +void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
> +	      const u8 iv[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
> +
> +#endif /* _CRYPTO_AES_CTR_H */
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index c64cc3e12b57..96febc3df6d6 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -47,6 +47,12 @@ config CRYPTO_LIB_AES_ECB
>   	help
>   	  The AES-ECB library functions.
>   
> +config CRYPTO_LIB_AES_CTR
> +	tristate
> +	select CRYPTO_LIB_AES
> +	help
> +	  The AES-CTR and AES-XCTR library functions.
> +
>   config CRYPTO_LIB_AESGCM
>   	tristate
>   	select CRYPTO_LIB_AES
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index 3635fbe946f3..9da274a72221 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -6,6 +6,7 @@
>   
>   #include <crypto/aes-cbc-macs.h>
>   #include <crypto/aes-cbc.h>
> +#include <crypto/aes-ctr.h>
>   #include <crypto/aes-ecb.h>
>   #include <crypto/aes.h>
>   #include <crypto/utils.h>
> @@ -967,6 +968,98 @@ void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
>   EXPORT_SYMBOL_GPL(aes_cbc_cts_decrypt);
>   #endif /* CONFIG_CRYPTO_LIB_AES_CBC */
>   
> +#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
> +/*
> + * Hooks for optimized AES-CTR and AES-XCTR implementations, overridable by the
> + * architecture.  They are called with any len >= 0.  Returning false causes the
> + * fallback implementation to be used instead.
> + */
> +#ifndef aes_ctr_arch
> +static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
> +			 u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
> +{
> +	return false;
> +}
> +#endif
> +#ifndef aes_xctr_arch
> +static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 *ctr,
> +			  const u8 iv[AES_BLOCK_SIZE],
> +			  const struct aes_enckey *key)
> +{
> +	return false;
> +}
> +#endif
> +
> +static __always_inline void inc_be128_ctr(u8 ctr[AES_BLOCK_SIZE])
> +{
> +	/* Casts to u8 are needed because of the implicit integer promotion. */
> +	if (((u8)++ctr[AES_BLOCK_SIZE - 1]) != 0)
> +		return;

Why do you handle the first value separately here? The code could be 
simplified to start with "int i = AES_BLOCK_SIZE -1" in the for-loop instead?

> +	for (int i = AES_BLOCK_SIZE - 2; i >= 0; i--) {
> +		if ((u8)++ctr[i] != 0)
> +			break;
> +	}
> +}
> +
> +void aes_ctr(u8 *dst, const u8 *src, size_t len, u8 ctr[AES_BLOCK_SIZE],
> +	     aes_encrypt_arg key)
> +{
> +	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
> +
> +	if (likely(aes_ctr_arch(dst, src, len, ctr, key.enc_key)))
> +		return;
> +
> +	/* Handle the full blocks. */
> +	for (; len >= AES_BLOCK_SIZE; len -= AES_BLOCK_SIZE) {
> +		aes_encrypt(key, keystream, ctr);
> +		crypto_xor_cpy(dst, src, keystream, AES_BLOCK_SIZE);
> +		inc_be128_ctr(ctr);
> +		dst += AES_BLOCK_SIZE;
> +		src += AES_BLOCK_SIZE;
> +	}
> +	/* Handle any partial block at the end. */
> +	if (len) {
> +		aes_encrypt(key, keystream, ctr);
> +		crypto_xor_cpy(dst, src, keystream, len);
> +		/* Counter is incremented even with just a partial block. */
> +		inc_be128_ctr(ctr);
> +	}
> +	memzero_explicit(keystream, sizeof(keystream));
> +}
> +EXPORT_SYMBOL_GPL(aes_ctr);
> +
> +void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
> +	      const u8 iv[AES_BLOCK_SIZE], aes_encrypt_arg key)
> +{
> +	const __le64 iv0 = get_unaligned((const __le64 *)&iv[0]);
> +	__le64 aes_input[2];
> +	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
> +
> +	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
> +		return;
> +
> +	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
> +	/* Handle the full blocks. */
> +	for (; len >= AES_BLOCK_SIZE; len -= AES_BLOCK_SIZE) {
> +		aes_input[0] = iv0 ^ cpu_to_le64((*ctr)++);

Do we want to have a BUG_ON or WARN_ON_ONCE somewhere to check that ctr does 
not wrap around (i.e. to make sure that ctr was really 1 for the first 
call)? Something like:

	WARN_ON_ONCE((s64)(cpu_to_le64(*ctr) + len / AES_BLOCK_SIZE) < 0)

at the beginning of the function?

> +		aes_encrypt(key, keystream, (const u8 *)aes_input);
> +		crypto_xor_cpy(dst, src, keystream, AES_BLOCK_SIZE);
> +		dst += AES_BLOCK_SIZE;
> +		src += AES_BLOCK_SIZE;
> +	}
> +	/* Handle any partial block at the end. */
> +	if (len) {
> +		/* Counter is incremented even with just a partial block. */
> +		aes_input[0] = iv0 ^ cpu_to_le64((*ctr)++);
> +		aes_encrypt(key, keystream, (const u8 *)aes_input);
> +		crypto_xor_cpy(dst, src, keystream, len);
> +	}
> +	memzero_explicit(keystream, sizeof(keystream));
> +	memzero_explicit(aes_input, sizeof(aes_input));
> +}
> +EXPORT_SYMBOL_GPL(aes_xctr);
> +#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
> +
>   static int __init aes_mod_init(void)
>   {
>   #ifdef aes_mod_init_arch
> diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
> index e78086f3c954..9284d0134d77 100644
> --- a/lib/crypto/tests/Kconfig
> +++ b/lib/crypto/tests/Kconfig
> @@ -146,6 +146,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
>   	depends on KUNIT
>   	select CRYPTO_LIB_AES_CBC
>   	select CRYPTO_LIB_AES_CBC_MACS
> +	select CRYPTO_LIB_AES_CTR
>   	select CRYPTO_LIB_AES_ECB
>   	select CRYPTO_LIB_BLAKE2B
>   	select CRYPTO_LIB_CHACHA20POLY1305

  Thomas

