Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0047C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA03960F46
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 08:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhJZIj6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 04:39:58 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:25556 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJZIjq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 04:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635237442;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UHIcmmtXAz63qMGGo0D/G7B9h1QgSqadW2ikaM+wM/s=;
    b=btm+WfmSiWpmmZbicJvsZNNgLsu7laZpDG+W1j/OvmWRW4GCHo+b4Q4oKsN1D/8cvM
    xSKgg3KGkkE2VCZ02yjrGtmy3LHA3YWG0ymae9dsar31Hl+muY7fjmNlYzNjSndTWeSW
    HR2XrrH2NtzC61CL8jyqRQxmQTaLZCPN3Edm3DtHMubsMuc0ArTef3eTLVbIrAKJoTT8
    CjCXjyWU9xvE4OmIamiXQWZMiFZSlBUlgyxOjgO5F8+42DkLFiRBMux5gR/GUnYBRmTS
    8HYokqhhdIs+m9fS6a2eebkyu/gYsFwbiIcY5knAfp/bx0j2IDWR8oHleGjzOvaSDojO
    eTBg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q8bL20Q
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 10:37:21 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 1/6] crypto: DRBG - prepare for more fine-grained tracking of seeding state
Date:   Tue, 26 Oct 2021 10:37:21 +0200
Message-ID: <2351272.LuTyyo00Js@positron.chronox.de>
In-Reply-To: <20211025092525.12805-2-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-2-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:20 CEST schrieb Nicolai Stange:

Hi Nicolai,

> There are two different randomness sources the DRBGs are getting seeded
> from, namely the jitterentropy source (if enabled) and get_random_bytes().
> At initial DRBG seeding time during boot, the latter might not have
> collected sufficient entropy for seeding itself yet and thus, the DRBG
> implementation schedules a reseed work from a random_ready_callback once
> that has happened. This is particularly important for the !->pr DRBG
> instances, for which (almost) no further reseeds are getting triggered
> during their lifetime.
>=20
> Because collecting data from the jitterentropy source is a rather expensi=
ve
> operation, the aforementioned asynchronously scheduled reseed work
> restricts itself to get_random_bytes() only. That is, it in some sense
> amends the initial DRBG seed derived from jitterentropy output at full
> (estimated) entropy with fresh randomness obtained from get_random_bytes()
> once that has been seeded with sufficient entropy itself.
>=20
> With the advent of rng_is_initialized(), there is no real need for doing
> the reseed operation from an asynchronously scheduled work anymore and a
> subsequent patch will make it synchronous by moving it next to related
> logic already present in drbg_generate().
>=20
> However, for tracking whether a full reseed including the jitterentropy
> source is required or a "partial" reseed involving only get_random_bytes()
> would be sufficient already, the boolean struct drbg_state's ->seeded
> member must become a tristate value.
>=20
> Prepare for this by introducing the new enum drbg_seed_state and change
> struct drbg_state's ->seeded member's type from bool to that type.
>=20
> For facilitating review, enum drbg_seed_state is made to only contain
> two members corresponding to the former ->seeded values of false and true
> resp. at this point: DRBG_SEED_STATE_UNSEEDED and DRBG_SEED_STATE_FULL. A
> third one for tracking the intermediate state of "seeded from jitterentro=
py
> only" will be introduced with a subsequent patch.
>=20
> There is no change in behaviour at this point.
>=20
> Signed-off-by: Nicolai Stange <nstange@suse.de>

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

Ciao
Stephan


