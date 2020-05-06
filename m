Return-Path: <SRS0=2pnx=6U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D08C28CBC
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 05:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB06206E6
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 05:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWmLLBCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEFFMD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 01:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgEFFMD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 01:12:03 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC12CC061A0F;
        Tue,  5 May 2020 22:12:02 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id k110so407652otc.2;
        Tue, 05 May 2020 22:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3pa+z5yRoZ1c8FaD2cxTuWWdNrsrhZtS7/bufcqIM2A=;
        b=PWmLLBCe1epja7NdbWvKWCpCXb8eV2jAMIITdDD8EYvfA9prDmV4zALNL+a1M/Tcor
         MtrliG3sZwaHrFJd6MXwH23/50juTqWDiuDKmpgaQ+eBmyNzWC/2U+Qx+lSm1vzXy3dB
         Xo8lbSStne+aDK9/L6QOl5IDItGdPLQlWFuKCPVBtgLVgYBatm46hccMVrnTkiLzykbY
         5/ZcM+y+MtRD0iwIWdO/ZB3F1VARlwNtJyJgxqLmX4ld0AACUgrwrm/+jPqj3ghpx+Jv
         BfrXOx5N5y9wgncsdi6QmRh5EAe2djh/2BEiTon28M4XftzwF8cocMzGA/iwPZmmokne
         8gOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3pa+z5yRoZ1c8FaD2cxTuWWdNrsrhZtS7/bufcqIM2A=;
        b=Xt/HKuXaNhMW8LpV5GFrqQ/2mREXedCqUSqFfHGuX2QQ4J2THVXiVavmsSXo1XO/Dj
         gOiYRWwGUg8FA+kjLX9Z9Qunupw5QPmDDE5HzIkVv57EIp0berII/BT/JHJja7eOq4Zd
         gPUV41Tz/zi366s199fUuSzgzQV2ILVFvoiQFHV4jH0isIodxweDgpAPbBxWj880Xk3p
         uIn6awK/eUA3TFkZOzCLAkH09iwu7iAc6lDol/rHaenx4XTLKalDP4XxVd2g1ie23jQ+
         1SoJWo909bM0Cw1Vq2CIhYwof8o3JPlCjDk8+LhoLBJMmOxN2EEGXpuF05Szv8BARgi2
         f7OQ==
X-Gm-Message-State: AGi0Pua7uey/ziaEmAYKhItw4VJ1p7fZaS39qAVN8Jc1Zc4jz+kDxNKN
        T5zl8u5M35WRgHD598mcKIU=
X-Google-Smtp-Source: APiQypL6DCRhQ+E6SYpUR7ZBDm8fdazSrL/wFlCv9H93Q0uTCBdjfpcS5A+FbZcjfN3/U3did81qqA==
X-Received: by 2002:a05:6830:225d:: with SMTP id t29mr4881623otd.125.1588741922299;
        Tue, 05 May 2020 22:12:02 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id h65sm298950oth.34.2020.05.05.22.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 22:12:01 -0700 (PDT)
Date:   Tue, 5 May 2020 22:12:00 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Sterba <dsterba@suse.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: blake2b - Fix clang optimization for ARMv7-M
Message-ID: <20200506051200.GA831492@ubuntu-s3-xlarge-x86>
References: <20200505135402.29356-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505135402.29356-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 05, 2020 at 03:53:45PM +0200, Arnd Bergmann wrote:
> When building for ARMv7-M, clang-9 or higher tries to unroll some loops,
> which ends up confusing the register allocator to the point of generating
> rather bad code and using more than the warning limit for stack frames:
> 
> warning: stack frame size of 1200 bytes in function 'blake2b_compress' [-Wframe-larger-than=]
> 
> Forcing it to not unroll the final loop avoids this problem.
> 
> Fixes: 91d689337fe8 ("crypto: blake2b - add blake2b generic implementation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/blake2b_generic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
> index 1d262374fa4e..0ffd8d92e308 100644
> --- a/crypto/blake2b_generic.c
> +++ b/crypto/blake2b_generic.c
> @@ -129,7 +129,9 @@ static void blake2b_compress(struct blake2b_state *S,
>  	ROUND(9);
>  	ROUND(10);
>  	ROUND(11);
> -
> +#ifdef CONFIG_CC_IS_CLANG

Given your comment in the bug:

"The code is written to assume no loops are unrolled"

Does it make sense to make this unconditional and take compiler
heuristics out of it?

> +#pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
> +#endif
>  	for (i = 0; i < 8; ++i)
>  		S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
>  }
> -- 
> 2.26.0
> 
