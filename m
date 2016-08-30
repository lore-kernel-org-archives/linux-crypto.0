From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] char: hw_random: bcm2835: handle of_iomap failures in bcm2835 driver
Date: Tue, 30 Aug 2016 11:26:05 -0700
Message-ID: <87bn0aazb6.fsf@eliezer.anholt.net>
References: <1472490616-9597-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.apana.org.au,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, lee@kernel.org,
        yendapally.reddy@broadcom.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:37984 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751680AbcH3S0I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2016 14:26:08 -0400
In-Reply-To: <1472490616-9597-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Arvind Yadav <arvind.yadav.cs@gmail.com> writes:

> Check return value of of_iomap and handle errors correctly.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJXxc+9AAoJELXWKTbR/J7oN9YP/0qnyJ8zbqi++fwBaM9qWLJU
xdDxtxLMszO9aY6xKx58I4p6LDTMgp+cQfBN4jgDSCIMxMvtN38LJp7/ICJBP+c1
HB+/gopxkIzoM1oc8O3fS3/04EKi+7ebGzTY+AxYZiN/A4Zub56ufegc80T877JJ
+NKIHIa0Ey7x7K++I4tFH3//NcfPzz61jT3WLLiRYrYq6Q0ieH+prtsbi4W/agbc
uB9CjgpagcA7qREQIvyAeEWEVWXdHeDqgmEd7Hvb0iDBgu+Rhjg6ROVna6l/j4y5
zRVpuD/ox9yskaQWClgE+k2bmS+sBcCYSSlznX2BE9j7P9HeR10grgX1/0PJJO9U
7bX1BehmDMwzfpDLtqdV6+m1YQOJKiQdS20UjbcJ41yxRxivTDDEbW9p4tg6nVDF
lQVhAXnCLMfkleZfVhJbShjs10N++VQaVRV4A4gGqasnaa5gN8FhD1qXSvoq0obp
ShkmM86fFQFUzJf3M6RmrJgl3gcWcdZnsE3mICVWP1MPEvj/LwJNgIyI4+FA/PQT
SOnGqHnvw3EvqFGW1AEgzPnC4FFXyFoJCdQsxnEWTEAMnvrdRXEztwJ7ZBBxx59l
6eDETBchMU7jGk3pjcsKzU0FTDxMRMP4x1zoSJgn+B+BJxGL7dvlWh0aAAwd9wEa
d/T9LMiHp5TqHJxikxCS
=NhD8
-----END PGP SIGNATURE-----
--=-=-=--
