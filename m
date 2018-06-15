From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chtls - use after free in chtls_pt_recvmsg()
Date: Fri, 15 Jun 2018 23:13:03 +0800
Message-ID: <20180615151303.gvj3es3jfepfmycs@gondor.apana.org.au>
References: <20180601075852.fn5hongkasesi2ep@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Werner <werner@chelsio.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601075852.fn5hongkasesi2ep@kili.mountain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 01, 2018 at 10:59:25AM +0300, Dan Carpenter wrote:
> We call chtls_free_skb() but then we dereference it on the next lines.
> Also "skb" can't be NULL, we just dereferenced it on the line before.
> 
> I have moved the free down a couple lines to fix this issue.
> 
> Fixes: 17a7d24aa89d ("crypto: chtls - generic handling of data and hdr")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
