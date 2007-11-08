From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: Re: [PATCH] iSCSI fix endieness of digest to be network byte order
Date: Thu, 8 Nov 2007 09:18:49 +0800
Message-ID: <20071108011849.GA12428@gondor.apana.org.au>
References: <47320C54.10406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Mike Christie <michaelc@cs.wisc.edu>
To: Benny Halevy <bhalevy@panasas.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1720 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbXKHBTN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2007 20:19:13 -0500
Content-Disposition: inline
In-Reply-To: <47320C54.10406@panasas.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 07, 2007 at 07:04:52PM +0000, Benny Halevy wrote:
> Am I dreaming (or just sleep deprived ;), or crc32c swabs the crc
> one too many times on big-endian machines when CRC_LE_BITS != 1?

Your patch looks good to me since nobody in the kernel actually
uses the crc32c functions directly.

Please resend the patch with a change description + sign-off.

BTW you can get rid of the byteorder.h inclusion with the patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
