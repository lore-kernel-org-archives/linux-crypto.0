From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 17:05:54 +0200
Message-ID: <938ee0cf-85e6-eefa-7df9-9d5e09ed7a9d@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-efi@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
 linus.walleij@linaro.org, paul.gortmaker@windriver.com, hpa@zytor.com,
 tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au,
 mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com,
 xemul@parallels.com, joro@8bytes.org, x86@kernel.org, mingo@redhat.com,
 msalter@redhat.com, ross.zwisler@linux.intel.com, labbott@fedoraproject.org,
 dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
 keescook@chromium.org, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
 dan.j.williams@intel.com, andriy.shevchenko@linux.intel.com,
 akpm@linux-foundation.org, herbert@gondor.apana.org.au, tony.luck@intel.com,
 linux-mm@kvack.org, kuleshovmail@gmail.com, linux-kernel@vger.kernel.org,
 mcgrof@kernel.org, linux-crypto@vger.kernel.org, devel@li
To: Borislav Petkov <bp@suse.de>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org



On 22/09/2016 16:59, Borislav Petkov wrote:
> On Thu, Sep 22, 2016 at 04:45:51PM +0200, Paolo Bonzini wrote:
>> The main difference between the SME and SEV encryption, from the point
>> of view of the kernel, is that real-mode always writes unencrypted in
>> SME and always writes encrypted in SEV.  But UEFI can run in 64-bit mode
>> and learn about the C bit, so EFI boot data should be unprotected in SEV
>> guests.
> 
> Actually, it is different: you can start fully encrypted in SME, see:
> 
> https://lkml.kernel.org/r/20160822223539.29880.96739.stgit@tlendack-t1.amdoffice.net
> 
> The last paragraph alludes to a certain transparent mode where you're
> already encrypted and only certain pieces like EFI is not encrypted.

Which paragraph?

>> Because the firmware volume is written to high memory in encrypted
>> form, and because the PEI phase runs in 32-bit mode, the firmware
>> code will be encrypted; on the other hand, data that is placed in low
>> memory for the kernel can be unencrypted, thus limiting differences
>> between SME and SEV.
> 
> When you run fully encrypted, you still need to access EFI tables in the
> clear. That's why I'm confused about this patch here.

I might be wrong, but I don't think this patch was tested with OVMF or Duet.

Paolo
