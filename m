Return-Path: <SRS0=TGnC=TT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2660DC04AB4
	for <linux-crypto@archiver.kernel.org>; Sun, 19 May 2019 17:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1409204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 19 May 2019 17:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="1DhIF28L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfESRYx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 May 2019 13:24:53 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:37274 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfESRYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 May 2019 13:24:52 -0400
Received: by mail-ua1-f65.google.com with SMTP id t18so4495022uar.4
        for <linux-crypto@vger.kernel.org>; Sun, 19 May 2019 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AfDkIx67EU0wHyEHueagVJG3HjlBgao6rt8wR4bAwCY=;
        b=1DhIF28LSxz9G4Jti5KhSzI2A498eFkjxXbUEErOX1gKxjcvF3EMRfFWX96+lmzwcD
         fGvVxDpQtkgu3dWJ5nq8aU1Kr6JSCO6dLbYcyy4c/PROtsxHewnBXjXV4syDCpl5FmSu
         TFIxNikyIl0/Ap2KvZYY8YRKaJ08ZIVqssKvUChqhdFdV2dStlsVgXIe3ym265I93TV3
         m2I4a8dW0tBEuZUJFkzWvLKpMp2S52pgWaGBSYD9+CcFIivJ1CbaDA8ki7Bypi9Kj3Rh
         +oAFCbDfdYHFRGoZlQcH9jjLaeP6JTQszMmBujWo4o+uAkicK3R2yZAbew2VQsxBqGNS
         IGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AfDkIx67EU0wHyEHueagVJG3HjlBgao6rt8wR4bAwCY=;
        b=Pi1dJXH1goOw9PsWXLrmfoYGodhYsB2yXH0npficmL4EgC03krgyB5/hne18OS8zjb
         ZEcVMVBDdS1+cI0rM90WPIkRnMb5OULJCb0h/sakS/ShubfiQbZQnuGePX0nPmtwe4Dl
         31j2Ruk3PKSe1dRH8QXtfVgwgeLKUoqmdUiihpZrVgabm6HnvMnhmQgyGxV66U94CdSO
         /dJ4JLGcLhpAKhIEsRNj/kvg1fbBxM+BFgJZakbmB0EQFB2gV9GINO4NyjF+wGR/9CKx
         4O1NHnO+X2auhobS0bk/mwUCAXUt3pwWmuXhEd2w0fseeJfpmUV1kQJrK8YCvPqg2ufH
         N4Ew==
X-Gm-Message-State: APjAAAUeCangSqi80ES2qMUTqmUxbfrzf/J/tDjeMasyMlnKAsnRFk5Z
        CdAyUkWmE2MqukKoM4FqGHpvPAZ9QzzYytPjJ1Gwsg==
X-Google-Smtp-Source: APXvYqy1ewDvtB4MUYqX6DuUZZ1vmwzclPcymjYyA39Wh+ycaaWGioENThJloKTmGBQNyKMpenvKzhxknWL/lJFLasE=
X-Received: by 2002:ab0:5930:: with SMTP id n45mr19721206uad.87.1558254498292;
 Sun, 19 May 2019 01:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190418133913.9122-1-gilad@benyossef.com> <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
 <20190517145235.GB10613@kroah.com> <CAOtvUMc++UtTP3fvXofuJA4JpdT86s5gbSx6WRtDK=sWnuUZrg@mail.gmail.com>
In-Reply-To: <CAOtvUMc++UtTP3fvXofuJA4JpdT86s5gbSx6WRtDK=sWnuUZrg@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 19 May 2019 11:28:05 +0300
Message-ID: <CAOtvUMcfXHv0UxytEEdGJG5LM-SfyyVHbnbE0RNALMfBD1zuEQ@mail.gmail.com>
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 18, 2019 at 10:36 AM Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
>
> Hi
>
> On Fri, May 17, 2019 at 5:52 PM Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> >
> > On Sun, Apr 21, 2019 at 11:52:55AM +0300, Gilad Ben-Yossef wrote:
> > > On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef.com=
> wrote:
> > > >
> > > > A set of new features, mostly support for CryptoCell 713
> > > > features including protected keys, security disable mode and
> > > > new HW revision indetification interface alongside many bug fixes.
> > >
> > > FYI,
> > >
> > > A port of those patches from this patch series which have been marked
> > > for stable is available at
> > > https://github.com/gby/linux/tree/4.19-ccree
> >
> > Hm, all I seem to need are 2 patches that failed to apply.  Can you jus=
t
> > provide backports for them?
>
> Sure, I'll send them early next week.

hm...  I've just fetched the latest from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git,
rebased that branch against the linux-4.19.y branch and it all went
smooth.

What am I'm missing? is there some other tree I should be doing this on?

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
