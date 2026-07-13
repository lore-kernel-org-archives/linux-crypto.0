Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7FE409635
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783944919; cv=none; b=YpvyR4oiAHTgycaFP9HPGSHkJZnq7BNVZsu6KA5POhSYQTgcleQEZ3G7LzGCGzLnATYFD6CrrRf6NQ9s3IMJPDSAPB5n293OkmXelVyFTToM4pN8/qhi0K0XuHUR1CKoCMmbPTvH4GEjLpPQBBXc4HeJQs231uvZ4c4ugFE6xZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783944919; c=relaxed/simple;
	bh=iaJDELJuKbYVUblVt3MJKnCzvWU1tiAjBf8WfhprKSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1mc41PpUS+4LZa5tL2pdH7zr0V/B8aTk4Di7vvdLORBFx4Z5ulu5zU5Tirlj9/FvqMbBmkyVL4Yw48egOb/NJwAlX7NKUSGaUnz0dqFGFRO4JGUbPg82Ch7CPh2GCA07fYNJFcGXGNCej30wmhzDgjBcVUtRGyh4t1+oSgCKws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ID01Gw9I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PiXt3+pw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ID01Gw9I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PiXt3+pw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783944912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xuNv5PJndaoLFBj/URqzUONgy/T8cOH0xmGpB39u3Oo=;
	b=ID01Gw9IXwlcZgdkkiNKXBiQ7AAYz5zifyJNGPGarxAaUVxXpONT1sMaafvNkmPnzMm25j
	e/jg6DJq+omz7+OuybJXM4SZe1bCyOraTh3medEkPU18RUA/cBwwHqIdwGM69qg6tIeLuR
	ZZCyBRnc8R7OWzY1NHYkv8lqBry5CyU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-cDZFSudcPueht6Oa8WUhaA-1; Mon, 13 Jul 2026 08:15:09 -0400
X-MC-Unique: cDZFSudcPueht6Oa8WUhaA-1
X-Mimecast-MFC-AGG-ID: cDZFSudcPueht6Oa8WUhaA_1783944908
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-475e540a0ffso1749882f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 05:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783944908; x=1784549708; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xuNv5PJndaoLFBj/URqzUONgy/T8cOH0xmGpB39u3Oo=;
        b=PiXt3+pwCf85vxMwlR5VKcL4eaSkTGfvrrNkXNUE46QLuKdo8aDp1tnP9dZKIm5Gw5
         D5KTenrtPG6HaR6s0b15lxXzv9oP4g97ON8RErGiSWeXOYVmCNoGCduiqbs+YhqKrzYX
         EPyZmn38Po6ng44k4Jj28YUV/zrJG7kYPDhIwFWokGf0tH+yDOvj/gB0FwHm9uDPLmgD
         TJATAUli+KDRfcrDCxb6H4jRAmbYATqFWSeWxcn8acLzHyLWytzJTSCQfKt3igMju52T
         /3Y4qOhHbKP8Y9ZXwDf1ze1mqqYDu7Tz2WwwwCroHA/VRUl7lsBXtKxr5FP+xHwp6CJJ
         PtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783944908; x=1784549708;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xuNv5PJndaoLFBj/URqzUONgy/T8cOH0xmGpB39u3Oo=;
        b=OZGABkJ7YEtIJkL07EMNfFxSgfho4QQCi4R+1in80tNbaGKmECgcSOLNutv7JZ5Xk1
         l3xIY5gUjdRBCro4i0jGCX/VeIxeSw9oCh8HZxVzdjE594vjC0JroXrDqihJPltLIblR
         U+/aPoA6hJ8NV6bDhnDoWmdlv9WLPim5StEtbiZ0QRNrSzpEq5Wqmva9y4LMVaVvmZau
         bGRSOaqUqc1l5m1ieoSjNGNIiKy1W62+r4mbGIwa9WxgyiA/BN49M1Kz3SJV6xCK8hZo
         1iDcnzRLhOWpy5E91eKMHSeZ3fVN4tIG/N3KVSS5NPj5oxb/Y6CDg8eKUV+Ov7dn13RT
         qyzA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4KbHf0n4tkJ5QRFNF96fy7yEF+Abx6Uve8tS1H18lTOQmNmNestnrIsyP42Fs//nbcxtbu6IDi+lfXlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqaBg5i0Vj5QmKZzAKUV8N9vo1IrjYiWHRBkXFpVWqiu2bjege
	WoE008Mf0VtRa0ZT4rqNdj0eA8mCilNSKz+pL1PE5ASDlrBmDaMD+tL3FSlykZyG2T+RyWaC93c
	2F8j7kbv6axzX+j1jUBInepIpCYFSv+q9/Kga9UM2gOfyrX8Tfhv+k1aa68tzlAkesg==
