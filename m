From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
	rfc4106_set_hash_subkey().
Date: Tue, 8 Feb 2011 08:09:02 +1100
Message-ID: <20110207210901.GA21941@gondor.apana.org.au>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
	adrian.hoban@intel.com, jj@chaosbits.net
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39123 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BGVJF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Feb 2011 16:09:05 -0500
Content-Disposition: inline
In-Reply-To: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 07, 2011 at 05:32:59PM +0000, tadeusz.struk@intel.com wrote:
>
> Here goes.
> 
> Fix up previous patch that attempted to fix a mem leak in 
> rfc4106_set_hash_subkey. The previous patch was flawed in that the 'goto 
> out' would still leak.

Sign-off?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
