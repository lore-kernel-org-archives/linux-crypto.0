From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_hash: splice of data > 2**16
Date: Wed, 24 Dec 2014 16:12:53 +0100
Message-ID: <1444883.Oc8SnflNUU@tachyon.chronox.de>
References: <8707521.TbV00HIEUx@tauon> <11733044.fQnf94a6to@tachyon.chronox.de> <549AC946.2000909@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51030 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaLXPM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Dec 2014 10:12:59 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD897> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Wed, 24 Dec 2014 16:12:54 +0100
In-Reply-To: <549AC946.2000909@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 24. Dezember 2014, 15:10:14 schrieb leroy christophe:

Hi leroy,

> Le 24/12/2014 10:03, Stephan Mueller a =E9crit :
> > Am Dienstag, 23. Dezember 2014, 18:16:01 schrieb leroy christophe:
> >=20
> > Hi leroy,
> >=20
> >> Le 20/12/2014 07:37, Stephan Mueller a =E9crit :
> >>> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christop=
he:
> >>>=20
> >>> Hi Christophe,
> >>>=20
> >>>> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
> >>>>> Hi Herbert,
> >>>>>=20
> >>>>> While testing the vmsplice/splice interface of algif_hash I was=
 made
> >>>>> aware of the problem that data blobs larger than 16 pages do no=
t seem
> >>>>> to
> >>>>> be hashed properly.
> >>>>>=20
> >>>>> For testing, a file is mmap()ed and handed to vmsplice / splice=
=2E If
> >>>>> the
> >>>>> file is smaller than 2**16, the interface returns the proper ha=
sh.
> >>>>> However, when the file is larger, only the first 2**16 bytes se=
em to
> >>>>> be
> >>>>> used.
> >>>>>=20
> >>>>> When adding printk's to hash_sendpage, I see that this function=
 is
> >>>>> invoked exactly 16 times where the first 15 invocations have th=
e
> >>>>> MSG_MORE flag set and the last invocation does not have MSG_MOR=
E.
> >>>>=20
> >>>> Hi Stephan,
> >>>>=20
> >>>> I have already noticed the same issue and proposed a patch, but =
I never
> >>>> got any feedback and it has never been merged, allthought I ping=
ed it a
> >>>> few times.
> >>>>=20
> >>>> See https://lkml.org/lkml/2014/4/18/276
> >>>=20
> >>> After testing, this patch does not work for me. The operation sti=
ll
> >>> stops
> >>> after 16 pages.
> >>=20
> >> Yes, it looks like the function I fixed is exclusively used by
> >> sendfile() system call.
> >> So there is probably the same kind of fix to be done in another fu=
nction.
> >=20
> > I do not believe that is the case. IMHO the blocking issue is found=
 in the
> > following code:
> >=20
> > splice_from_pipe_feed walks the pipe->nrbufs. And vmsplice_to_pipe =
defines
> > the maximum number of nrbufs as PIPE_DEF_BUFFERS -- which is 16. As
> > subsequent functions allocate memory based on PIPE_DEF_BUFFERS, the=
re is
> > no trivial way to increase the number of pages to be processed.
> >=20
> > Thus I see that the vmsplice/splice combo can at most operate on a =
chunk
> > of 16 pages. Thus, you have to segment your input buffer into chunk=
s of
> > that size and invoke the vmsplice/splice syscalls for each segment.
>=20
> Yes your are probably right. There splice needs to be called with
> SPLICE_F_MORE flag, hope that works.

That is not the only one. Vmsplice works on a pipe. A pipe is backed by=
 16=20
pages max. Thus, you have to call vmsplice once per 16 pages. The curre=
nt code=20
I am testing which seems to work is the following:

	while (inlen) {
		size_t datalen =3D (inlen > MAXLEN) ? MAXLEN : inlen;

		iov.iov_len =3D datalen;
		ret =3D _kcapi_common_vmsplice_data(handle, &iov, 1, datalen,=20
1);
		if (0 > ret)
			return ret;
		processed +=3D ret;
		iov.iov_base =3D (void*)(uintptr_t)(in + processed);
		inlen -=3D ret;
	}
	return _kcapi_common_read_data(handle, out, outlen);


--=20
Ciao
Stephan
