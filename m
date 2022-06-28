Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFBFC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jun 2022 13:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbiF1N36 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jun 2022 09:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346450AbiF1N3O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jun 2022 09:29:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2A8821828
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 06:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656422898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PH7wMQRYi1ZWFVxyL/3d+sZ7rcf181kH7ObPj88vxe0=;
        b=TCjYsq9XEdoy0jbmQXqcg2qcWB13azoELplc8JkC1XvnSHTnfhJRBpfavpM1tYh48xmR/Q
        CIPK/tgpSd3BU0vCJ+UOHUfGOdyMLYlLNBsDcIHCpqHxYpThXR4LxX+m4dw+ozZW0gtP0j
        WK4lYd4EgaQLkEg3Le00JgezpVx8Goc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-iBLMObpOO4GygNoCkI_yFg-1; Tue, 28 Jun 2022 09:28:17 -0400
X-MC-Unique: iBLMObpOO4GygNoCkI_yFg-1
Received: by mail-wr1-f69.google.com with SMTP id e5-20020adff345000000b0021b9f00e882so1791732wrp.6
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 06:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PH7wMQRYi1ZWFVxyL/3d+sZ7rcf181kH7ObPj88vxe0=;
        b=r89SFnp10O7X0SBtX8ls71aR5nIP0pA0ZO/H3v3VGRSUjKJ+Zmhki3nKfNsevqVuyo
         eh3L4Z8l4Vfzqbf+GzdJDiBVCRjEQX6G2atW3E6BsfX6ThrR5Ga5fCnUv9vCqZqqos1S
         6IQSfVUQ4WJME5n4I6+O+u9nW/2FA5n3VyidPICTjnqwtYOMFHmz+Ci6YmHdOibYezVp
         mpLQPVlkvTnStjQ9C6eXVDtplwIq6cS7C0AfdL7AYSi1R0RNhV4VOo+UmfhFS1Drue9n
         Ut3lZyDZXKVT5dN4FSakHfleUcwaPvNXkknFDCGzmeWt8jEdw2+clUO2U+Trc/u+ZtwP
         9i/A==
X-Gm-Message-State: AJIora/zGSmyEnkODTiUjydFm/GXxlCcE6mI7VfPHG+Ww5fwgebdBR+7
        qTwf11qhGzpzz3aG+eguTYiBAaJ/nnBVK4oQ67GZKfQ/YXEnwn8jue10n3L+8jAbH1lwJdYiO9q
        81iKe8ezW1GNF8uvdStQadP0M
X-Received: by 2002:a5d:5047:0:b0:21b:92b2:f34f with SMTP id h7-20020a5d5047000000b0021b92b2f34fmr17127813wrt.677.1656422896237;
        Tue, 28 Jun 2022 06:28:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tqVf5A7KSxbTw31AFhCSUb6QIduyx0h8n4yb62+NQ1QBxlS5VZpJjh7TfSMSbhzJ+0xSz+Vw==
X-Received: by 2002:a5d:5047:0:b0:21b:92b2:f34f with SMTP id h7-20020a5d5047000000b0021b92b2f34fmr17127781wrt.677.1656422895955;
        Tue, 28 Jun 2022 06:28:15 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id w9-20020a5d6089000000b0020e5b4ebaecsm13771290wrt.4.2022.06.28.06.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:28:15 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:28:12 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 36/49] KVM: SVM: Add support to handle GHCB GPA
 register VMGEXIT
Message-ID: <YrsB7G4NSgJ+vKVw@work-vm>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <c2c4d365b4616c83ab2fb91b7c89d13535de8c0a.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2c4d365b4616c83ab2fb91b7c89d13535de8c0a.1655761627.git.ashish.kalra@amd.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> SEV-SNP guests are required to perform a GHCB GPA registration. Before
> using a GHCB GPA for a vCPU the first time, a guest must register the
> vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
> it must respond back with the same GPA otherwise return -1.
> 
> On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
> mismatch is detected then abort the guest.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h            |  7 +++++++
>  3 files changed, 42 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 539de6b93420..0a9055cdfae2 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -59,6 +59,14 @@
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
>  
> +/* Preferred GHCB GPA Request */
> +#define GHCB_MSR_PREF_GPA_REQ		0x010
> +#define GHCB_MSR_GPA_VALUE_POS		12
> +#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)

Are the magic 51's in here fixed ?

Dave

> +#define GHCB_MSR_PREF_GPA_RESP		0x011
> +#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
> +
>  /* GHCB GPA Register */
>  #define GHCB_MSR_REG_GPA_REQ		0x012
>  #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c70f3f7e06a8..6de48130e414 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3331,6 +3331,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_PREF_GPA_REQ: {
> +		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
> +				  GHCB_MSR_GPA_VALUE_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
> +				  GHCB_MSR_INFO_POS);
> +		break;
> +	}
> +	case GHCB_MSR_REG_GPA_REQ: {
> +		u64 gfn;
> +
> +		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
> +					GHCB_MSR_GPA_VALUE_POS);
> +
> +		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
> +
> +		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
> +				  GHCB_MSR_GPA_VALUE_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
> +				  GHCB_MSR_INFO_POS);
> +		break;
> +	}
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> @@ -3381,6 +3402,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
>  
> +	/* SEV-SNP guest requires that the GHCB GPA must be registered */
> +	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
> +		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
> +		return -EINVAL;
> +	}
> +
>  	ret = sev_es_validate_vmgexit(svm, &exit_code);
>  	if (ret)
>  		return ret;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c80352c9c0d6..54ff56cb6125 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -206,6 +206,8 @@ struct vcpu_sev_es_state {
>  	 */
>  	u64 ghcb_sw_exit_info_1;
>  	u64 ghcb_sw_exit_info_2;
> +
> +	u64 ghcb_registered_gpa;
>  };
>  
>  struct vcpu_svm {
> @@ -334,6 +336,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
>  	return sev_es_guest(kvm) && sev->snp_active;
>  }
>  
> +static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
> +{
> +	return svm->sev_es.ghcb_registered_gpa == val;
> +}
> +
>  static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
>  {
>  	vmcb->control.clean = 0;
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

