Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBFAC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 21:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiEDV21 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 17:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiEDV21 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 17:28:27 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0FD4EF60
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 14:24:49 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l19so3287324ljb.7
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 14:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XjGyI9MSGnU0qCNLMFpaviA7GndbKZ2IDx6hLyctHX4=;
        b=Hnh4NwCji3pL4qgEEYR/rp2EGQirIJ6TndAv3gfwVZ/JGytdR+O9QCKDEHVhGtvIFF
         9aRffXNypP8dkToBapQXAOdfXKU9mZIa3VfxkZr2nxb/u8IQj1Frzb2oFZRJ285d1XCi
         +bh+/hBYCHPvKxUswkWHNbsX+17jJWjNy8VKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XjGyI9MSGnU0qCNLMFpaviA7GndbKZ2IDx6hLyctHX4=;
        b=iMQmjkOAw6zT2jnDBb31URpSFZouD73XZnKzAxVY58yKWKUgVJhIVu2Z/Rmm6zWWop
         7tvbkMUYXOWnBoX4YAvGVurRNVY60DoyfTAj04GLGk7ykO1cwU2nkTdve7lVSX9r1vpJ
         YxgFlHHs660KUfuzQKdn3BdTzaf4iMACI74DkpH/apD25Mg/upkWvusvnuKvpzRugX6b
         ZY9VRYm1riXTZNaEcrrLSBMOJaBVjCO9erUDjOhluayeswYSib7TvT2UxLjQ/3rT158j
         raWnaWxbX9gJ1CkH2sZ1OhE7Seab3FtsYZQt0hs6ic9Yd/vlbf2MDGdBFewXtc9pUJfg
         PZsA==
X-Gm-Message-State: AOAM532pxSN0PQo/U3WGzlsbUtH5GiGPKH+jRgZgflFowgjx5S1PbLlB
        AKnSgjuV4u8eTZk0bJbKJqMYGNWaNOXxqshdu8M=
X-Google-Smtp-Source: ABdhPJymiS734rtuGsbopIRoX1sbFmQSh0v52Blt3cR34tj3zL7gS0KUTKxKGNL2pPbl+t+73JWXxQ==
X-Received: by 2002:a05:651c:b8c:b0:24f:139e:ddde with SMTP id bg12-20020a05651c0b8c00b0024f139edddemr13093817ljb.62.1651699487422;
        Wed, 04 May 2022 14:24:47 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id t14-20020a05651c204e00b0024f3d1daeb2sm1803542ljo.58.2022.05.04.14.24.45
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 14:24:46 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id q130so3291591ljb.5
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 14:24:45 -0700 (PDT)
X-Received: by 2002:a2e:9d46:0:b0:24c:7f1d:73cc with SMTP id
 y6-20020a2e9d46000000b0024c7f1d73ccmr13958171ljj.358.1651699485493; Wed, 04
 May 2022 14:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
 <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
 <YnLeH7kBImX5XLNn@antec> <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
In-Reply-To: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 14:24:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgKEbppgxafYchqQ6X_VFa0d_vdtVmfqGQC6kQ+Hg9cAw@mail.gmail.com>
Message-ID: <CAHk-=wgKEbppgxafYchqQ6X_VFa0d_vdtVmfqGQC6kQ+Hg9cAw@mail.gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
To:     Stafford Horne <shorne@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 4, 2022 at 1:26 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Could be anywhere. Xfinity, Nest WiFi, or the cable router. They all
> are doing their own dns thing.
>
> Probably my cable box, since it's likely the oldest thing in the chain.

No, it seems to be my Nest WiFi router. I told it to use google DNS to
avoid Xfinity or the cable box, and it still shows the same behavior.

Not that I care much, since I consider those IDN names to be dangerous
anyway, but I think it would have been less sad if it had been some
old cable modem.

               Linus
