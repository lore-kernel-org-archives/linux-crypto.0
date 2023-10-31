Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA1BC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Oct 2023 13:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbjJaNTP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 09:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344452AbjJaNTO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 09:19:14 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D215E6
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 06:19:12 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1A8813F129
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698758351;
        bh=xQ1LVChD2C7G1Q9HJV1xfv3RT5SOZzgcjNNAFs0Kmno=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=nkeFF1XYkEzOWBF/8A8LgVG16wG3zvnmiwepugOzU8rpZfH8f3n+U7aIvAguRXFFn
         nLqUpoESHzH+SDPpSjduVf5VFHQj+Y+fRDDeoUXTb65tmoynXibZ8ZtKsEaYlHBSNe
         cQTNlDG8CHgPTLpALdXM55cJONb5VbcVlAe56SEoPnILMPkERdZiABcd+4x5H2czgz
         T3YqoN6ptMvsfVWgPlUN/nSRtaG40xvaAz3jlydPZKhPtH3R9peMoQdUnX6vG245kx
         rvnrapNSn1GPau5sHy+TuZRpfeHoQ8hwIwdgaKNFEmLXdiHeKS3QKCsgeVwaC20WSp
         IMafizasAi9yg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9d25d0788b8so171184566b.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 06:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698758350; x=1699363150;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQ1LVChD2C7G1Q9HJV1xfv3RT5SOZzgcjNNAFs0Kmno=;
        b=XfzNh+EuaNOiNmt6YOcC+FfrRt0pd4pabQKd6LUasQzr/6AhXWewqAeu8pAW6iX+Yc
         d/STUsq5HLsoRjwCaL2BSkpAlrTxtIT7KKLKiS1BF+KxiVbIA+R80+OHLT38X9MtcTjf
         EFTsQ8n8nHUYPFaNF6CV3O/pTTBGy0/c7tqCosPUTOCq0eKi6Wmlg1RBrQwBTrCyQLO2
         5kfmp2LsykTHPKnhrp78yTIarOAVQXIgqQiHZ8bVd+iyeeCjo91EzeL29+zQ4yTwYiz+
         AEYJ9Tlg/aslspaaAljqSKT2zM5NyHt4kVFStQ/9Yn7BUUTsEae4dumSFLdHRBSiL27g
         XDCg==
X-Gm-Message-State: AOJu0Yz5CPS6oJQNSSlymLgsGS0ouedwF5AYEDXcEWg9Xxk9dP6/IoSN
        4s0fODTmm8rf0mvO7+ZO1E931EGJg6nqlTf/ikhid6sXwe6yelu5SYt+6ZoDOECY+WNgdYcKnZ8
        w9DCm0FE0pLEm5NEeYW/KyoUWA3rBFc6GwJyn4SvJdw==
X-Received: by 2002:a17:907:1c25:b0:9ae:50e3:7e40 with SMTP id nc37-20020a1709071c2500b009ae50e37e40mr10757300ejc.52.1698758350680;
        Tue, 31 Oct 2023 06:19:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEm55lPblLBrefD7AlrP935q+lJPO0fxTIlCYa44XkJ2BglY0/OKYolk5xZn4YQU9z5ivjN8Q==
X-Received: by 2002:a17:907:1c25:b0:9ae:50e3:7e40 with SMTP id nc37-20020a1709071c2500b009ae50e37e40mr10757281ejc.52.1698758350351;
        Tue, 31 Oct 2023 06:19:10 -0700 (PDT)
Received: from [192.168.0.189] (77-169-125-32.fixed.kpn.net. [77.169.125.32])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709060e9000b009786c8249d6sm973306ejf.175.2023.10.31.06.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 06:19:09 -0700 (PDT)
Message-ID: <34843a86-6516-47d2-88dd-5ca0aa86a052@canonical.com>
Date:   Tue, 31 Oct 2023 14:19:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20231029051555.157720-1-ebiggers@kernel.org>
From:   Roxana Nicolescu <roxana.nicolescu@canonical.com>
Autocrypt: addr=roxana.nicolescu@canonical.com; keydata=
 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 Og==
In-Reply-To: <20231029051555.157720-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 29/10/2023 06:15, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The x86 SHA-256 module contains four implementations: SSSE3, AVX, AVX2,
> and SHA-NI.  Commit 1c43c0f1f84a ("crypto: x86/sha - load modules based
> on CPU features") made the module be autoloaded when SSSE3, AVX, or AVX2
> is detected.  The omission of SHA-NI appears to be an oversight, perhaps
> because of the outdated file-level comment.  This patch fixes this,
> though in practice this makes no difference because SSSE3 is a subset of
> the other three features anyway.  Indeed, sha256_ni_transform() executes
> SSSE3 instructions such as pshufb.
>
> Cc: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Indeed, it was an oversight.


Reviewed-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> ---
>   arch/x86/crypto/sha256_ssse3_glue.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index 4c0383a90e11..a135cf9baca3 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -1,15 +1,15 @@
>   /*
>    * Cryptographic API.
>    *
> - * Glue code for the SHA256 Secure Hash Algorithm assembler
> - * implementation using supplemental SSE3 / AVX / AVX2 instructions.
> + * Glue code for the SHA256 Secure Hash Algorithm assembler implementations
> + * using SSSE3, AVX, AVX2, and SHA-NI instructions.
>    *
>    * This file is based on sha256_generic.c
>    *
>    * Copyright (C) 2013 Intel Corporation.
>    *
>    * Author:
>    *     Tim Chen <tim.c.chen@linux.intel.com>
>    *
>    * This program is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU General Public License as published by the Free
> @@ -38,20 +38,21 @@
>   #include <crypto/sha2.h>
>   #include <crypto/sha256_base.h>
>   #include <linux/string.h>
>   #include <asm/cpu_device_id.h>
>   #include <asm/simd.h>
>   
>   asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
>   				       const u8 *data, int blocks);
>   
>   static const struct x86_cpu_id module_cpu_ids[] = {
> +	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
>   	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
>   	{}
>   };
>   MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
>   
>   static int _sha256_update(struct shash_desc *desc, const u8 *data,
>   			  unsigned int len, sha256_block_fn *sha256_xform)
>   {
>
> base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
