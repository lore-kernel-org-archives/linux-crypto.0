From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx: use of_property_read_u32()
Date: Tue, 24 Nov 2015 18:24:29 +0800
Message-ID: <20151124102429.GC363@gondor.apana.org.au>
References: <1448272614-24337-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ddstreet@ieee.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Saurabh Sengar <saurabh.truth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448272614-24337-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 23, 2015 at 03:26:54PM +0530, Saurabh Sengar wrote:
> use of_propert_read_u32() for reading int value,
> it can help reducing number of variables used
> 
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
