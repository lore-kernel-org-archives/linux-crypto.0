From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 18 Jul 2017 07:32:41 +0100
Message-ID: <CAKv+Gu_6Gw5dD7rnmL-AUUSFFC8W077F8FqDK7m_wYYUizmZFg@mail.gmail.com>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org> <20170718052556.GA4532@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36541 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdGRGcm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 02:32:42 -0400
Received: by mail-io0-f180.google.com with SMTP id z62so8662566ioi.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 23:32:42 -0700 (PDT)
In-Reply-To: <20170718052556.GA4532@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 July 2017 at 06:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jun 20, 2017 at 11:28:53AM +0200, Ard Biesheuvel wrote:
>> The generic AES driver uses 16 lookup tables of 1 KB each, and has
>> encryption and decryption routines that are fully unrolled. Given how
>> the dependencies between this code and other drivers are declared in
>> Kconfig files, this code is always pulled into the core kernel, even
>> if it is usually superseded at runtime by accelerated drivers that
>> exist for many architectures.
>
> Why can't we simply replace aes-generic with aes-ti?
>

Because it is slower, and how much slower is architecture dependent
(if your arch has slow multiplication, aes-ti decryption will be dog
slow compared to aes-generic)

Also, quite a few architectures have table based implementations that
reuse crypto_ft_tab/crypto_fl_tab etc so we'd need to factor out those
into a separate module if we were to remove aes-generic.
