From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha512_ssse3: fix byte count to bit count
 conversion
Date: Wed, 25 Jun 2014 21:56:13 +0800
Message-ID: <20140625135613.GF10379@gondor.apana.org.au>
References: <20140623164105.13319.42220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45661 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbaFYN4Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:56:16 -0400
Content-Disposition: inline
In-Reply-To: <20140623164105.13319.42220.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 23, 2014 at 07:41:05PM +0300, Jussi Kivilinna wrote:
> Byte-to-bit-count computation is only partly converted to big-endian and is
> mixing in CPU-endian values. Problem was noticed by sparce with warning:
> 
>   CHECK   arch/x86/crypto/sha512_ssse3_glue.c
> arch/x86/crypto/sha512_ssse3_glue.c:144:19: warning: restricted __be64 degrades to integer
> arch/x86/crypto/sha512_ssse3_glue.c:144:17: warning: incorrect type in assignment (different base types)
> arch/x86/crypto/sha512_ssse3_glue.c:144:17:    expected restricted __be64 <noident>
> arch/x86/crypto/sha512_ssse3_glue.c:144:17:    got unsigned long long
> 
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
