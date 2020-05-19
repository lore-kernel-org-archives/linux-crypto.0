Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3FEC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6640520758
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nmzCc3If"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgESV0V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 17:26:21 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45527 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgESV0U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 17:26:20 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200519212618euoutp028c00e7a8d7ff908ed621dbadcc02a4c5~QixI_e6w02168721687euoutp02F
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 21:26:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200519212618euoutp028c00e7a8d7ff908ed621dbadcc02a4c5~QixI_e6w02168721687euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589923578;
        bh=1c7VGWvexy2eW95UqCglB2SCwEWKkXv1iIEzc8i/+A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmzCc3IfOZR0RTjmEzmN4cxTlxmPF7oeznOzU+wU3q4pJMvjSpo4eCtfv5821X4N6
         Dw1s9j8I3C39ta1Nn7Fh2SLv7Pev7hVMnlaAaTzSkB2yejp+LA9g9pWIxpHDAl8UHM
         7ePx9efat7Rtb4dEDxKCtrcwZEKzYpp1FEcEyIIw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200519212617eucas1p184ae7a3c1ceef4f3069943c69c8bbed0~QixIAgXno2659226592eucas1p1b;
        Tue, 19 May 2020 21:26:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A9.EB.60679.9FE44CE5; Tue, 19
        May 2020 22:26:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200519212617eucas1p1b6e7af0ecb894896b165601fafd6abe8~QixHPs0gA2557025570eucas1p1W;
        Tue, 19 May 2020 21:26:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200519212617eusmtrp292b562aade6f48110764323077d6f380~QixHO68Go1117911179eusmtrp2b;
        Tue, 19 May 2020 21:26:17 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-2d-5ec44ef94874
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 83.A7.08375.8FE44CE5; Tue, 19
        May 2020 22:26:16 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200519212616eusmtip13926f680a1fb9914bec1e3649925e7ca~QixHBwEZQ2033920339eusmtip1y;
        Tue, 19 May 2020 21:26:16 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Matt Mackall <mpm@selenic.com>,
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
        Stephan Mueller <smueller@chronox.de>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 0/2] Set the quality value for two HW RNGs
