Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:52898 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbeK2RtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 12:49:07 -0500
Date: Thu, 29 Nov 2018 14:44:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "gongchen (E)" <gongchen4@huawei.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Chencheng (J)" <beyond.chen@huawei.com>,
        "Yangjie (R)" <yangjie234@huawei.com>,
        Fengzhiqiang <fengzhiqiang.feng@huawei.com>,
        "shengyong (A)" <shengyong1@huawei.com>,
        "Luoxinqiang (CBG)" <luoxinqiang2@huawei.com>,
        "lipengcheng (C)" <lipengcheng8@huawei.com>
Subject: Re: [Help] Null pointer exception in scatterwalk_start() in
 kernel-4.9
Message-ID: <20181129064445.x5pkqjqe5uy5wnsy@gondor.apana.org.au>
References: <780FCA0995E39E408348187D2462E36A01557596@dggeml509-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <780FCA0995E39E408348187D2462E36A01557596@dggeml509-mbx.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 20, 2018 at 07:09:53AM +0000, gongchen (E) wrote:
> Hi Dear Herbert,
> 
>             Sorry to bother you , but we’ve met a problem in crypto module, would you please kindly help us look into it ? Thank you very much.
> 
>              In the below function chain, scatterwalk_start() doesn't check the result of sg_next(), so the kernel will crash if sg_next() returns a null pointer, which is our case. (The full stack is at the end of letter)
>              blkcipher_walk_done()->scatterwalk_done()->scatterwalk_pagedone()->scatterwalk_start(walk, sg_next(walk->sg));
>             
>             Should we add a null-pointer-check in scatterwalk_start()? Or is there any process can ensure that there should be a valid sg pointer if the condition (walk->offset >= walk->sg->offset + walk->sg->length) is true?
>                       
>             We are really looking forward to your reply, any information will be appreciated , thanks again.

Did you apply the following patch?

commit 0868def3e4100591e7a1fdbf3eed1439cc8f7ca3
Author: Eric Biggers <ebiggers@google.com>
Date:   Mon Jul 23 10:54:57 2018 -0700

    crypto: blkcipher - fix crash flushing dcache in error path

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
