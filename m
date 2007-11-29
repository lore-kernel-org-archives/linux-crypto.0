From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Possible bug in CTR (and Salsa20) for large test vectors
Date: Fri, 30 Nov 2007 00:26:15 +1100
Message-ID: <20071129132615.GE8487@gondor.apana.org.au>
References: <fd3e431c0711241207u462cacdfre0ca957cd16a6b58@mail.gmail.com> <fd3e431c0711250758k6cbfa13fja73f5298a4c356f4@mail.gmail.com> <20071126132153.GB27228@gondor.apana.org.au> <fd3e431c0711271509t38efef8aoa0fa1a59d24ffe39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3713 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756567AbXK2N0W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Nov 2007 08:26:22 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711271509t38efef8aoa0fa1a59d24ffe39@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 28, 2007 at 07:09:08AM +0800, Tan Swee Heng wrote:
>
> The final patch (combining yours and the two fixes) is attached to this email.

Thanks! I've added it to cryptodev-2.6.
 
> One question: Can we use crypto_cipher_encrypt_one() in both
> _segment() and _inplace()? It reads better than the function pointer
> fn().

Normally that's what we'd use.  However, these two functions are
performance-critical and reading the pointer out potentially
allows better optimisations since the compiler now knows that
we're calling the same function rather than potentially different
functions each time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
