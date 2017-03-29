From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 16/32] x86: kvm: Provide support to create Guest
 and HV shared per-CPU variables
Date: Wed, 29 Mar 2017 17:21:13 +0200
Message-ID: <9a8723fc-300d-eb76-deb1-cbc8492e9d49@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846773666.2349.9492983018843773590.stgit@brijesh-build-machine>
 <20170328183931.rqorduu5fnp5r3y2@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
        kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
        linux-pci@vger.kernel.org, linus.walleij@linaro.org,
        gary.hook@amd.com, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com,
        dan.j.williams@intel.com, aarcange@redhat.com,
        sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com,
        herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com,
        joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
        piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
        ross.zwisler@linux.intel.com, dyoung@redhat.com,
        thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org,
        arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
        luto@kernel.org, devel@linuxdriverproject.org, bhelgaas
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170328183931.rqorduu5fnp5r3y2@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 28/03/2017 20:39, Borislav Petkov wrote:
>> 2) Since the encryption attributes works on PAGE_SIZE hence add some extra
>> padding to 'struct kvm-steal-time' to make it PAGE_SIZE and then at runtime
>> clear the encryption attribute of the full PAGE. The downside of this was
>> now we need to modify structure which may break the compatibility.
> From SEV-ES whitepaper:
> 
> "To facilitate this communication, the SEV-ES architecture defines
> a Guest Hypervisor Communication Block (GHCB). The GHCB resides in
> page of shared memory so it is accessible to both the guest VM and the
> hypervisor."
> 
> So this is kinda begging to be implemented with a shared page between
> guest and host. And then put steal-time, ... etc in there too. Provided
> there's enough room in the single page for the GHCB *and* our stuff.

The GHCB would have to be allocated much earlier, possibly even by
firmware depending on how things will be designed.  I think it's
premature to consider SEV-ES requirements.

Paolo
