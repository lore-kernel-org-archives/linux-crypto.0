From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Sat, 21 Aug 2010 09:09:58 -0400
Message-ID: <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>
To: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 20, 2010 at 04:45, Miloslav Trma=C4=8D <mitr@redhat.com> wr=
ote:
> This patch introduces the new user-space API, <ncr.h>.
>
> Quick overview:
>
> * open("/dev/crypto") to get a FD, which acts as a namespace for key =
and
> =C2=A0session identifiers.
>
> * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the k=
ey
> =C2=A0material inside the kernel, load a plaintext key, unwrap a key,=
 or
> =C2=A0derive a key. =C2=A0Similarly the key material can be copied ou=
t of the
> =C2=A0kernel or wrapped.
>
> [...snip...]

Ugh... We already have one very nice key/keyring API in the kernel
(see Documentation/keys.txt) that's being used for crypto keys for
NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types to
that API instead?

David Howells added to CC, since I believe he wrote most of that code i=
nitially.

Cheers,
Kyle Moffett
