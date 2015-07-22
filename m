From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 09:32:41 +0800
Message-ID: <20150722013241.GA31240@gondor.apana.org.au>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36359 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbbGVBcw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 21:32:52 -0400
Content-Disposition: inline
In-Reply-To: <3908391.JkjAozYBaW@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 12:12:29AM +0200, Stephan Mueller wrote:
> 
> The patchset provides the implementation of the AF_ALG userspace interface
> for the asymmetric cipher API of the kernel crypto API.

I think we should finish the conversion of the only in-kernel
user of RSA before we add the user-space interface.  Otherwise
this unnecessarily ties our hands to the current API.

For example, do we want an SG interface for the input and output?
As it stands even if a hardware device came with SG support we
would not be able to use it.

Tadeusz, can you confirm again that qat does not support SG with
respect to RSA input and output?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
