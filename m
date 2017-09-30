From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Sat, 30 Sep 2017 10:55:25 -0500
Message-ID: <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
 <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0052.outbound.protection.outlook.com ([104.47.41.52]:36412
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751398AbdI3Pzc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Sep 2017 11:55:32 -0400
In-Reply-To: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 9/29/17 10:16 AM, Borislav Petkov wrote:
...

> +
>> +config CRYPTO_DEV_SP_PSP
>> +	bool "Platform Security Processor (PSP) device"
>> +	default y
>> +	depends on CRYPTO_DEV_CCP_DD
> So this last symbol CRYPTO_DEV_CCP_DD is default m and it doesn't depend
> on anything. And I'm pretty sure it should depend on CPU_SUP_AMD as this
> is AMD-specific hw. You can add that dependency in a prepatch.


CRYPTO_DEV_CCP_DD is supported on aarch64 and x86. Whereas the PSP
interface I am adding is available on x86 only hence its safe to add add
depend on CPU_SUP_AMD for CRYPTO_DEV_SP_PSP.


> And what happened to adding dependencies on CONFIG_KVM_AMD? Or can you
> use the PSP without virtualization in any sensible way?

Yes its very much possible. The SEV FW provides two sets of commands 1)
platform certificate management and 2) guest management

The platform certificate management commands is used outside the
CONFIG_KVM_AMD.

-Brijesh
