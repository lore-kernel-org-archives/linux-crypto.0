From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Part2 PATCH v9 00/38] x86: Secure Encrypted Virtualization (AMD)
Date: Thu, 21 Dec 2017 14:06:19 +0100
Message-ID: <f29a9a2a-b8b1-b8d8-1c1e-9ec5fcb2d0ca@redhat.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LDhMKNbcODwqHDheKEog==?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51321 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751881AbdLUNG0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 08:06:26 -0500
In-Reply-To: <20171205010438.5773-1-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/12/2017 02:04, Brijesh Singh wrote:
> This part of Secure Encrypted Virtualization (SEV) patch series focuses on KVM
> changes required to create and manage SEV guests.
> 
> SEV is an extension to the AMD-V architecture which supports running encrypted
> virtual machine (VMs) under the control of a hypervisor. Encrypted VMs have their
> pages (code and data) secured such that only the guest itself has access to
> unencrypted version. Each encrypted VM is associated with a unique encryption key;
> if its data is accessed to a different entity using a different key the encrypted
> guest's data will be incorrectly decrypted, leading to unintelligible data.
> This security model ensures that hypervisor will no longer able to inspect or
> alter any guest code or data.
> 
> The key management of this feature is handled by a separate processor known as
> the AMD Secure Processor (AMD-SP) which is present on AMD SOCs. The SEV Key
> Management Specification (see below) provides a set of commands which can be
> used by hypervisor to load virtual machine keys through the AMD-SP driver.
> 
> The patch series adds a new ioctl in KVM driver (KVM_MEMORY_ENCRYPT_OP). The
> ioctl will be used by qemu to issue SEV guest-specific commands defined in Key
> Management Specification.

Hi Brijesh,

I have a couple comments:

1) how is MSR_AMD64_SEV's value passed to the guest, and where is it in
the manual?

2) ECX should be 0 in the guest's 0x8000_001f leaf, because we don't
support nested SEV guests.  Likewise, EAX bit 2 should be 0 since you
don't emulate the page flush MSR.

Both can be fixed on top (and I can do the second myself of course), so
there should be no need for a v10.  But MSR_AMD64_SEV is leaving me
quite puzzled.

Thanks,

Paolo

