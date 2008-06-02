From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in
	cbc mode
Date: Mon, 2 Jun 2008 08:45:42 -0400
Message-ID: <20080602124542.GA15844@hmsreliant.think-freely.org>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <4841F6F6.2020502@swiss-it.ch> <20080601160349.GA29225@localhost.localdomain> <4842C9CA.9070506@swiss-it.ch> <20080601221839.GA5171@localhost.localdomain> <48432622.1090300@swiss-it.ch> <20080602083210.GA22264@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2605 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981AbYFBMp5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 08:45:57 -0400
Content-Disposition: inline
In-Reply-To: <20080602083210.GA22264@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 02, 2008 at 06:32:10PM +1000, Herbert Xu wrote:
> On Mon, Jun 02, 2008 at 12:43:46AM +0200, Adrian-Ken Rueegsegger wrote:
> >
> > I just did a clean build on a different machine with the current HEAD (ac3f925c2bb1b08a41713394d78098857d3f40a7)
> > of the cryptodev-2.6-tree. The two tests fail on that box too. :( I will see if I can spot something suspicious by
> > comparing the two configs. Could somebody else run the tests and report back the results?
> 
> It's failing for me on x86-64 as well.
> 
> Neil, I'm going to revert this until it's fixed.  BTW, please
> add the same tests to case 4 as well as case 0 so that we can run
> the test by itself.
> 
> Thanks,
Copy that.  I think I found the problem, anyway.  The verdict is that Adrian was
right, and I'm klutz.  I mixed up the output vector from a successful and a
failed test during development.  I'll repost shortly.  Sorry for the trouble!

Regards
Neil

> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
