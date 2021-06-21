Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24646C48BE5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 03:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F232C61206
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 03:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFUDuS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Jun 2021 23:50:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44527 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFUDuR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Jun 2021 23:50:17 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210621034802epoutp01a9625b0cb3cd518f2917bac8771df2fd~KfEwwZBNM1746517465epoutp01Y
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jun 2021 03:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210621034802epoutp01a9625b0cb3cd518f2917bac8771df2fd~KfEwwZBNM1746517465epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624247282;
        bh=4o0BF1p//yguPV8uZCfsZ88Z+jjCIGGL4FlNAhcy5Jg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=SSzeHCcLxu4iqT7m+4Qcpte8F2fvtWneNWAteX4CCk+l05gGqCxX/6VzqQm8PnBFA
         fJsoM8yOg+AZG5AsXSePYKG/tySiaptpQwOVAkppdEA5eYgcKACAV3thOjVinizLrg
         ijEHylbCHpXkRGJWYvbQBfsa1ursBcgQFA8pIq5M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210621034801epcas3p36a5f228cb6b3a73bc4296b90fc6d3dd8~KfEwLFK1h0112101121epcas3p3j;
        Mon, 21 Jun 2021 03:48:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4G7b8d4TMfz4x9Q3; Mon, 21 Jun 2021 03:48:01 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210621025522epcas2p24c20721675d0705ce694a7dc69006264~KeWx4tFzs1749517495epcas2p2b;
        Mon, 21 Jun 2021 02:55:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210621025522epsmtrp2857703936059551ab47ef74bf7bf8991~KeWx2rmu62801528015epsmtrp2a;
        Mon, 21 Jun 2021 02:55:22 +0000 (GMT)
X-AuditID: b6c32a2a-c01ff70000002061-8e-60cfff9a722e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.34.08289.A9FFFC06; Mon, 21 Jun 2021 11:55:22 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210621025522epsmtip2b1550c3abc802ff415f31c6f4b6db240~KeWxipG3f0873908739epsmtip2m;
        Mon, 21 Jun 2021 02:55:22 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Dominique MARTINET'" <dominique.martinet@atmark-techno.com>,
        "'Jianxiong Gao'" <jxgao@google.com>
Cc:     "'Christoph Hellwig'" <hch@lst.de>,
        "'Konrad Rzeszutek Wilk'" <konrad@darnok.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        =?utf-8?Q?'Horia_Geant=C4=83'?= <horia.geanta@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        "'Lukas Hartmann'" <lukas@mntmn.com>,
        "'Aymen Sghaier'" <aymen.sghaier@nxp.com>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        "'Marc Orr'" <marcorr@google.com>,
        "'Erdem Aktas'" <erdemaktas@google.com>,
        "'Peter Gonda'" <pgonda@google.com>,
        "'Bumyong Lee'" <bumyong.lee@samsung.com>
In-Reply-To: <YM/zWyZlk1bzHWgI@atmark-techno.com>
Subject: RE: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Date:   Mon, 21 Jun 2021 11:55:22 +0900
Message-ID: <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFDXrbxzNqCjAFYIyZp8SJPpEE7BALklUvQAU7mhF0BiRUMkQElteCnAXJthq8BvQCqOAH1sv7OAe2NoSYCTMPpJQDVyVEXAhuWClmrrDnekA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWy7bCSvO6s/+cTDM695bZoPbyUyWLvaQuL
        l4c0Leacb2GxWH3AyWL9hf/sFitXH2Wy6H4lY/Hh/GEmiwX7rS2mtfWxWCxb/JTR4s3zy6wW
        9+/9ZLK4vGsOm8WV1VPZLY5c6me3mL7gHrPFo7637A7CHp3Ni5k8Oq5cZffYsvImk8e2A6oe
        CzaVepyY8ZvFY/KN5Yweu282sHksPXqE1WPjux1MHh+f3mLx6NuyitHj8ya5AN4oLpuU1JzM
        stQifbsEroyt0+azFqzkrljzfi1rA2MDZxcjJ4eEgInE9h3HmboYuTiEBHYwStz5dZgNIiEr
        8ezdDnYIW1jifssRVoiiZ4wSEzseMYMk2AT0JV52bGMFsUUEMiXeLexiBCliFtjLKnGs7Rg7
        RMcyFolXPfPBRnEKGEpMvnMHbIWwQITEh62tYN0sAqoSr+7/B4pzcPAKWErMnSILEuYVEJQ4
        OfMJC4jNLKAt8fTmUzh72cLXzBDXKUj8fLoM6og6iWsXn7JD1IhIzO5sY57AKDwLyahZSEbN
        QjJqFpKWBYwsqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxglOBltYOxj2rPugdYmTi
        YDzEKMHBrCTCy5l5JkGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUw
        WSYOTqkGJt15cxj4uKQ2HjB87Dn3SCenXJtI2UtZJ4P2a0YWAa81WY4aTjT9svh16oOw1/lm
        imsmaX7fkjcz7qdypN3BFVOP7BP64HZrJttVkXCr7tyPW2ZPNvBVy5vLKeJ59Hnd9LCTN5t/
        3z4rvzp4TZPpy9/CK7qDJgrOuOL5f1ua04egSVucBNxmq3xZddq9LCKocvFcL+VE1Z4FneV/
        vtcZcGccVPW6zvcs8KNIivam2nU6jj7r7vBHTTCItJVlW13fveibplT6rDWtVzbknHx1K/65
        7ppGkX8S4asXJav2aX97b+a7a80WqxKWSAW2r3w7bJg6z0pYdjXtbGVvcpJO3/3w4gzzzMDd
        RatPmJU3K7EUZyQaajEXFScCAGgu9I90AwAA
X-CMS-MailID: 20210621025522epcas2p24c20721675d0705ce694a7dc69006264
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210621020328epcas2p207e9fa2df119730ceb993543621437d8
References: <YL7XXNOnbaDgmTB9@atmark-techno.com>
        <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
        <20210611062153.GA30906@lst.de> <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
        <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
        <YMqW+/gQvM+uWUTw@fedora> <YMqZswFnSNKk4Z7B@atmark-techno.com>
        <20210617051232.GB27192@lst.de> <YMrfWBLsJxCRhX5U@atmark-techno.com>
        <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
        <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
        <YM/zWyZlk1bzHWgI@atmark-techno.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

+ Bumyong who is the original author of the patch.=20

Hi Dominique,

> Thanks!
> (a bit late, but added Chanho Park in Cc...)
>=20
> I can confirm it also works for our caam problem, as Horia said.
>=20
> I've also come to term with the use of swiotlb_align_offset() through
> testing, or rather many devices seem to have a 0 mask so it will almost
> always be cancelled out, so if it works for Jianxiong then it's probably
> good enough and I'll just assume that's how the orig_addr has been
> designed...
>=20
> I think it's missing a couple of checks like the one Linus had in his
> patch, and would be comfortable with something like the attached patch (i=
n
> practice for me exactly the same as the original patch, except I've added
> two checks: offsets smaller than orig addr offset are refused as well as
> offsets bigger than the mapping size)
>=20
> I'm sorry Jianxiong but would you be willing to take the time to test
> again just to make sure there were no such offsets in your case?
>=20
>=20
> If we're good with that I'll send it as an official v2 keeping Chanho's
> from, unless he wants to.
>=20

Sure. No problem. But, the patch was already stacked on Konrad's tree
and linux-next as well.

https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/commit/?=
h=3Ddevel/for-linus-5.14&id=3D33d1641f38f0c327bc3e5c21de585c77a6512bc6=20

Best Regards,=20
Chanho Park


