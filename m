Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CF6C3DA7A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Jan 2023 22:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjABWoz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Jan 2023 17:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjABWoy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2023 17:44:54 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF6B9FD9
        for <linux-crypto@vger.kernel.org>; Mon,  2 Jan 2023 14:44:51 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230102224448euoutp02b9c837feda12e75b31c5857eb71897a9~2n1J4wmzD0468704687euoutp02R;
        Mon,  2 Jan 2023 22:44:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230102224448euoutp02b9c837feda12e75b31c5857eb71897a9~2n1J4wmzD0468704687euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1672699488;
        bh=3wKohNIznyH57YYB5ZNQsR2OUuR/Q7aZGJ0qCguF58g=;
        h=From:To:Subject:Date:References:From;
        b=bvOE3VD6nHOtQXTnzsoij449e7fLvH9+ItwxjhMZFp/cRr4CwSPf/+bxQW2sgA+os
         q+8SjLEzxbOl2DKSeidK3eYAXqedVirhffHHRqvegmoGOc+8yWd6U4s5Wf44G9XB+l
         i2a181nyv2a3bebxtIlYtSpK0kx9KD5nb6y2AfdQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230102224447eucas1p14d060b096429b82e258244b031b8e3a1~2n1JizMY61790517905eucas1p1B;
        Mon,  2 Jan 2023 22:44:47 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id A1.ED.56180.F5E53B36; Mon,  2
        Jan 2023 22:44:47 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532~2n1JL6Kvm2311023110eucas1p1r;
        Mon,  2 Jan 2023 22:44:47 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230102224447eusmtrp1888949d7c4927fcf02fc6b32883c152e~2n1JLSM8Y2679926799eusmtrp1Y;
        Mon,  2 Jan 2023 22:44:47 +0000 (GMT)
X-AuditID: cbfec7f2-acbff7000000db74-36-63b35e5f3548
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 9A.00.23420.F5E53B36; Mon,  2
        Jan 2023 22:44:47 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230102224447eusmtip2b879497356f0d8fe7341f774e2a5be03~2n1I-8HZN2265922659eusmtip2a;
        Mon,  2 Jan 2023 22:44:47 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: xor_blocks() assumptions
