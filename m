Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F71AC05052
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 06:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbjHRGDZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 02:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357744AbjHRGDD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 02:03:03 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4230E1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2023 23:02:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWsZH-005C35-Ih; Fri, 18 Aug 2023 14:02:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 14:02:44 +0800
Date:   Fri, 18 Aug 2023 14:02:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lu Jialin <lujialin4@huawei.com>
Cc:     steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        lujialin4@huawei.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto:padata: Fix return err for PADATA_RESET
Message-ID: <ZN8JhAGuYlz3B+9j@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809125048.503619-1-lujialin4@huawei.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Lu Jialin <lujialin4@huawei.com> wrote:
> We found a hungtask bug in test_aead_vec_cfg as follows:
> 
> INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Call trace:
> __switch_to+0x98/0xe0
> __schedule+0x6c4/0xf40
> schedule+0xd8/0x1b4
> schedule_timeout+0x474/0x560
> wait_for_common+0x368/0x4e0
> wait_for_completion+0x20/0x30
> test_aead_vec_cfg+0xab4/0xd50
> test_aead+0x144/0x1f0
> alg_test_aead+0xd8/0x1e0
> alg_test+0x634/0x890
> cryptomgr_test+0x40/0x70
> kthread+0x1e0/0x220
> ret_from_fork+0x10/0x18
> Kernel panic - not syncing: hung_task: blocked tasks
> 
> For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
> wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
> case, aead_request_complete() will be called in pcrypt_aead_serial and the
> return err is 0 for padata_do_parallel. But, when pinst->flags is
> PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
> won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
> hung at wait_for_completion(&wait->completion), which will cause
> hungtask.
> 
> The problem comes as following:
> (padata_do_parallel)                 |
>    rcu_read_lock_bh();              |
>    err = -EINVAL;                   |   (padata_replace)
>                                     |     pinst->flags |= PADATA_RESET;
>    err = -EBUSY                     |
>    if (pinst->flags & PADATA_RESET) |
>        rcu_read_unlock_bh()         |
>        return err                   |
> 
> In order to resolve the problem, change the return err to -EINVAL when
> pinst->flags is set PADATA_RESET.
> 
> Signed-off-by: Lu Jialin <lujialin4@huawei.com>
> ---
> kernel/padata.c | 1 -
> 1 file changed, 1 deletion(-)

Thanks for the patch.

So the issue here is that the Crypto API uses EBUSY for a specific
purpose but padata uses it too and they're getting confused with
each other.

I think what we should do is get pcrypt to check the error value from
padata_do_parallel, and if it's EBUSY then change it to something
else.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
