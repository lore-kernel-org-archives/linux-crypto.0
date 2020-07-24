Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99C9C433E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 03:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79A920786
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 03:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Gx0y6LVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGXDJz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 23:09:55 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58623 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgGXDJz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 23:09:55 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BCZ1r06q6z9sR4;
        Fri, 24 Jul 2020 13:09:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595560192;
        bh=JMyV1D9kt2gAi4H5USAM4UKG8u63RFAYH2U6HpUh4Mg=;
        h=Date:From:To:Cc:Subject:From;
        b=Gx0y6LVtETGyjCBJcV5q1yxh+iieSqatCVmmFV+ILXQvZmSsQppUBEmop1NenZTVT
         IWrtqNP0nTTFb5l4rjSmsDvMzDXLdjcJu3KVucASOm5ImanRDoFtnUuk3l5hky0VxA
         qYZDGowCun2FnE/hhavCmhGjMj1EqGkCEtFblDh84cox4aoKz5jEGYTNJphD7dcAd5
         eDX32HKIy6DLAy31uL9J4YrJjVi4PVGdhm1TM/VKwrg/PMPlHtdge8KLvmpnkPjl+g
         ug1Q9+o0KlgIvlBqv+9/Q3dgu2g44iF0RnLyS3gk/dg19UFJ+HjbWDdv4SIiXwkkRb
         q4fN7UGV7SHXw==
Date:   Fri, 24 Jul 2020 13:09:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: linux-next: manual merge of the crypto tree with the jc_docs tree
Message-ID: <20200724130951.5b99a9c9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VIJwA+efFIsvhi_Eq.TH6uZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/VIJwA+efFIsvhi_Eq.TH6uZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got a conflict in:

  Documentation/crypto/api-intro.rst

between commit:

  5846551bb147 ("docs: crypto: convert api-intro.txt to ReST format")

from the jc_docs tree and commit:

  9332a9e73918 ("crypto: Replace HTTP links with HTTPS ones")

from the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/crypto/api-intro.rst
index bcff47d42189,40137f93e04f..000000000000
--- a/Documentation/crypto/api-intro.rst
+++ b/Documentation/crypto/api-intro.rst
@@@ -159,31 -146,31 +159,31 @@@ Credit
  The following people provided invaluable feedback during the development
  of the API:
 =20
 -  Alexey Kuznetzov
 -  Rusty Russell
 -  Herbert Valerio Riedel
 -  Jeff Garzik
 -  Michael Richardson
 -  Andrew Morton
 -  Ingo Oeser
 -  Christoph Hellwig
 +  - Alexey Kuznetzov
 +  - Rusty Russell
 +  - Herbert Valerio Riedel
 +  - Jeff Garzik
 +  - Michael Richardson
 +  - Andrew Morton
 +  - Ingo Oeser
 +  - Christoph Hellwig
 =20
  Portions of this API were derived from the following projects:
 - =20
 +
    Kerneli Cryptoapi (http://www.kerneli.org/)
 -    Alexander Kjeldaas
 -    Herbert Valerio Riedel
 -    Kyle McMartin
 -    Jean-Luc Cooke
 -    David Bryson
 -    Clemens Fruhwirth
 -    Tobias Ringstrom
 -    Harald Welte
 +   - Alexander Kjeldaas
 +   - Herbert Valerio Riedel
 +   - Kyle McMartin
 +   - Jean-Luc Cooke
 +   - David Bryson
 +   - Clemens Fruhwirth
 +   - Tobias Ringstrom
 +   - Harald Welte
 =20
  and;
 - =20
 +
-   Nettle (http://www.lysator.liu.se/~nisse/nettle/)
+   Nettle (https://www.lysator.liu.se/~nisse/nettle/)
 -    Niels M=C3=B6ller
 +   - Niels M=C3=B6ller
 =20
  Original developers of the crypto algorithms:
 =20

--Sig_/VIJwA+efFIsvhi_Eq.TH6uZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8aUP8ACgkQAVBC80lX
0GwK6gf5ASvaTROcfQXXob7S7o5gNJ/nm1LtCXWpaAopVPAklGB8dQfd78C5uvgd
bWIBve/aLsfpj7826voSRZTUBfA84SSuoRDpDZT5kxSuXdiRjDsCMMklXxWipSvw
4XVfSY8m1RxVx7RZPzKvFyqr9TlvTH6BDDlkwycp0/AZR14IEMaA2nabpWftMfSv
rfdUIATa3hMCpyp+9lMmvfODkqb8lSqIfSR5WByh2ek13Fcfoh12VOd7FhPAc5K2
O0aIZO0ZPWotv876+CTtELgt8wTTfB4Y7ipuVHYimQ8m2kvUtQwTen9X+5ZfHOz/
YYNMFSNR3yjGZ5H2PYhG3N0g9GpNSg==
=41P1
-----END PGP SIGNATURE-----

--Sig_/VIJwA+efFIsvhi_Eq.TH6uZ--
