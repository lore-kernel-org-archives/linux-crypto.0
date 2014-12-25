From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_hash: splice of data > 2**16
Date: Thu, 25 Dec 2014 23:08:41 +0100
Message-ID: <3336170.jqoOL9TV9j@tachyon.chronox.de>
References: <8707521.TbV00HIEUx@tauon> <549AC946.2000909@c-s.fr> <1444883.Oc8SnflNUU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51079 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaLYWIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Dec 2014 17:08:46 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD9A0> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 25 Dec 2014 23:08:42 +0100
In-Reply-To: <1444883.Oc8SnflNUU@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 24. Dezember 2014, 16:12:53 schrieb Stephan Mueller:

Hi Christophe,

> Am Mittwoch, 24. Dezember 2014, 15:10:14 schrieb leroy christophe:
>=20
> Hi leroy,
>=20
> > Le 24/12/2014 10:03, Stephan Mueller a =E9crit :
> > > Am Dienstag, 23. Dezember 2014, 18:16:01 schrieb leroy christophe=
:
> > >=20
> > > Hi leroy,
> > >=20
> > >> Le 20/12/2014 07:37, Stephan Mueller a =E9crit :
> > >>> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christ=
ophe:
> > >>>=20
> > >>> Hi Christophe,
> > >>>=20
> > >>>> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
> > >>>>> Hi Herbert,
> > >>>>>=20
> > >>>>> While testing the vmsplice/splice interface of algif_hash I w=
as made
> > >>>>> aware of the problem that data blobs larger than 16 pages do =
not
> > >>>>> seem
> > >>>>> to
> > >>>>> be hashed properly.
> > >>>>>=20
> > >>>>> For testing, a file is mmap()ed and handed to vmsplice / spli=
ce. If
> > >>>>> the
> > >>>>> file is smaller than 2**16, the interface returns the proper =
hash.
> > >>>>> However, when the file is larger, only the first 2**16 bytes =
seem to
> > >>>>> be
> > >>>>> used.
> > >>>>>=20
> > >>>>> When adding printk's to hash_sendpage, I see that this functi=
on is
> > >>>>> invoked exactly 16 times where the first 15 invocations have =
the
> > >>>>> MSG_MORE flag set and the last invocation does not have MSG_M=
ORE.
> > >>>>=20
> > >>>> Hi Stephan,
> > >>>>=20
> > >>>> I have already noticed the same issue and proposed a patch, bu=
t I
> > >>>> never
> > >>>> got any feedback and it has never been merged, allthought I pi=
nged it
> > >>>> a
> > >>>> few times.
> > >>>>=20
> > >>>> See https://lkml.org/lkml/2014/4/18/276
> > >>>=20
> > >>> After testing, this patch does not work for me. The operation s=
till
> > >>> stops
> > >>> after 16 pages.
> > >>=20
> > >> Yes, it looks like the function I fixed is exclusively used by
> > >> sendfile() system call.
> > >> So there is probably the same kind of fix to be done in another
> > >> function.
> > >=20
> > > I do not believe that is the case. IMHO the blocking issue is fou=
nd in
> > > the
> > > following code:
> > >=20
> > > splice_from_pipe_feed walks the pipe->nrbufs. And vmsplice_to_pip=
e
> > > defines
> > > the maximum number of nrbufs as PIPE_DEF_BUFFERS -- which is 16. =
As
> > > subsequent functions allocate memory based on PIPE_DEF_BUFFERS, t=
here is
> > > no trivial way to increase the number of pages to be processed.
> > >=20
> > > Thus I see that the vmsplice/splice combo can at most operate on =
a chunk
> > > of 16 pages. Thus, you have to segment your input buffer into chu=
nks of
> > > that size and invoke the vmsplice/splice syscalls for each segmen=
t.
> >=20
> > Yes your are probably right. There splice needs to be called with
> > SPLICE_F_MORE flag, hope that works.
>=20
> That is not the only one. Vmsplice works on a pipe. A pipe is backed =
by 16
> pages max. Thus, you have to call vmsplice once per 16 pages. The cur=
rent
> code I am testing which seems to work is the following:
>=20
> 	while (inlen) {
> 		size_t datalen =3D (inlen > MAXLEN) ? MAXLEN : inlen;
>=20
> 		iov.iov_len =3D datalen;
> 		ret =3D _kcapi_common_vmsplice_data(handle, &iov, 1, datalen,
> 1);
> 		if (0 > ret)
> 			return ret;
> 		processed +=3D ret;
> 		iov.iov_base =3D (void*)(uintptr_t)(in + processed);
> 		inlen -=3D ret;
> 	}
> 	return _kcapi_common_read_data(handle, out, outlen);

As I do not see an easy fix where a single vmsplice/splice syscall comb=
o can=20
be applied to an input data stream of arbitrary length, I added appropr=
iate=20
handling code in libkcapi version 0.6.2 [1].

This code follows the aforementioned approach to segment the input into=
 16=20
PAGE_SIZE segments and send them to the kernel individually.

[1] http://www.chronox.de/libkcapi.html
--=20
Ciao
Stephan
