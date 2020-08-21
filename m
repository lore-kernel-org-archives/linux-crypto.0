Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A57C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 03:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CD220714
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 03:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHUDzK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 23:55:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49752 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgHUDzF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 23:55:05 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8y8l-00007s-2V; Fri, 21 Aug 2020 13:54:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 13:54:55 +1000
Date:   Fri, 21 Aug 2020 13:54:55 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Felipe Balbi <balbi@kernel.org>
Subject: Re: [build break] aegis128-neon-inner.c fails to build on v5.9-rc1
Message-ID: <20200821035454.GA25551@gondor.apana.org.au>
References: <87ft8l1nuo.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft8l1nuo.fsf@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 17, 2020 at 03:03:11PM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> I'm not sure if there's already a patch for this, but I notices arm64
> allmodconfig fails to build with GCC 10.2 as shown below:
> 
> crypto/aegis128-neon-inner.c: In function 'crypto_aegis128_init_neon':
> crypto/aegis128-neon-inner.c:151:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
>   151 |   k ^ vld1q_u8(const0),
>       |   ^
> crypto/aegis128-neon-inner.c:152:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
>   152 |   k ^ vld1q_u8(const1),
>       |   ^
> crypto/aegis128-neon-inner.c:147:29: warning: missing braces around initializer [-Wmissing-braces]
>   147 |  struct aegis128_state st = {{
>       |                             ^
> ......
>   151 |   k ^ vld1q_u8(const0),
>       |   {
>   152 |   k ^ vld1q_u8(const1),
>   153 |  }};
>       |  }
> 
> Confirmation of GCC version follows:
> 
> $ aarch64-linux-gnu-gcc --version
> aarch64-linux-gnu-gcc (GCC) 10.2.0
> Copyright (C) 2020 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Ard, can you please take a look at this?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
