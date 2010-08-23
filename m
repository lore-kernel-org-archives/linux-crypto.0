From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Mon, 23 Aug 2010 11:37:40 -0400 (EDT)
Message-ID: <1269957386.1124701282577860651.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1278368294.1123931282577639823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55518 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751520Ab0HWPjK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Aug 2010 11:39:10 -0400
In-Reply-To: <1278368294.1123931282577639823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Kyle Moffett" <kyle@moffetthome.net> wrote:
> On Fri, Aug 20, 2010 at 04:45, Miloslav Trma=C4=8D <mitr@redhat.com>
> wrote:
> > * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the=
 key
> > =C2=A0material inside the kernel, load a plaintext key, unwrap a ke=
y, or
> > =C2=A0derive a key. =C2=A0Similarly the key material can be copied =
out of the
> > =C2=A0kernel or wrapped.
> >
> Ugh... We already have one very nice key/keyring API in the kernel
> (see Documentation/keys.txt) that's being used for crypto keys for
> NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types t=
o
> that API instead?
I have examined that API; going purely by the names, having only one fa=
cility to manage "keys" does sound reasonable.

Looking at the details, the keyring API is primarily designed for long-=
term secure storage of unstructured, named blobs, in various namespaces=
 - in some respects it is quite similar to a memory-only filesystem: ea=
ch key has an explicit name and permissions, there is a hierarchy, and =
keys are designed to be shared between processes (although in some name=
spaces they are not).

The keys for crypto are often short-lived, almost exclusively local to =
a specific process, most don't have an unique name (which means a kerne=
l-choosen integer is a better identifier than an application-choosen st=
ring, especially if user-space libraries hide the existence of the kern=
el crypto API from applications, because choosing an unique string iden=
tifier is non-trivial).  The crypto keys also are also formatted for us=
e by a specific algorithm, often using a non-trivial format (e.g. a RSA=
 key should be internally stored as the separate integer components, no=
t as a blob).  They have some attribute flags, with no overlap with the=
 flags in the keyring API.

I can see almost no overlap between the two sets of requirements.  Prob=
ably the only common use case is handling session keys (e.g. keys used =
in a kerberos ticket), which should be stored in the kernel for the dur=
ation of the session, made available to each process in the session, an=
d available as keys for kernel crypto.  Such keys will be in the minori=
ty, though, and it seems to me the best approach for handling these is =
to allow key export/import from/to keyring keys in addition to export/i=
mport from/to data in userspace: the long-term storage would be handled=
 by the existing keyring API, which stores the key as unformatted binar=
y data, and import into the crypto context would convert the key into t=
he internal representation more suitable for crypto.

I have seriously considered the keyring API, and this is what I came up=
 with - but I'd love to be shown a better way.
    Mirek
