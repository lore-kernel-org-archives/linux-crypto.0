From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: api - use list_first_entry_or_null and
 list_next_entry
Date: Mon, 23 Nov 2015 21:01:08 +0800
Message-ID: <20151123130108.GA7866@gondor.apana.org.au>
References: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1c77a1fba395b9f7fa6fae64f639b98a5662735e.1447684469.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 16, 2015 at 10:37:14PM +0800, Geliang Tang wrote:
> Simplify crypto_more_spawns() with list_first_entry_or_null()
> and list_next_entry().
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
