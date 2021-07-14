Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E074C47E48
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 20:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36E4613A9
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 20:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhGNUkC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jul 2021 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhGNUkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jul 2021 16:40:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC80C061764
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jul 2021 13:37:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so2533697pjo.3
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jul 2021 13:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZVoghOGzFUo2g1EHO3svD45q6oPjKQ3+d8OVWxkKeFs=;
        b=JiU2GbbPqJEfjdLSrQJtgYY3oWalcHVF5itcoxrvKNVRdaiNBcHkThvP5a13TSbF/F
         975P58r0yXUBYucj06Qebr86YNALTQ+WyrW8dwDAzxB5rRtElAwzRA5OLP/QBpJbUPw0
         EXbFkofXnP6BHr0opiIKPx1G6cbmQMXpNY2Ft4SImg1JUU9x0QpEdd9rY9la8Lc6KI6Q
         /tBVkTIXZpTN14WonkOF+PsfWoFfhZeFXuH3VW2oazKiJSWXyLBV7BAcC3wIrR+eR9oF
         M6re8cCcSA0q47xQspQh2x4zNkVDMuZ8Fmn8Z59RpcGleVkcOUjcm7nBPQLI7V+hGLzL
         eMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZVoghOGzFUo2g1EHO3svD45q6oPjKQ3+d8OVWxkKeFs=;
        b=SIig21lyOPTAGN6t4c2sbWzxuolSyeTJPINEoul8SJxRlAF6qMpAWq9Kp/FfV0L0gl
         iis/q3O7SOByK4XZFjAqnNWeH/QDDlymL6493VWOnzS9297fBLO8GbyQ1so8hUuB/68E
         Aw7dP7NdFB1eCgYQxXexscg7yEJEhCBXo/RzWHKDsThf3JMBg3DyeU2REIDFo0CtYtr2
         gqIwAy9B3W/irYjBKuGcvsKbxfkUtOvpiA5EuZjzDF7jIYiCtYzWH2B76J/sRujIppIQ
         M+BL0SUXmKBgK5YemTmT+d/MueuhxlbbZy6EDeIM1ZQXMGITutcmbRWYKamdvsh60FZ5
         rHyg==
X-Gm-Message-State: AOAM5321kIuc30tKMIiqFRL/eXmqMQbHx6lmIv0qN5XfzOLjSNcEGZtm
        QVb1UiCooitwyDwUaryINf1XJg==
X-Google-Smtp-Source: ABdhPJwUL+v46lDMA+LqJ5QvGmnIpHnxv/opqwJmq3pJ98w6lIS+a2sQ5Xiu1judhEtQf2xwoOjymw==
X-Received: by 2002:a17:90b:b88:: with SMTP id bd8mr5383285pjb.26.1626295029550;
        Wed, 14 Jul 2021 13:37:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t37sm3942693pfg.14.2021.07.14.13.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:37:08 -0700 (PDT)
Date:   Wed, 14 Jul 2021 20:37:05 +0000
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
Subject: Re: [PATCH Part2 RFC v4 02/40] KVM: SVM: Provide the Hypervisor
 Feature support VMGEXIT
Message-ID: <YO9K8akh1CdY1kjd@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-3-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> Version 2 of the GHCB specification introduced advertisement of features
> that are supported by the Hypervisor.
> 
> Now that KVM supports version 2 of the GHCB specification, bump the
> maximum supported protocol version.

Heh, the changelog doesn't actually state that it's adding support for said
advertisement of features.  It took me a few seconds to figure out what the
patch was doing, even though it's quite trivial in the end.

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/uapi/asm/svm.h |  4 ++--
>  arch/x86/kvm/svm/sev.c          | 14 ++++++++++++++
>  arch/x86/kvm/svm/svm.h          |  3 ++-
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 9aaf0ab386ef..ba4137abf012 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -115,7 +115,7 @@
>  #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
>  #define SVM_VMGEXIT_AP_CREATE			1
>  #define SVM_VMGEXIT_AP_DESTROY			2
> -#define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
> +#define SVM_VMGEXIT_HV_FT			0x8000fffd

This is fixing up commit 3 from Part1, though I think it can and should be
omitted from that patch entirely since it's not relevant to the guest, only to
KVM.

And FWIW, I like the verbose name, though it looks like Boris requested the
shorter names for the guest.  Can we keep the verbose form for KVM-only VMEGXIT
name?  Hyper-V has mostly laid claim to "HV", and feature is not the first thing
that comes to mind for "FT".

>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
