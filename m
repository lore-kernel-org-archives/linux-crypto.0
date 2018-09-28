From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : chtls: remove redundant null pointer check
 before kfree_skb
Date: Fri, 28 Sep 2018 13:09:21 +0800
Message-ID: <20180928050921.m6eee4twxlp2oovt@gondor.apana.org.au>
References: <1537437436-43088-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, harsh@chelsio.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537437436-43088-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 05:57:16PM +0800, zhong jiang wrote:
> kfree_skb has taken the null pointer into account. hence it is safe
> to remove the redundant null pointer check before kfree_skb.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
