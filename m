From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS
 modes
Date: Fri, 4 Oct 2013 14:57:28 -0400 (EDT)
Message-ID: <alpine.LFD.2.03.1310041455170.3023@syhkavp.arg>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org> <20131004174853.GY24303@mudshark.cambridge.arm.com> <alpine.LFD.2.03.1310041420520.3023@syhkavp.arg> <CAKv+Gu9Lnn4=ENMc1Q+9Bkwj1R+2yk91KK1iETaes_OWaTO+fw@mail.gmail.com>
 <20131004184625.GS12758@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Will Deacon <will.deacon@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33709 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3JDS5a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:57:30 -0400
Received: by mail-qa0-f45.google.com with SMTP id k4so1353436qaq.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2013 11:57:30 -0700 (PDT)
In-Reply-To: <20131004184625.GS12758@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 4 Oct 2013, Russell King - ARM Linux wrote:

> On Fri, Oct 04, 2013 at 08:41:35PM +0200, Ard Biesheuvel wrote:
> > On 4 October 2013 20:34, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > > On Fri, 4 Oct 2013, Will Deacon wrote:
> > [...]
> > >>
> > >> Why do you consider it unsuitable to ship the perl script with the kernel?
> > >> Perl 5 is already documented as a build dependency in Documentation/Changes
> > >
> > > Do you have an example of something that does require perl to build the
> > > kernel on ARM?  I was under the impression that people try to avoid it
> > > as much as possible in general.
> > >
> > > I'm personally sitting on the fence between effectively adding a new
> > > kernel build dependencies or carrying the output of the perl script.
> > > But if the kernel build does already require perl in practice then this
> > > might tip the balance.
> > >
> > 
> > I like Russell's suggestion the most, in fact. In this case, the build
> > time requirement for Perl effectively gets suspended until you start
> > making modifications to the perl script, and the relation between the
> > .S and the .pl files is made explicit by the make rule.
> > 
> > Should I put the cmd_perl rule in scripts/Makefile.build ? Or can I
> > just keep it under arch/arm/crypto ?
> 
> Just running through the Makefiles, it seems we have a fair amount
> of stuff already using perl in various ways.  So I wouldn't worry too
> much about where it's placed.  It's probably something that should
> eventually end up in scripts/ at _some_ point.

BTW, Russell's opinion has precedence over what I just said.


Nicolas
