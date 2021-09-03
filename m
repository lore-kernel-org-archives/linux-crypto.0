Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552DAC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 19:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E2760F42
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 19:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348939AbhICTjt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Sep 2021 15:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349865AbhICTjr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Sep 2021 15:39:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A6C0613C1
        for <linux-crypto@vger.kernel.org>; Fri,  3 Sep 2021 12:38:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso231262pjh.5
        for <linux-crypto@vger.kernel.org>; Fri, 03 Sep 2021 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzhaz9XxDSm1ugGQAic1jSV4h3dO1CWRqJG/Wa1eKqo=;
        b=Q4g8O/XPm2u0b/cy1Hw89zcNMj9oiX+bRd+8mJDYqYQ8LqTxTaTrNWdtwP4bLcnUkU
         eMWjtXHzk5yzQKvQBZz1g+zzocaHQ9MQmA8qY4buy+vaNmp5diQC16nhwre2uxT+p8vV
         JaPlc6nRsTMCMhGj/qmDvfSk+tKUB6VvKpq9Gv4jj25FmVwK/Bdzgw/LlzdZO6aAJQv5
         f1EqIV23Wb6apk3n3WO4d0Tzr00atX0sfTt+1Q6zmCti6z/NPft5/mzAJJpR+1wmv7ml
         Q385PdhiwJginqPZ/Re4d9EE91NU4GLKOycCnmXK4odaYvOj4A5XwF2/tqj8Hh6UoDX4
         Ku8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzhaz9XxDSm1ugGQAic1jSV4h3dO1CWRqJG/Wa1eKqo=;
        b=j8fEZm1A2XBvYkYZtIdxO64gD0MAxTKahxDQODFmuR/0RNWdXe0uQ5cXbv1ea60auZ
         xYMzf+q5Yp+aJs8aySQ2lSNVfgyPAqpEPC4nOXgRCi1E1C+Fjbj4GMQwtxzUmmdEAKNX
         OkcXQbLf3smWuiIysD+qg8dc+g05Szme9iIuqCAUQVcXZoPhzXe1fnyh0mjj+wiYDfMS
         BH/yDg9UtW71C0UC/gsQp9vvrMnhuv0n7GutVCPg+p/Uuu84mB5pBv8WK6dEG1btl9zk
         XIWQ1QWJBGlYFTVnxjzRT0U3c7DYmORLxqxWblKxGjkpDSpNb5EwDyR2xlL3x1WAyWCT
         IuVA==
X-Gm-Message-State: AOAM532NCcJWnUDEFBecqKWobJ/hvdw+TPiPskfJ4vqs6yurtXegAXkN
        /XnstGS/gFZgeK/PvpUo49dzzQ==
X-Google-Smtp-Source: ABdhPJxAbMzCuFmt0f4TsCM6x099HH8zwapkycmIw+PDBp1H5EAVUuuq+cobTGIsNH17Vprk8NCwxQ==
X-Received: by 2002:a17:90b:4b4f:: with SMTP id mi15mr497532pjb.120.1630697926927;
        Fri, 03 Sep 2021 12:38:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q20sm180458pgu.31.2021.09.03.12.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 12:38:46 -0700 (PDT)
Date:   Fri, 3 Sep 2021 19:38:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
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
Message-ID: <YTJ5wjNShaHlDVAp@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818053908.1907051-4-mizhang@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 18, 2021, Mingwei Zhang wrote:
> @@ -336,11 +322,9 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free_session;
>  
>  	/* Bind ASID to this guest */
> -	ret = sev_bind_asid(kvm, start.handle, error);
> -	if (ret) {
> -		sev_guest_decommission(start.handle, NULL);
> +	ret = sev_guest_bind_asid(sev_get_asid(kvm), start.handle, error);
> +	if (ret)
>  		goto e_free_session;
> -	}
>  
>  	/* return handle to userspace */
>  	params.handle = start.handle;

...

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e2d49bedc0ef..325e79360d9e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -903,6 +903,21 @@ int sev_guest_activate(struct sev_data_activate *data, int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_guest_activate);
>  
> +int sev_guest_bind_asid(int asid, unsigned int handle, int *error)
> +{
> +	struct sev_data_activate activate;
> +	int ret;
> +
> +	/* activate ASID on the given handle */
> +	activate.handle = handle;
> +	activate.asid   = asid;
> +	ret = sev_guest_activate(&activate, error);
> +	if (ret)
> +		sev_guest_decommission(handle, NULL);

Hrm, undoing state like this is a bad API.  It assumes the caller is well-behaved,
e.g. has already done something that requires decommissioning, and it surprises
the caller, e.g. the KVM side (above) looks like it's missing error handling.
Something like this would be cleaner overall:

	/* create memory encryption context */
	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, &start,
				error);
	if (ret)
		goto e_free_session;

	/* Bind ASID to this guest */
	ret = sev_guest_activate(sev_get_asid(kvm), start.handle, error);
	if (ret)
		goto e_decommision;

	params.handle = start.handle;
	if (copy_to_user((void __user *)(uintptr_t)argp->data,
			 &params, sizeof(struct kvm_sev_receive_start))) {
		ret = -EFAULT;
		goto e_deactivate;
	}

    	sev->handle = start.handle;
	sev->fd = argp->sev_fd;

e_deactivate:
	sev_guest_deactivate(sev_get_asid(kvm), start.handle, error);
e_decommision:
	sev_guest_decommission(start.handle, error);
e_free_session:
	kfree(session_data);
e_free_pdh:
	kfree(pdh_data);


However, I don't know that that's a good level of abstraction, e.g. the struct
details are abstracted from KVM but the exact sequencing is not, which is odd
to say the least.

Which is a good segue into my overarching complaint about the PSP API and what
made me suggest this change in the first place.  IMO, the API exposed to KVM (and
others) is too low level, e.g. KVM is practically making direct calls to the PSP
via sev_issue_cmd_external_user().  Even the partially-abstracted helpers that
take a "struct sev_data_*" are too low level, KVM really shouldn't need to know
the hardware-defined structures for an off-CPU device.

My intent with the suggestion was to start driving toward a mostly-abstracted API
across the board, with an end goal of eliminating sev_issue_cmd_external_user()
and moving all of the sev_data* structs out of psp-sev.h and into a private
header.  However, I think we should all explicitly agree on the desired level of
abstraction before shuffling code around.

My personal preference is obviously to work towards an abstracted API.  And if
we decide to go that route, I think we should be much more aggressive with respect
to what is abstracted.   Many of the functions will be rather gross due to the
sheer number of params, but I think the end result will be a net positive in terms
of readability and separation of concerns.

E.g. get KVM looking like this

static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
{
	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
	struct kvm_sev_receive_start params;
	int ret;

	if (!sev_guest(kvm))
		return -ENOTTY;

	/* Get parameter from the userspace */
	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
			sizeof(struct kvm_sev_receive_start)))
		return -EFAULT;

	ret = sev_guest_receive_start(argp->sev_fd, &arpg->error, sev->asid,
				      &params.handle, params.policy,
				      params.pdh_uaddr, params.pdh_len,
				      params.session_uaddr, params.session_len);
	if (ret)
		return ret;

	/* Copy params back to user even on failure, e.g. for error info. */
	if (copy_to_user((void __user *)(uintptr_t)argp->data,
			 &params, sizeof(struct kvm_sev_receive_start)))
		return -EFAULT;

    	sev->handle = params.handle;
	sev->fd = argp->sev_fd;
	return 0;
}
