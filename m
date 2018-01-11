From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Part2 PATCH v9 00/38] x86: Secure Encrypted Virtualization (AMD)
Date: Thu, 11 Jan 2018 13:20:38 +0100
Message-ID: <03c41419-4c66-c391-0792-d3c419c12bb0@redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:49332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932306AbeAKNZn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 08:25:43 -0500
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
> 
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

Merged!  Thanks,

Paolo
