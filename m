From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RSA signature verification
Date: Mon, 21 Mar 2011 22:06:53 +0800
Message-ID: <20110321140653.GA14174@gondor.apana.org.au>
References: <4D875AF9.4060302@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54216 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1CUOGz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2011 10:06:55 -0400
Content-Disposition: inline
In-Reply-To: <4D875AF9.4060302@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 21, 2011 at 04:04:41PM +0200, Dmitry Kasatkin wrote:
>
> Do you think it make sense to have it as a crypto "algo"
> What kind of API you would have in mind?

So the obvious question is who will use this functionality in
the kernel? If the only use is going to be in user-space, then
the next question is are you doing this for hardware enablement.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
