From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Sat, 21 Aug 2010 19:08:03 +0200
Message-ID: <201008211908.03705.arnd@arndb.de>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Miloslav =?utf-8?q?Trma=C4=8D?= <mitr@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday 20 August 2010 10:45:43 Miloslav Trma=C4=8D wrote:
>=20
> Major changes since the previous post:
> * "struct nlattr"-based extensible attributes used for extensibility
>   of most operations, both for input and output attributes

The API here looks overly complex resulting from the use of a combinati=
on
of ioctl and netlink. If your interface cannot be easily expressed usin=
g
simple (no indirect pointers or variable-length fields please) ioctl
and read/write operations, why not go all the way and turn the interfac=
e
into a netlink facility?

> * Full compat_ioctl implementation

New drivers should be written to *avoid* compat_ioctl calls, using only
very simple fixed-length data structures as ioctl commands.

> * Version number added to the data format used when wrapping keys for=
 storage

Again, wrong direction. If you think you need a version number, the int=
erface
is probably not ready for inclusion yet. Make sure it is simple enough =
that
you don't run into the case where you have to make incompatible changes
that require API versioning.

>   The libtom* patches will probably still be too large for the mailin=
g list;
>   the whole patch set is also available at
>   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .

They actually seem to have made it to the list. However, the more signf=
icant
problem is the amount of code added to a security module. 20000 lines o=
f
code that is essentially a user-level library moved into kernel space
can open up so many possible holes that you end up with a less secure
(and slower) setup in the end than just doing everything in user space.
=20
> Original patch set description follows.
>=20
> These are the major differences compared to the BSD-like interface:
>=20
> * The API supports key storage and management inside the kernel.
>   An application can thus ask the kernel to generate a key; the key i=
s
>   then referenced via an integer identifier, and the application can =
be
>   prevented from accessing the raw key data.  Such a key can, if so c=
onfigured,
>   still be wrapped for key transport to the recipient of the message,=
 and
>   unwrapped by the recipient.

As Kyle mentioned, we already have a key management API in the kernel.
I think you should make a better effort of interfacing with that and
adding features you need to it, like a way to prevent the kernel from
handing out keys as you mentioned in your reply.

>   An user-space library is not separated, options are a) root
>   running daemon that does crypto, but this would be slow due to cont=
ext
>   switches, scheduler mismatching and all the IPC overhead and b) use=
 crypto
>   that is in the kernel.

I think you will have to back that statement by measurements. There are
reasonably fast ways to do IPC and the interface you suggest to put in =
the
kernel does not exactly look tuned for performance.
=20
> * FIPS-140-3 calls out for cryptographic functions to be non-debuggab=
le (ptrace)
>   meaning that you cannot get to the key material. The solution is th=
e same as
>   above.

We have kgdb, kdb, qemu gdbserver, tracing and more things that would v=
ery
much make your code debuggable.

OTOH, disabling ptrace with a root-only prctl should be an easy thing t=
o
implement if there is a use case for it.

> Other advantages to having kernel crypto available to user space:
>=20
> * User space will be able to take advantage of kernel drivers for har=
dware
>   crypto accelerators.

I can see this as a good reason to put a proper interface for asymmetri=
c
crypto into the kernel. There are PCI cards and other things that are
supported using ad-hoc interfaces right now. It would be wonderful
if someone could clean that up and create a simple common interface tha=
t
covers all the hardware variants.
But that does not justify putting a software implementation into the ke=
rnel.

=46or symmetric crypto and hashing hardware acceleration is typically
implemented as CPU instructions anyway and available to user space
already, without the need for kernel support.

> * glibc, which in some configurations links to libfreebl3.so for hash=
es
>   necessary for crypt(), will be able to use the kernel implementatio=
n; this
>   means one less library to load and dynamically link for each such p=
rocess.

If you are really worried about library load times, you can probably cr=
eate
a patch that statically links libfreebl3 into glibc.

	Arnd
