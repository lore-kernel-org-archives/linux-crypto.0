Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333EBC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 15:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF04214DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 15:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="gB8aH9bX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgA0PKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 10:10:04 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40646 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgA0PKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 10:10:04 -0500
Received: by mail-vs1-f66.google.com with SMTP id g23so5817865vsr.7
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2020 07:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NkoAUVzWFZjHMMtEdPmvHpOHaSeOlTobo/dhUR4U2mI=;
        b=gB8aH9bXLODaT5xi6+YHilW7T0QWwBAAdJXLkkbJnINh/xj60xu3s2hA6DzCwXv+DS
         3aQFGUF9eIk05QAu4EhBap3BxPNU4qG6au51QwFeTW6qPx1AckH1AbWL8k1K0WsC5wu5
         vHie2JLP6hSf9W+59v383Hpr35ojnQNblt8gf+ozgUyd/GQzPax1JGQbCOCSA1sbpmxe
         x2bjcvOhEjsaSKEZ25/CkFgazKBSIvHnyz1d+6VQBFH8EKS4Kj7vHhlyZAZJPYd2084W
         UeUtrhvCVukGhxtzatJIyWhVYMlrdc0lzhy8m5b9p8BUVYRi/aH2dGrsABVOrOYg3PeH
         dilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NkoAUVzWFZjHMMtEdPmvHpOHaSeOlTobo/dhUR4U2mI=;
        b=F3RVd3uN06a0hecdnPLgXicp+ope9Ad5UyxZNLltcnvvkBi6ynCF4Blo8cDjfsU0G0
         91nclcmX6DvTdlsGh1sXLlL/aae32cQly5ZcPv3PlmFCFmIJ4fmec/wAxh4NTIv5khvW
         3hG2Mgsv+1i9TzDGzHfdRYRaOB+PSL+dWRC2bKomAoX4vs3fPA0jN5+uKiSIoJuTLZHo
         Iuwe1AHOlDeJsPllQrqKUqA7kNKrb7ET0OyeamXpkaKD5uO+iiY5NqM6v9DIHei7AtPu
         XRctV7itRMEOjRahaV8o9iSQPHazsljb01la1PqGuSnq/2uoNFLG5ujkrRDjvIOtqTfp
         vIHQ==
X-Gm-Message-State: APjAAAUUsJxt1FTpg4ep2IbsISvYiRnXa9JUyoY6syhimYlXjOVUI/6O
        aSlPDNVhoQ02wCpY7UjTG5jfstqDSMVpHqd21CoJ1y4CSdM=
X-Google-Smtp-Source: APXvYqwXtEK+nyeYN+ImrtWqCwzLW1sUUPSn17lF3dhK2jYXgmqlEoxWUYBw5LsFIOvXnu7JeeiZnw8mTYQ34xHNQug=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr9765471vsr.136.1580137803056;
 Mon, 27 Jan 2020 07:10:03 -0800 (PST)
MIME-Version: 1.0
References: <20200127122939.6952-1-gilad@benyossef.com> <CAMuHMdVrQh-1cEncfWoAjhd6SjJRHZPg9Qt7yVyw5Qrdo+-nrQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVrQh-1cEncfWoAjhd6SjJRHZPg9Qt7yVyw5Qrdo+-nrQ@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 27 Jan 2020 17:09:51 +0200
Message-ID: <CAOtvUMcmw_W-WVMGusCnkKBg71540c8Bo7LCMhz+t+dOsPUG3Q@mail.gmail.com>
Subject: Re: [RFC] crypto: ccree - protect against short scatterlists
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 2:52 PM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
>
> Hi Gilad,
>
> On Mon, Jan 27, 2020 at 1:29 PM Gilad Ben-Yossef <gilad@benyossef.com> wr=
ote:
> > Deal gracefully with the event of being handed a scatterlist
> > which is shorter than expected.
> >
> > This mitigates a crash in some cases of Crypto API calls due with
> > scatterlists with a NULL first buffer, despite the aead.h
> > forbidding doing so.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Thanks for your patch!
>
> Unable to handle kernel paging request at virtual address fffeffffc000000=
0

OK, this is a progress of a sort.
We now crash during unmap, not map.

Sent another go. If this doesn't work I'll wait till I reunite with the boa=
rd.
Blind debugging is hard...

Thanks again!
Gilad


values of =CE=B2 will give rise to dom!
