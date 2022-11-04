Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56675C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 10:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiKDKm1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 06:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiKDKm0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 06:42:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D055BDD5
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 03:42:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso7803378pjg.5
        for <linux-crypto@vger.kernel.org>; Fri, 04 Nov 2022 03:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=afinTwlHwuk3XRN0Ie4Cj80KCTtrU3DzRUD464EZP/Q=;
        b=DlIwkCIzo7i5DVHMoFSypI+nEM7CCXOCmJbeILeZmL2s/aKu1Uz4bc4bwRLVeSntbn
         I4XlTfpvCFhjbEW+wTaZYDx6LpVAxW0SKOZlUBimKTXxETm3dcaT+hkECC5aVrg2d81i
         WRr+yrrss5bcT4bUlNkbvhgHCMFJjPfnIlAeFnN2bJHdJjMvqBpptbC5Nmw8NLgS4uQU
         I9PPZCzDu1PaKUt8fCeXM1afijKjLDWXrH6y9k7hglI89qsRcyarFcd9M642jPAWKLy2
         C0XK4TL7nQqBpI2ej5u197byn02YEHwCYzDWPkZLhLCU98CRygLpSbbfeTYCj6Ov8mWX
         qCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=afinTwlHwuk3XRN0Ie4Cj80KCTtrU3DzRUD464EZP/Q=;
        b=cEhrjjRd+8FeQ0I+Z23RU632qiE6Xjah7WN4hf6p3omSXzsZaAysaQobcWQjp97P7c
         eE7kQ9iyTNru6M78NNvWDKh5ZiOGkh7kB+FGcyDVbOfS5oZMyRcOgN1EMITbGQi0+EUV
         zRX8s23wy0xTPmnkJ7tD5J5Ry85tuBObr1EizFBghwliChxrmkzbeDKUJDW0BrL7W/lQ
         2PX+hBrOqRahzGjjlEurl5Vc4sRf7c06pgJJ5D9rVqmXBdh9p0TIpH5E4HGRbdqkDdkJ
         09Tf9qhQG/eA4t0PcLRN/KNmCI11QpKHahP6/RZzJgExdhd0GyT4/pcnhSisOR66ZLU/
         HDuw==
X-Gm-Message-State: ACrzQf3etdfE9DPQz8fC/KyS/bN+B2CPBtI07WQYuPYbpd0LaF+2r7y8
        Ffq8FcglvSFiCwfdClrFU+M=
X-Google-Smtp-Source: AMsMyM6Fku+SAGoYYHbuC7D0WztJWihZNZCPMG9iXKkLuEbc/UFik3CEDH8bwroinRuy+wlmtXU//Q==
X-Received: by 2002:a17:902:8a90:b0:186:b145:f5ec with SMTP id p16-20020a1709028a9000b00186b145f5ecmr35496034plo.103.1667558545294;
        Fri, 04 Nov 2022 03:42:25 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f40:98::16:16c])
        by smtp.gmail.com with ESMTPSA id r11-20020aa7962b000000b0056cc538baf0sm2380565pfg.114.2022.11.04.03.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 03:42:24 -0700 (PDT)
Message-ID: <e7bdd6dd-f698-aea5-c2f2-bb0aab7923fb@gmail.com>
Date:   Fri, 4 Nov 2022 19:42:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/2] crypto: aria: implement aria-avx512
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        jussi.kivilinna@iki.fi
References: <20221026052057.12688-1-ap420073@gmail.com>
 <20221026052057.12688-3-ap420073@gmail.com>
 <Y2TcH5CeGZxIpcnO@gondor.apana.org.au>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y2TcH5CeGZxIpcnO@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thank you so much for your review!

On 11/4/22 18:32, Herbert Xu wrote:
 > On Wed, Oct 26, 2022 at 05:20:57AM +0000, Taehee Yoo wrote:
 >>
 >> +		while (nbytes >= ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE) {
 >> +			u8 keystream[ARIA_GFNI_AVX512_PARALLEL_BLOCK_SIZE];
 >
 > This is too big for the stack.  Perhaps put it into the reqctx.
 >
 > Cheers,

Thanks, I will put the keystream array into the struct aria_ctx.

Thanks a lot!
Taehee Yoo
