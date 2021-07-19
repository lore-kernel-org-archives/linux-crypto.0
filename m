Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA33C07E9D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 17:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B4D6121F
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 17:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347902AbhGSQai (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 12:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345121AbhGSQ1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 12:27:10 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F321CC0613DD
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 09:33:19 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d9so5807850pfv.4
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 09:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pHb5bkAVRB42TqiPWwfLPH1AL+uUpnACNe29QjGSxaY=;
        b=wWjAGEqCZT2SqkCZwd6sWt/7nsE3FDiXvtXZl03cKrrWqWxHoKPQIrsffQjKJ13WG3
         EtmnIKLF+iUOmpw/nICZRgWdRYzg5CVsZ4JGG31bckuuXW2KmDIrtW0aUWPbywlk+Re+
         ysYfGknbrkm6/fCX4e++AOlHrp85izifA31B0RM/WNmTyYeytvj3aGvaPOIheZbXd6Qg
         +f65RrcEPsNUtrQthvx/IqpwUYrZZlqBFKSDm3xxgdP4+/YqaSNRZrvRYVhpZxne3Fe3
         4pVNYC8FKZniaUHFqa3DGzuzMaVvBRv5hVoqiViY8Pgmw9z/gHkKcxQSKlLSDnwzB6Eb
         AujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pHb5bkAVRB42TqiPWwfLPH1AL+uUpnACNe29QjGSxaY=;
        b=SM9Y1+swRT6PLk/koiW3zg34wgPUZbCq1sWkRFVjINvxLDqGnO0LWr1YBpV+VGM7lW
         EPi37W+AykItN1eTrQRU5jCGu9xJioKKfNmRq8WpMUrsWMYX9KwPa4yHbqYWwyvLqLvV
         +U2EbKgzYwPHZuCXspdVF09GVH7Ve95ATWC+L39rvt3plxU1n+aezFGVYPxzQWGx2H2F
         Ca3HzfdwKtQYlo1M7dxqwYaXL5k6rCs5wuKrnv2SWoF0XEC5esmMB5SH7ghzEVkM1Vfb
         5nE50Hr0UR7zE+ZSnCtiyP3WonMK/3jpAq1UbTD0ae3oxgY+odqXpcA3LRKeFEZfAsDC
         gR5A==
X-Gm-Message-State: AOAM5317lmywu299vITjFSitpQMXjNQYCNY6vWFjVE8Nb3thTydqt43M
        9DpjGJuRCgYJZTbIhEnygy9pLg==
X-Google-Smtp-Source: ABdhPJzjdliagIIxw89Ud0WLqDwORLqyx5dLKpfYjX5Qr2Jo5aV2ovPM9l2YmkMyXrKafSxH6Usw+Q==
X-Received: by 2002:a65:648f:: with SMTP id e15mr26154606pgv.165.1626713689551;
        Mon, 19 Jul 2021 09:54:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q11sm25570pjd.30.2021.07.19.09.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 09:54:48 -0700 (PDT)
Date:   Mon, 19 Jul 2021 16:54:45 +0000
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
Subject: Re: [PATCH Part2 RFC v4 26/40] KVM: SVM: Add
 KVM_SEV_SNP_LAUNCH_FINISH command
Message-ID: <YPWuVY+rKU2/DVUS@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-27-brijesh.singh@amd.com>
 <YPHpk3RFSmE13ZXz@google.com>
 <9ee5a991-3e43-3489-5ee1-ff8c66cfabc1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ee5a991-3e43-3489-5ee1-ff8c66cfabc1@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 16, 2021, Brijesh Singh wrote:
> 
> On 7/16/21 3:18 PM, Sean Christopherson wrote:
> > On Wed, Jul 07, 2021, Brijesh Singh wrote:
> >> +	data->gctx_paddr = __psp_pa(sev->snp_context);
> >> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
> > Shouldn't KVM unwind everything it did if LAUNCH_FINISH fails?  And if that's
> > not possible, take steps to make the VM unusable?
> 
> Well, I am not sure if VM need to unwind. If the command fail but VMM decide
> to ignore the error then VMRUN will probably fail and user will get the KVM
> shutdown event. The LAUNCH_FINISH command finalizes the VM launch process,
> the firmware will probably not load the memory encryption keys until it moves
> to the running state.

Within reason, KVM needs to provide consistent, deterministic behavior.  Yes, more
than likely failure at this point will be fatal to the VM, but that doesn't justify
leaving the VM in a random/bogus state.  In addition to being a poor ABI, it also
makes it more difficult to reason about what is/isn't possible in KVM.

> >> +	 */
> >> +	if (sev_snp_guest(vcpu->kvm)) {
> >> +		struct rmpupdate e = {};
> >> +		int rc;
> >> +
> >> +		rc = rmpupdate(virt_to_page(svm->vmsa), &e);
> > So why does this not need to go through snp_page_reclaim()?
> 
> As I said in previous comments that by default all the memory is in the
> hypervisor state. if the rmpupdate() failed that means nothing is changed in
> the RMP and there is no need to reclaim. The reclaim is required only if the
> pages are assigned in the RMP table.

I wasn't referring to RMPUPDATE failing here (or anywhere).  This is the vCPU free
path, which I think means the svm->vmsa page was successfully updated in the RMP
during LAUNCH_UPDATE.  snp_launch_update_vmsa() goes through snp_page_reclaim()
on LAUNCH_UPDATE failure, whereas this happy path does not.  Is there some other
transition during teardown that obviastes the need for reclaim?  If so, a comment
to explain that would be very helpful.
