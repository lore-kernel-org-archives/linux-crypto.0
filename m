Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA5C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 08:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAEF60EB0
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 08:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244570AbhH0Igp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 04:36:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54412 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244471AbhH0Igp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 04:36:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mJXKd-0007Ya-3Y; Fri, 27 Aug 2021 16:35:23 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mJXKT-0005ch-By; Fri, 27 Aug 2021 16:35:13 +0800
Date:   Fri, 27 Aug 2021 16:35:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Subject: Re: [PATCH 0/2] add AES-NI/AVX2/x86_64 implementation
Message-ID: <20210827083513.GB21571@gondor.apana.org.au>
References: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 18, 2021 at 11:31:15AM +0800, Tianjia Zhang wrote:
> This patchsets exported some of the common functions implemented by
> the SM4 AESNI/AVX algorithm, and reused these functions to achieve
> the acceleration of AESNI/AVX2 implementation.
> 
> The main algorithm implementation comes from SM4 AES-NI work by
> libgcrypt and Markku-Juhani O. Saarinen at:
> https://github.com/mjosaarinen/sm4ni
> 
> Benchmark on Intel i5-6200U 2.30GHz, performance data of three
> implementation methods, pure software sm4-generic, aesni/avx
> acceleration, and aesni/avx2 acceleration, the data comes from
> the 218 mode and 518 mode of tcrypt. The abscissas are blocks of
> different lengths. The data is tabulated and the unit is Mb/s:
> 
> block-size  |    16      64     128     256    1024    1420    4096
> sm4-generic
>     ECB enc | 60.94   70.41   72.27   73.02   73.87   73.58   73.59
>     ECB dec | 61.87   70.53   72.15   73.09   73.89   73.92   73.86
>     CBC enc | 56.71   66.31   68.05   69.84   70.02   70.12   70.24
>     CBC dec | 54.54   65.91   68.22   69.51   70.63   70.79   70.82
>     CFB enc | 57.21   67.24   69.10   70.25   70.73   70.52   71.42
>     CFB dec | 57.22   64.74   66.31   67.24   67.40   67.64   67.58
>     CTR enc | 59.47   68.64   69.91   71.02   71.86   71.61   71.95
>     CTR dec | 59.94   68.77   69.95   71.00   71.84   71.55   71.95
> sm4-aesni-avx
>     ECB enc | 44.95  177.35  292.06  316.98  339.48  322.27  330.59
>     ECB dec | 45.28  178.66  292.31  317.52  339.59  322.52  331.16
>     CBC enc | 57.75   67.68   69.72   70.60   71.48   71.63   71.74
>     CBC dec | 44.32  176.83  284.32  307.24  328.61  312.61  325.82
>     CFB enc | 57.81   67.64   69.63   70.55   71.40   71.35   71.70
>     CFB dec | 43.14  167.78  282.03  307.20  328.35  318.24  325.95
>     CTR enc | 42.35  163.32  279.11  302.93  320.86  310.56  317.93
>     CTR dec | 42.39  162.81  278.49  302.37  321.11  310.33  318.37
> sm4-aesni-avx2
>     ECB enc | 45.19  177.41  292.42  316.12  339.90  322.53  330.54
>     ECB dec | 44.83  178.90  291.45  317.31  339.85  322.55  331.07
>     CBC enc | 57.66   67.62   69.73   70.55   71.58   71.66   71.77
>     CBC dec | 44.34  176.86  286.10  501.68  559.58  483.87  527.46
>     CFB enc | 57.43   67.60   69.61   70.52   71.43   71.28   71.65
>     CFB dec | 43.12  167.75  268.09  499.33  558.35  490.36  524.73
>     CTR enc | 42.42  163.39  256.17  493.95  552.45  481.58  517.19
>     CTR dec | 42.49  163.11  256.36  493.34  552.62  481.49  516.83
> 
> >From the benchmark data, it can be seen that when the block size is
> 1024, compared to AVX acceleration, the performance achieved by AVX2
> has increased by about 70%, it is also 7.7 times of the pure software
> implementation of sm4-generic.
> 
> Tianjia Zhang (2):
>   crypto: x86/sm4 - export reusable AESNI/AVX functions
>   crypto: x86/sm4 - add AES-NI/AVX2/x86_64 implementation
> 
>  arch/x86/crypto/Makefile                |   3 +
>  arch/x86/crypto/sm4-aesni-avx2-asm_64.S | 497 ++++++++++++++++++++++++
>  arch/x86/crypto/sm4-avx.h               |  24 ++
>  arch/x86/crypto/sm4_aesni_avx2_glue.c   | 169 ++++++++
>  arch/x86/crypto/sm4_aesni_avx_glue.c    |  92 +++--
>  crypto/Kconfig                          |  22 ++
>  6 files changed, 775 insertions(+), 32 deletions(-)
>  create mode 100644 arch/x86/crypto/sm4-aesni-avx2-asm_64.S
>  create mode 100644 arch/x86/crypto/sm4-avx.h
>  create mode 100644 arch/x86/crypto/sm4_aesni_avx2_glue.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
