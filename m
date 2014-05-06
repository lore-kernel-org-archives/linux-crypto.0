From: Vakul Garg <vakul@freescale.com>
Subject: RE: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Tue, 6 May 2014 03:39:09 +0000
Message-ID: <70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
	<20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
	<72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
 <20140505133725.33abd0d08a1662a147c498f5@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Kim Phillips <Kim.Phillips@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"Horia.Geanta@freescale.com" <Horia.Geanta@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"alexandru.porosanu@freescale.com" <alexandru.porosanu@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:17982
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933740AbaEFDjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 May 2014 23:39:12 -0400
In-Reply-To: <20140505133725.33abd0d08a1662a147c498f5@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim

> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Tuesday, May 06, 2014 12:07 AM
> To: Garg Vakul-B16394
> Cc: Phillips Kim-R1AAHA; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; Geanta Neag Horia Ioan-B05471; Gupta
> Ruchika-R66431; Porosanu Alexandru-B06830
> Subject: Re: [PATCH] crypto: caam - Fix key inlining in AEAD shared
> descriptors
> 
> On Sat, 3 May 2014 06:44:39 -0500
> Garg Vakul-B16394 <vakul@freescale.com> wrote:
> 
> > > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > > Sent: Saturday, May 03, 2014 5:40 AM
> > >
> > > On Sun, 27 Apr 2014 11:26:14 -0400
> > > Vakul Garg <vakul@freescale.com> wrote:
> > >
> > > > @@ -220,6 +220,8 @@ static int aead_null_set_sh_desc(struct
> > > > crypto_aead
> > > *aead)
> > > >  	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > > >  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > > >  		keys_fit_inline = true;
> > > > +	else
> > > > +		keys_fit_inline = false;
> > >
> > > Can we do the easier to read:
> > >
> > > 	keys_fit_inline = false;
> > > 	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > > 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > > 		keys_fit_inline = true;
> > >
> > > ?
> >
> > Why pre-init a variable with default value when it could be
> overwritten?
> 
> why not?  compiler output doesn't differ in this regard.
> 

Agree that compiler output doesn't differ.
But why depend upon compiler's optimization capability while writing code when we can be explicit?

> > I think that the form I submitted is equally easy to read.
> 
> adding one line instead of two -> less lines overall -> more code on one
> screen -> easier to read.
> 

I think that this is a matter of personal coding choice.
Both the approaches are fine and compliant to kernel coding guidelines.

> Kim
