Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102B7C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 18:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDED7205C9
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 18:10:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JBs2gM9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfF1SKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 14:10:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36566 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfF1SKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 14:10:06 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so14465046ioh.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYWzxaXovWkgcEFlvE0Xp9fq1rOCMq8z72F52B44Ujo=;
        b=JBs2gM9vBb0OEheV98pM2TtHhfvao8WVFb/KDlJasoM8LrxPjvce9QWMr4CbXM7gsN
         /L3V4zTrpANLu5oYIMVWIdVAJowlk/NYmFQKAaV/e2Bf+pwR4xUWTHs7RBP+S+HeG1tI
         QFolz3Rspj+hz3yjnfHJU7Wyg17h+Y3/MyhsccFBT/OEV6oBC8OCcseyvzjGQ9PwVsYI
         OcbKxU7xN86B3Pc2D9rdZmX67/m/EViCsspr+LJz9irXDnwT5yxN+vjK3UX7dyAecF64
         V86SMKcf8MlKWmT9ZltVPhmW5fo4v1OQZDA/b4GsQEP6EvYa4XMveR2GSVS1uuTnFMDR
         JneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYWzxaXovWkgcEFlvE0Xp9fq1rOCMq8z72F52B44Ujo=;
        b=SgkWLFe2sa9KCY2L9GqsZMFL/RV78b1W5fl/auYZoXJ1ayn3BoJufUi+HckY/kszbp
         6R+JT7HpU5B6z5bW9x6C7f04cKySyApVSALjehS0kgKIaW0rALMWF5GGEI5t+EszVx7k
         kXqQnYb6NCdeVwyeWMCIlSRUcCaxhMGcEiY78VWd+cWu2wtvfZP4s20Mu4UKnLJrIGOV
         rDrnxbz+byHqRRtpj9OHzq5qhTvo8QLHWaDCZ/TrQgr+BJVjj9wT1K/czGY2EUH49O2u
         sdIh6pZ4cMh3WaE0vK4jpP5twSus0AYHVKXohL5hZmw+Csz2hkWuqLhZx/L+W9Q6/ydl
         OgZA==
X-Gm-Message-State: APjAAAVfWVedNMoN1wdwoiluIqn4HsAi2los66nTMTDB5lwp550redYX
        dG+xjM98XvVeO+FjSUxAp6AZCrnnM38AfPkxDWkSvg==
X-Google-Smtp-Source: APXvYqx+NnMbClpJ2onsdNYXMm8sivmrFOPXnQEQXLACcIeC5bs6mQctMPqplE9EHAQBbs0DgHi+8Q5JrWxFZp49S78=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr11858580ion.65.1561745405295;
 Fri, 28 Jun 2019 11:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-3-ard.biesheuvel@linaro.org> <20190628180037.GC103946@gmail.com>
In-Reply-To: <20190628180037.GC103946@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 28 Jun 2019 20:09:54 +0200
Message-ID: <CAKv+Gu9=6uWSy2V4=7CVU6oqVUA0GFrjXHp48aiZ6sd_YQH-Uw@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] fs: crypto: invoke crypto API for ESSIV handling
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 28 Jun 2019 at 20:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 05:21:07PM +0200, Ard Biesheuvel wrote:
> > diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> > index dcd91a3fbe49..f39667d4316a 100644
> > --- a/fs/crypto/keyinfo.c
> > +++ b/fs/crypto/keyinfo.c
> > @@ -13,14 +13,10 @@
> >  #include <linux/hashtable.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/ratelimit.h>
> > -#include <crypto/aes.h>
> >  #include <crypto/algapi.h>
> > -#include <crypto/sha.h>
> >  #include <crypto/skcipher.h>
> >  #include "fscrypt_private.h"
> >
> > -static struct crypto_shash *essiv_hash_tfm;
> > -
> >  /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
> >  static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
> >  static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
> > @@ -144,10 +140,9 @@ static struct fscrypt_mode available_modes[] = {
> >       },
> >       [FS_ENCRYPTION_MODE_AES_128_CBC] = {
> >               .friendly_name = "AES-128-CBC",
> > -             .cipher_str = "cbc(aes)",
> > +             .cipher_str = "essiv(cbc(aes),aes,sha256)",
> >               .keysize = 16,
> > -             .ivsize = 16,
> > -             .needs_essiv = true,
> > +             .ivsize = 8,
> >       },
>
> Now that the essiv template takes the same size IV, the .ivsize here needs to be
> left as 16.
>

indeed. Thanks for spotting that.
