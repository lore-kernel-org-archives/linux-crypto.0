From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/18] crypto: Add helper functions for parallelized
	LRW and XTS modes
Date: Wed, 9 Nov 2011 12:00:03 +0800
Message-ID: <20111109040003.GA19104@gondor.apana.org.au>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42686 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1KIEAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 23:00:06 -0500
Content-Disposition: inline
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 18, 2011 at 01:32:08PM +0300, Jussi Kivilinna wrote:
> This series adds lrw_crypt() and xts_crypt() functions for cipher implementations that
> can benefit from parallel cipher block operations. To make interface flexible, 
> caller is reponsible of allocating buffer large enough to store temporary cipher
> blocks. This buffer size should be as large as size of parallel blocks processed at
> once. Cryption callback is called with buffer size at maximum of parallel blocks size
> and at minimum size of one block.
> 
> Series adds LRW/XTS support to serpent-sse2 and twofish-x86_64-3way, and therefore
> depends on those series.
> 
> Patches 1-4: include LRW fixes/cleanups, export gf128mul table and add lrw_crypt().
> Patches 5-7: add LRW support to serpent-sse2, with tcrypt tests and test vectors.
> Patches 8-10: add LRW support to twofish-x86_64-3way, with tcrypt tests and test vectors.
> Patches 11-12: include XTS cleanup for blocksize usage and add xts_crypt().
> Patches 13-15: add XTS support to serpent-sse2, with tcrypt tests and test vectors.
> Patches 16-18: add XTS support to twofish-x86_64-3way, with tcrypt tests and test vectors.

All applied except for the serpent patches.  Please resend those
after you've fixed up the previous serpent patches.

I've also merged your later fixes into these.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
