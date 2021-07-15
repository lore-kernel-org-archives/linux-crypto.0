Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE354C636CD
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 18:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9683F613CA
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 18:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhGOSk1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 14:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhGOSkY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 14:40:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C736C061762
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 11:37:30 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q10so6286960pfj.12
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 11:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b0k1g7//WbCfpqVPknCaS62XmrgAPcdGgqibAcypVAA=;
        b=ZuFddVCnGCX2gwIB5owc8oQOjN5zz0iQq+GFG5cfKoR26QRYNgdBRLlV3L/mvPgaVz
         3RSdZ1WZmIi6LR4QnYs4JYaAWwwS3PhNqzoc1HTPdWdiSB5oVyimTgEpYxvbGd32qPXV
         SOz3HElhRqllBnhDZ5bF58P3tzlMN3fbvCPenHgvmO64sLAyHp/ufhZGI0KPeyP9ynbR
         eTFn1muNqJuSgge26KfL3qPMjaxtfPP6p821CXz1OjEck/wH1Ves4PKSg51ImOEyq6io
         ycwb28L2SK3acNcoroR5aFuYlh4D5XqwRE601MJZRiXt2Uv7GELoNr7jC3gwYtNmeagF
         mRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b0k1g7//WbCfpqVPknCaS62XmrgAPcdGgqibAcypVAA=;
        b=Gw+j/YfhRgnQL221t+kpcyKgfdN2GV3O+SRcTeDqaDRd/qwGGIIN/ZW/1RX1F9jEL7
         /GzIaWKxm0r4QrAjT9c5mokits5heFSr0bLofpyCgTLtAGU+uqS6qQvLC1thRjvWWO/E
         WTglZzaUk7IisF1JfkS8jwULtnk6lpOr5X/1jx9OB7ltl3Tm9VRj0H4zqhWZRseRcz7Z
         zSqsqrhyq3CmgAy3skIi5WdeM3ZE5ouzcx4iQtul6t3GA5evNhVAPsNK5xK3c5T4ptsv
         y4+/EkpqgJP0SHD88S+s6XpjfGMJ0DJa6vbMGytu2etsfC0PtZfGfdOPecipM8ODqCIu
         gUow==
X-Gm-Message-State: AOAM532jq+sRfWzrgvy8BglxRm3dOJsGp9hY93PyaYvCtFu0QGODrty9
        HpszWpljM7MdD3aB6wVTzGk3RA==
X-Google-Smtp-Source: ABdhPJxqkYY9aLIvqtUQ9od6UU93/eKmeKYJstKVrJ9ha/ruBvMB7R0iAD4iuyNlkS3yLOCj5ZJZtw==
X-Received: by 2002:aa7:8154:0:b029:310:70d:a516 with SMTP id d20-20020aa781540000b0290310070da516mr6181701pfn.63.1626374249730;
        Thu, 15 Jul 2021 11:37:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y82sm7396193pfb.121.2021.07.15.11.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 11:37:29 -0700 (PDT)
Date:   Thu, 15 Jul 2021 18:37:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 05/40] x86/sev: Add RMP entry lookup helpers
Message-ID: <YPCAZaROOHNskGlO@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> entry for a given page. The RMP entry format is documented in AMD PPR, see
> https://bugzilla.kernel.org/attachment.cgi?id=296015.

Ewwwwww, the RMP format isn't architectural!?

  Architecturally the format of RMP entries are not specified in APM. In order
  to assist software, the following table specifies select portions of the RMP
  entry format for this specific product.

I know we generally don't want to add infrastructure without good reason, but on
the other hand exposing a microarchitectural data structure to the kernel at large
is going to be a disaster if the format does change on a future processor.

Looking at the future patches, dump_rmpentry() is the only power user, e.g.
everything else mostly looks at "assigned" and "level" (and one ratelimited warn
on "validated" in snp_make_page_shared(), but I suspect that particular check
can and should be dropped).

So, what about hiding "struct rmpentry" and possibly renaming it to something
scary/microarchitectural, e.g. something like

/*
 * Returns 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
 * and -errno if there is no corresponding RMP entry.
 */
int snp_lookup_rmpentry(struct page *page, int *level)
{
	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
	struct rmpentry *entry, *large_entry;
	unsigned long vaddr;

	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
		return -ENXIO;

	vaddr = rmptable_start + rmptable_page_offset(phys);
	if (unlikely(vaddr > rmptable_end))
		return -EXNIO;

	entry = (struct rmpentry *)vaddr;

	/* Read a large RMP entry to get the correct page level used in RMP entry. */
	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
	large_entry = (struct rmpentry *)vaddr;
	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));

	return !!entry->assigned;
}


And then move dump_rmpentry() (or add a helper) in sev.c so that "struct rmpentry"
can be declared in sev.c.

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  4 +--
>  arch/x86/kernel/sev.c      | 26 +++++++++++++++++++
>  include/linux/sev.h        | 51 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/sev.h
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 6c23e694a109..9e7e7e737f55 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -9,6 +9,7 @@
>  #define __ASM_ENCRYPTED_STATE_H
>  
>  #include <linux/types.h>
> +#include <linux/sev.h>

Why move things to linux/sev.h?  AFAICT, even at the end of the series, the only
users of anything in this file all reside somewhere in arch/x86.

>  #include <asm/insn.h>
>  #include <asm/sev-common.h>
>  #include <asm/bootparam.h>
> @@ -75,9 +76,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  /* Software defined (when rFlags.CF = 1) */
>  #define PVALIDATE_FAIL_NOUPDATE		255
>  
> -/* RMP page size */
> -#define RMP_PG_SIZE_4K			0
> -
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index f9d813d498fa..1aed3d53f59f 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -49,6 +49,8 @@
>  #define DR7_RESET_VALUE        0x400
>  
>  #define RMPTABLE_ENTRIES_OFFSET        0x4000
> +#define RMPENTRY_SHIFT			8
> +#define rmptable_page_offset(x)	(RMPTABLE_ENTRIES_OFFSET + (((unsigned long)x) >> RMPENTRY_SHIFT))
>  
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
> @@ -2319,3 +2321,27 @@ static int __init snp_rmptable_init(void)
>   * passthough state, and it is available after subsys_initcall().
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)

Maybe just snp_get_rmpentry?  Or snp_lookup_rmpentry?  I'm guessing the name was
chosen to align with e.g. lookup_address_in_mm, but IMO the lookup_address helpers
are oddly named.

> +{
> +	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
> +	struct rmpentry *entry, *large_entry;
> +	unsigned long vaddr;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return NULL;
> +
> +	vaddr = rmptable_start + rmptable_page_offset(phys);
> +	if (unlikely(vaddr > rmptable_end))
> +		return NULL;
> +
> +	entry = (struct rmpentry *)vaddr;
> +
> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
> +	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
> +	large_entry = (struct rmpentry *)vaddr;
> +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
> +
> +	return entry;
> +}
