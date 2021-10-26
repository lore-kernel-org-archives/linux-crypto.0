Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E88C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB8D60ED4
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhJZIo0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 04:44:26 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:18826 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhJZIo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 04:44:26 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 04:44:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635237716;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=u1DhPlwbDH666DKBWaor9+8Usu29r6LeIHM2pVITEKg=;
    b=fF7nAZBp3GJjqTX3Hpic/QC7nQ2vmzNkc9KwfH66VQIQeGm/BsFbfHlWOVPMKFT7Yc
    w+y7vpxI2z6CK7/VW00iFr19L4bze2nhTYpx9NK3YEdVB34ehJDRKhlUXhcS0cLjU4Y9
    9TQB53wnEcRBxjvATxnbSOOp0acgWbBk5l2vip4OYIfC3iN7EfUr4tATYKUTCj+XTV9m
    I2uEA4/VLr+dezwfW/LQ6N6Rcq9I7PsaJ4LAWwuPA6UmxvbkUGv+oz+wyYYridI9puZj
    Km6+Rbco3JVz2kw9mmclhrdv9so4n6F5b4Sy6cmz5TM7mXhRWmJlWksnUv/HdCUvE8Gp
    2QOA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q8fs22X
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 10:41:54 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 2/6] crypto: DRBG - track whether DRBG was seeded with !rng_is_initialized()
Date:   Tue, 26 Oct 2021 10:41:53 +0200
Message-ID: <56392671.GheZNe4kVQ@positron.chronox.de>
In-Reply-To: <20211025092525.12805-3-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-3-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:21 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Currently, the DRBG implementation schedules asynchronous works from
> random_ready_callbacks for reseeding the DRBG instances with output from
> get_random_bytes() once the latter has sufficient entropy available.
>=20
> However, as the get_random_bytes() initialization state can get queried by
> means of rng_is_initialized() now, there is no real need for this
> asynchronous reseeding logic anymore and it's better to keep things simple
> by doing it synchronously when needed instead, i.e. from drbg_generate()
> once rng_is_initialized() has flipped to true.
>=20
> Of course, for this to work, drbg_generate() would need some means by whi=
ch
> it can tell whether or not rng_is_initialized() has flipped to true since
> the last seeding from get_random_bytes(). Or equivalently, whether or not
> the last seed from get_random_bytes() has happened when
> rng_is_initialized() was still evaluating to false.
>=20
> As it currently stands, enum drbg_seed_state allows for the representation
> of two different DRBG seeding states: DRBG_SEED_STATE_UNSEEDED and
> DRBG_SEED_STATE_FULL. The former makes drbg_generate() to invoke a full
> reseeding operation involving both, the rather expensive jitterentropy as
> well as the get_random_bytes() randomness sources. The DRBG_SEED_STATE_FU=
LL
> state on the other hand implies that no reseeding at all is required for a
> !->pr DRBG variant.
>=20
> Introduce the new DRBG_SEED_STATE_PARTIAL state to enum drbg_seed_state f=
or
> representing the condition that a DRBG was being seeded when
> rng_is_initialized() had still been false. In particular, this new state
> implies that
> - the given DRBG instance has been fully seeded from the jitterentropy
>   source (if enabled)
> - and drbg_generate() is supposed to reseed from get_random_bytes()
>   *only* once rng_is_initialized() turns to true.
>=20
> Up to now, the __drbg_seed() helper used to set the given DRBG instance's
> ->seeded state to constant DRBG_SEED_STATE_FULL. Introduce a new argument
> allowing for the specification of the to be written ->seeded value instea=
d.
> Make the first of its two callers, drbg_seed(), determine the appropriate
> value based on rng_is_initialized(). The remaining caller,
> drbg_async_seed(), is known to get invoked only once rng_is_initialized()
> is true, hence let it pass constant DRBG_SEED_STATE_FULL for the new
> argument to __drbg_seed().
>=20
> There is no change in behaviour, except for that the pr_devel() in
> drbg_generate() would now report "unseeded" for ->pr DRBG instances which
> had last been seeded when rng_is_initialized() was still evaluating to
> false.
>=20
> Signed-off-by: Nicolai Stange <nstange@suse.de>

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan


