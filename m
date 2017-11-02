From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 00/38] x86: Secure Encrypted Virtualization (AMD)
Date: Thu, 2 Nov 2017 15:18:59 -0500
Message-ID: <14a4e716-2a74-d6ef-bf43-6794f29db1c8@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <d3b1c8a1-5073-3334-ad41-07a612a4f698@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm list <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Gary Hook <Gary.Hook@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0041.outbound.protection.outlook.com ([104.47.32.41]:62000
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934221AbdKBUTI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 16:19:08 -0400
In-Reply-To: <d3b1c8a1-5073-3334-ad41-07a612a4f698@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,


On 10/24/2017 07:14 AM, Brijesh Singh wrote:
> Hi Herbert and Paolo,
> 
> 

....

> 
> Since the PSP patches touches both the CCP and KVM driver, hence I was
> wondering if you guys have any thought on how PSP patches will be
> merged? I am talking about Patch 9 to 20 from this series. I have
> ensured that patches apply cleanly on both kvm/master and
> cryptodev-2.6/master. We can do this in one of two ways:
> 
> - Paolo can merge the PSP support through the KVM branch
> 
> or
> 
> - Herbert can create a topic branch with PSP changes and Paolo can use
> that topic branch.
> 
> Any visibility will help my next submission. thank you.
> 

Just checking, any thought on this?

Are you okay if the PSP changes are merged through the KVM tree?

-Brijesh
