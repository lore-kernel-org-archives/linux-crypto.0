Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127D8C433E3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3F0207F9
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="opcHvNIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgETJSz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 05:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJSy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 05:18:54 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCB2C061A0E;
        Wed, 20 May 2020 02:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589966330;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=jnu5hWhBP4JZRIy4PRG4U6miSmGbRgsPoOIk1eFJ53E=;
        b=opcHvNIS2wUmw7Z8RZ1xMShDtJeCEMF2S+IkoH4VGplXLFVF9y22JJ9TZPnZYh4Rdy
        i6wkhmgcfBQHzF3VxqKfXAYptX9H3/FG4YiJzCo7GANAEzeC5iX7PR6O6bqmmNE/LCIh
        WIfpu0IqwbVzf03B/9hBW21168BNxHJhesyFKjkfTFwMJrnTQgAuPlxdYYDOLhpofFfu
        3pFRffsvVKBBAuqt9hWkvXkegriOQohGq0xA9sWTgWaV4LL36r3bgjvYc8Rb/D9WXOda
        mOEU5gHHrOtFZ211MbFl5AQ2tx8jf7k9NxcVwaRbDujt+miqvgtZnXZHdP+l+Eov+uzf
        frvQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmgLKehaO2hZDSTWbg/LOA=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 AUTH)
        with ESMTPSA id k09005w4K9IZ4DL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 11:18:35 +0200 (CEST)
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
Date:   Wed, 20 May 2020 11:18:32 +0200
Message-ID: <15745285.MnsZKaK4VV@tauon.chronox.de>
In-Reply-To: <dleftjr1vf2cqf.fsf%l.stelmach@samsung.com>
References: <1748331.j7eDFAdTc1@tauon.chronox.de> <CGME20200520091043eucas1p15ecae108007382a95b01e42241cc7a26@eucas1p1.samsung.com> <dleftjr1vf2cqf.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 20. Mai 2020, 11:10:32 CEST schrieb Lukasz Stelmach:

Hi Lukasz,

> It was <2020-05-20 =C5=9Bro 08:23>, when Stephan Mueller wrote:
> > Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:
> >> The value was estimaded with ea_iid[1] using on 10485760 bytes read fr=
om
> >> the RNG via /dev/hwrng. The min-entropy value calculated using the most
> >> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.
> >=20
> > I am sorry, but I think I did not make myself clear: testing random
> > numbers
> > post-processing with the statistical tools does NOT give any idea about
> > the
> > entropy rate. Thus, all that was calculated is the proper implementation
> > of
> > the post-processing operation and not the actual noise source.
> >=20
> > What needs to happen is that we need access to raw, unconditioned data
> > from
> > the noise source that is analyzed with the statistical methods.
>=20
> I did understand you and I assure you the data I tested were obtained
> directly from RNGs. As I pointed before[1], that is how /dev/hwrng
> works[2].

I understand that /dev/hwrng pulls the data straight from the hardware. But=
=20
the data from the hardware usually is not obtained straight from the noise=
=20
source.

Typically you have a noise source (e.g. a ring oscillator) whose data is=20
digitized then fed into a compression function like an LFSR or a hash. Then=
 a=20
cryptographic operation like a CBC-MAC, hash or even a DRBG is applied to t=
hat=20
data when the caller wants to have random numbers.

In order to estimate entropy, we need the raw unconditioned data from the,=
=20
say, ring oscillator and not from the (cryptographic) output operation.

That said, the illustrated example is typical for hardware RNGs. Yet it is=
=20
never guaranteed to work that way. Thus, if you can point to architecture=20
documentation of your specific hardware RNGs showing that the data read fro=
m=20
the hardware is pure unconditioned noise data, then I have no objections to=
=20
the patch.
>=20
> If I am wrong, do show me the code that processes the data from a HW RNG
> before copying them to user provided buffer[3].

I am not talking about any software post-processing. I am talking about pos=
t-
processing within the hardware.
>=20
> [1] https://lkml.org/lkml/2020/5/15/252
> [2]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
oc
> umentation/admin-guide/hw_random.rst?h=3Dv5.6 [3]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
ri
> vers/char/hw_random/core.c?h=3Dv5.6#n251
>=20
> Kind regards,


Ciao
Stephan


