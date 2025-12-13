Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80021190462
	for <linux-crypto@vger.kernel.org>; Sat, 13 Dec 2025 04:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765598916; cv=none; b=mBeemD8zfYpRqksNmap4PoQ6ocoy0rACv+hcfsVqcB9rIrzruanGs8bWTacGHTXPTrbXfg9jv7RftTOJqoZ04B5Jje46weaCh4UvFAE1elrkigf9buyhL4IYJ6U0k0R+LjhF5onyqTaICIHX/JOL1g1SFoXna0J4FUolDLhsH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765598916; c=relaxed/simple;
	bh=S4e+17BhVdLJ7FEFhc4YNXAdO1LVfA7BvpY6ADlBRxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQI+WI2ufQJka/pEDf42QGlo0nLzX0YmR4ybIBnZVjoSjfykVvOi9+7Y3fGccvxHFOYIsWhmCuOelGCEMTBfGpicNqKOpTMkpuzhZi0LH7kShm1uT/bcr240eCcXnqZB2n9rlPQSueVwtj4Oorp59SFemrETTiWJPrpe3Xpb7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TLta5YKR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TLta5YKR"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3436a97f092so3086710a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 20:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765598914; x=1766203714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQ+twKjaHYke23BhsGcZ+xE0VciI0W1uX/632/TSbdM=;
        b=TLta5YKRVEIULfvULzX1jGjAPylePpMzXGTDat1tDjl/9diUoLL96DXerH3SHo+eNF
         RQ69o4czRpS1xk7jSomh7/9CfYPMgiNsF84Muqwb9v3RToZs7xLSmU/vZGjhrbCXZbzA
         sQYuLQdcZrYnv8VFLP0Gc2uRwNfawL33S96nOZanqAS9vMfYSlHS1fDYB2B3aS3AUdQS
         mP4z+YL5MX6/WUu0BSwMP2RNPO6BsJ0QUy+6Kv9MVAhk04UsYIem/gSqqaeGUTuzWtBQ
         KDeozSjb00s4YZ330HAkgyegfIsBNlUOvHfGgxNW26on2Ydag85vZ30qBcsXU0HkP2qu
         6YaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765598914; x=1766203714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQ+twKjaHYke23BhsGcZ+xE0VciI0W1uX/632/TSbdM=;
        b=q3RvuKo8/NMNipF80UBXyIc9vISxL90cvMEYn45IwFpYXbBheeziRNPh4u/f0HbKUH
         rD9WIObjGknv1LJbJgFqh4GBVwxSLwyqwfcaryv6bJnnsIxzd9UGSxWjPL6sR3ET/GA1
         KMlzcpT0pVHsFqKx8G/DBLIQ38lbQa0ma4p0ncFU0dU6Usg6p2RsIk4ampk2tDbokvdP
         gepRktqr2soUSAJM35MtOE6jjZafFaSKOGD6mthG02g1XULfcDjWzzuFxc7d/SBQzIBY
         6mQlB2qem9QcbRxRhjqxwHZ4kUumvIasJ5WZzqApQW5+Nurin0U81Ci9I4d+mOW+YnUM
         mDPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjVgUgd3oOmMdmnGOV5lBdB7gDRuOfg258Cj524U09k0Or0f8nesDEw2fK3jABO28DTQZNHJG5S40LRV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUOrabvfbAZR8nhQCQ7ZwRZWVsGSg3apRPs+VfAi0b5QXCqsg0
	qocAaiEtNb4ckIaK2zYba+BinBehYnIsaieUXor4dVDhdYM8q78JtzYU
