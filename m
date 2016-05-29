From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Could this be applied to random(4)?
Date: Sun, 29 May 2016 21:20:11 +0200
Message-ID: <3128607.kWjc3BaTVM@positron.chronox.de>
References: <CACXcFm=Feh_V_AMMYwdAjx4SiVh1eSeQnu1eujjv4S6-LD9Pag@mail.gmail.com> <1536831.omfD4HBPSy@tauon.atsec.com> <CACXcFmm1q-Z3JSE79m5ak-a+tO50uQNUPwvq_ueei_b19qycJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	John Denker <jsd@av8n.com>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35070 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbcE2TUN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 May 2016 15:20:13 -0400
In-Reply-To: <CACXcFmm1q-Z3JSE79m5ak-a+tO50uQNUPwvq_ueei_b19qycJw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 27. Mai 2016, 16:09:53 schrieb Sandy Harris:

Hi Sandy,

> On Fri, May 27, 2016 at 2:30 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > This document describes extractors. Those extractors are intended to
> > combine *independent* sources with weak entropy.
> > 
> > None of our sources we have in add_*_randomness are independent.
> 
> No, but it would be easy to get two independent sources, interrupts
> and some sort of timer jitter thing as in my maxwell, your jitter
> driver, havege, ...

I think I would concur with you here. From my LRNG code:

static int lrng_pdrbg_seed_internal(u8 *outbuf, u32 outbuflen, bool 
fullentropy,
                                    bool drain)
{
...
        /*
         * Concatenate the output of the noise sources. This would be the
         * spot to add an entropy extractor logic if desired.
...

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
