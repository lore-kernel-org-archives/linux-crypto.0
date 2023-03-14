Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B56C6FD1F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 03:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCNDTy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Mar 2023 23:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNDTv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2023 23:19:51 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAADA65C4F;
        Mon, 13 Mar 2023 20:19:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PbJfq6XyGz4x1d;
        Tue, 14 Mar 2023 14:19:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678763988;
        bh=A42uzgmqy6kdHFRu9vEVBB0TC3eb2uJkHBMlhnDQMZk=;
        h=Date:From:To:Cc:Subject:From;
        b=QRoEQlgP+DDOtFnWQQ865M7Yh/rS2nGS7ALvO2KwyPmxXX+gKk7UZysdGpFyoEL/X
         5X0dKtCqsq3kvj0On+Ga/rnmT0UsnCoGy3aRuV3SZ7RJ8hICaa3Z5WMlFstRqMIgNZ
         /K5JnBNF8w4NmAuZM9idDr6ri6lBTfqgvAv5b8+WY9Kq3Ky0J2UwRcmuZi1eOVOFIL
         vPdDf4n8L03w+KoFCsQyJnTfaTVUTSfWA40Vpwujp3janbtYim0mmattOYsTRNKGF4
         Xz2h0E9vX6W1mSp2L929dJf36r8++hKUHkEvmBDsaX2vNmJ4gNXYupU1plUfEqY8m1
         MnDlfO67+8HQg==
Date:   Tue, 14 Mar 2023 14:19:47 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the crypto tree
Message-ID: <20230314141947.18574ae8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Wd6y3Eb3fJm.eyoHW7xA6Io";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/Wd6y3Eb3fJm.eyoHW7xA6Io
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the crypto tree, today's linux-next build (htmldocs)
produced these warnings:

include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:245: warning: Function parameter or member 'HASH_ALG_=
COMMON' not described in 'shash_alg'
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!
include/crypto/hash.h:69: error: Cannot parse struct or union!

Introduced by commit

  0e4e6d7094df ("crypto: hash - Count error stats differently")

--=20
Cheers,
Stephen Rothwell

--Sig_/Wd6y3Eb3fJm.eyoHW7xA6Io
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQP59MACgkQAVBC80lX
0GxFdwf9EiO9SQzRixlV3sRNrWyTgA5kpucZSlgavTDesdpsGlJnZ79TZYyV33yJ
kwH0ufWVjOAKK9e4ibyf73TeNLQmv9iGZdvAl6Ptk/XtCH02jnQXBnRhX7ADVSEu
/XOjQNXGITXEYrTcgMkwRjKK4P9cZSHbaFXkwDtVRoxJjHKzA9j//7ZUPFHDx4gl
FZIAc2bsW3MFop8gXRnKPdZYlgwKLxlz8tSay+i1s8bnfyz3VkG6I7wJI9gzmRna
7vuYuCQWEc8IiJ/WdUPXOV40pFN3tzcIKQqEof3nTIJnXHe5bb41dewqEDRganLy
4fmFkj8LPz0yUR4D1ZE+ViPqolk1rA==
=zMRe
-----END PGP SIGNATURE-----

--Sig_/Wd6y3Eb3fJm.eyoHW7xA6Io--
