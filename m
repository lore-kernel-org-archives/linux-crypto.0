From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: akcipher: add crypto_akcipher_type methods
 needed by templates.
Date: Wed, 18 Nov 2015 08:05:47 +0800
Message-ID: <20151118000547.GB13894@gondor.apana.org.au>
References: <1447412495-4370-3-git-send-email-andrew.zaborowski@intel.com>
 <20151117134251.GA9363@gondor.apana.org.au>
 <CAOq732JGbGmHeBKX39ZRRdKvrqDhO6H7DinVBY8dGxvqqaUJ0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55155 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbbKRAFu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 19:05:50 -0500
Content-Disposition: inline
In-Reply-To: <CAOq732JGbGmHeBKX39ZRRdKvrqDhO6H7DinVBY8dGxvqqaUJ0A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 10:47:11PM +0100, Andrzej Zaborowski wrote:
>
> Will you then accept a patch to add a cra_u.akcipher to struct
> crypto_alg?  I see shash/ahash use one method to create instances and

No as struct crypto_alg is obsolete.

> blkcipher use another.  I have no way to know which of them is
> "obsolete" (possibly both) and that was the reason for sending an RFC
> first.

AEAD is the best example to use for templates.  It was recently
converted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
