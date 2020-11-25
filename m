Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CE9C56202
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 16:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E642168B
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 16:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rStl8SH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgKYQ41 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgKYQ41 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 11:56:27 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43125206D8;
        Wed, 25 Nov 2020 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606323386;
        bh=gvfELxtUVaQH1cIr3zNQqYq5mdQ1wuuXqsBh9wX7J9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rStl8SH7wb8IjEKSIFt61N8QHfvGBZSQw7VXhZ6gzt0ekRhRF0xJS16Po6UNtt+0A
         NEVs6qwBlhZTIPxs+A9Q57kyZSeb5rbLz1PpIWlgX1L/VBwFt5TkGXYFTQldfsWerT
         yribr0jVCZ6gC7FKUok3y4bWkP0gVuTZ20zxfWV8=
Date:   Wed, 25 Nov 2020 08:56:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com
Subject: Re: [PATCH] crypto: arm/aes-ce - work around Cortex-A72 erratum
 #1655431
Message-ID: <X76MuJmPvy6CeoBd@sol.localdomain>
References: <20201125072216.892-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125072216.892-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 25, 2020 at 08:22:16AM +0100, Ard Biesheuvel wrote:
> ARM Cortex-A72 cores running in 32-bit mode are affected by a silicon
> erratum (1655431: ELR recorded incorrectly on interrupt taken between
> cryptographic instructions in a sequence [0]) where the second instruction
> of a AES instruction pair may execute twice if an interrupt is taken right
> after the first instruction consumes an input register of which a single
> 32-bit lane has been updated the last time it was modified.
> 
> This is not such a rare occurrence as it may seem: in counter mode, only
> the least significant 32-bit word is incremented in the absence of a
> carry, which makes our counter mode implementation susceptible to the
> erratum.
> 
> So let's shuffle the counter assignments around a bit so that the most
> recent updates when the AES instruction pair executes are 128-bit wide.
> 
> [0] ARM-EPM-012079 v11.0 Cortex-A72 MPCore Software Developers Errata Notice
> 
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/aes-ce-core.S | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
> index 4d1707388d94..c0ef9680d90b 100644
> --- a/arch/arm/crypto/aes-ce-core.S
> +++ b/arch/arm/crypto/aes-ce-core.S
> @@ -386,20 +386,20 @@ ENTRY(ce_aes_ctr_encrypt)
>  .Lctrloop4x:
>  	subs		r4, r4, #4
>  	bmi		.Lctr1x
> -	add		r6, r6, #1
> +	add		ip, r6, #1
>  	vmov		q0, q7
> +	rev		ip, ip
> +	add		lr, r6, #2
> +	vmov		s31, ip
> +	add		ip, r6, #3
> +	rev		lr, lr
>  	vmov		q1, q7
> -	rev		ip, r6
> -	add		r6, r6, #1
> +	vmov		s31, lr
> +	rev		ip, ip
>  	vmov		q2, q7
> -	vmov		s7, ip
> -	rev		ip, r6
> -	add		r6, r6, #1
> +	vmov		s31, ip
> +	add		r6, r6, #4
>  	vmov		q3, q7
> -	vmov		s11, ip
> -	rev		ip, r6
> -	add		r6, r6, #1
> -	vmov		s15, ip
>  	vld1.8		{q4-q5}, [r1]!
>  	vld1.8		{q6}, [r1]!
>  	vld1.8		{q15}, [r1]!

Seems like this could use a comment that explains that things need to be done in
a certain way to avoid an erratum.

- Eric
