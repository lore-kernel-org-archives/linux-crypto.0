From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto ahash error handling
Date: Fri, 12 Nov 2010 01:17:08 +0900
Message-ID: <20101111161707.GA32431@gondor.apana.org.au>
References: <20101110122759.GA18577@gondor.apana.org.au> <4CDAB23B.9000704@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45276 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0KKQRL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Nov 2010 11:17:11 -0500
Content-Disposition: inline
In-Reply-To: <4CDAB23B.9000704@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 10, 2010 at 04:54:51PM +0200, Dmitry Kasatkin wrote:
> This is not good.
> 
> Driver might allocate some resources, which needs to be released.
> crypto_ahash_final() should do some kind of "cleanup" task.

Then your driver is broken.  The whole hash API is designed around
the fact that each update operation completely stores all output
state in the memory provided, leaving no state behind in the
hardware.

Is your hardware capable of producing unfinalised hashes? If not
then you shouldn't even be implementing an update operation in
hardware.  You should instead use a software fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
