Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0A8C43460
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 22:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AD0610E9
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 22:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhDKW2u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:28:50 -0400
Received: from ozlabs.org ([203.11.71.1]:47393 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDKW2u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Apr 2021 18:28:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FJRNF4BvSz9sW4;
        Mon, 12 Apr 2021 08:28:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618180110;
        bh=fP3GesCiOkWm3CBwoD72L76loWNr2ldZNLevrAelw5Q=;
        h=Date:From:To:Cc:Subject:From;
        b=jNuKGQRq88iSVfPaLiCclsMjAr9MatCwEutLCJfaqiPq6m7WM9sJ5R1UTd7Hq4XSS
         mTTOo0lXLRV+xErsnhWH8kxji82rQeAinZ72haIF0e4IvW4ul7AfE4i2oQs1L0wtfM
         CGk7azY4fRnNOUSM1Dde3VItEWrAQe4+BtFMpoJVlGU9sc5toSQ2ZtbSAc37qYnqOv
         gNT75pKdJ11WddoWficrS8C8f9NTB+nl0SvqZeSAKCkWHxRMDSg9U39GmG8MJwQPWr
         bzb6veKwoVuIxss465yxqestfnd986lIB4jAoBaVAiCYBaE3B3jYpjV9/cyreUgEco
         pq2Tg7EyBU0tA==
Date:   Mon, 12 Apr 2021 08:28:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the crypto tree
Message-ID: <20210412082828.2d7ff09f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/J+96lH4tYICTK=sueM5b4q3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/J+96lH4tYICTK=sueM5b4q3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  36303413885e ("crypto: chelsio - Read rxchannel-id from firmware")

Fixes tag

  Fixes: 567be3a5d227 ("crypto: chelsio - Use multiple txq/rxq per tfm to p=
rocess the requests)

has these problem(s):

  - Subject has leading but no trailing quotes

--=20
Cheers,
Stephen Rothwell

--Sig_/J+96lH4tYICTK=sueM5b4q3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBzeAwACgkQAVBC80lX
0GxZQQf/SdbMaIksVBel+M7vfqNIaqcn0zCQrXsKtipyT2T+m3MFQtDP7ZSvThNP
yRhW6mbVlq3nvfNk1yw83po1a+oCLaoV+iYEaAm0LzK+o71yTBKSmHD0m4DMu5Et
X5t/POYQj6CX2Sxpns422sLDP3MZb2svdn/hM04ryaWA5wulxpgrMG31UzmhBXd2
HvHTZpPjXbL/mU1w/TIJAe6vIgkUhLrq1bDlVKtphBUEkWr/XfazJKfsSgMLzoRw
vtIew1xkjD7KHLdiZDTjdBo7iSUkunw7JYV4mcJoRBxLamxqUObahI/MnM3YxBBa
ANOTL/YcwGoDur89Q+/2sM9hsTG1jA==
=YmaW
-----END PGP SIGNATURE-----

--Sig_/J+96lH4tYICTK=sueM5b4q3--
