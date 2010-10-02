From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Sat, 2 Oct 2010 11:49:57 -0700
Message-ID: <20101002184957.GA17774@kroah.com>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com> <20100930190814.52268D2B48C@gemini.denx.de> <AANLkTi=CJOsayM1YnwE3a22D2S35aM+BTV6_YfXjcjiO@mail.gmail.com> <dc9b5d064d80ac2af2ccf932e94b2bb9@mail.gmail.com> <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tirumala Marri <tmarri@apm.com>, Wolfgang Denk <wd@denx.de>,
	linuxppc-dev@lists.ozlabs.org, yur@emcraft.com,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0JBStb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Oct 2010 14:49:31 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 30, 2010 at 05:57:10PM -0700, Dan Williams wrote:
> [ adding Greg ]
> 
> On Thu, Sep 30, 2010 at 5:16 PM, Tirumala Marri <tmarri@apm.com> wrote:
> >> Where ?iop_adma_alloc_slots() is implemented differently between
> >> iop13xx and iop3xx. ?In this case why does ppc440spe-adma.h exist? ?If
> >> it has code specific to ppe440spe it should just live in the ppe440spe
> >> C file. ?If it is truly generic it should move to the base adma.c
> >> implementation. ?If you want to reuse a ppe440spe routine just link to
> >> it.
> > [Marri]That is how I started changing the code. And I see tons of warnings
> > Saying "Used but not defined" or "Defined but not used". How should I
> > suppress
> > Some functions from adma.c are used in ppc440spe-adma.c and some from
> > ppc440spe-adma.c
> > Are used in adma.c.
> 
> This is part of defining a common interface.  Maybe look at the
> linkages of how the common ioat_probe() routine is used to support all
> three versions of its dma hardware.
> 
> > So I created intermediate file ppc440spe-adma.h with
> > inlined
> > Functions. In future this will be converted into ppc4xx_adma.h and move
> > existing
> > SoC specific stuff to ppc440spe-adma.c file.
> 
> You definitely need to be able to resolve "used but not defined" and
> "defined but not used" warnings before tackling a driver conversion
> like this.  In light of this comment I wonder if it would be
> appropriate to submit your original driver, that just duplicated
> routines from the ppc440spe driver, to the -staging tree.  Then it
> would be available for someone familiar with driver conversions to
> take a shot at unifying.
> 
> Greg, is this an appropriate use of -staging?

Possibly, but I really don't like duplication if possible.  What's
keeping this code from being fixed up now properly?

thanks,

greg k-h
