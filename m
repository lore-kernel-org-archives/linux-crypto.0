Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1C7C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 379ED23A51
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbgLRKMl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 05:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733175AbgLRKMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 05:12:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC29C0617A7;
        Fri, 18 Dec 2020 02:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q457vqRhGVY+DCXnSpRFWh1rrM5zU5I1XZakIw5Qxyg=; b=bBja/AtMC1lfOxpkFLdH6GYYvu
        KslWDhPvHn2uD55eB8U8GkgQe0c23Oki+luzz6mvRSH5XHk41bAb8yqNfMYgFZjN73bt/6sOb8fT4
        eU1/41fYqVFh7Y4THiPGR5nKj7vwodq1QLUSzhaE+ZcPYUGmfXqRAvbWI9jdCdSpJTaGjWFoPp1Xi
        evIQsbp67yIcgRCcBlhzexHaBSoMmgLpqBdBlYTQt1N/tYAK+ob+rsoBmGTvvzPLZpfeVLxPP95yP
        3SCHjMIfX11pptP3IKT5DytYiHaLKwL5ZGnHqD8P4NybhiXS97NQMt3PmQ6aWhvfLiU0HW+O4bTc9
        fFjVD9xg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqCjm-0004Br-7e; Fri, 18 Dec 2020 10:11:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 02600300446;
        Fri, 18 Dec 2020 11:11:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E179C200E592B; Fri, 18 Dec 2020 11:11:48 +0100 (CET)
