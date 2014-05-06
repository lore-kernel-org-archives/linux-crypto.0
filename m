From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Tue, 6 May 2014 15:11:14 -0500
Message-ID: <20140506151114.e44a1af14c9d5b63ecbac603@freescale.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
	<20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
	<72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
	<20140505133725.33abd0d08a1662a147c498f5@freescale.com>
	<70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"Geanta Neag Horia Ioan-B05471" <Horia.Geanta@freescale.com>,
	Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>,
	Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
To: Garg Vakul-B16394 <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:50059
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751207AbaEFUQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 16:16:20 -0400
In-Reply-To: <70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 5 May 2014 22:39:09 -0500
Garg Vakul-B16394 <vakul@freescale.com> wrote:

> Hi Kim

Hi Vakul,

> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Tuesday, May 06, 2014 12:07 AM
> > 
> > On Sat, 3 May 2014 06:44:39 -0500
> > Garg Vakul-B16394 <vakul@freescale.com> wrote:
> > 
> > > > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > > > Sent: Saturday, May 03, 2014 5:40 AM
> > > >
> > > > On Sun, 27 Apr 2014 11:26:14 -0400
> > > > Vakul Garg <vakul@freescale.com> wrote:
> > > >
> > > > > @@ -220,6 +220,8 @@ static int aead_null_set_sh_desc(struct
> > > > > crypto_aead
> > > > *aead)
> > > > >  	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > > > >  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > > > >  		keys_fit_inline = true;
> > > > > +	else
> > > > > +		keys_fit_inline = false;
> > > >
> > > > Can we do the easier to read:
> > > >
> > > > 	keys_fit_inline = false;
> > > > 	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > > > 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > > > 		keys_fit_inline = true;
> > > >
> > > > ?
> > >
> > > Why pre-init a variable with default value when it could be
> > overwritten?
> > 
> > why not?  compiler output doesn't differ in this regard.
> 
> Agree that compiler output doesn't differ.
> But why depend upon compiler's optimization capability while writing code when we can be explicit?

?  with optimizations turned off, the explicit 'else' *adds* an
extra CoF..

> > > I think that the form I submitted is equally easy to read.
> > 
> > adding one line instead of two -> less lines overall -> more code on one
> > screen -> easier to read.
> 
> I think that this is a matter of personal coding choice.
> Both the approaches are fine and compliant to kernel coding guidelines.

I disagree, for the reasons already mentioned above.

Kim
