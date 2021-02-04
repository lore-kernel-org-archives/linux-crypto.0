Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8943C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 22:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A39E864FAC
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 22:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhBDWtq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 17:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhBDWtp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 17:49:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00ED64DF2;
        Thu,  4 Feb 2021 22:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612478945;
        bh=7QnK/aB3P7v5IBOvtzrGKwEUFve4+Dto18dDjO+8HLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/DLtBszbEmXjF281wBSMYWiRZDQpWLbNB1hCBU/WmWWmI91t0lNABmwDr+X9aJP0
         QhhLgwVoYvVFVA7rPv2x1DAS3u9KAJhKY0VXDKG/YQIFdeFxqEtctIoxRCiHBzvL5I
         V1iDbiBFQvkaVgZ/gBYdWuUNEVaUGwewKE5c1Kq6iZXrt2l0zl3zPcV7LaUnNrCRH2
         Q8ljHsJEmySu7NFfshF30NTTI5pij9sWH/e9rkTUYfTG0F5XUDjQ+9ohC+qH5Gj2cj
         lQ6XtAD6kOmVnEE6f/aCOYRyQVswghbEb045rL4IkM0somAhSEBthahOiU+qLZw1Y2
         h5jASoZtw0I4w==
Date:   Thu, 4 Feb 2021 14:48:41 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/11] crypto: qce: skcipher: Return error for zero
 length messages
Message-ID: <YBx5yWhKtT2EC2Ce@gmail.com>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
 <20210204214359.1993065-6-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204214359.1993065-6-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 04, 2021 at 04:43:53PM -0500, Thara Gopinath wrote:
> Crypto engine BAM dma does not support 0 length data. Return unsupported
> if zero length messages are passed for transformation.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/skcipher.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
> index de1f37ed4ee6..331b3c3a5b59 100644
> --- a/drivers/crypto/qce/skcipher.c
> +++ b/drivers/crypto/qce/skcipher.c
> @@ -8,6 +8,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/moduleparam.h>
>  #include <linux/types.h>
> +#include <linux/errno.h>
>  #include <crypto/aes.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/internal/skcipher.h>
> @@ -260,6 +261,10 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
>  	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
>  	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
>  
> +	/* CE does not handle 0 length messages */
> +	if (!req->cryptlen)
> +		return -EOPNOTSUPP;
> +

For the algorithms in question, the correct behavior is to return 0.

Aren't the tests catching that difference?

- Eric