Date:   Tue, 19 May 2020 23:25:50 +0200
Message-Id: <20200519212552.11671-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514190734.32746-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+3bOzjla0+OSejFLGmkYZXazD+xexOkfsaKgQGu107p4Y0vt
        AhmTNJdupUQ1lbZUZsvrZitFU5ZpWamRZdFlXRaWZVgatnWfx6j/fu/7Pc/zfQ98DCHNooKY
        PUn7eVWSPEFG+ZL2NnfnHHdMa3ykpi8S/8hvo3Ht2Woxrsy7QeKuHDOBPR9baZxZUk3hE/3B
        WP/6PYG7umpo/NhRjrD19UMxdj53i/D9hiIKn+26JsLGApcYG+06hN+cs1H44yUXwqdvV5K4
        /WYOsSKQ++bJR5zBeZfiPvf0iLh6wzOaK7E2U5y9JZSzWnIorrm4guZspRmcrs6CON27GsRV
        1z0gOU1Htpgbsk6L9dvqu0TBJ+xJ41Vzl2333X3PXECnZIkPWM1PyKMom9QihgF2Idw5ptQi
        X0bKliNwtZURwjCMwK1z0Frk82cYQpCZu+mvwfaJEzRmBIXuEloY+hCY7CaR10CxK0FfdlPs
        5UC2SgwjZbyXCTYdjr10je4nskvB9sqEvEyyodA06BhlCRsNec/clJeBDYFs85VR9mGXQO9b
        j0jQBMCtcy7Sy/7sLKjQ9JJCfghkXi4cbQBsNwPGERMhBK2BHJ1mLHQi9LfX0QIHw6/68yKh
        WQYU5EcJ3lwE9qKvpKCJhqedHsqrIdhwqG6YK6xXQqlFP2b1g0cDAcIT/CDffoYQ1hI4niUV
        1DOgSt84FhgEef3l6CSSGf4rY/ivgOHfXUZEWNBkPlWdqOTV85P49Ai1PFGdmqSM2JmcaEV/
        fuftn+3DV1HD9x0OxDJINkES2Xg9XiqWp6kPJjoQMIQsUHLyrSNeKlHIDx7iVcnbVKkJvNqB
        pjCkbLJkwYV3cVJWKd/P7+P5FF7191TE+AQdRYe3KAJP3SEWaQecMfhi2pueCVPHj3v+wrn4
        iEJlLptWGZWwPiRuqLn2Rea+l0u7i8M29yyOcPetuYGDp5fSXKs+/QPBOK2Wtf57lU19w++b
        TS21G2aGbWlctGtgVUd2bCxet7oxxEPvaunP7axq3zpbYbRtXP5Fq+mYVBzeGlU+KCPVu+Xz
        ZhEqtfw3JclJQJkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t/xu7o//I7EGeycbmPxd9IxdouNM9az
        WqztPcpicb5zObPFr3dH2C2aF69ns+h+JWPR//g1s8X58xvYLW4eWsFosenxNVaL+/d+Mllc
        3jWHzWLG+X1MFgsmP2G1WLCtj9Hi6czNbBbvVj9htJh6ei2LxfETncwOIh6/f01i9Jh1/yyb
        x6crV5g8ds66y+6xeNN+No9tB1Q9Nq3qZPPYP3cNu8fmJfUefVtWMXr0vdzA6LF+y1UWj6ZT
        7awenzfJBfBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW
        6dsl6GVcXD6ZvaCNtWLT8tssDYztLF2MHBwSAiYSmz96dDFycQgJLGWU2L/xGyNEXEpi5dz0
        LkZOIFNY4s+1LjYQW0jgKaPE6++yIDabgKNE/9ITrCC9IgJ7WCV23+hkAkkwC5RLtD58wgpi
        CwvYSmx+tJARxGYRUJXY++EQmM0rYC3Re/cnG8QCeYn25dvBbE4BG4nrL34xQSyzlrjzZS4r
        RL2gxMmZT8BuZhZQl1g/TwgkzC+gJbGm6ToLxFp5ieats5knMArNQtIxC6FjFpKqBYzMqxhF
        UkuLc9Nziw31ihNzi0vz0vWS83M3MQJTxbZjPzfvYLy0MfgQowAHoxIPr8Gew3FCrIllxZW5
        hxglOJiVRHgnvDgUJ8SbklhZlVqUH19UmpNafIjRFOjNicxSosn5wDSWVxJvaGpobmFpaG5s
        bmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qBsSH2fXJgdk2TwvTAi483rZwp9crpHGOg
        OEOfofxJyZn6vum/NeY37wtb/7LjDhPTcfVvSnY+6zUM/a5fTfuxkW1CqutGnV4rvyU+qx4v
        fn87XeK2gW6U7ikHwc5Jio0rzlzQvd8pO/ninl1WyydJn7qtx79k0qvsd99+Tq0weMMfvTvH
        93hkhBJLcUaioRZzUXEiACOC+cArAwAA
X-CMS-MailID: 20200519212617eucas1p1b6e7af0ecb894896b165601fafd6abe8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200519212617eucas1p1b6e7af0ecb894896b165601fafd6abe8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200519212617eucas1p1b6e7af0ecb894896b165601fafd6abe8
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <CGME20200519212617eucas1p1b6e7af0ecb894896b165601fafd6abe8@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rng structure contains the quality field which tells how many bits
of entropy can be obtained from 1024 bits read from a device. With the
quality value set the hw_random framework starts a kernel thread to feed
the entropy pool in the CRNG, which helps to initialize it quickly
especially during boot.

Łukasz Stelmach (2):
  hwrng: iproc-rng200 - Set the quality value
  hwrng: exynos - Set the quality value

 drivers/char/hw_random/exynos-trng.c  | 1 +
 drivers/char/hw_random/iproc-rng200.c | 1 +
 2 files changed, 2 insertions(+)

v2:
  - recalculated values using the SP800-90B_EntropyAssessment package
-- 
2.25.0

