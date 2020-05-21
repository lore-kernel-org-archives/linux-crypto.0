Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7797DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 19:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40CF4207D3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 19:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qEqYU8O4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgEUTOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 15:14:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39144 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgEUTOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 15:14:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200521191416euoutp01406a09fea21c119418aed71c6e462521~RIQbJ_DFV3049730497euoutp01d;
        Thu, 21 May 2020 19:14:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200521191416euoutp01406a09fea21c119418aed71c6e462521~RIQbJ_DFV3049730497euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590088456;
        bh=2Hm918oQzbPJkJZODw11AOxw6PW5YurvcHvbPoWuhvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEqYU8O4luTy/5y9TlzG4psZVbnqA76Ard0Z1v0X6j0axobO9srSshZLNWay8fT8A
         0AkYpS1mRQu81nhEC0fqyEYsLKZXpkfdZ0cbQsyZtHg359Hvs92x4zHkL+UY41NW1n
         qsuv65IdMAoG2jXMXBmIQpSXf1bssuMOpFM0y+dU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200521191416eucas1p1f9c925645e26efd0d940969d4d63cbfa~RIQav2Bdt1168511685eucas1p1M;
        Thu, 21 May 2020 19:14:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 5F.86.60698.703D6CE5; Thu, 21
        May 2020 20:14:15 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3~RIQaEFCrA2032720327eucas1p2T;
        Thu, 21 May 2020 19:14:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200521191415eusmtrp28b9448932936d83ce87cdd52598ba64f~RIQaDSRJK2432924329eusmtrp2l;
        Thu, 21 May 2020 19:14:15 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-7d-5ec6d307ba94
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DC.56.07950.703D6CE5; Thu, 21
        May 2020 20:14:15 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200521191415eusmtip22a3ec30a98ec92f7cf49806acb8289f2~RIQZ4NyI80034100341eusmtip25;
        Thu, 21 May 2020 19:14:15 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
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
        Stephan Mueller <smueller@chronox.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Thu, 21 May 2020 21:14:02 +0200
