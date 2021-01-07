Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B1CC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAEC322D71
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbhAGGij (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAGGij (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 01:38:39 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E6BC0612F4;
        Wed,  6 Jan 2021 22:37:58 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e340040aa7c2c4e2416a1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:3400:40aa:7c2c:4e24:16a1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDEBE1EC0505;
        Thu,  7 Jan 2021 07:37:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610001475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=v+qMAxqqt8nszXdetCtccYLnMdXSV0ny4ReqXtPVORw=;
        b=aP7NQt5Lz7pIHzFTeA7T5LrK0qu5eRPssQukqAt5INooLBcAfxyHQf77Goom81Ycr/gTDO
        0SoLv3gF7o3MWnxjCFkj0ZQA8KTvKtaky2CsGIXktMzoEz22dFJOv/4eEQZiZpZn5nOlAX
        CY1lWo6OC0anBoE6SQZRNyL9M8peaTk=
Date:   Thu, 7 Jan 2021 07:37:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, tony.luck@intel.com, dave.hansen@intel.com,
        seanjc@google.com, fenghua.yu@intel.com, thomas.lendacky@amd.com,
        kyung.min.park@intel.com, kim.phillips@amd.com,
        mgross@linux.intel.com, peterz@infradead.org,
        krish.sadhukhan@oracle.com, liam.merwick@oracle.com,
        mlevitsk@redhat.com, reinette.chatre@intel.com, babu.moger@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH v1 1/3] x86/cpufeatures: Add low performance CRC32C
 instruction CPU feature
Message-ID: <20210107063750.GA14697@zn.tnic>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <1610000348-17316-2-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1610000348-17316-2-git-send-email-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 07, 2021 at 02:19:06PM +0800, Tony W Wang-oc wrote:
> SSE4.2 on Zhaoxin CPUs are compatible with Intel. The presence of
> CRC32C instruction is enumerated by CPUID.01H:ECX.SSE4_2[bit 20] = 1.
> Some Zhaoxin CPUs declare support SSE4.2 instruction sets but their
> CRC32C instruction are working with low performance.
> 
> Add a synthetic CPU flag to indicates that the CRC32C instruction is
> not working as intended. This low performance CRC32C instruction flag
> is depend on X86_FEATURE_XMM4_2.
> 
> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b8878..9e8151b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -292,6 +292,7 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_CRC32C		(11*32+ 8) /* "" Low performance CRC32C instruction */

Didn't hpa say to create a BUG flag for it - X86_BUG...? Low performance
insn sounds like a bug and not a feature to me.

And call it X86_BUG_CRC32C_SLOW or ..._UNUSABLE to denote what it means.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
