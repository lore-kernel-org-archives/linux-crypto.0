Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AC8C54EE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 17:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiISRyI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 13:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiISRyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 13:54:06 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ADA4457F
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:54:02 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a9so49505ilh.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=/cf7B/KTsLD75IcdMZipBXm6ofpyaTAcEkMwbp5iR00=;
        b=R8mhDvftQzWNGK0iyvTa9nSIWZrFtnkIInr7JSr2ggsBoL0OTaAAJ8tWbpkuAvy5uz
         /KUqKCF6s6xS0GQg0bWo7WW2V5rhJSdcyvJdj3QJ8g7jcGbxnddmPgRlFFig95paopv9
         JJitEjoyNVAtyNOz4042FtJmsLF6F0qY3daW/gDjQH/PduCqhXQvCb4a4wsPlcIyO9d2
         OO/7Mv1YzGbaTOiX3ImsaQ+5viwPfIzfyLecupDW8Q+rHJrno580i7K6KH0ODQsvfAYl
         5W6sni6L8cuSeTVcAsYL23+NoDAUfHl1n82XX047aOmMYGSl7IPD6AXuHbyOys0rn2Ji
         ZM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/cf7B/KTsLD75IcdMZipBXm6ofpyaTAcEkMwbp5iR00=;
        b=bS2eeqTk2E/M/tVkzFhSpLBHA+/x585bjzapht5Dezj9VY968iwVKeA8bKQxEZs6h5
         RG+goETCqi4/oTXviTbkj88/hmO2/mim4Mw7nftLMmh8/GVmjUSylGsyK9PLImVmxCdH
         CM0GPZlJuI/zFz9+tD/R1WBliuE+nlJxv7n1YVCQ2+tZK5XSObzc3o4tx3UFA2et+zOH
         WSWytUnQjTBqXQ49O6Pvob4UbuuZZxELmsTNIeKJyUZEq+EMQQ0/TEH1MvVi9RGS7IZU
         hpLzgRtXPuQL+rX/deZHBOlV2Oc4fV0Wo2eE8FGTgXPH4m3WTL/O4DP4ifikHk1hnWsz
         YEhg==
X-Gm-Message-State: ACrzQf2dYV60dPJqqei0inPwMOAMbXk7a8gjVdDM7j3ffhGWJ9YXfVid
        rkX21Uzpf8I+9wHRKwhW2EVVt55wHuuYV7wicpzxMQ==
X-Google-Smtp-Source: AMsMyM7ZwbCCz+Lnjmmlji90t5P++0wvHrAVUqDM1acb+Y9g6sLPifzlN/Q3k34EEoZMwTLsTTl3wGgSyLZbbRAEbkE=
X-Received: by 2002:a92:ca49:0:b0:2f5:30:bfc1 with SMTP id q9-20020a92ca49000000b002f50030bfc1mr6478814ilo.224.1663610040996;
 Mon, 19 Sep 2022 10:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
In-Reply-To: <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 19 Sep 2022 10:53:49 -0700
Message-ID: <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
To:     Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
>
> > +
> > +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
> > +                                         int level)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       int rc, npt_level;
> > +       kvm_pfn_t pfn;
> > +       gpa_t gpa_end;
> > +
> > +       gpa_end = gpa + page_level_size(level);
> > +
> > +       while (gpa < gpa_end) {
> > +               /*
> > +                * If the gpa is not present in the NPT then build the NPT.
> > +                */
> > +               rc = snp_check_and_build_npt(vcpu, gpa, level);
> > +               if (rc)
> > +                       return -EINVAL;
> > +
> > +               if (op == SNP_PAGE_STATE_PRIVATE) {
> > +                       hva_t hva;
> > +
> > +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
> > +                               return -EINVAL;
> > +
> > +                       /*
> > +                        * Verify that the hva range is registered. This enforcement is
> > +                        * required to avoid the cases where a page is marked private
> > +                        * in the RMP table but never gets cleanup during the VM
> > +                        * termination path.
> > +                        */
> > +                       mutex_lock(&kvm->lock);
> > +                       rc = is_hva_registered(kvm, hva, page_level_size(level));
> > +                       mutex_unlock(&kvm->lock);
> > +                       if (!rc)
> > +                               return -EINVAL;
> > +
> > +                       /*
> > +                        * Mark the userspace range unmerable before adding the pages
> > +                        * in the RMP table.
> > +                        */
> > +                       mmap_write_lock(kvm->mm);
> > +                       rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
> > +                       mmap_write_unlock(kvm->mm);
> > +                       if (rc)
> > +                               return -EINVAL;
> > +               }
> > +
> > +               write_lock(&kvm->mmu_lock);
> > +
> > +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> > +               if (!rc) {
> > +                       /*
> > +                        * This may happen if another vCPU unmapped the page
> > +                        * before we acquire the lock. Retry the PSC.
> > +                        */
> > +                       write_unlock(&kvm->mmu_lock);
> > +                       return 0;
> > +               }
>
> I think we want to return -EAGAIN or similar if we want the caller to
> retry, right? I think returning 0 here hides the error.
>

The problem here is that the caller(linux guest kernel) doesn't retry
if PSC fails. The current implementation in the guest kernel is that
if a page state change request fails, it terminates the VM with
GHCB_TERM_PSC reason.
Returning 0 here is not a good option because it will fail the PSC
silently and will probably cause a nested RMP fault later. Returning
an error also terminates the guest immediately with current guest
implementation. I think the best approach here is adding a retry logic
to this function. Retrying without returning an error should help it
work because snp_check_and_build_npt will be called again and in the
second attempt this should work.

> > +
> > +               /*
> > +                * Adjust the level so that we don't go higher than the backing
> > +                * page level.
> > +                */
> > +               level = min_t(size_t, level, npt_level);
> > +
> > +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
> > +
> > +               switch (op) {
> > +               case SNP_PAGE_STATE_SHARED:
> > +                       rc = snp_make_page_shared(kvm, gpa, pfn, level);
> > +                       break;
> > +               case SNP_PAGE_STATE_PRIVATE:
> > +                       rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
> > +                       break;
> > +               default:
> > +                       rc = -EINVAL;
> > +                       break;
> > +               }
> > +
> > +               write_unlock(&kvm->mmu_lock);
> > +
> > +               if (rc) {
> > +                       pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
> > +                                          op, gpa, pfn, level, rc);
> > +                       return rc;
> > +               }
> > +
> > +               gpa = gpa + page_level_size(level);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
