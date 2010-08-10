From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Mon, 9 Aug 2010 20:00:55 -0400 (EDT)
Message-ID: <1976107781.89151281398455116.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100809143943.GB19862@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54918 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757275Ab0HJABC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Aug 2010 20:01:02 -0400
In-Reply-To: <20100809143943.GB19862@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:

> On Thu, Aug 05, 2010 at 10:17:53PM +0200, Miloslav Trma=C4=8D wrote:
> > Hello,
> > following is a patchset providing an user-space interface to the ke=
rnel crypto
> > API.  It is based on the older, BSD-compatible, implementation, but=
 the
> > user-space interface is different.
>=20
> Thanks for the patches.
>=20
> Unfortunately it fails to satisfy the requirement of supporting
> all our existing kernel crypto interfaces, such as AEAD, as well
> as being flexible enough in adding new interfaces such as xor.
Thanks for the review.

I think I can add AEAD (and compression/RNG, if requested) easily enoug=
h, I'll send an updated patch set.

(Talking specifically about xor, xor does not seem to be cryptographic =
operation that should be exposed as such to userspace - and AFAICS it i=
s not integrated in the crypto API algorithm mechanism in the kernel ei=
ther.)

Is the proposed interface acceptable in the general approach (enums for=
 algorithms/operations, unions for parameters, session init/update/fina=
lize)?  With respect to flexibility, do you have specific suggestions o=
r areas of concern?
    Mirek
