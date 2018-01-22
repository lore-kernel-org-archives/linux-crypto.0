From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/8] crypto: arm64+generic - SHA3/SHA-512/SM-3 roundup
Date: Mon, 22 Jan 2018 20:59:19 +0000
Message-ID: <CAKv+Gu_56Bp+LPMdWoWZy_YHPvwJ+rS2nT0nO8nPwE45Fe_DrA@mail.gmail.com>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
 <CAK8P3a0HCr2zm40kqZWLCV=qPFkmAVDa5gDDKVU381pA3BjEHA@mail.gmail.com> <CAK8P3a2BaL_wYDRJ+O0Dntcz6XkunrdAE-xDKwSgSEruNJ=Hvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:42391 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbeAVU7V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 15:59:21 -0500
Received: by mail-it0-f42.google.com with SMTP id p139so11471275itb.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2018 12:59:20 -0800 (PST)
In-Reply-To: <CAK8P3a2BaL_wYDRJ+O0Dntcz6XkunrdAE-xDKwSgSEruNJ=Hvg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 January 2018 at 20:51, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Jan 22, 2018 at 3:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Jan 19, 2018 at 1:04 PM, Ard Biesheuvel
>> I'm doing a little more randconfig build testing here now, will write back by
>> the end of today in the unlikely case that if I find anything else wrong.
>
> Did a few hundred randconfig builds, everything fine as expected.
>

Thanks Arnd
