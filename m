Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22611C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020BF207ED
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="h9Ygwzog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgETJKr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 05:10:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49132 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETJKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 05:10:46 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200520091044euoutp026770d90a495d56eae89d8f08b9ce172c~QsYLhZv8n3274832748euoutp02l;
        Wed, 20 May 2020 09:10:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200520091044euoutp026770d90a495d56eae89d8f08b9ce172c~QsYLhZv8n3274832748euoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589965844;
        bh=Ik7IIZgBVxkfBPHIlJ3FcRHTlQPWyYIvhW9LFSW2QiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9YgwzogO14ift6H3+DtTgO5V8CO8+OX8SUlRjjCXfM1m2p1PTSjccjH8rdEQn9ld
         Yea9ogRG+9ugtkCxPFyxIFWBXRY3sv5+z0Jwf1RigXL0WI6ytNRVrBye5lI6Q3Yowp
         BJSmi/ViPMn+MIYMjjCCTp+UCpFzs2+UD0ye/p4Q=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200520091043eucas1p2feac347997dc632e3b3b5346272c37d8~QsYLO7TWK1590115901eucas1p2_;
        Wed, 20 May 2020 09:10:43 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 16.61.61286.314F4CE5; Wed, 20
        May 2020 10:10:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200520091043eucas1p15ecae108007382a95b01e42241cc7a26~QsYK5aUP42199621996eucas1p18;
        Wed, 20 May 2020 09:10:43 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200520091043eusmtrp2a5bec9df1163088b2990b5c13058c987~QsYK4a7mJ0336803368eusmtrp2f;
        Wed, 20 May 2020 09:10:43 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-f1-5ec4f4134ab7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 73.0B.08375.314F4CE5; Wed, 20
        May 2020 10:10:43 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200520091043eusmtip22c1a46ce2665b5a87a3ba9c950895c30~QsYKpzAhc3121631216eusmtip2b;
        Wed, 20 May 2020 09:10:43 +0000 (GMT)
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
Date:   Wed, 20 May 2020 11:10:32 +0200
In-Reply-To: <1748331.j7eDFAdTc1@tauon.chronox.de> (Stephan Mueller's
        message of "Wed, 20 May 2020 08:23:59 +0200")
Message-ID: <dleftjr1vf2cqf.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUyTVxTHc/u80tn6UDCedMQsHSZTY8FI9BoVp1ni/bYtyxbjIlrlGRBp
        Ma34ljlwKgyVQoBlUmvAKS8BC1hqo8xR0qEgKN14UYwKibAMqsOkxSBF5vp4NfHb75zz/9/z
        kisyunpeL2ZZ9stWiynbwKtZ763ZwMq46c60ZHu5Ec+X3RLwlbPNHHYV32RxoKiOwZGpTgEf
        v9jM49PBBFwy9pTBgUCLgN1j9zg8OjKrwgNtTh6fDbSrcHX5OIervXaE/65s5fFU4zjCP/e6
        WNzVXcR8GkfmImWIOEbv8iQ0OKgi1x2PBXLR7eOJt2MpcTcU8cR3/rJAWi/lEbunARH7ZAsi
        zZ4hlvzYU8iRsHvJF9rt6g3pcnbWAdmalLpLnXkmMK3aVxV7aK5mmMtHYe0pFCOClAKBohlW
        YZ1Uj6Bv6rtTSB3laQSD7S6BBmEEMzVB9M7xV9cQRwt1CGpCQwwN/kHQe98RtYgiLxnB5dqm
        GOKlZTBUWMUrGkbq4+DVuX5GKcRJW+HCcO2b3qy0FCYqg5zCMVIu3An5VQprpLXw4IRdUHiR
        tA48E6MCzcfC7crxN15GMkNl4BlSGoA0LkLI71PRUT+D/FC3QDkOgl2et5wAr69XqZRBQcqD
        8rI11HsGgdf5kqWa9fCoL8JT3gydvxdwVK+F4X9jaV8tlHl/YWhaAz8V6Kg6EZpKbrx9RQ/F
        wXpEJQSuDmygpzqJoKDwPF+KPnK8t43jvW0cUQsTPV1zWxJNr4DaC08Zyhuhqek5W424BrRY
        zrWZM2TbKot80GgzmW25lgzjnhyzG0X/bO9/XaFr6EX/bj+SRGRYoEm+8UeajjMdsB02+1Fi
        9KUnLY1/Ij1rybHIhnhN6YQ/TadJNx0+Iltzdlpzs2WbH30osobFmtW/Tu7QSRmm/fJeWd4n
        W99VVWKMPh/lk7we52+GLSdTTeGvxkYqlnT4lr2+9M3Es5KvN36bEGksTb29cGV44dr5T75P
        /1ytfVjb0/rx8W7NwA+Zk70teSPzvhnnDue25ec0KUkdW09UBGfbEifj67wJLzJejgaPbjIk
        z2Xp8SZt5I4Xf+kzbi++eqz96Afdj+ZJ/2ZPyfqKFANryzStWs5Ybab/AQm9CxG7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHefZetkmzd1PzYUjUqA8ZTl8v7THUogu9H0pSCSTLWvmi4S62
        dxPtg9kN2ywrQ9CRpZRms3nZTMoia86sLNZFZRU6SkcrQyktMC3aHIHffpz/7xzOgSPAJI2E
        VHBEo2d1GqVKRobgg38HxmLCZp25cZd+haM/1U/4qLO2nUDW8/04chlvYuj3lJOPTl1vJ1Hl
        1yh0YXwSQy5XBx/ZxkcI5Bmb46G3PVdIVOt6yEMNlycI1NBdBZC3zk6iqdYJgGoGrTgaeGrE
        Nocx87+rAWP2vCSZH0NDPOaeeZTPXLf1kkz3o7WMzWIkmd7623zGfuM4U9VlAUzVlw7AtHcN
        48zJ5xUEM2NbuTt0rzxFpzXo2VUFWk6fKsuhUbycTkby+MRkOZ2g2L8xPkkWm5aSx6qOFLO6
        2LSD8oJzrlle0TVxyXyTmygHM6EmIBRAKhG+HhgmTCBEIKGaAPzhPoGZgMAfSOGt+vygEwYX
        Rkxk0PEC6Og/AwIOScmh1ZodcMKpdXC44tqig1E9BPxQOUIEgjBqB2x0N+MBllA0vGP5DgKM
        U2uhr+7roiOkDNDZbMUCLKIU8N3pKn6AI6hk2OXz8IN1MXxWN7E4B6MK4c/Wz9hFQJmXROYl
        kdm/Hubfqb0nNlheD5sbJ7Egp8K2tmm8ARAWEM4aOHW+mqPlnFLNGTT58sNatQ34X6L7yZz9
        LnjTmeUAlADIloniHvTlSghlMVeqdoA1/jGfOlpfASmu0WpYWbjoos+RKxHlKUuPsTrtAZ1B
        xXIOkOS/8xImjTis9T+bRn+ATqIVKJlWJCgSNiBZpOgs9XifhMpX6tlCli1idf/7eAKhtBzs
        qVFt7zn6gKn9eLzx8/JSVVlnrqdl0juZGjudvqlV3DYVM/Jo9ND2QdM3X+Wz8r66im3OuKlv
        C6PO5TDeLVYVRD5MvyHdNe0tO7Tzft+QN8Oe0TS4Int174zwReTVjK0/FZnZ9qiNJRfsxTVb
        kp4aDRs8We9bJJkmY050qTsmcVaGcwVKOhrTccp/YUqeCDQDAAA=
