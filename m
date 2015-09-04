From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86/crypto/ghash-intel: specify context size for ghash
 async algorithm
Date: Fri, 4 Sep 2015 23:24:17 +0800
Message-ID: <20150904152417.GA10022@gondor.apana.org.au>
References: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
 <1441279921-26838-2-git-send-email-aryabinin@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
To: Andrey Ryabinin <aryabinin@odin.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40549 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbbIDPZD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Sep 2015 11:25:03 -0400
Content-Disposition: inline
In-Reply-To: <1441279921-26838-2-git-send-email-aryabinin@odin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 03, 2015 at 02:32:01PM +0300, Andrey Ryabinin wrote:
> Currently context size (cra_ctxsize) doesn't specified for
> ghash_async_alg. Which means it's zero. Thus crypto_create_tfm()
> doesn't allocate needed space for ghash_async_ctx, so any
> read/write to ctx (e.g. in ghash_async_init_tfm()) is not valid.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@odin.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
