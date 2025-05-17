Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC294B1E7B;
	Sat, 17 May 2025 07:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747467747; cv=none; b=Nl6resa8P/Yf2IivbUvJy4UXP5ckenKxhvDt94N8wSPucY1WTYo609Wrx8495W7xMgCrDTod2grCo/N+Mf09ceKoORcJ7eRzB0Z+zR+i10xrdYz+HMfrNDXew/nWKUx24S7XkdYC64+DGiVrsRTVdMF9pZD7O7UFo9AbnXqpsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747467747; c=relaxed/simple;
	bh=uYn6X5KptqYq4oLBuy217WriZf8lMFOZ2i+WCF7q6sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sjNclKKlbY5lmaKw6ULUbf0WTQrE9KsrkdWwX/BktwUJPGoyySmBcbvBmIULWhC4jW4oRzVrh7TqUzVEYrsgdNpEnIRgyab0KaLRPD/508kZvhRax9x8nHBDfKTex9fTq5KFcwsbqrm9KvY3alGaRLJlRBtdwgv050fVDAUPqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=USKuqWHP; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="USKuqWHP"
Received: from [172.20.3.254] (unknown [213.157.19.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C744C3FAF0;
	Sat, 17 May 2025 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1747467735;
	bh=tNwwwS/3kfyG+r0IhuUAksmNxwZppBafE6zBouPal/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=USKuqWHP8ftrp4TWMROFV/WCLB+A8sj+F0mO2kr2aqFjcgOXKEF1l33LBLJqD9AJO
	 ianSqv0enNC8Gtez3aINLhw9l8cEnHKgDdZ6GiMpb0dJNY7F+xUNqyNHLd778ZhBI2
	 TZYtp5aU3AYLEg8IZBeJqfrNnqJQurshpNzcN+r68AtxAMcmdPT18NoVPXWqHJrX7I
	 Ukf0Be8I1sLsvB81EfL4aigSwO1mz79xQ9aEEoaiY2/WpW9iHAOKumn8aPvKiVOLTm
	 3GfQKFFylg1T7WtsW7sonB/43qYrBJHK8+xZxRKIxHQo4/4wrmhtp0YnhYwOHGerlZ
	 IS36VqK6l0RlQ==
Message-ID: <ac8fdbfc-02f4-4f35-b8a1-e029b6b322c1@canonical.com>
Date: Sat, 17 May 2025 00:42:14 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of crypto_shash
 API
To: Eric Biggers <ebiggers@kernel.org>, apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20250428190430.850240-1-ebiggers@kernel.org>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20250428190430.850240-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 12:04, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This user of SHA-256 does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: John Johansen <john.johansen@canonical.com>

> ---
> 
> This patch is targeting the apparmor tree for 6.16.
> 
>   security/apparmor/Kconfig  |  3 +-
>   security/apparmor/crypto.c | 85 ++++++--------------------------------
>   2 files changed, 13 insertions(+), 75 deletions(-)
> 
> diff --git a/security/apparmor/Kconfig b/security/apparmor/Kconfig
> index 64cc3044a42ce..1e3bd44643dac 100644
> --- a/security/apparmor/Kconfig
> +++ b/security/apparmor/Kconfig
> @@ -57,12 +57,11 @@ config SECURITY_APPARMOR_INTROSPECT_POLICY
>   	  cpu is paramount.
>   
>   config SECURITY_APPARMOR_HASH
>   	bool "Enable introspection of sha256 hashes for loaded profiles"
>   	depends on SECURITY_APPARMOR_INTROSPECT_POLICY
> -	select CRYPTO
> -	select CRYPTO_SHA256
> +	select CRYPTO_LIB_SHA256
>   	default y
>   	help
>   	  This option selects whether introspection of loaded policy
>   	  hashes is available to userspace via the apparmor
>   	  filesystem. This option provides a light weight means of
> diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
> index aad486b2fca65..40e17e153f1e5 100644
> --- a/security/apparmor/crypto.c
> +++ b/security/apparmor/crypto.c
> @@ -9,115 +9,54 @@
>    * Fns to provide a checksum of policy that has been loaded this can be
>    * compared to userspace policy compiles to check loaded policy is what
>    * it should be.
>    */
>   
> -#include <crypto/hash.h>
> +#include <crypto/sha2.h>
>   
>   #include "include/apparmor.h"
>   #include "include/crypto.h"
>   
> -static unsigned int apparmor_hash_size;
> -
> -static struct crypto_shash *apparmor_tfm;
> -
>   unsigned int aa_hash_size(void)
>   {
> -	return apparmor_hash_size;
> +	return SHA256_DIGEST_SIZE;
>   }
>   
>   char *aa_calc_hash(void *data, size_t len)
>   {
> -	SHASH_DESC_ON_STACK(desc, apparmor_tfm);
>   	char *hash;
> -	int error;
> -
> -	if (!apparmor_tfm)
> -		return NULL;
>   
> -	hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
> +	hash = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
>   	if (!hash)
>   		return ERR_PTR(-ENOMEM);
>   
> -	desc->tfm = apparmor_tfm;
> -
> -	error = crypto_shash_init(desc);
> -	if (error)
> -		goto fail;
> -	error = crypto_shash_update(desc, (u8 *) data, len);
> -	if (error)
> -		goto fail;
> -	error = crypto_shash_final(desc, hash);
> -	if (error)
> -		goto fail;
> -
> +	sha256(data, len, hash);
>   	return hash;
> -
> -fail:
> -	kfree(hash);
> -
> -	return ERR_PTR(error);
>   }
>   
>   int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
>   			 size_t len)
>   {
> -	SHASH_DESC_ON_STACK(desc, apparmor_tfm);
> -	int error;
> +	struct sha256_state state;
>   	__le32 le32_version = cpu_to_le32(version);
>   
>   	if (!aa_g_hash_policy)
>   		return 0;
>   
> -	if (!apparmor_tfm)
> -		return 0;
> -
> -	profile->hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
> +	profile->hash = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
>   	if (!profile->hash)
>   		return -ENOMEM;
>   
> -	desc->tfm = apparmor_tfm;
> -
> -	error = crypto_shash_init(desc);
> -	if (error)
> -		goto fail;
> -	error = crypto_shash_update(desc, (u8 *) &le32_version, 4);
> -	if (error)
> -		goto fail;
> -	error = crypto_shash_update(desc, (u8 *) start, len);
> -	if (error)
> -		goto fail;
> -	error = crypto_shash_final(desc, profile->hash);
> -	if (error)
> -		goto fail;
> -
> +	sha256_init(&state);
> +	sha256_update(&state, (u8 *)&le32_version, 4);
> +	sha256_update(&state, (u8 *)start, len);
> +	sha256_final(&state, profile->hash);
>   	return 0;
> -
> -fail:
> -	kfree(profile->hash);
> -	profile->hash = NULL;
> -
> -	return error;
>   }
>   
>   static int __init init_profile_hash(void)
>   {
> -	struct crypto_shash *tfm;
> -
> -	if (!apparmor_initialized)
> -		return 0;
> -
> -	tfm = crypto_alloc_shash("sha256", 0, 0);
> -	if (IS_ERR(tfm)) {
> -		int error = PTR_ERR(tfm);
> -		AA_ERROR("failed to setup profile sha256 hashing: %d\n", error);
> -		return error;
> -	}
> -	apparmor_tfm = tfm;
> -	apparmor_hash_size = crypto_shash_digestsize(apparmor_tfm);
> -
> -	aa_info_message("AppArmor sha256 policy hashing enabled");
> -
> +	if (apparmor_initialized)
> +		aa_info_message("AppArmor sha256 policy hashing enabled");
>   	return 0;
>   }
> -
>   late_initcall(init_profile_hash);
> 
> base-commit: 33035b665157558254b3c21c3f049fd728e72368

