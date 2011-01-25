From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hash finup() issue
Date: Wed, 26 Jan 2011 09:29:17 +1000
Message-ID: <20110125232917.GA14972@gondor.apana.org.au>
References: <4D3ED3CF.4080205@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52191 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1AYX3U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Jan 2011 18:29:20 -0500
Content-Disposition: inline
In-Reply-To: <4D3ED3CF.4080205@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 25, 2011 at 03:44:47PM +0200, Dmitry Kasatkin wrote:
>
> What we have done in our system is introduced a new flag which is set to
> request.
> flags |= CRYPTO_TFM_REQ_USE_FINUP;
> ahash_request_set_callback(req, flags,  tcrypt_complete, &tresult);

We don't need a flag for this, we just need to optimise the
user-interface code to actually use finup when MSG_MORE is not
set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
