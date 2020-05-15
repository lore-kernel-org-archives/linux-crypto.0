Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D17EC433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7E7205CB
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ABtk6hl+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEOJGu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:06:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37555 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEOJGt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:06:49 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200515090648euoutp02ca23d34b2e28f8de83766f769dbe24fe~PKGURWJye0696006960euoutp02R;
        Fri, 15 May 2020 09:06:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200515090648euoutp02ca23d34b2e28f8de83766f769dbe24fe~PKGURWJye0696006960euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589533608;
        bh=Rgf0DcSHGDxAPO+e54+qqjmUM1+sR1ls1YqjuvhAlng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABtk6hl+oLDnWJ965GufGG8Mo7IDRjRyRS2jQNP3QwKJbZL0VI7ADppDL6usWRadw
         6rzSLhSZ9UiIjPd3pQSVKFUqrg24s4HC0+MWVtQX6Fu5dnHBcPuEvC6MpJa479hgY5
         rgLyH1XeDemqZJMq72Vy90nutrPpsddti1LFDvEU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200515090647eucas1p127b1f85b98f1044df800d7f5878973e6~PKGUAd8Wu1172411724eucas1p1F;
        Fri, 15 May 2020 09:06:47 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 03.64.60679.7AB5EBE5; Fri, 15
        May 2020 10:06:47 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200515090647eucas1p21018edfd835730c9a68dcb186349ee74~PKGTqgs6w1476614766eucas1p2W;
        Fri, 15 May 2020 09:06:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200515090647eusmtrp12fd4a9a4f13f1c13c2a06a2843cdfbf6~PKGTpjEep0296002960eusmtrp1q;
        Fri, 15 May 2020 09:06:47 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-24-5ebe5ba7e364
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 52.FD.07950.7AB5EBE5; Fri, 15
        May 2020 10:06:47 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200515090647eusmtip2e03fda35d17045664eaf97456b7f3c36~PKGTdAkmO3032830328eusmtip2o;
        Fri, 15 May 2020 09:06:47 +0000 (GMT)
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
Subject: Re: [PATCH 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Fri, 15 May 2020 11:06:46 +0200
In-Reply-To: <2080864.23lDWg4Bvs@tauon.chronox.de> (Stephan Mueller's
        message of "Fri, 15 May 2020 10:32:22 +0200")
Message-ID: <dleftjblmp8t3t.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01SWUwTURT1daYz08biUDRekahp8EONFXF7rtG4vWhcvowRRauMSKDFtIJL
        ohCMIggFS1BbMVRRKCi0FKyIIgYX1AaLuMREFBQaFRTEJZGKxJbBxL9zz73n3CWXo5SlTCgX
        p9sn6HWaBBUjp10P+j3TS6JuR0cU5EzFf0wPWFx51i7F5dn3aezJKKGwr+cei48W2Rl8sisM
        53R0U9jjcbDY2fFSitve9kvws9oCBp/13JZga16nFFtdRoS95ioG91zpRDjfXU7jxocZ1NIQ
        8ttnQsTS1sSQb8+fS8gNyxuWFDnrGeK6M5k4yzIYUn/+KkuqLqUQY3UZIsZPDkTs1S9okvY4
        XUq+OydsDNoiXxQjJMQlC/oZS3bI95w/o9x7OfhAfft1aSqqC8pEMg742dDia6MykZxT8jYE
        xXVeiRj8QPC52c6IwXcE7/KL0D9JzoCNFRMlCCq6OoaDDwgeOl76JRzH8GooL98cEIzmp8CL
        9MIhJ4p/IoWBcy1UIBHCr4CWk6ckAUzzk6G1tIwNYBmfBN6vliFewc+DL/aaITyGnw/VH9tY
        kQ+GR+ZOOoApXgtmz2cUaAB8OweNtipKHHUFFN7zMiIOga7GalbEYeDOy6IDgwKfAnmmuaI2
        C4Gr4Bct1iyE1ie+Ye0yaLA1sWJ9ELz6Eiz2DQKT6wwl0go4cVwpVodDRc6tYZdQyO6yDR+O
        QGdeHy3e6hiC5kwvk4smWf5bx/LfOha/LeW/nb12hkhPg+IL3ZSIF0NFRS9tRdIyNFZIMmhj
        BUOkTtivNmi0hiRdrHpXotaJ/E/rHmz8UYNqB3Y2IJ5DqpGKiPy6aKVUk2w4qG1A4X6n944r
        zSiU1iXqBNVoxXr7zWilIkZz8JCgT9yuT0oQDA1oPEerxipmXfy0TcnHavYJ8YKwV9D/y0o4
        WWgqMhb1eguWrg0ejOn3WcPw6q3GdT9XOlxzrp2eIid9LnPCuws3TcUpsjHtb9nswaaJPWml
        y3fvJgPukrVRkYt6fo/LslhHxKl772bGc0+X5KpSZ8Ufnv1hQtrK1km9yepVVsnhTRfvHF9j
        zh0V2e1+rdhwo0+/vHJBdsR42SBKn3YkSkUb9mhmTqX0Bs1fgbXITbwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHffZedsHZ25z0sKJi1IcuTjdbexYqUiNe+hBBgyJrNutFy11s
        7yZZRKIfdJPsKuVwubBlOufWsnnDNCm7SE0r/VJpFyXLWlRElBptjqBvP87/dw7nwOFhIjch
        4R0yWRmLSW+QkgJ86M/98dSm3Nu69MCICM2fG+SiG5f8BPKduoejsL0JQ78jd7mootFPouqP
        y9DpdzMYCocDXBR8N0agifFfHPSsu55El8K3Och9fpJA7lANQFN1N0kU8U4CVDvkw9H9B3Ys
        J5me/X0O0M6JxyT97flzDt3lfMWlG4N9JB3qX00HW+wk3edq5dI3r56ka9pbAF3zIQBof/so
        Tpc/qiTo78HlO5L2yDItZpuVWVloZq1Z0lw5UsjkaiRTbFDL5BmqfZsUSmladuZBxnCohLGk
        Ze+XFbouioo9i4/2ve4gykBvkgPweZDaAE/PXec6gIAnojwAehu+4g7AiwYS2OwqiDvJcG7M
        QcadKQAdb8NkzCEpGfT5dsccMbUGjlY2LDgY1U3AF9VjRCxIpjTwafVZToxFlBw2dYWxGOPU
        aviyuYUbYz5lg8MVATzGQkoFP/s7F/wUSg3bpye48fpi+LBucsHBqCL4w/seOwMo53+R87/I
        GV0Pi+7k706Ll9fBa1dmsDhnwba2L7gbEC1AzNhYY4GRVchYvZG1mQpkB8zGIIh+RGjwV3sn
        cER2DgCKB6SJwvTaXp2I0JewpcYBsCo65m3AOwwkuMlsYqRi4XZ/j04kPKgvPcZYzHkWm4Fh
        B4AyeudZTJJywBz9NZM1T66Uq5BarspQZWxE0iXCKurOXhFVoLcyRQxTzFj+9XF4fEkZOOzR
        vLIKanb1q34oTpTBia0PZrcotCMVwkFMyaRfSJj+dpXXU+8qn8l0jT4K28uOf29zJQa068fn
        Q/n6wyunV5Rs25yneXOrQ5jaysEGxdOS/KJQFb8o52fVR0/p1FJtgmpIY+nVCUZHkNaQ8/JZ
        XfmiI08uf+oHX9NaI8OtUpwt1MvXYhZW/xeIRrh8MwMAAA==
X-CMS-MailID: 20200515090647eucas1p21018edfd835730c9a68dcb186349ee74
X-Msg-Generator: CA
X-RootMTR: 20200515090647eucas1p21018edfd835730c9a68dcb186349ee74
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200515090647eucas1p21018edfd835730c9a68dcb186349ee74
References: <2080864.23lDWg4Bvs@tauon.chronox.de>
        <CGME20200515090647eucas1p21018edfd835730c9a68dcb186349ee74@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-15 pi=C4=85 10:32>, when Stephan Mueller wrote:
> Am Freitag, 15. Mai 2020, 00:18:41 CEST schrieb Lukasz Stelmach:
>
>> I am running tests using SP800-90B tools and the first issue I can see
>> is the warning that samples contain less than 1e6 bytes of data. I know
>> little about maths behind random number generators, but I have noticed
>> that the bigger chunk of data from an RNG I feed into either ent or ea_i=
id
>> the higher entropy they report. That is why I divided the data into 1024
>> bit chunks in the first place. To get worse results. With ea_iid they
>> get even worse (128 bytes of random data)
>
> I read that you seem to just take the output data from the RNG. If this i=
s=20
> correct, I think we can stop right here. The output of an RNG is usually =
after=20
> post-processing commonly provided by a cryptographic function.
>
> Thus, when processing the output of the RNG all what we measure here is t=
he=20
> quality of the cryptographic post-processing and not the entropy that may=
 be=20
> present in the data.
>
> What we need is to access the noise source and analyze this with the give=
n=20
> tool set. And yes, the analysis may require adjusting the data to a forma=
t=20
> that can be consumed and analyzed by the statistical tests.

I took data from /dev/hwrng which is directly connected to the
hardware. See rng_dev_read() in drivers/char/hw_random/core.c.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl6+W6YACgkQsK4enJil
gBDM+wgAqKajSG8VdU0jbHzag/4aYJErE1pxTpDqEjsEkF7cMeaMwpOjLskALmDu
ukYcpFmBPQCN4s0wHx4TTmh+TWPosnYwEgKwlQx8pZ5Y2k/rQ1F6+j5wnjOgISto
+pVuNtuec1S4mXQaN69EfpNFWKrOPvfLLKx1XWHceJ+Qiwy9Hbf+DX0wUW20c3pN
A0RSMIHFOuNHsfqeCRLJxm93GNuNnZl+lyI6fPtbGDDubn2wJQ9R5xJUrHAV95sA
VIFyBVxrq8o9vSBnRic2WA6PHqa5NQQQyOiw8sOcJAhtpQmbEj7m8NwnQAkW27EP
4IWU/gPKFHmM5jYTvdjkqat66a9ddA==
=JDyg
-----END PGP SIGNATURE-----
--=-=-=--
