Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED36C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0531A206BB
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HnqxpifQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbfFKN5L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:57:11 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45405 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391492AbfFKN5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:57:00 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so9935371ioc.12
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 06:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k2eIxKEznVdBNiutDU+wxdpnvDC8qgGQViu4hbtHNAg=;
        b=HnqxpifQFdKH3Knn7Mb1vwGInG4FS0YJAVD+9nh429/DXn1dxL2aa2Ie/K6o+qIi8x
         ibu7Akv33IzkRQK7vymJLo9K/5CUKgDZpJYXEWbIJG8QUXedkXzCtjBh1Sk+Q/T/iHWD
         B1eORsdGhFFOJVDcAo6mU4/dmyD2Xopmm+VJGqM3FMQQ7B8Yj+MD4Vmj9AjTYJDrUyMk
         rx1He0VQ9dQGEY1Webh1k9zFjjOB+27XsR7FqydRM5ahifaTDR4AERPylMi4R7w4AApF
         g/ePKiPipXJ5QxGqhuaspwrrWh3yOLPtCUc8xtXDsY+G6m+GDO2kO/GPqJ3csJIhF776
         o6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k2eIxKEznVdBNiutDU+wxdpnvDC8qgGQViu4hbtHNAg=;
        b=QdroGjjWVGwr2PSlPrlTyMBj9Y5tKEjtD6f9pRJTE5oHYhHQ9GQvizzxzL/J/T5oIh
         lalIJyYBIapA9XXmzQrXoLQb+s1wBnXjOTcgEtxomYK8yvpg3i1mkhW4eP/oqLH4wn6L
         /OkdToYaZxmRZLH/uQEHYGWRneaH0V4XgcfIutk5+R/7KEoaTDtEb8q7igGEYgq3mXes
         K/Fi10z6ACCxnKqd84rvWIMEUQhM+TTmHarcHazQJ67gyPrS8xWkSQKnSeBpP5LhXX7l
         Y2MADjRNAqNzVkADjpACjkBi7ss3uxoQFaD/LjDin8DhfPekPNK2JZpYakGTW2YlZGD5
         TV+g==
X-Gm-Message-State: APjAAAXGH9bzjbsdqRuNBwajWrV0tiNo9Hs07Sksqd8IscySZ6DqQIvt
        XEgT+YsAQ1VI2gsJTblxqnvZ5iTNHFHiaNWk7tXtDQ==
X-Google-Smtp-Source: APXvYqx6SOB9njZxdu+hQyqQ41cl1vAk/t/eL2UegCLluximfuuc+0DXfAA7EGMejOAjt2P7he5/Zy8asGLb5XcGs+4=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr945403ion.128.1560261419456;
 Tue, 11 Jun 2019 06:56:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-3-ard.biesheuvel@linaro.org> <3c625ea9ab435c35cda6e61d19e21802d9507f13.camel@sipsolutions.net>
 <CAKv+Gu9A0Mc67yQb=TfurEgwmaFquzKEQgiwXHxVu7iVp7t-NQ@mail.gmail.com> <9c521e1f6555ca335d950b7cde7a00b95fb1ce3d.camel@sipsolutions.net>
In-Reply-To: <9c521e1f6555ca335d950b7cde7a00b95fb1ce3d.camel@sipsolutions.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 11 Jun 2019 15:56:47 +0200
Message-ID: <CAKv+Gu-RPRH-3ofWk7-=-p6mRCFPm3QiZsM+ZKko269oiw0Kzg@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] net/mac80211: move WEP handling to ARC4 library interface
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 11 Jun 2019 at 15:55, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2019-06-11 at 15:53 +0200, Ard Biesheuvel wrote:
> > On Tue, 11 Jun 2019 at 15:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > On Tue, 2019-06-11 at 15:47 +0200, Ard Biesheuvel wrote:
> > > >
> > > > +++ b/net/mac80211/mlme.c
> > > > @@ -5038,8 +5038,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
> > > >               auth_alg = WLAN_AUTH_OPEN;
> > > >               break;
> > > >       case NL80211_AUTHTYPE_SHARED_KEY:
> > > > -             if (IS_ERR(local->wep_tx_tfm))
> > > > -                     return -EOPNOTSUPP;
> > > >               auth_alg = WLAN_AUTH_SHARED_KEY;
> > >
> > > This bit is probably not right, we directly use the WEP functions for
> > > shared key authentication.
> > >
> >
> > OK. So we need to change this test to
> >
> > > > -             if (fips_enabled)
> > > > -                     return -EOPNOTSUPP;
>
> Right.
>
> > Does this also apply to
> >
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index a1973a26c7fc..9d8a8878a487 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -402,9 +402,6 @@ static int ieee80211_add_key(struct wiphy *wiphy,
> > struct net_device *dev,
> >   case WLAN_CIPHER_SUITE_WEP40:
> >   case WLAN_CIPHER_SUITE_TKIP:
> >   case WLAN_CIPHER_SUITE_WEP104:
> > -     if (IS_ERR(local->wep_tx_tfm))
> > -         return -EINVAL;
> > -     break;
>
> This shouldn't be possible because in cfg80211 we should be checking
> that only ciphers are allowed that are in the cipher list (which we
> built with the "have_wep" thing before), but perhaps better to be safe
> here just in case we forgot something in cfg80211 - I could see e.g. the
> old WEXT compatibility code not checking too carefully...
>

OK. I could make it a WARN_ONCE(fips_enabled) perhaps?
