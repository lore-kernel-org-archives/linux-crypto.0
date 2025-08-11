Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4785657C9F;
	Mon, 11 Aug 2025 06:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892826; cv=none; b=VzSc8aRBo9mk5G9zFwnsWdvmLEmbIHmlC2W0fYBg19OiTsW5/GWiGDMh16x1JTiUwEPaoY0bMjIcjfuCTiq5gYtzrW7FoEeB9aNIzfI0EHFNhA9Xx9dSeqkH8yb0MUwbjuTQbE/Smxr5DN29edaqqj2js4iq0qBpk46Gahg0vbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892826; c=relaxed/simple;
	bh=LnPCD5wQWfe5ewQuYs5Ji2os16OC0uw92HZs4chNN6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuUEjLy6mCiO0uQSNkNcrBml5eAayAfoZzVT00+fvenC42KgM8shSG1xipg438tL+dsj3bVhYZtpuWchcm71becEt7bzGnzUQ1JvpzSoZrTEnmRE3IpNa/GrQ1TfQ8ws3jUrezs7h4wKMglVHd8qjMo5DXH5MoTLyyekPyxgIWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdExNfS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdExNfS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB26DC4CEED;
	Mon, 11 Aug 2025 06:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754892822;
	bh=LnPCD5wQWfe5ewQuYs5Ji2os16OC0uw92HZs4chNN6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XdExNfS82bYgbvYkazYD5Uca3vV525KEhs2Ec9BJUVqX9itC+3aNzhRqI0Na5Q+ym
	 Cna1s1ttn1b/iAFMF5AK8f8uXlPrvEIogzcVxTbyzYY5bNxtYW5u03kY2NHC2QK6Lj
	 D0ad0rPk5i/9ilAtjvCynVZkD46ucAXWSJQ7krj3/gw1FNPg5ibNqX0fQnKx/vWYWI
	 skmBqB7HKQMPq0sopiAHlRXbqAyg27nqBkMNc5QXihGtcPpLCI5PiFeZwqelbHxvmp
	 w97tZxlrXGimx55YtNHf39NI1kKnOLo1qfXeFmuv7zrrbeIoEiJDq5IKDVsXH9+TxF
	 KS+INLsfOw17w==
Date: Mon, 11 Aug 2025 11:43:35 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tee: Use SHA-1 library instead of crypto_shash
Message-ID: <aJmKDyD4weX9bR0U@sumit-X1>
References: <20250801235541.14050-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801235541.14050-1-ebiggers@kernel.org>

On Fri, Aug 01, 2025 at 04:55:41PM -0700, Eric Biggers wrote:
> Use the SHA-1 library functions instead of crypto_shash.  This is
> simpler and faster.
> 
> Change uuid_v5() to return void, since it can no longer fail.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> Note: this patch depends on the SHA-1 library functions that were merged
> in v6.17-rc1.
> 
>  drivers/tee/Kconfig    |  3 +--
>  drivers/tee/tee_core.c | 55 +++++++-----------------------------------
>  2 files changed, 10 insertions(+), 48 deletions(-)

Nice cleanup, FWIW:

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

