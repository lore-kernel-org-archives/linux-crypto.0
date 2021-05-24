Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E56C47083
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 08:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C7D161354
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 08:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhEXIeP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 04:34:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23795 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhEXIeO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 04:34:14 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210524083245euoutp0247e9c49324bc01ac2e097399ce06036c~B85XDs0EA0318303183euoutp02D;
        Mon, 24 May 2021 08:32:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210524083245euoutp0247e9c49324bc01ac2e097399ce06036c~B85XDs0EA0318303183euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621845165;
        bh=qwqR1BNh3mimBBRmdJxT8M1e0EB8tVvcsh5WWn2peN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PalQo9i/or2FTzwmu1ANp2KD57fEWwXA4/II6M8LxUDnE9ZIJNHlW01MVAbAk9twY
         rJWdbpDjjb3LYtx0SvnDZayZJ9VJSL2SE6VSUsYm971vqk+dFoKyB+4gjcphW+u42R
         37XGGI4eRbNLv26DErjjG+E2/6uhwKwEDvumyft4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210524083245eucas1p14d2b4f0b579dc7ef5589ea6db0422f4f~B85W48a2E1964819648eucas1p1z;
        Mon, 24 May 2021 08:32:45 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 45.59.09444.DA46BA06; Mon, 24
        May 2021 09:32:45 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210524083244eucas1p263470ad84270aa59c06432c92cf56280~B85Wf1XRQ3250432504eucas1p2F;
        Mon, 24 May 2021 08:32:44 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210524083244eusmtrp2da8abe0073e15fa8594edd99597023af~B85WfM_Qa2429424294eusmtrp21;
        Mon, 24 May 2021 08:32:44 +0000 (GMT)
X-AuditID: cbfec7f4-dd5ff700000024e4-35-60ab64ad72e9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EB.27.08696.CA46BA06; Mon, 24
        May 2021 09:32:44 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210524083244eusmtip2fe1925d329ae959edce653f598931cb2~B85WUK5Hr1154311543eusmtip24;
        Mon, 24 May 2021 08:32:44 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <krzysztof.kozlowski@canonical.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] hwrng: exynos: Use pm_runtime_resume_and_get() to
 replace open coding
