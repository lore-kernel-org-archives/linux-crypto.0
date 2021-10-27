Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4B3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 18:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B1761039
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 18:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhJ0SqO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 14:46:14 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:30097 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238382AbhJ0SqN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 14:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635360224;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=8dmzvbAY2zD0jIDT/JUNyjCXUAI+Jsnu1YfCVPC0KNo=;
    b=db+zZ6Iho1wVd4JUzzFZ0kNn5AYxFHkzuvkDWyOnspxXgNCW/+r5BEsGksSSn7MWQA
    w/XOIr0bR7wXyIxQxu7T+91xYuvyTZqna0OwcHSafsJZkZu7dFC9Mpa/MpPONphVllMU
    vs7d3GXSeT6hWDf4m4OjdU2u8/aHNw4uP6i+CopxOe5J97jdtyyJtfnzf5C6tPe/NSRY
    8ijlXxOxYJjlG7IDO1BV95RohZ1qIuSmbQZ+cGS4rQFKdjXjj7+OOk+OMf4AM401xVpN
    K7CsXytQotVZW7HBoMdek6xsB7tEDYlzHRFspnuwpmmxao/F5ffVhKPgFgbUdQtowdwt
    +/0A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9RIhhA1i
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 27 Oct 2021 20:43:43 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>, Torsten Duwe <duwe@suse.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto: DRBG - improve 'nopr' reseeding
Date:   Wed, 27 Oct 2021 20:43:42 +0200
Message-ID: <2466958.tJBOlap2oN@positron.chronox.de>
In-Reply-To: <87zgqurhcj.fsf@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <2120606.3HGXcN3vsr@positron.chronox.de> <87zgqurhcj.fsf@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 27. Oktober 2021, 10:40:12 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Hi Stephan,
>=20
> first of all, many thanks for your prompt review!
>=20
> Stephan M=FCller <smueller@chronox.de> writes:
> > Am Montag, 25. Oktober 2021, 11:25:19 CEST schrieb Nicolai Stange:
> >> - Replace the asynchronous random_ready_callback based DRBG reseeding
> >>=20
> >>   logic with a synchronous solution leveraging rng_is_initialized().
> >=20
> > Could you please help me why replacing an async method with a sync meth=
od
> > is helpful? Which problems do you see with the async method that are
> > alleviated with the swtich to the sync method? In general, an async
> > method is more powerful, though it requires a bit more code.
>=20
> There is no problem with the async method (*), I just don't see any
> advantage over the less complex approach of doing all reseeding
> work synchronously from drbg_generate().
>=20
> Before the change, there had been two sites taking care of reseeding:
> the drbg_async_seed() work handler scheduled from the
> random_ready_callback and drbg_generate().
>=20
> After the change, all reseeding is handled at a single place only, namely
> drbg_generate(), which, in my opinion, makes it easier to reason about.
> In particular, in preparation for patch 6/6 from this series introducing
> yet another condition for triggering a reseed...

That makes sense. Thanks for clarifying.

Ciao
Stephan
>=20
> Thanks,
>=20
> Nicolai
>=20
> (*) Except for that a wait_for_random_bytes() issued by DRBG users won't
>     give any guarantees with respect to a subsequent drbg_generate()
>     operation, c.f. my other mail in reply to your review on 3/6 I'm
>     about to write in a second. As of now, there aren't any DRBG users
>     invoking wait_for_random_bytes(), but one might perhaps consider
>     changing that in the future.
>=20
> >>   This
> >>   move simplifies the code IMO and, as a side-effect, would enable DRBG
> >>   users to rely on wait_for_random_bytes() to sync properly with
> >>   drbg_generate(), if desired. Implemented by patches 1-5/6.
> >>=20
> >> - Make the 'nopr' DRBGs to reseed themselves every 5min from
> >>=20
> >>   get_random_bytes(). This achieves at least kind of a partial predict=
ion
> >>   resistance over the time domain at almost no extra cost. Implemented
> >>   by patch 6/6, the preceding patches in this series are a prerequisite
> >>   for this.


Ciao
Stephan


