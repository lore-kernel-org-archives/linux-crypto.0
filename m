From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: Undefined behaviour in
	crypto_aes_expand_key
Date: Fri, 24 Jul 2009 13:59:43 +0800
Message-ID: <20090724055943.GA22512@gondor.apana.org.au>
References: <1248274623-17158-1-git-send-email-ext-phil.2.carmody@nokia.com> <d6993c333f1a82367e6b0228f03e1ae2f5d5b9dd.1248272328.git.ext-phil.2.carmody@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50706 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbZGXF7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2009 01:59:53 -0400
Content-Disposition: inline
In-Reply-To: <d6993c333f1a82367e6b0228f03e1ae2f5d5b9dd.1248272328.git.ext-phil.2.carmody@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2009 at 05:57:03PM +0300, Phil Carmody wrote:
> It's undefined behaviour in C to write outside the bounds of an array.
> The key expansion routine takes a shortcut of creating 8 words at a
> time, but this creates 4 additional words which don't fit in the array.
> 
> As everyone is hopefully now aware, GCC is at liberty to make any
> assumptions and optimisations it likes in situations where it can
> detect that UB has occured, up to and including nasal demons, and
> as the indices being accessed in the array are trivially calculable,
> it's rash to invite gcc to do take any liberties at all.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
