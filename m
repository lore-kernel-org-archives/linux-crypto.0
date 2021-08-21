Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A832AC4320A
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 02:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81868611C7
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 02:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbhHUCMh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Aug 2021 22:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbhHUCMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Aug 2021 22:12:37 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50ACC061757
        for <linux-crypto@vger.kernel.org>; Fri, 20 Aug 2021 19:11:58 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id b1so9069443qtx.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Aug 2021 19:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2gOO2S7Mv0HOYYeN5193uyMUGfsmPjSlzi2OFU8Y+fo=;
        b=L8bsYCZr6W6WOVgqBP0nhp9qabhe3vp0nXQEfWFvEEp2V3ftXg/ZVGt48988QCyJSN
         g25s9q0q+k+UI5gdlyy9fDtxUQoosqOy3QODvoWrq8d0AnMZhf1sxLSuZPst5G6XO6xG
         2hwDr+08s5ajJotnhZDie1AgvEX74LQd6O7wpL3SXiNZ44td+ePm+EA7aFhW04nhLXm7
         uXG5PwIm36yZVEfQh3e28iJymNdJctSE/4a3tpCFmkjnzZ3fpIulLnS+f1cVjo0KlD1s
         Jizp09BdIWghNYDyA/mEQ/CDqEyNTeKUZdu8AFvQ7PyKOUsUIjvlHXPIXPdetrTN/ykm
         5nEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2gOO2S7Mv0HOYYeN5193uyMUGfsmPjSlzi2OFU8Y+fo=;
        b=lIOhD7qoAy/k8UP87ywVNq7iJ/jPuXVipc1D/fKsxmxXcdEg8y1hKjwVToPTK7/E3n
         Jzn7xn2a6GODBxd+DFP+8CtQ2X97kigYwGjOtvkAb96IyaS28Uh0zStHxlP6ji8g1Ffo
         1pI5YjJ9ujD6QScku9bTPlZLFDnS73sbZy4pHCDCe7SxxiHJzJa0Z5XSvmkLRRTr/uCO
         nUWA5ibbOTlj+j4zYyPSJBgKiQLjQwZaHgTXHA+iUhBjFWZxtZQAGeZEY9MAcQw/T2HO
         lhcRNa0rjHzol2wa6w++933W523Z3I89jGU5SU7ygj9r0Dp/l3I9SWg+iiFRh6G+0jdJ
         efNg==
X-Gm-Message-State: AOAM532V6odVUzvP/4QGY7TRgA5A6yL9uWKvnz0DhSVf/wKvnciAepN0
        +NMx5+Eg5BUaxsi6Lxw6EUK60XM3k6KZmUt1NU0OrA==
X-Google-Smtp-Source: ABdhPJxvczIWQNg+cxCoCUPQp8oANeSbmnqZtLwQvuXY+SvSo6y+6aTdmCOV51JpAiZA3j9p/g2HEN6baPINaTMxVno=
X-Received: by 2002:a05:622a:488:: with SMTP id p8mr20558647qtx.159.1629511917617;
 Fri, 20 Aug 2021 19:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com> <20210818053908.1907051-2-mizhang@google.com>
In-Reply-To: <20210818053908.1907051-2-mizhang@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 19:11:46 -0700
Message-ID: <CAA03e5Ggh4gODFspxcXAU6WRe0aMCvkG794JpwvyBf6ERs_6dA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: SVM: fix missing sev_decommission in sev_receive_start
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 17, 2021 at 10:39 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> sev_decommission is needed in the error path of sev_bind_asid. The purpose
> of this function is to clear the firmware context. Missing this step may
> cause subsequent SEV launch failures.
>
> Although missing sev_decommission issue has previously been found and was
> fixed in sev_launch_start function. It is supposed to be fixed on all
> scenarios where a firmware context needs to be freed. According to the AMD
> SEV API v0.24 Section 1.3.3:
>
> "The RECEIVE_START command is the only command other than the LAUNCH_START
> command that generates a new guest context and guest handle."
>
> The above indicates that RECEIVE_START command also requires calling
> sev_decommission if ASID binding fails after RECEIVE_START succeeds.
>
> So add the sev_decommission function in sev_receive_start.
>
> Cc: Alper Gun <alpergun@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: David Rienjes <rientjes@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Vipin Sharma <vipinsh@google.com>
>
> Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..55d8b9c933c3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>         /* Bind ASID to this guest */
>         ret = sev_bind_asid(kvm, start.handle, error);
> -       if (ret)
> +       if (ret) {
> +               sev_decommission(start.handle);
>                 goto e_free_session;
> +       }
>
>         params.handle = start.handle;
>         if (copy_to_user((void __user *)(uintptr_t)argp->data,
> --
> 2.33.0.rc1.237.g0d66db33f3-goog

Should this patch have the following Fixes tag?

Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")

Reviewed-by: Marc Orr <marcorr@google.com>
