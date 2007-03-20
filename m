From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scatterwalk_copychunks() fails to advance through scatterlist
Date: Wed, 21 Mar 2007 07:54:21 +1100
Message-ID: <20070320205421.GA23929@gondor.apana.org.au>
References: <20070319235508.GH29272@fieldses.org> <20070320051656.GA17711@gondor.apana.org.au> <20070320141614.GA12165@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nfsv4@linux-nfs.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2290 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753897AbXCTUyc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2007 16:54:32 -0400
Content-Disposition: inline
In-Reply-To: <20070320141614.GA12165@fieldses.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 20, 2007 at 10:16:14AM -0400, J. Bruce Fields wrote:
> 
> Are the elements of the scatterlists assumed to always be full pages?  I

Definitely not.

> need to encrypt things that look like, for example:
> 
> 	sg[0].page = page1
> 	sg[0].offset = 0
> 	sg[0].length = 5
> 	sg[1].page = page2
> 	sg[1].offset = 0
> 	sg[1].length = 37

OK I see what you mean now.  I'll apply your patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
