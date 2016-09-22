From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 20:50:42 +0200
Message-ID: <4e93fbb3-d01c-1fd6-0610-56402eb5c242@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <0012cd4d-d432-ae14-1041-5e8b62973b37@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org,
        rkrcmar@redhat.com, matt@codeblueprint.co.uk, linus.walleij@linaro.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com,
        dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au,
        andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
        bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org,
        mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com,
        dyoung@redhat.com, jroedel@suse.de, keescook@chromium.org,
        toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
        devel@linuxdriverproject.org, tglx@linutronix.de, mchehab@kernel.org,
        iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, tony.luck@intel.com,
        alexandre.bounine@idt.com, kuleshovmail@gmail.com,
        linux-kernel@
To: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0012cd4d-d432-ae14-1041-5e8b62973b37@amd.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org



On 22/09/2016 20:47, Tom Lendacky wrote:
> > Because the firmware volume is written to high memory in encrypted form,
> > and because the PEI phase runs in 32-bit mode, the firmware code will be
> > encrypted; on the other hand, data that is placed in low memory for the
> > kernel can be unencrypted, thus limiting differences between SME and SEV.
> 
> I like the idea of limiting the differences but it would leave the EFI
> data and ACPI tables exposed and able to be manipulated.

Hmm, that makes sense.  So I guess this has to stay, and Borislav's
proposal doesn't fly either.

Paolo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
