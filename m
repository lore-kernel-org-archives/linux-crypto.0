From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Mon, 02 Feb 2009 18:01:07 +0000
Message-ID: <1233597667.1536.10.camel@localhost.localdomain>
References: <20090118225517.GA30510@gondor.apana.org.au>
	 <20090128035615.GA13051@gondor.apana.org.au>
	 <1233577246.18006.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Martin Schwidefksy <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:36417 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbZBBRA5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Feb 2009 12:00:57 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id n12H0ux9001585
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 17:00:56 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n12H0thN4169850
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 18:00:55 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n12H0sZc012639
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2009 18:00:55 +0100
In-Reply-To: <1233577246.18006.1.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2009-02-02 at 13:20 +0100, Martin Schwidefsky wrote:
> On Wed, 2009-01-28 at 14:56 +1100, Herbert Xu wrote:
> > On Mon, Jan 19, 2009 at 09:55:17AM +1100, Herbert Xu wrote:
> > >=20
> > > Could you let me if this patch breaks s390?
> > >=20
> > > commit 0fe7dddf02811152d7e58747bfe419ec0f43ea4e
> > > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > > Date:   Sun Jan 18 20:33:33 2009 +1100
> > >=20
> > >     crypto: sha-s390 - Switch to shash
> > >    =20
> > >     This patch converts the S390 sha algorithms to the new shash =
interface.
> > >    =20
> > >     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >=20
> > I'm going to throw this into cryptodev and if it breaks, please
> > yell.
>=20
> Just back from my vacation. Jan will check if the patch breaks anythi=
ng,
> we'll complain if it does..
>=20

The patch is not yet in cryptodev, so I applied it on top of cryptodev.
Compiling it gives me the following error:

 CC [M]  arch/s390/crypto/sha256_s390.o
arch/s390/crypto/sha_common.c: In function =A1s390_sha_update=A2:
arch/s390/crypto/sha_common.c:23: error: implicit declaration of functi=
on =A1crypto_shash_blocksize=A2
make[1]: *** [arch/s390/crypto/sha_common.o] Error 1

--jan


--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
