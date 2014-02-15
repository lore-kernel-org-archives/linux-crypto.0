From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Sat, 15 Feb 2014 09:23:14 +0800
Message-ID: <20140215012314.GA28843@gondor.apana.org.au>
References: <1392405277.27116.72.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38160 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBOBYC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 20:24:02 -0500
Content-Disposition: inline
In-Reply-To: <1392405277.27116.72.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 14, 2014 at 11:14:37AM -0800, Tim Chen wrote:
> We added the soft module dependency of various crypto algorithm's module alias
>  to generic crypto algorithm's module. This loads hardware accelerated
>  modules and uses them when available.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

I don't see the point of this patch.  Any users of these modules
would be requesting for their alias and not their real name.  So
either it'll already load all the hardware modules or it won't load
the generic version either.

For example, if you request blowfish you'll get every module that
has the alias blowfish.  As the software version is called blowfish_generic
it will be treated no differently than any hardware accelerated
version.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
