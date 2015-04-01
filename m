From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-aes: Fix support for unequal lengths
Date: Wed, 1 Apr 2015 22:24:39 +0800
Message-ID: <20150401142439.GB28651@gondor.apana.org.au>
References: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
 <1427775745-4674-3-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, nsekhar@ti.com, t-kristo@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427775745-4674-3-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 31, 2015 at 09:52:25AM +0530, Lokesh Vutla wrote:
> For cases where total length of an input SGs is not same as
> length of the input data for encryption, omap-aes driver
> crashes. This happens in the case when IPsec is trying to use
> omap-aes driver.
> 
> To avoid this, we copy all the pages from the input SG list
> into a contiguous buffer and prepare a single element SG list
> for this buffer with length as the total bytes to crypt, which is
> similar thing that is done in case of unaligned lengths.
> 
> Fixes: 6242332ff2f3 ("crypto: omap-aes - Add support for cases of unaligned lengths")
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
