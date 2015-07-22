From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 12:21:35 +0800
Message-ID: <20150722042135.GA32302@gondor.apana.org.au>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
 <20150722013241.GA31240@gondor.apana.org.au>
 <55AF19D0.5040700@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44280 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbGVEVm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 00:21:42 -0400
Content-Disposition: inline
In-Reply-To: <55AF19D0.5040700@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 21, 2015 at 09:19:28PM -0700, Tadeusz Struk wrote:
> 
> Is there any other in-kernel user of RSA other than the module verifier?

Not that I know of.

> If that's the only one I don't think we need any API changes.
> I can refresh the old patches that converted it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
