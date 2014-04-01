From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [crypto:master 60/60] arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25:
 sparse: cast to restricted __be64
Date: Tue, 1 Apr 2014 14:37:20 +0200
Message-ID: <CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:57819 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDAMhW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2014 08:37:22 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so6848777lan.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2014 05:37:20 -0700 (PDT)
In-Reply-To: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1 April 2014 13:23, kbuild test robot <fengguang.wu@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> head:   8ceee72808d1ae3fb191284afc2257a2be964725
> commit: 8ceee72808d1ae3fb191284afc2257a2be964725 [60/60] crypto: ghash-clmulni-intel - use C implementation for setkey()
> reproduce: make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted __be64
>>> arch/x86/crypto/ghash-clmulni-intel_glue.c:72:25: sparse: cast to restricted __be64
>

Sigh.

The sparse warnings /without/ the be64 casts are even worse.

The obvious fix is not to use a be128 for the key, as it is obviously
an opaque type that just represents a byte array.
So, Herbert, if you prefer, I can rework this patch to use be128
instead of u128 inside struct ghash_ctx, but it will have some fallout
throughout the file. Or instead, we cast to '__force __be64',
basically just telling sparse to shut up ...

Regards,
Ard.


> vim +71 arch/x86/crypto/ghash-clmulni-intel_glue.c
>
>     65          }
>     66
>     67          /* perform multiplication by 'x' in GF(2^128) */
>     68          a = be64_to_cpu(x->a);
>     69          b = be64_to_cpu(x->b);
>     70
>   > 71          ctx->shash.a = (__be64)((b << 1) | (a >> 63));
>   > 72          ctx->shash.b = (__be64)((a << 1) | (b >> 63));
>     73
>     74          if (a >> 63)
>     75                  ctx->shash.b ^= cpu_to_be64(0xc2);
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
