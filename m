From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Mon, 5 May 2014 13:37:25 -0500
Message-ID: <20140505133725.33abd0d08a1662a147c498f5@freescale.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
	<20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
	<72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"Geanta Neag Horia Ioan-B05471" <Horia.Geanta@freescale.com>,
	Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>,
	Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
To: Garg Vakul-B16394 <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:20064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448AbaEESm2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 May 2014 14:42:28 -0400
In-Reply-To: <72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 3 May 2014 06:44:39 -0500
Garg Vakul-B16394 <vakul@freescale.com> wrote:

> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Saturday, May 03, 2014 5:40 AM
> > 
> > On Sun, 27 Apr 2014 11:26:14 -0400
> > Vakul Garg <vakul@freescale.com> wrote:
> > 
> > > @@ -220,6 +220,8 @@ static int aead_null_set_sh_desc(struct crypto_aead
> > *aead)
> > >  	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > >  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > >  		keys_fit_inline = true;
> > > +	else
> > > +		keys_fit_inline = false;
> > 
> > Can we do the easier to read:
> > 
> > 	keys_fit_inline = false;
> > 	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
> > 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
> > 		keys_fit_inline = true;
> > 
> > ?
> 
> Why pre-init a variable with default value when it could be overwritten?

why not?  compiler output doesn't differ in this regard.

> I think that the form I submitted is equally easy to read.

adding one line instead of two -> less lines overall -> more code
on one screen -> easier to read.

Kim
