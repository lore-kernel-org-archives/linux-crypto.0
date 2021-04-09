Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCC6C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 02:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB12F610C9
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 02:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhDICpD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:45:03 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:48744 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhDICpC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 22:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617936286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbt6s8Xm+0C1xOzwiz1rM7kEjqZ3GwCpYUjNtvQ8fwo=;
        b=NuoCA2qXSwXBxPHvGhsMX28Wp0sOMV4tfvJPmDdEP95/kXrI/Rd2V6UrSiDfVwqAzLwy4G
        0eeTiSqtJYeM70fh29XPLBs7kIu+0oMNtFJGz+ZGOSsM7FVXL0gnIeZnd1X0dG5SFTX9cM
        YxrDXQ3GLBGYoBSEJq6XwKpSSDGeIIE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2509b4cb (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Apr 2021 02:44:46 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id n12so4951848ybf.8;
        Thu, 08 Apr 2021 19:44:46 -0700 (PDT)
X-Gm-Message-State: AOAM533kDwqTQ0PNOdEQkXuwtQdCRM94G+r6Ghl+Pqw0TjOeFb83efxP
        71OlDILHdkHy5DDdrxXDk7Hz2T0VAlxfCeMeX2M=
X-Google-Smtp-Source: ABdhPJx3eEkk2YNZQ0Z4xRktcT2FpMre8EaBM953qIVD47KrdvEHwwkk7M4/3W97SCtYfzxzQKOI3nyuo99+XSWUEUI=
X-Received: by 2002:a25:ad0f:: with SMTP id y15mr12846290ybi.306.1617936285990;
 Thu, 08 Apr 2021 19:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
 <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
 <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com> <20210409024143.GL2900@Leo-laptop-t470s>
In-Reply-To: <20210409024143.GL2900@Leo-laptop-t470s>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 8 Apr 2021 20:44:35 -0600
X-Gmail-Original-Message-ID: <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
Message-ID: <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Simo Sorce <simo@redhat.com>, Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hangbin,

On Thu, Apr 8, 2021 at 8:41 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> I agree that the best way is to disable the crypto modules in FIPS mode.
> But the code in lib/crypto looks not the same with crypto/. For modules
> in crypto, there is an alg_test() to check if the crytpo is FIPS allowed
> when do register.
>
> - crypto_register_alg()
>   - crypto_wait_for_test()
>     - crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult)
>       - cryptomgr_schedule_test()
>         - cryptomgr_test()
>           - alg_test()
>
> But in lib/crypto the code are more like a library. We can call it anytime
> and there is no register. Maybe we should add a similar check in lib/crypto.
> But I'm not familiar with crypto code... Not sure if anyone in linux-crypto@
> would like help do that.

Since it's just a normal module library, you can simply do this in the
module_init function, rather than deep within registration
abstractions.

> > diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
> > index 288a62cd29b2..b794f49c291a 100644
> > --- a/lib/crypto/curve25519.c
> > +++ b/lib/crypto/curve25519.c
> > @@ -12,11 +12,15 @@
> >  #include <crypto/curve25519.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> > +#include <linux/fips.h>
> >
> >  bool curve25519_selftest(void);
> >
> >  static int __init mod_init(void)
> >  {
> > + if (!fips_enabled)
> > + return -EOPNOTSUPP;
>
> Question here, why it is !fips_enabled? Shouldn't we return error when
> fips_enabled?

Er, just not thinking straight today. `if (fips_enabled)` is probably
what you want indeed.

Jason
