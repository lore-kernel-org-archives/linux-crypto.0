From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 4 Aug 2008 22:04:35 +0800
Message-ID: <20080804140435.GA11227@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217844725.3454.580.camel@pmac.infradead.org> <1217846139.20845.25.camel@localhost.localdomain> <1217846726.3454.589.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Austin Zhang <austin_zhang@linux.intel.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59486 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359AbYHDOEq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 10:04:46 -0400
Content-Disposition: inline
In-Reply-To: <1217846726.3454.589.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 11:45:26AM +0100, David Woodhouse wrote:
> 
> Are we deprecating libcrc32c, then? Or just turning it into a wrapper
> around the crypto code?

It will be removed.

> Either way, does it really make sense to force all crc32 users to pull
> in the whole crypto framework? Some may get fractious about that...

There only three crc32c users in the kernel tree and the crypto
interface will serve the perfectly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
