Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFCE2F0699;
	Fri, 31 Oct 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918958; cv=none; b=TpBMc2HFdNGManQk7wfVGIAqJ/+Mmfg+ZqU+lovdLotjSowcIZuraHqKI8gM7T1IBKGOaR77N5WS2iX9ombklLBPAUVVw69dZOkeytelDM9OGwqxglxFjANPKJqUeeKDA9LGYPgWIYbSNbh9FaU5782MwPqcyqePrJTO0aXCTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918958; c=relaxed/simple;
	bh=6NkBGG6MBPr3tGI6UhUfBqT345cQBS6YO0MM0giZo2U=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irTNnhPu8poPrQ1HC76M2sFGjFAW1fQ3FNpWtO0St5sI/EN29EGZeoFgkaUCci+UU3OCDwqlvQM5aHcfCHQKEneBSa/ira1TO+UszXI6cR3fJ865hG8ofjKpniBRCRS5bqxse7/94IMC2UtX7d1d9/7GTwPUPUfewGr6s9RfeO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cyj8J2hyPz6M4V2;
	Fri, 31 Oct 2025 21:52:00 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 36EBA140144;
	Fri, 31 Oct 2025 21:55:54 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Oct
 2025 13:55:53 +0000
Date: Fri, 31 Oct 2025 13:55:52 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ard Biesheuvel <ardb+git@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Kees Cook
	<kees@kernel.org>
Subject: Re: [PATCH v4 04/21] arm64/simd: Add scoped guard API for kernel
 mode SIMD
Message-ID: <20251031135552.00004281@huawei.com>
In-Reply-To: <20251031103858.529530-27-ardb+git@google.com>
References: <20251031103858.529530-23-ardb+git@google.com>
	<20251031103858.529530-27-ardb+git@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 31 Oct 2025 11:39:03 +0100
Ard Biesheuvel <ardb+git@google.com> wrote:

> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Encapsulate kernel_neon_begin() and kernel_neon_end() using a 'ksimd'
> cleanup guard. This hides the prototype of those functions, allowing
> them to be changed for arm64 but not ARM, without breaking code that is
> shared between those architectures (RAID6, AEGIS-128)
> 
> It probably makes sense to expose this API more widely across
> architectures, as it affords more flexibility to the arch code to
> plumb it in, while imposing more rigid rules regarding the start/end
> bookends appearing in matched pairs.
> 
> Reviewed-by: Kees Cook <kees@kernel.org>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Very nice.

FWIW I looked at all the usecases and other than a couple of trivial
comments on individual patches they look good to me.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
For patches 4-19


> ---
>  arch/arm64/include/asm/simd.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> index 8e86c9e70e48..d9f83c478736 100644
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -6,12 +6,15 @@
>  #ifndef __ASM_SIMD_H
>  #define __ASM_SIMD_H
>  
> +#include <linux/cleanup.h>
>  #include <linux/compiler.h>
>  #include <linux/irqflags.h>
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
>  #include <linux/types.h>
>  
> +#include <asm/neon.h>
> +
>  #ifdef CONFIG_KERNEL_MODE_NEON
>  
>  /*
> @@ -40,4 +43,8 @@ static __must_check inline bool may_use_simd(void) {
>  
>  #endif /* ! CONFIG_KERNEL_MODE_NEON */
>  
> +DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
> +
> +#define scoped_ksimd()	scoped_guard(ksimd)
> +
>  #endif

