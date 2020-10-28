Return-Path: <SRS0=zC9F=ED=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED402C55179
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B3E32470E
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="L2xbAiWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgJ1V4S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgJ1V4O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 17:56:14 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6EEC0613CF
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2020 14:56:14 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a12so441700ybg.9
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2020 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ZlXToatDcyQe4UfooUu3JrhisJTqzWvPk9UeTaykHI=;
        b=L2xbAiWTTbIrt5K7yoWLPYgbHcR6JA3ygW52PmeYhcPUro9EBJ7jeSZ+LuUceUwi6h
         7oJ0nyVewkcb5K+ygEJWYYMKXhaWMSobBdS26zzBkdJSzJLQfkJ9ORBytL4idG2x8OiJ
         9aarfLTEzGCk1uCjCog7oi7V7msQ35V7eKNBN6lB3Pt0XeZUaZZGqxIfwBcha2zEJ3WN
         kZ9kfFU6h35Lf2aGkBLA0WhEm9MhweORqvnr/qOj6MkqYCWc4yB4rpgdiBoO/86iCgZ7
         IEUBBDYCvLrMJVulHBHcZCHWqbinwfnCxIm8NM7pVPl6asD8IeCh1a7crlyWFtjVbf2K
         AdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ZlXToatDcyQe4UfooUu3JrhisJTqzWvPk9UeTaykHI=;
        b=Ne+ZZbKLe2lIY33kP3nTw/kiIDuXDgkMH9fFlqOV6vs93BLcOF9ArvJ6sQ0dqrwArC
         v5oEAX38vgPA5geOfrsxtcCZ6RYrJ6ur0koaq1ajbC8KM4DZXji8uEwMtNfp3aVLmAKf
         QJp89A5BXVCw3aQ8wOdoP3hlvteACyzVX8EOjBzHXB5zsY1epp5ASgdD8cnzy2beZwFt
         +7Ou/7ppjSURdP2TKDDuBsgWt6VFR9XiMwle5XUm/AeHh2Tj3FWnRBM+era/blW+aHUv
         KSW9Q5Bk9RduYos+Hwc2Ip+k33dxbcG4hLFdP3yrb3K3EXi0QV/dx3Zz4UOU0DxZ72kJ
         xl1w==
X-Gm-Message-State: AOAM533ZUkEbAofnrhkt1LUwZxNQd5Emyge85z05I7hiNTOuzGuoST0b
        0Qnzoe9/8ZOc6uciCTfBk21wX781kWmAove8zhvTbQ8xzAA9GA==
X-Google-Smtp-Source: ABdhPJwPEPpN0dIcKBfaGDgutMYF3sOkE6KoP9i1uddB1epbqqtMw2qCiW/gFeatIzJ1+Wk2li1pZyaWC1wQlcX+ghA=
X-Received: by 2002:a25:41d0:: with SMTP id o199mr9520447yba.276.1603885293714;
 Wed, 28 Oct 2020 04:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com> <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain> <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
 <20201026183936.GJ858@sol.localdomain> <20201026184155.GA6863@gondor.apana.org.au>
 <20201026184402.GA6908@gondor.apana.org.au>
In-Reply-To: <20201026184402.GA6908@gondor.apana.org.au>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 28 Oct 2020 13:41:28 +0200
Message-ID: <CAOtvUMf-xv5cHTjExW2Ffx6soLavFztow6DwE6Qo5pffF0N5uw@mail.gmail.com>
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 8:44 PM Herbert Xu <herbert@gondor.apana.org.au> wr=
ote:
>
> On Tue, Oct 27, 2020 at 05:41:55AM +1100, Herbert Xu wrote:
> >
> > The point is that people rebuilding their kernel can end up with a
> > broken system.  Just set a default on EBOIV if dm-crypt is on.
>
> That's not enough as it's an existing option.  So we need to
> add a new Kconfig option with a default equal to dm-crypt.

Sorry if I'm being daft, but what did you refer to be "an existing
option"? there was no CONFIG_EBOIV before my patchset, it was simply
built as part of dm-crypt so it seems that setting CONFIG_EBOIV
default to dm-crypto Kconfig option value does solves the problem, or
have I missed something?

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
