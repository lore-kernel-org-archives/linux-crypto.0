Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2E4C433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 22:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9323C61132
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 22:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhDHWQV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 18:16:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhDHWQU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 18:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617920168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f53Jf6JjQR5CMt6Ykm4q1l2b8XVAEN4/334rnWuEa2Y=;
        b=Rh1ayv16guG5Pir5SfyDP903d69yRDzmh1dttmO7qUi6afHj/EAa+tbJLJj/RtB2Jv0GVR
        YY5ZD4DdgPPcfhMS8DXjyFmYOhxPNGTwMkB0DIpUPISuQyfpE1jRfmhuqqqBlutj2AXfJy
        MpUG4uY6uCXsI0+1iM1Qkhkuhe53RiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-co5dfCUxNFC3A9BXaJX4sg-1; Thu, 08 Apr 2021 18:16:06 -0400
X-MC-Unique: co5dfCUxNFC3A9BXaJX4sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F12B801814;
        Thu,  8 Apr 2021 22:16:05 +0000 (UTC)
Received: from ovpn-112-53.phx2.redhat.com (ovpn-112-53.phx2.redhat.com [10.3.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A711C6A97E;
        Thu,  8 Apr 2021 22:16:01 +0000 (UTC)
Message-ID: <5b9206d9d451de1358a2c633ebe460eeb5a84749.camel@redhat.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Thu, 08 Apr 2021 18:16:00 -0400
In-Reply-To: <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
         <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
         <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-04-08 at 15:55 -0600, Jason A. Donenfeld wrote:
> On Thu, Apr 8, 2021 at 7:55 AM Simo Sorce <simo@redhat.com> wrote:
> > > I'm not sure this makes so much sense to do _in wireguard_. If you
> > > feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> > > poly1305, then wouldn't it make most sense to disable _those_ modules
> > > instead? And then the various things that rely on those (such as
> > > wireguard, but maybe there are other things too, like
> > > security/keys/big_key.c) would be naturally disabled transitively?
> > 
> > The reason why it is better to disable the whole module is that it
> > provide much better feedback to users. Letting init go through and then
> > just fail operations once someone tries to use it is much harder to
> > deal with in terms of figuring out what went wrong.
> > Also wireguard seem to be poking directly into the algorithms
> > implementations and not use the crypto API, so disabling individual
> > algorithm via the regular fips_enabled mechanism at runtime doesn't
> > work.
> 
> What I'm suggesting _would_ work in basically the exact same way as
> this patch. Namely, something like:
> 
> diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
> index 288a62cd29b2..b794f49c291a 100644
> --- a/lib/crypto/curve25519.c
> +++ b/lib/crypto/curve25519.c
> @@ -12,11 +12,15 @@
>  #include <crypto/curve25519.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/fips.h>
> 
>  bool curve25519_selftest(void);
> 
>  static int __init mod_init(void)
>  {
> + if (!fips_enabled)
> + return -EOPNOTSUPP;
> +
>   if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
>       WARN_ON(!curve25519_selftest()))
>   return -ENODEV;
> 
> Making the various lib/crypto/* modules return EOPNOTSUPP will in turn
> mean that wireguard will refuse to load, due to !fips_enabled. It has
> the positive effect that all other things that use it will also be
> EOPNOTSUPP.
> 
> For example, what are you doing about big_key.c? Right now, I assume
> nothing. But this way, you'd get all of the various effects for free.
> Are you going to continuously audit all uses of non-FIPS crypto and
> add `if (!fips_enabled)` to every new use case, always, everywhere,
> from now into the boundless future? By adding `if (!fips_enabled)` to
> wireguard, that's what you're signing yourself up for. Instead, by
> restricting the lib/crypto/* modules to !fips_enabled, you can get all
> of those transitive effects without having to do anything additional.

I guess that moving the fips check down at the algorithms level is a
valid option. There are some cases that will be a little iffy though,
like when only certain key sizes cannot be accepted, but for the
wireguard case it would be clean.

> Alternatively, I agree with Eric - why not just consider this outside
> your boundary?

For certification purposes wireguard is not part of the module boundary
(speaking only for my company in this case).

But that is not the issue.

There is an expectation by customers that, when the kernel is in fips
mode, non-approved cryptography is not used (given those customers are
required by law/regulation to use only approved/certified
cryptography).
So we still have a strong desire, where possible, to not allow the
kernel to use non-certified cryptography, regardless of what is the
crypto module boundary (we do the same in user space).

HTH,
Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




