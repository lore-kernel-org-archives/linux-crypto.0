From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 24/32] kvm: x86: prepare for SEV guest management
 API support
Date: Thu, 16 Mar 2017 11:33:03 +0100
Message-ID: <e3624c9f-af1f-740d-d359-3703024e83fd@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846784278.2349.17771314083820274411.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org,
        linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
        matt@codeblueprint.co.uk, linux-pci@vger.kernel.org,
        linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com,
        dan.j.williams@intel.com, aarcange@redhat.com,
        sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com,
        herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com,
        joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
        piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
        ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com,
        thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org,
        arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
        luto
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdCPKdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:33:17 -0400
In-Reply-To: <148846784278.2349.17771314083820274411.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 02/03/2017 16:17, Brijesh Singh wrote:
> ASID management:
>  - Reserve asid range for SEV guest, SEV asid range is obtained through
>    CPUID Fn8000_001f[ECX]. A non-SEV guest can use any asid outside the SEV
>    asid range.

How is backwards compatibility handled?

>  - SEV guest must have asid value within asid range obtained through CPUID.
>  - SEV guest must have the same asid for all vcpu's. A TLB flush is required
>    if different vcpu for the same ASID is to be run on the same host CPU.

[...]

> +
> +	/* which host cpu was used for running this vcpu */
> +	bool last_cpuid;

Should be unsigned int.

> 
> +	/* Assign the asid allocated for this SEV guest */
> +	svm->vmcb->control.asid = asid;
> +
> +	/* Flush guest TLB:
> +	 * - when different VMCB for the same ASID is to be run on the
> +	 *   same host CPU
> +	 *   or
> +	 * - this VMCB was executed on different host cpu in previous VMRUNs.
> +	 */
> +	if (sd->sev_vmcbs[asid] != (void *)svm->vmcb ||

Why the cast?

> +		svm->last_cpuid != cpu)
> +		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;

If there is a match, you don't need to do anything else (neither reset
the asid, nor mark it as dirty, nor update the fields), so:

	if (sd->sev_vmcbs[asid] == svm->vmcb &&
	    svm->last_cpuid == cpu)
		return;

	svm->last_cpuid = cpu;
	sd->sev_vmcbs[asid] = svm->vmcb;
	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
	svm->vmcb->control.asid = asid;
	mark_dirty(svm->vmcb, VMCB_ASID);

(plus comments ;)).

Also, why not TLB_CONTROL_FLUSH_ASID if possible?

> +	svm->last_cpuid = cpu;
> +	sd->sev_vmcbs[asid] = (void *)svm->vmcb;
> +
> +	mark_dirty(svm->vmcb, VMCB_ASID);

[...]

> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index fef7d83..9df37a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1284,6 +1284,104 @@ struct kvm_s390_ucas_mapping {
>  /* Memory Encryption Commands */
>  #define KVM_MEMORY_ENCRYPT_OP	  _IOWR(KVMIO, 0xb8, unsigned long)
>  
> +/* Secure Encrypted Virtualization mode */
> +enum sev_cmd_id {

Please add documentation in Documentation/virtual/kvm/memory_encrypt.txt.

Paolo
