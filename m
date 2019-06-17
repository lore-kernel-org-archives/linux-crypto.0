Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7B8C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 15:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB86208CB
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 15:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFQPXG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:23:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46023 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfFQPXG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 11:23:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so11115595qtr.12;
        Mon, 17 Jun 2019 08:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrEZUkFuELLhw0pt018loVt7YnupXDtD8eAxix9mLHM=;
        b=WZT0xngbF/Mz5KGVFnYoznoCXQGb/eAHf4/UJfqoyvktiTPcQNgwM8j3a71a8BpJA0
         sH7gsAuUdd8EKsqjS1l9zADW7maM+r25vm26dS7IJA9JcthuBz2ewFCTVf5nYu//n/RE
         He4Idtt0eIzRIrlHzVar2oJ/3zVmPWo+5M2m/Oa8ilfp8Dm2dXOprEK3Y+CF+mw9GV88
         873yncgGHNbk9WRMpBIxO7Lqy2HblXhfLeA6JdGFOzz6LRaMMze1wkmsmhP+dGaMP5Tj
         0UACaE0tkbI5gEc6uHmF0WZXFg0EisT8mKR22bcxwLnoGL5Vk5F9kLmuC3ID3v4qUh2E
         2rUA==
X-Gm-Message-State: APjAAAWhcS0m1y++Vy/FH9JezRqEK1bdUZMR6j+QYy22ZIwR6B1gXQXj
        f4Iyrq4YPmMt7IWg4j79sS2Hky5Hxe/No6s6enc=
X-Google-Smtp-Source: APXvYqwdOCztB/HaPoHrVI4jezpNp3+qJM2SQ/2flC+wy6HEK6Ecu5v5vGFmMesw/QXPvfW0xI+P1XEXys1SUckw5CI=
X-Received: by 2002:aed:2bc1:: with SMTP id e59mr74620252qtd.7.1560784984951;
 Mon, 17 Jun 2019 08:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190617132343.2678836-1-arnd@arndb.de> <20190617140435.qjzcouaqzepaicf4@gondor.apana.org.au>
 <CAK8P3a07Vcqs+6Rs2Ckq_itWfGKUv+_pdgdis9eSujCGHQgFkQ@mail.gmail.com>
 <20190617142419.yw4w5w344tf6ozrb@gondor.apana.org.au> <CAK8P3a0G2K4u-Sh495O7_nfc6zydtZBTOJcq19g3YYQA2ZMKFA@mail.gmail.com>
 <20190617145624.p6alck5m6bqaswgp@gondor.apana.org.au>
In-Reply-To: <20190617145624.p6alck5m6bqaswgp@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 17 Jun 2019 17:22:47 +0200
Message-ID: <CAK8P3a1e4RGZGD3Ww8ym5iXdt7v8GPxY29jywNnZ-Wx51L-beQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 4:56 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 17, 2019 at 04:54:16PM +0200, Arnd Bergmann wrote:
> >
> > Just converting the three testvec_config variables is what I originally
> > had in my patch. It got some configurations below the warning level,
> > but some others still had the problem. I considered sending two
> > separate patches, but as the symptom was the same, I just folded
> > it all into one patch that does the same thing in four functions.
>
> Just curious, how bad is it with only moving testvec_config off
> the stack?

I tried setting the warning limit to 256 now. On the original code I get
crypto/testmgr.c:2816:12: error: stack frame size of 984 bytes in
function 'alg_test_skcipher'
crypto/testmgr.c:2273:12: error: stack frame size of 1032 bytes in
function 'alg_test_aead'
crypto/testmgr.c:3267:12: error: stack frame size of 576 bytes in
function 'alg_test_crc32c'
crypto/testmgr.c:3811:12: error: stack frame size of 280 bytes in
function 'alg_test_akcipher'
crypto/testmgr.c:2798:12: error: stack frame size of 600 bytes in
function 'test_skcipher'
crypto/testmgr.c:2413:12: error: stack frame size of 352 bytes in
function 'test_skcipher_vec_cfg'
crypto/testmgr.c:2255:12: error: stack frame size of 600 bytes in
function 'test_aead'
crypto/testmgr.c:1823:12: error: stack frame size of 368 bytes in
function 'test_aead_vec_cfg'
crypto/testmgr.c:1694:12: error: stack frame size of 1408 bytes in
function '__alg_test_hash'

Just removing the testvec_config reduces the size of the largest three functions
by some 350 bytes, but I still get a warning for __alg_test_hash in some
configurations with the default 1024 byte limit:

crypto/testmgr.c:2837:12: error: stack frame size of 632 bytes in
function 'alg_test_skcipher'
crypto/testmgr.c:2287:12: error: stack frame size of 688 bytes in
function 'alg_test_aead'
crypto/testmgr.c:3288:12: error: stack frame size of 576 bytes in
function 'alg_test_crc32c'
crypto/testmgr.c:3832:12: error: stack frame size of 280 bytes in
function 'alg_test_akcipher'
crypto/testmgr.c:2819:12: error: stack frame size of 600 bytes in
function 'test_skcipher'
crypto/testmgr.c:2427:12: error: stack frame size of 352 bytes in
function 'test_skcipher_vec_cfg'
crypto/testmgr.c:2269:12: error: stack frame size of 600 bytes in
function 'test_aead'
crypto/testmgr.c:1830:12: error: stack frame size of 368 bytes in
function 'test_aead_vec_cfg'
crypto/testmgr.c:1701:12: error: stack frame size of 1088 bytes in
function '__alg_test_hash'

With the patch I posted, the last line goes down to 712:

crypto/testmgr.c:1709:12: error: stack frame size of 712 bytes in
function '__alg_test_hash'

In other subsystems, the numbers tend to be much smaller than in the crypto
code. I think a lot of that is inherent in the way the subsystem is designed,
but it also seems a little dangerous.

        Arnd
