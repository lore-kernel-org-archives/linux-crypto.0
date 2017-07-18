From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 18 Jul 2017 08:57:28 +0100
Message-ID: <CAKv+Gu-FAfcfAiPju_+X=3ZOC_NqGYo7DaMpx9YosH=OpWaVCw@mail.gmail.com>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170718052556.GA4532@gondor.apana.org.au> <CAKv+Gu_6Gw5dD7rnmL-AUUSFFC8W077F8FqDK7m_wYYUizmZFg@mail.gmail.com>
 <20170718071849.GA5536@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36310 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRH53 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 03:57:29 -0400
Received: by mail-io0-f177.google.com with SMTP id z62so9530443ioi.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 00:57:29 -0700 (PDT)
In-Reply-To: <20170718071849.GA5536@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 July 2017 at 08:18, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jul 18, 2017 at 07:32:41AM +0100, Ard Biesheuvel wrote:
>>
>> Because it is slower, and how much slower is architecture dependent
>> (if your arch has slow multiplication, aes-ti decryption will be dog
>> slow compared to aes-generic)
>
> Right, but does anybody actually care? My guess is that on such a
> platform aes-generic is going to be dog-slow anyway.
>

Could be, yes, but it is not trivial to find out.

>> Also, quite a few architectures have table based implementations that
>> reuse crypto_ft_tab/crypto_fl_tab etc so we'd need to factor out those
>> into a separate module if we were to remove aes-generic.
>
> You mean x86 and arm, right? Isn't the idea of your patch-set to allow
> aes-generic to be disabled on x86/arm, no?
>

Yes. The original aes-ti implemented encryption only, to provide
AES-CBCMAC, CMAC etc, i.e., algorithms that rely on encryption only,
and cannot be parallelized, the use case being 32-bit ARM, which has a
fast, NEON-based, time invariant implementation for parallel modes,
but had to fall back to the table based AES for the MAC part of CCM
etc. As suggested by Eric, AES-TI was converted into a full cipher,
allowing it to replace AES generic entirely. (I have documented the
rationale more elaborately here:
http://www.workofard.com/2017/02/time-invariant-aes/)

So if you care about security and/or the cache/memory footprint more
than about speed, you can disable the table based implementations that
exist for i586, x86, ARM and arm64 (all of which have faster and time
invariant implementations based on SIMD or special instructions
anyway, so for 95% of the cases, it does not really matter).

But I'd be happy to rework the code so that the small time invariant
routines implement the core AES code, fulfilling the existing
dependencies on CRYPTO_AES. Then, we could still provide AES generic
on top of that, or only expose the tables (I don't think we should
remove the x86/arm table based drivers altogether). This fits well
with my non-SIMD fallback changes for arm64, which invoke
crypto_aes_encrypt() directly (rather than going via
CRYPTO_ALG_NEED_FALLBACK resolution, which itself may produce another
SIMD based algo which requires a non-SIMD fallback itself)
