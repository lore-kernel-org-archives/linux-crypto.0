Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5532C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 01:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiGYB5V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 21:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGYB5U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 21:57:20 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE8BD63;
        Sun, 24 Jul 2022 18:57:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oFnLN-0046n1-0C; Mon, 25 Jul 2022 11:57:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Jul 2022 09:57:13 +0800
Date:   Mon, 25 Jul 2022 09:57:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, javier.martin@vista-silicon.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH v2] crypto: sahara - don't sleep when in softirq
Message-ID: <Yt34edMP7fCGUEwd@gondor.apana.org.au>
References: <20220725011324.383031-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725011324.383031-1-shaozhengchao@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 09:13:24AM +0800, Zhengchao Shao wrote:
> Function of sahara_aes_crypt maybe could be called by function
> of crypto_skcipher_encrypt during the rx softirq, so it is not
> allowed to use mutex lock.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> This patch is not yet tested, compiled only.
> ---
>  drivers/crypto/sahara.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> index 457084b344c1..c978d16dc609 100644
> --- a/drivers/crypto/sahara.c
> +++ b/drivers/crypto/sahara.c
> @@ -26,7 +26,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kthread.h>
>  #include <linux/module.h>
> -#include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>

Please keep the alphabetical order.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
