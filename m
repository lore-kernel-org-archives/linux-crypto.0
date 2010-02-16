From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Feb 2010 14:58:44 +0800
Message-ID: <20100216065844.GA28436@gondor.apana.org.au>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com> <4B799E83.5000700@nokia.com> <20100216004430.GA26021@gondor.apana.org.au> <4B7A3CD8.2000500@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53739 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754456Ab0BPG6r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 01:58:47 -0500
Content-Disposition: inline
In-Reply-To: <4B7A3CD8.2000500@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2010 at 08:36:08AM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> we have HW accelerator which can be accessed without DMA.
> CPU just sequentially writes data to the port and then reads result.

Well if that's the case then you definitely don't need anything
other than kmap_atomic.  You should be able to map it atomically,
write the data out, unmap it, and then wait for the completion.

Non-atomic kmaps should be avoided if at all possible.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
