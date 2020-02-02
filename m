Return-Path: <SRS0=2eH/=3W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78FEC35249
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 15:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEB120643
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 15:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="sg0V/ZEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgBBPcq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Feb 2020 10:32:46 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:46409 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgBBPcq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Feb 2020 10:32:46 -0500
Received: by mail-vk1-f196.google.com with SMTP id u6so3426272vkn.13
        for <linux-crypto@vger.kernel.org>; Sun, 02 Feb 2020 07:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mi90bhimP2jFo8+p9OQpeUpQJ64yDvLVQgP6F2u9uVY=;
        b=sg0V/ZEY7dip3DPh2qScwwXLgsOdsHMbJpEt/HidDkUo2ozTR1tL/uF7fLiOwFm1C8
         HGalfdK6UF5WK+mlmAvuuk4zJRL4z34U89LZ2qoA+X+tCgM8dLGKtQh2HfOite9TOIpF
         RkAlpkXeZ4A+9KjhaYRk2IpuXwcOV1YM/oc/wDL+OKvHqzdH4sVnkqfK5khHHHwlXlVD
         Hnk0BjepTdKx5ylG3EknP1a+v8P4ppI1iJSYMmtujHO1XIUpJjMMlCLah+bMqn5e/oSN
         Phg0MqA0qhlAnmY2zG5nNd6QW/u1RfgqiLhI6VCW/UL9lhaNOPidCLHwu3gec3bAuwuR
         qYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mi90bhimP2jFo8+p9OQpeUpQJ64yDvLVQgP6F2u9uVY=;
        b=PFj/PLmvgBWbkB7T/3Cb4bWaWkpPar/vagPTQcQi873yV2nCVH12Yz7gb/cSjvEAuM
         lqhKpEy9ZeByGg2KJWfBTgwugti3lSO+c1xn32xYGE/oLEUlfxixUV6qJx097MX2WRYp
         HDCA0Jx8kycJAs/qIciwkG1QSE3XZ/U/snaWlY6T7JuSHoAyXuSsk3i0kIn45nHTIg24
         5UqM6bdRvoUdETkPJ+N06RQ0KobQsQf0BDWGGVdlOOFcjhzMRbx3Sj2RK1w/xRCvZzVN
         T4lVOF6LqjTF1kQ5yBfJtFQGZaUmap0x27JDmDNxtboDKoftILjgWSBlvjrCIFlZWkHS
         1Mtg==
X-Gm-Message-State: APjAAAWHQC93IHeLb9dP7EDkueyiBwTixziT1ivyIfpx9PqvXOuMCIgK
        qSkwaqz24xOtimdbhrrOALyIvsHrTQJB4q6zF9onTQ==
X-Google-Smtp-Source: APXvYqzBdegfrRAQZPJTNqqHFNCy/GnEoZFaWZ8XhQ3QHf76DwqaIc9nOnqobCWdRP3+qDU3VnSL8eetfU207zqK4jk=
X-Received: by 2002:a1f:8d0f:: with SMTP id p15mr11945370vkd.100.1580657565589;
 Sun, 02 Feb 2020 07:32:45 -0800 (PST)
MIME-Version: 1.0
References: <20200129143757.680-1-gilad@benyossef.com> <20200129143757.680-5-gilad@benyossef.com>
 <CAMuHMdVb_AGa7980fRXaxon=uDojZ1x5d6z-FCJAt5aMEGMcbw@mail.gmail.com>
 <CAOtvUMdUBMkmZ6nzGVxi1W_Y4yFvcd6rfvz6BA63h4eq2QFUdA@mail.gmail.com> <CAMuHMdXecd0KAN6B4GWKMp-DsmZVTJqOJfm5CymwwPMwDqG0qA@mail.gmail.com>
In-Reply-To: <CAMuHMdXecd0KAN6B4GWKMp-DsmZVTJqOJfm5CymwwPMwDqG0qA@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 2 Feb 2020 17:32:33 +0200
Message-ID: <CAOtvUMcejz8qLrg8MBxM2DkYSqvfX-yKwK7NujmwD=szystUAQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: ccree - fix AEAD blocksize registration
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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

On Thu, Jan 30, 2020 at 3:19 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Gilad,
>
> On Thu, Jan 30, 2020 at 12:33 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > On Wed, Jan 29, 2020 at 5:17 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, Jan 29, 2020 at 3:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > > > Fix an error causing no block sizes to be reported during
> > > > all AEAD registrations.
> > > >
> > > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > >
> > > Thanks, this fixes:
> > >
> > >     alg: aead: blocksize for authenc-hmac-sha1-cbc-aes-ccree (0)
> > > doesn't match generic impl (16)
> > >     alg: aead: blocksize for authenc-hmac-sha256-cbc-aes-ccree (0)
> > > doesn't match generic impl (16)
> > >
> > > which you may want to mention in the commit description, so
> > > people who search for the error message will find the fix.
> > >
> > > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > >
> > > Note that even after applying this series, the kernel still crashes with
> > >
> > > kernel BUG at kernel/dma/swiotlb.c:497!
> > > ....

Thank you!

I've managed to reproduce this here.
Looking into it now...

Gilad
