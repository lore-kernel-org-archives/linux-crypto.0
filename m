From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/2] hwrng: mtk: Add driver for hardware random generator
 on MT7623 SoC
Date: Fri, 14 Apr 2017 10:27:51 +0530
Message-ID: <CANc+2y4yrSbSqS5Ga6WXjQ9s9RkiptJ5XsN8EczS0wehxAXfGw@mail.gmail.com>
References: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
 <1492067108-14748-3-git-send-email-sean.wang@mediatek.com>
 <CANc+2y4Oj-sbSKnsTSK+kRYNewp7Pj0fEk_=dqULxWG08L77Eg@mail.gmail.com> <1492142296.6147.19.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        shannon.nelson@oracle.com, Wei Yongjun <weiyongjun1@huawei.com>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sean wang <keyhaede@gmail.com>
To: Sean Wang <sean.wang@mediatek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34534 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdDNE5w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 00:57:52 -0400
In-Reply-To: <1492142296.6147.19.camel@mtkswgap22>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14 April 2017 at 09:28, Sean Wang <sean.wang@mediatek.com> wrote:
>
> Hi PrasannaKumar,
>
> Add my comments inline
>
>>
>> Use readl_poll_timeout_atomic's return value or -EIO instead of
>> !!ready. This will simplify mtk_rng_read.
>>
>
> !!ready provided is in order to let blocking/non-blocking case could
> share same code path. And readl_poll_timeout_atomic only handles
> blocking case.

Missed this point. Makes sense. My previous comment about return value
in mtk_rng_read is invalid as I based it on a wrong assumption.

>
>> > +static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>> > +{
>> > +       struct mtk_rng *priv = to_mtk_rng(rng);
>> > +       int retval = 0;
>> > +
>> > +       while (max >= sizeof(u32)) {
>> > +               if (!mtk_rng_wait_ready(rng, wait))
>> > +                       break;
>> > +
>> > +               *(u32 *)buf = readl(priv->base + RNG_DATA);
>> > +               retval += sizeof(u32);
>> > +               buf += sizeof(u32);
>> > +               max -= sizeof(u32);
>> > +       }
>> > +
>> > +       if (unlikely(wait && max))
>> > +               dev_warn(priv->dev, "timeout might be not properly set\n");
>>
>> Is this really necessary? Better to choose proper timeout than
>> providing this warning message. In rare cases if the timeout could
>> occur due to some reason (may be a hardware fault) print appropriate
>> warning message.
>
> It is good, I will choose the proper timeout and remove the log in the
> next one.
>
>>
>> > +       return retval || !wait ? retval : -EIO;
>> > +}
>>
>> Set retavl to mtk_rng_wait_ready and return retval.
>>
>
> Maybe i didn't get your points exactly. Adding some explanation about
> thoughts here.
>
> "return retval || !wait ? retval : -EIO;" I use can also help handling
> the both cases in one line which i think is elegant enough.
>
> And retval is accumulated with each round if some data's existing in
> hardware, so we don't return the value from mtk_rng_wait_ready().

retval can be 0 only when mkt_rng_wait_ready fails, returning 0 when
wait is true is confusing. Expected return value when 0 bytes is read
from device and wait is true is not clearly documented.

"return retval || !wait ? retval : -EIO;" is also fine.

Overall the code looks good to me. You can add:
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>.

Regards,
PrasannaKumar
