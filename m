From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Fri, 1 Oct 2010 17:54:20 -0700
Message-ID: <7a4fda4dcac9cc030907f3e5ed8a8967@mail.gmail.com>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com>
	<20100930190814.52268D2B48C@gemini.denx.de>	<AANLkTi=CJOsayM1YnwE3a22D2S35aM+BTV6_YfXjcjiO@mail.gmail.com>
	<dc9b5d064d80ac2af2ccf932e94b2bb9@mail.gmail.com> <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@lists.ozlabs.org,
	yur@emcraft.com, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> You definitely need to be able to resolve "used but not defined" and
> "defined but not used" warnings before tackling a driver conversion
> like this.  In light of this comment I wonder if it would be
> appropriate to submit your original driver, that just duplicated
> routines from the ppc440spe driver, to the -staging tree.  Then it
> would be available for someone familiar with driver conversions to
> take a shot at unifying.
>
> Greg, is this an appropriate use of -staging?
The other option is to define non static functions in ppc440spe-adma.c
which are used in common
File adma.c . This way there will not be any warnings. Is this something
acceptable ?

Here is the break down

ppc440spe-adma.c: It will have all the 440spe SoC specific functions.
ppc4xx_adma.h will have the declarations from 440spe-adma.c as non static.
adma.c will have common functions which are independent of SoC.

Please suggest.
Regards,

-Marri