X-CMS-MailID: 20200520091043eucas1p15ecae108007382a95b01e42241cc7a26
X-Msg-Generator: CA
X-RootMTR: 20200520091043eucas1p15ecae108007382a95b01e42241cc7a26
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200520091043eucas1p15ecae108007382a95b01e42241cc7a26
References: <1748331.j7eDFAdTc1@tauon.chronox.de>
        <CGME20200520091043eucas1p15ecae108007382a95b01e42241cc7a26@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-20 =C5=9Bro 08:23>, when Stephan Mueller wrote:
> Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:
>
>> The value was estimaded with ea_iid[1] using on 10485760 bytes read from
>> the RNG via /dev/hwrng. The min-entropy value calculated using the most
>> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.
>
> I am sorry, but I think I did not make myself clear: testing random numbe=
rs=20
> post-processing with the statistical tools does NOT give any idea about t=
he=20
> entropy rate. Thus, all that was calculated is the proper implementation =
of=20
> the post-processing operation and not the actual noise source.
>
> What needs to happen is that we need access to raw, unconditioned data fr=
om=20
> the noise source that is analyzed with the statistical methods.

I did understand you and I assure you the data I tested were obtained
directly from RNGs. As I pointed before[1], that is how /dev/hwrng
works[2].

If I am wrong, do show me the code that processes the data from a HW RNG
before copying them to user provided buffer[3].

[1] https://lkml.org/lkml/2020/5/15/252
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/admin-guide/hw_random.rst?h=3Dv5.6
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/char/hw_random/core.c?h=3Dv5.6#n251

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7E9AgACgkQsK4enJil
gBDKOggAoVfZTiIxpvV2zbs8NraxS44nLMlX476LHniFWu6Rurw1WrepnIi5HGp3
J5YcE/eOtH8dciy9fHz2NFgXG6711U8pgqDV0A31xSPlJj9effjLVEbROl4oDc4Y
O6Rl6WMjUKnetl/nWNMhi39JuxYZnRPLnnmawxPUPjR7DiO2TxO9yPqBY2verjFp
AQQWy3/fw1H3mS4sg7eRbN5zZHtmCFQoKvFn5C1xoiMchWu66kERk3vUJtpGw0UV
d51Ro2X1gBbvV8ZfZkG1jmgI2Q4mL314gfQ0xIogF7HQECELHZ7qKU35tT6LjA3C
jrAmmuMFHtUEgK9hjq6X4hCon2i8OA==
=hppL
-----END PGP SIGNATURE-----
--=-=-=--
