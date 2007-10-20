From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GCM & CTR (fwd)
Date: Sat, 20 Oct 2007 21:32:55 +0800
Message-ID: <20071020133255.GA28678@gondor.apana.org.au>
References: <Pine.LNX.4.64.0710192300150.3619@antarct> <1192832972.2477.413.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikko Herranen <mikko.herranen@cs.helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1169 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754521AbXJTNxn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2007 09:53:43 -0400
Content-Disposition: inline
In-Reply-To: <1192832972.2477.413.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 19, 2007 at 10:29:32PM +0000, Joy Latten wrote:
>
> I think the change to CTR would be simple.  
> If noncesize + ivsize == blocksize, then use 
> entire counterblock as counter and pass to  
> ctr_inc_quad(). Currently, we just fail 
> if noncesize + ivsize == blocksize.  

How about adding an explicit counter size parameter?

So intead of ctr(aes,4,8) for the standard IPsec CTR we'd have
ctr(aes,4,8,4).  Then GCM can just use ctr(aes,4,12,4).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
