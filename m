From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v5] IV Generation algorithms for dm-crypt
Date: Thu, 13 Apr 2017 14:16:43 +0530
Message-ID: <CAHv-k_98gM8Je+Yi5+Yj5s=6-qxNuuYY1x=ypy_dk6gL=WqyKg@mail.gmail.com>
References: <1491562064-23591-1-git-send-email-binoy.jayan@linaro.org> <774a9713-05ef-0162-0203-461254a04f6e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>, Gilad <gilad@benyossef.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34257 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdDMIqu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 04:46:50 -0400
Received: by mail-vk0-f45.google.com with SMTP id z204so25100674vkd.1
        for <linux-crypto@vger.kernel.org>; Thu, 13 Apr 2017 01:46:45 -0700 (PDT)
In-Reply-To: <774a9713-05ef-0162-0203-461254a04f6e@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Milan,

On 10 April 2017 at 19:30, Milan Broz <gmazyland@gmail.com> wrote:

Thank you for the reply.

> Well, it is good that there is no performance degradation but it
> would be nice to have some user of it that proves it is really
> working for your hw.

I have been able to get access to a hardware with IV generation support
a few days back. The hardware I was having before did not have IV
generation support. Will be able to come up with numbers after making
it work with the new one.

> FYI - with patch that increases dmcrypt sector size to 4k
> I can see improvement in speed usually in 5-15% with sync AES-NI
> (depends on access pattern), with dmcrypt mapped to memory
> it is even close to 20% speed up (but such a configuration is
> completely artificial).
>
> I wonder why increased dmcrypt sector size does not work for your hw,
> it should help as well (and can be combiuned later with this IV approach).
> (For native 4k drives this should be used in future anyway...)

I think it should work well too with backward incompatibility.

Thanks,
Binoy
