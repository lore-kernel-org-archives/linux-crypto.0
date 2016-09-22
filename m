From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 22:10:40 +0200
Message-ID: <20160922201040.ek3l3njcfdwsx6sl@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
 <938ee0cf-85e6-eefa-7df9-9d5e09ed7a9d@redhat.com>
 <20160922170718.34d4ppockeurrg25@pd.tnic>
 <1a22afee-a146-414c-6f58-66a942f7aab9@amd.com>
 <20160922191138.lnp4ac3cfkiebjo3@pd.tnic>
 <e162ecbf-f0b5-9a38-fdf6-7f097e20c5ad@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org,
	linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
	matt@codeblueprint.co.uk, linus.walleij@linaro.org,
	linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com,
	dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au,
	andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
	bhe@redhat.com, xemul@parallels.com, joro@8bytes.org,
	x86@kernel.org, mingo@redhat.com, msalter@redhat.com,
	ross.zwisler@linux.intel.com, dyoung@redhat.com, jroedel@suse.de,
	keescook@chromium.org, toshi.kani@hpe.com,
	mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org,
	tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com,
	labbott@fedoraproject.org, tony.luck@intel.com,
	alexandre.bounine@idt.com, kuleshovmail@gmail.com,
	linux-kernel@vger.
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <e162ecbf-f0b5-9a38-fdf6-7f097e20c5ad@amd.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 22, 2016 at 02:49:22PM -0500, Tom Lendacky wrote:
> > I thought that reduction is the reservation of bits for the SME mask.
> > 
> > What other reduction is there?
> 
> There is a reduction in physical address space for the SME mask and the
> bits used to aid in identifying the ASID associated with the memory
> request. This allows for the memory controller to determine the key to
> be used for the encryption operation (host/hypervisor key vs. an SEV
> guest key).

Ok, I think I see what you mean: you call SME mask the bit in CPUID
Fn8000_001F[EBX][5:0], i.e., the C-bit, i.e. sme_me_mask. And the other
reduction is the key ASID, i.e., CPUID Fn8000_001F[EBX][11:6], i.e.
sme_me_loss.

I think we're on the same page - I was simply calling everything SME
mask because both are together in the PTE:

"Additionally, in some implementations, the physical address size of the
processor may be reduced when memory encryption features are enabled,
for example from 48 to 43 bits."

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
