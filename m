From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DocBook update: skip the akcipher for now?
Date: Thu, 23 Jul 2015 09:57:50 +0800
Message-ID: <20150723015750.GC9777@gondor.apana.org.au>
References: <1592921.a47nh6Krko@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57287 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbbGWB5z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 21:57:55 -0400
Content-Disposition: inline
In-Reply-To: <1592921.a47nh6Krko@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 10:24:40PM +0200, Stephan Mueller wrote:
> Hi Herbert, Tadeusz,
> 
> I am just developing patches to the kernel crypto API DocBook. Thanks to 
> Tadeusz, the API calls are nicely documented. There are only a very minor 
> tidbits I want to add.
> 
> What is missing is the link from the DocBook to the akcipher API. I would like 
> to prepare the patch, but I am not sure whether I should at this point. As 
> Herbert mentioned, there may be API changes depending on the outcome of the 
> discussion to use SGLs instead of linear buffers.
> 
> Herbert, Tadeusz, shall I wait for a DocBook update covering akcipher?

Let's wait until it settles down, i.e., after we convert the only
in-kernel user over.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
