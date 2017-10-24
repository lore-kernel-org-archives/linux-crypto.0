From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 00/38] x86: Secure Encrypted Virtualization (AMD)
Date: Tue, 24 Oct 2017 07:14:20 -0500
Message-ID: <d3b1c8a1-5073-3334-ad41-07a612a4f698@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm list <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Gary Hook <Gary.Hook@amd.com>
To: Brijesh Singh <brijesh.singh@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0077.outbound.protection.outlook.com ([104.47.36.77]:45368
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932308AbdJXMOc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 08:14:32 -0400
In-Reply-To: <20171020023413.122280-1-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert and Paolo,


On 10/19/17 9:33 PM, Brijesh Singh wrote:
> This part of Secure Encryted Virtualization (SEV) patch series focuses on KVM
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

Since the PSP patches touches both the CCP and KVM driver, hence I was
wondering if you guys have any thought on how PSP patches will be
merged? I am talking about Patch 9 to 20 from this series. I have
ensured that patches apply cleanly on both kvm/master and
cryptodev-2.6/master. We can do this in one of two ways:

- Paolo can merge the PSP support through the KVM branch

or

- Herbert can create a topic branch with PSP changes and Paolo can use
that topic branch.

Any visibility will help my next submission. thank you.

-Brijesh
