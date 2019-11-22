Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D30C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 02:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14802206CB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574388495;
	bh=3TLVQnr9kSN+3NuE0Zx1VSvE1j1miP8Gef7UYqy9SNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hzGHomPxP9db6GkL4YutwO2N4YlPQ6sz4IP/QBY3m44kWaxzhAuXYd6Rbco0JKcxb
	 C5cdUWF4FQxCc0j1pWdcW85lOo5ivr/t9dVLXFM03FMG1lvYYhieeCNuBrDqN6Mhi1
	 nUcLjFqAjf+0Eg1DubA3+/qVjQjn7ahVhBjfoktE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfKVCIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 21:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfKVCIO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 21:08:14 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C702068F;
        Fri, 22 Nov 2019 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574388493;
        bh=3TLVQnr9kSN+3NuE0Zx1VSvE1j1miP8Gef7UYqy9SNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UW6tPp5GB8CqMJ/1mdSpooR0KZeaENiY7TrENwbRtI4Mn/J9cd3/ruedevbC+mfN4
         1d3UeUy2cbFbC6hqM9vdNgyDUOpVpqm7sm2se3l4l4b3lOZz/Ja6QN8Z/6p2nwSfqu
         UIVzOlMEnUjMHMg8619f3v+6M7oyMhZN3mbygH1U=
Date:   Thu, 21 Nov 2019 18:08:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 6/8] crypto: x86/aesni: Remove glue function macro
 usage
Message-ID: <20191122020812.GB32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
 <20191122010334.12081-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122010334.12081-7-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 21, 2019 at 05:03:32PM -0800, Kees Cook wrote:
> In order to remove the callsite function casts, regularize the function
> prototypes for helpers to avoid triggering Control-Flow Integrity checks
> during indirect function calls. Where needed, to avoid changes to
> pointer math, u8 pointers are internally cast back to u128 pointers.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/crypto/aesni-intel_asm.S  |  8 +++---
>  arch/x86/crypto/aesni-intel_glue.c | 45 ++++++++++++------------------
>  2 files changed, 22 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> index e40bdf024ba7..89e5e574dc95 100644
> --- a/arch/x86/crypto/aesni-intel_asm.S
> +++ b/arch/x86/crypto/aesni-intel_asm.S
> @@ -1946,7 +1946,7 @@ ENTRY(aesni_set_key)
>  ENDPROC(aesni_set_key)
>  
>  /*
> - * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
> + * void aesni_enc(void *ctx, u8 *dst, const u8 *src)
>   */

This doesn't exactly match the C prototype.

>  ENTRY(aesni_enc)
>  	FRAME_BEGIN
> @@ -2137,7 +2137,7 @@ _aesni_enc4:
>  ENDPROC(_aesni_enc4)
>  
>  /*
> - * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
> + * void aesni_dec (void *ctx, u8 *dst, const u8 *src)
>   */
>  ENTRY(aesni_dec)

Likewise.

>  	FRAME_BEGIN
> @@ -2726,8 +2726,8 @@ ENDPROC(aesni_ctr_enc)
>  	pxor CTR, IV;
>  
>  /*
> - * void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
> - *			 bool enc, u8 *iv)
> + * void aesni_xts_crypt8(void *ctx, u8 *dst, const u8 *src, bool enc,
> + *			 le128 *iv)
>   */

Likewise.  This one is particularly strange because the first argument was
changed to void * here, but in C it's 'const struct crypto_aes_ctx *ctx'.
 
- Eric
