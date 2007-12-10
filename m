From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2]: salsa20_i586: Corrected order of source and destination buffers.
Date: Mon, 10 Dec 2007 15:53:55 +0800
Message-ID: <20071210075355.GC754@gondor.apana.org.au>
References: <fd3e431c0712080731w4ead1910gf16a256bc7e58ea9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3270 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182AbXLJHx6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 02:53:58 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712080731w4ead1910gf16a256bc7e58ea9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 08, 2007 at 11:31:30PM +0800, Tan Swee Heng wrote:
> The current salsa20_32.c called the salsa20_encrypt_bytes() function
> with the source and destination buffers in the wrong order. This patch
> corrects it.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Both patches applied.  Note that I've combined them with the
original patch to form a single commit.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
