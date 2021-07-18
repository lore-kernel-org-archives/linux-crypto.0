Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C82BC636CA
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 22:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6091360BD3
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 22:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRWQX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 18:16:23 -0400
Received: from ozlabs.org ([203.11.71.1]:36407 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGRWQW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 18:16:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GSfPY3jcQz9sRf;
        Mon, 19 Jul 2021 08:13:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626646402;
        bh=76JJ6B/S6eIHUIE32siXxhCH89n+pV1CtCnbUm403lI=;
        h=Date:From:To:Cc:Subject:From;
        b=op9EhBvAWlv+qwBaV5k6Kyg/bjCLlQr8+e1YWO8NOeYEGReSZILxeiu6CHUDWMbsq
         A29KGaC7NnjYkFVgAIrApvT+5/RSsm1LyNlVQM7yVIBxTlkOyt5EELP64BKcZL4b26
         SAppMJOVxvAPmNWBZ2GJ07RzI+YuFtWY7TTSFr0Z7qbgiRFZ4JBJZBlk75LV4rp+j+
         U+pNazZLadO4MMj2ZwusaUfOHHCk5AMCZC2tCcHNs7iVnbR+5GTDUfsz/PgVuYfWyw
         yrBzsWPHoidmYSCSHvQia3XnhMx8KYcpqf9Ey4y/XgiT5k5ToXsQUaZ2WLNoJKbE2T
         i3kRMOhxFfR4g==
Date:   Mon, 19 Jul 2021 08:13:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the crypto tree
Message-ID: <20210719081320.1d205c98@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7u=v7OJOCpMjm9K.1gh1z1W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/7u=v7OJOCpMjm9K.1gh1z1W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  5261cdf457ce ("crypto: drbg - select SHA512")

Fixes tag

  Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG as default

has these problem(s):

  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/7u=v7OJOCpMjm9K.1gh1z1W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD0p4AACgkQAVBC80lX
0Gx1jggAlfLGtProRJIvMM7OnVh2SE7C24yyYONis9zMbMWCtBeQj/C7NawDtSg0
BMuIkUUV8RIe85guMMdWGJiLWDL+fxLg8Zf/sImB1buLKLtuf+Rk+4Jve9wrsFKC
kGGMwTcDQbh8/nngdUrWwbD+j1rv99raf0Xwn2xe5eLkB6EmNaXN5feg41mynsMm
rDHvbn8iQFSLZDozK3PbF1LKGkwAyBXYr6icP1jX9j7SpShG4DLYiUjmAZ558Jnw
0KZfq5DOAr1kixOOAWyVOM6U1BnlEZ743GO5Wld0vK0DC/8mlir4apmXDNJthnDn
Tk3IoGGH0JEAInJ965IdvXjBcXWf2Q==
=6IQD
-----END PGP SIGNATURE-----

--Sig_/7u=v7OJOCpMjm9K.1gh1z1W--
