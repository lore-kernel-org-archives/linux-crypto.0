Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C264C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC6B20748
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j6FR1biL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgEUNxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 09:53:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43618 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgEUNxN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 09:53:13 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200521135310euoutp012ec60fdbed0cda17e2b7d3cad3c9823d~RD4EMlap00262402624euoutp01C;
        Thu, 21 May 2020 13:53:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200521135310euoutp012ec60fdbed0cda17e2b7d3cad3c9823d~RD4EMlap00262402624euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590069190;
        bh=YfRtVo8/rtlJ19IErtdjlJ6JVjpxclDbDa34stjlnO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6FR1biLt8D+cfQ+J7u1OupmI2veRnVbgvB+flxRmCCMO1JyKgbMloYzT7+YW6l9B
         gP7BrtVHJJcohh04Hz//3ZsH1SegnO4Zgr3w8jjREuSQkei53TW03Bqfh52vOTsrtZ
         9p8F5wIvgeOp/ZbAhnWkAYYfOSdYdJFi9K9JuAyU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200521135310eucas1p21b83ff5816dc51b51e4155298e15dfd5~RD4D-U-pn1391613916eucas1p2l;
        Thu, 21 May 2020 13:53:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 85.D2.60679.6C786CE5; Thu, 21
        May 2020 14:53:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200521135309eucas1p1c0734570f04660c8b60ea12531f53e60~RD4Dp5vXT2496524965eucas1p10;
        Thu, 21 May 2020 13:53:09 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200521135309eusmtrp2aa4fddb17d67739dcf9feec5996efb4b~RD4DpNwcT1832118321eusmtrp2K;
        Thu, 21 May 2020 13:53:09 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-49-5ec687c6951f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id E9.A5.07950.5C786CE5; Thu, 21
        May 2020 14:53:09 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200521135309eusmtip2b27232232bd46d20d6f1afbec6d9c609~RD4DbB-7K0157001570eusmtip2N;
        Thu, 21 May 2020 13:53:09 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: exynos - fix runtime pm imbalance on error
Date:   Thu, 21 May 2020 15:52:56 +0200
In-Reply-To: <20200520131911.16813-1-dinghao.liu@zju.edu.cn> (Dinghao Liu's
        message of "Wed, 20 May 2020 21:19:10 +0800")