X-Gm-Gg: AY/fxX5VbU69kpeDsbv7HAEhbK/YnPTGeQyRsYB1OgikA9QrWAMScLXC8C09b4gwNTf
	6Bf+76DI4rlOOJm2iqWlYhwqkl9vokXaZ6/Mr6sgz9JaU4e+fhdbG2fBNLog2co1OBz4DU9ebRF
	89tlDs0Z1YOlokhYQDfSOMj7xVVrxODx6KK0L9xl9yv7urm8E+OM0JlEZITN7MQkwoUcHTAWgQJ
	OfyG27pshhaPAaORNMXAGgYNoYVYemNOQcosQLiCan8nqzcJTCZUmQDLCNFODELZGM5nYDF1gUd
	r657IVjnmvYIuvim32LQBHuqwp8o8gbCsIMRCQT+P5exKvHGiERaiUwNbuFR3TqxPtZNooyLdpl
	EbrVukVpuXcoW7x1ODC9HGP2teUDjN5dkoBgxnhsdgJtZhA2LuBp6gwEtmQ7YuaGQ6qyYo/L/s8
	zXIlu8RdKUaH91Oq5J/QQGwhIPMZUJyIgz6qObgo7OVNkz9ubJwqjPfRsoUYw=
X-Google-Smtp-Source: AGHT+IH9xu7w1st+DcAteV/4FOc533EQ8weiBhK+qkvKu6HP5khA+4aMkrsi4AU3dWt4u/is2CZeGA==
X-Received: by 2002:a17:90a:fc47:b0:32b:65e6:ec48 with SMTP id 98e67ed59e1d1-34abd6efa0emr3444232a91.8.1765598913720;
        Fri, 12 Dec 2025 20:08:33 -0800 (PST)
Received: from [10.200.5.118] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe216c54sm3195985a91.7.2025.12.12.20.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 20:08:33 -0800 (PST)
Message-ID: <038b5ca7-fe01-4f85-b26c-d8219d046345@gmail.com>
Date: Sat, 13 Dec 2025 04:08:27 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v3 3/6] bpf: Add SHA hash kfunc for cryptographic
 hashing
To: Daniel Hodges <git@danielhodges.dev>, bpf@vger.kernel.org
Cc: ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
 vadim.fedorenko@linux.dev, song@kernel.org, yatsenko@meta.com,
 martin.lau@linux.dev, eddyz87@gmail.com, haoluo@google.com,
 jolsa@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, yonghong.song@linux.dev, herbert@gondor.apana.org.au,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20251208030117.18892-1-git@danielhodges.dev>
 <20251208030117.18892-4-git@danielhodges.dev>
