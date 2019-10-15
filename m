Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BACECE58E
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 378962089C
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfJOKIS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:08:18 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:50816 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfJOKIR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 06:08:17 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 06:08:17 EDT
Received: from book (unknown [IPv6:2a01:2a8:8100:2001:c78:a6a8:6f3f:a6b3])
        by mail.strongswan.org (Postfix) with ESMTPSA id BE1994001D;
        Tue, 15 Oct 2019 12:00:49 +0200 (CEST)
Message-ID: <8021f3ad396dead64fca36cef018c914f9a3a55d.camel@strongswan.org>
Subject: Re: [PATCH v3 02/29] crypto: x86/chacha - depend on generic chacha
 library instead of crypto driver
From:   Martin Willi <martin@strongswan.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>
Date:   Tue, 15 Oct 2019 12:00:49 +0200
In-Reply-To: <20191007164610.6881-3-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
         <20191007164610.6881-3-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

> Since turning the FPU on and off is cheap these days, simplify the
> SIMD routine by dropping the per-page yield, which makes for a
> cleaner switch to the library API as well.

In my measurements that lazy FPU restore works as intended, and I could
not identify any slowdown by this change. 

> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -127,32 +127,32 @@ static int chacha_simd_stream_xor [...]
>  
> +	do_simd = (walk->total > CHACHA_BLOCK_SIZE) && crypto_simd_usable();

Given that most users (including chacha20poly1305) likely involve
multiple operations under the same (real) FPU save/restore cycle, those
length checks both in chacha and in poly1305 hardly make sense anymore.

Obviously under tcrypt we get better results when engaging SIMD for any
length, but also for real users this seems beneficial. But of course we
may defer that to a later optimization patch.

Thanks,
Martin

