Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E40C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 20:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B730207BB
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 20:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgHTUK6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 16:10:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49320 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgHTUK6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 16:10:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8qtk-0001j7-1U; Fri, 21 Aug 2020 06:10:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 06:10:55 +1000
Date:   Fri, 21 Aug 2020 06:10:55 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200820201055.GA24119@gondor.apana.org.au>
References: <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au>
 <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au>
 <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
 <20200820074414.GA21848@gondor.apana.org.au>
 <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
 <20200820075353.GA21901@gondor.apana.org.au>
 <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
 <6bd84823-7dc6-e132-2959-e73d6806d2f1@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bd84823-7dc6-e132-2959-e73d6806d2f1@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 20, 2020 at 06:54:58AM -0700, Ben Greear wrote:
>
> Here's a run on an:  Intel(R) Core(TM) i7-7700T CPU @ 2.90GHz
> 
>                testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
>
> [  259.397910] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   8442 cycles/operation,    8 cycles/byte
>
>                testing speed of async cmac(aes-generic) (cmac(aes-generic))
>
> [  294.171530] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   9022 cycles/operation,    8 cycles/byte
> 
> On my slow apu2 board with processor: AMD GX-412TC SOC
> 
>               testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
>
> [   51.751810] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  18759 cycles/operation,   18 cycle
>
>               testing speed of async cmac(aes-generic) (cmac(aes-generic))
>
> [   97.837497] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  31365 cycles/operation,   30 cycle

So clearly aes-generic is slower than aes-aesni even with saving and
restoring for each block.  Therefore improving the performance of
the latter per se does not make sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
