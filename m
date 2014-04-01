From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [crypto:master 60/60] arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25:
 sparse: cast to restricted __be64
Date: Tue, 1 Apr 2014 14:43:47 +0200
Message-ID: <CAKv+Gu_gWzRKRZ59PAOwrWwzwtm2VG4sJzUwAq-fy8Qy+Sn2=A@mail.gmail.com>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
	<CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45981 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaDAMnt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2014 08:43:49 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so6728738lbi.8
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2014 05:43:47 -0700 (PDT)
In-Reply-To: <CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1 April 2014 14:37, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 1 April 2014 13:23, kbuild test robot <fengguang.wu@intel.com> wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
>> head:   8ceee72808d1ae3fb191284afc2257a2be964725
>> commit: 8ceee72808d1ae3fb191284afc2257a2be964725 [60/60] crypto: ghash-clmulni-intel - use C implementation for setkey()
>> reproduce: make C=1 CF=-D__CHECK_ENDIAN__
>>
>>
>> sparse warnings: (new ones prefixed by >>)
>>
>>>> arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted __be64
>>>> arch/x86/crypto/ghash-clmulni-intel_glue.c:72:25: sparse: cast to restricted __be64
>>
>
> Sigh.
>
> The sparse warnings /without/ the be64 casts are even worse.
>
> The obvious fix is not to use a be128 for the key, as it is obviously
> an opaque type that just represents a byte array.
> So, Herbert, if you prefer, I can rework this patch to use be128
> instead of u128 inside struct ghash_ctx, but it will have some fallout

Sorry, I meant 'use u128 instead of be128'

> throughout the file. Or instead, we cast to '__force __be64',
> basically just telling sparse to shut up ...
>

-- 
Ard.


>> vim +71 arch/x86/crypto/ghash-clmulni-intel_glue.c
>>
>>     65          }
>>     66
>>     67          /* perform multiplication by 'x' in GF(2^128) */
>>     68          a = be64_to_cpu(x->a);
>>     69          b = be64_to_cpu(x->b);
>>     70
>>   > 71          ctx->shash.a = (__be64)((b << 1) | (a >> 63));
>>   > 72          ctx->shash.b = (__be64)((a << 1) | (b >> 63));
>>     73
>>     74          if (a >> 63)
>>     75                  ctx->shash.b ^= cpu_to_be64(0xc2);
>>
>> ---
>> 0-DAY kernel build testing backend              Open Source Technology Center
>> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
