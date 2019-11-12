Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23BAC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 22:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB04321D7F
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 22:56:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IsPQL/hU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKLW4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:56:49 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38748 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLW4s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 17:56:48 -0500
Received: by mail-pf1-f194.google.com with SMTP id c13so152242pfp.5
        for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2019 14:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zpJ/TMpVSKZy+JXxk/4c68rZdEAtB+OaqfRaFt77y6Y=;
        b=IsPQL/hU3IhF+qfkUCRWUrXYZheaE/5EOnSVDyJp/WnzWjkB3a7igBYUvpzviMn6L3
         EWwKMMcbTBSkE9j6+lM7cjybdedxFAxjw34SjY8xUmExgVx9vkxyfsA7HCeOc5ODgssQ
         WFs7WhwKK8SIMbSuP6MoGhI6aOCwmBoWjhHQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zpJ/TMpVSKZy+JXxk/4c68rZdEAtB+OaqfRaFt77y6Y=;
        b=TfGfuodjZzMIb2fWce5JJSEDW55sXzP+lz3DXxKcGjI3jsytT7E7/ndJ/LjNV50cWT
         Or0DiLDLq6HsIoS3PohxJHk7hcbKqxTRVT6XSF78UuM9PdBZszeQN5//07fve9kBxXNK
         HBdguiQrJT7GKqAeuF1HuCyAbYDHK7L15Sw7fpafkfmBPZNZyHqI3857HZMSK6WPXYgm
         7uXxhBp60AuIbpZSTjGtEGMZffT/Z+utNH0UBQ+SIXf8Sl8ly48RUvyMmIh78qnTuF+Q
         Jy4PoTZOnGuhjha8cplOTLAhL41U8nBNfa7FZW7GQ6Qxn4/JwOVC4F5qvkrnzz+tDb9l
         tlqw==
X-Gm-Message-State: APjAAAWY0psn6q3pEb1Y0hj0SSq7HVJBfuXrTpUlTksktzrs+gUJK1aJ
        GaLyFaBC4VCcdjvjXsF7mdNouA==
X-Google-Smtp-Source: APXvYqwVpIPBQ69m+AEur+RE+tA3ua9JIQo1zSDy5Qc9XKebf2oGEun7RjUMRnM+saiWqFyl65X22A==
X-Received: by 2002:a17:90a:d102:: with SMTP id l2mr363545pju.132.1573599406393;
        Tue, 12 Nov 2019 14:56:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e198sm18553pfh.83.2019.11.12.14.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:56:45 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:56:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 3/8] crypto: x86/camellia: Use new glue function macros
Message-ID: <201911121452.AE2672AECB@keescook>
References: <20191111214552.36717-1-keescook@chromium.org>
 <20191111214552.36717-4-keescook@chromium.org>
 <3059417.7DhL3USBNQ@positron.chronox.de>
 <20191112031417.GB1433@sol.localdomain>
 <20191112031635.jm32vne33qxh7ojh@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112031635.jm32vne33qxh7ojh@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 11:16:35AM +0800, Herbert Xu wrote:
> On Mon, Nov 11, 2019 at 07:14:17PM -0800, Eric Biggers wrote:
> >
> > Also, I don't see the point of the macros, other than to obfuscate things.  To
> > keep things straightforward, I think we should keep the explicit function
> > prototypes for each algorithm.
> 
> I agree.  Kees, please get rid of the macros.

Okay, if we do that, then we'll likely be dropping a lot of union logic
(since ecb and cbc end up with identical params and ctr and xts do too):

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
                                       le128 *iv);
typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
                                       le128 *iv);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union { 
                common_glue_func_t ecb;
                common_glue_cbc_func_t cbc;
                common_glue_ctr_func_t ctr;
                common_glue_xts_func_t xts;
        } fn_u;
};

These would end up being just:

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_iv_func_t)(void *ctx, u8 *dst, const u8 *src,
                                       le128 *iv);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union { 
                common_glue_func_t func;
                common_glue_iv_func_t iv_func;
        } fn_u;

Is that reasonable?

-- 
Kees Cook