In-Reply-To: <573b2eff-3c74-90e9-50fa-644264d0a0e5@i2se.com> (Stefan
        Wahren's message of "Thu, 21 May 2020 13:00:33 +0200")
Message-ID: <dleftjftbtyubp.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGc3o/aVZ2LDLfVcOWBlzUSbcIepzObAvL7j9GY5bJTAZe5Ypk
        tJhe64Zug6nT8SEoxgAFNz4UWBEKpTTDODZxFAaTOtsZJJMyqCgfosI0yhyOcjHxv9/7Pu95
        zvOeHJ7SVrM6PsW0VzKbxFQ9q6Zd7sc9KzmvO+GNE+NryX8Fbo40FtkZUnesnSaerGqKTE/8
        ypFDlXaW5IwuIflDYxTxeBo44hi6xhB//2MV8Z4vZUmRp1VFyk4GGFLmykPkZnETSyZqA4ic
        6q6jiaOml30nTPh3ugAJVv9lVpj0+VRCi/UGJ7h+iRKa+2IFhy2LFX4+fY4Tms5kCHlOGxLy
        RhqQYHf+SQsHu44ywpQjYnPoNvX6JCk1ZZ9kNmzYrt7d3FSs2jP90uffVF+iMpE/LBuF8IBj
        YGBqiMlGal6LaxBc7xqklOIfBGc7+zilmEJwxXZQ9ezI4ZxBWhGqEfSNnEFBQYtvIbh/R8hG
        PM/iaKiriw+2F+LlkJ3lmDOisJeBklwbFRTC8AdQ3ltFB5nGUVAx4meCHIK/hEsD42yQNXgN
        dB5pnPMPx2vBedvPKf0F8FtxYO4shY1Q7BlHSrgBHq7lfKxwHHgGz3EKh8Foh3Oel8DTlu9V
        wZyAM+BkwepgNsC5CFylj2hlZh381TPNKvwu+B4GkDIfCr13FijXhkKBq5BS2hr49ohWmY6E
        +vwL8y46ODZaM59MgK+dgfn3zEdw70Qpdxy9an1uG+tz21hnbSm8DOznDUp7BVSVj1EKvw31
        9XfpMsTY0CLJIhuTJXmVSfosWhaNssWUHL0zzehAs1+2e6bjwY+o9cmONoR5pH9BQ3a5E7SM
        uE9ON7ahyFmnwYbaK0hHm9JMkn6hpvzF9gStJklM3y+Z0xLNllRJbkOLeVq/SLOqYuQTLU4W
        90qfStIeyfxMVfEhukykndiyLHPrRVHd/OFkpcF/tjHm5RLWsDnWu+39otSv6N9v/SBGuF1x
        sRv7W38Kn5lM2lTYODx8NSbxMrvG+0rnOqdtV5eh/7UVF6//4TtV+8QXVXW4JON4XITl73hz
        j9Muzwy3jr330Xe5mtdb3orfkm4YtSytOa07cCgy8egX9tKrK8P1tLxbfHM5ZZbF/wHVVITg
        ugMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTURjHOXtvU1oet1mnFSFjftBya7O1Yze6EL1fgizI0NKGvqjottq7
        WQZR2NVJWkqlo2Baamne5pQyKrNcloaBdjN15YUu2rLEILtujqBvP57/7384DzxCQuygZMIM
        o4UzG/VZcjqY7Pr9cCia6XUnLTt/OwT/KnIzuLGknsK1pztI3JNXReAZ7wMGH71cT+P8j4tw
        4cg4gXt6GhjsHHlOYc/QdwHubb1I45KeOwLsKB6lsKOlAOCx0iYae2tGAT7XVUti59WX9DoJ
        +2OmCLB2zxOa/drXJ2Bv2gcZtqUtgm3u17LO6jyavXvpOsM2XTnMFriqAVvwoQGw9a5nJJv7
        +CTFTjkXb52boFxtNlktXHi6ibeskSeqsUapjsVKzfJYpTpGt3ulRitXrV2dymVlZHNm1do9
        yvTmplLB3pl5B45X3SeOAI/EBoKECC5Hx/KHSRsIFophBUClA5OEDQh9gQxdu5QWcCTo53Mb
        HXDGAJpo8wK/Q0Mlqq3d6XekMArZ8pyM3yHgXQoVV44AfyCBm1HZy0rSz2K4Cv1pmZhlEkag
        8g8eys9B8BC64Kqg/SyCOtR5onG2GwZjkeu9hwnMQ9Gj0tHZLgEz0XTNO+IMgPb/Ivt/kd33
        PQJGovpWVWC8BFWWjRMBXoPq6j6TDkBVAyln5Q1pBl6j5PUG3mpMU6aYDE7gu4gW93fXDWDz
        bm8HUAjkc0RvUtxJYkqfzecY2oHC98xwQ81TICONJiMnl4rKQjqSxKJUfc5BzmxKNluzOL4d
        aH17niVkYSkm360ZLclqrVqHY9W6GF3MCiyfLzoF7+0SwzS9hcvkuL2c+V9PIAySHQHuC/cu
        blG9XTapBVk7Ig8MtKni6WmvBAwmbBwrHN8nzFufvOJU9QImPion6sv7bXFS6lPb/k7FUlv3
        0MmRFxXfTgs2haOSxLqkyU0LQws10dIzG3I7UJwCDhTJpvaTiuIYF/vqVoFUrzjYnz/HJvhp
        najrfTX1tTvZ9dpZnvpCTvLpenUUYeb1fwH2utjCMwMAAA==
X-CMS-MailID: 20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3
X-Msg-Generator: CA
X-RootMTR: 20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3
References: <573b2eff-3c74-90e9-50fa-644264d0a0e5@i2se.com>
        <CGME20200521191415eucas1p2d112a86171b23dcf255e7da53a56f4f3@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-21 czw 13:00>, when Stefan Wahren wrote:
> Hi Lukasz,
>
> Am 19.05.20 um 23:25 schrieb =C5=81ukasz Stelmach:
>> The value was estimaded with ea_iid[1] using on 10485760 bytes read from
>> the RNG via /dev/hwrng. The min-entropy value calculated using the most
>> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.
>
> could you please mention in the commit the used hardware
> implementation(s) of iproc-rng200 to get this quality?
>
> AFAIK there is still no public register description at least for the
> bcm2711. So is it safe to assume that the suggested quality applies to
> all possible configurations?

I've learnt that there is a post-processing unit in RNG200 that tests
the output of the noise generator and fills FIFO only with data that
passes FIPS tests. Unlike simmilar unit in Exynos, it cannot be disabled
or bypassed. Therefore, after Stephan Mueller's thorough explanations I
am considering dropping this patch in v3.

However, I stil am still not 100% convinced that it is impossible to
assign the quality a reasonable non-zero value in such case.


> Thanks
> Stefan
>
>>
>> [1] https://protect2.fireeye.com/url?k=3Dda4735b2-87d99b28-da46befd-0cc4=
7a336fae-e1c21080bc6ab1e4&q=3D1&u=3Dhttps%3A%2F%2Fgithub.com%2Fusnistgov%2F=
SP800-90B_EntropyAssessment
>> [2] https://csrc.nist.gov/publications/detail/sp/800-90b/final
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  drivers/char/hw_random/iproc-rng200.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_ran=
dom/iproc-rng200.c
>> index 32d9fe61a225..95669ece050f 100644
>> --- a/drivers/char/hw_random/iproc-rng200.c
>> +++ b/drivers/char/hw_random/iproc-rng200.c
>> @@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device=
 *pdev)
>>  	priv->rng.read =3D iproc_rng200_read,
>>  	priv->rng.init =3D iproc_rng200_init,
>>  	priv->rng.cleanup =3D iproc_rng200_cleanup,
>> +	priv->rng.quality =3D 1000,
>>=20=20
>>  	/* Register driver */
>>  	ret =3D devm_hwrng_register(dev, &priv->rng);
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7G0voACgkQsK4enJil
gBCTpAf9EuGO7grEX/oH7Vcrzy2CBVDtdNQcJXDRvzv5S3eM9Hn2DzUMjdbJfnCU
kaXL16BI7IXz70IV64NakifjI6BeMuHria7mloEKupURngqPpDGnikOZFvLqzaib
Hb7rgbdK20pCwmWzRB0tnsSeWZiLhCEeyuYY5ZyMfPPci1uXstDFjUicdRY13D3S
zEJCVWNaNqihaYX+6OeGPWrPiCiB9ufmWy+9iZNSLuCmUgXwIoXOFn6ALS/ydOPt
pQ2vooM/p3I+z/t55Y2XyTa220/FjK55fE3othybXSsdYq8a+Stwm1FGLu7GvoaQ
3c+8fUGvKHEvOWx3jB8UXca/n0AwjA==
=kxZ0
-----END PGP SIGNATURE-----
--=-=-=--