Content-Language: en-US
From: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
In-Reply-To: <20251208030117.18892-4-git@danielhodges.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/8/25 03:01, Daniel Hodges wrote:
> Extend bpf_crypto_type structure with hash operations:
>   - hash(): Performs hashing operation
>   - digestsize(): Returns hash output size
>
> Update bpf_crypto_ctx_create() to support keyless operations:
>   - Hash algorithms don't require keys, unlike ciphers
>   - Only validates key presence if type->setkey is defined
>   - Conditionally sets IV/state length for cipher operations only
>
> Add bpf_crypto_hash() kfunc that works with any hash algorithm
> registered in the kernel's crypto API through the BPF crypto type
> system. This enables BPF programs to compute cryptographic hashes for
> use cases such as content verification, integrity checking, and data
> authentication.
>
> Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> ---
>   kernel/bpf/crypto.c | 76 ++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 68 insertions(+), 8 deletions(-)
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
>
> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> index 83c4d9943084..47e6a43a46d4 100644
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c
> @@ -171,7 +171,12 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
>   		goto err_module_put;
>   	}
>   
> -	if (!params->key_len || params->key_len > sizeof(params->key)) {
> +	/* Hash operations don't require a key, but cipher operations do */
> +	if (params->key_len > sizeof(params->key)) {
> +		*err = -EINVAL;
> +		goto err_module_put;
> +	}
> +	if (!params->key_len && type->setkey) {
>   		*err = -EINVAL;
>   		goto err_module_put;
>   	}
> @@ -195,16 +200,19 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
>   			goto err_free_tfm;
>   	}
>   
> -	*err = type->setkey(ctx->tfm, params->key, params->key_len);
> -	if (*err)
> -		goto err_free_tfm;
> +	if (params->key_len) {
> +		*err = type->setkey(ctx->tfm, params->key, params->key_len);
> +		if (*err)
> +			goto err_free_tfm;
>   
> -	if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
> -		*err = -EINVAL;
> -		goto err_free_tfm;
> +		if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
> +			*err = -EINVAL;
> +			goto err_free_tfm;
> +		}
>   	}
>   
> -	ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
> +	if (type->ivsize && type->statesize)
> +		ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
>   
>   	refcount_set(&ctx->usage, 1);
>   
> @@ -343,6 +351,54 @@ __bpf_kfunc int bpf_crypto_encrypt(struct bpf_crypto_ctx *ctx,
>   	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, false);
>   }
>   
> +#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
> +/**
> + * bpf_crypto_hash() - Compute hash using configured context
> + * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
> + * @data:	bpf_dynptr to the input data to hash. Must be a trusted pointer.
> + * @out:	bpf_dynptr to the output buffer. Must be a trusted pointer.
> + *
> + * Computes hash of the input data using the crypto context. The output buffer
> + * must be at least as large as the digest size of the hash algorithm.
> + */
> +__bpf_kfunc int bpf_crypto_hash(struct bpf_crypto_ctx *ctx,
> +				const struct bpf_dynptr *data,
> +				const struct bpf_dynptr *out)
> +{
> +	const struct bpf_dynptr_kern *data_kern = (struct bpf_dynptr_kern *)data;
> +	const struct bpf_dynptr_kern *out_kern = (struct bpf_dynptr_kern *)out;
> +	u64 data_len, out_len;
> +	const u8 *data_ptr;
> +	u8 *out_ptr;
> +
> +	if (!ctx->type->hash)
> +		return -EOPNOTSUPP;
> +
> +	data_len = __bpf_dynptr_size(data_kern);
> +	out_len = __bpf_dynptr_size(out_kern);
> +
> +	if (data_len == 0)
> +		return -EINVAL;
> +
> +	if (!ctx->type->digestsize)
> +		return -EOPNOTSUPP;
> +
> +	unsigned int digestsize = ctx->type->digestsize(ctx->tfm);
> +	if (out_len < digestsize)
> +		return -EINVAL;
> +
> +	data_ptr = __bpf_dynptr_data(data_kern, data_len);
> +	if (!data_ptr)
> +		return -EINVAL;
> +
> +	out_ptr = __bpf_dynptr_data_rw(out_kern, out_len);
> +	if (!out_ptr)
> +		return -EINVAL;
> +
> +	return ctx->type->hash(ctx->tfm, data_ptr, out_ptr, data_len);
> +}
> +#endif /* CONFIG_CRYPTO_HASH2 */
> +
>   __bpf_kfunc_end_defs();
>   
>   BTF_KFUNCS_START(crypt_init_kfunc_btf_ids)
> @@ -359,6 +415,9 @@ static const struct btf_kfunc_id_set crypt_init_kfunc_set = {
>   BTF_KFUNCS_START(crypt_kfunc_btf_ids)
>   BTF_ID_FLAGS(func, bpf_crypto_decrypt, KF_RCU)
>   BTF_ID_FLAGS(func, bpf_crypto_encrypt, KF_RCU)
> +#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
> +BTF_ID_FLAGS(func, bpf_crypto_hash, KF_RCU)
> +#endif
>   BTF_KFUNCS_END(crypt_kfunc_btf_ids)
>   
>   static const struct btf_kfunc_id_set crypt_kfunc_set = {
> @@ -383,6 +442,7 @@ static int __init crypto_kfunc_init(void)
>   	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &crypt_kfunc_set);
>   	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &crypt_kfunc_set);
>   	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &crypt_kfunc_set);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &crypt_kfunc_set);
>   	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
>   					       &crypt_init_kfunc_set);
>   	return  ret ?: register_btf_id_dtor_kfuncs(bpf_crypto_dtors,
