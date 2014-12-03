From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 03/17] crypto: ansi_cprng - Eliminate ctx->I
Date: Wed, 3 Dec 2014 06:08:29 -0500
Message-ID: <20141203110829.GA23296@hmsreliant.think-freely.org>
References: <20141202145249.GE3388@hmsreliant.think-freely.org>
 <20141202200338.13255.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34455 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCLIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 06:08:42 -0500
Content-Disposition: inline
In-Reply-To: <20141202200338.13255.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:03:38PM -0500, George Spelvin wrote:
> > I'm only ok with removing I if you can continue to be able to output it.
> > given that I is listed as part of the test sequences that NIST provides,
> > I'd like to be able to compare the values.
> 
> I can do that easily, but I can't print the *input* I, which
> is the result of encrypting the previous DT, as it's thrown
> away earlier.
> 
> You'd have to look further back in the debug messages to find it.
> 
> Is changing the format of the debug messages okay?  I'd like the debug
> messages to describe the code, but I don't know if you have something
> that parses the current output.
> 
I'm fine with changing the output, as I don't think anything particularly relies
on the format, but I cant' speak for others
Neil

> 
> The test output I see on p. 33 of
> http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
> doesn't include I.  Can you point me to a sample that includes I?
> 
> It might be best to more significantly  rework the debug messages to
> resemble the NIST test vectors.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
