From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Fri, 3 Aug 2007 23:13:41 +0800
Message-ID: <20070803151341.GA27969@gondor.apana.org.au>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc> <20070803123425.GA25948@gondor.apana.org.au> <20070803132628.GC17687@Chamillionaire.breakpoint.cc> <20070803134302.GA26727@gondor.apana.org.au> <20070803135856.GD17687@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1916 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932390AbXHCPNp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2007 11:13:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGyqU-00014k-5w
	for <linux-crypto@vger.kernel.org>; Sat, 04 Aug 2007 01:13:42 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGyqT-0007Hg-00
	for <linux-crypto@vger.kernel.org>; Fri, 03 Aug 2007 23:13:41 +0800
Content-Disposition: inline
In-Reply-To: <20070803135856.GD17687@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 03, 2007 at 03:58:56PM +0200, Sebastian Siewior wrote:
>
> >I'll get this pushed into stable too.
> 
> This bug is only available in upcomming v2.6.23, isn't it?

Indeed.  Excellent, it's only needed for the 2.6.23 tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
