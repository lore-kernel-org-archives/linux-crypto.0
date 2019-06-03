Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68677C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE09206BA
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559598447;
	bh=IZXCj5jxf9eAYQwNueq6BzltjAUhCFsFwTi0mTPxogE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ZMKgNe91mYG8+68jHD7V006JYA9GN6N5s4dHmH7hP2Ix2//YKEqMxQRSz9cxIygG8
	 bieBkbFvWiXI9su64WfkkT4X+Ob+kXZ4KjdvE3FpnknV1ORKOVRoqxSXPJ/WufDcBr
	 Uy1i+mdQWaAQNVy6USaQtxgASisriiJrQCWBOa30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFCVr0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 17:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbfFCVrZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 17:47:25 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E4224695;
        Mon,  3 Jun 2019 21:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559598093;
        bh=IZXCj5jxf9eAYQwNueq6BzltjAUhCFsFwTi0mTPxogE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ts63bHhoHjEwHoguPS98FOlJlHULP9xS3Oy1wcT2MEqZrFAeXOpn3JlufH7Eef2pe
         ebYDM7je/lskiEV548m5LQpSvFwVrW5LJtk/f/QJ2udr71wF1m41GGZCC3hyChJZMB
         u+bdKxm2Nu+VwtMbYyqwJpCcxnq+j6gRC4KL67I0=
Date:   Mon, 3 Jun 2019 14:41:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Maninder Singh <maninder1.s@samsung.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com, joe@perches.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com, v.narang@samsung.com
Subject: Re: [PATCH 1/4] zstd: pass pointer rathen than structure to
 functions
Message-Id: <20190603144132.7611b8fe3cf6928d8391a24a@linux-foundation.org>
In-Reply-To: <1559552526-4317-2-git-send-email-maninder1.s@samsung.com>
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc@epcas5p1.samsung.com>
        <1559552526-4317-2-git-send-email-maninder1.s@samsung.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon,  3 Jun 2019 14:32:03 +0530 Maninder Singh <maninder1.s@samsung.com> wrote:

> currently params structure is passed in all functions, which increases
> stack usage in all the function and lead to stack overflow on target like
> ARM with kernel stack size of 8 KB so better to pass pointer.
> 
> Checked for ARM:
> 
>                                 Original               Patched
> Call FLow Size:                  1264                   1040
> ....
> (HUF_sort)                      -> 296
> (HUF_buildCTable_wksp)          -> 144
> (HUF_compress4X_repeat)         -> 88
> (ZSTD_compressBlock_internal)   -> 200
> (ZSTD_compressContinue_internal)-> 136                  -> 88
> (ZSTD_compressCCtx)             -> 192                  -> 64
> (zstd_compress)                 -> 144                  -> 96
> (crypto_compress)               -> 32
> (zcomp_compress)                -> 32
> ....
> 
> ...
>
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -162,7 +162,7 @@ static int __zstd_compress(const u8 *src, unsigned int slen,
>  	struct zstd_ctx *zctx = ctx;
>  	const ZSTD_parameters params = zstd_params();
>  
> -	out_len = ZSTD_compressCCtx(zctx->cctx, dst, *dlen, src, slen, params);
> +	out_len = ZSTD_compressCCtx(zctx->cctx, dst, *dlen, src, slen, &params);
>  	if (ZSTD_isError(out_len))
>  		return -EINVAL;
>  	*dlen = out_len;
> diff --git a/include/linux/zstd.h b/include/linux/zstd.h
> index 249575e..5103efa 100644
> --- a/include/linux/zstd.h
> +++ b/include/linux/zstd.h
> @@ -254,7 +254,7 @@ ZSTD_CCtx *ZSTD_initCCtx(void *workspace, size_t workspaceSize);
>   *               ZSTD_isError().
>   */
>  size_t ZSTD_compressCCtx(ZSTD_CCtx *ctx, void *dst, size_t dstCapacity,
> -	const void *src, size_t srcSize, ZSTD_parameters params);
> +	const void *src, size_t srcSize, const ZSTD_parameters *params);

Making the params poniter const made review a lot easier ;)

But struct ZSTD_CCtx_s.params is still a copied structure.  Could we
make it `const ZSTD_parameters *params'?  Probably not, due to lifetime
issues?


