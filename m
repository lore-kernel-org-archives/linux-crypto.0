From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Mon, 2 Jan 2017 12:35:03 +0530
Message-ID: <CAHv-k_8RAvNt5RC1uJg=he-8dOSmH=f5X83i3h6WYJ47FjL+7g@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com> <20161222085509.GA2160@gondor.apana.org.au>
 <CAHv-k_-EKq2g=Wb+YkPVp9gCXTDEyrxZhQpT5JMSw=WtZ1OC9w@mail.gmail.com>
 <20161223075114.GA3580@gondor.apana.org.au> <CAHv-k_9SynECq7qDbrW59=LsV_WNj+9Ffa=6tATyNKOt36he6Q@mail.gmail.com>
 <20161230102723.GA15713@gondor.apana.org.au> <CAHv-k_8FmeKk_3zUAVCqHp82nHmiWsyfZ_BW+z=SC5VVOrFsAA@mail.gmail.com>
 <20170102065325.GA19553@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34788 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755063AbdABHFE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2017 02:05:04 -0500
Received: by mail-ua0-f179.google.com with SMTP id 34so256279588uac.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jan 2017 23:05:04 -0800 (PST)
In-Reply-To: <20170102065325.GA19553@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 January 2017 at 12:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jan 02, 2017 at 12:16:45PM +0530, Binoy Jayan wrote:
>>
>> Even if ciphers are allocated this way, all the encryption requests
>> for cbc should still go through IV generators? So that should mean,
>> create one instance of IV generator using 'crypto_alloc_skcipher'
>> and create tfms_count instances of the generator depending on the
>> number of keys.
>
> Right.  The actual number of underlying tfms that do the work
> won't change compared to the status quo.  We're just structuring
> it such that if the overall scheme is supported by the hardware
> then we can feed more than one sector at a time to it.

Thank you Herbert.
