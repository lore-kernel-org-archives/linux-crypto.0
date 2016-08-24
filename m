From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH -next] chcr: Fix non static symbol warning
Date: Wed, 24 Aug 2016 22:50:24 +0800
Message-ID: <06364d6b-bc23-26dd-df2f-9a7ec165674a@gmail.com>
References: <1471882278-25777-1-git-send-email-weiyj.lk@gmail.com>
 <20160824130651.GB2120@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36490 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756591AbcHXOua (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 10:50:30 -0400
Received: by mail-pf0-f193.google.com with SMTP id y134so1367617pfg.3
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 07:50:30 -0700 (PDT)
In-Reply-To: <20160824130651.GB2120@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 08/24/2016 09:06 PM, Herbert Xu wrote:
> On Mon, Aug 22, 2016 at 04:11:18PM +0000, Wei Yongjun wrote:
>> From: Wei Yongjun <weiyongjun1@huawei.com>
>>
>> Fixes the following sparse warning:
>>
>> drivers/crypto/chelsio/chcr_algo.c:593:5: warning:
>>  symbol 'cxgb4_is_crypto_q_full' was not declared. Should it be static?
>>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Please repost this to netdev as the chelsio patches were applied
> in the net tree.

This file only exists in net-next, not in netdev.
http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/tree/drivers/crypto/chelsio/chcr_algo.c
show not found.

Regards,
Wei Yongjun
