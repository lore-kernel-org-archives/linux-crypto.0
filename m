Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B325C7EE23
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Mar 2023 01:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCBBl4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Mar 2023 20:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCBBlz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2023 20:41:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CE1580DF
        for <linux-crypto@vger.kernel.org>; Wed,  1 Mar 2023 17:41:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso1187396pjs.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Mar 2023 17:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQ/k+I6vg3DIpuQkWsbGXKaDuFnWAPV+R/MRhIWgerE=;
        b=M1faUwzF8K9LVMgFawTxpJg0odDzVyBttN0AF69uG9guWjiSvbhav1cNgD35gDMKu0
         j1niW9n0QqE3EKJ1dLgwNzvMTsr/XSuX4cXlnqhLDSoEXOlwHLpg/HIGgMwqwQFoKLTY
         /3p1wvO6ecQ1YgClypzXuo5Z+9McY/e//LJVhv3UX6Kpq0CIXJKrgmeQRoYvzMI1gJrs
         GhDh8QtNI7ubX9ks3+BO7j6DV36t9q0rMBQcG43GtBzfzhnaGmfxqQjy6q1mxlVc/mvD
         dmoYB0/AEPJc7ihdJU3WdhAsnYUJK781v7iYPrrNrt88tgTT5g7Myt5GjBx8YtQisLfu
         4ZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQ/k+I6vg3DIpuQkWsbGXKaDuFnWAPV+R/MRhIWgerE=;
        b=q0ENrM8umC02FsReY3dR5d1r+0FEP9tLLvhAUDymjDWTqhNoyVao1xK4mosxI7zxK6
         XhvoLR7Z91+2ifURJIRoLUtPsjken9KCG5dHnM8SPTxZLh8iwx7SieIEZDVZHhtcQ+Zb
         9hE9fcnFsP8RS5YIxLF2iv0Og9WRJH4Eg+sIFva2ozIxfxc7qap9S7/mPF9RgfcP0b+T
         XMnZvzKqkRSiQ4oVkynxsHxFPc+1Idq+pGF/iu6OzBHL8fXJr6xRK8UlBCIQb7mosd1A
         L9Bc9+B8mFBorVrFzfNm7X7Q/sZ5SIkt4lsqngUnXFc1jrig8yClcb+dceJzepmGg/72
         DzWQ==
X-Gm-Message-State: AO0yUKWXXjvUz4hNZld6YJk4BVYtmU2XsP+7bhgaJ3Z5clOCORU2LL8c
        /Lp1JiWoGqpgxk6gAh2SYyaze+gWnc89Xc6bCmY0UQ==
X-Google-Smtp-Source: AK7set96nV5WxVAFJCuff1YfyXG1LVejzmkonDIYcfNUk89kau/aG+VyPFxYaHWrc+2i5u58w4j88wEOxo3FDLY30SQ=
X-Received: by 2002:a17:902:7841:b0:19d:1dfe:eac6 with SMTP id
 e1-20020a170902784100b0019d1dfeeac6mr3274257pln.1.1677721282551; Wed, 01 Mar
 2023 17:41:22 -0800 (PST)
MIME-Version: 1.0
References: <20230220183847.59159-1-michael.roth@amd.com> <20230220183847.59159-55-michael.roth@amd.com>
 <20230302020245.00006f57@gmail.com>
In-Reply-To: <20230302020245.00006f57@gmail.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Wed, 1 Mar 2023 17:41:11 -0800
Message-ID: <CAAH4kHY6jm9PHjuGj18eyCC8H4oksuNkVL=igAh4P4BTsKs2xA@mail.gmail.com>
Subject: Re: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance certs
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > @@ -2089,6 +2089,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >               goto e_free;
> >
> >       sev->snp_certs_data = certs_data;
> > +     sev->snp_certs_len = 0;
> >
> >       return context;
> >
>
> Better to move the fix to PATCH 45.
>

This part isn't a fix, but part of the implementation since
snp_certs_len is added in this patch here

> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 221b38d3c845..dced46559508 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -94,6 +94,7 @@ struct kvm_sev_info {
> >       u64 snp_init_flags;
> >       void *snp_context;      /* SNP guest context page */
> >       void *snp_certs_data;
> > +     unsigned int snp_certs_len; /* Size of instance override for certs */
> >       struct mutex guest_req_lock; /* Lock for guest request handling */
> >
> >       u64 sev_features;       /* Features set at VMSA creation */


-- 
-Dionna Glaze, PhD (she/her)