X-Gm-Gg: AfdE7cm0MITwrQuMOiOQ7fBMTofyHD65JiHnHGjWPs1drYrZCXqx6a3wl0Tqg9+Ccay
	2x1rovAMEhbm1riwsF14cEAV017ML7ZmKJsTAaCEcJrzm9vvXgZTAHoolC/j0RR5hX+I6KIc+Zq
	7sbMUd4WwVbXcme9Iop3nLNkQkEHfYb6WTEwzxaAaNN0NPbMVyola8NAa5d56tZJZwBnZGReMl+
	/Y0GM0JMgx1eAl+Fj3MEsYelCd2Je2lGtN4013h7OpslrBd4rDXZs8PqoKpjFlQm5nS5isBFD0b
	H+jljFmi+BcNPSZOleobAJBsdEu/LVJaX0o1zrdZtqmip6l/gVj6j+4Rv7RsJgTbpu+s3YlZG7V
	YUi9ZSYxh
X-Received: by 2002:a05:6000:4704:b0:476:cb01:6387 with SMTP id ffacd0b85a97d-47f2dc88652mr10108518f8f.17.1783944907794;
        Mon, 13 Jul 2026 05:15:07 -0700 (PDT)
X-Received: by 2002:a05:6000:4704:b0:476:cb01:6387 with SMTP id ffacd0b85a97d-47f2dc88652mr10108477f8f.17.1783944907326;
        Mon, 13 Jul 2026 05:15:07 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8cdsm87947898f8f.1.2026.07.13.05.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 05:15:06 -0700 (PDT)
