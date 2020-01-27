Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0E9C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFCB207FD
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRL0v/bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgA0Np4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 08:45:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41481 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Np4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 08:45:56 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so11351490wrw.8;
        Mon, 27 Jan 2020 05:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8wEogbygRvbp++ia3Wid/2+2KW6gEIuAoacWgq7qzc=;
        b=cRL0v/bFbFZAZhiad103inFwPBpqos0ja22iRbW+dOrWsh74BdcetI5WcSEMSIEinN
         KRB2F9FP/e13dq+bJQOy8yLRxlAxblXwQqV5mFUfJjqOFbU7/JluNgf1+7LCN3efoQF7
         dYSFNXoV8vA3I5e2vgVtt2uoYTFqTs+14rfvZX2JnD3KE/s6Am2NCl8E+HoUWheX+2WT
         zILZAJz7ve7m06cyTDMfzUgPY5x/NOUYZWnJx+JHRRa69Du994Hkyje/Fti4dGaulGTY
         7UedkXMUiNgdJSWFCW6aq4xzq+/Vh2uZcqXvBU4KaW2sXgRTaG7HHNqq20zMGwDQrr+2
         iddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8wEogbygRvbp++ia3Wid/2+2KW6gEIuAoacWgq7qzc=;
        b=aYTOwWsyzqgAAiZrxUPiXXl+3oofxiZEpUu4S8TaVKgUlX3+z+c9YqzuXjeI6zXGd4
         tAkxmbsecjtI89Nbk/LR6lvtQarxpuR9onymqkd3G46e26uibcJHURlfVC3Rr9MyGux4
         MeFH5k/P89KhyGUpBrdbD6gcATecwOhdv1qIR92kzaKgD9kEUWKxiQqN8PpnTVoefJrX
         WO2w7+KPycY7xvBq5zT8T7jeyZIvPjCQpbNTDkeNYqlgQdB0ju7ugEPpSWtPwXD9nHkG
         uCm2bcVCaDps9JaNKayHl6732gqEBu9MO9Y1zu+DaFZlKSfhanfXtJwkuhVjEIaetI1j
         q5NQ==
X-Gm-Message-State: APjAAAWbHPk7eU570C2he22ueHjGIoZbHKz04Cwk8XPtO7D+xKvNprYB
        +HWcH9N0jvFc9gCWHChEj94OZxBTZl0ClZRUVZI=
X-Google-Smtp-Source: APXvYqy9UtPthtDDo0IABzhU454S5hEjWywRyR/c9pHdOIJGh/RDB5dsYOSfJOcmnuriBjgxgc/EA/GA1SCGsaQXAtc=
X-Received: by 2002:adf:ea42:: with SMTP id j2mr20895943wrn.270.1580132754034;
 Mon, 27 Jan 2020 05:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-7-andrew.smirnov@gmail.com> <VI1PR0402MB3485B3F4C3E39D0D94A1D8C6980D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR0402MB3485015AD186F00B258F76D4980C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485015AD186F00B258F76D4980C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 27 Jan 2020 05:45:42 -0800
Message-ID: <CAHQ1cqG185EmhTYGwfm4LBrhbX1ibACaTAjZ5UnZ5uYx+o88HQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] crypto: caam - enable prediction resistance in HRWNG
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 22, 2020 at 5:37 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/21/2020 6:38 PM, Horia Geanta wrote:
> > On 1/8/2020 5:42 PM, Andrey Smirnov wrote:
> >> @@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
> >>              return -ENOMEM;
> >>
> >>      for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
> >> +            const u32 rdsta_if = RDSTA_IF0 << sh_idx;
> >> +            const u32 rdsta_pr = RDSTA_PR0 << sh_idx;
> >> +            const u32 rdsta_mask = rdsta_if | rdsta_pr;
> >>              /*
> >>               * If the corresponding bit is set, this state handle
> >>               * was initialized by somebody else, so it's left alone.
> >>               */
> >> -            if ((1 << sh_idx) & state_handle_mask)
> >> -                    continue;
> >> +            if (rdsta_if & state_handle_mask) {
> >> +                    if (rdsta_pr & state_handle_mask)
> > instantiate_rng() is called with
> >       state_handle_mask = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
> > so if (rdsta_pr & state_handle_mask) will always be false,
> > leading to unneeded state handle re-initialization.
> >
> Sorry, I missed this change:
> -#define RDSTA_IFMASK (RDSTA_IF1 | RDSTA_IF0)
> +#define RDSTA_IFMASK (RDSTA_PR1 | RDSTA_PR0 | RDSTA_IF1 | RDSTA_IF0)
>
> which means code is correct (though I must admit not so intuitive).

Renamed this to RDSTA_MASK in v7, to, hopefully make things more clear.

Thanks,
Andrey Smirnov
