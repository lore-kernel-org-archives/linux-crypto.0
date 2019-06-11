Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF3FC43218
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1FB206BB
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TsFsnQnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfFKNyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:54:09 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36942 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfFKNyJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:54:09 -0400
Received: by mail-it1-f196.google.com with SMTP id x22so4865451itl.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 06:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7a37nGc2Hhw4ZLDIYB0sJASgVa2z1dBzj5SpJMqh0NQ=;
        b=TsFsnQnHehkG+vCisfPZGOiMvHMGnO6X5hecLqIzL+GZdEtI/2UH+MwY02Ei2IKV+M
         RwMrquKwsu7zKv6otyWT4TJSd9EXV7SHz5agFA6vZ6llNoE00cPPP2I2jCViyuOkMtRC
         867RRC2fUyWasZ/dX99cw1gO7R3l005j28O7ADJbaNrkcF6UwzlqdCxn8QpqU9b3XHdC
         BCKuLLESgiSKD6qI2UWzie1QWwL41KOlxXpdM9cM8y/6ptx4rYQ0nvzTibXrPK0SnOS+
         4a0hhiQz5OW6Zdw8ueXKNK76yoKAlZ3Iwa4AAMI+h9XmpQERNz+oODA/RRW22BvrypK+
         XDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7a37nGc2Hhw4ZLDIYB0sJASgVa2z1dBzj5SpJMqh0NQ=;
        b=a1gamz8SHcQzePIvdisX0i7NHyVhEsQ+eaBnFZhK/wFOxric1oym0ADq874Yuhodad
         aU7O50eOkWekC8bHy00O6XnwjGzPRLamOSv14W6zWF34d7EyqEZQBUe+i/IhIGWqLh7b
         RVXU07GJMCTNG04wn1xzc1kegC9QsUvKNRW8QlUFguRHG2O+zqstwhN9UozE2cUTy1WC
         CGUIgUfb8WTtHJQkzdCFRyA0hWyYNfAuMZ0IkdPzg4b4SjNFh3SYKqsSNp/emACsCLCu
         2vcSshvSlYkArm0tKXGF/67zGmLBGMO2xmEOVNmLqyDaB/OcvVJDotzDvQweSy2TXKmJ
         hgnw==
X-Gm-Message-State: APjAAAUkh99axwEquCbdOtTiuV62luSAlNqGCK4XkZYMq1bN1TSh5pec
        gL5FhC3tKEoWlC7vBMagvdXAgSrBna3gHPH2hpsQ+g==
X-Google-Smtp-Source: APXvYqxjZ6m63/aIi5RtkDEtIUUaea9cg9p1ZOV5PPpJFpMLUtiL+3Fnednx8oo1QlSrkRic0Qy0qdGw90IrKmDZvLk=
X-Received: by 2002:a02:a815:: with SMTP id f21mr7630839jaj.130.1560261248752;
 Tue, 11 Jun 2019 06:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-3-ard.biesheuvel@linaro.org> <3c625ea9ab435c35cda6e61d19e21802d9507f13.camel@sipsolutions.net>
In-Reply-To: <3c625ea9ab435c35cda6e61d19e21802d9507f13.camel@sipsolutions.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 11 Jun 2019 15:53:56 +0200
Message-ID: <CAKv+Gu9A0Mc67yQb=TfurEgwmaFquzKEQgiwXHxVu7iVp7t-NQ@mail.gmail.com>
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

On Tue, 11 Jun 2019 at 15:52, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2019-06-11 at 15:47 +0200, Ard Biesheuvel wrote:
> >
> > +++ b/net/mac80211/mlme.c
> > @@ -5038,8 +5038,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
> >               auth_alg = WLAN_AUTH_OPEN;
> >               break;
> >       case NL80211_AUTHTYPE_SHARED_KEY:
> > -             if (IS_ERR(local->wep_tx_tfm))
> > -                     return -EOPNOTSUPP;
> >               auth_alg = WLAN_AUTH_SHARED_KEY;
>
> This bit is probably not right, we directly use the WEP functions for
> shared key authentication.
>

OK. So we need to change this test to

> > -             if (fips_enabled)
> > -                     return -EOPNOTSUPP;

Does this also apply to

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1973a26c7fc..9d8a8878a487 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -402,9 +402,6 @@ static int ieee80211_add_key(struct wiphy *wiphy,
struct net_device *dev,
  case WLAN_CIPHER_SUITE_WEP40:
  case WLAN_CIPHER_SUITE_TKIP:
  case WLAN_CIPHER_SUITE_WEP104:
-     if (IS_ERR(local->wep_tx_tfm))
-         return -EINVAL;
-     break;
  case WLAN_CIPHER_SUITE_CCMP:
  case WLAN_CIPHER_SUITE_CCMP_256:
  case WLAN_CIPHER_SUITE_AES_CMAC:

?
