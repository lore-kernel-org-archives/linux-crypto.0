From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: dm-crypt optimization
Date: Thu, 22 Dec 2016 13:55:59 +0530
Message-ID: <CAHv-k_-K9dOiM+Pm_wqVJrvmNYhjtS82-emKVZ8OjsoMHf+7hg@mail.gmail.com>
References: <CAHv-k_98w-9whFiCLAnTGL2QAirExsix_S8ZWc8tM7wj=gzD6Q@mail.gmail.com>
 <bf5e7237-2f5c-3fc6-c7d6-38c3b13ac2c3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, private-kwg@linaro.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:35262 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761600AbcLVI0B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 03:26:01 -0500
Received: by mail-ua0-f182.google.com with SMTP id 2so100928953uax.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2016 00:26:00 -0800 (PST)
In-Reply-To: <bf5e7237-2f5c-3fc6-c7d6-38c3b13ac2c3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Milan,

On 21 December 2016 at 18:17, Milan Broz <gmazyland@gmail.com> wrote:

> So the core problem is that your crypto accelerator can operate efficiently only
> with bigger batch sizes.

Thank you for the reply. Yes, that would be rather an improvement when having
bigger block sizes.

> How big blocks your crypto hw need to be able to operate more efficiently?
> What about 4k blocks (no batches), could it be usable trade-off?

The benchmark results for Qualcomm Snapdragon SoC's (mentioned below) show
significant improvement with 4K blocks but in batches of all such contiguous
segments in the block layer's request queue in the form of a chained
scatterlist.
However, it uses the algorithm 'aes-xts' instead of the conventional
'essiv-cbc-aes'
used in dm-crypt. Also, it uses the device mapper dm-req-crypt instead
of dm-cypt.

http://nelenkov.blogspot.in/2015/05/hardware-accelerated-disk-encryption-in.html
Section : 'Performance'

Its reports and IO rate of 46.3MB/s compared to an IO rate of 25.1MB/s while
using a software-based FDE (based on dm-crypt).  But I am not sure how genuine
this data is or how it was tested.

Since qualcomm SoC's use hardware backed keystore for managing keys and since
there is no easy way to make dm-crypt work with qualcomm's engines, I do not
have solid benchmark data to show an improved performance when using 4k blocks.

> With some (backward incompatible) changes in LUKS format I would like to see support
> for encryption blocks equivalent to sectors size, so it basically means for 4k drive 4k
> encryption block.
> (This should decrease overhead, now is everything processed on 512 blocks only.)
>
> Support of bigger block sizes would be unsafe without additional mechanism that provides
> atomic writes of multiple sectors. Maybe it applies to 4k as well on some devices though...)

Did you mean write to the crypto output buffers or the actual disk write?
I didn't quite understand how the block size for encryption affects atomic
writes as it is the block layer which handles them. As far as dm-crypt is,
concerned it just encrypts/decrypts a 'struct bio' instance and submits the IO
operation to the block layer.

> The above is not going against your proposal, I am just curious if this is enough
> to provide better performance on your hw accelerator or not.

May be I should be able to procure an open crypto board and get back to you with
some results. Or may be show even a marginal improvement while using software
algorithm by avoiding the crypto overhead for every 512 bytes.

-Binoy
