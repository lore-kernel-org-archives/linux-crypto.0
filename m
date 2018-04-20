From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : chtls_cm - Fix potential NULL pointer
 dereferences
Date: Sat, 21 Apr 2018 00:51:07 +0800
Message-ID: <20180420165107.5opcf5tk2nbhxova@gondor.apana.org.au>
References: <20180403200912.GA25976@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Atul Gupta <atul.gupta@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180403200912.GA25976@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 03, 2018 at 03:09:12PM -0500, Gustavo A. R. Silva wrote:
> Add null checks on lookup_tid() return value in order to prevent
> null pointer dereferences.
> 
> Addresses-Coverity-ID: 1467422 ("Dereference null return value")
> Addresses-Coverity-ID: 1467443 ("Dereference null return value")
> Addresses-Coverity-ID: 1467445 ("Dereference null return value")
> Addresses-Coverity-ID: 1467449 ("Dereference null return value")
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
