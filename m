Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE75CCA47D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jun 2022 23:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbiFMXeB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiFMXd7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jun 2022 19:33:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ADB30F4A
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2022 16:33:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d123so7761162iof.10
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2022 16:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7klOn/n2ISdaUz2eIXWWcqcQBg4U27lMXyVywy5WCjY=;
        b=Pt4uO6D7w05L89kAG3AkG+VxqIN5vQCQvkc++FaNCyNy9/ogT1Ad0WIp6FP8U/vQuC
         yFLRfhV+TzvsbtTPTdGrp72FAJibDLhuymdGCxaZzVcgAH3SavqY82+mFTytm1tPar5L
         9iiyBdo7zbMda9RS5PZWg38dm0N+aCbgyjgdQd0unSij+sCHtpj4VLdBmD5/kvVWbAoE
         DiF86xT2V+XxAJyxF+uWMQNILr+Lf9HKFX5kHTYPX02VMujTkqw63eVGKjQ/tA1W7XGV
         MS6cGtitxY5fPKKS3usaM9YWExzYnli+wkopye1Dwum6g6Qw11KUth03Gdx7AdVFwtVw
         00Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7klOn/n2ISdaUz2eIXWWcqcQBg4U27lMXyVywy5WCjY=;
        b=VV0mMMxgNoE9/8+Vlp6vguXJTiUBPjzlMh7DgdPGKhHnTg0bSbTaafwT+9fhNcdzsD
         KUI3RssEnSM/UoX2I6AL6P6jWPvbHbglJ9jj9r6FoT1pJk5YuHUETuLl8aiBXu3wzpmk
         AFjUlN8pleUFWfvCGEjbuky94vQvxZj3ptAX6PFi54AdGnCvL+esIT2Ps50TSyjwX0g1
         Wrj/ha3vGfWyR0ojiPfRa08FdhaJuUcnC8+L+FnGeoRufLq6bXLuLJNXm/M6PbJa0y7x
         IOTId6QJVMOfwc0C7FeTt/mZGKijr45V1vPo5wG3v4fWhZz5iyUdX1yL59OxuosvQTPw
         j4jA==
X-Gm-Message-State: AOAM533/8LfhaDFYGOcvvahCF+6MgZJyAvelgnxO/I3sS82jEnFl/N4m
        XdjyL5/AaQBvxF6vLEmDNJV3RfhIH8vlQMZEwx98RA==
X-Google-Smtp-Source: ABdhPJxEJgKvL2Ty4cQM8Q/E8hNQ4MW6ddzj/3hqzuY2s0vPDzhpxWeDKErRLXXBzTFpsF41SPGyqn1nwEtc03ExiTs=
X-Received: by 2002:a5e:c30b:0:b0:668:825c:8556 with SMTP id
 a11-20020a5ec30b000000b00668825c8556mr1092877iok.68.1655163237901; Mon, 13
 Jun 2022 16:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com> <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
In-Reply-To: <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 13 Jun 2022 16:33:46 -0700
Message-ID: <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Ashish Kalra <ashkalra@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, Ashish.Kalra@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 13, 2022 at 4:15 PM Ashish Kalra <ashkalra@amd.com> wrote:
>
> Hello Alper,
>
> On 6/13/22 20:58, Alper Gun wrote:
> > static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>   {
> >> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
> >>          struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
> >> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
> >>          int asid, ret;
> >>
> >>          if (kvm->created_vcpus)
> >> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>                  return ret;
> >>
> >>          sev->es_active = es_active;
> >> +       sev->snp_active = snp_active;
> >>          asid = sev_asid_new(sev);
> >>          if (asid < 0)
> >>                  goto e_no_asid;
> >>          sev->asid = asid;
> >>
> >> -       ret = sev_platform_init(&argp->error);
> >> +       if (snp_active) {
> >> +               ret = verify_snp_init_flags(kvm, argp);
> >> +               if (ret)
> >> +                       goto e_free;
> >> +
> >> +               ret = sev_snp_init(&argp->error);
> >> +       } else {
> >> +               ret = sev_platform_init(&argp->error);
> > After SEV INIT_EX support patches, SEV may be initialized in the platform late.
> > In my tests, if SEV has not been initialized in the platform yet, SNP
> > VMs fail with SEV_DF_FLUSH required error. I tried calling
> > SEV_DF_FLUSH right after the SNP platform init but this time it failed
> > later on the SNP launch update command with SEV_RET_INVALID_PARAM
> > error. Looks like there is another dependency on SEV platform
> > initialization.
> >
> > Calling sev_platform_init for SNP VMs fixes the problem in our tests.
>
> Trying to get some more context for this issue.
>
> When you say after SEV_INIT_EX support patches, SEV may be initialized
> in the platform late, do you mean sev_pci_init()->sev_snp_init() ...
> sev_platform_init() code path has still not executed on the host BSP ?
>

Correct, INIT_EX requires the file system to be ready and there is a
ccp module param to call it only when needed.

MODULE_PARM_DESC(psp_init_on_probe, " if true, the PSP will be
initialized on module init. Else the PSP will be initialized on the
first command requiring it");

If this module param is false, it won't initialize SEV on the platform
until the first SEV VM.

> Before launching the first SNP/SEV guest launch after INIT, we need to
> issue SEV_CMD_DF_FLUSH command.
>
> I assume that we will always be initially doing SNP firmware
> initialization with SNP_INIT command followed by sev_platform_init(), if
> SNP is enabled on boot CPU.
>
> Thanks, Ashish
>
