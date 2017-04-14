From: Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH 2/2] hwrng: mtk: Add driver for hardware random
 generator on MT7623 SoC
Date: Fri, 14 Apr 2017 11:58:16 +0800
Message-ID: <1492142296.6147.19.camel@mtkswgap22>
References: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
         <1492067108-14748-3-git-send-email-sean.wang@mediatek.com>
         <CANc+2y4Oj-sbSKnsTSK+kRYNewp7Pj0fEk_=dqULxWG08L77Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        "Romain Perier" <romain.perier@free-electrons.com>,
        <shannon.nelson@oracle.com>,
        "Wei Yongjun" <weiyongjun1@huawei.com>,
        <devicetree@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:49951 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751544AbdDND6X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 23:58:23 -0400
In-Reply-To: <CANc+2y4Oj-sbSKnsTSK+kRYNewp7Pj0fEk_=dqULxWG08L77Eg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi PrasannaKumar,

Add my comments inline


On Thu, 2017-04-13 at 14:09 +0530, PrasannaKumar Muralidharan wrote:
> Hi Sean,
> 
> Mostly looks good, have few minor comments.
> 
> On 13 April 2017 at 12:35,  <sean.wang@mediatek.com> wrote:
> > +static bool mtk_rng_wait_ready(struct hwrng *rng, bool wait)
> > +{
> > +       struct mtk_rng *priv = to_mtk_rng(rng);
> > +       int ready;
> > +
> > +       ready = readl(priv->base + RNG_CTRL) & RNG_READY;
> > +       if (!ready && wait)
> > +               readl_poll_timeout_atomic(priv->base + RNG_CTRL, ready,
> > +                                         ready & RNG_READY, USEC_POLL,
> > +                                         TIMEOUT_POLL);
> > +       return !!ready;
> > +}
> 
> Use readl_poll_timeout_atomic's return value or -EIO instead of
> !!ready. This will simplify mtk_rng_read.
> 

!!ready provided is in order to let blocking/non-blocking case could
share same code path. And readl_poll_timeout_atomic only handles
blocking case.



> > +static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > +{
> > +       struct mtk_rng *priv = to_mtk_rng(rng);
> > +       int retval = 0;
> > +
> > +       while (max >= sizeof(u32)) {
> > +               if (!mtk_rng_wait_ready(rng, wait))
> > +                       break;
> > +
> > +               *(u32 *)buf = readl(priv->base + RNG_DATA);
> > +               retval += sizeof(u32);
> > +               buf += sizeof(u32);
> > +               max -= sizeof(u32);
> > +       }
> > +
> > +       if (unlikely(wait && max))
> > +               dev_warn(priv->dev, "timeout might be not properly set\n");
> 
> Is this really necessary? Better to choose proper timeout than
> providing this warning message. In rare cases if the timeout could
> occur due to some reason (may be a hardware fault) print appropriate
> warning message.

It is good, I will choose the proper timeout and remove the log in the
next one.

> 
> > +       return retval || !wait ? retval : -EIO;
> > +}
> 
> Set retavl to mtk_rng_wait_ready and return retval.
> 

Maybe i didn't get your points exactly. Adding some explanation about
thoughts here.

"return retval || !wait ? retval : -EIO;" I use can also help handling
the both cases in one line which i think is elegant enough. 

And retval is accumulated with each round if some data's existing in
hardware, so we don't return the value from mtk_rng_wait_ready().


> Regards,
> Prasanna

thanks for all your reviewing and suggestion

	Sean
