From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 12/32] x86: Add early boot support when running
 with SEV active
Date: Thu, 16 Mar 2017 09:28:58 -0500
Message-ID: <b27126ee-aff0-ab11-706b-fc6d8d4901db@amd.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846768878.2349.15757532025749214650.stgit@brijesh-build-machine>
 <20170309140748.tg67yo2jmc5ahck3@pd.tnic>
 <5d62b16f-16ef-1bd7-1551-f0c4c43573f4@redhat.com>
 <20170309162942.jwtb3l33632zhbaz@pd.tnic>
 <1fe1e177-f588-fe5a-dc13-e9fde00e8958@amd.com>
 <20170316101656.dcwgtn4qdtyp5hip@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Paolo Bonzini <pbonzini@redhat.com>, <simon.guinot@sequanux.org>,
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
        <msalter@redhat.com>, <ross.zwisler@linux.intel.com>,
        <dyoung@redhat.com>, <jroedel@suse.de>, <keescook@chromium.org>,
        <arnd@arndb.de>, <toshi.kani@hpe.com>,
        <math
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:24455
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751321AbdCPO3K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 10:29:10 -0400
In-Reply-To: <20170316101656.dcwgtn4qdtyp5hip@pd.tnic>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/16/2017 5:16 AM, Borislav Petkov wrote:
> On Fri, Mar 10, 2017 at 10:35:30AM -0600, Brijesh Singh wrote:
>> We could update this patch to use the below logic:
>>
>>  * CPUID(0) - Check for AuthenticAMD
>>  * CPID(1) - Check if under hypervisor
>>  * CPUID(0x80000000) - Check for highest supported leaf
>>  * CPUID(0x8000001F).EAX - Check for SME and SEV support
>>  * rdmsr (MSR_K8_SYSCFG)[MemEncryptionModeEnc] - Check if SMEE is set
>
> Actually, it is still not clear to me *why* we need to do anything
> special wrt SEV in the guest.
>
> Lemme clarify: why can't the guest boot just like a normal Linux on
> baremetal and use the SME(!) detection code to set sme_enable and so
> on? IOW, I'd like to avoid all those checks whether we're running under
> hypervisor and handle all that like we're running on baremetal.

Because there are differences between how SME and SEV behave
(instruction fetches are always decrypted under SEV, DMA to an
encrypted location is not supported under SEV, etc.) we need to
determine which mode we are in so that things can be setup properly
during boot. For example, if SEV is active the kernel will already
be encrypted and so we don't perform that step or the trampoline area
for bringing up an AP must be decrypted for SME but encrypted for SEV.
The hypervisor check will provide that ability to determine how we
handle things.

Thanks,
Tom

>