Message-ID: <6c6d258e-d510-4e44-bd07-7ea91b9369a6@redhat.com>
Date: Mon, 13 Jul 2026 14:15:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/33] lib/crypto: aes: Add XTS support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-6-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260707053503.209874-6-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 07.34, Eric Biggers wrote:
> Add support for AES-XTS to the crypto library.
> 
> This will be used to provide a streamlined implementation of the
> "xts(aes)" crypto_skcipher algorithm.  I'm also planning to use this
> directly in fscrypt and blk-crypto-fallback.
> 
> As usual, the architecture-optimized AES-XTS code will be migrated into
> the library as well (using the hooks provided in this commit),
> eliminating lots of repetitive boilerplate code.  Compared to direct
> implementation of "xts(aes)", I've also eliminated the requirement for
> architectures to implement ciphertext stealing, as the library just
> handles it portably instead.  That will simplify things considerably.
> 
> Initial test coverage is provided by the crypto_skcipher support added
> in a later commit.  I'm planning a KUnit test suite as well.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-unauth-encryption.rst    |   7 +
>   include/crypto/aes-xts.h                      |  87 +++++++
>   lib/crypto/Kconfig                            |   6 +
>   lib/crypto/aes.c                              | 224 ++++++++++++++++++
>   lib/crypto/tests/Kconfig                      |   1 +
>   5 files changed, 325 insertions(+)
>   create mode 100644 include/crypto/aes-xts.h
> 
> diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
> index 6aca01d715da..15deba7e53e8 100644
> --- a/Documentation/crypto/libcrypto-unauth-encryption.rst
> +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
> @@ -40,3 +40,10 @@ AES-ECB
>   Support for AES in the ECB mode of operation.
>   
>   .. kernel-doc:: include/crypto/aes-ecb.h
> +
> +AES-XTS
> +-------
> +
> +Support for AES in the XTS mode of operation.
> +
> +.. kernel-doc:: include/crypto/aes-xts.h
> diff --git a/include/crypto/aes-xts.h b/include/crypto/aes-xts.h
> new file mode 100644
> index 000000000000..226ac38d54ac
> --- /dev/null
> +++ b/include/crypto/aes-xts.h
> @@ -0,0 +1,87 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AES-XTS unauthenticated encryption and decryption
> + *
> + * Copyright 2026 Google LLC
> + */
> +#ifndef _CRYPTO_AES_XTS_H
> +#define _CRYPTO_AES_XTS_H
> +
> +#include <crypto/aes.h>
> +#include <crypto/xts.h>
> +
> +/**
> + * struct aes_xts_key - A key prepared for AES-XTS encryption and decryption
> + *
> + * Note that (depending on the architecture) this typically is around 768 bytes,
> + * which makes it a bit too large to allocate on the stack in most cases.
> + */
> +struct aes_xts_key {
> +	/* private: */
> +	struct aes_key main_key;
> +	struct aes_enckey tweak_key;
> +};
> +
> +/**
> + * aes_xts_preparekey() - Prepare an AES-XTS key
> + * @key: (output) The key structure to initialize
> + * @in_key: The raw AES-XTS key
> + * @key_len: Length of the raw key in bytes
> + * @flags: Optional flag XTS_FORBID_WEAK_KEYS to forbid keys whose two halves
> + *	   are the same.
> + *
> + * Context: Any context.
> + * Return:
> + * * 0 on success
> + * * -EINVAL if the key is rejected because its length isn't 32, 64, or (when
> + *   FIPS mode isn't enabled) 48; or because its two halves are the same and
> + *   either XTS_FORBID_WEAK_KEYS is given or FIPS mode is enabled.
> + */
> +int __must_check aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
> +				    size_t key_len, int flags);
> +
> +/**
> + * aes_xts_encrypt() - Encrypt data using AES-XTS
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to encrypt.  Must be >= AES_BLOCK_SIZE.  On non-last
> + *	 calls it also must be a multiple of AES_BLOCK_SIZE.
> + * @tweak: The tweak.  It is updated with the next value, unless @len isn't a
> + *	   multiple of AES_BLOCK_SIZE in which case the value is unspecified.
> + * @key: The key
> + * @cont: %true to continue same message (skip tweak encryption)
> + *
> + * This supports both one-shot and incremental encryption.  For incremental
> + * encryption, all non-last calls require @len aligned to AES_BLOCK_SIZE, and
> + * all non-first calls require @cont = %true.
> + *
> + * Context: Any context.
> + */
> +void aes_xts_encrypt(u8 *dst, const u8 *src, size_t len,
> +		     u8 tweak[at_least AES_BLOCK_SIZE],
> +		     const struct aes_xts_key *key, bool cont);
> +
> +/**
> + * aes_xts_decrypt() - Decrypt data using AES-XTS
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to decrypt.  Must be >= AES_BLOCK_SIZE.  On non-last
> + *	 calls it also must be a multiple of AES_BLOCK_SIZE.
> + * @tweak: The tweak.  It is updated with the next value, unless @len isn't a
> + *	   multiple of AES_BLOCK_SIZE in which case the value is unspecified.
> + * @key: The key
> + * @cont: %true to continue same message (skip tweak encryption)
> + *
> + * This supports both one-shot and incremental decryption.  For incremental
> + * decryption, all non-last calls require @len aligned to AES_BLOCK_SIZE, and
> + * all non-first calls require @cont = %true.
> + *
> + * Context: Any context.
> + */
> +void aes_xts_decrypt(u8 *dst, const u8 *src, size_t len,
> +		     u8 tweak[at_least AES_BLOCK_SIZE],
> +		     const struct aes_xts_key *key, bool cont);
> +
> +#endif /* _CRYPTO_AES_XTS_H */
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index 96febc3df6d6..9af44cf743a7 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -53,6 +53,12 @@ config CRYPTO_LIB_AES_CTR
>   	help
>   	  The AES-CTR and AES-XCTR library functions.
>   
> +config CRYPTO_LIB_AES_XTS
> +	tristate
> +	select CRYPTO_LIB_AES
> +	help
> +	  The AES-XTS library functions.
> +
>   config CRYPTO_LIB_AESGCM
>   	tristate
>   	select CRYPTO_LIB_AES
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index 9da274a72221..630702a4228c 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -8,7 +8,9 @@
>   #include <crypto/aes-cbc.h>
>   #include <crypto/aes-ctr.h>
>   #include <crypto/aes-ecb.h>
> +#include <crypto/aes-xts.h>
>   #include <crypto/aes.h>
> +#include <crypto/gf128mul.h>
>   #include <crypto/utils.h>
>   #include <linux/cache.h>
>   #include <linux/crypto.h>
> @@ -1060,6 +1062,228 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
>   EXPORT_SYMBOL_GPL(aes_xctr);
>   #endif /* CONFIG_CRYPTO_LIB_AES_CTR */
>   
> +#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
> +int aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
> +		       size_t key_len, int flags)
> +{
> +	int err;
> +
> +	err = __xts_verify_key(in_key, key_len, flags);
> +	if (err)
> +		return err;
> +	/* First half of XTS key is the main key */
> +	err = aes_preparekey(&key->main_key, in_key, key_len / 2);
> +	if (err)
> +		return err;
> +	/* Second half of XTS key is the tweak key */
> +	return aes_prepareenckey(&key->tweak_key, &in_key[key_len / 2],
> +				 key_len / 2);
> +}
> +EXPORT_SYMBOL_GPL(aes_xts_preparekey);
> +
> +/*
> + * Hooks for optimized AES-XTS implementations, overridable by the architecture.
> + * They are called with len > 0 && len % AES_BLOCK_SIZE == 0.  In other words,
> + * they aren't expected to handle ciphertext stealing or empty inputs.
> + * Returning false causes the fallback implementation to be used instead.
> + *
> + * (Currently, all users of AES-XTS in the kernel seem to en/decrypt whole
> + * numbers of blocks anyway, with len >= 512.  So there's no need to heavily
> + * optimize ciphertext stealing for short messages.)
> + */
> +#ifndef aes_xts_encrypt_arch
> +static bool aes_xts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
> +				 u8 tweak[AES_BLOCK_SIZE],
> +				 const struct aes_xts_key *key, bool cont)
> +{
> +	return false;
> +}
> +#endif
> +#ifndef aes_xts_decrypt_arch
> +static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
> +				 u8 tweak[AES_BLOCK_SIZE],
> +				 const struct aes_xts_key *key, bool cont)
> +{
> +	return false;
> +}
> +#endif
> +
> +static noinline void aes_xts_crypt_nocts_blockbyblock(
> +	u8 *dst, const u8 *src, size_t len, u8 tweak[AES_BLOCK_SIZE],
> +	const struct aes_xts_key *key, bool cont, bool enc)
> +{
> +	le128 t;
> +
> +	if (cont)
> +		memcpy(&t, tweak, sizeof(t));
> +	else
> +		aes_encrypt(&key->tweak_key, (u8 *)&t, tweak);
> +	do {
> +		crypto_xor_cpy(dst, src, (const u8 *)&t, AES_BLOCK_SIZE);
> +		if (enc)
> +			aes_encrypt(&key->main_key, dst, dst);
> +		else
> +			aes_decrypt(&key->main_key, dst, dst);
> +		crypto_xor(dst, (const u8 *)&t, AES_BLOCK_SIZE);
> +		gf128mul_x_ble(&t, &t);
> +		dst += AES_BLOCK_SIZE;
> +		src += AES_BLOCK_SIZE;
> +		len -= AES_BLOCK_SIZE;
> +	} while (len);
> +	memcpy(tweak, &t, sizeof(t));
> +	memzero_explicit(&t, sizeof(t));
> +}
> +
> +/* Requires len > 0 && len % AES_BLOCK_SIZE == 0 */
> +static __always_inline void aes_xts_encrypt_nocts(u8 *dst, const u8 *src,
> +						  size_t len,
> +						  u8 tweak[AES_BLOCK_SIZE],
> +						  const struct aes_xts_key *key,
> +						  bool cont)
> +{
> +	if (likely(aes_xts_encrypt_arch(dst, src, len, tweak, key, cont)))
> +		return;
> +
> +	/*
> +	 * For the fallback, just go block-by-block.  It could be implemented on
> +	 * top of AES-ECB, which could be significantly faster than this if the
> +	 * arch has optimized AES-ECB code but not AES-XTS.  However, AES-XTS
> +	 * performance is important enough that it needs to be (and has been)
> +	 * implemented directly by every non-obsolete arch anyway.
> +	 */
> +	aes_xts_crypt_nocts_blockbyblock(dst, src, len, tweak, key, cont,
> +					 /* enc= */ true);
> +}
> +
> +/* Requires len > 0 && len % AES_BLOCK_SIZE == 0 */
> +static __always_inline void aes_xts_decrypt_nocts(u8 *dst, const u8 *src,
> +						  size_t len,
> +						  u8 tweak[AES_BLOCK_SIZE],
> +						  const struct aes_xts_key *key,
> +						  bool cont)
> +{
> +	if (likely(aes_xts_decrypt_arch(dst, src, len, tweak, key, cont)))
> +		return;
> +
> +	/* Just go block-by-block.  See comment in aes_xts_encrypt_nocts(). */
> +	aes_xts_crypt_nocts_blockbyblock(dst, src, len, tweak, key, cont,
> +					 /* enc= */ false);
> +}
> +
> +static noinline void aes_xts_encrypt_cts(u8 *dst, const u8 *src, size_t len,
> +					 u8 tweak[AES_BLOCK_SIZE],
> +					 const struct aes_xts_key *key,
> +					 bool cont)
> +{
> +	size_t partial_len = len % AES_BLOCK_SIZE; /* Length of partial block */
> +	size_t nocts_len = round_down(len, AES_BLOCK_SIZE);
> +	u8 tmp_block[AES_BLOCK_SIZE] __aligned(__alignof__(long));
> +
> +	/* Encrypt all full blocks. */
> +	aes_xts_encrypt_nocts(dst, src, nocts_len, tweak, key, cont);
> +	dst += nocts_len - AES_BLOCK_SIZE;
> +	src += nocts_len - AES_BLOCK_SIZE;
> +
> +	/*
> +	 * Swap the partial block with the first 'partial_len' bytes of the
> +	 * encrypted last full block.  Note that a temporary buffer is needed to
> +	 * support in-place encryption.
> +	 */
> +	memcpy(tmp_block, src + AES_BLOCK_SIZE, partial_len);
> +	memcpy(dst + AES_BLOCK_SIZE, dst, partial_len);
> +	memcpy(dst, tmp_block, partial_len);
> +
> +	/* Encrypt the last full block again. */
> +	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
> +	aes_encrypt(&key->main_key, dst, dst);
> +	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
> +	memzero_explicit(tmp_block, sizeof(tmp_block));
> +}
> +
> +static noinline void aes_xts_decrypt_cts(u8 *dst, const u8 *src, size_t len,
> +					 u8 tweak[AES_BLOCK_SIZE],
> +					 const struct aes_xts_key *key,
> +					 bool cont)
> +{
> +	size_t partial_len = len % AES_BLOCK_SIZE; /* Length of partial block */
> +	size_t nocts_len = round_down(len, AES_BLOCK_SIZE) - AES_BLOCK_SIZE;
> +	union {
> +		u8 block[AES_BLOCK_SIZE];
> +		le128 tweak;
> +	} tmp __aligned(__alignof__(long));
> +
> +	/*
> +	 * Decrypt all blocks except the last full block and the partial block.
> +	 * The last full block has to be handled specially because decryption
> +	 * ciphertext stealing uses the last two tweaks in reverse order.
> +	 *
> +	 * nocts_len == 0 is possible here, which aes_xts_decrypt_nocts()
> +	 * doesn't handle (so that the length doesn't get checked redundantly in
> +	 * the fast path).  So handle that case specially as well.
> +	 */
> +	if (nocts_len)
> +		aes_xts_decrypt_nocts(dst, src, nocts_len, tweak, key, cont);
> +	else if (!cont)
> +		aes_encrypt(&key->tweak_key, tweak, tweak);
> +	dst += nocts_len;
> +	src += nocts_len;
> +
> +	/* Copy the tweak, advance it again, then decrypt last full block. */
> +	memcpy(&tmp.tweak, tweak, AES_BLOCK_SIZE);
> +	gf128mul_x_ble(&tmp.tweak, &tmp.tweak);
> +	crypto_xor_cpy(dst, src, tmp.block, AES_BLOCK_SIZE);
> +	aes_decrypt(&key->main_key, dst, dst);
> +	crypto_xor(dst, tmp.block, AES_BLOCK_SIZE);
> +
> +	/*
> +	 * Swap the partial block with the first 'partial_len' bytes of the
> +	 * decrypted last full block.  Note that a temporary buffer is needed to
> +	 * support in-place decryption.
> +	 */
> +	memcpy(tmp.block, src + AES_BLOCK_SIZE, partial_len);
> +	memcpy(dst + AES_BLOCK_SIZE, dst, partial_len);
> +	memcpy(dst, tmp.block, partial_len);
> +
> +	/* Decrypt the last full block again. */
> +	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
> +	aes_decrypt(&key->main_key, dst, dst);
> +	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
> +	memzero_explicit(&tmp, sizeof(tmp));
> +}
So in aes_xts_decrypt_cts, you're using a union to get a u8* pointer to the 
tweak, but in aes_xts_crypt_nocts_blockbyblock() you're casting it instead? 
... looks a little bit inconsisten, I'd maybe use the same way in both 
functions (IMHO casting in aes_xts_decrypt_cts should be fine, too, since 
you never seem to access the individual bytes of the tweak).

Apart from that, patch looks fine to me.

  Thanks,
   Thomas

