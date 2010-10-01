From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Thu, 30 Sep 2010 17:57:10 -0700
Message-ID: <AANLkTi=JqTU898DfW1=4qcb2WbwHvroY6LqiAX_oBb5L@mail.gmail.com>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com>
	<20100930190814.52268D2B48C@gemini.denx.de>
	<AANLkTi=CJOsayM1YnwE3a22D2S35aM+BTV6_YfXjcjiO@mail.gmail.com>
	<dc9b5d064d80ac2af2ccf932e94b2bb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@lists.ozlabs.org,
	yur@emcraft.com, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, Greg KH <greg@kroah.com>
To: Tirumala Marri <tmarri@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0JAA5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Sep 2010 20:57:12 -0400
In-Reply-To: <dc9b5d064d80ac2af2ccf932e94b2bb9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[ adding Greg ]

On Thu, Sep 30, 2010 at 5:16 PM, Tirumala Marri <tmarri@apm.com> wrote:
>> Where =A0iop_adma_alloc_slots() is implemented differently between
>> iop13xx and iop3xx. =A0In this case why does ppc440spe-adma.h exist?=
 =A0If
>> it has code specific to ppe440spe it should just live in the ppe440s=
pe
>> C file. =A0If it is truly generic it should move to the base adma.c
>> implementation. =A0If you want to reuse a ppe440spe routine just lin=
k to
>> it.
> [Marri]That is how I started changing the code. And I see tons of war=
nings
> Saying "Used but not defined" or "Defined but not used". How should I
> suppress
> Some functions from adma.c are used in ppc440spe-adma.c and some from
> ppc440spe-adma.c
> Are used in adma.c.

This is part of defining a common interface.  Maybe look at the
linkages of how the common ioat_probe() routine is used to support all
three versions of its dma hardware.

> So I created intermediate file ppc440spe-adma.h with
> inlined
> Functions. In future this will be converted into ppc4xx_adma.h and mo=
ve
> existing
> SoC specific stuff to ppc440spe-adma.c file.

You definitely need to be able to resolve "used but not defined" and
"defined but not used" warnings before tackling a driver conversion
like this.  In light of this comment I wonder if it would be
appropriate to submit your original driver, that just duplicated
routines from the ppc440spe driver, to the -staging tree.  Then it
would be available for someone familiar with driver conversions to
take a shot at unifying.

Greg, is this an appropriate use of -staging?

--
Dan