> 
> diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
> index 61b507c187801..a84767940fbfc 100644
> --- a/drivers/tee/Kconfig
> +++ b/drivers/tee/Kconfig
> @@ -1,12 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  # Generic Trusted Execution Environment Configuration
>  menuconfig TEE
>  	tristate "Trusted Execution Environment support"
>  	depends on HAVE_ARM_SMCCC || COMPILE_TEST || CPU_SUP_AMD
> -	select CRYPTO
> -	select CRYPTO_SHA1
> +	select CRYPTO_LIB_SHA1
>  	select DMA_SHARED_BUFFER
>  	select GENERIC_ALLOCATOR
>  	help
>  	  This implements a generic interface towards a Trusted Execution
>  	  Environment (TEE).
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index acc7998758ad8..d079aeee0690a 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -12,11 +12,10 @@
>  #include <linux/module.h>
>  #include <linux/overflow.h>
>  #include <linux/slab.h>
>  #include <linux/tee_core.h>
>  #include <linux/uaccess.h>
> -#include <crypto/hash.h>
>  #include <crypto/sha1.h>
>  #include "tee_private.h"
>  
>  #define TEE_NUM_DEVICES	32
>  
> @@ -140,72 +139,36 @@ static int tee_release(struct inode *inode, struct file *filp)
>   * UUIDv5 is specific in RFC 4122.
>   *
>   * This implements section (for SHA-1):
>   * 4.3.  Algorithm for Creating a Name-Based UUID
>   */
> -static int uuid_v5(uuid_t *uuid, const uuid_t *ns, const void *name,
> -		   size_t size)
> +static void uuid_v5(uuid_t *uuid, const uuid_t *ns, const void *name,
> +		    size_t size)
>  {
>  	unsigned char hash[SHA1_DIGEST_SIZE];
> -	struct crypto_shash *shash = NULL;
> -	struct shash_desc *desc = NULL;
> -	int rc;
> -
> -	shash = crypto_alloc_shash("sha1", 0, 0);
> -	if (IS_ERR(shash)) {
> -		rc = PTR_ERR(shash);
> -		pr_err("shash(sha1) allocation failed\n");
> -		return rc;
> -	}
> -
> -	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
> -		       GFP_KERNEL);
> -	if (!desc) {
> -		rc = -ENOMEM;
> -		goto out_free_shash;
> -	}
> -
> -	desc->tfm = shash;
> +	struct sha1_ctx ctx;
>  
> -	rc = crypto_shash_init(desc);
> -	if (rc < 0)
> -		goto out_free_desc;
> -
> -	rc = crypto_shash_update(desc, (const u8 *)ns, sizeof(*ns));
> -	if (rc < 0)
> -		goto out_free_desc;
> -
> -	rc = crypto_shash_update(desc, (const u8 *)name, size);
> -	if (rc < 0)
> -		goto out_free_desc;
> -
> -	rc = crypto_shash_final(desc, hash);
> -	if (rc < 0)
> -		goto out_free_desc;
> +	sha1_init(&ctx);
> +	sha1_update(&ctx, (const u8 *)ns, sizeof(*ns));
> +	sha1_update(&ctx, (const u8 *)name, size);
> +	sha1_final(&ctx, hash);
>  
>  	memcpy(uuid->b, hash, UUID_SIZE);
>  
>  	/* Tag for version 5 */
>  	uuid->b[6] = (hash[6] & 0x0F) | 0x50;
>  	uuid->b[8] = (hash[8] & 0x3F) | 0x80;
> -
> -out_free_desc:
> -	kfree(desc);
> -
> -out_free_shash:
> -	crypto_free_shash(shash);
> -	return rc;
>  }
>  
>  int tee_session_calc_client_uuid(uuid_t *uuid, u32 connection_method,
>  				 const u8 connection_data[TEE_IOCTL_UUID_LEN])
>  {
>  	gid_t ns_grp = (gid_t)-1;
>  	kgid_t grp = INVALID_GID;
>  	char *name = NULL;
>  	int name_len;
> -	int rc;
> +	int rc = 0;
>  
>  	if (connection_method == TEE_IOCTL_LOGIN_PUBLIC ||
>  	    connection_method == TEE_IOCTL_LOGIN_REE_KERNEL) {
>  		/* Nil UUID to be passed to TEE environment */
>  		uuid_copy(uuid, &uuid_null);
> @@ -258,11 +221,11 @@ int tee_session_calc_client_uuid(uuid_t *uuid, u32 connection_method,
>  	default:
>  		rc = -EINVAL;
>  		goto out_free_name;
>  	}
>  
> -	rc = uuid_v5(uuid, &tee_client_uuid_ns, name, name_len);
> +	uuid_v5(uuid, &tee_client_uuid_ns, name, name_len);
>  out_free_name:
>  	kfree(name);
>  
>  	return rc;
>  }
> 
> base-commit: 0905809b38bda1fa0b206986c44d846e46f13c1d
> -- 
> 2.50.1
> 
