From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata: add SPDX identifier
Date: Thu, 28 Dec 2017 17:53:27 +1100
Message-ID: <20171228065327.GA9066@gondor.apana.org.au>
References: <1513856130-7843-1-git-send-email-thrust73@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thrust73@gmail.com,
        pombredanne@nexb.com
To: Cheah Kok Cheong <thrust73@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48954 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbdL1Gxf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 01:53:35 -0500
Content-Disposition: inline
In-Reply-To: <1513856130-7843-1-git-send-email-thrust73@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cheah Kok Cheong <thrust73@gmail.com> wrote:
> Add SPDX license identifier according to the type of license text found
> in the file.
> 
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
> ---
> kernel/padata.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index e265953..eb9a9d9 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> /*
>  * padata.c - generic interface to process data streams in parallel
>  *

Steffen, are you OK with this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
