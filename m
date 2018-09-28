From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: remove redundant null pointer check
 before kfree
Date: Fri, 28 Sep 2018 13:09:58 +0800
Message-ID: <20180928050958.gpbgh7r2canffij6@gondor.apana.org.au>
References: <1537536615-46814-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, george.cherian@cavium.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537536615-46814-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 21, 2018 at 09:30:15PM +0800, zhong jiang wrote:
> kfree has taken the null pointer into account. hence it is safe
> to remove the redundant null pointer check before kfree.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
