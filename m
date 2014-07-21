From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 0/9] crypto: caam - Add RTA descriptor creation library
Date: Mon, 21 Jul 2014 10:08:22 -0500
Message-ID: <20140721100822.07e26d08b627b42b9593d3b8@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
	<20140718171339.fe181f6425daa57bc179ef81@freescale.com>
	<53C9B302.9000403@freescale.com>
	<20140718202326.75cfb9a11f3969ee3353135d@freescale.com>
	<53CCC5A5.1070004@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	"Ruchika Gupta" <ruchika.gupta@freescale.com>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:23184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932489AbaGUPNv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jul 2014 11:13:51 -0400
In-Reply-To: <53CCC5A5.1070004@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 21 Jul 2014 10:47:49 +0300
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 7/19/2014 4:23 AM, Kim Phillips wrote:
> > On Sat, 19 Jul 2014 02:51:30 +0300
> > Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:
> >
> >> On 7/19/2014 1:13 AM, Kim Phillips wrote:
> >>> On Fri, 18 Jul 2014 19:37:17 +0300
> >>> Horia Geanta <horia.geanta@freescale.com> wrote:
> >>>
> >>>> This patch set adds Run Time Assembler (RTA) SEC descriptor libr=
ary.
> >>>>
> >>> which can only mean it's slower and more susceptible to bugs - an=
d
> >>> AFAICT for no superior technical advantage:  NACK from me.
> >>
> >> The fact that the code size is bigger doesn't necessarily mean a b=
ad thing:
> >> 1-code is better documented - cloc reports ~ 1000 more lines of
> >> comments; patch 09 even adds support for generating a docbook
> >> 2-pure code (i.e. no comments, white spaces) - cloc reports ~ 5000=
 more
> >> lines; this reflects two things, AFAICT:
> >> 2.1-more features: options (for e.g. new SEC instructions, little =
endian
> >> env. support), platform support includes Era 7 and Era 8, i.e.
> >> Layerscape LS1 and LS2; this is important to note, since plans are=
 to
> >> run the very same CAAM driver on ARM platforms
> >
> > um, *those* features should not cost any driver *that many* lines o=
f
> > code!
>=20
> You are invited to comment on the code at hand. I am pretty sure it's
> not perfect.

I can see RTA is responsible for the code size increase, not the
features.  And just because RTA has - or has plans for - those
features don't justify the kernel driver adopting RTA over
inline-append.

> >> 2.2-more error-checking - from this perspective, I'd say driver is=
 less
> >> susceptible to bugs, especially subtle ones in CAAM descriptors th=
at are
> >> hard to identify / debug; RTA will complain when generating descri=
ptors
> >> using features (say a new bit in an instruction opcode) that are n=
ot
> >> supported on the SEC on device
> >
> > ?  The hardware does the error checking.  This just tells me RTA is
> > slow, inflexible, and requires unnecessary maintenance by design:
> > all the more reason to keep it out of the kernel :)
>=20
> This is just like saying a toolchain isn't performing any checks and
> lets the user generate invalid machine code and deal with HW errors.
>=20
> Beside this, there are (quite a few) cases when SEC won't emit any
> error, but still the results are different than expected.
> SEC HW is complex enough to deserve descriptor error checking.

if part of RTA's objective is to cater to new SEC programmers, great,
but that doesn't mean it belongs in the crypto API driver's limited
input parameter set, and fixed descriptors operating environment:
it's not the place to host an entire SEC toolchain.

> >> RTA currently runs on:
> >> -QorIQ platforms - userspace (USDPAA)
> >> -Layerscape platforms - AIOP accelerator
> >> (obviously, plans are to run also on QorIQ/PowerPC and LS/ARM kern=
els)
> >
> > inline append runs elsewhere, too, but I don't see how this is
> > related to the subject I'm bringing up.
>=20
> This is relevant, since having a piece of SW running in multiple
> environments should lead to better testing, more exposure, finding bu=
gs
> faster.

that doesn't defeat the fact that more lines of code to do the same
thing is always going to be a more bug-prone way of doing it.

> inline append *could run* elsewhere , but it doesn't AFAICT. Last tim=
e
> I checked, USDPAA and AIOP use RTA.

inline append runs in ASF, and has been available for all upstream
for years.

> >> Combined with:
> >> -comprehensive unit testing suite
> >> -RTA kernel port is bit-exact in terms of SEC descriptors hex dump=
s with
> >> inline append; besides this, it was tested with tcrypt and in IPse=
c
> >> scenarios
> >> I would say that RTA is tested more than inline append. In the end=
, this
> >> is a side effect of having a single code base.
> >
> > inline append has been proven stable for years now.  RTA just adds
> > redundant code and violates CodingStyle AFAICT.
>=20
> New platform support is not redundant.

No, RTA is.

> Error checking is not redundant, as explained above.

It is: the kernel has fixed descriptors.

> kernel-doc is always helpful.

it doesn't matter how much you decorate it.

> Coding Style can be fixed.

inline append isn't broken.

Kim
