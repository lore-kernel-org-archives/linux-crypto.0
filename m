From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-sha: constify x86_cpu_id
Date: Fri, 22 Sep 2017 18:15:21 +0800
Message-ID: <20170922101521.GM16270@gondor.apana.org.au>
References: <65b824f997b05b65cdd76e41d2e6dda631d5b684.1503685310.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <65b824f997b05b65cdd76e41d2e6dda631d5b684.1503685310.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 25, 2017 at 11:53:59PM +0530, Arvind Yadav wrote:
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