> The following links provide additional details:
> 
> AMD Memory Encryption white paper:
> http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> 
> AMD64 Architecture Programmer's Manual:
>     http://support.amd.com/TechDocs/24593.pdf
>     SME is section 7.10
>     SEV is section 15.34
> 
> SEV Key Management:
> http://support.amd.com/TechDocs/55766_SEV-KM API_Specification.pdf
> 
> KVM Forum Presentation:
> http://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
> 
> SEV Guest BIOS support:
>   SEV support has been add to EDKII/OVMF BIOS
>   https://github.com/tianocore/edk2
> 
> --
> 
> The series applies on kvm/next commit : 4fbd8d194f06 (Linux 4.15-rc1)
> 
> Complete tree is available at:
> repo: https://github.com/codomania/kvm.git
> branch: sev-v9-p2
> 
> TODO:
> * Add SEV guest migration command support
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim KrÄmÃ¡Å™" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> 
> Changes since v8:
>  * Rebase the series to kvm/next branch
>  * Update SEV asid allocation to limit the ASID between SEV_MIN_ASID to SEV_MAX_ASID
>    (EPYC BIOS provide option to change the SEV_MIN_ASID -- which can be used to
>    limit the number of SEV-enable guest)
> 
> Changes since v7:
>  * Rebase the series to kvm/next branch
>  * move the FW error enum definition in include/uapi/linux/psp-sev.h so that
>    both userspace and kernel can share it.
>  * (ccp) drop cmd_buf arg from sev_platform_init()
>  * (ccp) apply some cleanup/fixup from Boris
>  * (ccp) add some comments in FACTORY_RESET command handling
>  * (kvm) some fixup/cleanup from Boris
>  * (kvm) acquire the kvm->lock when modifying the sev->regions_list
> 
> Changes since v6:
>  * (ccp): Extend psp_device structure to track the FW INIT and SHUTDOWN states.
>  * (ccp): Init and Uninit SEV FW during module load/unload
>  * (ccp): Avoid repeated k*alloc() for init and status command buffer
>  * (kvm): Rework DBG command to fix the compilation warning seen with gcc7.x
>  * (kvm): Convert the SEV doc in rst format
> 
> Changes since v5:
>  * split the PSP driver support into multiple patches
>  * multiple improvements from Boris
>  * remove mem_enc_enabled() ops
> 
> Changes since v4:
>  * Fixes to address kbuild robot errors
>  * Add 'sev' module params to allow enable/disable SEV feature
>  * Update documentation
>  * Multiple fixes to address v4 feedbacks
>  * Some coding style changes to address checkpatch reports
> 
> Changes since v3:
>  * Re-design the PSP interface support patch
>  * Rename the ioctls based on the feedbacks
>  * Improve documentation
>  * Fix i386 build issues
>  * Add LAUNCH_SECRET command
>  * Add new Kconfig option to enable SEV support
>  * Changes to address v3 feedbacks.
> 
> Changes since v2:
>  * Add KVM_MEMORY_ENCRYPT_REGISTER/UNREGISTER_RAM ioct to register encrypted
>    memory ranges (recommend by Paolo)
>  * Extend kvm_x86_ops to provide new memory_encryption_enabled ops
>  * Enhance DEBUG DECRYPT/ENCRYPT commands to work with more than one page \
>                 (recommended by Paolo)
>  * Optimize LAUNCH_UPDATE command to reduce the number of calls to AMD-SP driver
>  * Changes to address v2 feedbacks
> 
> 
> Borislav Petkov (1):
>   crypto: ccp: Build the AMD secure processor driver only with AMD CPU
>     support
> 
> Brijesh Singh (34):
>   Documentation/virtual/kvm: Add AMD Secure Encrypted Virtualization
>     (SEV)
>   KVM: SVM: Prepare to reserve asid for SEV guest
>   KVM: X86: Extend CPUID range to include new leaf
>   KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl
>   KVM: Introduce KVM_MEMORY_ENCRYPT_{UN,}REG_REGION ioctl
>   crypto: ccp: Define SEV userspace ioctl and command id
>   crypto: ccp: Define SEV key management command id
>   crypto: ccp: Add Platform Security Processor (PSP) device support
>   crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support
>   crypto: ccp: Implement SEV_FACTORY_RESET ioctl command
>   crypto: ccp: Implement SEV_PLATFORM_STATUS ioctl command
>   crypto: ccp: Implement SEV_PEK_GEN ioctl command
>   crypto: ccp: Implement SEV_PDH_GEN ioctl command
>   crypto: ccp: Implement SEV_PEK_CSR ioctl command
>   crypto: ccp: Implement SEV_PEK_CERT_IMPORT ioctl command
>   crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command
>   KVM: X86: Add CONFIG_KVM_AMD_SEV
>   KVM: SVM: Reserve ASID range for SEV guest
>   KVM: SVM: Add sev module_param
>   KVM: Define SEV key management command id
>   KVM: SVM: Add KVM_SEV_INIT command
>   KVM: SVM: VMRUN should use associated ASID when SEV is enabled
>   KVM: SVM: Add support for KVM_SEV_LAUNCH_START command
>   KVM: SVM: Add support for KVM_SEV_LAUNCH_UPDATE_DATA command
>   KVM: SVM: Add support for KVM_SEV_LAUNCH_MEASURE command
>   KVM: SVM: Add support for SEV LAUNCH_FINISH command
>   KVM: SVM: Add support for SEV GUEST_STATUS command
>   KVM: SVM: Add support for SEV DEBUG_DECRYPT command
>   KVM: SVM: Add support for SEV DEBUG_ENCRYPT command
>   KVM: SVM: Add support for SEV LAUNCH_SECRET command
>   KVM: SVM: Pin guest memory when SEV is active
>   KVM: SVM: Clear C-bit from the page fault address
>   KVM: SVM: Do not install #UD intercept when SEV is enabled
>   KVM: X86: Restart the guest when insn_len is zero and SEV is enabled
> 
> Tom Lendacky (3):
>   x86/CPU/AMD: Add the Secure Encrypted Virtualization CPU feature
>   kvm: svm: prepare for new bit definition in nested_ctl
>   kvm: svm: Add SEV feature definitions to KVM
> 
>  Documentation/virtual/kvm/00-INDEX                 |    3 +
>  .../virtual/kvm/amd-memory-encryption.rst          |  247 ++++
>  Documentation/virtual/kvm/api.txt                  |   50 +
>  arch/x86/include/asm/cpufeatures.h                 |    1 +
>  arch/x86/include/asm/kvm_host.h                    |   15 +
>  arch/x86/include/asm/msr-index.h                   |    2 +
>  arch/x86/include/asm/svm.h                         |    3 +
>  arch/x86/kernel/cpu/amd.c                          |   66 +-
>  arch/x86/kernel/cpu/scattered.c                    |    1 +
>  arch/x86/kvm/Kconfig                               |   10 +
>  arch/x86/kvm/cpuid.c                               |    2 +-
>  arch/x86/kvm/mmu.c                                 |   10 +
>  arch/x86/kvm/svm.c                                 | 1178 +++++++++++++++++++-
>  arch/x86/kvm/x86.c                                 |   30 +
>  drivers/crypto/ccp/Kconfig                         |   12 +
>  drivers/crypto/ccp/Makefile                        |    1 +
>  drivers/crypto/ccp/psp-dev.c                       |  805 +++++++++++++
>  drivers/crypto/ccp/psp-dev.h                       |   83 ++
>  drivers/crypto/ccp/sp-dev.c                        |   35 +
>  drivers/crypto/ccp/sp-dev.h                        |   28 +-
>  drivers/crypto/ccp/sp-pci.c                        |   52 +
>  include/linux/psp-sev.h                            |  606 ++++++++++
>  include/uapi/linux/kvm.h                           |   90 ++
>  include/uapi/linux/psp-sev.h                       |  142 +++
>  24 files changed, 3440 insertions(+), 32 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/amd-memory-encryption.rst
>  create mode 100644 drivers/crypto/ccp/psp-dev.c
>  create mode 100644 drivers/crypto/ccp/psp-dev.h
>  create mode 100644 include/linux/psp-sev.h
>  create mode 100644 include/uapi/linux/psp-sev.h
> 
