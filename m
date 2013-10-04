From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS
 modes
Date: Fri, 4 Oct 2013 14:54:11 -0400 (EDT)
Message-ID: <alpine.LFD.2.03.1310041448010.3023@syhkavp.arg>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org> <20131004174853.GY24303@mudshark.cambridge.arm.com> <alpine.LFD.2.03.1310041420520.3023@syhkavp.arg> <CAKv+Gu9Lnn4=ENMc1Q+9Bkwj1R+2yk91KK1iETaes_OWaTO+fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Will Deacon <will.deacon@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52041 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3JDSyO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:54:14 -0400
Received: by mail-qc0-f172.google.com with SMTP id l13so3127559qcy.17
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2013 11:54:13 -0700 (PDT)
In-Reply-To: <CAKv+Gu9Lnn4=ENMc1Q+9Bkwj1R+2yk91KK1iETaes_OWaTO+fw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 4 Oct 2013, Ard Biesheuvel wrote:

> On 4 October 2013 20:34, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Fri, 4 Oct 2013, Will Deacon wrote:
> [...]
> >>
> >> Why do you consider it unsuitable to ship the perl script with the kernel?
> >> Perl 5 is already documented as a build dependency in Documentation/Changes
> >
> > Do you have an example of something that does require perl to build the
> > kernel on ARM?  I was under the impression that people try to avoid it
> > as much as possible in general.
> >
> > I'm personally sitting on the fence between effectively adding a new
> > kernel build dependencies or carrying the output of the perl script.
> > But if the kernel build does already require perl in practice then this
> > might tip the balance.
> >
> 
> I like Russell's suggestion the most, in fact.

Me too.

> In this case, the build time requirement for Perl effectively gets 
> suspended until you start making modifications to the perl script, and 
> the relation between the .S and the .pl files is made explicit by the 
> make rule.
> 
> Should I put the cmd_perl rule in scripts/Makefile.build ? Or can I
> just keep it under arch/arm/crypto ?

To avoid possible gag reactions from the wider community I'd suggest you 
keep it local for now.  Unless there are already such perl usage 
elsewhere in the tree in which case abstracting it to 
scripts/Makefile.build first is recommended.


Nicolas
