Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BEDC43460
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 16:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2A2613C4
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 16:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEDQ6b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 May 2021 12:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhEDQ6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 May 2021 12:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B336112F;
        Tue,  4 May 2021 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620147456;
        bh=7xtXEJUggeEQTnglckkti+0y7zH44zmLRlGn4eJ23Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POXrpb22md3Gzgo2Tdj0M4U4LAOaoGmbUFzKkFlRlHCzxXbq4UhFXpyXp9biB7vwT
         26B7R2RL6kXXSoqe6ZT0J5UrMLBcNJn6/LzlIrOh/BC92EUyzKnv3jGZPi8RpeF8kd
         TPNCuFQtSKH9OSSPxlf9zLS7YmYs1XlqavRiKiyM7dL4iCw+z8zLtzi83O8PNK+7z5
         rEpe2yJRdW4oqsTaeAQz9lD7CeWO23ZYxmlMYX8MnTh7QZhzhVMHSrR170Aqi+nwIy
         hwx4jb/o8/SGN7RiAZt53FYHofj+v2IA05vFVwyvtUUVWcEf8/4wR9s3slKqVD/kT6
         l6qesFDYHJxlQ==
Date:   Tue, 4 May 2021 09:57:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: arc4: Implement a version optimized for
 memory usage
Message-ID: <YJF8/oaWUqZsWfOb@gmail.com>
References: <c52bd8972c9763c3fac685d7c6af3c46a23a1477.1619983555.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c52bd8972c9763c3fac685d7c6af3c46a23a1477.1619983555.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 02, 2021 at 09:29:46PM +0200, Christophe JAILLET wrote:
> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> +#define S_type	u8
> +#else
> +#define S_type	u32
> +#endif
> +
>  struct arc4_ctx {
> -	u32 S[256];
> +	S_type S[256];
>  	u32 x, y;
>  };

Is it actually useful to keep both versions?  It seems we could just use the u8
version everywhere.  Note that there aren't actually any unaligned memory
accesses, so choosing the version conditionally on
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS seems odd.  What are you trying to
determine by checking that?

- Eric
