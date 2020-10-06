Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5960AC46466
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 08:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E382078E
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 08:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601972878;
	bh=m+YONX5DTHAK2AEO77BcXWasjn+CyrqoLTOeN3cRhDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ot3An41PSiUce7rE5X9Wba2lq1LGDdj/iNlC9HdTMvy1q4/Nuj1gWq3cfMGJFhE4f
	 KkQbr3fuG6W34Elw5dTRGNU0ToJikr7AChMFCpaLupPkWChYpZ0v2YrTIAN4u7ouk+
	 sVoR07YK12iMi8B40Xb6+MOuN7H/CB5aswrWO0F4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgJFI1y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 04:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJFI1y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 04:27:54 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 493B82078E;
        Tue,  6 Oct 2020 08:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601972874;
        bh=m+YONX5DTHAK2AEO77BcXWasjn+CyrqoLTOeN3cRhDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hfpnsDE0NuEXXCm+pW/AXOuvn13l1yww2vtFrzcKvR6NBmd4sfRThWDDV3lw9jBOv
         r7C9Zjx6YFPY34l7otBKgu5wWD+iF4uO+3/X4oTeCebN5lYZQdPgDqb5AySSUjMcat
         C3JSi+s+1T+81JUqV98Gcrr9h2air8eV2tyUwO1U=
Date:   Tue, 6 Oct 2020 09:27:48 +0100
From:   Will Deacon <will@kernel.org>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        broonie@kernel.org, ardb@kernel.org, catalin.marinas@arm.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH] crypto: arm64: Avoid indirect branch to bti_c
Message-ID: <20201006082748.GB25305@willie-the-truck>
References: <20201006034854.2277538-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006034854.2277538-1-jeremy.linton@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 05, 2020 at 10:48:54PM -0500, Jeremy Linton wrote:
> The AES code uses a 'br x7' as part of a function called by
> a macro. That branch needs a bti_j as a target. This results
> in a panic as seen below. Instead of trying to replace the branch
> target with a bti_jc, lets replace the indirect branch with a
> bl/ret, bl sequence that can target the existing bti_c.
> 
>   Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
>   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>   pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
>   pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>   lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>   sp : ffff80001052b730
> 
>   aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>    __xts_crypt+0xb0/0x2dc [aes_neon_bs]
>    xts_encrypt+0x28/0x3c [aes_neon_bs]
>   crypto_skcipher_encrypt+0x50/0x84
>   simd_skcipher_encrypt+0xc8/0xe0
>   crypto_skcipher_encrypt+0x50/0x84
>   test_skcipher_vec_cfg+0x224/0x5f0
>   test_skcipher+0xbc/0x120
>   alg_test_skcipher+0xa0/0x1b0
>   alg_test+0x3dc/0x47c
>   cryptomgr_test+0x38/0x60
> 
> Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")

nit: the "commit" string shouldn't be here, and I think the linux-next
scripts will yell at us if we don't remove it.

> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  arch/arm64/crypto/aes-neonbs-core.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index b357164379f6..32f53ebe5e2c 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
>  
>  0:	mov		bskey, x21
>  	mov		rounds, x22
> -	br		x7
> +	ret
>  SYM_FUNC_END(__xts_crypt8)
>  
>  	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
> @@ -806,8 +806,8 @@ SYM_FUNC_END(__xts_crypt8)
>  	uzp1		v30.4s, v30.4s, v25.4s
>  	ld1		{v25.16b}, [x24]
>  
> -99:	adr		x7, \do8
> -	bl		__xts_crypt8
> +99:	bl		__xts_crypt8
> +	bl 		\do8
>  
>  	ldp		q16, q17, [sp, #.Lframe_local_offset]
>  	ldp		q18, q19, [sp, #.Lframe_local_offset + 32]

Acked-by: Will Deacon <will@kernel.org>

Catalin -- can you pick this for 5.9 please?

Will
