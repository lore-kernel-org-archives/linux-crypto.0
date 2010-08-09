From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Mon, 9 Aug 2010 10:39:43 -0400
Message-ID: <20100809143943.GB19862@gondor.apana.org.au>
References: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40808 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0HIOjr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Aug 2010 10:39:47 -0400
Content-Disposition: inline
In-Reply-To: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 05, 2010 at 10:17:53PM +0200, Miloslav Trma=C4=8D wrote:
> Hello,
> following is a patchset providing an user-space interface to the kern=
el crypto
> API.  It is based on the older, BSD-compatible, implementation, but t=
he
> user-space interface is different.
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
>=20
>   The kernel key storage does not span system reboots, but applicatio=
ns can
>   also wrap the keys for persistent storage, receiving an encrypted b=
lob that
>   does not reveal the raw key data, but can be later loaded back into=
 the
>   kernel.
>=20
> * More algorithms and mechanisms are supported by the API, including =
public key
>   algorithms (RSA/DSA encryption and signing, D-H key derivation, key=
 wrapping).

Thanks for the patches.

Unfortunately it fails to satisfy the requirement of supporting
all our existing kernel crypto interfaces, such as AEAD, as well
as being flexible enough in adding new interfaces such as xor.

So we need to address these issues before this can be integrated
into Linux.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
