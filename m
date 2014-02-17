From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Mon, 17 Feb 2014 07:08:06 -0500
Message-ID: <20140217120806.GA17382@hmsreliant.think-freely.org>
References: <1392405277.27116.72.camel@schen9-DESK>
 <20140215012314.GA28843@gondor.apana.org.au>
 <1392429666.27116.93.camel@schen9-DESK>
 <20140215234122.GA3401@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaBQMIZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Feb 2014 07:08:25 -0500
Content-Disposition: inline
In-Reply-To: <20140215234122.GA3401@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 16, 2014 at 07:41:23AM +0800, Herbert Xu wrote:
> On Fri, Feb 14, 2014 at 06:01:06PM -0800, Tim Chen wrote:
> > 
> > Module A selects CRYPTO_ALG_B in config, which causes the generic
> > ALG_B to get built and a module dependency to the generic
> > ALG_B to be established.  Then when module A loads,
> 
> No, if you select ALG_B then yes it'll get built but it certainly
> won't establish a module dependency on ALG_B.  Only a softdep could
> create such a dependency.
> 
My understanding was that the soft dependencies were there to work exactly at
the softdep directive was in modprobe.conf.  That it to say, "Module B would
like to have Module A installed, but it won't be fatal if it can't be done".
The more correct example I've seen thus far has been the crct10dif crc
algorithm for x86.  In lib/crc-t10dif we have a crc-t10dif function which makes
use of the generic crc_t10dif_generic function defined in crct10dif_common.c.
However, x86 has an accelerated version of the function defined in the
crct10dif-pcmul module (thats aliased to crct10dif).  So the library funcion in
the kernel lists crct10dif as a soft dependency and modprobe tries to load it,
but just carries on if it fails.

Although as I write that, several things confuse me.  When are module
dependencies meant to be satisfied on behalf of the monolithic kernel, where
that dependecy is defined?  I'm guessing right before the init routine is
called for that code, but I'm not sure.  Also, I'm a bit confused by Marco and
Lukas' statement about how they see soft dependencies working.  I'm not sure
where the requirement to recognize soft dependencies comes from in depmod.

Regards
Neil

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
