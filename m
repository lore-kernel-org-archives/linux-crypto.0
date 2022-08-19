Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8E5C28B2B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 17:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354582AbiHSRg4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 13:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354705AbiHSRge (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 13:36:34 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA41631FD
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 09:55:11 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bx38so5027982ljb.10
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AhTWQcbRqLOHVkblJK8G++davTd8BoOGzTOxaJ8TciQ=;
        b=rev22bDg/B6huypKjaBYCvhEdROPXhJKo6JY54CN/6HsfbGiAmHcmqz0iheKnDiDLv
         60YvV6ZgPfqwgXaYULb+bIH7ZUt/NgGkDRQU23y78EYAPdOVenEvDyqxPyto7nYBPA5Z
         XlpbPeRjdVjAuHZy974y8RZepwILZP8uJ4UkB1YMCBrCslXjf4MRg873773Fs2FkUMHK
         QsqKpT37JjGP63hwvjmwKtKwirueKtOXcEQSrq4+c6X+2pNdYciqCszqJ9gyzTHHe95s
         UwY4K0fEdTOLITGsLhKh/abM38uMi95xw1SFJtkj7Ko+Jzi2+qbqPO7SOVvFC9NsTxRy
         n2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AhTWQcbRqLOHVkblJK8G++davTd8BoOGzTOxaJ8TciQ=;
        b=mngQUFOurvL1UAS68kK7CaxLK+CKg5MIykZFBsVj6UpowvzuBkFtKXVBZ6+via/pyi
         0hiG0xzoXf2PVy8NJfF4hTLIaZquXJ/21QpeHdI0ibSD6IZZNJie4w6Lp8AaUBeBuD1O
         PsDNPio1JOo8RV3vdQQ2KXZxccdlmgJS4GvDO7yjn27yOz6eqp+6txa7K5J1MPctBFE5
         x1p7cLtWA886sIw/4kOWBZbKzXY8a5G2eMSc92ngfBq8NErm1BIo4Cft1Sotj7Y6M+ZV
         tw5yDdXLfIaKq8SrrhnQTdUqb5FCmAsuGa67ApQ6KDrEnX+DxmTERkrXVE1OX4M3nD1/
         fy9A==
X-Gm-Message-State: ACgBeo1q7yh9sBxvJT/sjMAim9mwxfWsPHxMCR0Yj2GNsusIiLKGAiN7
        SlTr5YI95mcqvl80m3DOQl0v+lglYt1mZB7eQH0Tfw==
X-Google-Smtp-Source: AA6agR58K2GJzQfDZi+FO4kcRkjUmKJQPNXIQiTuu2Go1eedCUceiwNYBAb48mJhSiTtK1OeQXqSY4hu6BiWgBiZhe4=
X-Received: by 2002:a05:651c:1787:b0:261:c1ff:4407 with SMTP id
 bn7-20020a05651c178700b00261c1ff4407mr340249ljb.257.1660928058082; Fri, 19
 Aug 2022 09:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 19 Aug 2022 10:54:06 -0600
Message-ID: <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> +
> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
> +                                         int level)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +       struct kvm *kvm = vcpu->kvm;
> +       int rc, npt_level;
> +       kvm_pfn_t pfn;
> +       gpa_t gpa_end;
> +
> +       gpa_end = gpa + page_level_size(level);
> +
> +       while (gpa < gpa_end) {
> +               /*
> +                * If the gpa is not present in the NPT then build the NPT.
> +                */
> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
> +               if (rc)
> +                       return -EINVAL;
> +
> +               if (op == SNP_PAGE_STATE_PRIVATE) {
> +                       hva_t hva;
> +
> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
> +                               return -EINVAL;
> +
> +                       /*
> +                        * Verify that the hva range is registered. This enforcement is
> +                        * required to avoid the cases where a page is marked private
> +                        * in the RMP table but never gets cleanup during the VM
> +                        * termination path.
> +                        */
> +                       mutex_lock(&kvm->lock);
> +                       rc = is_hva_registered(kvm, hva, page_level_size(level));
> +                       mutex_unlock(&kvm->lock);
> +                       if (!rc)
> +                               return -EINVAL;
> +
> +                       /*
> +                        * Mark the userspace range unmerable before adding the pages
> +                        * in the RMP table.
> +                        */
> +                       mmap_write_lock(kvm->mm);
> +                       rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
> +                       mmap_write_unlock(kvm->mm);
> +                       if (rc)
> +                               return -EINVAL;
> +               }
> +
> +               write_lock(&kvm->mmu_lock);
> +
> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> +               if (!rc) {
> +                       /*
> +                        * This may happen if another vCPU unmapped the page
> +                        * before we acquire the lock. Retry the PSC.
> +                        */
> +                       write_unlock(&kvm->mmu_lock);
> +                       return 0;
> +               }

I think we want to return -EAGAIN or similar if we want the caller to
retry, right? I think returning 0 here hides the error.

> +
> +               /*
> +                * Adjust the level so that we don't go higher than the backing
> +                * page level.
> +                */
> +               level = min_t(size_t, level, npt_level);
> +
> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
> +
> +               switch (op) {
> +               case SNP_PAGE_STATE_SHARED:
> +                       rc = snp_make_page_shared(kvm, gpa, pfn, level);
> +                       break;
> +               case SNP_PAGE_STATE_PRIVATE:
> +                       rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
> +                       break;
> +               default:
> +                       rc = -EINVAL;
> +                       break;
> +               }
> +
> +               write_unlock(&kvm->mmu_lock);
> +
> +               if (rc) {
> +                       pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
> +                                          op, gpa, pfn, level, rc);
> +                       return rc;
> +               }
> +
> +               gpa = gpa + page_level_size(level);
> +       }
> +
> +       return 0;
> +}
> +
