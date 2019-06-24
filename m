Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC3AC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 04:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACA220679
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 04:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfFXEH3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 00:07:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52070 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfFXEH3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 00:07:29 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hfGGM-000441-N0; Mon, 24 Jun 2019 12:07:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hfGGK-0003eE-Ae; Mon, 24 Jun 2019 12:07:24 +0800
Date:   Mon, 24 Jun 2019 12:07:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Aditya Parekh <kerneladi@gmail.com>
Cc:     davem@davemloft.net, trivial@kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Crypto: fixed a comment coding style issue
Message-ID: <20190624040724.4te3ud3dtvshxanm@gondor.apana.org.au>
References: <20190623014000.2935-1-kerneladi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623014000.2935-1-kerneladi@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 22, 2019 at 09:40:00PM -0400, Aditya Parekh wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Aditya Parekh <kerneladi@gmail.com>
> ---
>  crypto/fcrypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
> index 4e8704405a3b..3828266af0b8 100644
> --- a/crypto/fcrypt.c
> +++ b/crypto/fcrypt.c
> @@ -306,7 +306,8 @@ static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key
>  
>  #if BITS_PER_LONG == 64  /* the 64-bit version can also be used for 32-bit
>  			  * kernels - it seems to be faster but the code is
> -			  * larger */
> +			  * larger
> +			  */
>  
>  	u64 k;	/* k holds all 56 non-parity bits */

Nack.  This patch doesn't improve the code at all.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
