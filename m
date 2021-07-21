Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0107AC6377D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 19:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFEB961221
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 19:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbhGUTM1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 15:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbhGUTM0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 15:12:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6314DC061575
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 12:53:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c15so1610537pls.13
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 12:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ZFdogakN+U+D6SX6LhX2SwuYGYaPQsFnYtn2JJoTak=;
        b=tvsyIWhNU3cg/xV3WaOgqDwBpspmMJ50HUSKczTQOHxoia0Gf97fLeNPk6repjxMxU
         5jlQjcRGy7FAvAeYmsOGOEYiTkvB0EteJixLlWUNljGhhG0PxH0M7Jr0YMrWsiBC+SVB
         pIOpLAoFAx54KbgFB0OJI2cv1cLaVXjySbSkqcTiKacy5Jiswx7XbaxYaezXwq5abeO8
         d9qYtq/rp/48EjBy9Fe3JmA2tU0HXYTEFUlhqjbmenaY06xhIi59kAojLPYzjgdIIkUG
         pwhusBBAxUzr7N/6g9a8yVt99NfLdGGQmtyY79jbo2dQWDvQacDkC6QpUzuye67Hh0CG
         pWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ZFdogakN+U+D6SX6LhX2SwuYGYaPQsFnYtn2JJoTak=;
        b=iDeuZQdgOY8Cb0OGDY3StfqGAV0iUR+RMz9Td4PzzE5bthQhsvecRC8jZANnbn1Xxa
         ApNM1i1GSngtjv4VzqG/g6xJwbMOyPFiRiqqT6Vp6kP7waW3WnYBe2NfNSjvhLQ0TYsE
         0HZmMF6CwfvvF1kcgwuO50VWbSLPboFECZ19bmGooEtAVkRECEA//HHwePZvGQG0mOfE
         qO76wEkiwsMs8TJ509mGQaRMD6Q64qJ0eA5u0oehhXo0L5d9XYBChYgpzi+UvHFdX1lt
         Tku5MHY11bBg0dCm4VeRpooLt4u/IvE8yEFIo0/g+2+OGT8cZKMlCxiazMpL0mXuASSZ
         WKjg==
X-Gm-Message-State: AOAM532iRv2vS3iMsPw+Egn7Lo5hI9izUqse3MLRlYx1GMRlxTnvGBVL
        0zxWIRydg3fXfRppB6wrXn3K2g==
X-Google-Smtp-Source: ABdhPJx0SNXBSozA1zqonbwhhcSmrLxNop72v66ohRghPV4r836hvfWk3fIwfoZPziXuNwE9t9Hl/Q==
X-Received: by 2002:a17:90b:2382:: with SMTP id mr2mr5315994pjb.169.1626897180725;
        Wed, 21 Jul 2021 12:53:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 5sm31461466pgv.25.2021.07.21.12.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 12:52:59 -0700 (PDT)
Date:   Wed, 21 Jul 2021 19:52:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
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
Subject: Re: [PATCH Part2 RFC v4 40/40] KVM: SVM: Support SEV-SNP AP Creation
 NAE event
Message-ID: <YPh7F2talucL7FQ9@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-41-brijesh.singh@amd.com>
 <YPdjvca28JaWPZRb@google.com>
 <c007821a-3a79-d270-07af-eb7d4c2d0862@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c007821a-3a79-d270-07af-eb7d4c2d0862@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 21, 2021, Tom Lendacky wrote:
> On 7/20/21 7:01 PM, Sean Christopherson wrote:
> > On Wed, Jul 07, 2021, Brijesh Singh wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >> +
> >> +		svm->snp_vmsa_pfn = pfn;
> >> +
> >> +		/* Use the new VMSA in the sev_es_init_vmcb() path */
> >> +		svm->vmsa_pa = pfn_to_hpa(pfn);
> >> +		svm->vmcb->control.vmsa_pa = svm->vmsa_pa;
> >> +
> >> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> >> +	} else {
> >> +		vcpu->arch.pv.pv_unhalted = false;
> > 
> > Shouldn't the RUNNABLE path also clear pv_unhalted?
> 
> If anything it should set it, since it will be "unhalted" now. But, I
> looked through the code to try and understand if there was a need to set
> it and didn't really see any reason. It is only ever set (at least
> directly) in one place and is cleared everywhere else. It was odd to me.

