Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3FCC3A59B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 20:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D0F72343A
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 20:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvTqGDHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfH3UhH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:37:07 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39480 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfH3UhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 16:37:06 -0400
Received: by mail-io1-f67.google.com with SMTP id d25so14192751iob.6;
        Fri, 30 Aug 2019 13:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0JUNhfkrZqLY9KN3K5zh26VHBBeMbBG5ArZ82Gj/QyU=;
        b=qvTqGDHH7or7n6VUh01Oe1iaqtd+FjKc2/UTCYhp5J9UwxdydcutSEiz3KTpDC3YxG
         rDyj+e1FNAJfuzhP4apRCX71oZnr0MhA1ZtWIDnVs1gG6cegdKteJoHiNWa9sSpxbKVb
         tsmIDTu2Q4BMibcK5rCX5v0GD8ZsndBalEDGIjaXChwUGnFCTT7KAq95PZkefH3+cHGD
         n9q8ZNyo6n9+vBGKL53OK6HCTpJQEL1qEgy8DBYreiQrOV2FvlhwbPffeYpwAZRInxne
         irjak/VX5lxQSAt/GxqT3F+SGNy3L9PnE5Y3sY4NO8Fwo36ql2BTWJ6R0Nq+vp/t/rvc
         95Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0JUNhfkrZqLY9KN3K5zh26VHBBeMbBG5ArZ82Gj/QyU=;
        b=IDhAFvp2J0SMmcJ29nDKCObRTNwWxmMR/UJfZM/ar7b7sxZM83BROI+zeS8Y2vN4PQ
         DJjd0KLOpxHv60xyhrUXBrzXwnVaPqNh3uYoRnqzOd+TBri/JCDrhNXOES2szngVRZaq
         XOV0pyPLZlnYqsFIGQopAeCDkqwNX/JL9GaZ2M7U3aDdr401GO+F3xoOmV9bSw/EPp++
         pXG8W/mz5A0dtR4mNp8P4PrvBvNlvJ86Rxn8BzUvfMWSkkufrQEPi3v53F6XI709rlt9
         EUHa9oTwWFXv7EMqHeN8ImC/tSYx9qyonbXxJXdHTTlzHIQpVw9oNPBVziixgctwuLsf
         PB4Q==
X-Gm-Message-State: APjAAAV5BRv88YlR0QqZfmKQ/Q9Qv7mOPc/E8c58NZ2gDeXLocuXnz4R
        rjhna+urCBDLMVtZKlX9e8TScFZLxVCQSDiLm5w=
X-Google-Smtp-Source: APXvYqz+s6vgax/O8s/+ztnS4mJsISNhBbsquvh/Fry1XjMzc3kv04A/xu8SEGtbqkaHIImTwNjCvKCfLH6cnyiWIs8=
X-Received: by 2002:a6b:6013:: with SMTP id r19mr832881iog.94.1567197425925;
 Fri, 30 Aug 2019 13:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190830082320.GA8729@gondor.apana.org.au> <VI1PR04MB444580B237A9F57A7BAAF32B8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190830131547.GA27480@gondor.apana.org.au> <VI1PR04MB4445AE3FE7AD09C4544D155C8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4445AE3FE7AD09C4544D155C8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 30 Aug 2019 13:36:54 -0700
Message-ID: <CAHQ1cqHMCvHkCA+Y07W05F08VQJC4jF1VrJmvNno983+3Pn8Og@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "christopher.spencer@sea.co.uk" <christopher.spencer@sea.co.uk>,
        "cory.tusar@zii.aero" <cory.tusar@zii.aero>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 30, 2019 at 6:35 AM Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 8/30/2019 4:16 PM, Herbert Xu wrote:
> > On Fri, Aug 30, 2019 at 09:15:12AM +0000, Iuliana Prodan wrote:
> >>
> >> Can you, please, add, also, the device tree patch ("arm64: dts: imx8mq:
> >> Add CAAM node") in cryptodev tree?
> >> Unfortunately Shawn Guo wasn't cc-ed on this patch and, to have the
> >> complete support for imx8mq, in kernel v5.4, we need the node in dts.
> >
> > If Shawn can ack this then I'm happy to apply this patch.
> >
> > Thanks,
> >
>
> Thanks, Herbert!
>
> Andrey can you, please, resend the dts patch and cc Shawn Guo?
>

Will do.

Thanks,
Andrey Smirnov
