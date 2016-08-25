From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] chcr: Fix non static symbol warning
Date: Thu, 25 Aug 2016 12:22:24 +0800
Message-ID: <20160825042224.GC9906@gondor.apana.org.au>
References: <1471882278-25777-1-git-send-email-weiyj.lk@gmail.com>
 <20160824130651.GB2120@gondor.apana.org.au>
 <06364d6b-bc23-26dd-df2f-9a7ec165674a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55828 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753994AbcHYHDx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 03:03:53 -0400
Content-Disposition: inline
In-Reply-To: <06364d6b-bc23-26dd-df2f-9a7ec165674a@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 24, 2016 at 10:50:24PM +0800, Wei Yongjun wrote:
> Hi Herbert,
> 
> On 08/24/2016 09:06 PM, Herbert Xu wrote:
> > On Mon, Aug 22, 2016 at 04:11:18PM +0000, Wei Yongjun wrote:
> >> From: Wei Yongjun <weiyongjun1@huawei.com>
> >>
> >> Fixes the following sparse warning:
> >>
> >> drivers/crypto/chelsio/chcr_algo.c:593:5: warning:
> >>  symbol 'cxgb4_is_crypto_q_full' was not declared. Should it be static?
> >>
> >> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > Please repost this to netdev as the chelsio patches were applied
> > in the net tree.
> 
> This file only exists in net-next, not in netdev.
> http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/tree/drivers/crypto/chelsio/chcr_algo.c
> show not found.

I meant the netdev mailing list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
