From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 00/12] crypto: caam - Add RTA descriptor creation
 library
Date: Wed, 3 Sep 2014 18:54:02 -0500
Message-ID: <20140903185402.0d6b73be4d4de2d7def36680@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
	<20140816061655.d2fa481b47f701f2f2bd8552@freescale.com>
	<5406E686.3010803@freescale.com>
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
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:18348
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932561AbaICX7U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Sep 2014 19:59:20 -0400
In-Reply-To: <5406E686.3010803@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 3 Sep 2014 12:59:34 +0300
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 8/16/2014 2:16 PM, Kim Phillips wrote:
> > On Thu, 14 Aug 2014 15:54:22 +0300
> > Horia Geanta <horia.geanta@freescale.com> wrote:
> >=20
> >> This patch set adds Run Time Assembler (RTA) SEC descriptor librar=
y.
> >> RTA is a replacement for incumbent "inline append".
> >>
> >> The library is intended to be a single code base for SEC descripto=
rs creation
> >> for all Freescale products. This comes with a series of advantages=
, such as
> >> library being maintained / kept up-to-date with latest platforms, =
i.e. SEC
> >> functionalities (for e.g. SEC incarnations present in Layerscape L=
S1 and LS2).
> >>
> >> RTA detects options in SEC descriptors that are not supported
> >> by a SEC HW revision ("Era") and reports this back.
> >> Say a descriptor uses Sequence Out Pointer (SOP) option for the SE=
QINPTR
> >> command, which is supported starting from SEC Era 5. If the descri=
ptor would
> >> be built on a P4080R3 platform (which has SEC Era 4), RTA would re=
port
> >> "SEQ IN PTR: Flag(s) not supported by SEC Era 4".
> >> This is extremely useful and saves a lot of time wasted on debuggi=
ng.
> >> SEC HW detects only *some* of these problems, leaving user wonder =
what causes
> >> a "DECO Watchdog Timeout". And when it prints something more usefu=
l, sometimes
> >> it does not point to the exact opcode.
> >=20
> > again, RTA just adds bloat to the kernel driver - the kernel driver
> > is supposed to generate the appropriate descriptor for its target
> > running SEC version no matter what, not "report back" what is/is no=
t
> > supported.  This is a flaw at the RTA design level, as far as the
> > kernel driver is concerned.
>=20
> What is your understanding of developing a descriptor?
> First it needs to be written, then tested - within the kernel driver.
> Having no error checking in the code that generates descriptors
> increases testing / debugging time significantly. Again, SEC HW provi=
des
> some error reporting, but in many cases this is a clueless Watchdog T=
imeout.
> SEC descriptors development is complex enough to deserve a few
> indications along the way.

AFAICT, RTA doesn't address the Watchdog Timeout issue (which
pretty much always means some part of the SEC has timed out waiting
for more input data).  This is something learnt pretty quickly by
SEC developers, and something best to leave to the h/w anyway, since
it would be too cumbersome to add to descriptor construction.  So
instead of using RTA, we can discuss enhancing error.c messages to
address cluing in users wrt what the error means, but that change
should probably start with the SEC documentation itself (which is
what error.c messages are based on, and what developers should be
referencing in the first place :).

So RTA tells you what command flags are supported in which SEC
versions.  I'm pretty sure h/w behaviour covers that case, too, but
the premise doesn't apply to the kernel driver, since adding support
to the existing descriptors for a new feature flag implies knowing
which SEC version it was introduced in, because the kernel must
work on all versions of the SEC.  This promotes a more constructive
implementation design, i.e., the upper levels of the descriptor
construction code shouldn't use the flag if the h/w doesn't support
it in the first place:  none of this 'reporting back' business.

=46WIW, I doubt that out-of-kernel users would want this feature
either - it's bloat to them too, assuming they are working under the
same constraints as the kernel.  If a user experiences the 'flag
unsupported' error, hypothetically they'd go back to the upper level
descriptor construction code and adjust it accordingly, rendering
the original check a waste of runtime after that point.

This reinforces my notion that RTA was not well thought-out from the
beginning.  Probably a better place to do these basic checks is in
the form of an external disassembler.

In any case, most of the kernel's crypto API algorithm descriptors
are already fixed, written and constantly get backward-compatibility
tested on newer h/w via the kernel's testing infrastructure:  RTA
adds nothing but bloat, and for that reason, I consider it a
regression, and therefore unacceptable for upstream inclusion.
Sorry.

Kim
