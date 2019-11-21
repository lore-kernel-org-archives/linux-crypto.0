Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DE7C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 22:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DAD206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 22:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Dgq75UxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUW4y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:56:54 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44915 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfKUW4y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 17:56:54 -0500
Received: by mail-pg1-f194.google.com with SMTP id e6so2373806pgi.11
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2019 14:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=51ePzUa5LZhbNRRNHcVyQNi+kbgLjJEObJHSIPI8Few=;
        b=Dgq75UxQKQ+n9NET5W+fmhvBZkoxdKTqUAfv3i6EjHKXau+tH7dXyJCOd7sKPCaReG
         mW+skl8fu0KzoLICwdl5cbOATztar7BuOO58zM+WbsOC3XwhVy+cspC+GMHTITXCjWS5
         q90o67NXvsAtLjPhEVq7UsaPuAI4gyTiehSBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=51ePzUa5LZhbNRRNHcVyQNi+kbgLjJEObJHSIPI8Few=;
        b=VOFEOKxSwhrQcV7r9fcMMwYVjYYbt7N7l7MqCOuP/mHk3R3ZjjS3yCEZH+RM3kXb4E
         9HL/BZNsC+C91Hn4xblFmEFgEORfiOvOuq9VTnZ95P5IDhoh3uOAwLI0FTneWI5RxTFl
         M6NUsBg3aZvF14zDIVnFuIeJeyPB3dzJGZRL4TDIFQqe+ugyR4M0YmbTrVNKMXMXDiG0
         c8l9NaJZlu3UQS0ro70WZrVqCZ5L0too5Y5Rr1mEhjyKeRGlqek1SBtfLP77kvqh6uoi
         7pH11inUUj/7NTl4ziCrfZEeMfwPZS+1Aro2IPEskj9GnsN3Q4vuqG3CYh4G/Oh9SF8u
         T1Aw==
X-Gm-Message-State: APjAAAWNVrSKRsJvt6+g51fK0dOhbgE4mmK0+0hdIORa//3OkxEg4oLX
        v09o+N+VhjPZGKPHp5vpGLTRhg==
X-Google-Smtp-Source: APXvYqyrHq4Mzk/fXpSWa5CCvgYUBoBsGM3Wwaxzr2MePcj67iCvIBaWCtGswXTvktiZaLE7kazz1w==
X-Received: by 2002:a63:2003:: with SMTP id g3mr12417392pgg.359.1574377013170;
        Thu, 21 Nov 2019 14:56:53 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z10sm4122210pgg.39.2019.11.21.14.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 14:56:51 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:56:50 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 3/8] crypto: x86/camellia: Remove glue function macro
 usage
Message-ID: <201911211456.CE356C2@keescook>
References: <20191113182516.13545-1-keescook@chromium.org>
 <20191113182516.13545-4-keescook@chromium.org>
 <20191113193911.GC221701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191113193911.GC221701@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 11:39:12AM -0800, Eric Biggers wrote:
> On Wed, Nov 13, 2019 at 10:25:11AM -0800, Kees Cook wrote:
> > In order to remove the callsite function casts, regularize the function
> > prototypes for helpers to avoid triggering Control-Flow Integrity checks
> > during indirect function calls. Where needed, to avoid changes to
> > pointer math, u8 pointers are internally cast back to u128 pointers.
> > 
> > Co-developed-by: João Moreira <joao.moreira@intel.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++------------
> >  arch/x86/crypto/camellia_aesni_avx_glue.c  | 74 ++++++++++------------
> >  arch/x86/crypto/camellia_glue.c            | 45 +++++++------
> >  arch/x86/include/asm/crypto/camellia.h     | 64 ++++++++-----------
> >  4 files changed, 119 insertions(+), 138 deletions(-)
> > 
> > diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > index a4f00128ea55..a68d54fc2dde 100644
> > --- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > +++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
> > @@ -19,20 +19,17 @@
> >  #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
> >  
> >  /* 32-way AVX2/AES-NI parallel cipher functions */
> > -asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> > -asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> > +asmlinkage void camellia_ecb_enc_32way(void *ctx, u8 *dst, const u8 *src);
> > +asmlinkage void camellia_ecb_dec_32way(void *ctx, u8 *dst, const u8 *src);
> >  
> > -asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src);
> > -asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				   const u8 *src, le128 *iv);
> > +asmlinkage void camellia_cbc_dec_32way(void *ctx, u8 *dst, const u8 *src);
> > +asmlinkage void camellia_ctr_32way(void *ctx, u8 *dst, const u8 *src,
> > +				   le128 *iv);
> >  
> > -asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src, le128 *iv);
> > -asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
> > -				       const u8 *src, le128 *iv);
> > +asmlinkage void camellia_xts_enc_32way(void *ctx, u8 *dst, const u8 *src,
> > +				       le128 *iv);
> > +asmlinkage void camellia_xts_dec_32way(void *ctx, u8 *dst, const u8 *src,
> > +				       le128 *iv);
> 
> As long as the type of all the 'ctx' arguments is being changed anyway, can you
> please make them const, as they should have been all along?  This applies to all
> the algorithms.  I.e., something like this:
> 
> [const diff]

Awesome, thanks! I've incorporated this into the series now. :)

-- 
Kees Cook
