From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RFC] crypto: cesa: Don't use tfm->__crt_alg->cra_type
 directly
Date: Thu, 22 May 2014 21:09:15 +0800
Message-ID: <20140522130914.GD3598@gondor.apana.org.au>
References: <1400060572-11692-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Phil Sutter <phil.sutter@viprinet.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48314 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaEVNJU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:09:20 -0400
Content-Disposition: inline
In-Reply-To: <1400060572-11692-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2014 at 11:42:52AM +0200, Marek Vasut wrote:
> The checking for the type of algorithm implementation is pretty
> strange here. Use regular flags to check for the type instead.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Phil Sutter <phil.sutter@viprinet.com>

Looks OK to me.  Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
