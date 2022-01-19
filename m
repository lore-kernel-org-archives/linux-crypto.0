Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3763DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jan 2022 10:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345776AbiASKRt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jan 2022 05:17:49 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:47343 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349426AbiASKRs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jan 2022 05:17:48 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MEmpp-1n762b3UK3-00GFv6 for <linux-crypto@vger.kernel.org>; Wed, 19 Jan
 2022 11:17:46 +0100
Received: by mail-wm1-f54.google.com with SMTP id v123so4362876wme.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jan 2022 02:17:46 -0800 (PST)
X-Gm-Message-State: AOAM533VAa5kP0kc/zqj1+CXKows5y9Cao8iaDHp2XcrcoPp71Dhe68c
        /pPStNco0feZ+qmWIykMytz4XhEBf7fsZB2FRSs=
X-Google-Smtp-Source: ABdhPJxIlHNoUe8ZgY3HoUk1jhPEpLo1FY9cqBkT6/jqrN8ALkDEnDsPDJRrCgEVUJ2S8/GtQ3CasTZFhN5yQmQ02ro=
X-Received: by 2002:a05:600c:4e4e:: with SMTP id e14mr2752715wmq.98.1642587466476;
 Wed, 19 Jan 2022 02:17:46 -0800 (PST)
MIME-Version: 1.0
References: <20220119093109.1567314-1-ardb@kernel.org>
In-Reply-To: <20220119093109.1567314-1-ardb@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 19 Jan 2022 11:17:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3b+37jZBE_OSPg7zdrZeoton0X8cka6bxp5AGK3kD+yA@mail.gmail.com>
Message-ID: <CAK8P3a3b+37jZBE_OSPg7zdrZeoton0X8cka6bxp5AGK3kD+yA@mail.gmail.com>
Subject: Re: [PATCH] crypto: memneq: avoid implicit unaligned accesses
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:U0DPhcBCCELwr+YvguSv6xB34JJBCkM+fL7YbbeohuYL1qMUVHA
 hrZBty0uWFLkTrpK9QEPI4pWEqqb6Qahgw8LCotuZsvThSwReciiOcaiAz5zdJbvj4lOQlk
 1TO/rI+bhwWVGMbF34XXqzds95G+ExI6KzejPVqg9EMBElKGgIM/Oi/+Elih7Bq3UIc23za
 rC/27Do9/TnnG4H75XXIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4kk5PKYH0Q8=:bCSZIaU9BIoZ7dZBdXWnD9
 18IRee2nfXbbo3VmV6ScK9yMMeshlmuKfaXyGcg8z+mHwLxEEfck8n/UqLGIrGBfUarAkehj+
 c3z56HpDV9iV3whK2cZw39cp6Geijd9DjxeYBCVnVry5YHJckT1av3j/wbMFGRCWNsoh6jVry
 N7B+MF0Na7qb89OgFCYda0RNx+96UtWTGBk7uleJX66K86g/kqSZ8/IDka26DmiSQdiaPIxFN
 WvJYwr2y3MkHTmIVMLUzuDZnFC6BiAFYqB+9rXHUroDWxFusQwCwFm69ApW9+5Pf3L7Opdlqv
 4zC5GGRZtGL/9G9a4lpm5E7WiHY/NQysHrP9XXLQAXPNlaBiweVD1GdSHQJmaRO3NLr6dQRSO
 EXYgsojQffKqzkl3HCGCELVkQbO51yj4ZiTXxl4uRwyT3TBNX8NPgaA6vM1rRsUqVzCkH6dbL
 EVOGgNr1oNRpo2EnEBHi+AObat7IMf0llhMCa6tEHptMQE6HydCAgZafkgnDQElStsUTD5+8k
 Gl+UMYlJegVACB9KMVZJgkVZqEgrlabk4YLATEcxsJ+RfqAHeWIUYetavyu1QLNnlVtZPngPf
 ENTO2zIjRiPspEtAteiZ4/ygLHG3AJ/FKasVnKPS0Mde5QW5Mb8a8bkI+qQUhHPCvZp4c9pJh
 TTZ/qWMYKOxmXVkhnDaL7c+OCdNvvjE+mDiRTj7rYAqYa0hTcOKP6K2mq8BOHA/J9ZxQ=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 19, 2022 at 10:31 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The C standard does not support dereferencing pointers that are not
> aligned with respect to the pointed-to type, and doing so is technically
> undefined behavior, even if the underlying hardware supports it.
>
> This means that conditionally dereferencing such pointers based on
> whether CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y is not the right thing
> to do, and actually results in alignment faults on ARM, which are fixed
> up on a slow path. Instead, we should use the unaligned accessors in
> such cases: on architectures that don't care about alignment, they will
> result in identical codegen whereas, e.g., codegen on ARM will avoid
> doubleword loads and stores but use ordinary ones, which are able to
> tolerate misalignment.
>
> Link: https://lore.kernel.org/linux-crypto/CAHk-=wiKkdYLY0bv+nXrcJz3NH9mAqPAafX7PpW5EwVtxsEu7Q@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
