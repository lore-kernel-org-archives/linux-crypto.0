From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/3] crypto: time invariant AES for CCM (and CMAC/XCBC)
Date: Sat, 11 Feb 2017 18:05:26 +0000
Message-ID: <CAKv+Gu-ONMC-5gstC4A0HCBSEsRf_wexw7pYk8Zmd3YE3Y67xQ@mail.gmail.com>
References: <1486133377-23290-1-git-send-email-ard.biesheuvel@linaro.org> <20170211105339.GE855@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35103 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdBKSF1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 13:05:27 -0500
Received: by mail-io0-f174.google.com with SMTP id j18so69504293ioe.2
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2017 10:05:27 -0800 (PST)
In-Reply-To: <20170211105339.GE855@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 February 2017 at 10:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Feb 03, 2017 at 02:49:34PM +0000, Ard Biesheuvel wrote:
>> This series is primarily directed at improving the performance and security
>> of CCM on the Rasperry Pi 3. This involves splitting the MAC handling of
>> CCM into a separate driver so that we can efficiently replace it by something
>> else using the ordinary algo resolution machinery.
>>
>> Patch #1 adds some testcases for cbcmac(aes), which will be introduced later.
>>
>> Patch #2 replaces the open coded CBC MAC hashing routines in the CCM driver
>> with calls to a cbcmac() hash, and implements a template for producing such
>> cbcmac transforms. This eliminates all the fuzzy scatterwalk code as well.
>>
>> Patch #3 implements cbcmac(aes) using NEON on arm64, and CMAC/XCBC at the
>> same time, since it is trivially implemented reusing the same core transform
>
> All applied.  Please send any fixups on top of these patches.

Thanks Herbert. I do have a fixup for #2, which currently does not
correctly take the alignmask of the MAC's subordinate cipher into
account. I will send a fix for that shortly.
