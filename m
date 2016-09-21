From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 03/28] kvm: svm: Use the hardware provided GPA
 instead of page walk
Date: Wed, 21 Sep 2016 19:16:59 +0200
Message-ID: <20160921171659.cvtkp5nf3r3afawi@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190824754.9523.13923968456167130181.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
	kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
	linus.walleij@linaro.org, linux-mm@kvack.org,
	paul.gortmaker@windriver.com, hpa@zytor.com,
	dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au,
	andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
	bhe@redhat.com, xemul@parallels.com, joro@8bytes.org,
	x86@kernel.org, mingo@redhat.com, msalter@redhat.com,
	ross.zwisler@linux.intel.com, dyoung@redhat.com,
	thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org,
	toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
	devel@linuxdriverproject.org, tglx@linutronix.de,
	mchehab@kernel.org, iamjoonsoo.kim@lge.com,
	labbott@fedoraproject.org, tony.luck@intel.com,
	alexandre.bounine@idt.com, kuleshovmail@gmail.com,
	linux-kernel@vger.kernel.org, mcgrof@kernel.org,
	linux-crypto@vger.k
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <147190824754.9523.13923968456167130181.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 22, 2016 at 07:24:07PM -0400, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When a guest causes a NPF which requires emulation, KVM sometimes walks
> the guest page tables to translate the GVA to a GPA. This is unnecessary
> most of the time on AMD hardware since the hardware provides the GPA in
> EXITINFO2.
> 
> The only exception cases involve string operations involving rep or
> operations that use two memory locations. With rep, the GPA will only be
> the value of the initial NPF and with dual memory locations we won't know
> which memory address was translated into EXITINFO2.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/kvm_emulate.h |    3 +++
>  arch/x86/include/asm/kvm_host.h    |    3 +++
>  arch/x86/kvm/svm.c                 |    2 ++
>  arch/x86/kvm/x86.c                 |   17 ++++++++++++++++-
>  4 files changed, 24 insertions(+), 1 deletion(-)

FWIW, LGTM. (Gotta love replying in acronyms :-))

Reviewed-by: Borislav Petkov <bp@suse.de>

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
