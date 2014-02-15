From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Fri, 14 Feb 2014 18:01:06 -0800
Message-ID: <1392429666.27116.93.camel@schen9-DESK>
References: <1392405277.27116.72.camel@schen9-DESK>
	 <20140215012314.GA28843@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaBOCBK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 21:01:10 -0500
In-Reply-To: <20140215012314.GA28843@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2014-02-15 at 09:23 +0800, Herbert Xu wrote:
> On Fri, Feb 14, 2014 at 11:14:37AM -0800, Tim Chen wrote:
> > We added the soft module dependency of various crypto algorithm's module alias
> >  to generic crypto algorithm's module. This loads hardware accelerated
> >  modules and uses them when available.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> I don't see the point of this patch.  Any users of these modules
> would be requesting for their alias and not their real name.  So
> either it'll already load all the hardware modules or it won't load
> the generic version either.
> 
> For example, if you request blowfish you'll get every module that
> has the alias blowfish.  As the software version is called blowfish_generic
> it will be treated no differently than any hardware accelerated
> version.

If we issue an explicit modprobe of the module alias, I don't
think there is a problem.

I am under the impression we may have a scenario like this:

Module A selects CRYPTO_ALG_B in config, which causes the generic
ALG_B to get built and a module dependency to the generic
ALG_B to be established.  Then when module A loads,
we will load the generic ALG_B module.  So a soft dependency
in the generic ALG_B module is needed
to load all the other alias module along with the generic
module.  Otherwise only the generic module is loaded when
module A loads.

Tim
