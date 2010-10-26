From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: General questions on crypto
Date: Mon, 25 Oct 2010 20:06:30 -0400
Message-ID: <20101026000630.GA6293@gondor.apana.org.au>
References: <Pine.GSO.4.64.1010251627060.2377@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33626 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0JZAGc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 20:06:32 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1010251627060.2377@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
> 
> The sha1_generic that is supplied appears to be using shash, is there an 
> example for ahash?

We have a number of existing drivers under drivers/crypto that
use the ahash interface.  You can use them as a model for your
driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