Date:   Mon, 24 May 2021 10:32:33 +0200
In-Reply-To: <1621569489-20554-1-git-send-email-tiantao6@hisilicon.com>
        (Tian Tao's message of "Fri, 21 May 2021 11:58:09 +0800")
Message-ID: <dleftjy2c4zg4e.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djP87prU1YnGCyeyGGx8e0PJov7934y
        Wcw4v4/JYvXrfewOLB6zGnrZPB7P3cju8XmTXABzFJdNSmpOZllqkb5dAldGQ9NR5oJbfBUN
        H/4yNzDe4Oli5OSQEDCRONf1ir2LkYtDSGAFo8SOMxNZIJwvjBKz359mhHA+M0o8XvufHaZl
        3/O5rBCJ5UBVR58xQTjPGSXOfprB3MXIwcEmoCexdm0ESIOIgKrEkqblrCA2s0C+xMEZV5hA
        bGGBGInrV06CDWUBqlm+uwnsDk6BZkaJc3uXgBXxCphL3H95EqxZVMBSYsuL++wQcUGJkzOf
        sEAMzZWYef4N2KkSAhc4JB433WWEONVF4sv5RywQtrDEq+NboF6Qkfi/cz4TyKESAvUSkyeZ
        QfT2MEpsm/MDqt5a4s65X2wQtqPE9/YZrBD1fBI33gpC7OWTmLRtOjNEmFeio00IolpFYl3/
        HqgpUhK9r1ZAXeMh8XL3B2hYz2KUePZtMfMERoVZSN6ZheSdWUBjmQU0Jdbv0ocIa0ssW/ia
        GcK2lVi37j3LAkbWVYziqaXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIHJ5vS/4192MC5/9VHv
        ECMTB+MhRhWg5kcbVl9glGLJy89LVRLh/du3MkGINyWxsiq1KD++qDQntfgQozQHi5I4b9KW
        NfFCAumJJanZqakFqUUwWSYOTqkGpqXHypRXpdwU5BSeceDYjPC/Gyep+ZZVnZ92+tOX/Fre
        jhXG7HPuzebTFT9eVlb/QkpZ93O3yLFNZucnLGaMYiiIUbpxon+nzSlTszwTycnW0z7OmRg7
        Q7Vue4ftV+WynoxFake3zqyZstSkfltg1P/sIN3ktGwb5zVdm6UanyqHiR02vXFpybNzD293
        fp3fKqAsv2byxqgVmy6vWlixQDVK8lHvpAeeM4/OFTeUSbb7fWbPnAVl7gJb+JaJak6YlTXT
        PuOSkId3k/jOtYpFXt8ebMqpuzJ9E3+uss/Kj2kPz+xQPndxonhi2a6eyznqH636ji0UNlVx
        nXru/EuxhcFCqpu1VjCH5v3Z9oT100YlluKMREMt5qLiRAB+UxBNsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xe7prUlYnGJw6q22x8e0PJov7934y
        Wcw4v4/JYvXrfewOLB6zGnrZPB7P3cju8XmTXABzlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWe
        kYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl5GQ9NR5oJbfBUNH/4yNzDe4Oli5OSQEDCR2Pd8
        LmsXIxeHkMBSRomOR7+Yuhg5gBJSEivnpkPUCEv8udbFBlHzlFFi669edpAaNgE9ibVrI0Bq
        RARUJZY0LWcFsZkF8iQ6N61gBrGFBaIkjt9bzgZiCwm4SbxcfgGshgWofvnuJnaQmZwCzYwS
        XasPsoMkeAXMJe6/PAlWJCpgKbHlxX2ouKDEyZlPWCAWZEt8Xf2ceQKjwCwkqVlIUrOAzmMW
        0JRYv0sfIqwtsWzha2YI21Zi3br3LAsYWVcxiqSWFuem5xYb6RUn5haX5qXrJefnbmIExsm2
        Yz+37GBc+eqj3iFGJg7GQ4wqQJ2PNqy+wCjFkpefl6okwvu3b2WCEG9KYmVValF+fFFpTmrx
        IUZToN8mMkuJJucDIzivJN7QzMDU0MTM0sDU0sxYSZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5O
        qQYmvp2VzBYPTFTn8k7yY+p5qZ39IDn8a43XY8FProKvPprwHXySsUtipcquKSydD3d8Sm33
        SuWcs6CsmdlO+ui6RTXvbXTDdgZdep319+l6RfkGvagvc7sUN1ne1E5YckT9V7a+99UOk3/M
        V5Ia7DgD5pV9/j17wWX5IKsnZv/elLw+4tBw8if/vaf/ttamC8Vm3o19MNfkRzUPQ+Yjc+n+
        ALF3tYckn39WPnt2Rz9jdixPSD2DQviiRSn8PWpKirHPdJu32fzYeqhch/FRWYwBW/PvavF9
        0sa+Alln7afm+3r2mp5f+H7HPb8/iyz/F+/MYrZ4tH9Pj+bqb2fTTy7eve+a72H+3kW72AwN
        Tf4osRRnJBpqMRcVJwIAfH9IpSgDAAA=
X-CMS-MailID: 20210524083244eucas1p263470ad84270aa59c06432c92cf56280
X-Msg-Generator: CA
X-RootMTR: 20210524083244eucas1p263470ad84270aa59c06432c92cf56280
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210524083244eucas1p263470ad84270aa59c06432c92cf56280
References: <1621569489-20554-1-git-send-email-tiantao6@hisilicon.com>
        <CGME20210524083244eucas1p263470ad84270aa59c06432c92cf56280@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-05-21 pi=C4=85 11:58>, when Tian Tao wrote:
> use pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. this change is just to simplify the code, no
> actual functional changes.
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/char/hw_random/exynos-trng.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f..d71ef3c 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -196,10 +196,9 @@ static int __maybe_unused exynos_trng_resume(struct =
device *dev)
>  {
>  	int ret;
>=20=20
> -	ret =3D pm_runtime_get_sync(dev);
> -	if (ret < 0) {
> +	ret =3D pm_runtime_resume_and_get(dev);
> +	if (ret) {

pm_runtime_resume_and_get() (see include/linux/pm_runtime.h) checks for
ret < 0 and returns it, so I think it is better to keep (ret < 0).

>  		dev_err(dev, "Could not get runtime PM.\n");
> -		pm_runtime_put_noidle(dev);
>  		return ret;
>  	}

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmCrZKIACgkQsK4enJil
gBCyEAf/d2Zw70kujgGEQWPrkeLmvoZmGFM7fhsVYADO4PvD55QRF3Er0bLWC2sf
xd6gbcVU935trDA3UfRIT5fgEx6Dzxudz8CGmDbGnrX6cSV14kSOrYy8FEC7++Cw
19dPfIayqUszjUMprKoHlNcs+02y/Uth1OFm58uB0ptPwbvRmzpNAQiRcEFyc/u7
zv1py8TYLwMa1hptu1ZgZV1uqXA+8lktA8iOQHkWqp78H2wcm82sGalTCmvE1v4U
coe+NGbUVBCx7NqY802VzZh53MxEd+nYzxMk55DEF0YzCG2rsp3DwE9NFDv5EPCn
p0+0v4nwQn/K/4yUvD8ChDGcxtYQkA==
=J0qR
-----END PGP SIGNATURE-----
--=-=-=--
