Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33BCC4CED1
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 13:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F57F20873
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 13:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfJCNpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 09:45:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38416 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfJCNpT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 09:45:19 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iG1Pv-0000db-Hw; Thu, 03 Oct 2019 23:45:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Oct 2019 23:45:12 +1000
Date:   Thu, 3 Oct 2019 23:45:12 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, smueller@chronox.de,
        ayush.sawal@chelsio.com
Subject: Re: [Crypto chcr] crypto: af_alg - cast ki_complete call's ternary
 operator variables to long.
Message-ID: <20191003134512.GA31972@gondor.apana.org.au>
References: <20191003063231.8352-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003063231.8352-1-atul.gupta@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 11:32:31PM -0700, Atul Gupta wrote:
> The ki_complete called from af_alg_async_cb use ternary operator to get
> the value of second argument.As err is signed int while resultlen is
> unsigned int, by the precedence rule err is also processed as unsigned
> int and lose its original value.Hence, it is advised to cast both err
> and resultlen as long which is expected by the definition of ki_complete
> call as its 2nd argument. This will retain the original signed value of
> err.
> 
>  Declaration of ki_complete in file linux/include/linux/fs.h  in struct
> kiocb {...
> 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
> 	...
>  }
> 
>     Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  crypto/af_alg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index edca099..8e48d97 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1048,7 +1048,7 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
>  	af_alg_free_resources(areq);
>  	sock_put(sk);
>  
> -	iocb->ki_complete(iocb, err ? err : resultlen, 0);
> +	iocb->ki_complete(iocb, err ? (long)err : (long)resultlen, 0);

Why are you casting err when it's already signed? You can rewrite
it as

	err ?: (int)resultlen

Please also add a fixes header for the commit that introduced this
bug.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