Message-ID: <dleftjmu61z96v.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTURjGOd67e6/D2XEavi2LGArZh1pa3uibpC4RGYgQQdZqN5W2GVtm
        5R9+ZOXMUpcfJas008R0mcnaVErEViK6orKCUsnM7ywNTGua8yr03+99nue8530PhyGkIyIZ
        E6s5zWs1CpWcEpNm22T7WttlW1TQ4xGCdRhsNPtkIoVkL5Q8pNgrgz5sVs8Qwb683Uazdns1
        zdb0dIjYrs5JF/ZNnZFib9ifurBF5mtohxv3Z8qAOHOjH1dToae4Z7cqae7xvSTu2kA14t4V
        p9LceM1yTl83Qh1wPSTeouRVsWd4beC2o+KY/PcO4lTmorOWtxY6GWVJMpArAzgErji+URlI
        zEhxOYLCtp+EUPxCcKGvnBSKcQTPLqeIFo7MGK4iwbiP4G++nXYaUtyHwKoPy0AMQ+EAqKo6
        6JS98Eqo702lnXkC6wkoaxgnnYYn3g0T3wuQk0nsBy3TVsLJrjgRsnO75zISHArTQ5mUkxfj
        TVDb30ULuge03Pw6lyGwGm7ah+cGAqxnoNRqooVJwyB14M08e8Lgi9p59oEZ6x0X56CAk+C6
        YaNwNhOB2fibFDKb4VP7FCXwTmjsrSeEvDt8GPEQ7nUHg7lgXpZA+iWpkPYFU1bDfBcZXB0s
        RwJzUF9gEQnvloUgx5ROZaMVhf+tU/jfOoWzbQnsDw/rAgV5NZQVDxECbwWTaZQsQqIK5M3H
        69TRvG69hk8I0CnUunhNdMDxOHUNmv14rdMvfllQ3d9jTQgzSO4m6T5ui5KKFGd059RNyHe2
        05fqB6+QjNTEaXi5l6R40fMoqUSpOHee18Yd0careF0TWsqQcm9J8N2Bw1IcrTjNn+T5U7x2
        wXVhXGXJyMznVPw4S4d4BIWHIyLQ4h+xPSdt1C/vsF/yBs/SUOPH4f1t1mW1pS3v+8aC80YV
        31WOye7E8p5lXrtO7O1MSVvCRirz1ktXl3Ss2rMzcE14c0Ra60VT2T5Za3NLztGKhMrUgUna
        N9241qOrn8lLGgvyfm2OfKQc+3wp18cY+7xBTupiFOtWEVqd4h9uZsX1gAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7pH24/FGXy6pGHxd9Ixdovt3xtZ
        LJoXr2ez6H4lY9H/+DWzxYl5Z9ktzp/fwG6x6fE1Vov7934yWVzeNYfNYsb5fUwWC7b1MTrw
        ePz+NYnRY9sBVY9NqzrZPPbPXcPusXlJvUffyw2MHlcXNrF7fN4k59G56y1bAGeUnk1RfmlJ
        qkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsa063+ZC3r4K3Zc
        2cHewNjP28XIySEhYCLxf1IvYxcjF4eQwFJGiYn/ZgI5HEAJKYmVc9MhaoQl/lzrYoOoecoo
        ce19LxtIDZuAnsTatREgNSICGhK7nzaxg9QwC/xnkljy8QojSEJYwE3i+7vpYLaQgLXEme5D
        YDaLgKrEyX87mUFsToFqiQlTHrCA2LwC5hL/XvewgdiiApYSW17cZ4eIC0qcnPkErIZZIFvi
        6+rnzBMYBWYhSc1CkpoFdB6zgKbE+l36EGFtiWULXzND2LYS69a9Z1nAyLqKUSS1tDg3PbfY
        SK84Mbe4NC9dLzk/dxMjMFq3Hfu5ZQdj17vgQ4wCHIxKPLwPko/FCbEmlhVX5h5iVAEa82jD
        6guMUix5+XmpSiK8C/mPxgnxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjDB5JXEG5oamltY
        GpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi4JRqYNR+GrfUnHO7adfF19qMc+YsaHG5
        9/eXyqSnk3Kddp15PeFldIiSqpJLjYTO20lXdxRM//JWbcvZ9jgWQZYVQqwPvzEUaclt6hQX
        YvQ6vuTmZM3j9Qa1RbFqV59JL9grzNcpVaizx5HFydZ2Tszri6lt9mGT8if9s3S3/vGl3MBW
        //JihZj2EiWW4oxEQy3mouJEAKZFW3z4AgAA
X-CMS-MailID: 20200521135309eucas1p1c0734570f04660c8b60ea12531f53e60
X-Msg-Generator: CA
X-RootMTR: 20200521135309eucas1p1c0734570f04660c8b60ea12531f53e60
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200521135309eucas1p1c0734570f04660c8b60ea12531f53e60
References: <20200520131911.16813-1-dinghao.liu@zju.edu.cn>
        <CGME20200521135309eucas1p1c0734570f04660c8b60ea12531f53e60@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-20 =C5=9Bro 21:19>, when Dinghao Liu wrote:
> pm_runtime_get_sync() increments the runtime PM usage counter even
> the call returns an error code. Thus a pairing decrement is needed
> on the error handling path to keep the counter balanced.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/char/hw_random/exynos-trng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f8dd2d..133e017db577 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -165,9 +165,8 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>  	clk_disable_unprepare(trng->clk);
>=20=20
>  err_clock:
> -	pm_runtime_put_sync(&pdev->dev);
> -
>  err_pm_get:
> +	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>=20=20
>  	return ret;

You are right. I will accept the patch, when you remove the err_clock
label and and change goto instructions above to point to
err_pm_get. There is no point in having two labels.

Thank you.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7Gh7kACgkQsK4enJil
gBBm2Af/SrD1GVby/I1q7EfWsefc/fbhflA6BuaxaeBQftAotiqgfdhW4fSiUyjb
6eG0I7Yq9kppEWBOyUi1qEUypzN9KFvBQ20ey9mqNtj+g+xVXTxmHMjZMrszb41U
tO7ePEx15hrnjro40NmDMlObuJU1PMVb3EZuZbkoM2qiC9S8ktAar1Cuiw2etyMf
yFWlwmjb+H+RsjVokVyQxW+UgZ9BgRFBXgifvHixN4ngrVB6ANSZAjjhNE66v0R3
/8V9R+Z562uWyoqser/x4Nm9ygmBvtB9cKWiHgODK5sycgwuGQYlaFGWWTdZ6P7L
7pFWPeP4nd73lk8OQwAz7w6E9U7Crw==
=o590
-----END PGP SIGNATURE-----
--=-=-=--
