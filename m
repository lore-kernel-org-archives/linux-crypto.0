Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08780C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D43DB2073D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbfHBEzy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:55:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48678 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfHBEzy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:55:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPbE-0006IB-Tb; Fri, 02 Aug 2019 14:55:29 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPb9-0004ji-79; Fri, 02 Aug 2019 14:55:23 +1000
Date:   Fri, 2 Aug 2019 14:55:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        kasan-dev@googlegroups.com,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: jitterentropy: build without sanitizer
Message-ID: <20190802045523.GF18077@gondor.apana.org.au>
References: <20190724185207.4023459-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724185207.4023459-1-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 24, 2019 at 08:51:55PM +0200, Arnd Bergmann wrote:
> Recent clang-9 snapshots double the kernel stack usage when building
> this file with -O0 -fsanitize=kernel-hwaddress, compared to clang-8
> and older snapshots, this changed between commits svn364966 and
> svn366056:
> 
> crypto/jitterentropy.c:516:5: error: stack frame size of 2640 bytes in function 'jent_entropy_init' [-Werror,-Wframe-larger-than=]
> int jent_entropy_init(void)
>     ^
> crypto/jitterentropy.c:185:14: error: stack frame size of 2224 bytes in function 'jent_lfsr_time' [-Werror,-Wframe-larger-than=]
> static __u64 jent_lfsr_time(struct rand_data *ec, __u64 time, __u64 loop_cnt)
>              ^
> 
> I prepared a reduced test case in case any clang developers want to
> take a closer look, but from looking at the earlier output it seems
> that even with clang-8, something was very wrong here.
> 
> Turn off any KASAN and UBSAN sanitizing for this file, as that likely
> clashes with -O0 anyway.  Turning off just KASAN avoids the warning
> already, but I suspect both of these have undesired side-effects
> for jitterentropy.
> 
> Link: https://godbolt.org/z/fDcwZ5
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/Makefile | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
