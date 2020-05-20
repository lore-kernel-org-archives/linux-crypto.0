Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09449C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 11:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5FC20829
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 11:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="bSnYXfe2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgETLxQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 07:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLxQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 07:53:16 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE3AC061A0E;
        Wed, 20 May 2020 04:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589975593;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=iPy9ZlubTd1xhTrkVXUYqz/ZgEBhY94Iy8kD2Y+7c9s=;
        b=bSnYXfe2rREgw1M3JnRrHJpV/Twt8OOdc8xnRGid09ngBxBYpI38/xQkpi5LYpfRaC
        Pf2x4bLTS1RDuyeHn9h4t7ziARKBU7GbEA99Yp8K6YXl1uZonxPYCzdtbo/V6eRhkWi6
        LdZ9vr35kR1UFnVBG+j33fe97yKVLpr0EgTqSSemWz3cBhCMEZl1TGxJdd/MCTij9j2B
        gN9U3YfRXvVZ7d3Dwa7vo7e+CzMKy4YhT78KWdbGF1hwiDBkEJcXVS18qZsIqLrNcBKT
        1rwdCV/8OGUKdI+Bc7E05ap3Y93TWTjmSJk3jyZd2XCbXaM+T2lUoQG0JbHzhVG1Pwqu
        egiw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4KBr45E5
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 13:53:04 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Wed, 20 May 2020 13:53:04 +0200
Message-ID: <2041475.ybOAuNAZB8@tauon.chronox.de>
In-Reply-To: <dleftjh7wa3my6.fsf%l.stelmach@samsung.com>
References: <15745285.MnsZKaK4VV@tauon.chronox.de> <CGME20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964@eucas1p1.samsung.com> <dleftjh7wa3my6.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 20. Mai 2020, 12:44:33 CEST schrieb Lukasz Stelmach:

Hi Lukasz,

> It was <2020-05-20 =C5=9Bro 11:18>, when Stephan Mueller wrote:
> > Am Mittwoch, 20. Mai 2020, 11:10:32 CEST schrieb Lukasz Stelmach:
> >> It was <2020-05-20 =C5=9Bro 08:23>, when Stephan Mueller wrote:
> >>> Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:
> >>>> The value was estimaded with ea_iid[1] using on 10485760 bytes read
> >>>> from the RNG via /dev/hwrng. The min-entropy value calculated using
> >>>> the most common value estimate (NIST SP 800-90P[2], section 6.3.1)
> >>>> was 7.964464.
> >>>=20
> >>> I am sorry, but I think I did not make myself clear: testing random
> >>> numbers post-processing with the statistical tools does NOT give any
> >>> idea about the entropy rate. Thus, all that was calculated is the
> >>> proper implementation of the post-processing operation and not the
> >>> actual noise source.
> >>>=20
> >>> What needs to happen is that we need access to raw, unconditioned
> >>> data from the noise source that is analyzed with the statistical
> >>> methods.
> >>=20
> >> I did understand you and I assure you the data I tested were obtained
> >> directly from RNGs. As I pointed before[1], that is how /dev/hwrng
> >> works[2].
> >=20
> > I understand that /dev/hwrng pulls the data straight from the
> > hardware. But the data from the hardware usually is not obtained
> > straight from the noise source.
> >=20
> > Typically you have a noise source (e.g. a ring oscillator) whose data
> > is digitized then fed into a compression function like an LFSR or a
> > hash. Then a cryptographic operation like a CBC-MAC, hash or even a
> > DRBG is applied to that data when the caller wants to have random
> > numbers.
>=20
> I do understand your point (but not entirely, see below). [opinion]
> However, I am really not sure that this is a "typical" setting for a HW
> RNG, at least not among RNGs supported by Linux. Otherwise there would
> be no hw_random framework and no rngd(8) which are suppsed to
> post-process imperfectly random data from HW. [/opinion]

The hw_random framework only makes these hardware RNG accessible for in-ker=
nel=20
as well as user space use.
>=20
> > In order to estimate entropy, we need the raw unconditioned data from
> > the, say, ring oscillator and not from the (cryptographic) output
> > operation.
>=20
> Can you tell, why it matters in this case? If I understand correctly,
> the quality field describes not the randomness created by the noise
> generator but the one delivered by the driver to other software
> components.

The quality field is used by add_hwgenerator_randomness to increase the Lin=
ux=20
RNG entropy estimator accordingly. This is the issue.

And giving an entropy rate based on post-processed data is meaningless.

The concern is, for example, that you use a DRBG that you seeded with, say,=
 a=20
zero buffer. You get perfect random data from it that no statistical test c=
an=20
disprove. Yet we know this data stream has zero entropy. Thus, we need to g=
et=20
to the source and assess its entropy.

>=20
> > That said, the illustrated example is typical for hardware RNGs. Yet
> > it is never guaranteed to work that way. Thus, if you can point to
> > architecture documentation of your specific hardware RNGs showing that
> > the data read from the hardware is pure unconditioned noise data, then
> > I have no objections to the patch.
>=20
> I can tell for sure that this is the case for exynos-trng[1].

So you are saying that the output for the exynos-trng is straight from a ri=
ng=20
oscillator without any post-processing of any kind?

If this is the case, I would like to suggest you add that statement to the =
git=20
commit message with that reference. If so, then I would withdraw my objecti=
on.

> There is a
> post-processor which I have forgotten about since writing the driver,
> because from the very beginning I didn't intend to use it. I knew there
> is the software framework for post-processing and simply didn't bother.
>=20
> With regards to iproc-rng200 I cannot be sure.
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
ri
> vers/char/hw_random/exynos-trng.c?h=3Dv5.6#n100
>=20
> Kind regards,


Ciao
Stephan


