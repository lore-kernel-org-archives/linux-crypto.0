Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E41C33CB1
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC37920702
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="fjmT4coy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgA0M3r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 07:29:47 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:46473 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730196AbgA0M3r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 07:29:47 -0500
Received: by mail-ua1-f68.google.com with SMTP id l6so3323854uap.13
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2020 04:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TC/jbdNXZ2D9BmqUV22cZuRvRHGXN8uex0O3uaZCCB8=;
        b=fjmT4coyOvrBK2h+BPci1LCeVr+a3vWJX76FTYcFv0XlUFna4w2ZvTLMkrpnLlk3U0
         cggT7NAylDCNPt4e1Vm+pkp3CwK78hBam+QsnfR1c2357YuiEfg7v2NwOHoZbupHRLYp
         s2jEJmwTzdD/jjqV4y5avgneVsl6BT08m4aBtn1GxU+tB7CWwEsCUA7OJAUf5LPopeSb
         bXLHbRx2Pi9DHFCtDa8MjxaeQm0e/BRVWnBRYHnTfL1VrdFCsNkESmT4fhLVi3B3u1xP
         wRE7JgaUHijwRdiTzb67S5GesN5QNqnqR4F5dUCEcqr5c9glGsa9qRwbs1ImHDBWN1y2
         suLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TC/jbdNXZ2D9BmqUV22cZuRvRHGXN8uex0O3uaZCCB8=;
        b=DWdtIQXKwYflaRu3X+8XKFWD5SKh6Zrj0wm3fm+X91ZCyEyNt0yPYJN/hBoBV2ReoZ
         InkruQceQq7YHp2wl55tY93M8W6WzUO23IeBnO9p4q2+Y7dtpYWVoe5aelY1A+A+r9bF
         yjsNAG0E1/VRVXyZiNWr5Ai3lEclSb4LhjEpN/Q/CFYeT6iPpYl1C6ARuR3qeLP0IBfB
         j5J/rVSl1pzjsHs8Kzho0SGkW/QfnqXrWN5VtFIu7SO1e9wI75Wkhh7zxGzE5Tr4Qdha
         Y6AAVnlOCspI3SMOsciK6N3i0KHh4su1HMkUrKBmaBFEhnBOxlp7H2elvuqjPK4UsNvk
         mDmw==
X-Gm-Message-State: APjAAAUDYRhzDxF8eYs1QGWoo11Emx26VMPWwxfkDaaqcYD68LaHaWnR
        OG+LH7nhPsR8W2z5GIy718t416wUQDYoEJ7FuqtkF/DkmyqjEw==
X-Google-Smtp-Source: APXvYqwZbM7FkGoGBSAI/S5xNKm1fSPmsgIPqD8MahEvFKdy3f+86z+s9RgPmD468G4wv7FiDLxF2cdLNgO5B0lH0oI=
X-Received: by 2002:a9f:226d:: with SMTP id 100mr9338336uad.107.1580128186076;
 Mon, 27 Jan 2020 04:29:46 -0800 (PST)
MIME-Version: 1.0
References: <20200126133805.20294-1-gilad@benyossef.com> <CAMuHMdXHgMn8L2_CZ8kXcp3g4Y+3HfQsvFhyTZatf8-xk2kUdQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXHgMn8L2_CZ8kXcp3g4Y+3HfQsvFhyTZatf8-xk2kUdQ@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 27 Jan 2020 14:29:35 +0200
Message-ID: <CAOtvUMdoktR3C_xwkfpzq_=CqyMzmr_BjWEEg6MW-NnoAZ+ssw@mail.gmail.com>
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

On Mon, Jan 27, 2020 at 10:03 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Gilad,
>
> On Sun, Jan 26, 2020 at 2:38 PM Gilad Ben-Yossef <gilad@benyossef.com> wr=
ote:
> > Deal gracefully with the event of being handed a scatterlist
> > which is shorter than expected.
> >
> > This mitigates a crash in some cases of crashes due to
> > attempt to map empty (but not NULL) scatterlists with none
> > zero lengths.
> >
> > This is an interim patch, to help diagnoze the issue, not
> > intended for mainline in its current form as of yet.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Thanks for your patch!
>
> Unfortunately this doesn't make a difference, as ...


OK, so this is a different case than the one I am seeing but similar
in the sense that we get a scatterlist with
a NULL first buffer, which aead.h says we shouldn't... Oh, well.

Sorry, still waiting to get my R-Car board back. Please try the patch
I'm about to send and see if it is better.

Thanks,
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
