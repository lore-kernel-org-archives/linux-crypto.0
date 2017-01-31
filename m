From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/4] crypto: time invariant AES for CCM (and GCM/CTR)
Date: Tue, 31 Jan 2017 18:30:34 +0000
Message-ID: <CAKv+Gu9GXmMzHiOZE57xQEwoH4ib1dq7LZFPia=nr27bj_pdkg@mail.gmail.com>
References: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34267 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdAaSak (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2017 13:30:40 -0500
Received: by mail-io0-f169.google.com with SMTP id l66so138576962ioi.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2017 10:30:35 -0800 (PST)
In-Reply-To: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 January 2017 at 23:33, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This series is primarily directed at improving the performance and security
> of CCM on the Rasperry Pi 3. This involves splitting the MAC handling of
> CCM into a separate driver so that we can efficiently replace it by something
> else using the ordinary algo resolution machinery.
>
> Patch #1 adds some testcases for cbcmac(aes), which will be introduced later.
>
> Patch #2 replaces the open coded CBC MAC hashing routines in the CCM driver
> with calls to a cbcmac() hash, and implements a template for producing such
> transforms. This eliminates all the fuzzy scatterwalk code as well.
>
> Patch #3 implements cbcmac(aes) using NEON on arm64
>
> Patch #4 is an RFC patch that implements ctr(aes) and cbcmac(aes) in a way
> that is intended to eliminate observeable data dependent latencies in AES
> processing, by replacing the usual 16 KB of lookup tables with a single
> Sbox that is prefetched before processing each block. It is 50% slower than
> generic AES, but this may be acceptable in many cases.
>
> Changes since v1:
> - remove ilen, and add missing flags assignment (#2)
> - deal with zero cryptlen (#2)
> - use correctly sized dg[] array in desc ctx (#3, #4)
> - fix bug in update routine (#3)
> - various other tweaks
>
> Ard Biesheuvel (4):
>   crypto: testmgr - add test cases for cbcmac(aes)
>   crypto: ccm - switch to separate cbcmac driver
>   crypto: arm64/aes - add NEON and Crypto Extension CBC-MAC driver
>   crypto: aes - add generic time invariant AES for CTR/CCM/GCM
>

I have updated versions of these that make use of the alignment
agnostic crypto_xor(). I will respin these once that patch gets
discussed/merged/rejected/etc
