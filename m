From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 10/10] crypto: aesni - Convert rfc4106 to new AEAD
 interface
Date: Fri, 29 May 2015 10:32:24 -0700
Message-ID: <1432920744.15761.17.camel@schen9-desk2.jf.intel.com>
References: <20150528140311.GA8423@gondor.apana.org.au>
	 <E1YxyQL-0002Ha-OL@gondolin.me.apana.org.au>
	 <1432848213.15761.13.camel@schen9-desk2.jf.intel.com>
	 <20150529002923.GB14942@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbbE2Rc0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 13:32:26 -0400
In-Reply-To: <20150529002923.GB14942@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2015-05-29 at 08:29 +0800, Herbert Xu wrote:
> On Thu, May 28, 2015 at 02:23:33PM -0700, Tim Chen wrote:
> >
> > Quick question.  When src and dst are different, the above code 
> > leave space for the assoc data in dst.  However, I don't think we copy
> > over the assoc data from src to dst.
> > I assume we don't have to do that, right?  If so, we have not
> > initialized assoc in dst.  This won't be a problem, will it?
> 
> It shouldn't be an issue.  If you look at the documentation for
> aead_rquest_set_crypt, it says:
> 
>  * The content of the AD in the destination buffer after processing
>  * will either be untouched, or it will contain a copy of the AD
>  * from the source buffer.  In order to ensure that it always has
>  * a copy of the AD, the user must copy the AD over either before
>  * or after processing.  Of course this is not relevant if the user
>  * is doing in-place processing where src == dst.
> 

Great, then it is clearly a user's responsibility to make sure 
that AD in dst is initialized.

Tim 
