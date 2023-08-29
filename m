Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7510C83F16
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Aug 2023 11:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjH2LtA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Aug 2023 07:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjH2Lsh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2023 07:48:37 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E6A194
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2023 04:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1693309705;
        bh=V7fp4M9m50UUinbeFQ1LBWrcpG397hshYrmRg4hs78o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ld+GC+EV4Zu+j0MWCz9YSYef3C+5Ig5srlyGRbxzJY1VRX0A7tAuee/Im30uP23XS
         hLzLy9MNLElY+77KNRrDZEApxw+r5WXfZwXLZcU0I3Cv7AR0bs4GwHj6m0RgIcl5i7
         pGHiKFSI7QYWqvakfvamyqq4K+T1GGciAx9EE2HYz3bN9YsyVmAEscsInMPGLvjZA+
         uqZZ4mPASaPlNfTNNtBEbdCyjg8orG0ECVaNS/VCcauiGQifpBvDFD0sWz3/o2UAIS
         DMYxgWIOUFvZZgoFj9GTgdvF228twAda/t9F60m7bebZnCe9RECs8yLjJKc0GGaGI9
         sAAMichvM70mw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RZm090DPRz4wxQ;
        Tue, 29 Aug 2023 21:48:25 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Danny Tsen <dtsen@linux.ibm.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: crypto: powerpc/chacha20,poly1305-p10 - Add dependency on VSX
In-Reply-To: <ZOxj3rFGVcRUzgwb@gondor.apana.org.au>
References: <202308251906.SYawej6g-lkp@intel.com>
 <ZOxj3rFGVcRUzgwb@gondor.apana.org.au>
Date:   Tue, 29 Aug 2023 21:48:17 +1000
Message-ID: <87msyakr26.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Fri, Aug 25, 2023 at 07:44:32PM +0800, kernel test robot wrote:
>>
>> All errors (new ones prefixed by >>):
>> 
>>    In file included from arch/powerpc/crypto/poly1305-p10-glue.c:19:
>
> ...
>
>> ae3a197e3d0bfe3 David Howells    2012-03-28  75  
>> ae3a197e3d0bfe3 David Howells    2012-03-28  76  #ifdef CONFIG_VSX
>> d1e1cf2e38def30 Anton Blanchard  2015-10-29  77  extern void enable_kernel_vsx(void);
>> ae3a197e3d0bfe3 David Howells    2012-03-28  78  extern void flush_vsx_to_thread(struct task_struct *);
>> 3eb5d5888dc68c9 Anton Blanchard  2015-10-29  79  static inline void disable_kernel_vsx(void)
>> 3eb5d5888dc68c9 Anton Blanchard  2015-10-29  80  {
>> 3eb5d5888dc68c9 Anton Blanchard  2015-10-29  81  	msr_check_and_clear(MSR_FP|MSR_VEC|MSR_VSX);
>> 3eb5d5888dc68c9 Anton Blanchard  2015-10-29  82  }
>> bd73758803c2eed Christophe Leroy 2021-03-09  83  #else
>> bd73758803c2eed Christophe Leroy 2021-03-09  84  static inline void enable_kernel_vsx(void)
>> bd73758803c2eed Christophe Leroy 2021-03-09  85  {
>> bd73758803c2eed Christophe Leroy 2021-03-09 @86  	BUILD_BUG();
>> bd73758803c2eed Christophe Leroy 2021-03-09  87  }
>> bd73758803c2eed Christophe Leroy 2021-03-09  88  
>
> ---8<---
> Add dependency on VSX as otherwise the build will fail without
> it.
>
> Fixes: 161fca7e3e90 ("crypto: powerpc - Add chacha20/poly1305-p10 to Kconfig and Makefile")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308251906.SYawej6g-lkp@intel.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

> diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
> index f25024afdda5..7a66d7c0e6a2 100644
> --- a/arch/powerpc/crypto/Kconfig
> +++ b/arch/powerpc/crypto/Kconfig
> @@ -113,7 +113,7 @@ config CRYPTO_AES_GCM_P10
>  
>  config CRYPTO_CHACHA20_P10
>  	tristate "Ciphers: ChaCha20, XChacha20, XChacha12 (P10 or later)"
> -	depends on PPC64 && CPU_LITTLE_ENDIAN
> +	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_LIB_CHACHA_GENERIC
>  	select CRYPTO_ARCH_HAVE_LIB_CHACHA
> @@ -127,7 +127,7 @@ config CRYPTO_CHACHA20_P10
>  
>  config CRYPTO_POLY1305_P10
>  	tristate "Hash functions: Poly1305 (P10 or later)"
> -	depends on PPC64 && CPU_LITTLE_ENDIAN
> +	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
>  	select CRYPTO_HASH
>  	select CRYPTO_LIB_POLY1305_GENERIC
>  	help
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
