From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 04/32] KVM: SVM: Add SEV feature definitions to KVM
Date: Tue, 7 Mar 2017 01:50:53 +0100
Message-ID: <20170307005053.izjygz6mcebo5hza@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846756856.2349.18360437323368784256.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
	kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
	linux-pci@vger.kernel.org, linus.walleij@linaro.org,
	gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com,
	hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com,
	aarcange@redhat.com, sfr@canb.auug.org.au,
	andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
	bhe@redhat.com, xemul@parallels.com, joro@8bytes.org,
	x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com,
	mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com,
	dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
	keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com,
	mathieu.desnoyers@efficios.com, luto@kernel.org,
	devel@linuxdriverproject.org, bhelgaas@google.com,
	tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com,
	labbott@fedo
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <148846756856.2349.18360437323368784256.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 02, 2017 at 10:12:48AM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Define a new KVM CPU feature for Secure Encrypted Virtualization (SEV).
> The kernel will check for the presence of this feature to determine if
> it is running with SEV active.
> 
> Define the SEV enable bit for the VMCB control structure. The hypervisor
> will use this bit to enable SEV in the guest.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/svm.h           |    1 +
>  arch/x86/include/uapi/asm/kvm_para.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2aca535..fba2a7b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -137,6 +137,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
>  
>  #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
> +#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
>  
>  struct __attribute__ ((__packed__)) vmcb_seg {
>  	u16 selector;
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 1421a65..bc2802f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -24,6 +24,7 @@
>  #define KVM_FEATURE_STEAL_TIME		5
>  #define KVM_FEATURE_PV_EOI		6
>  #define KVM_FEATURE_PV_UNHALT		7
> +#define KVM_FEATURE_SEV			8

This looks like it needs documenting in Documentation/virtual/kvm/cpuid.txt

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
