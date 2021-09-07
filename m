Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AC0C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Sep 2021 23:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F330610A3
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Sep 2021 23:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346385AbhIGXil (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Sep 2021 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240071AbhIGXil (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Sep 2021 19:38:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592BEC061757
        for <linux-crypto@vger.kernel.org>; Tue,  7 Sep 2021 16:37:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so174912pjr.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Sep 2021 16:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nPlOnObV+7IafwUpE6JONJNl4l7ItG2KBzqpYLFaSDI=;
        b=lWWLU21jXgpKCcMeJzCV3mM/lYIHHadbLLphHrMJR6nzn7nm2hNVFSLmcqJrNG0Qwp
         bnQJJAnfVzg4zo6YOeHON52TeqlHsw4Drj7PZIScPVABqqMLRnlfAftu1J/nOHlphYj3
         AENC5G+npvkCsN1bC0NYqOLRePIIGmz8Pxxyf0H97Uv+0AczlJ/j16ADKk8nSSo3x2XE
         Fp+NPLlky2UtHIBoZTqz/epUy8trKjNxNlGpcO6mK9eHXkHosjfqo7Cd9489Jra2zIGc
         NwjhHFqBdWRHvkCEQ7h3diyH+2pgz1UtjgxZH8dM/hWQVsztbBSbJyOYj6nsjCjDD0Jm
         6X1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nPlOnObV+7IafwUpE6JONJNl4l7ItG2KBzqpYLFaSDI=;
        b=VUa5JPtbcDYR5DLDCSGonAswxYCLwjOW8MQKn0iYWUylVhWscvioCBABj3Bv324pER
         smT7teh9Vl10VDA9pTs0dVlCdR63+tCvkdj75ySbce9RlOf+h5tDrUzh1ImZGa7Bnqwl
         tIepq5rwmZsnfQxhwj7eeZ/McIiF8TXn38CYm74pk+VWMPhKTtRACLczIZyvbvN1zY5S
         XWOTIklf16GS5xUdp3D0dK6rL/5693cdOExXiqP4DGoOoqW4H8iMJwYw5v3dyQGjwHn8
         tkjX7avCP5T2sZqkDVnneEruFOy56cJ4zzPvHDQRyP+jQjoCFyeu/LXDgHP9tyuBAtXE
         L1ig==
X-Gm-Message-State: AOAM531iF/F1CZARKNKY5XXyK/+M7QQly0STN59BScd0fGdxtWY8J0UY
        rS7KZMICr8gPHsgaSmX93SacVunRwh2iDA==
X-Google-Smtp-Source: ABdhPJyJqG6oPEYS1iJvCqYIi+YU5oYd8fIoUn5t6j6xhWDd2stQtnMMncIdKYaRCEKIlXO024qe8Q==
X-Received: by 2002:a17:90a:192:: with SMTP id 18mr945730pjc.119.1631057853662;
        Tue, 07 Sep 2021 16:37:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b13sm146800pjk.35.2021.09.07.16.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 16:37:32 -0700 (PDT)
Date:   Tue, 7 Sep 2021 23:37:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
Message-ID: <YTf3udAv1TZzW+xA@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com>
 <YTJ5wjNShaHlDVAp@google.com>
 <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 07, 2021, Brijesh Singh wrote:
> 
> On 9/3/21 2:38 PM, Sean Christopherson wrote:
> > My personal preference is obviously to work towards an abstracted API.  And if
> > we decide to go that route, I think we should be much more aggressive with respect
> > to what is abstracted.   Many of the functions will be rather gross due to the
> > sheer number of params, but I think the end result will be a net positive in terms
> > of readability and separation of concerns.
> > 
> > E.g. get KVM looking like this
> > 
> > static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > {
> > 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > 	struct kvm_sev_receive_start params;
> > 	int ret;
> > 
> > 	if (!sev_guest(kvm))
> > 		return -ENOTTY;
> > 
> > 	/* Get parameter from the userspace */
> > 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > 			sizeof(struct kvm_sev_receive_start)))
> > 		return -EFAULT;
> > 
> > 	ret = sev_guest_receive_start(argp->sev_fd, &arpg->error, sev->asid,
> > 				      &params.handle, params.policy,
> > 				      params.pdh_uaddr, params.pdh_len,
> > 				      params.session_uaddr, params.session_len);
> > 	if (ret)
> > 		return ret;
> > 
> > 	/* Copy params back to user even on failure, e.g. for error info. */
> > 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
> > 			 &params, sizeof(struct kvm_sev_receive_start)))
> > 		return -EFAULT;
> > 
> >      	sev->handle = params.handle;
> > 	sev->fd = argp->sev_fd;
> > 	return 0;
> > }
> > 
> 
> I have no strong preference for either of the abstraction approaches. The
> sheer number of argument can also make some folks wonder whether such
> abstraction makes it easy to read. e.g send-start may need up to 11.

Yeah, that's brutal, but IMO having a few ugly functions is an acceptable cost if
it means the rest of the API is cleaner.  E.g. KVM is not the right place to
implement sev_deactivate_lock, as any coincident DEACTIVATE will be problematic.
The current code "works" because KVM is the only in-tree user, but even that's a
bit of a grey area because sev_guest_deactivate() is exported.

If large param lists are problematic, one idea would be to reuse the sev_data_*
structs for the API.  I still don't like the idea of exposing those structs
outside of the PSP driver, and the potential user vs. kernel pointer confusion
is more than a bit ugly.  On the other hand it's not exactly secret info,
e.g. KVM's UAPI structs are already excrutiatingly close to sev_data_* structs.

For future ioctls(), KVM could even define UAPI structs that are bit-for-bit
compatible with the hardware structs.  That would allow KVM to copy userspace's
data directly into a "struct sev_data_*" and simply require the handle and any
other KVM-defined params to be zero.  KVM could then hand the whole struct over
to the PSP driver for processing.

We can even do a direct copy to sev_data* with KVM's current UAPI by swapping
fields as necessary, e.g. swap policy<->handle before and after send-start, but
that's all kinds of gross and probably not a net positive.
