Return-Path: <SRS0=iGjW=WT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3595C3A5A3
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 03:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9070C2341D
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 03:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="G4FkLh8q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbfHWDOo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 23:14:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51215 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfHWDOo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 23:14:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46F62V4Rc9z9s7T;
        Fri, 23 Aug 2019 13:14:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1566530082;
        bh=93bLYnpZyMz5ZmWW64meRlCsaIjlWV1lvPWKGI7p/44=;
        h=Date:From:To:Cc:Subject:From;
        b=G4FkLh8qL60Kw4JYoUZ/tZrkDiW6bNv/knJmIvtWSNrMYLRbz1xxP+pQVOL9kOfLS
         LQte59vbTOBaKygSq69fP8LZQfQNaqDivBWJR7tk5eVaH7ChpoReLpPCRchkOGjrwg
         XvI5/igQ4+4uqmtrIwMZTDQpUvwNvKs7UgamzffAcuSe0SYBo9cx/ZrOHpt/3UtNVH
         y22/DQiHmCrTRqdsfyfmAMcPaVYOMvvOidKjkf/UYcRiK7h9zC1Ix2NKypy7Mveuf8
         iR0nqNWJCE0MkiXmXaBrkW8tOaLPRVH/ddT5/Lt9NyTXU+pDUs0HnCkEcf6Ng+Lqh8
         TXZEfmnI9QZCw==
Date:   Fri, 23 Aug 2019 13:14:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: linux-next: build warning after merge of the crypto tree
Message-ID: <20190823131442.5a84a475@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5ka7wD7hXFjk=rXgpMfsMku";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/5ka7wD7hXFjk=rXgpMfsMku
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the crypto tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

WARNING: modpost: missing MODULE_LICENSE() in lib/crypto/libsha256.o
see include/linux/module.h for more information

Presumably introduced by commit

  01d3aee86625 ("crypto: sha256 - Make lib/crypto/sha256.c suitable for gen=
eric use")

--=20
Cheers,
Stephen Rothwell

--Sig_/5ka7wD7hXFjk=rXgpMfsMku
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1fWiIACgkQAVBC80lX
0Gz9IQf/eT4VElDbE8oPsaW/auaD7FEJLiEgDaogwaPctm708jwxkfYqvICbz5XB
Ui8kF8BTwMU0PBxFHccMby4u9YFz4X5vXh9i+0wB8OUZzLVi8sYoeRw7lZ4BcH/b
faW2EYcnxxQEa63HxCCUH84V1NK056i1LcazGln+OrlPi/naCvpCgyYKe2LJMhcx
v7HolyrlX9wuQKJAEONiu05fzEip6GeOOuQjCTD5A5cM/H1+edDIo0k2Wv0DRF2r
/qtzTgomYVeLTV5+L6/AbyNxycrfIYq2t3nowAthFKpIF2wEPn08uH23MRbQa+kj
sE2IkLkBQD5X+JjMo6TklC4ld6uGhg==
=zntQ
-----END PGP SIGNATURE-----

--Sig_/5ka7wD7hXFjk=rXgpMfsMku--
