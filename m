From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Thu, 5 Jan 2017 11:36:52 +0530
Message-ID: <CAHv-k_9G=iWe_CWNEcKxq0Q1=XhUAPDE88NvvkCOu5q=pNSgrA@mail.gmail.com>
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
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36539 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967208AbdAEGGz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Jan 2017 01:06:55 -0500
Received: by mail-vk0-f53.google.com with SMTP id p9so296452683vkd.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Jan 2017 22:06:55 -0800 (PST)
In-Reply-To: <20170102065325.GA19553@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 2 January 2017 at 12:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jan 02, 2017 at 12:16:45PM +0530, Binoy Jayan wrote:
>
> Right.  The actual number of underlying tfms that do the work
> won't change compared to the status quo.  We're just structuring
> it such that if the overall scheme is supported by the hardware
> then we can feed more than one sector at a time to it.

I was thinking of continuing to have the iv generation algorithms as template
ciphers instead of regular 'skcipher' as it is easier to inherit the parameters
from the underlying cipher (e.g. aes) like cra_blocksize, cra_alignmask,
ivsize, chunksize etc.

Usually, the underlying cipher for the template ciphers are instantiated
in the following function:

skcipher_instance:skcipher_alg:init()

Since the number of such cipher instances depend on the key count, which is
not known at the time of creation of the cipher (it's passed to as an argument
to the setkey api), the creation of those have to be delayed until the setkey
operation of the template cipher. But as Mark pointed out, the users of this
cipher may get confused if the creation of the underlying cipher fails while
trying to do a 'setkey' on the template cipher. I was wondering if I can create
a single instance of the cipher and assign it to tfms[0] and allocate the
remaining instances when the setkey operation is called later with the encoded
key_count so that errors during cipher creation are uncovered earlier.

Thanks,
Binoy
