From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] Introduce devm_hwrng_register and convert a few
 dirvers
Date: Mon, 16 Mar 2015 21:49:34 +1100
Message-ID: <20150316104933.GA793@gondor.apana.org.au>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49945 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbbCPKth (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 06:49:37 -0400
Content-Disposition: inline
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 12, 2015 at 02:00:01PM -0700, Dmitry Torokhov wrote:
> A few drivers can benefit from devm-style interface for hwrng since it
> is quite often the last thing that isn't automatically managed. Using
> devm_hwrng_register() in such drivers allows get rid of manual error
> unwinding and drivers' remove() methods.
> 
> I tested changes to iproc-rng200, the rest are compiled only.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
