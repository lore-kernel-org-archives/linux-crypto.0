From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: nx - Fix reentrancy bugs
Date: Wed, 8 Jul 2015 06:10:47 +0800
Message-ID: <20150707221047.GA7655@gondor.apana.org.au>
References: <20150707093025.GA31368@gondor.apana.org.au>
 <20150707184837.GA9341@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39669 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbGGWKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 18:10:51 -0400
Content-Disposition: inline
In-Reply-To: <20150707184837.GA9341@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2015 at 03:48:37PM -0300, Leonidas S. Barbosa wrote:
> On Tue, Jul 07, 2015 at 05:30:25PM +0800, Herbert Xu wrote:
> > The crypto API allows a single transform to be used by multiple
> > threads simultaneously.  For example, IPsec will use a single tfm
> > to process packets for a given SA.  As packets may arrive on
> > multiple CPUs that tfm must be reentrant.
> > 
> > The nx driver does try to deal with this by using a spin lock.
> > Unfortunately only the basic AES/CBC/ECB algorithms do this in
> > the correct way.
> > 
> > The symptom of these bugs may range from the generation of incorrect
> > output to memory corruption.
> 
> Is this related with the issue in CTR ouput test#4 too?

I don't think so because during the test there should only be a
single user.  But I'll test it out today just in case.

PS it would appear that you can make this completely reentrant
by moving all the data from the tfm into the reqeust.  Could you
work on this and remove the spinlock completely?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
