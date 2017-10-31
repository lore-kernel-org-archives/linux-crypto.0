From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 30 Oct 2017 20:29:25 -0500
Message-ID: <de5d7e77-56d0-8cbc-1dcb-01cf3f0daeb4@amd.com>
References: <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171029204825.18260-1-brijesh.singh@amd.com>
 <20171030172150.3eibiqr44i43zbvd@pd.tnic>
 <1e89d599-b1d2-bb16-92f4-0409ee0a6ea0@amd.com>
 <20171030175708.3w3sfzbtqdvmqs62@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:64703
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753221AbdJaB3h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 21:29:37 -0400
In-Reply-To: <20171030175708.3w3sfzbtqdvmqs62@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/30/17 12:57 PM, Borislav Petkov wrote:
> On Mon, Oct 30, 2017 at 12:49:14PM -0500, Brijesh Singh wrote:
>> If the buffer is allocated on the stack then there is no guarantee that
> static global is not allocated on the stack.

Okay, Just tried static global with CONFIG_VMAP_STACK=y and I am getting
wrong physical address with __pa. PSP command fails with error code
"INVALID_ADDRESS". The same thing works fine with kmalloc() buffer.

>> I can certainly move the allocation outside, but then it may increase the
>> code size in other functions. If its not a big deal then I would prefer to
>> keep what we have.
> Avoiding repeated k*alloc calls is always a good thing. Actually kmalloc-ing 20
> bytes each time sounds like it is not worth the calling overhead to me.
>

To avoid repeated k*alloc calls, I could devm_kzalloc() these variable 
during sev_init() and reuse them when needed.
