From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] chtls: fix null dereference chtls_free_uld()
Date: Sat, 25 Aug 2018 21:27:50 +0800
Message-ID: <20180825132750.b2gogoloozjufjme@gondor.apana.org.au>
References: <1533905861-27339-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, indranil@chelsio.com, dt@chelsio.com,
        Atul Gupta <atul.gupta@chelsio.com>
To: Ganesh Goudar <ganeshgr@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533905861-27339-1-git-send-email-ganeshgr@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 10, 2018 at 06:27:41PM +0530, Ganesh Goudar wrote:
> call chtls_free_uld() only for the initialized cdev,
> this fixes NULL dereference in chtls_free_uld()
> 
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
