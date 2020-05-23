Return-Path: <SRS0=aEsr=7F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31264C433E3
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C8420787
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 18:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="kQ2Yw2kF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgEWSqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 May 2020 14:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWSqx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 May 2020 14:46:53 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0F6C061A0E;
        Sat, 23 May 2020 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590259611;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=EG0M3Hyxz4BV7j1+OKdBXWmu8BWCl4V9Gc3tOojvV2Y=;
        b=kQ2Yw2kFPnXLOMaH6oTfMTnm9bEjkJwWchdpFEpCQ2XYC9cYpJr88PrZfKCqInSKiu
        uoo7rDY7P1168eh/MyV+O3lcbDQbKb4GTKLPBPmMVvd5HOJKMphkm3GNQj8zC/yqw5Kh
        5rEwSbfRWtR6IO2vwmYRIDIodsEYJ4lx80r8xiLXH528mawDTcDsq5k4xgn7yupaGojp
        0VAloQ7VWS8iwpUYCk07gpnnxCW/zd+/KVZ0DYcsEngMz8js8ZYkmdUZ25lJGThjCeRv
        CM6v23Nv9esdtb1Is/i5lAXqgdnDxiBLtMLLrzexhQ6z6H/IGQ8rLvzB1uDGIbweXmXu
        0LHg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJ/SdwHc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4NIkQI1J
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 23 May 2020 20:46:26 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Lukasz Stelmach <l.stelmach@samsung.com>
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
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Sat, 23 May 2020 20:46:26 +0200
Message-ID: <3080190.aeNJFYEL58@positron.chronox.de>
In-Reply-To: <dleftjftbtyubp.fsf%l.stelmach@samsung.com>
References: <573b2eff-3c74-90e9-50fa-644264d0a0e5@i2se.com> <CGME20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3@eucas1p2.samsung.com> <dleftjftbtyubp.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 21. Mai 2020, 21:14:02 CEST schrieb Lukasz Stelmach:

Hi Lukasz,

> It was <2020-05-21 czw 13:00>, when Stefan Wahren wrote:
> > Hi Lukasz,
> >=20
> > Am 19.05.20 um 23:25 schrieb =C5=81ukasz Stelmach:
> >> The value was estimaded with ea_iid[1] using on 10485760 bytes read fr=
om
> >> the RNG via /dev/hwrng. The min-entropy value calculated using the most
> >> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.
> >=20
> > could you please mention in the commit the used hardware
> > implementation(s) of iproc-rng200 to get this quality?
> >=20
> > AFAIK there is still no public register description at least for the
> > bcm2711. So is it safe to assume that the suggested quality applies to
> > all possible configurations?
>=20
> I've learnt that there is a post-processing unit in RNG200 that tests
> the output of the noise generator and fills FIFO only with data that
> passes FIPS tests. Unlike simmilar unit in Exynos, it cannot be disabled
> or bypassed. Therefore, after Stephan Mueller's thorough explanations I
> am considering dropping this patch in v3.

If you would be more clear what that FIPS test is all about, we may be able=
 to=20
identify whether it affects the entropy behavior or not. E.g. if it is the=
=20
SP800-90B health test following SP880-90B section 4.4, this does not affect=
=20
entropy and you could apply your calculation.
>=20
> However, I stil am still not 100% convinced that it is impossible to
> assign the quality a reasonable non-zero value in such case.
>=20
> > Thanks
> > Stefan
> >=20
> >> [1]
> >> https://protect2.fireeye.com/url?k=3Dda4735b2-87d99b28-da46befd-0cc47a=
336f
> >> ae-e1c21080bc6ab1e4&q=3D1&u=3Dhttps%3A%2F%2Fgithub.com%2Fusnistgov%2FS=
P800-90
> >> B_EntropyAssessment [2]
> >> https://csrc.nist.gov/publications/detail/sp/800-90b/final
> >>=20
> >> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> >> ---
> >>=20
> >>  drivers/char/hw_random/iproc-rng200.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>=20
> >> diff --git a/drivers/char/hw_random/iproc-rng200.c
> >> b/drivers/char/hw_random/iproc-rng200.c index 32d9fe61a225..95669ece05=
0f
> >> 100644
> >> --- a/drivers/char/hw_random/iproc-rng200.c
> >> +++ b/drivers/char/hw_random/iproc-rng200.c
> >> @@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_devi=
ce
> >> *pdev)>>=20
> >>  	priv->rng.read =3D iproc_rng200_read,
> >>  	priv->rng.init =3D iproc_rng200_init,
> >>  	priv->rng.cleanup =3D iproc_rng200_cleanup,
> >>=20
> >> +	priv->rng.quality =3D 1000,
> >>=20
> >>  	/* Register driver */
> >>  	ret =3D devm_hwrng_register(dev, &priv->rng);


Ciao
Stephan


