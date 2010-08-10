From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 08:46:28 -0400
Message-ID: <20100810124628.GA3072@hmsreliant.think-freely.org>
References: <20100809143943.GB19862@gondor.apana.org.au>
 <1976107781.89151281398455116.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40725 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab0HJMul (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 08:50:41 -0400
Content-Disposition: inline
In-Reply-To: <1976107781.89151281398455116.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 09, 2010 at 08:00:55PM -0400, Miloslav Trmac wrote:
> ----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:
>=20
> > On Thu, Aug 05, 2010 at 10:17:53PM +0200, Miloslav Trma=C4=8D wrote=
:
> > > Hello,
> > > following is a patchset providing an user-space interface to the =
kernel crypto
> > > API.  It is based on the older, BSD-compatible, implementation, b=
ut the
> > > user-space interface is different.
> >=20
> > Thanks for the patches.
> >=20
> > Unfortunately it fails to satisfy the requirement of supporting
> > all our existing kernel crypto interfaces, such as AEAD, as well
> > as being flexible enough in adding new interfaces such as xor.
> Thanks for the review.
>=20
> I think I can add AEAD (and compression/RNG, if requested) easily eno=
ugh, I'll send an updated patch set.
>=20
> (Talking specifically about xor, xor does not seem to be cryptographi=
c operation that should be exposed as such to userspace - and AFAICS it=
 is not integrated in the crypto API algorithm mechanism in the kernel =
either.)
>=20
> Is the proposed interface acceptable in the general approach (enums f=
or algorithms/operations, unions for parameters, session init/update/fi=
nalize)?  With respect to flexibility, do you have specific suggestions=
 or areas of concern?

I know we spoke about this previously, but since you're asking publical=
ly, I'll
make my argument here so that we can have the debate in public as well.=
  I'm ok
wih the general enumeration of operations in user space (I honestly can=
't see
how you would do it otherwise).  What worries me though is the use ioct=
l for
these operations  and the flexibility that it denies you in future upda=
tes.

Specifically, my concerns are twofold:

1) struct format.  By passing down a structure as your doing through an=
 ioctl
call, theres  no way to extend/modify that structure easily for future =
use.  For
instance the integration of aead might I think requires a blocking fact=
or to be
sepcified, and entry for which you have no available field in your cryp=
t_ops
structure.  If you extend the structure in a later release of this code=
, you
create a potential incompatibility with user space because you are no l=
onger
guaranteed that the size of the crypt_op structure is the same, and you=
 need to
be prepared for a range of sizes to get passed down, at which point it =
becomes
difficult to differentiate between older code thats properly formatted,=
 and
newer code thats legitimately broken.  You might could add a version fi=
eld to
mitigate that, but it gets ugly pretty quickly.

2) Use of pointers.  Thats just a pain.  You have the compat ioctl stuf=
f in
place to handle the 32/64 bit conversions, but it would be really nice =
if you
could avoid having to maintain that extra code path.

Thats why I had suggested the use of a netlink protocol to manage this =
kind of
interface.  There are other issue to manage there, but they're really n=
ot that
big a deal, comparatively speaking, and that interface allows for the e=
asy
specification of arbitrary length data in a fashion that doesn't cause =
user
space breakage when additional algorithms/apis are added.

Thats just my opinion, I'm sure others have differing views.  I'd be in=
terested
to hear what others think.

Regards
Neil

>=20
