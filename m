Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F9FECAAD2
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 06:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiH0GS2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 02:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiH0GS1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 02:18:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F116D8B0A
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:18:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h11-20020a17090a470b00b001fbc5ba5224so3889286pjg.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=P31a9O24nr7eOE10BJy2u4aOd/gHuvQj/9lvUiGUd/Y=;
        b=VVONwp8f7Rb4bW/HxRa4Z5J+xn6cU2MtMHaHaZRBGxjBGc0tsDo2w291cSr4+VlJpW
         0mptHNHVRKmLnMlgUOKfonV/aXZ2bPl3t2sQf9+Csg8sZQwxkw1DqtI2YZkf5bupLIct
         BtdMAUaBX5nrZSZJiqjDiQfPJvQiPOFclVC7V6m5PGJedIRdbJd0sTnLvlro+jRAo3GZ
         dT2R6N6E/3BuBW0Epx6FEESOCUzxyx6kCEfC3agJdMX8sgEUWECihCNCnLZdLpK6V7A4
         NL5owYHXV2TtnjNIBl/GKsQf0CAl+rsnB1YT7Yl2+5hO6ZDBo0dgFZajgTNSG3m1y8hO
         PCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=P31a9O24nr7eOE10BJy2u4aOd/gHuvQj/9lvUiGUd/Y=;
        b=s4yngMAz8RQyVZ1HqFhEmjRMnDEJfCY3wnFvTPA8A3FX45I2wYUW8BEbCHECHI5tEc
         IGdZrtkImIgjO5bxRyOYOsbzSj5HrKx/0QoPPqAiexZjJqALfv2ukLR0Ud7ZBFhSEgJa
         UgeImLONBGMfWlI8lejJjrdgDfcReGlM9QVww72dXxDLcie2KBb+ndu0wo9yUEjmivG2
         89EuMSgHUsUWGYn6k5O9pSwWp4Wos7NBBnTnWR/QP6EMLuMP6E+auL6ThKG4iZdwsZI6
         OaHk85/VIHE2pXEPYG76psUG/oVnMayfW7vklNs0dlt4bLWibdw87wm9RlNzFQv5DCtb
         jJwA==
X-Gm-Message-State: ACgBeo0idJo/krG+yZ/5RPbSdGi5jrYUNPsG4pVBEZdfmnki4MdVvhO6
        JmNxAmPVUbJMYTM1Yik6yy8=
X-Google-Smtp-Source: AA6agR7Bcw9PgAkQv3sbqDMfThh8NeWVcBFaO3Alo8iz3a8KuLRDVBBss9zaP+KEkXV7E5Rcqzs4JA==
X-Received: by 2002:a17:902:b086:b0:171:2632:cd3b with SMTP id p6-20020a170902b08600b001712632cd3bmr7097720plr.111.1661581106026;
        Fri, 26 Aug 2022 23:18:26 -0700 (PDT)
Received: from ?IPV6:2001:2d8:ee33:425e:2c9c:e338:d99e:acdc? ([2001:2d8:ee33:425e:2c9c:e338:d99e:acdc])
        by smtp.gmail.com with ESMTPSA id o66-20020a625a45000000b0053605d5e1adsm2869237pfb.206.2022.08.26.23.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 23:18:25 -0700 (PDT)
Message-ID: <258295d3-13af-db2c-d2c4-d571b6b44cd9@gmail.com>
Date:   Sat, 27 Aug 2022 15:18:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
 <MW5PR84MB1842DCF66CD8692D99545D98AB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <MW5PR84MB1842DCF66CD8692D99545D98AB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott, Robert
Thanks for your review!

2022. 8. 27. 오전 12:12에 Elliott, Robert (Servers) 이(가) 쓴 글:
 >
 >
 >> -----Original Message-----
 >> From: Taehee Yoo <ap420073@gmail.com>
 >> Sent: Friday, August 26, 2022 12:32 AM
 >> Subject: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 
assembler
 >> implementation of aria cipher
 >>
 >> v2:
 >>   - Do not call non-FPU functions(aria_{encrypt | decrypt}() in the
 >>     FPU context.
 >>   - Do not acquire FPU context for too long.
 >
 > ...
 >> +static int ecb_do_encrypt(struct skcipher_request *req, const u32 
*rkey)
 >> +{
 > ...
 >> +	while ((nbytes = walk.nbytes) > 0) {
 >> +		const u8 *src = walk.src.virt.addr;
 >> +		u8 *dst = walk.dst.virt.addr;
 >> +
 >> +		kernel_fpu_begin();
 >> +		while (nbytes >= ARIA_AVX_BLOCK_SIZE) {
 >> +			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
 >> +			dst += ARIA_AVX_BLOCK_SIZE;
 >> +			src += ARIA_AVX_BLOCK_SIZE;
 >> +			nbytes -= ARIA_AVX_BLOCK_SIZE;
 >> +		}
 >> +		kernel_fpu_end();
 >
 > Per Herbert's reply on the sha512-avx RCU stall issue, another nesting
 > level might be necessary limiting the amount of data processed between
 > each kernel_fpu_begin() to kernel_fpu_end() pair to 4 KiB.
 >
 > If you modify this driver to use the ECB_WALK_START, ECB_BLOCK, and
 > ECB_WALK_END macros from ecb_cbc_helpers.h and incorporate that fix,
 > then your fix would be easy to replicate into the other users (camellia,
 > cast5, cast6, serpent, and twofish).
 >

Now I understand why you suggested using ECB macro instead of open code.
I think your idea is nice for many users such as camellia, cast5, etc.

I will use ECB macro in the v3 patch.
Then, I will send a fixing the RCU stall issue patch separately instead 
of containing it.

Thanks a lot!
Taehee Yoo
