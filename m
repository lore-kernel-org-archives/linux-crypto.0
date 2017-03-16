From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 12/32] x86: Add early boot support when running
 with SEV active
Date: Thu, 16 Mar 2017 17:29:23 +0100
Message-ID: <20170316162923.m2qh4mhkxzg3lpme@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846768878.2349.15757532025749214650.stgit@brijesh-build-machine>
 <20170309140748.tg67yo2jmc5ahck3@pd.tnic>
 <5d62b16f-16ef-1bd7-1551-f0c4c43573f4@redhat.com>
 <20170309162942.jwtb3l33632zhbaz@pd.tnic>
 <1fe1e177-f588-fe5a-dc13-e9fde00e8958@amd.com>
 <20170316101656.dcwgtn4qdtyp5hip@pd.tnic>
 <b27126ee-aff0-ab11-706b-fc6d8d4901db@amd.com>
 <20170316150957.dos6wp3pmhos4hkj@pd.tnic>
 <cb1693fc-6876-a448-f485-1a6c70aa6ff5@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, simon.guinot@sequanux.org,
        linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
        matt@codeblueprint.co.uk, linux-pci@vger.kernel.org,
        linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com,
        dan.j.williams@intel.com, aarcange@redhat.com,
        sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com,
        herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com,
        joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
        piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
        ross.zwisler@linux.intel.com, dyoung@redhat.com, jroedel@suse.de,
        keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com,
        mathieu.desnoyers@efficios.com, luto
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cb1693fc-6876-a448-f485-1a6c70aa6ff5@amd.com>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 16, 2017 at 11:11:26AM -0500, Tom Lendacky wrote:
> Not quite. The guest still needs to understand about the encryption mask
> so that it can protect memory by setting the encryption mask in the
> pagetable entries.  It can also decide when to share memory with the
> hypervisor by not setting the encryption mask in the pagetable entries.

Ok, so the kernel - by that I mean both the baremetal and guest kernel -
needs to know whether we're encrypting stuff. So it needs to know about
SME.

> "Instruction fetches are always decrypted under SEV" means that,
> regardless of how a virtual address is mapped, encrypted or decrypted,
> if an instruction fetch is performed by the CPU from that address it
> will always be decrypted. This is to prevent the hypervisor from
> injecting executable code into the guest since it would have to be
> valid encrypted instructions.

Ok, so the guest needs to map its pages encrypted.

Which reminds me, KSM might be a PITA to enable with SEV but that's a
different story. :)

> There are many areas that use the same logic, but there are certain
> situations where we need to check between SME vs SEV (e.g. DMA operation
> setup or decrypting the trampoline area) and act accordingly.

Right, and I'd like to keep those areas where it differs at minimum and
nicely cordoned off from the main paths.

So looking back at the current patch in this subthread:

we do check

* CPUID 0x40000000
* 8000_001F[EAX] for SME
* 8000_001F[EBX][5:0] for the encryption bits.

So how about we generate the following CPUID picture for the guest:

CPUID_Fn8000001F_EAX = ...10b

That is, SME bit is cleared, SEV is set. This will mean for the guest
kernel that SEV is enabled and you can avoid yourself the 0x40000000
leaf check and the additional KVM feature bit glue.

10b configuration will be invalid for baremetal as - I'm assuming - you
can't have SEV=1b with SME=0b. It will be a virt-only configuration and
this way you can even avoid the hypervisor-specific detection but do
that for all.

Hmmm?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
