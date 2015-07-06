From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/10] crypto: tcrypt: Added speed tests for Async AEAD
 crypto alogrithms
Date: Mon, 6 Jul 2015 15:44:03 +0800
Message-ID: <20150706074403.GE20192@gondor.apana.org.au>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-11-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435814320-30347-11-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 02, 2015 at 10:48:40AM +0530, Lokesh Vutla wrote:
> Adding simple speed tests for a range of block sizes for Async AEAD crypto
> algorithms.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

What's wrong with the existing AEAD speed tests?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
