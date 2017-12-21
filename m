From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v9 00/38] x86: Secure Encrypted Virtualization (AMD)
Date: Thu, 21 Dec 2017 10:09:44 -0600
Message-ID: <c0fbe565-ef0c-5273-46ea-e8d7c7e22ec0@amd.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com>
 <f29a9a2a-b8b1-b8d8-1c1e-9ec5fcb2d0ca@redhat.com>
 <51fe0851-14d7-cb37-613c-0eaf8a7d2a65@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, bp@alien8.de,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LDhMKNbcODwqHDhQ==?= =?UTF-8?B?4oSi?=
        <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0050.outbound.protection.outlook.com ([104.47.32.50]:5120
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751143AbdLUQJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 11:09:56 -0500
In-Reply-To: <51fe0851-14d7-cb37-613c-0eaf8a7d2a65@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 12/21/17 9:51 AM, Brijesh Singh wrote:
>
> On 12/21/17 7:06 AM, Paolo Bonzini wrote:
> ....
>
> Hi Paolo,
>  
>
>> Hi Brijesh,
>>
>> I have a couple comments:
>>
>> 1) how is MSR_AMD64_SEV's value passed to the guest, and where is it in
>> the manual?
> It is a non interceptable read-only MSR set by the HW when SEV feature
> is enabled in VMRUN instruction.

I just checked both PPR and Family 17 manual and it seems both are still
missing this MSR definition. I will ping doc team to get it updated. thanks
>> 2) ECX should be 0 in the guest's 0x8000_001f leaf, because we don't
>> support nested SEV guests.  Likewise, EAX bit 2 should be 0 since you
>> don't emulate the page flush MSR.
> IIRC, I do clear both EAX Page_Flush and nested virtualization case from
> Qemu SEV feature is enabled.
>> Both can be fixed on top (and I can do the second myself of course), so
>> there should be no need for a v10.  
> Thanks
>
