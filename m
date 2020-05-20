Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D4DC433E3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 10:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD152075F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 10:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lT0Mu8TQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETKox (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 06:44:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48308 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETKow (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 06:44:52 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200520104449euoutp015d4f975969ddb3980840e7e9323d320c~QtqVaNobS2434624346euoutp01H;
        Wed, 20 May 2020 10:44:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200520104449euoutp015d4f975969ddb3980840e7e9323d320c~QtqVaNobS2434624346euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589971489;
        bh=6CPRq4ULqK4ssuhc8hx4tHsC9pvXqnG/nhCQu807Mtk=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=lT0Mu8TQU3QCwLx2oV5ASGQJ3uKAscQvHrBQSsj0MR4yRsBXvPJbfWuX43I87MgBk
         m+sNlwdWS7YwHp+PLLu0XX4l7Te3dJvJAYDwAkgzIfrWT5a9H04jKLQFJkFL/OdiQC
         QkSn31bItydkK67cFhQmVASPbWJWhjaEqQQ3HTxY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200520104449eucas1p1f58225b60dd7909e0c145619450697ae~QtqVABDTY1237912379eucas1p19;
        Wed, 20 May 2020 10:44:49 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 95.24.60698.12A05CE5; Wed, 20
        May 2020 11:44:49 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964~QtqUjLTwx2400824008eucas1p19;
        Wed, 20 May 2020 10:44:48 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200520104448eusmtrp288e8ca9495b3f2c380cd4d434cf8a5f3~QtqUiYFfW3067630676eusmtrp2T;
        Wed, 20 May 2020 10:44:48 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-86-5ec50a2171d9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D7.F9.08375.02A05CE5; Wed, 20
        May 2020 11:44:48 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200520104448eusmtip17a58f4a9cc7f66dd304079cdd8c37cee~QtqUYUA4n2150821508eusmtip1I;
        Wed, 20 May 2020 10:44:48 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Stephan Mueller <smueller@chronox.de>
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
In-Reply-To: <15745285.MnsZKaK4VV@tauon.chronox.de> (Stephan Mueller's
        message of "Wed, 20 May 2020 11:18:32 +0200")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 20 May 2020 12:44:33 +0200
Message-ID: <dleftjh7wa3my6.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURDH87rb7dJYshTUERW1AY0aQcXoMx7RaHSJmEjCBzSxUnUDBFqg
        BTwTDyKHCGLxoqJUMJSU07VWMF7BAy9Y5DB4olijtIp4JYp4tF1M+PabN/Of+c/k0YSyggqk
        E3RpnF6nSVJRctJ+56cwa4r8tnr2icxR+LfxjgyfP1knxTX5t0ks5FoIPNh/S4Yzy+sonOec
        gA+/cRFYEOplmH/zWIp7Xv6U4I7LJRQ+KVyTYHORQ4rN9gKE3xZfoHB/lQPhYw9qSNx8N5dY
        5s/+GjQi1tTTQrFfOjslbKPphYwt569TrP1GCMtbcyn2+ulqGXvh3B62wGZFbEFfPWLrbF0k
        u/9+tpT9yget890gX7yVS0rI4PRhS2Pl8VVl7SjFFbT90vmUvej1uIPIhwZmHvSbh6iDSE4r
        mUoEfe1HSDH4huDcq4Hh4CuC7C4j+i9pK+GRmLAg4J2CRAzeIcgTPrklNE0xoVBTE+MRBDDT
        oSu71DuDYFqlMHSqnfAk/JnVcLa7gvSwD5MBQ88+eHk0sxBs73tkHiaZEHj7ZMDLCmYBPBUc
        EpH94F6xw1tPMFooFj54HQHjoMGa1Ut4TACzEu51Bomu/cHZbJOJPAH+NpZKxJI9UGScL0oP
        IbCX/CDFmkXwvHWQEmuWwztBLaIvdH/0E6f6gtF+YniQAnKylKIwGGoPXxluEgj5zsrhs7HQ
        97jFa0DJZCH4XplaiCabRuxiGrGLyd2VcB+u7nKY+DwTKs66CJGXQG3tJ9KMpFY0lks3aOM4
        Q7iO2xZq0GgN6bq40C3JWh65f+yDP83fG9C1oc1NiKGRapSiu/GmWinVZBh2aJtQsLtTb31V
        Gwokdck6ThWgKHzfpFYqtmp27OT0yZv06UmcoQmNp0nVWEV4Wd9GJROnSeMSOS6F0//PSmif
        wL0IzEfuN+RUJ7jYdsuuSWPW9qyLy4ox2Q6Ydn9OSosK57tuqZ2tUyIS5047Gp8zvtq1bL11
        TkzRltqo55acxNi2A8URl2Ijj/MKv/U/stOjLzZ2tKWuebhw36Or0asjQqpWqKc6LZoA5/a5
        YRPTolc1TB/IPbNrZWT5itgbeeN8yZbMBSrSEK+ZM4PQGzT/AH+j0Fi5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHe/cdNq3F25z1tkpkWFTWp99M9xoaQURfF0mHG8m0hn5o6DbZ
        t83qotIubNN0GUEuLcvU0nQ6RcsO5kxnJ2ZmkoVZHig1LIwusuPmCLr78fz/z5//A4+EkF2m
        FJLDOiNv0GmylHQg+eS3e3hjaGB3SmTXUCT+VdIjxk0XHBSuP9NNYo+lhsBzMw/F+FSlg8YF
        Uytx8dg0gT2eRjF2jg1SeOTtdxF+0V5G4wue+yJccW6cwhWtRQBPlDbTeKZuHODzT+pJ7O61
        EFuDuB9zJYCzjzyjudmBARF32z4s5iqdHTTX+mA156y10FxH+U0x13ztBFfUUgu4oslGwDla
        XpJc3uN8ivvqDNm9eD8TZ9CbjHxohl4wxiuTWKxi2FjMqDbFMmyUOnmzKloZsSUujc86bOYN
        EVsOMRl1V/tB9nTIkbam7JPg/XIrCJAguAn1lTmBFQRKZLAKoJs/u2krkHgFBbpRnu73BKGf
        g1baxzI4AZDbbfJZaMig+vpE31gO16GX+ZdpXwwB2yn0pmCQ8glBcAe68qqa9HEANCPL0zGR
        P0eF8q7bgI+DYSxq+Tgi9jEJV6OJoS/zLIVq9NozLvLzEvSodHw+h4CZ6FvdB8IGoP0/yf6f
        ZPfWI7ydHO0R/nE4qr4yTfg5HjU0fCYrAFUL5LxJ0KZrBZYRNFrBpEtnUvVaJ/A+RGvP9+Zb
        oL9pnwtACVAukkbe7UqRURqzcFTrAmHemNHGuj6gIHV6Ha+US20fXSkyaZrm6DHeoD9oMGXx
        ggtEe+85SyiCU/XeV9MZD7LRrBrHsuoodVQMVi6TnoadB2QwXWPkM3k+mzf82xNJAhQnwaqm
        uP6uXSZX2ackOVMaP6UgckpSy8y1l17ERe99vnTBtsUxk1mf9zRutazLkZOuDQNtaxZ+yVix
        PeF4SEt7+EUn3HeiN4bdeel64WxebrG5YdrdE1M42xtlW6vMdSQasneJCn91zP3prAm7d27F
        +VzHHRVIqAoZLep7Z3QkF5aHKkkhQ8OuJwyC5i8OYmq8MgMAAA==
X-CMS-MailID: 20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964
X-Msg-Generator: CA
X-RootMTR: 20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964
References: <15745285.MnsZKaK4VV@tauon.chronox.de>
        <CGME20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-20 =C5=9Bro 11:18>, when Stephan Mueller wrote:
> Am Mittwoch, 20. Mai 2020, 11:10:32 CEST schrieb Lukasz Stelmach:
>> It was <2020-05-20 =C5=9Bro 08:23>, when Stephan Mueller wrote:
>>> Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:
>>>> The value was estimaded with ea_iid[1] using on 10485760 bytes read
>>>> from the RNG via /dev/hwrng. The min-entropy value calculated using
>>>> the most common value estimate (NIST SP 800-90P[2], section 6.3.1)
>>>> was 7.964464.
>>>=20
>>> I am sorry, but I think I did not make myself clear: testing random
>>> numbers post-processing with the statistical tools does NOT give any
>>> idea about the entropy rate. Thus, all that was calculated is the
>>> proper implementation of the post-processing operation and not the
>>> actual noise source.
>>>=20
>>> What needs to happen is that we need access to raw, unconditioned
>>> data from the noise source that is analyzed with the statistical
>>> methods.
>>=20
>> I did understand you and I assure you the data I tested were obtained
>> directly from RNGs. As I pointed before[1], that is how /dev/hwrng
>> works[2].
>
> I understand that /dev/hwrng pulls the data straight from the
> hardware. But the data from the hardware usually is not obtained
> straight from the noise source.
>
> Typically you have a noise source (e.g. a ring oscillator) whose data
> is digitized then fed into a compression function like an LFSR or a
> hash. Then a cryptographic operation like a CBC-MAC, hash or even a
> DRBG is applied to that data when the caller wants to have random
> numbers.

I do understand your point (but not entirely, see below). [opinion]
However, I am really not sure that this is a "typical" setting for a HW
RNG, at least not among RNGs supported by Linux. Otherwise there would
be no hw_random framework and no rngd(8) which are suppsed to
post-process imperfectly random data from HW. [/opinion]

> In order to estimate entropy, we need the raw unconditioned data from
> the, say, ring oscillator and not from the (cryptographic) output
> operation.

Can you tell, why it matters in this case? If I understand correctly,
the quality field describes not the randomness created by the noise
generator but the one delivered by the driver to other software
components.

> That said, the illustrated example is typical for hardware RNGs. Yet
> it is never guaranteed to work that way. Thus, if you can point to
> architecture documentation of your specific hardware RNGs showing that
> the data read from the hardware is pure unconditioned noise data, then
> I have no objections to the patch.

I can tell for sure that this is the case for exynos-trng[1]. There is a
post-processor which I have forgotten about since writing the driver,
because from the very beginning I didn't intend to use it. I knew there
is the software framework for post-processing and simply didn't bother.

With regards to iproc-rng200 I cannot be sure.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/char/hw_random/exynos-trng.c?h=3Dv5.6#n100

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7FChEACgkQsK4enJil
gBCsvQgAhq2NdaCOe4RS5Cfyu6s7rYJIijngIdzcEg3V+VmN2vniWJYNobIUL8S6
et4cCzQKSbxw/FgDCmZKpffRz7Md+98M4hpkWCfuhqhXj8kXV8e5Oa7QAyMo6H+s
kpATmCe9Jkbx8K4ufD5bDnON6kv8dP1iJMOdkoiIN7F/HvTbuIgW33XoP+n8IU7o
QRuNwK+C8IhgOppNU6fPYLUcBVtIvW4wplMc5mEZQNNIsRSPH7pNgK8X6BihA3eR
j2BsGU3dv7tfVvVTV7EZ/k1lmFWwd3lusLirmrHly9Hodsfj4AWmLRorgnCBCM7D
gGwIZrzGXyx9M54bg+LoADhurlMakQ==
=CU9M
-----END PGP SIGNATURE-----
--=-=-=--
