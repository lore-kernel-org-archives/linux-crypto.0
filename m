Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75A9C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiGYOhH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiGYOhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:37:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EADCDE89;
        Mon, 25 Jul 2022 07:37:04 -0700 (PDT)
Received: from zn.tnic (p200300ea972976f8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:76f8:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DCF841EC0554;
        Mon, 25 Jul 2022 16:36:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658759818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ukq4Ju25HfOtxA6MIzJPkc7+yNzn1aszkw7wxTvzP54=;
        b=Tmx9olaPmHkwLBrBL1vEE/sWkEe+Zs2j9FDsF2GEiz9TIkJg5v9gxUBFF7nY3RpzGfVTcG
        i92eMw4KSOayT98YDkbl34LR/hryxsZsVOdUuFY6MEdwNLXpQkcqnwpwbyrr0B97Sxaxh2
        YogDp8c2pbWrktu9FED9q/LKngw0f5E=
Date:   Mon, 25 Jul 2022 16:36:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <Yt6qit4al5/eM7YO@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 11:02:52PM +0000, Ashish Kalra wrote:
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index cb16f0e5b585..6ab872311544 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -85,7 +85,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_PG_SIZE_2M			1
>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>  
>  /*
>   * The RMP entry format is not architectural. The format is defined in PPR
> @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
>  	u64 secrets_gpa;
>  };
>  
> +struct rmpupdate {

Why is there a struct rmpupdate *and* a struct rmpentry?!

One should be enough.

> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;
> +

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
