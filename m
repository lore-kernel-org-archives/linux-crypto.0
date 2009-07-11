From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Sat, 11 Jul 2009 18:25:44 +0800
Message-ID: <20090711102544.GA14845@gondor.apana.org.au>
References: <20090711101958.GA14642@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47073 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752541AbZGKKZr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jul 2009 06:25:47 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MPZm5-000690-Me
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2009 20:25:45 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MPZm5-0003rg-1I
	for linux-crypto@vger.kernel.org; Sat, 11 Jul 2009 18:25:45 +0800
Content-Disposition: inline
In-Reply-To: <20090711101958.GA14642@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 11, 2009 at 06:19:58PM +0800, Herbert Xu wrote:
> Hi:
> 
> This series of patches converts the padlock-sha implementation to
> shash.  This is also the last legacy hash algorithm to be converted,
> apart from hmac which I had to revert as it would break padlock-sha
> unless the latter is converted.
> 
> As I don't have the hardware supporting padlock-sha, could someone
> with access to it please test this for me? In particular, I'd like
> to see this tested with an actual IPsec connection.

BTW, I got the numbering wrong so it started from 2 instead of
1.  For the record there is no 1/10.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
