Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189E2C1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 22:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAD2420738
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584483469;
	bh=sY4cOhcMEMawFpaLftRkDuoAZYkzfT6Iq/pDMIVQ+QM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Jk+0lnghDvfjl/nzGxFx7ENJQghzkFCHI5GRJEmdpQ43dsTncmYvVN+NQQdadLUwY
	 PZOqApoi+6X1vveodqQQzYlhojNzCeQ1gP09LrzfTeP10NK0V/Gi1nx9kdmPVY0Hla
	 vJseENEtMdKQQ5vG+bG/wmDIDWQzyELs3E6mZNDo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQWRt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 18:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgCQWRt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 18:17:49 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A73206EC;
        Tue, 17 Mar 2020 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584483468;
        bh=sY4cOhcMEMawFpaLftRkDuoAZYkzfT6Iq/pDMIVQ+QM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0QGP7zI9fM58OdTLqDxjLIcR2NDM+WwQ4MBisE/1SCYXBDjdNnC+PTF/305E5GyST
         kIqZVvbLlzYcUqBHggnCaCPlwSH7VtJqmiU8YuCYpkjEJG1LvNZnpjOCI11ZdmF4Ey
         0175SzJkfPb8KuTVROY2dRPony8hRwWy9EPhI0ys=
Date:   Tue, 17 Mar 2020 22:17:43 +0000
From:   Will Deacon <will@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ardb@kernel.org
Subject: Re: [Patch][Fix] crypto: arm{,64} neon: memzero_explicit aes-cbc key
Message-ID: <20200317221743.GD20788@willie-the-truck>
References: <20200313110258.94A0668C4E@verein.lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313110258.94A0668C4E@verein.lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Ard]

On Fri, Mar 13, 2020 at 12:02:58PM +0100, Torsten Duwe wrote:
> From: Torsten Duwe <duwe@suse.de>
> 
> At function exit, do not leave the expanded key in the rk struct
> which got allocated on the stack.
> 
> Signed-off-by: Torsten Duwe <duwe@suse.de>
> ---
> Another small fix from our FIPS evaluation. I hope you don't mind I merged
> arm32 and arm64 into one patch -- this is really simple.
> --- a/arch/arm/crypto/aes-neonbs-glue.c
> +++ b/arch/arm/crypto/aes-neonbs-glue.c
> @@ -138,6 +138,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>  	kernel_neon_begin();
>  	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
>  	kernel_neon_end();
> +	memzero_explicit(&rk, sizeof(rk));
>  
>  	return crypto_cipher_setkey(ctx->enc_tfm, in_key, key_len);
>  }
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
> index e3e27349a9fe..c0b980503643 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -151,6 +151,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>  	kernel_neon_begin();
>  	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
>  	kernel_neon_end();
> +	memzero_explicit(&rk, sizeof(rk));
>  
>  	return 0;
>  }

I'm certainly not a crypto person, but this looks sensible to me and I
couldn't find any other similar stack variable usage under
arch/arm64/crypto/ at a quick glance.

Acked-by: Will Deacon <will@kernel.org>

Will