Date:   Mon, 02 Jan 2023 23:44:35 +0100
Message-ID: <dleftjk024o8to.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGe7e7eZ3NrrPysFJRk7JoZhQpWilIjEIwqYgydc2bWjrHbmof
        ECZl5Tcry2aZmvm9GUtnflUsUtRsZlauzKGkyfKDNStcljmvQf/9znOe857zwIszeb8wPh4n
        OU3KJKJ4dzYH07TP6jZHRjwSb+ns8vK9o7uE+WYa1/oahmYZgUxhfZWeIdQ88xSa1S6hzCOc
        gGgyPi6ZlHnviuLE3lTGSg12Z9QmJSsVFXMykC0OxDbQd/ahDMTBeUQlgoaCahZdzCC40T7N
        pgszgvyZMda/kb7JD5iVeUQFAsVjD5rHETSOHspAOM4mBKBUHrbKK4kkeNVbYWNlR8INXjR+
        YVsZIzzB0tzCsDKX2AEFbYbF51cRfjA3ZrKhdQfovP15cRWTSIDbuonFS4G4i0PTbD+i7wmG
        4SL9EjuCsaPehua10H09C6MHriBI6y9h0UUeAvPVNAbt8ofBVxY2zUGQNvcOWRMAYQ8Dkw70
        ZnuQa24xaZkLV9N5tHsdqHJbMZr5kG2sXLpBCLWFb2ysdh5xDKaeCPOQi+K/OIr/4igWXEzC
        C+qavWl5E5SXfGXSvBNUqmmsGLGqkROZRCXEkJSPhEwRUKIEKkkSIxAnJqjRwp/o/tPx7TG6
        azQJtIiBIy1atzA88rCmF/ExSaKEdF/JlY+rxTxutOjsOVKWGClLiicpLVqDY+5O3IKGe2Ie
        ESM6TZ4iSSkp+9dl4Lb8VAa1WvFnfu/J4vQt0wF1Hx/F7Ps55Vn04ofWnHPxwP5qV8aDPYWh
        GvG25/q41n675vlr8omnxSNbnctXWAzhT0NrR8PqK3ruU7LJo+M6ym7Scqo3ZCY3W5p3fjhy
        Gr+fc3yZye1TSKNlhdm519/jxsH5rVmdUp9Lg/k9LVH5ZfpC+5euv+3Th266JDtUacNFRsf3
        o0ERur64su2Fmi7P5U222c3Dlys7guVY9et3yqaw9oEo15q36/mCk2xqvKGq8aiwVNqzqc0x
        M7tVzglJJcPq71yIUPFTguI3hH/fEDIBD8v8ikrLYw0DUyUD6hNe0RG7TYEZCnmd6no5t3u9
        LqXHHaNiRT4bmTJK9BcXMeBQjgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xe7rxcZuTDXYdEbGYc76FxaL7lYzF
        /Xs/mRyYPbasvMnkse2AqsfnTXIBzFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuax
        VkamSvp2NimpOZllqUX6dgl6GdPWZhTc567Y9HEtawPjAq4uRk4OCQETiUtvb7F0MXJxCAks
        ZZTY9P0TkMMBlJCSWDk3HaJGWOLPtS42iJpnjBL/Hi1lB6lhE9CTWLs2AqRGRKBU4urKRiYQ
        W1hAUeLo9udsIDaLgKrEr127weK8AuYSM/beZwWxRQUsJf48+8gOEReUODnzCQuIzSyQLfF1
        9XPmCYy8s5CkZiFJzQLazCygKbF+lz5EWFti2cLXzBC2rcS6de9ZFjCyrmIUSS0tzk3PLTbU
        K07MLS7NS9dLzs/dxAgM5m3Hfm7ewTjv1Ue9Q4xMHIyHGFWAOh9tWH2BUYolLz8vVUmEd9KL
        TclCvCmJlVWpRfnxRaU5qcWHGE2B3pnILCWanA+Ms7ySeEMzA1NDEzNLA1NLM2MlcV7Pgo5E
        IYH0xJLU7NTUgtQimD4mDk6pBqZ9mw+5PatZ+6F3zbM5b96t139aE3QhP2bjBSt9HvNjBxvK
        zrY3xaaXLvN1Swq5tN6J74zeF8UmZqGrh3Tyvs39b1AuV1o3S/DZhxULisv3lySe9UwPNs2+
        LfiXRy4zPmHzfMnclwkiwZy8vVf2Re1VvXVRXnu/lF4+779js50vHHLkmR6oEmL306LK5d7b
        GZ/i9q4tKOGof73JVnn1t0l691raAidMOf6ohiPF8NrlwvM7z3dzi4nzfjs35fZtpXWGq+0e
        zrmT9uXCkZ0bP7ioyzy92+Npukw7snqabN7GJZdnM/Nckdkud5B5q8W7BO7KabLFT0V2t1X+
        Lji58eX02AvzV/8UXFT6SFIombVKiaU4I9FQi7moOBEAWljNNfsCAAA=
X-CMS-MailID: 20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532
X-Msg-Generator: CA
X-RootMTR: 20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532
References: <CGME20230102224447eucas1p1dad1a2362030eee0d3890dd3546a1532@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am researching possibility to use xor_blocks() in crypto_xor() and
crypto_xor_cpy(). What I've found already is that different architecture
dependent xor functions work on different blocks between 16 and 512
(Intel AVX) bytes long. There is a hint in the comment for
async_xor_offs() that src_cnt (as passed to do_sync_xor_offs()) counts
pages. Thus, it is assumed, that the smallest chunk xor_blocks() gets is
a single page. Am I right?

Do you think adding block_len field to struct xor_block_template (and
maybe some information about required alignment) and using it to call
do_2 from crypto_xor() may work? I am thinking especially about disk
encryption where sectors of 512~4096 are handled.

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmOzXlMACgkQsK4enJil
gBDN7Qf5AUHJBxnjfBkzVjHIgnjw7zePEKjjejojGD0rRpEOuW8UMqjseFlAmIOM
HMJ7uN28ipcFfcs2d0rCahi25Z+BQ9w2e5P+A2U8yAQJqTtIXgOEEX+XovoCoPkA
PC4rf0hJBoHMbsyYbnE/fXdiMqtOhjh1zPJYk21HRVvmT1Vmwn7g8nz5bNrhfOvd
D9pkumcgR1+Mm/brR5tgvI38458vYoPOeu28LOUlr9fzvI0iH+reA65SfWzuRWl6
UcddOJPlhUfl0tfUCKJwLAT+13mmc1/3eC72L4qfc2jKRP3TlQICAb9KagtUE1qe
DwGtZS7+6fPaKlPxJzsZcreXLakztQ==
=n7YA
-----END PGP SIGNATURE-----
--=-=-=--
