From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes: constify x86_cpu_id
Date: Fri, 22 Sep 2017 18:15:14 +0800
Message-ID: <20170922101514.GL16270@gondor.apana.org.au>
References: <b9707729957fe75e016b7f99d11d801e7d993027.1503685229.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b9707729957fe75e016b7f99d11d801e7d993027.1503685229.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 25, 2017 at 11:53:42PM +0530, Arvind Yadav wrote:
> x86_cpu_id are not supposed to change at runtime. MODULE_DEVICE_TABLE
> and x86_match_cpu are working with const x86_cpu_id. So mark the
> non-const x86_cpu_id structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
