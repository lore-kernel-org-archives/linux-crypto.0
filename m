From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_hash: splice of data > 2**16
Date: Sat, 20 Dec 2014 07:37:55 +0100
Message-ID: <3364866.GGZiChayfE@tachyon.chronox.de>
References: <8707521.TbV00HIEUx@tauon> <5492C6FC.50005@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55092 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaLTGiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Dec 2014 01:38:01 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD189> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sat, 20 Dec 2014 07:37:56 +0100
In-Reply-To: <5492C6FC.50005@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:

Hi Christophe,

> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
> > Hi Herbert,
> >=20
> > While testing the vmsplice/splice interface of algif_hash I was mad=
e
> > aware of the problem that data blobs larger than 16 pages do not se=
em to
> > be hashed properly.
> >=20
> > For testing, a file is mmap()ed and handed to vmsplice / splice. If=
 the
> > file is smaller than 2**16, the interface returns the proper hash.
> > However, when the file is larger, only the first 2**16 bytes seem t=
o be
> > used.
> >=20
> > When adding printk's to hash_sendpage, I see that this function is
> > invoked exactly 16 times where the first 15 invocations have the
> > MSG_MORE flag set and the last invocation does not have MSG_MORE.
>=20
> Hi Stephan,
>=20
> I have already noticed the same issue and proposed a patch, but I nev=
er
> got any feedback and it has never been merged, allthought I pinged it=
 a
> few times.
>=20
> See https://lkml.org/lkml/2014/4/18/276

After testing, this patch does not work for me. The operation still sto=
ps=20
after 16 pages.
>=20
> Christophe


--=20
Ciao
Stephan
