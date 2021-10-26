Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57F7C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 877AD60F21
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 09:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhJZJfh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:35:37 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:29047 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhJZJfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 05:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635240790;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fGDDsDctVaRMHIggoIoP1bVsbZmKxZfSLPjlDlyrLuY=;
    b=QHTuOfySLdUKrKb6cge7CabKGKPSH3BJgIHoMwi2dCFV9JtcsbIE2h/OekR2OpNzKv
    BKALMTupQN4Q7UHYVmImrn9W88UmlaHM0sHvN6r/+TAmQPWXnS87OLpOZ5VfyQFd54sk
    28C0C3DnsbpiMwJMh/KtLdOCNDapouLpPVtfM3caoYCKimjqMZyw7auzyXQQ/Y9uL/Sj
    ePjSoALwDVzttnYdnaREZjCJ7Rzy9djsIcwNoeTs0RRcOcFSzZiuL4KnBmIiDmn3/MCT
    g5wvjz10tzjDoqwbRDG64Yn57Sx3A4jpyDhznXPXALXgqLQwXzyCFih1PpkS/kPjnWrL
    fEOg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3JdRcQGaevZhmp"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.1 DYNA|AUTH)
    with ESMTPSA id n020a8x9Q9X92OF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 26 Oct 2021 11:33:09 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 6/6] crypto: DRBG - reseed 'nopr' drbgs periodically from get_random_bytes()
Date:   Tue, 26 Oct 2021 11:33:08 +0200
Message-ID: <2978329.31agJDbIcV@positron.chronox.de>
In-Reply-To: <20211025092525.12805-7-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de> <20211025092525.12805-7-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 25. Oktober 2021, 11:25:25 CEST schrieb Nicolai Stange:

Hi Nicolai,

> In contrast to the fully prediction resistant 'pr' DRBGs, the 'nopr'
> variants get seeded once at boot and reseeded only rarely thereafter,
> namely only after 2^20 requests have been served each. AFAICT, this
> reseeding based on the number of requests served is primarily motivated
> by information theoretic considerations, c.f. NIST SP800-90Ar1,
> sec. 8.6.8 ("Reseeding").
>=20
> However, given the relatively large seed lifetime of 2^20 requests, the
> 'nopr' DRBGs can hardly be considered to provide any prediction resistance
> whatsoever, i.e. to protect against threats like side channel leaks of the
> internal DRBG state (think e.g. leaked VM snapshots). This is expected and
> completely in line with the 'nopr' naming, but as e.g. the
> "drbg_nopr_hmac_sha512" implementation is potentially being used for
> providing the "stdrng" and thus, the crypto_default_rng serving the
> in-kernel crypto, it would certainly be desirable to achieve at least the
> same level of prediction resistance as get_random_bytes() does.
>=20
> Note that the chacha20 rngs underlying get_random_bytes() get reseeded
> every CRNG_RESEED_INTERVAL =3D=3D 5min: the secondary, per-NUMA node rngs=
 from
> the primary one and the primary rng in turn from the entropy pool, provid=
ed
> sufficient entropy is available.
>=20
> The 'nopr' DRBGs do draw randomness from get_random_bytes() for their
> initial seed already, so making them to reseed themselves periodically fr=
om
> get_random_bytes() in order to let them benefit from the latter's
> prediction resistance is not such a big change conceptually.
>=20
> In principle, it would have been also possible to make the 'nopr' DRBGs to
> periodically invoke a full reseeding operation, i.e. to also consider the
> jitterentropy source (if enabled) in addition to get_random_bytes() for t=
he
> seed value. However, get_random_bytes() is relatively lightweight as
> compared to the jitterentropy generation process and thus, even though the
> 'nopr' reseeding is supposed to get invoked infrequently, it's IMO still
> worthwhile to avoid occasional latency spikes for drbg_generate() and
> stick to get_random_bytes() only. As an additional remark, note that
> drawing randomness from the non-SP800-90B-conforming get_random_bytes()
> only won't adversely affect SP800-90A conformance either: the very same is
> being done during boot via drbg_seed_from_random() already once
> rng_is_initialized() flips to true and it follows that if the DRBG
> implementation does conform to SP800-90A now, it will continue to do so.
>=20
> Make the 'nopr' DRBGs to reseed themselves periodically from
> get_random_bytes() every CRNG_RESEED_INTERVAL =3D=3D 5min.
>=20
> More specifically, introduce a new member ->last_seed_time to struct
> drbg_state for recording in units of jiffies when the last seeding
> operation had taken place. Make __drbg_seed() maintain it and let
> drbg_generate() invoke a reseed from get_random_bytes() via
> drbg_seed_from_random() if more than 5min have passed by since the last
> seeding operation. Be careful to not to reseed if in testing mode though,
> or otherwise the drbg related tests in crypto/testmgr.c would fail to
> reproduce the expected output.
>=20
> In order to keep the formatting clean in drbg_generate() wrap the logic
> for deciding whether or not a reseed is due in a new helper,
> drbg_nopr_reseed_interval_elapsed().
>=20
> Signed-off-by: Nicolai Stange <nstange@suse.de>

=46or the code review:

Reviewed-by: Stephan M=FCller <smueller@chronox.de>

But with respect to the overall architecture of the seeding in the entire=20
kernel, this is insufficient (note, I am not saying that this patch series=
=20
should and can fix it though). It is insufficient, because:

=2D reseeding does not happen if new data is received by the kernel entropy=
=20
gathering functions like the RNDADDENTROPY IOCTL or add_hwgenerator_randomn=
ess=20
=2D i.e. externally provided data lingers without being used in the DRBG

=2D reseeding does not consider the amount of entropy added from the entrop=
y=20
sources allowing potential pathological weak reseeding operation

=2E.. and other seeding problems in random.c...

Ciao
Stephan


