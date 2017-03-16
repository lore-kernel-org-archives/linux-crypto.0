From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH v2 32/32] x86: kvm: Pin the guest memory when SEV is
 active
Date: Thu, 16 Mar 2017 13:17:47 -0500
Message-ID: <b2a3cb42-1467-823e-affd-72a0be577932__43454.3937830769$1489688315$gmane$org@amd.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846793743.2349.8478208161427437950.stgit@brijesh-build-machine>
 <453770c9-f9d7-4806-dbae-d19876f2a22e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <brijesh.singh@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>, <simon.guinot@sequanux.org>,
        <linux-efi@vger.kernel.org>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linux-pci@vger.kernel.org>, <linus.walleij@linaro.org>,
        <gary.hook@amd.com>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>, <cl@linux.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <peterz@infradead.org>, <piotr.luc@intel.com>, <mingo@redhat.com>,
        <msalter@redhat.com>, <ross.zwisler@linux.intel.com>, <bp@suse.de>,
        <dyoung@redhat.com>, <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <arnd@arndb
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0078.outbound.protection.outlook.com ([104.47.41.78]:19205
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752111AbdCPSSB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 14:18:01 -0400
In-Reply-To: <453770c9-f9d7-4806-dbae-d19876f2a22e@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 03/16/2017 05:38 AM, Paolo Bonzini wrote:
>
>
> On 02/03/2017 16:18, Brijesh Singh wrote:
>> The SEV memory encryption engine uses a tweak such that two identical
>> plaintexts at different location will have a different ciphertexts.
>> So swapping or moving ciphertexts of two pages will not result in
>> plaintexts being swapped. Relocating (or migrating) a physical backing pages
>> for SEV guest will require some additional steps. The current SEV key
>> management spec [1] does not provide commands to swap or migrate (move)
>> ciphertexts. For now we pin the memory allocated for the SEV guest. In
>> future when SEV key management spec provides the commands to support the
>> page migration we can update the KVM code to remove the pinning logical
>> without making any changes into userspace (qemu).
>>
>> The patch pins userspace memory when a new slot is created and unpin the
>> memory when slot is removed.
>>
>> [1] http://support.amd.com/TechDocs/55766_SEV-KM%20API_Spec.pdf
>
> This is not enough, because memory can be hidden temporarily from the
> guest and remapped later.  Think of a PCI BAR that is backed by RAM, or
> also SMRAM.  The pinning must be kept even in that case.
>
> You need to add a pair of KVM_MEMORY_ENCRYPT_OPs (one that doesn't map
> to a PSP operation), such as KVM_REGISTER/UNREGISTER_ENCRYPTED_RAM.  In
> QEMU you can use a RAMBlockNotifier to invoke the ioctls.
>

I was hoping to avoid adding new ioctl, but I see your point. Will add a pair of ioctl's
and use RAMBlocNotifier to invoke those ioctls.

-Brijesh
