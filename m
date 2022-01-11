Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64DFC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 07:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348457AbiAKHSG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 02:18:06 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:34839 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiAKHSG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 02:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641885479;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MRnjE9Z5ElkIORUL8grk4lSy5TJKyFtbbyPmKgxVLh0=;
    b=KX2oeT+zLTI+BHWsH3nnudd/Leitysyu2MK+yEFozzR9c3txb3ozUKeLzrZI5bkSc/
    OkvAaHiFedZHhFd4PG902KAf5xKviL7dmqqlO4Fa1Vu4yhDronoyItIaSXF6B7wPNxgG
    HoNxxpydJQ6X6Tm2crrjiUxAx8GQkFBdIAhtBdX2lTIvktfOuRrcqM98s3UwE25yCl/7
    Prdsa/mFEnb2fWNFj7vZllPexpZ5QiU5wLqTGY8brnE67T2CxFByZA+eQqEFxJfGl4Ka
    RKZB8pA0arUjsF2cBcExS02fEiCJBPnJPsIexqtHn1WoxnjLo2gjhl4MHRx3zuRFNAAr
    9oZA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSbY0c="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id t60e2cy0B7HwGZV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 08:17:58 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Niolai Stange <nstange@suse.com>, Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Tue, 11 Jan 2022 08:17:57 +0100
Message-ID: <1979340.Ftzpt9979A@tauon.chronox.de>
In-Reply-To: <2042139.9o76ZdvQCi@positron.chronox.de>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YdjMn75GFEOLvoDr@sol.localdomain> <2042139.9o76ZdvQCi@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 8. Januar 2022, 07:39:27 CET schrieb Stephan M=FCller:

Hi,

> Am Samstag, 8. Januar 2022, 00:28:31 CET schrieb Eric Biggers:
>=20
> Hi Eric,
>=20
> > Hi Stephan,
> >=20
> > On Fri, Jan 07, 2022 at 08:25:24PM +0100, Stephan M=FCller wrote:
> > > FIPS 140 requires a minimum security strength of 112 bits. This impli=
es
> > > that the HMAC key must not be smaller than 112 in FIPS mode.
> > >=20
> > > This restriction implies that the test vectors for HMAC that have a k=
ey
> > > that is smaller than 112 bits must be disabled when FIPS support is
> > > compiled.
> > >=20
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> >=20
> > This could make sense, but the weird thing is that the HMAC code has be=
en
> > like this from the beginning, yet many companies have already gotten th=
is
> > exact same HMAC implementation FIPS-certified.  What changed?
>=20
> FIPS 140-3 (which is now mandatory) requires this based on SP800-131A.

Here are a few more details:

The requirement from FIPS 140-3 that the crypto module (aka kernel crypto A=
PI)=20
must provide an indicator whether the algorithm(s) in use are FIPS complian=
t.

If you look at various user space libraries, they make quite an effort thes=
e=20
days to add that "service indicator" as an API. Adding such an API to the=20
crypto API is not helpful.

Thus we revert to the notion of a "global service indicator" meaning that w=
hen=20
the kernel is booted with fips=3D1, all algorithms operate in FIPS mode. Th=
is=20
means that all non-approved algos must be technically disabled.

There have been patches from me disabling RSA < 2k and others not too long=
=20
ago. In the future, I would expect additional patches disabling the use of =
GCM=20
when invoked without seqiv or disabling dh when not used with one of the up-
and-coming FFDHE / MODP groups from Nicolai's patch set. All those patches=
=20
revolve around the same issue.

Note, for some algorithms like XTS key check we already had such technical=
=20
enforcements. This was due to the fact that FIPS 140-2 required for some=20
aspects technical enforcements but for some others, "procedural" coverage (=
aka=20
documentation) was sufficient.

Ciao
Stephan


