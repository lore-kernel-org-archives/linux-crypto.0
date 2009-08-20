From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Thu, 20 Aug 2009 17:54:37 +1000
Message-ID: <20090820075437.GA30878@gondor.apana.org.au>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au> <20090813144156.GA31826@shamino.rdu.redhat.com> <20090814031340.GA2380@gondor.apana.org.au> <20090814105829.GB20601@hmsreliant.think-freely.org> <20090814111355.GA5908@gondor.apana.org.au> <20090814153930.GC20601@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41444 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750744AbZHTHyi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2009 03:54:38 -0400
Content-Disposition: inline
In-Reply-To: <20090814153930.GC20601@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2009 at 11:39:30AM -0400, Neil Horman wrote:
> 
> What about something like this?  It defaults the CPRNG to m and makes FIPS
> dependent on the CPRNG.  That way you get a module build by default, but you can
> change it to y manually during config and still satisfy the dependency, and if
> you select N it disables FIPS as well.  I rather like that better than making
> FIPS a tristate.  I just tested it out here and it seems to work well.  Let me
> know what you think
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Looks good to me.  Patch applied.

Thanks Neil,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
