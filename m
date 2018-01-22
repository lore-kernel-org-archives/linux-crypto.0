From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/8] crypto: arm64+generic - SHA3/SHA-512/SM-3 roundup
Date: Mon, 22 Jan 2018 21:51:42 +0100
Message-ID: <CAK8P3a2BaL_wYDRJ+O0Dntcz6XkunrdAE-xDKwSgSEruNJ=Hvg@mail.gmail.com>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org> <CAK8P3a0HCr2zm40kqZWLCV=qPFkmAVDa5gDDKVU381pA3BjEHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:41830 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbeAVUvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 15:51:43 -0500
Received: by mail-ot0-f180.google.com with SMTP id 44so8728621otk.8
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2018 12:51:43 -0800 (PST)
In-Reply-To: <CAK8P3a0HCr2zm40kqZWLCV=qPFkmAVDa5gDDKVU381pA3BjEHA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 22, 2018 at 3:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Jan 19, 2018 at 1:04 PM, Ard Biesheuvel
> I'm doing a little more randconfig build testing here now, will write back by
> the end of today in the unlikely case that if I find anything else wrong.

Did a few hundred randconfig builds, everything fine as expected.

       Arnd
