From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about ahash
Date: Mon, 25 Oct 2010 20:04:40 -0400
Message-ID: <20101026000440.GA6243@gondor.apana.org.au>
References: <Pine.GSO.4.64.1010251647580.2377@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.hengli.com.au, mark.a.allyn@intel.com,
	linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40492 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab0JZAEp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 20:04:45 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1010251647580.2377@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
> 
> Herbert:
> 
> Perhaps this is very fundamential, but what is the difference between
> synchronous and asynchronous as far as crypto is concerned? My device
> performs encryption and decryption asynchronously in relation to
> the main processor in the system. The driver tells the device to
> do x, then goes away and does other stuff, then gets an interrupt
> when the device is done and ready.

That is clearly a candidate for the ahash interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
