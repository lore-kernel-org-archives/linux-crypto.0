From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/8] crypto: arm64+generic - SHA3/SHA-512/SM-3 roundup
Date: Mon, 22 Jan 2018 15:54:42 +0100
Message-ID: <CAK8P3a0HCr2zm40kqZWLCV=qPFkmAVDa5gDDKVU381pA3BjEHA@mail.gmail.com>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:43680 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeAVOyn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 09:54:43 -0500
Received: by mail-oi0-f53.google.com with SMTP id t16so6072065oif.10
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2018 06:54:43 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 19, 2018 at 1:04 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> This supersedes all outstanding patches from me related to SHA-3, SHA-512
> or SM-3.
>
> - fix a correctness issue in the SHA-3 code (#1) and a performance issue (#2),
>   the first one is definitely a -stable candidate, the second one potentially
>   as well
> - patches #3 and #4 make the generic SHA-3 code reusable as a fallback for the
>   accelerated code introduced in #6
> - patch #5 adds some SHA-3 test cases
> - patch #6 implements SHA-3 using special arm64 instructions
> - patch #7 implements the Chinese SM3 secure hash algorithm using special
>   arm64 instructions
> - patch #8 contains some fixes for the recently queued SHA-512 arm64 code.
>
> Ard Biesheuvel (8):
>   crypto/generic: sha3 - fixes for alignment and big endian operation
>   crypto/generic: sha3: rewrite KECCAK transform to help the compiler
>     optimize
>   crypto/generic: sha3 - simplify code
>   crypto/generic: sha3 - export init/update/final routines
>   crypto/testmgr: sha3 - add new testcases
>   crypto/arm64: sha3 - new v8.2 Crypto Extensions implementation
>   crypto/arm64: sm3 - new v8.2 Crypto Extensions implementation
>   crypto/arm64: sha512 - fix/improve new v8.2 Crypto Extensions code

I can confirm that patch 8 fixes the issues I saw earlier, it would be
good to have that merged quickly.

I'm doing a little more randconfig build testing here now, will write back by
the end of today in the unlikely case that if I find anything else wrong.

      Arnd
