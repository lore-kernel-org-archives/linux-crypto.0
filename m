From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 21:07:41 +0800
Message-ID: <20070820130741.GA13549@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3687 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbXHTNHq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 09:07:46 -0400
Content-Disposition: inline
In-Reply-To: <20070820130639.GN16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 20, 2007 at 03:06:39PM +0200, Andi Kleen wrote:
>
> > Well it's not that useful for an assembly implementation
> > that works on all instances of a given architecture.
> 
> I meant on x86. Sure for other architectures the C version is needed.

My point was that while it's not useful for aes-i586 on x86,
it definitely is useful for padlock-aes which is also x86 asm
but only works on a subset of x86 processors.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
