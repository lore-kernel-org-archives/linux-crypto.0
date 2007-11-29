From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] tcrypt.h: AES CTR large test vector
Date: Fri, 30 Nov 2007 00:39:44 +1100
Message-ID: <20071129133943.GG8487@gondor.apana.org.au>
References: <fd3e431c0711271531odc6a554r1916e44bd60a7909@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3835 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755098AbXK2Njr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Nov 2007 08:39:47 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711271531odc6a554r1916e44bd60a7909@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 28, 2007 at 07:31:30AM +0800, Tan Swee Heng wrote:
> This patch adds a large AES CTR mode test vector. The test vector is
> 4100 bytes in size. It was generated using a C++ program that called
> Crypto++.
> 
> Note that this patch increases considerably the size of "struct
> cipher_testvec" and hence the size of tcrypt.ko.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  It's a good thing modules use vmalloc and tcrypt doesn't
have to stay loaded :)

Longer term we want to 

1) Split tcrypt into core and algorithm-specific chunks.  Have each
algorithm produce its own tcrypt module.

2) Change these staticly sized arrays to something a bit more flexible.

Hopefully your addition will actually prompt someone (other than me :)
to do these things.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
