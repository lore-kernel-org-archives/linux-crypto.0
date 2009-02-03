From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Tue, 03 Feb 2009 15:16:22 +0000
Message-ID: <1233674182.1536.28.camel@localhost.localdomain>
References: <20090118225517.GA30510@gondor.apana.org.au>
	 <20090128035615.GA13051@gondor.apana.org.au>
	 <1233577246.18006.1.camel@localhost>
	 <1233597667.1536.10.camel@localhost.localdomain>
	 <20090203014806.GA32506@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Martin Schwidefksy <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42398 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZBCOQI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2009 09:16:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id n13EG89r237770
	for <linux-crypto@vger.kernel.org>; Tue, 3 Feb 2009 14:16:08 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n13EG7R63858496
	for <linux-crypto@vger.kernel.org>; Tue, 3 Feb 2009 15:16:07 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n13EG6KL008585
	for <linux-crypto@vger.kernel.org>; Tue, 3 Feb 2009 15:16:06 +0100
In-Reply-To: <20090203014806.GA32506@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2009-02-03 at 12:48 +1100, Herbert Xu wrote:
> On Mon, Feb 02, 2009 at 06:01:07PM +0000, Jan Glauber wrote:
> >
> > The patch is not yet in cryptodev, so I applied it on top of crypto=
dev.
> > Compiling it gives me the following error:
> >=20
> >  CC [M]  arch/s390/crypto/sha256_s390.o
> > arch/s390/crypto/sha_common.c: In function =A1s390_sha_update=A2:
> > arch/s390/crypto/sha_common.c:23: error: implicit declaration of fu=
nction =A1crypto_shash_blocksize=A2
> > make[1]: *** [arch/s390/crypto/sha_common.o] Error 1
>=20
> Thanks for testing! It turns out that this was the first in-tree
> user for crypto_shash_blocksize so I'll need to add it.


With this little typo-patch shash works fine on s390.

Cheers, Jan

--- ./arch/s390/crypto/sha256_s390.c.shash	2009-02-03 13:43:47.00000000=
0
+0100
+++ ./arch/s390/crypto/sha256_s390.c	2009-02-03 13:43:53.000000000 +010=
0
@@ -26,7 +26,7 @@
=20
 static int sha256_init(struct shash_desc *desc)
 {
-	struct s390_sha_ctx *sctx =3D shash_desc_ctx(tfm);
+	struct s390_sha_ctx *sctx =3D shash_desc_ctx(desc);
=20
 	sctx->state[0] =3D SHA256_H0;
 	sctx->state[1] =3D SHA256_H1;


--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