pv_unhalted is specifically used for a "magic" IPI (KVM hijacked a defunct
IPI type) in the context of PV spinlocks.  The idea is that a vCPU that's releasing
a spinlock can kick the next vCPU in the queue, and KVM will directly yield to the
vCPU being kicked so that the guest can efficiently make forward progress.

So it's not wrong to leave pv_unhalted as is, but it's odd to clear it in the
DESTROY case but not CREATE_INIT case.  It should be a moot point, as a sane
implementation should make it impossible to get to CREATE with pv_unhalted=1.

> >> +		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
> > 
> > What happens if userspace calls kvm_arch_vcpu_ioctl_set_mpstate, or even worse
> > the guest sends INIT-SIPI?  Unless I'm mistaken, either case will cause KVM to
> > run the vCPU with vmcb->control.vmsa_pa==0.
> 
> Using the INVALID_PAGE value now (and even when it was 0), you'll get a
> VMRUN failure.
> 
> The AP CREATE_ON_INIT is meant to be used with INIT-SIPI, so if the guest
> hasn't done the right thing, then it will fail on VMRUN.
> 
> > 
> > My initial reaction is that the "offline" case needs a new mp_state, or maybe
> > just use KVM_MP_STATE_STOPPED.
> 
> I'll look at KVM_MP_STATE_STOPPED. Qemu doesn't reference that state at
> all in the i386 support, though, which is why I went with UNINITIALIZED.

Ya, it'd effectively be a new feature.  My concern with UNINITIALIZED is that it
be impossible for KVM to differentiate between "never run" and "destroyed and may
have an invalid VMSA" without looking at the VMSA.

> >> +	mutex_lock(&target_svm->snp_vmsa_mutex);
> > 
> > This seems like it's missing a big pile of sanity checks.  E.g. KVM should reject
> > SVM_VMGEXIT_AP_CREATE if the target vCPU is already "created", including the case
> > where it was "created_on_init" but hasn't yet received INIT-SIPI.
> 
> Why? If the guest wants to call it multiple times I guess I don't see a
> reason that it would need to call DESTROY first and then CREATE. I don't
> know why a guest would want to do that, but I don't think we should
> prevent it.

Because "creating" a vCPU that already exists is non-sensical.  Ditto for
onlining a vCPU that is already onlined.  E.g. from the guest's perspective, I
would fully expect a SVM_VMGEXIT_AP_CREATE to fail, not effectively send the vCPU
to an arbitrary state.

Any ambiguity as to the legality of CREATE/DESTROY absolutely needs to be clarified
in the GHCB.

> >> +
> >> +	target_svm->snp_vmsa_gpa = 0;
> >> +	target_svm->snp_vmsa_update_on_init = false;
> >> +
> >> +	/* Interrupt injection mode shouldn't change for AP creation */
> >> +	if (request < SVM_VMGEXIT_AP_DESTROY) {
> >> +		u64 sev_features;
> >> +
> >> +		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> >> +		sev_features ^= sev->sev_features;
> >> +		if (sev_features & SVM_SEV_FEATURES_INT_INJ_MODES) {
> > 
> > Why is only INT_INJ_MODES checked?  The new comment in sev_es_sync_vmsa() explicitly
> > states that sev_features are the same for all vCPUs, but that's not enforced here.
> > At a bare minimum I would expect this to sanity check SVM_SEV_FEATURES_SNP_ACTIVE.
> 
> That's because we can't really enforce it. The SEV_FEATURES value is part
> of the VMSA, of which the hypervisor has no insight into (its encrypted).
> 
> The interrupt injection mechanism was specifically requested as a sanity
> check type of thing during the GHCB review, and as there were no
> objections, it was added (see the end of section 4.1.9).
> 
> I can definitely add the check for the SNP_ACTIVE bit, but it isn't required.

I'm confused.  If we've no insight into what the guest is actually using, what's
the point of the INT_INJ_MODES check?