Date:   Fri, 18 Dec 2020 11:11:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Message-ID: <20201218101148.GF3021@hirez.programming.kicks-ass.net>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216174146.10446-8-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 09:41:45AM -0800, Chang S. Bae wrote:
> diff --git a/arch/x86/include/asm/inst.h b/arch/x86/include/asm/inst.h
> index bd7f02480ca1..b719a11a2905 100644
> --- a/arch/x86/include/asm/inst.h
> +++ b/arch/x86/include/asm/inst.h
> @@ -122,9 +122,62 @@
>  #endif
>  	.endm
>  
> +	.macro XMM_NUM opd xmm
> +	\opd = REG_NUM_INVALID
> +	.ifc \xmm,%xmm0
> +	\opd = 0
> +	.endif
> +	.ifc \xmm,%xmm1
> +	\opd = 1
> +	.endif
> +	.ifc \xmm,%xmm2
> +	\opd = 2
> +	.endif
> +	.ifc \xmm,%xmm3
> +	\opd = 3
> +	.endif
> +	.ifc \xmm,%xmm4
> +	\opd = 4
> +	.endif
> +	.ifc \xmm,%xmm5
> +	\opd = 5
> +	.endif
> +	.ifc \xmm,%xmm6
> +	\opd = 6
> +	.endif
> +	.ifc \xmm,%xmm7
> +	\opd = 7
> +	.endif
> +	.ifc \xmm,%xmm8
> +	\opd = 8
> +	.endif
> +	.ifc \xmm,%xmm9
> +	\opd = 9
> +	.endif
> +	.ifc \xmm,%xmm10
> +	\opd = 10
> +	.endif
> +	.ifc \xmm,%xmm11
> +	\opd = 11
> +	.endif
> +	.ifc \xmm,%xmm12
> +	\opd = 12
> +	.endif
> +	.ifc \xmm,%xmm13
> +	\opd = 13
> +	.endif
> +	.ifc \xmm,%xmm14
> +	\opd = 14
> +	.endif
> +	.ifc \xmm,%xmm15
> +	\opd = 15
> +	.endif
> +	.endm
> +
>  	.macro REG_TYPE type reg
>  	R32_NUM reg_type_r32 \reg
>  	R64_NUM reg_type_r64 \reg
> +	XMM_NUM reg_type_xmm \reg
>  	.if reg_type_r64 <> REG_NUM_INVALID
>  	\type = REG_TYPE_R64
>  	.elseif reg_type_r32 <> REG_NUM_INVALID
> @@ -134,6 +187,14 @@
>  	.endif
>  	.endm
>  
> +	.macro PFX_OPD_SIZE
> +	.byte 0x66
> +	.endm
> +
> +	.macro PFX_RPT
> +	.byte 0xf3
> +	.endm
> +
>  	.macro PFX_REX opd1 opd2 W=0
>  	.if ((\opd1 | \opd2) & 8) || \W
>  	.byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1) | (\W << 3)
> @@ -158,6 +219,146 @@
>  	.byte 0x0f, 0xc7
>  	MODRM 0xc0 rdpid_opd 0x7
>  .endm
> +
> +	.macro ENCODEKEY128 reg1 reg2
> +	R32_NUM encodekey128_opd1 \reg1
> +	R32_NUM encodekey128_opd2 \reg2
> +	PFX_RPT
> +	.byte 0xf, 0x38, 0xfa
> +	MODRM 0xc0  encodekey128_opd2 encodekey128_opd1
> +	.endm
> +
> +	.macro ENCODEKEY256 reg1 reg2
> +	R32_NUM encodekey256_opd1 \reg1
> +	R32_NUM encodekey256_opd2 \reg2
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xfb
> +	MODRM 0xc0 encodekey256_opd1 encodekey256_opd2
> +	.endm
> +
> +	.macro AESENC128KL reg, xmm
> +	REG_TYPE aesenc128kl_opd1_type \reg
> +	.if aesenc128kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesenc128kl_opd1 \reg
> +	.elseif aesenc128kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesenc128kl_opd1 \reg
> +	.else
> +	aesenc128kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	XMM_NUM aesenc128kl_opd2 \xmm
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xdc
> +	MODRM 0x0 aesenc128kl_opd1 aesenc128kl_opd2
> +	.endm
> +
> +	.macro AESDEC128KL reg, xmm
> +	REG_TYPE aesdec128kl_opd1_type \reg
> +	.if aesdec128kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesdec128kl_opd1 \reg
> +	.elseif aesdec128kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesdec128kl_opd1 \reg
> +	.else
> +	aesdec128kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	XMM_NUM aesdec128kl_opd2 \xmm
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xdd
> +	MODRM 0x0 aesdec128kl_opd1 aesdec128kl_opd2
> +	.endm
> +
> +	.macro AESENC256KL reg, xmm
> +	REG_TYPE aesenc256kl_opd1_type \reg
> +	.if aesenc256kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesenc256kl_opd1 \reg
> +	.elseif aesenc256kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesenc256kl_opd1 \reg
> +	.else
> +	aesenc256kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	XMM_NUM aesenc256kl_opd2 \xmm
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xde
> +	MODRM 0x0 aesenc256kl_opd1 aesenc256kl_opd2
> +	.endm
> +
> +	.macro AESDEC256KL reg, xmm
> +	REG_TYPE aesdec256kl_opd1_type \reg
> +	.if aesdec256kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesdec256kl_opd1 \reg
> +	.elseif aesdec256kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesdec256kl_opd1 \reg
> +	.else
> +	aesdec256kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	XMM_NUM aesdec256kl_opd2 \xmm
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xdf
> +	MODRM 0x0 aesdec256kl_opd1 aesdec256kl_opd2
> +	.endm
> +
> +	.macro AESENCWIDE128KL reg
> +	REG_TYPE aesencwide128kl_opd1_type \reg
> +	.if aesencwide128kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesencwide128kl_opd1 \reg
> +	.elseif aesencwide128kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesencwide128kl_opd1 \reg
> +	.else
> +	aesencwide128kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xd8
> +	MODRM 0x0 aesencwide128kl_opd1 0x0
> +	.endm
> +
> +	.macro AESDECWIDE128KL reg
> +	REG_TYPE aesdecwide128kl_opd1_type \reg
> +	.if aesdecwide128kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesdecwide128kl_opd1 \reg
> +	.elseif aesdecwide128kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesdecwide128kl_opd1 \reg
> +	.else
> +	aesdecwide128kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xd8
> +	MODRM 0x0 aesdecwide128kl_opd1 0x1
> +	.endm
> +
> +	.macro AESENCWIDE256KL reg
> +	REG_TYPE aesencwide256kl_opd1_type \reg
> +	.if aesencwide256kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesencwide256kl_opd1 \reg
> +	.elseif aesencwide256kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesencwide256kl_opd1 \reg
> +	.else
> +	aesencwide256kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xd8
> +	MODRM 0x0 aesencwide256kl_opd1 0x2
> +	.endm
> +
> +	.macro AESDECWIDE256KL reg
> +	REG_TYPE aesdecwide256kl_opd1_type \reg
> +	.if aesdecwide256kl_opd1_type == REG_TYPE_R64
> +	R64_NUM aesdecwide256kl_opd1 \reg
> +	.elseif aesdecwide256kl_opd1_type == REG_TYPE_R32
> +	R32_NUM aesdecwide256kl_opd1 \reg
> +	.else
> +	aesdecwide256kl_opd1 = REG_NUM_INVALID
> +	.endif
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xd8
> +	MODRM 0x0 aesdecwide256kl_opd1 0x3
> +	.endm
> +
> +	.macro LOADIWKEY xmm1, xmm2
> +	XMM_NUM loadiwkey_opd1 \xmm1
> +	XMM_NUM loadiwkey_opd2 \xmm2
> +	PFX_RPT
> +	.byte 0x0f, 0x38, 0xdc
> +	MODRM 0xc0 loadiwkey_opd1 loadiwkey_opd2
> +	.endm
>  #endif
>  
>  #endif

*groan*, so what actual version of binutils is needed and why is this
driver important enough to build on ancient crud to warrant all this
gunk?

