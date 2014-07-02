From: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
 (part1)
Date: Tue, 01 Jul 2014 23:17:22 -0400 (EDT)
Message-ID: <alpine.LFD.2.11.1407012314100.16842@knanqh.ubzr>
References: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk>
 <yw1x4mz1f2t9.fsf@unicorn.mansr.com>
 <20140701171346.GP3705@n2100.arm.linux.org.uk>
 <yw1xzjgtdmas.fsf@unicorn.mansr.com> <20140701173547.GW28164@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_mgw8uSma0Mmji5Peh3Zp8w)"
Cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:12622 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaGBDRZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 23:17:25 -0400
In-reply-to: <20140701173547.GW28164@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_mgw8uSma0Mmji5Peh3Zp8w)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Tue, 1 Jul 2014, Will Deacon wrote:

> Hi Mans,
> 
> On Tue, Jul 01, 2014 at 06:24:43PM +0100, Måns Rullgård wrote:
> > Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > > As you point out, "bx lr" /may/ be treated specially (I've actually been
> > 
> > Most, if not all, Cortex-A cores do this according the public TRMs.
> > They also do the same thing for "mov pc, lr" so there will probably be
> > no performance gain from this change.  It's still a good idea though,
> > since we don't know what future cores will do.
> 
> Funnily enough, that's not actually true (and is more or less what prompted
> this patch after discussion with Russell). There are cores out there that
> don't predict mov pc, lr at all (let alone do anything with the return
> stack).
> 
> > > discussing this with Will Deacon over the last couple of days, who has
> > > also been talking to the hardware people in ARM, and Will is happy with
> > > this patch as in its current form.)  This is why I've changed all
> > > "mov pc, reg" instructions which return in some way to use this macro,
> > > and left others (those which are used to call some function and return
> > > back to the same point) alone.
> > 
> > In that case the patch should be fine.  Your patch description didn't
> > make it clear that only actual returns were being changed.
> 
> I'm led to believe that some predictors require lr in order to update the
> return stack, whilst others don't. That part is all horribly
> micro-architectural, so the current patch is doing the right thing by
> sticking to the ARM ARM but enabling us to hook into other registers later
> on if we choose.

May I suggest to have a patch with only the macro definition in it and 
all this discussion in the commit log please?  The usage sites should be 
done in a separate patch to make it clearer.


Nicolas

--Boundary_(ID_mgw8uSma0Mmji5Peh3Zp8w)--
