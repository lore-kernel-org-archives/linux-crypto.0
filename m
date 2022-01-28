Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84F3C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 15:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiA1Phd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 10:37:33 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:38357 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiA1Phd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 10:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643384248;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=z9B9LbV9dvuua4pywx57DeccaLvxUyezmmR5QCPxp/A=;
    b=bOIw1VNoGbCnVSm+OKxfCtRNLlQkD5a86xlmCb4k01JJTl5d1IREsEBkZZQzHr7J7y
    gGO/CPwJClQV0DpkDtjynL0W55BVKyweCntmK4CO1I3VayNYvzT4ibRtJl7Qzcsm1DOs
    HI5/q5lo5uEwu08scEdbpHTQI+UZEscU59PUaaGmt3uJSjFHrgrdQhLqvtN4NuoKAjrg
    w0zH7xNkta733zvnsvtuOn+GI1+zMPBGkX58EmOHpGFeuOft53RzwPmnqLMuMmjSvI1R
    yVUyqFw9QOPdxEyIkm+8PnlurDYp8sl5aCxqcdgg6Ceb9X3ZXWPew63fMz/RGx+2VNvJ
    +zuA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvSOeuZzLM="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0SFbRwv4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 16:37:27 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        simo@redhat.com, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/7] Common entropy source and DRNG management
Date:   Fri, 28 Jan 2022 16:37:26 +0100
Message-ID: <9785493.cvP5XnM2Xn@tauon.chronox.de>
In-Reply-To: <YfHP3xs6f68wR/Z/@sol.localdomain>
References: <2486550.t9SDvczpPo@positron.chronox.de> <YfHP3xs6f68wR/Z/@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 26. Januar 2022, 23:49:03 CET schrieb Eric Biggers:

Hi Eric,

> On Wed, Jan 26, 2022 at 08:02:54AM +0100, Stephan M=FCller wrote:
> > The current code base of the kernel crypto API random number support
> > leaves the task to seed and reseed the DRNG to either the caller or
> > the DRNG implementation. The code in crypto/drbg.c implements its own
> > seeding strategy. crypto/ansi_cprng.c does not contain any seeding
> > operation. The implementation in arch/s390/crypto/prng.c has yet
> > another approach for seeding. Albeit the crypto_rng_reset() contains
> > a seeding logic from get_random_bytes, there is no management of
> > the DRNG to ensure proper reseeding or control which entropy sources
> > are used for pulling data from.
>=20
> ansi_cprng looks like unused code that should be removed, as does the s390
> prng.
>=20
> With that being the case, what is the purpose of this patchset?

I would agree that ansi_csprng could be eliminated at this stage. However, =
the=20
S390 DRBG code base provides access to the CPACF DRBG implemented in the IB=
M Z=20
processors. That implementation must be seeded from software. See the funct=
ion=20
invocation of cpacf_klmd or cpacf_kmc in the prng.c file.

The extraction of the entropy source and DRNG management into its own=20
component separates out the security sensitive implementation currently fou=
nd=20
in multiple locations following the strategy found in the crypto API where=
=20
each moving part is separated and encapsulated.

The current implementation of the ESDM allows an easy addition of new entro=
py=20
sources which are properly encapsulated in self-contained code allowing sel=
f-
contained entropy analyses to be performed for each. These entropy sources=
=20
would provide their seed data completely separate from other entropy source=
s=20
to the DRNG preventing any mutual entanglement and thus challenges in the=20
entropy assessment. I have additional entropy sources already available tha=
t I=20
would like to contribute at a later stage. These entropy sources can be=20
enabled, disabled or its entropy rate set as needed by vendors depending on=
=20
their entropy source analysis. Proper default values would be used for the=
=20
common case where a vendor does not want to perform its own analysis or a=20
distro which want to provide a common kernel binary for many users.

The conditioning hash that is available to the entropy sources is currently=
=20
fixed to a SHA-256 software implementation. To support conveying more entro=
py=20
through the conditioning hash, I would like to contribute an extension that=
=20
allows the use of the kernel crypto API's set of message digest=20
implementations to be used. This would not only allow using larger message=
=20
digests, but also hashes other than SHA.

Depending on use cases, it is possible that different initial seeding=20
strategies are required to be considered for the DRNG. The initial patch se=
t=20
provides the oversampling of entropy sources and of the initial seed string=
 in=20
addition to the conventional approach of providing at least as much entropy=
 as=20
the security strength of the DRNG. There is a different seeding strategy in=
=20
the pipeline that is considered by other cryptographers for which I would l=
ike=20
to contribute the respective patch.

NUMA-awareness is another aspect that should be considered. The DRNG manage=
r=20
is prepared to instantiate one DRNG per node. The respective handler code,=
=20
however, is not part of the initial code drop.

In addition to the different DRNG implementations discussed before, there i=
s=20
the possibility to add an implementation to support atomic operations. The=
=20
current DRBG does not guarantee to be suitable for such use cases.

Ciao
Stephan


