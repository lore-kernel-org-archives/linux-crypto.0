From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] compiler-gcc.h: __nostackprotector needs gcc-4.4 and up
Date: Thu, 1 Feb 2018 16:29:53 +0100
Message-ID: <CAK8P3a1kW=c0p6wnNMu_85z4Rq1aRA02+mqRYkhnGTsuXsVjmw@mail.gmail.com>
References: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
 <1517480520-4465-2-git-send-email-geert@linux-m68k.org> <CAK8P3a1Tm7zJf1VEGFPmhwqS=h92=_ssfAENJcrmxGg0eJCqnA@mail.gmail.com>
 <CAMuHMdWHZMxRg91LVz6n1GsM+6jezdzzfnDtBTXixHh=Updt5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Li <sparse@chrisli.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:46052 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbeBAP3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 10:29:55 -0500
In-Reply-To: <CAMuHMdWHZMxRg91LVz6n1GsM+6jezdzzfnDtBTXixHh=Updt5A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 1, 2018 at 12:55 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Arnd,
>
> On Thu, Feb 1, 2018 at 12:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Feb 1, 2018 at 11:21 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> Gcc versions before 4.4 do not recognize the __optimize__ compiler
>>> attribute:

>
> And we might want to remove the dummy in include/linux/compiler_types.h:
>
> #ifndef __nostackprotector
> # define __nostackprotector
> #endif
>
> BTW, how does this work with non-gcc compilers?

clang should in theory accept the same flags, and it pretends to be an older
version of gcc.

I don't think anyone cares about ICC or any other compiler.

    Arnd
