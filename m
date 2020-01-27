Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681F8C32771
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 08:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43128214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 08:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgA0IDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 03:03:31 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35358 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0IDb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 03:03:31 -0500
Received: by mail-oi1-f194.google.com with SMTP id b18so1888594oie.2;
        Mon, 27 Jan 2020 00:03:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgXdDYkIY4+UUqK2Dq+7mVKD4OIm8lXoJ8rViIw8xNg=;
        b=gM3G5XE/slCfRMJXxCtiKdpCE3MI2MdeUID3tZjdFSB0TWT8dJnfY+uAqshw2RcOGa
         XFdGJxA9fApeiti/PQxrfPUWHW5iitMxESIxfWhZGSocMZ5GC92ugF3Aeun/wl/wrNZ9
         HKZ0teIdxyhcgeMycs/SlGRikybeyHeaCs7YmIzm+5K6tmVtngfmezSQk4sup4OSocL5
         gVBgilZJ+5RhR9QYnScMGAXfVFFykEtzI7VwEh+QoL+OHiDLE+5DweW1+/HtK7Q1ek4I
         OFpCwJYQ5tUTd5mgt+KF6QPv9Zy36LotAY8P9AuS0fri6PNe8B3A79EFMqcnNs4tPGGd
         0xiA==
X-Gm-Message-State: APjAAAXqOhBrpmHRnb/vCFBNlUjU4YafG8eNfolIXwUtBpPHxFueSO3Q
        slhbFy+G+FSzyLTQQNvBqe7uljUHuiXSON0wSQlDh7m2
X-Google-Smtp-Source: APXvYqy0qdoCEfCJgb0TnjJLPz4hHSZ5XEbNqTVRatdAxLMHxYZWUQ+YeqIBg/KeEYWzfDRydhyJhTS1GPrz+FLhyLU=
X-Received: by 2002:a54:4707:: with SMTP id k7mr4863437oik.153.1580112210830;
 Mon, 27 Jan 2020 00:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20200126133805.20294-1-gilad@benyossef.com>
In-Reply-To: <20200126133805.20294-1-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Jan 2020 09:03:19 +0100
Message-ID: <CAMuHMdXHgMn8L2_CZ8kXcp3g4Y+3HfQsvFhyTZatf8-xk2kUdQ@mail.gmail.com>
Subject: Re: [RFC] crypto: ccree - protect against short scatterlists
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gilad,

On Sun, Jan 26, 2020 at 2:38 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Deal gracefully with the event of being handed a scatterlist
> which is shorter than expected.
>
> This mitigates a crash in some cases of crashes due to
> attempt to map empty (but not NULL) scatterlists with none
> zero lengths.
>
> This is an interim patch, to help diagnoze the issue, not
> intended for mainline in its current form as of yet.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for your patch!

Unfortunately this doesn't make a difference, as ...

> --- a/drivers/crypto/ccree/cc_buffer_mgr.c
> +++ b/drivers/crypto/ccree/cc_buffer_mgr.c
> @@ -286,10 +286,32 @@ static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
>         sgl_data->num_of_buffers++;
>  }
>
> +static unsigned int cc_sg_trunc_len(struct scatterlist *sg, unsigned int len)
> +{
> +       unsigned int total;
> +
> +       if (!len)
> +               return 0;
> +
> +       for (total = 0; sg; sg = sg_next(sg)) {
> +               total += sg->length;
> +               if (total >= len) {
> +                       total = len;
> +                       break;
> +               }
> +       }
> +
> +       return total;
> +}
> +
>  static int cc_map_sg(struct device *dev, struct scatterlist *sg,
>                      unsigned int nbytes, int direction, u32 *nents,
>                      u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
>  {
> +       int ret;
> +
> +       nbytes = cc_sg_trunc_len(sg, nbytes);
> +
>         if (sg_is_last(sg)) {

(1) this branch is taken, and not the else below,
(2) nothing acts upon detecting nbytes = 0.

With extra debug print:

    cc_map_sg: nbytes  = 0, first branch taken

>                 /* One entry only case -set to DLLI */
>                 if (dma_map_sg(dev, sg, 1, direction) != 1) {
> @@ -313,12 +335,14 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
>                 /* In case of mmu the number of mapped nents might
>                  * be changed from the original sgl nents
>                  */
> -               *mapped_nents = dma_map_sg(dev, sg, *nents, direction);
> -               if (*mapped_nents == 0) {
> +               ret = dma_map_sg(dev, sg, *nents, direction);
> +               if (dma_mapping_error(dev, ret)) {
>                         *nents = 0;
> -                       dev_err(dev, "dma_map_sg() sg buffer failed\n");
> +                       dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
>                         return -ENOMEM;
>                 }
> +
> +               *mapped_nents = ret;
>         }
>
>         return 0;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
