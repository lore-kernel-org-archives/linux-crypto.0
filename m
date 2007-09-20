From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 20 Sep 2007 08:20:58 +0800
Message-ID: <20070920002058.GA26848@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de> <20070902224226.GA22869@Chamillionaire.breakpoint.cc> <20070919122943.GD19866@gondor.apana.org.au> <20070919214652.GC20997@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1300 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752413AbXITAVF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 20:21:05 -0400
Content-Disposition: inline
In-Reply-To: <20070919214652.GC20997@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2007 at 11:46:52PM +0200, Sebastian Siewior wrote:
>
> >Also please provide a way to build the generic AES code so
> >that it can at least be tested on i386/x86_64.
> 
> You want to auto compile aes-x86_64 if you are on x86_64 and additonally
> the generic version. Is that correct?
> If so, why do you want to have them both?

So that the generic C version can actually be tested on x86.
We don't want it to bit-rot which would make non-x86 2nd-class
citizens.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
