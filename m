Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA99223BF83;
	Fri, 31 Oct 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918762; cv=none; b=i8e3dGtTvo+NnO/ea0eIjDgZIU9OcQ6TP2JQ5rzpws4Ul9V5wtqyc6l6ZeTsmS5bGwuaZMpic4koqtS/Gj5ceA3uE45hXBhzif14gqXafjrCTi9CrksljJmyPuDcNoWABrqwpv+PQDU3i15YQBfLMt+hQYY9SR81Q2C26aaXMyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918762; c=relaxed/simple;
	bh=nDkoVx1LOlQ0Ieb+MUqePfoUVnAUGAJHjruVrqPMwxs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sO/9uu0Qlc6GaBskUdAOvPrOFH2RxNh9fi7ic9rBJ95V7pQz6V1hA3mHDI9FytZU6XwziglgHc6ESKZ/z9S6bdeRJ8b0ekfLBI5s4AtLpEfue/TOL2H2tTLxlmR7RnTlsV0WBaj5dJrTlqB7CGUNs/IF2p9Rtm+FF89QqxfrEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cyj7w6bTnzHnGk2;
	Fri, 31 Oct 2025 13:51:40 +0000 (UTC)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 772C4140144;
	Fri, 31 Oct 2025 21:52:37 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Oct
 2025 13:52:36 +0000
Date: Fri, 31 Oct 2025 13:52:35 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ard Biesheuvel <ardb+git@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 16/21] crypto/arm64: sm3 - Switch to 'ksimd' scoped
 guard API
Message-ID: <20251031135235.000007cb@huawei.com>
In-Reply-To: <20251031103858.529530-39-ardb+git@google.com>
References: <20251031103858.529530-23-ardb+git@google.com>
	<20251031103858.529530-39-ardb+git@google.com>
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

On Fri, 31 Oct 2025 11:39:15 +0100
Ard Biesheuvel <ardb+git@google.com> wrote:

> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Switch to the more abstract 'scoped_ksimd()' API, which will be modified
> in a future patch to transparently allocate a kernel mode FP/SIMD state
> buffer on the stack, so that kernel mode FP/SIMD code remains
> preemptible in principe, but without the memory overhead that adds 528
> bytes to the size of struct task_struct.
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Hi Ard,

Trivial comment inline.

> ---
>  arch/arm64/crypto/sm3-ce-glue.c   | 15 ++++++++-------
>  arch/arm64/crypto/sm3-neon-glue.c | 16 ++++++----------
>  2 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
> index eac6f5fa0abe..24c1fcfae072 100644
> --- a/arch/arm64/crypto/sm3-ce-glue.c
> +++ b/arch/arm64/crypto/sm3-ce-glue.c
> @@ -5,7 +5,6 @@
>   * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
>   */
>  
> -#include <asm/neon.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/sm3.h>
>  #include <crypto/sm3_base.h>
> @@ -13,6 +12,8 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  
> +#include <asm/simd.h>
> +
>  MODULE_DESCRIPTION("SM3 secure hash using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
> @@ -25,18 +26,18 @@ static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
>  {
>  	int remain;
>  
> -	kernel_neon_begin();
> -	remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
> -	kernel_neon_end();
> +	scoped_ksimd() {

Why does this get brackets unlike other cases?

> +		remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
> +	}
>  	return remain;
>  }
>  
>  static int sm3_ce_finup(struct shash_desc *desc, const u8 *data,
>  			unsigned int len, u8 *out)
>  {
> -	kernel_neon_begin();
> -	sm3_base_do_finup(desc, data, len, sm3_ce_transform);
> -	kernel_neon_end();
> +	scoped_ksimd() {
> +		sm3_base_do_finup(desc, data, len, sm3_ce_transform);
> +	}
>  	return sm3_base_finish(desc, out);
>  }
>  
> diff --git a/arch/arm64/crypto/sm3-neon-glue.c b/arch/arm64/crypto/sm3-neon-glue.c
> index 6c4611a503a3..15f30cc24f32 100644
> --- a/arch/arm64/crypto/sm3-neon-glue.c
> +++ b/arch/arm64/crypto/sm3-neon-glue.c
> @@ -5,7 +5,7 @@
>   * Copyright (C) 2022 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>   */
>  
> -#include <asm/neon.h>
> +#include <asm/simd.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/sm3.h>
>  #include <crypto/sm3_base.h>
> @@ -20,20 +20,16 @@ asmlinkage void sm3_neon_transform(struct sm3_state *sst, u8 const *src,
>  static int sm3_neon_update(struct shash_desc *desc, const u8 *data,
>  			   unsigned int len)
>  {
> -	int remain;
> -
> -	kernel_neon_begin();
> -	remain = sm3_base_do_update_blocks(desc, data, len, sm3_neon_transform);
> -	kernel_neon_end();
> -	return remain;
> +	scoped_ksimd()
> +		return sm3_base_do_update_blocks(desc, data, len,
> +						 sm3_neon_transform);
>  }
>  
>  static int sm3_neon_finup(struct shash_desc *desc, const u8 *data,
>  			  unsigned int len, u8 *out)
>  {
> -	kernel_neon_begin();
> -	sm3_base_do_finup(desc, data, len, sm3_neon_transform);
> -	kernel_neon_end();
> +	scoped_ksimd()
> +		sm3_base_do_finup(desc, data, len, sm3_neon_transform);
>  	return sm3_base_finish(desc, out);
>  }
>  

