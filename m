From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: tcrypt: Fix mixing printk/pr_err and obvious
 indentation issues
Date: Tue, 28 Jun 2016 16:37:34 +0800
Message-ID: <20160628083734.GC15985@gondor.apana.org.au>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 28, 2016 at 09:23:06AM +0200, Krzysztof Kozlowski wrote:
> The recently added test_mb_ahash_speed() has clearly serious coding
> style issues. Try to fix some of them:
> 1. Don't mix pr_err() and printk();
> 2. Don't wrap strings;
> 3. Properly align goto statement in if() block;
> 4. Align wrapped arguments on new line;
> 5. Don't wrap functions on first argument;
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
