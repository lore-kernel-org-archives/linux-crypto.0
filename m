Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED984C4708D
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 16:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjAFQHq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 11:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbjAFQHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 11:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4773C398;
        Fri,  6 Jan 2023 08:07:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECEB0B81CDC;
        Fri,  6 Jan 2023 16:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1C4C433EF;
        Fri,  6 Jan 2023 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673021255;
        bh=fErnzGHXYp7EafkqUofZ+/wlGIMUeDfiUn5oFwF8PJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rf5RCh3GLjZ44a5+pgObN4yfEQfuca85fWyqwY9CZgECrt2KCA95nL3BPxHrgxUDb
         +pvfRs8IjM839H91auovz6a/NnMZrvb5vAD+DKt9FJmUSlpznRfBaT1sEccgEjIBEM
         ZgW078wbxJSJMD9Tg2QBTWP7b46qFeWULbEb4GQRenp5jUCj6qYgdnF1E8Ze0l29ih
         X8QNZdNZmqep4Jvplq9Wumr2HR+zq+V7ibhRdJdOm1RGbvxYw3UJXqj1XF4VGELt51
         HFVjRATppE+eGlYmy5X5D3qJt2KyhOakr39U2a7Q8edvaazsYp3/sB5Q4zvd6/DcDh
         XfWEI0sSzSYPA==
Date:   Fri, 6 Jan 2023 09:07:33 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon: Wipe entire pool on error
Message-ID: <Y7hHRYUk6NypdZxT@dev-arch.thelio-3990X>
References: <20230106041945.never.831-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106041945.never.831-kees@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 05, 2023 at 08:19:48PM -0800, Kees Cook wrote:
> To work around a Clang __builtin_object_size bug that shows up under
> CONFIG_FORTIFY_SOURCE and UBSAN_BOUNDS, move the per-loop-iteration
> mem_block wipe into a single wipe of the entire pool structure after
> the loop.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1780
> Cc: Weili Qian <qianweili@huawei.com>
> Cc: Zhou Wang <wangzhou1@hisilicon.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks for the patch!

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

> ---
>  drivers/crypto/hisilicon/sgl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index 2b6f2281cfd6..0974b0041405 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -124,9 +124,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
>  	for (j = 0; j < i; j++) {
>  		dma_free_coherent(dev, block_size, block[j].sgl,
>  				  block[j].sgl_dma);
> -		memset(block + j, 0, sizeof(*block));
>  	}
> -	kfree(pool);
> +	kfree_sensitive(pool);
>  	return ERR_PTR(-ENOMEM);
>  }
>  EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
> -- 
> 2.34.1
> 
