Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932CEC7EE2F
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jun 2023 17:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbjFLRId (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbjFLRIb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 13:08:31 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058D310F4
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 10:08:25 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f58444a410so142e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2023 10:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686589703; x=1689181703;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hPHA2iInW/5MWEIDY5sRw7hsczk67ay7y9vys8rDT34=;
        b=JGfnzKQxNy5ZG+svk3pKWyN7ndYnw6Cg9NfAVLy+p80Ss4DBGYrgTioADx2kTru1sI
         Jiw4Cq4n4CvBniPpQdYSG0bgvTXC/lCBZWwzRI7ImGoniwCx5RT1mmyE3fAVGSZuo6rl
         kOLCwE/HMFlIkIC68lxhIo0g1ynyfizgcrAin0y7fQOFLdZJL5qPtHBMIMc9HeTz8j3C
         FV6Fe3V1rWxDiUqDjzbJEvoouy9sNYhVLzaF2X0FSyMHSmG8McHmXGU1sd5SgwDQWOqk
         lh1TtdgZNNeeCJXKMM8jvJSHzd5f0xl+QTVGjqiepFPlYV7S5SME39tqQGLNNvDwTNuQ
         OaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686589703; x=1689181703;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPHA2iInW/5MWEIDY5sRw7hsczk67ay7y9vys8rDT34=;
        b=afHWF2sW7wyYcuffG1sY4RXgKkc+TDEXEBonTWEGOeF40NQKR7SlXHFEUomcB3bY98
         AlMFG8rNxtvqje3O0Yw3dNvM0FWJga2EACNpL2ofQGyL2YBU4N2spFuj9qcQPZhlfKt8
         hdKd+wVT3P6yCOvMQhR/AZWfNM7I60lfB5IbXVGSjLTNiXxjvVjHdPkCVnNb9uNAnS16
         jBXEeuMtZHbQVY23SdCFyZyzbzRNEskMdajZNP0j45uRdd1+uXuYPaC21g68RWv1Jh+S
         QLyZyslTlyzBkO/5j9hmjQl9gHcxDUrQsMCGBkyE2ZKUgDKNY2CJqLtEZHgikRRFnL0i
         M1Aw==
X-Gm-Message-State: AC+VfDzsbRHpW+uz3uJOp5sJUj69YwGli7fa1Ofb3dCyCIfVuTcIgby3
        6GNS5Rwrllx4NOVg8pTvEy8DnR2JMARU6p0Xp3HVyQ==
X-Google-Smtp-Source: ACHHUZ75qxKnzvhiDDf0D5IcWH78fHsJ5oE2uWNN4sR3H9U9eFd+mPr5PWjgybS2SATgWNhLMY+e7X97TQ0uvb78OYc=
X-Received: by 2002:ac2:4c39:0:b0:4f6:1722:d73a with SMTP id
 u25-20020ac24c39000000b004f61722d73amr147507lfq.5.1686589702990; Mon, 12 Jun
 2023 10:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230612042559.375660-1-michael.roth@amd.com> <20230612042559.375660-30-michael.roth@amd.com>
In-Reply-To: <20230612042559.375660-30-michael.roth@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 12 Jun 2023 11:08:11 -0600
Message-ID: <CAMkAt6qQ73ah0UW2sTh8CYNgMhWRMQ7bVxH5bWpVfCR-ncnZuQ@mail.gmail.com>
Subject: Re: [PATCH RFC v9 29/51] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> +
> +static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_launch_start start = {0};
> +       struct kvm_sev_snp_launch_start params;
> +       int rc;
> +
> +       if (!sev_snp_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +               return -EFAULT;
> +
> +       sev->snp_context = snp_context_create(kvm, argp);
> +       if (!sev->snp_context)
> +               return -ENOTTY;


I commented on a  previous series but I think the bug is still here. I
think users can repeatedly call KVM_SEV_SNP_LAUNCH_START to have KVM
keep allocating more snp_contexts above.

Should we check if the VM already has a |snp_context| and error out if so?

>
> +
> +       start.gctx_paddr = __psp_pa(sev->snp_context);
> +       start.policy = params.policy;
> +       memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> +       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
> +       if (rc)
> +               goto e_free_context;
> +
> +       sev->fd = argp->sev_fd;
> +       rc = snp_bind_asid(kvm, &argp->error);
> +       if (rc)
> +               goto e_free_context;
> +
> +       return 0;
> +
> +e_free_context:
> +       snp_decommission_context(kvm);
> +
> +       return rc;
> +}
> +
