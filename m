Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170C21FB3
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744823386; cv=none; b=aaqpp1ru86sB3NzBJtzTsB8v8KOapw1knp26gKWoBNJBX/ZVjqZ8PvFHlEwQGF/Dm/dEQCx1BJ6O5oFnE4oDaKDgq+wCYa+JoUOIyr8bkY239t88jyYDRDjwdZXBWrVbHTGxswEu5EpcxoohNtN9IUSLPKj+TCG/0d+AMQ9Yajg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744823386; c=relaxed/simple;
	bh=71bXe7/JGCogsQ7ibc+guzQ5c9x3kLnVtoCxcOYQayg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuqpvF7UtAwwLTtbg1uLwYs1sshz9HrSnFhuX6rR5foh5YbCGtVaHfo55NYsS5qDNR7GKFVDDgJFv4y77xc6IHgx35wheBi2JiLK8CclkrFwYO307ftGOXh7oUSt0cSRLydvC5VMMWRWE5YkBg6TQpUgcUtk1DgOIEu5MmAskVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0HPiwW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0HPiwW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF7BC4CEE2;
	Wed, 16 Apr 2025 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744823385;
	bh=71bXe7/JGCogsQ7ibc+guzQ5c9x3kLnVtoCxcOYQayg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d0HPiwW5KIvl/Le9iDjcgAKhbskjl6UoqgGSvCxRvegI+EhuQj6lapdmDnXYDpXHe
	 610+CSXaYTPb9SBxmoFSJN2XQMNBWc0oiH8If7qCdUR4H4f1GupS+LK9u8ec5Gq7aO
	 82s1l5mrk4X1oFJt5K5qA9N1YxP5AZNnYeqFr9fJxIDf93VgrNy4HLkSPW7fTMPWXa
	 fK2zblArTDjXWY/HfKp4POXjwe8LDw7So2s9q1yENa9My0lKNgBWNhVg7ET0YPUJPu
	 PmTI9sDouB2AraYGVrV2nCn/p9EqYa7K25q5Ax9w7nC3A+2Ddxjt2T5riD8hfo2uiM
	 Xf3nVA6oTyh0w==
Date: Wed, 16 Apr 2025 10:09:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/4] asm-generic: Make simd.h more resilient
Message-ID: <20250416170943.GB189808@quark.localdomain>
References: <cover.1744356724.git.herbert@gondor.apana.org.au>
 <c2a0a6a3467c6ff404e524d564f777fad31c9ebc.1744356724.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2a0a6a3467c6ff404e524d564f777fad31c9ebc.1744356724.git.herbert@gondor.apana.org.au>

On Fri, Apr 11, 2025 at 03:38:43PM +0800, Herbert Xu wrote:
> Add missing header inclusions and protect against double inclusion.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  include/asm-generic/simd.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/simd.h b/include/asm-generic/simd.h
> index d0343d58a74a..ac29a22eb7cf 100644
> --- a/include/asm-generic/simd.h
> +++ b/include/asm-generic/simd.h
> @@ -1,6 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_GENERIC_SIMD_H
> +#define _ASM_GENERIC_SIMD_H
>  
> -#include <linux/hardirq.h>
> +#include <linux/compiler_attributes.h>
> +#include <linux/preempt.h>
> +#include <linux/types.h>
>  
>  /*
>   * may_use_simd - whether it is allowable at this time to issue SIMD
> @@ -13,3 +17,5 @@ static __must_check inline bool may_use_simd(void)
>  {
>  	return !in_interrupt();
>  }
> +
> +#endif	/* _ASM_GENERIC_SIMD_H */

This patch broke the powerpc build:

../arch/powerpc/lib/crc32-glue.c: In function 'crc32c_arch':
../arch/powerpc/lib/crc32-glue.c:44:17: error: implicit declaration of function 'pagefault_disable'; did you mean 'preempt_disable'? [-Wimplicit-function-declaration]
   44 |                 pagefault_disable();
      |                 ^~~~~~~~~~~~~~~~~
      |                 preempt_disable
../arch/powerpc/lib/crc-t10dif-glue.c: In function 'crc_t10dif_arch':
../arch/powerpc/lib/crc-t10dif-glue.c:48:17: error: implicit declaration of function 'pagefault_disable'; did you mean 'preempt_disable'? [-Wimplicit-function-declaration]
   48 |                 pagefault_disable();
      |                 ^~~~~~~~~~~~~~~~~
      |                 preempt_disable
../arch/powerpc/lib/crc32-glue.c:48:17: error: implicit declaration of function 'pagefault_enable'; did you mean 'preempt_enable'? [-Wimplicit-function-declaration]
   48 |                 pagefault_enable();
      |                 ^~~~~~~~~~~~~~~~
      |                 preempt_enable
../arch/powerpc/lib/crc-t10dif-glue.c:52:17: error: implicit declaration of function 'pagefault_enable'; did you mean 'preempt_enable'? [-Wimplicit-function-declaration]
   52 |                 pagefault_enable();
      |                 ^~~~~~~~~~~~~~~~
      |                 preempt_enable
