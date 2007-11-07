From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Wed, 7 Nov 2007 23:03:44 +0800
Message-ID: <20071107150344.GA5479@gondor.apana.org.au>
References: <200710261922.l9QJMSK0022034@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mikko.herranen@cs.helsinki.fi
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4031 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbXKGPEN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2007 10:04:13 -0500
Content-Disposition: inline
In-Reply-To: <200710261922.l9QJMSK0022034@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 26, 2007 at 02:22:28PM -0500, Joy Latten wrote:
>
> Ok, I added 2 additional checks; one check
> that countersize >= 4 and the other that 
> noncesize+ivsize+countersize >= blocksize.
>  
> I think the addition of these two checks help
> to cover instances where we will want to fail
> because of our inputs. 
> 
> The below patch covers the additional checks as
> well as the changes for GCM.

Looks great.  Thanks Joy!

BTW, please check your patches for white space errors with

git apply --check --whitespace=error-all your-patch

I've fixed them up this time.  Actually, I must've fixed them
up last time too because your patch didn't apply against my
tree :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
