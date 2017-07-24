From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part2 PATCH v3 00/26] x86: Secure Encrypted Virtualization (AMD)
Date: Mon, 24 Jul 2017 15:02:37 -0500
Message-ID: <20170724200303.12197-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=5C=22Radim=20Kr=C4=8Dm=C3=A1=C5=99=5C=22?=
        <rkrcmar@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:3232
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751558AbdGXUDY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 16:03:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This part of Secure Encryted Virtualization (SEV) patch series focuses on KVM
changes required to create and manage SEV guests.

SEV is an extension to the AMD-V architecture which supports running encrypted
virtual machine (VMs) under the control of a hypervisor. Encrypted VMs have their
pages (code and data) secured such that only the guest itself has access to
unencrypted version. Each encrypted VM is associated with a unique encryption key;
if its data is accessed to a different entity using a different key the encrypted
guest's data will be incorrectly decrypted, leading to unintelligible data.
This security model ensures that hypervisor will no longer able to inspect or
alter any guest code or data.

The key management of this feature is handled by a separate processor known as
the AMD Secure Processor (AMD-SP) which is present on AMD SOCs. The SEV Key
Management Specification (see below) provides a set of commands which can be
used by hypervisor to load virtual machine keys through the AMD-SP driver.

The patch series adds a new ioctl in KVM driver (KVM_MEMORY_ENCRYPTION_OP). The
ioctl will be used by qemu to issue SEV guest-specific commands defined in Key
Management Specification.

The following links provide additional details:

AMD Memory Encryption whitepaper:
http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf

AMD64 Architecture Programmer's Manual:
    http://support.amd.com/TechDocs/24593.pdf
    SME is section 7.10
    SEV is section 15.34

Secure Encrypted Virutualization Key Management:
http://support.amd.com/TechDocs/55766_SEV-KM API_Specification.pdf

KVM Forum Presentation:
http://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf

SEV Guest BIOS support:
  SEV support has been interated into EDKII/OVMF BIOS
  https://github.com/tianocore/edk2

RFC part1:
http://marc.info/?l=kvm&m=150092330804060&w=2

---
This RFC is based on tip/master commit : 22db3de (Merge branch 'x86/mm').
Complete git tree is available: https://github.com/codomania/tip/tree/sev-rfc-3

TODO:
 * Add SEV guest migration command support

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gary Hook <gary.hook@amd.com>
Cc: linux-crypto@vger.kernel.org

Changes since v2:
 * Add KVM_MEMORY_ENCRYPT_REGISTER/UNREGISTER_RAM ioct to register encrypted
   memory ranges (recommend by Paolo)
 * Extend kvm_x86_ops to provide new memory_encryption_enabled ops
 * Enhance DEBUG DECRYPT/ENCRYPT commands to work with more than one page (recommended by Paolo)
 * Optimize LAUNCH_UPDATE command to reduce the number of calls to AMD-SP driver
 * Changes to address v2 feedbacks

Brijesh Singh (24):
  Documentation/virtual/kvm: Add AMD Secure Encrypted Virtualization
    (SEV)
  crypto: ccp: Add Platform Security Processor (PSP) device support
  crypto: ccp: Add Secure Encrypted Virtualization (SEV) device support
  KVM: SVM: Prepare to reserve asid for SEV guest
  KVM: SVM: Reserve ASID range for SEV guest
  KVM: X86: Extend CPUID range to include new leaf
  KVM: Introduce KVM_MEMORY_ENCRYPT_OP ioctl
  KVM: Introduce KVM_MEMORY_ENCRYPT_REGISTER/UNREGISTER_RAM ioctl
  KVM: X86: Extend struct kvm_arch to include SEV information
  KVM: Define SEV key management command id
  KVM: SVM: Add KVM_SEV_INIT command
  KVM: SVM: VMRUN should use assosiated ASID when SEV is enabled
  KVM: SVM: Add support for SEV LAUNCH_START command
  KVM: SVM: Add support for SEV LAUNCH_UPDATE_DATA command
  KVM: SVM: Add support for SEV LAUNCH_MEASURE command
  KVM: SVM: Add support for SEV LAUNCH_FINISH command
  KVM: svm: Add support for SEV GUEST_STATUS command
  KVM: SVM: Add support for SEV DEBUG_DECRYPT command
  KVM: SVM: Add support for SEV DEBUG_ENCRYPT command
  KVM: SVM: Pin guest memory when SEV is active
  KVM: X86: Add memory encryption enabled ops
  KVM: SVM: Clear C-bit from the page fault address
  KVM: SVM: Do not install #UD intercept when SEV is enabled
  KVM: X86: Restart the guest when insn_len is zero and SEV is enabled

Tom Lendacky (2):
  KVM: SVM: Prepare for new bit definition in nested_ctl
  KVM: SVM: Add SEV feature definitions to KVM

 .../virtual/kvm/amd-memory-encryption.txt          |  328 ++++++
 arch/x86/include/asm/kvm_host.h                    |   17 +
 arch/x86/include/asm/svm.h                         |    3 +
 arch/x86/kvm/cpuid.c                               |    2 +-
 arch/x86/kvm/mmu.c                                 |   17 +
 arch/x86/kvm/svm.c                                 | 1221 +++++++++++++++++++-
 arch/x86/kvm/x86.c                                 |   48 +
 drivers/crypto/ccp/Kconfig                         |   19 +
 drivers/crypto/ccp/Makefile                        |    2 +
 drivers/crypto/ccp/psp-dev.c                       |  230 ++++
 drivers/crypto/ccp/psp-dev.h                       |  109 ++
 drivers/crypto/ccp/sev-dev.c                       |  416 +++++++
 drivers/crypto/ccp/sev-dev.h                       |   67 ++
 drivers/crypto/ccp/sev-ops.c                       |  457 ++++++++
 drivers/crypto/ccp/sp-dev.c                        |   43 +
 drivers/crypto/ccp/sp-dev.h                        |   41 +-
 drivers/crypto/ccp/sp-pci.c                        |   46 +
 include/linux/psp-sev.h                            |  683 +++++++++++
 include/uapi/linux/kvm.h                           |  159 +++
 include/uapi/linux/psp-sev.h                       |  110 ++
 20 files changed, 4010 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/virtual/kvm/amd-memory-encryption.txt
 create mode 100644 drivers/crypto/ccp/psp-dev.c
 create mode 100644 drivers/crypto/ccp/psp-dev.h
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h
 create mode 100644 drivers/crypto/ccp/sev-ops.c
 create mode 100644 include/linux/psp-sev.h
 create mode 100644 include/uapi/linux/psp-sev.h

-- 
Brijesh Singh
2.9.4
