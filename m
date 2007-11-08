From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] don't make CTR default M
Date: Thu, 8 Nov 2007 21:28:23 +0800
Message-ID: <20071108132823.GC17186@gondor.apana.org.au>
References: <20071028154902.GA26247@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3479 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934AbXKHN20 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 08:28:26 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iq7Qm-00022i-NR
	for <linux-crypto@vger.kernel.org>; Fri, 09 Nov 2007 00:28:24 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Iq7Ql-0004bP-00
	for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2007 21:28:23 +0800
Content-Disposition: inline
In-Reply-To: <20071028154902.GA26247@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 28, 2007 at 04:49:02PM +0100, Sebastian Siewior wrote:
> NO other block mode is M by default.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
