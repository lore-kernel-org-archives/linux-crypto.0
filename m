Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4B8C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Dec 2021 09:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhLNJXU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Dec 2021 04:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhLNJXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Dec 2021 04:23:19 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F2C061574
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 01:23:19 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c4so31226366wrd.9
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 01:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+8HAMzFINZJSXlRY8+3do5FXlh0Tu5Ll5qiedYfeu+s=;
        b=T6YiNV4Y2eDj5cO4pn9SuiONRbr80pg2GG0+zFeP9d/fqT7z8oL6QURMAVlVnZrZsb
         Va3MqwJsfuQ7ivwcFxe0j34tHQ5id/Hm5jeaAjctKEum4/oa5BZDEePeaFAo7B4+piVW
         vljZw8hD53QZYER1v+cCv/uaoHEtRj7C15Z6VNoc1ojHRtkAquRkxKGOwEoNaljbUQTX
         LGJBoizk4JlNXfc+4Jkt0Q5it2YWsdKzp6LDZWCnGpUL+EMEBV082DsltQnntPxzvBeR
         b00Clz5OVxRzfuluEAZD74k/m0+vtQ05ZtSPpu9J+zyfWPydkX3V3XB2Bl0EFA6xKH4u
         syjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+8HAMzFINZJSXlRY8+3do5FXlh0Tu5Ll5qiedYfeu+s=;
        b=qHppPmeBjoHTaglh4Im+tmO5JnS/qV1KZ0yJwlObeqf8hR3IdbB86/lPBMl8wl//3Z
         BIg/O9Xlj4uzzvV03hotJE6nxSVVMKQ0qhWgjR2VwL1+RkaAXSwI/yZ0BErKECHQW6eZ
         Ek+mKt5j1RD910eFfN45KDwd6M58JAjlqvgVsgTbo07Xzkf2mxUgYaT8/+PsrBtgr+x6
         rJ61LoX/rQ43cUtSx4miL45Obv022veqWZKCxvtY/U3JBfHBDuThwDaLwqjmyy0tCarH
         MDxqahV+IDgRehF0YP3Dwo1oNWngGCagTiRkq3Xc2pw/kRVAAIi3c7o2Z+D2oany4MGu
         8X7A==
X-Gm-Message-State: AOAM532AJ70GjKojJKC/hkQxPUff3103r1naAR58ayJIznHXpsHTxn5p
        RpSTxONhwlc9EMgHC90HU4VGE2jA1dlHMuMxyp88TS0g
X-Google-Smtp-Source: ABdhPJxa5GYqzeYL5aioYt3WLW3uOFwcHBdFnSNE7k99nK//OIZkJ8E7dK6psgRD1hhhCJPoo0f8SiF6wVRl6E77uNg=
X-Received: by 2002:a5d:644f:: with SMTP id d15mr4440802wrw.662.1639473798048;
 Tue, 14 Dec 2021 01:23:18 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmnEpzp-66JvENsAFTTyehM0bZoGFT6wOBPzkkbGgi7P5A@mail.gmail.com>
In-Reply-To: <CACXcFmnEpzp-66JvENsAFTTyehM0bZoGFT6wOBPzkkbGgi7P5A@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 14 Dec 2021 17:23:05 +0800
Message-ID: <CACXcFmnhFZAfjDC802cca9fTxwNOeNLU=F=Y6OiRyLMtoQci-A@mail.gmail.com>
Subject: Re: [RFC] random, initialize pool at compile time
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        John Denker <jsd@av8n.com>,
        Stephan Mueller <smueller@chronox.de>,
        Simo Sorce <simo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sandy Harris <sandyinchina@gmail.com> wrote:

> I will submit this as a patch ...

On second thought, no I won't.

The existing driver uses the gcc latent entropy plugin
to initialise the pool. I'm not sure how much entropy
that provides & worry that it might not be enough on
some systems. However it has an enormous
advantage over my proposal, in that it is likely to
give somewhat different results on every boot.

I have working code for a program to generate
initialised pool arrays & if anyone needs it, they
can certainly have it. However, I will not be trying
to get it into the mainstream kernel.

> /*
>  * Program to select random numbers for initialising things
>  * in the random(4) driver. ...

>  * Inserting random data at compile time can do no harm and
>  * will make some attacks considerably harder. ...
