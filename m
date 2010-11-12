From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto ahash error handling
Date: Fri, 12 Nov 2010 08:05:32 +0800
Message-ID: <20101112000532.GA4188@gondor.apana.org.au>
References: <20101110122759.GA18577@gondor.apana.org.au> <4CDAB23B.9000704@nokia.com> <20101111161707.GA32431@gondor.apana.org.au> <4CDC31C9.8070002@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42350 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0KLAFf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Nov 2010 19:05:35 -0500
Content-Disposition: inline
In-Reply-To: <4CDC31C9.8070002@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 11, 2010 at 08:11:21PM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> Yes. Our HW is capable of producing unfinalised hashes.
> Everything is fine.

OK then you should be fine even if the user never makes the "final"
call, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
