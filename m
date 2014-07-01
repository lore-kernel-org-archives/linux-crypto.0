From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
 (part1)
Date: Tue, 1 Jul 2014 18:35:47 +0100
Message-ID: <20140701173547.GW28164@arm.com>
References: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk>
 <yw1x4mz1f2t9.fsf@unicorn.mansr.com>
 <20140701171346.GP3705@n2100.arm.linux.org.uk>
 <yw1xzjgtdmas.fsf@unicorn.mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54202 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235AbaGARgW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 13:36:22 -0400
Content-Disposition: inline
In-Reply-To: <yw1xzjgtdmas.fsf@unicorn.mansr.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mans,

On Tue, Jul 01, 2014 at 06:24:43PM +0100, M=E5ns Rullg=E5rd wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > As you point out, "bx lr" /may/ be treated specially (I've actually=
 been
>=20
> Most, if not all, Cortex-A cores do this according the public TRMs.
> They also do the same thing for "mov pc, lr" so there will probably b=
e
> no performance gain from this change.  It's still a good idea though,
> since we don't know what future cores will do.

=46unnily enough, that's not actually true (and is more or less what pr=
ompted
this patch after discussion with Russell). There are cores out there th=
at
don't predict mov pc, lr at all (let alone do anything with the return
stack).

> > discussing this with Will Deacon over the last couple of days, who =
has
> > also been talking to the hardware people in ARM, and Will is happy =
with
> > this patch as in its current form.)  This is why I've changed all
> > "mov pc, reg" instructions which return in some way to use this mac=
ro,
> > and left others (those which are used to call some function and ret=
urn
> > back to the same point) alone.
>=20
> In that case the patch should be fine.  Your patch description didn't
> make it clear that only actual returns were being changed.

I'm led to believe that some predictors require lr in order to update t=
he
return stack, whilst others don't. That part is all horribly
micro-architectural, so the current patch is doing the right thing by
sticking to the ARM ARM but enabling us to hook into other registers la=
ter
on if we choose.

Cheers,

Will
