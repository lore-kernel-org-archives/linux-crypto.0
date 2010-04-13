From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 16:59:21 +0800
Message-ID: <20100413085921.GA8988@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry.Kasatkin@nokia.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:36105 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848Ab0DMI7Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 04:59:24 -0400
Content-Disposition: inline
In-Reply-To: <1270744533.1666.9.camel@Nokia-N900>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:35:33PM +0200, Dmitry.Kasatkin@nokia.com wrote:
> 
> Sha1 only is also very useful. We calcluate hashes of all binaries for integrity verification. We do not need hmac there.

But do we do that in the Linux kernel?

Of course it would be useful if we had a user-space API, but
that is still on the TODO list.

> But in general it is possible do add algo hmac(sha1) to the driver and implement it internally without import/export.

No we don't want to add hmac to every single driver that does
sha1.  So this would not be a good precedent.  In any case,
some form of import/export must be possible (maybe not in our
current format) because our API requires the ability to perform
a partial update and postpone the finalisation indefinitely.

If you couldn't import/export, that would imply that the hardware
must have infinite memory.

> I have to check on documentation publicity.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
