Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37407C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 051792070B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1dUl00q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfHSPpB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:45:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38668 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfHSPpB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 11:45:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id m125so2024077wmm.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rDzB2Zibu2YXXudL2YElzH6d1jj1SuOImetBIzIel50=;
        b=F1dUl00qmmd66H5j5IK12LmFOTQwyenWSuYAWbBbCWpZjNhmdK8gyHfNiLqh04quM2
         oyXXO5We3Rorbzb13nOX7E6Or9WU61i3yx+d/pCAHMvZPK73mQ+NaGrU7oUR8fa7csa6
         guOkh/FOQ11YobEhCMQrLB4fxd7v9zian11uhKw5tIoYvnDgFMvXviF8bfwu/ndhXVx/
         eTxseObSSBroh/h1mbDcgvnAT4X40LVCI8q+KDiydRKU1U41ZnRapMk4gODMfUFaBlYE
         OM3KLHHuhHnuvVYmTGjhaGquq/Umdr201EPtMMOtnZ1gjL2kdmzz+WJmLAyokrdZC3fE
         9ALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rDzB2Zibu2YXXudL2YElzH6d1jj1SuOImetBIzIel50=;
        b=KxhjPg3vue/C/L1dJuoLJa5dukkskfRj2x/HkSaiN8B8b2D9D45SjG3z5mVypnBcVE
         VEGXnd2A4FX4yqKmB/vQ5UOEx/vPdPcsiXrZTFNNT08YB3X2GmA0mPHR/Tr/dTprm6aq
         +K92QqnZGi9ZGcHYTr6EpFOU07ynopetdT3c+pUmSai7hDg+vGQCRKF9u9HVkVLw7GUx
         4ufzswZIX9u89NPc3Igbkjq4mtC998dNWfRbqnI/N3nBRWBWlrHNz8mdYU0YEqtDAZcY
         cT33OT/DnhPYefuNUHDlbt6YeRt6zeAGFUkiWMi8hOw3Nx+IHCdqX9Q6uqxpmrUOwBPM
         a6xA==
X-Gm-Message-State: APjAAAUBxgHjPlIKwZty3yNugMVik3T1C40EgszJxgLYvdv4SGoxE9K/
        OlIy9tl6oD6EfPGs6RAktH8=
X-Google-Smtp-Source: APXvYqw4rXDgVC3Pw4Xdm0HfIkyI3JIKynO6d6KVAfLVMkI+9cOjW3l27oDqNO3uEE/T/dqa7rkZ7g==
X-Received: by 2002:a1c:f20a:: with SMTP id s10mr22005739wmc.145.1566229498996;
        Mon, 19 Aug 2019 08:44:58 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id z12sm5399338wrt.92.2019.08.19.08.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 08:44:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 08:44:57 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: arm64/aegis128 - use explicit vector load for
 permute vectors
Message-ID: <20190819154457.GA108768@archlinux-threadripper>
References: <20190819141500.1070-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141500.1070-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 19, 2019 at 05:15:00PM +0300, Ard Biesheuvel wrote:
> When building the new aegis128 NEON code in big endian mode, Clang
> complains about the const uint8x16_t permute vectors in the following
> way:
> 
>   crypto/aegis128-neon-inner.c:58:40: warning: vector initializers are not
>       compatible with NEON intrinsics in big endian mode
>       [-Wnonportable-vector-initialization]
>                 static const uint8x16_t shift_rows = {
>                                                      ^
>   crypto/aegis128-neon-inner.c:58:40: note: consider using vld1q_u8() to
>       initialize a vector from memory, or vcombine_u8(vcreate_u8(), vcreate_u8())
>       to initialize from integer constants
> 
> Since the same issue applies to the uint8x16x4_t loads of the AES Sbox,
> update those references as well. However, since GCC does not implement
> the vld1q_u8_x4() intrinsic, switch from IS_ENABLED() to a preprocessor
> conditional to conditionally include this code.
> 
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I am not familiar enough with vectors and such to confidently give a
review but I can say this fixes the warning and doesn't introduce any
new ones. Thank you for the fix!

Tested-by: Nathan Chancellor <natechancellor@gmail.com>
