Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FA2C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 20:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB911600CC
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 20:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhCAUhV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241831AbhCAUdy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DCC66023C;
        Mon,  1 Mar 2021 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614624445;
        bh=0DlrWYj/bDt5bt3NPev9NpNg2Qh/3IIllLDP6ON9/iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYWNoMpAKvGsjPirsIul9RrB4MYn+LGdt4VyWWbKmH96i9rk9JawWfmAHURsJHq/G
         tRjX/sEov6mp6NgzKT62ta0uHXeG05QfwTH5TZxHp94nJUHxZtateRk/och1elCS6Y
         bYcm0BseUUzSvS+rcjaT8iVFd06cBb/K2hCMogdkubNcF/24KfJwWzQ/jp9uPVPXbt
         mvzzrJcB2q3GuDZL3vwl8fDUPQVUT/no6ZC9rXkj5he+efiUEUR5wiqmkvMXzM1BOZ
         BDsFuKaDrA62SoIU6AkJLWEX+LHlfFJz0PewEqFFldqpFDN5yTBaI8PwN0BRV+t9Tj
         mqi+JtoRSN04w==
Date:   Mon, 1 Mar 2021 10:47:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: expose needs_key in procfs
Message-ID: <YD02vJhFkFiARX0q@gmail.com>
References: <20210301165917.2576180-1-christoph.boehmwalder@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210301165917.2576180-1-christoph.boehmwalder@linbit.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 01, 2021 at 05:59:17PM +0100, Christoph Böhmwalder wrote:
> Currently, it is not apparent for userspace users which hash algorithms
> require a key and which don't. We have /proc/crypto, so add a field
> with this information there.
> 
> Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
> 
> ---
>  crypto/shash.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 2e3433ad9762..d3127a0618f2 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -477,6 +477,9 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
>  	seq_printf(m, "type         : shash\n");
>  	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
>  	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
> +	seq_printf(m, "needs key    : %s\n",
> +		   crypto_shash_alg_needs_key(salg) ?
> +		   "yes" : "no");
>  }
>  

Do you have a specific use case in mind for this information?  Normally, users
should already know which algorithm they want to use (or set of algorithms they
might want to use).

Also, what about algorithms of type "ahash"?  Shouldn't this field be added for
them too?

Also, what about algorithms such as blake2b-256 which optionally take a key (as
indicated by CRYPTO_ALG_OPTIONAL_KEY being set)?  So it's not really "yes" or
"no"; there is a third state as well.

- Eric
