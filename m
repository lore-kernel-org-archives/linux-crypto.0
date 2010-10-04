From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Mon, 4 Oct 2010 10:30:31 -0700
Message-ID: <070fbd9a32bf18957bc2ecda9a476d7d@mail.gmail.com>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com>
 <20100930190814.52268D2B48C@gemini.denx.de> <AANLkTi=CJOsayM1YnwE3a22D2S35aM+BTV6_YfXjcjiO@mail.gmail.com>
 <dc9b5d064d80ac2af2ccf932e94b2bb9@mail.gmail.com> <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
 <20101002184957.GA17774@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@lists.ozlabs.org,
	yur@emcraft.com, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Greg KH <greg@kroah.com>, Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101002184957.GA17774@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> >
> > You definitely need to be able to resolve "used but not defined" and
> > "defined but not used" warnings before tackling a driver conversion
> > like this.  In light of this comment I wonder if it would be
> > appropriate to submit your original driver, that just duplicated
> > routines from the ppc440spe driver, to the -staging tree.  Then it
> > would be available for someone familiar with driver conversions to
> > take a shot at unifying.
> >
> > Greg, is this an appropriate use of -staging?
>
> Possibly, but I really don't like duplication if possible.  What's
> keeping this code from being fixed up now properly?

[Marri] Hello Greg, I am working on restructuring ppc4xx/adma.c driver
into
Common code and SoC specific code. This way I can add support for similar
DMA engines.
In this process I had to declare some Of the functions non static so that
I can suppress "defined but not used" and "used but not defined".


Here is what series of patches I planned to work on.

1. First set patches to re-arrange the code. Functionally no change except
Structured into different files.
2. Second set to rename the common functions which are shared between SoC
dma-engines.
3. Add support of new DMA engine for different SoC.

I am working on first patch set right now.


Regards,
Marri
