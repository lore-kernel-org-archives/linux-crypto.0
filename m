From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Fri, 23 Sep 2016 11:50:15 +0200
Message-ID: <20160923095015.5nn52ekk2kkqixfi@pd.tnic>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <443d06f5-2db5-5107-296f-94fabd209407@amd.com>
 <45a56110-95e9-e1f3-83ab-e777b48bf79a@redhat.com>
 <20160922183759.7ahw2kbxit3epnzk@pd.tnic>
 <c2f7bb1d-cf3c-2373-c563-a1e72ff7b83a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
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
	alexandre.bounine@idt.com, ku
To: Kai Huang <kaih.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <c2f7bb1d-cf3c-2373-c563-a1e72ff7b83a@gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 23, 2016 at 09:33:00PM +1200, Kai Huang wrote:
> How is this even possible? The spec clearly says under SEV only in long mode
> or PAE mode guest can control whether memory is encrypted via c-bit, and in
> other modes guest will be always in encrypted mode.

I was suggesting the hypervisor supplies the EFI ranges unencrypted. But
that is not a good idea because firmware data is exposed then, see same
thread from yesterday.

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
