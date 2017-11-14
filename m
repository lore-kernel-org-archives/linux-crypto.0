From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 07/24] staging: ccree: remove unneeded cast
Date: Tue, 14 Nov 2017 11:30:26 +0200
Message-ID: <CAOtvUMdQeTWrUvJ-nPi3aPh3GNtpkRB60S1GSb4jW4h=iWXOMQ@mail.gmail.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
 <1510584358-29473-8-git-send-email-gilad@benyossef.com> <1510587714.10883.73.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:48472 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbdKNJa2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 04:30:28 -0500
Received: by mail-ot0-f170.google.com with SMTP id b49so12721522otj.5
        for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2017 01:30:27 -0800 (PST)
In-Reply-To: <1510587714.10883.73.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 13, 2017 at 5:41 PM, Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2017-11-13 at 14:45 +0000, Gilad Ben-Yossef wrote:
> > Remove uneeded cast from writel_relaxed parameter.
> []
> > diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> []
> > @@ -167,13 +167,13 @@ static inline void enqueue_seq(
> >       int i;
> >
> >       for (i = 0; i < seq_len; i++) {
> > -             writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> > -             writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> > -             writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> > -             writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> > -             writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> > +             writel_relaxed(seq[i].word[0], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
>
> Maybe remove the now unnecessary parentheses around
>         (cc_case + CC_REG(foo))
>
> Maybe review the use of inline in .c files too
>
> $ git grep -w inline drivers/staging/ccree/*.c | wc -l
> 41
>

Thanks, will do both.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
