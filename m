Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A4CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 20:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242484AbiERUVe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 16:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242477AbiERUVc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 16:21:32 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FC08BD29
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 13:21:30 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w127so647366oie.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6lnRyXRdpclSkDpWdKxmmOT7zesUDWOskA8B4RYY/c=;
        b=TWLXdHK3wqNn3HdV/aaUGPAQQ67/UmzCtZoSH5kRM5ZacS3noO6/4Sxti0A+n+d8eK
         1cia2priGINJE3sdKfl5lyXttfyP8mpKT5PN4Abc/50p7LOTBEhCyvWaoJxCt8LngOD5
         8wxJ79V5d786nAjFdxCpX4rks6paFflfetG9XBR2bSaIls0VWyrw1KPOv/6GpGy8UKkk
         dfaZiFUkrhQcb7qj0r3ab3HlNgedt7IH+FJloM9LcbqCLSLNuJMvRAKoAl4RyJUYCvQ3
         7Peqa0F359j7JUpE6eKM3OwajlJelq+aFw0oyz0E5QyvEFmqZD8TK4K9TzliWrfFF+J4
         DUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6lnRyXRdpclSkDpWdKxmmOT7zesUDWOskA8B4RYY/c=;
        b=aTIneenFntsfSlLSIiyEGczTojZgG/pWUZdR7+YRKkI7raTK8tp+VRdGxVZTxjp7Cx
         nOVxNvX1MsAwQ7geRwoBdGODkTP0A17GB/sQfL4QUifzDOSVKJl116qUNpaLc5oV4z//
         zZ1CvLQ1FNq07tHUk2Crr7poSW35Z9kgh1sY6LUvZXLc/nk/nCYqnCURAnviClvKcOBU
         SxG1ry0zVGYrZyzWEgCB3Y3+2384M2dMDq2AmHtNcbLPHhVwX0bfMsgiT743BKgebBh5
         U79zEj/fJilIkmMDXQueq5ttqSgcrB5DllPE4N1kPCHYSxRMdo+E55cVhf1MvI4yKSjW
         ivAA==
X-Gm-Message-State: AOAM531RvM9JwvLr1gz5SsVq7LzHnEY0HP6q0bThP50JElp+xhHiK1rk
        IVv6Mpx51z2aiIbrAAnH4f7zzzmLu24AtggrRnvdRg==
X-Google-Smtp-Source: ABdhPJyrABDg8UmKaFO4g1zPr7ZghjFTnzNY7hYFLo47MNaYS70K3fAAfHBMwODnv6JC7BiV3xuQQnWrp6uzkVZkDcY=
X-Received: by 2002:a05:6808:1599:b0:326:dae2:e49d with SMTP id
 t25-20020a056808159900b00326dae2e49dmr1027193oiw.110.1652905289966; Wed, 18
 May 2022 13:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-28-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-28-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 18 May 2022 13:21:18 -0700
Message-ID: <CAA03e5HmBHbt4YhE+0Sd0UKf_Nqeip4fRj73pdPfSSmNaKZvBQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 27/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> @@ -2364,16 +2467,29 @@ static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm;
> +       u64 pfn;
>
>         if (!sev_es_guest(vcpu->kvm))
>                 return;
>
>         svm = to_svm(vcpu);
> +       pfn = __pa(svm->vmsa) >> PAGE_SHIFT;
>
>         if (vcpu->arch.guest_state_protected)
>                 sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
> +
> +       /*
> +        * If its an SNP guest, then VMSA was added in the RMP entry as
> +        * a guest owned page. Transition the page to hyperivosr state
> +        * before releasing it back to the system.
> +        */
> +       if (sev_snp_guest(vcpu->kvm) &&
> +           host_rmp_make_shared(pfn, PG_LEVEL_4K, false))
> +               goto skip_vmsa_free;
> +
>         __free_page(virt_to_page(svm->vmsa));
>
> +skip_vmsa_free:
>         if (svm->ghcb_sa_free)
>                 kfree(svm->ghcb_sa);
>  }

Hi Ashish. We're still working with this patch set internally. We
found a bug that I wanted to report in this patch. Above, we need to
flush the VMSA page, `svm->vmsa`, _after_ we call
`host_rmp_make_shared()` to mark the page is shared. Otherwise, the
host gets an RMP violation when it tries to flush the guest-owned VMSA
page.

The bug was silent, at least on our Milan platforms, bef reo
d45829b351ee6 ("KVM: SVM: Flush when freeing encrypted pages even on
SME_COHERENT CPUs"), because the `sev_flush_guest_memory()` helper was
a noop on platforms with the SME_COHERENT feature. However, after
d45829b351ee6, we unconditionally do the flush to keep the IO address
space coherent. And then we hit this bug.

Thanks,
Marc
