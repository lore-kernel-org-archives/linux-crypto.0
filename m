Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A33FC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 12:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20AB760295
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 12:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhKCMwj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:52:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhKCMwi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Nov 2021 08:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635943802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hr7JrJqfAirrxOYSrCThVjDh0z0IbomemnVKcOY9trc=;
        b=EIAdsJadkMyB5okEYDRLo1pwD57bGMEcfx9u9nbj76/Z6C+ybFvq14I7l7ZV0nwLVb2RNo
        TUvcg3ECtaYRaTg3RsxMt9f6RRFdFnIF8+cxI8OSgNuS//dMlrOSX1DtP07E6GkAvcQOUx
        c8f1IKAk/SHxY/W3FZIFUxUACxuH3V8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-uBw11zxpMteLvhQzKNkbkQ-1; Wed, 03 Nov 2021 08:49:54 -0400
X-MC-Unique: uBw11zxpMteLvhQzKNkbkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C936EC1A0;
        Wed,  3 Nov 2021 12:49:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C25065D9D3;
        Wed,  3 Nov 2021 12:49:49 +0000 (UTC)
Message-ID: <aa044725031407b86e7b6edf8a9426166242b8d4.camel@redhat.com>
Subject: Re: [PATCH] crypto: x86/aes-ni: fix AVX detection
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Date:   Wed, 03 Nov 2021 14:49:48 +0200
In-Reply-To: <20211103124614.499580-1-mlevitsk@redhat.com>
References: <20211103124614.499580-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2021-11-03 at 14:46 +0200, Maxim Levitsky wrote:
> Fix two semi-theoretical issues that are present.
> 
> 1. AVX is assumed to be present when AVX2 is present.
>  That can be false in a VM.
>  This can be considered a hypervisor bug,
>  but the kernel should not crash in this case if this is possible.
> 
> 2. YMM state can be soft disabled in XCR0.
> 
> Fix both issues by using 'cpu_has_xfeatures(XFEATURE_MASK_YMM')
> to check for usable AVX support.
> 
> Fixes: d764593af9249 ("crypto: aesni - AVX and AVX2 version of AESNI-GCM encode and decode")
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

I forgot to mention that Paolo Bonzini helped me with this patch,
especially with the way to detect XCR0 bits.

Best regards,
	Maxim Levitsky

> ---
>  arch/x86/crypto/aesni-intel_glue.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 0fc961bef299c..20db1e500ef6f 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1147,24 +1147,25 @@ static int __init aesni_init(void)
>  	if (!x86_match_cpu(aesni_cpu_id))
>  		return -ENODEV;
>  #ifdef CONFIG_X86_64
> -	if (boot_cpu_has(X86_FEATURE_AVX2)) {
> -		pr_info("AVX2 version of gcm_enc/dec engaged.\n");
> -		static_branch_enable(&gcm_use_avx);
> -		static_branch_enable(&gcm_use_avx2);
> -	} else
> -	if (boot_cpu_has(X86_FEATURE_AVX)) {
> -		pr_info("AVX version of gcm_enc/dec engaged.\n");
> +	if (cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL)) {
> +
>  		static_branch_enable(&gcm_use_avx);
> -	} else {
> -		pr_info("SSE version of gcm_enc/dec engaged.\n");
> -	}
> -	if (boot_cpu_has(X86_FEATURE_AVX)) {
> +
> +		if (boot_cpu_has(X86_FEATURE_AVX2)) {
> +			static_branch_enable(&gcm_use_avx2);
> +			pr_info("AVX2 version of gcm_enc/dec engaged.\n");
> +		} else {
> +			pr_info("AVX version of gcm_enc/dec engaged.\n");
> +		}
> +
>  		/* optimize performance of ctr mode encryption transform */
>  		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
>  		pr_info("AES CTR mode by8 optimization enabled\n");
> +
> +	} else {
> +		pr_info("SSE version of gcm_enc/dec engaged.\n");
>  	}
>  #endif
> -
>  	err = crypto_register_alg(&aesni_cipher_alg);
>  	if (err)
>  		return err;


