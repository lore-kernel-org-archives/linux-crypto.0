From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Sun, 1 Oct 2017 15:05:11 -0500
Message-ID: <55879570-04d7-a627-5f4b-b94f1604ece5@amd.com>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
 <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
 <20170930161104.452sia6a5y5duyn4@pd.tnic>
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
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:64841
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750993AbdJAUFT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2017 16:05:19 -0400
In-Reply-To: <20170930161104.452sia6a5y5duyn4@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 9/30/17 11:11 AM, Borislav Petkov wrote:
> I think just from having CRYPTO_DEV_CCP_DD depend on CPU_SUP_AMD ||
> ARM64, CRYPTO_DEV_SP_PSP gets almost the same dependency transitively.
> But sure, let's make the PSP build only on x86. It should depend on
> X86_64, to be precise.

I think theoretically a 32-bit host OS can invoke a PSP commands but
currently PSP interface is exposing only the SEV FW command. And SEV
feature is available when we are in 64-bit mode hence for now its okay
to have depends on X86_64. I will add CRYPTO_DEV_CCP_DD depend on
CPU_SUP_AMD || ARM64 and CRYPTO_DEV_SP_PSP depend on X86_64 and send you
v4.2. thanks
