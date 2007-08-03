From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Fri, 3 Aug 2007 20:34:25 +0800
Message-ID: <20070803123425.GA25948@gondor.apana.org.au>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4731 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760622AbXHCMe2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2007 08:34:28 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGwMM-000759-D1
	for <linux-crypto@vger.kernel.org>; Fri, 03 Aug 2007 22:34:26 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGwML-0006lA-00
	for <linux-crypto@vger.kernel.org>; Fri, 03 Aug 2007 20:34:25 +0800
Content-Disposition: inline
In-Reply-To: <20070802125743.GC24639@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 02:57:43PM +0200, Sebastian Siewior wrote:
> setkey_unaligned() commited in ca7c39385ce1a7b44894a4b225a4608624e90730
> overwrites unallocated memory in the following memset() because I used the
> wrong buffer length.

Good catch.  Thanks!

We don't have any in-tree users that will trigger this right
now do we?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
