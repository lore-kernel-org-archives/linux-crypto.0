From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Mon, 23 Aug 2010 12:03:28 -0400 (EDT)
Message-ID: <623164086.1128831282579408813.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1291324238.1127211282578687312.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52522 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754380Ab0HWQE6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Aug 2010 12:04:58 -0400
In-Reply-To: <1291324238.1127211282578687312.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Arnd Bergmann" <arnd@arndb.de> wrote:

> On Friday 20 August 2010 10:45:43 Miloslav Trma=C4=8D wrote:
> >=20
> > Major changes since the previous post:
> > * "struct nlattr"-based extensible attributes used for extensibilit=
y
> >   of most operations, both for input and output attributes
>=20
> The API here looks overly complex resulting from the use of a combina=
tion
> of ioctl and netlink. If your interface cannot be easily expressed us=
ing
> simple (no indirect pointers or variable-length fields please) ioctl
> and read/write operations, why not go all the way and turn the interf=
ace
> into a netlink facility?
I'm afraid the flexibility is necessary: immediately after posting the =
first interface with fixed structures there were requests for extension=
s that would be difficult or impossible to implement using the structur=
es; crypto is not something fixed, new algorithms with algorithm-specif=
ic parameters appear all the time.  On the positive side, the implement=
ation of session_once as shorthand for session_{init,update,final} is m=
uch nicer with the netlink attributes.

Using netlink sockets is impractical: support of zero-copy encryption a=
nd auditing requires that operations are performed synchronously in the=
 task context, and the extra overhead of netlink is non-trivial (ioctl(=
) is one syscall per operation, netlink is at least two syscalls per op=
eration); based on a very crude benchmark, this results in about 20% pe=
rformance penalty when encrypting 256 bytes using cbc(aes) - and that i=
s not counting the impossibility to do zero-copy operations with netlin=
k).  Also matching netlink replies to requests can be complex in a mult=
i-threaded environments if there is one /dev/crypto file descriptor per=
 process.

> >   The libtom* patches will probably still be too large for the mail=
ing list;
> >   the whole patch set is also available at
> >   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .
>=20
> They actually seem to have made it to the list. However, the more sig=
nficant
> problem is the amount of code added to a security module. 20000 lines=
 of
> code that is essentially a user-level library moved into kernel space
> can open up so many possible holes that you end up with a less secure
> (and slower) setup in the end than just doing everything in user
> space.
Yes, it's a lot of code.   I'm afraid some of the security profiles req=
uire public key algorithms, giving some Linux users no choice in the ma=
tter.

On the other hand, the user-space crypto API is not inherently tied to =
the existence of these algorithms; if the public key algorithms were co=
mpletely unacceptable for some reason, that should still make it possib=
le to add the crypto API as such.

> >   An user-space library is not separated, options are a) root
> >   running daemon that does crypto, but this would be slow due to co=
ntext
> >   switches, scheduler mismatching and all the IPC overhead and b) u=
se crypto
> >   that is in the kernel.
>=20
> I think you will have to back that statement by measurements. There a=
re
> reasonably fast ways to do IPC and the interface you suggest to put i=
n the
> kernel does not exactly look tuned for performance.
See above for the effect of a single additional syscall.  Crypto is oft=
en done on small amounts of data at a time (one TLS/SSH record, which c=
an be thousands of bytes in favorable cases, tens of bytes in the worst=
 case), and each context switch is comparatively costly.

> > * FIPS-140-3 calls out for cryptographic functions to be non-debugg=
able (ptrace)
> >   meaning that you cannot get to the key material. The solution is =
the same as
> >   above.
>=20
> We have kgdb, kdb, qemu gdbserver, tracing and more things that would=
 very
> much make your code debuggable.
The system administrator is usually considered to be excluded from the =
requirements of such standards.
    Mirek
