Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2145EC56202
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4303206FB
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ivy3bAt4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgKTKnx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727160AbgKTKnx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 05:43:53 -0500
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A3DA22226
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605869032;
        bh=b1sf02KEJbvUoLJkc8Qlcvgk25718OVezl/a9wBroWY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ivy3bAt490/MokoPxjD2JI450TKMUzega4IKcrWTjOKWKXWhDEiAldoSBCboNrw5q
         X17Szquhryk9TkjoUfvSUANybbJNUjhlqbzUnMRKAZjMWiFgNLODajnEY3r6oom2z1
         IJcfRNnjRHJnFKxP3svRGclW62F4yL74V+rE6LO8=
Received: by mail-ot1-f45.google.com with SMTP id y24so2748892otk.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 02:43:52 -0800 (PST)
X-Gm-Message-State: AOAM531D6c2NUS478crqgyzZVLiWiiVAommK3NEfUFUjKy1raowQrKho
        oUig9XCgX0fziD0ad3eyhJu1X2taHovY8GwIAVA=
X-Google-Smtp-Source: ABdhPJwhytMyPEFzKy1wq2uVkrZYd1+8VZCpRztRHFaAcLnxYftXKjJ2jNL0d5icOoIOo9HQ+cMpsLewI856kfKmydc=
X-Received: by 2002:a05:6830:3099:: with SMTP id f25mr549530ots.77.1605869031717;
 Fri, 20 Nov 2020 02:43:51 -0800 (PST)
MIME-Version: 1.0
References: <20201109083143.2884-1-ardb@kernel.org> <20201109083143.2884-3-ardb@kernel.org>
 <20201120034440.GA18047@gondor.apana.org.au> <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
 <20201120100936.GA22225@gondor.apana.org.au> <CAMj1kXGu67h96=RvVDRM2z9-N4KcvOLnr6EurjkpbPdZQfh6qw@mail.gmail.com>
 <20201120103750.GA22319@gondor.apana.org.au> <CAMj1kXFdhZ8RZp6MQVJ6bgXNoLNr3pfDBkhhVvEGuLFb1xQo3g@mail.gmail.com>
 <20201120104208.GA22365@gondor.apana.org.au>
In-Reply-To: <20201120104208.GA22365@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Nov 2020 11:43:40 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGKRU0D=oJpLOkSoEVO49dB5xTG7phP30RmMH-=U6rmZQ@mail.gmail.com>
Message-ID: <CAMj1kXGKRU0D=oJpLOkSoEVO49dB5xTG7phP30RmMH-=U6rmZQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Nov 2020 at 11:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Nov 20, 2020 at 11:40:24AM +0100, Ard Biesheuvel wrote:
> >
> > Yeah, that would work, but enabling it as a builtin produces a lot of
> > bogus output if you fail to set the tcrypt.mode=xxx kernel command
> > line option, so it is really only intended for deliberate use.
>
> Perhaps replace it with a depends on m || EXPERT?
>

That would be an option, but since we basically already have our own
local 'EXPERT' option when it comes to crypto testing, I thought I'd
use that instead.
