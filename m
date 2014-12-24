From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_hash: splice of data > 2**16
Date: Wed, 24 Dec 2014 10:03:13 +0100
Message-ID: <11733044.fQnf94a6to@tachyon.chronox.de>
References: <8707521.TbV00HIEUx@tauon> <3364866.GGZiChayfE@tachyon.chronox.de> <5499A351.2010300@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51025 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaLXJDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Dec 2014 04:03:16 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD827> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Wed, 24 Dec 2014 10:03:13 +0100
In-Reply-To: <5499A351.2010300@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Dezember 2014, 18:16:01 schrieb leroy christophe:

Hi leroy,

> Le 20/12/2014 07:37, Stephan Mueller a =E9crit :
> > Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe=
:
> >=20
> > Hi Christophe,
> >=20
> >> Le 18/12/2014 13:15, Stephan Mueller a =E9crit :
> >>> Hi Herbert,
> >>>=20
> >>> While testing the vmsplice/splice interface of algif_hash I was m=
ade
> >>> aware of the problem that data blobs larger than 16 pages do not =
seem to
> >>> be hashed properly.
> >>>=20
> >>> For testing, a file is mmap()ed and handed to vmsplice / splice. =
If the
> >>> file is smaller than 2**16, the interface returns the proper hash=
=2E
> >>> However, when the file is larger, only the first 2**16 bytes seem=
 to be
> >>> used.
> >>>=20
> >>> When adding printk's to hash_sendpage, I see that this function i=
s
> >>> invoked exactly 16 times where the first 15 invocations have the
> >>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
> >>=20
> >> Hi Stephan,
> >>=20
> >> I have already noticed the same issue and proposed a patch, but I =
never
> >> got any feedback and it has never been merged, allthought I pinged=
 it a
> >> few times.
> >>=20
> >> See https://lkml.org/lkml/2014/4/18/276
> >=20
> > After testing, this patch does not work for me. The operation still=
 stops
> > after 16 pages.
>=20
> Yes, it looks like the function I fixed is exclusively used by
> sendfile() system call.
> So there is probably the same kind of fix to be done in another funct=
ion.

I do not believe that is the case. IMHO the blocking issue is found in =
the=20
following code:

splice_from_pipe_feed walks the pipe->nrbufs. And vmsplice_to_pipe defi=
nes the=20
maximum number of nrbufs as PIPE_DEF_BUFFERS -- which is 16. As subsequ=
ent=20
functions allocate memory based on PIPE_DEF_BUFFERS, there is no trivia=
l way=20
to increase the number of pages to be processed.

Thus I see that the vmsplice/splice combo can at most operate on a chun=
k of 16=20
pages. Thus, you have to segment your input buffer into chunks of that =
size=20
and invoke the vmsplice/splice syscalls for each segment.

--=20
Ciao
Stephan
