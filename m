From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chtls: generic handling of data and hdr
Date: Sun, 27 May 2018 00:25:40 +0800
Message-ID: <20180526162540.wxudu5nsnstzenn6@gondor.apana.org.au>
References: <1526296298-30183-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Harsh Jain <harsh@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526296298-30183-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 14, 2018 at 04:41:38PM +0530, Atul Gupta wrote:
> removed redundant check and made TLS PDU and header recv
> handling common as received from HW.
> Ensure that only tls header is read in cpl_rx_tls_cmp
> read-ahead and skb is freed when entire data is processed.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Harsh Jain <harsh@chelsio.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
