From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 6/7] crypto: aes - split off shared AES tables and key
 expansion routines
Date: Sun, 26 Mar 2017 21:11:43 +0100
Message-ID: <CAKv+Gu9aNFs3J28ZZ-gXxbnULOwseBRhWhABaYgMyrrCo2bLDg@mail.gmail.com>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
 <1490554148-10953-7-git-send-email-ard.biesheuvel@linaro.org> <alpine.LFD.2.20.1703261542360.2304@knanqh.ubzr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers3@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:33703 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdCZUMN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 16:12:13 -0400
Received: by mail-it0-f44.google.com with SMTP id 76so395910itj.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 13:11:44 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.20.1703261542360.2304@knanqh.ubzr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26 March 2017 at 20:50, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sun, 26 Mar 2017, Ard Biesheuvel wrote:
>
>> [...]
>> +static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
>
> You could consider using u8 for this table. This is a tiny space saving
> and normally it shouldn't make the runtime any slower on most
> architectures.
>

There is no performance concern here: this variable is only used by
the key expansion routine. I'll propose to change it at the next
occasion
