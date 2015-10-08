From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel: Check for clk_prepare_enable() return
 value
Date: Thu, 8 Oct 2015 22:23:26 +0800
Message-ID: <20151008142325.GC25166@gondor.apana.org.au>
References: <1443787978-26624-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443787978-26624-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 02, 2015 at 02:12:58PM +0200, LABBE Corentin wrote:
> clk_prepare_enable() can fail so add a check for this and
> return the error code if it fails.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
