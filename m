From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 21:11:38 +0200
Message-ID: <20160922191138.lnp4ac3cfkiebjo3@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
 <938ee0cf-85e6-eefa-7df9-9d5e09ed7a9d@redhat.com>
 <20160922170718.34d4ppockeurrg25@pd.tnic>
 <1a22afee-a146-414c-6f58-66a942f7aab9@amd.com>
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
In-Reply-To: <1a22afee-a146-414c-6f58-66a942f7aab9@amd.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 22, 2016 at 02:04:27PM -0500, Tom Lendacky wrote:
> That's not what I mean here.  If the BIOS sets the SMEE bit in the
> SYS_CFG msr then, even if the encryption bit is never used, there is
> still a reduction in physical address space.

I thought that reduction is the reservation of bits for the SME mask.

What other reduction is there?

> Transparent SME (TSME) will be a BIOS option that will result in the
> memory controller performing encryption no matter what. In this case
> all data will be encrypted without a reduction in physical address
> space.

Now I'm confused: aren't we reducing the address space with the SME
mask?

Or what reduction do you mean?

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
