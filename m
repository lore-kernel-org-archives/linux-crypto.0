From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] chcr: Fix non static symbol warning
Date: Wed, 24 Aug 2016 21:06:51 +0800
Message-ID: <20160824130651.GB2120@gondor.apana.org.au>
References: <1471882278-25777-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59177 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756020AbcHXOFH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 10:05:07 -0400
Content-Disposition: inline
In-Reply-To: <1471882278-25777-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 22, 2016 at 04:11:18PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fixes the following sparse warning:
> 
> drivers/crypto/chelsio/chcr_algo.c:593:5: warning:
>  symbol 'cxgb4_is_crypto_q_full' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Please repost this to netdev as the chelsio patches were applied
in the net tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
