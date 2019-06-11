Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A35C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520D9206BB
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbfFKN6w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:58:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42512 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387486AbfFKN6v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:58:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hahIW-0004yV-60; Tue, 11 Jun 2019 15:58:48 +0200
Message-ID: <a5dfdad39a78915354fbd6b304da39ae9c251dcc.camel@sipsolutions.net>
Subject: Re: [PATCH v3 2/7] net/mac80211: move WEP handling to ARC4 library
 interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Date:   Tue, 11 Jun 2019 15:58:46 +0200
In-Reply-To: <CAKv+Gu-RPRH-3ofWk7-=-p6mRCFPm3QiZsM+ZKko269oiw0Kzg@mail.gmail.com> (sfid-20190611_155701_268445_64752B39)
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
         <20190611134750.2974-3-ard.biesheuvel@linaro.org>
         <3c625ea9ab435c35cda6e61d19e21802d9507f13.camel@sipsolutions.net>
         <CAKv+Gu9A0Mc67yQb=TfurEgwmaFquzKEQgiwXHxVu7iVp7t-NQ@mail.gmail.com>
         <9c521e1f6555ca335d950b7cde7a00b95fb1ce3d.camel@sipsolutions.net>
         <CAKv+Gu-RPRH-3ofWk7-=-p6mRCFPm3QiZsM+ZKko269oiw0Kzg@mail.gmail.com>
         (sfid-20190611_155701_268445_64752B39)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2019-06-11 at 15:56 +0200, Ard Biesheuvel wrote:
> 
> > > +++ b/net/mac80211/cfg.c
> > > @@ -402,9 +402,6 @@ static int ieee80211_add_key(struct wiphy *wiphy,
> > > struct net_device *dev,
> > >   case WLAN_CIPHER_SUITE_WEP40:
> > >   case WLAN_CIPHER_SUITE_TKIP:
> > >   case WLAN_CIPHER_SUITE_WEP104:
> > > -     if (IS_ERR(local->wep_tx_tfm))
> > > -         return -EINVAL;
> > > -     break;
> > 
> > This shouldn't be possible because in cfg80211 we should be checking
> > that only ciphers are allowed that are in the cipher list (which we
> > built with the "have_wep" thing before), but perhaps better to be safe
> > here just in case we forgot something in cfg80211 - I could see e.g. the
> > old WEXT compatibility code not checking too carefully...
> > 
> 
> OK. I could make it a WARN_ONCE(fips_enabled) perhaps?

Sounds good to me.

johannes

