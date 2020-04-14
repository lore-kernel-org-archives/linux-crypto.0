Return-Path: <SRS0=2RfU=56=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290DBC2BA19
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Apr 2020 07:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E906C206E9
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Apr 2020 07:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="rpaI2zP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406709AbgDNHgo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:36:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53091 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbgDNHgn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Apr 2020 03:36:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 491ckH0Vbkz9sSG;
        Tue, 14 Apr 2020 17:36:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1586849799;
        bh=Z3MRAqxwicBr0S1w/2Qr9XiB1/u6yaHnOQXSasQJRHI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rpaI2zP2fU7SqG0Y9/40na1+0ilpHOKsMF/UfDUwWKr1hy3unjDVx67BBfGU1RU0e
         oGH6i0+X7wwSCcgqmZov+wzM8EDreszRVteyeZzjLk0rWfOjZtp7B8KzwIVeYMpW+J
         ACmj6QtqU7Ey0OmdCg5vIMzMcbfDUeaCVNBd/ea7pkDtJAjaJVQghm+j4tnVjLNwCj
         fHyndQbTkAwqsZAT97XerASPsE8QVXsH7b1xOm5s2NQvpb943ClSbnku2akDUcISN7
         1lhvbcd+XovyFkrPHxxd6ELMGXuGrz+iWaiPp5u2sJm/TXB8mayqjASOfFPXAWky2m
         qb+sIMQsyRzTQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/mpi: Fix building for powerpc with clang
In-Reply-To: <20200413195041.24064-1-natechancellor@gmail.com>
References: <20200413195041.24064-1-natechancellor@gmail.com>
Date:   Tue, 14 Apr 2020 17:36:52 +1000
Message-ID: <87blnujz6z.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> writes:
> 0day reports over and over on an powerpc randconfig with clang:
>
> lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
> inline asm context requiring an l-value: remove the cast or build with
> -fheinous-gnu-extensions
>
> Remove the superfluous casts, which have been done previously for x86
> and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
> commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
> x86").
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/991
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> Herbet seems to take lib/mpi patches but there does not seem to be a
> formal maintainer so Michael could take it since it is just a powerpc
> thing.

Oh you mean it's inside:

#if (defined(_ARCH_PPC) || defined(_IBMR2)) && W_TYPE_SIZE == 32


I don't mind taking it with Herbet's ack, or he could just merge it.

cheers


>
>  lib/mpi/longlong.h | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
> index 2dceaca27489..891e1c3549c4 100644
> --- a/lib/mpi/longlong.h
> +++ b/lib/mpi/longlong.h
> @@ -722,22 +722,22 @@ do {									\
>  do { \
>  	if (__builtin_constant_p(bh) && (bh) == 0) \
>  		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{aze|addze} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "%r" ((USItype)(ah)), \
>  		"%r" ((USItype)(al)), \
>  		"rI" ((USItype)(bl))); \
>  	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
>  		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{ame|addme} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "%r" ((USItype)(ah)), \
>  		"%r" ((USItype)(al)), \
>  		"rI" ((USItype)(bl))); \
>  	else \
>  		__asm__ ("{a%I5|add%I5c} %1,%4,%5\n\t{ae|adde} %0,%2,%3" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "%r" ((USItype)(ah)), \
>  		"r" ((USItype)(bh)), \
>  		"%r" ((USItype)(al)), \
> @@ -747,36 +747,36 @@ do { \
>  do { \
>  	if (__builtin_constant_p(ah) && (ah) == 0) \
>  		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfze|subfze} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "r" ((USItype)(bh)), \
>  		"rI" ((USItype)(al)), \
>  		"r" ((USItype)(bl))); \
>  	else if (__builtin_constant_p(ah) && (ah) == ~(USItype) 0) \
>  		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfme|subfme} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "r" ((USItype)(bh)), \
>  		"rI" ((USItype)(al)), \
>  		"r" ((USItype)(bl))); \
>  	else if (__builtin_constant_p(bh) && (bh) == 0) \
>  		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{ame|addme} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "r" ((USItype)(ah)), \
>  		"rI" ((USItype)(al)), \
>  		"r" ((USItype)(bl))); \
>  	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
>  		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{aze|addze} %0,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "r" ((USItype)(ah)), \
>  		"rI" ((USItype)(al)), \
>  		"r" ((USItype)(bl))); \
>  	else \
>  		__asm__ ("{sf%I4|subf%I4c} %1,%5,%4\n\t{sfe|subfe} %0,%3,%2" \
> -		: "=r" ((USItype)(sh)), \
> -		"=&r" ((USItype)(sl)) \
> +		: "=r" (sh), \
> +		"=&r" (sl) \
>  		: "r" ((USItype)(ah)), \
>  		"r" ((USItype)(bh)), \
>  		"rI" ((USItype)(al)), \
> @@ -787,7 +787,7 @@ do { \
>  do { \
>  	USItype __m0 = (m0), __m1 = (m1); \
>  	__asm__ ("mulhwu %0,%1,%2" \
> -	: "=r" ((USItype) ph) \
> +	: "=r" (ph) \
>  	: "%r" (__m0), \
>  	"r" (__m1)); \
>  	(pl) = __m0 * __m1; \
>
> base-commit: 8f3d9f354286745c751374f5f1fcafee6b3f3136
> -- 
> 2.26.0
