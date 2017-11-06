From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v7 20/38] crypto: ccp: Implement SEV_PDH_CERT_EXPORT
 ioctl command
Date: Mon, 6 Nov 2017 10:16:53 -0600
Message-ID: <280a3443-3268-5c11-4e7d-0d7874060730@amd.com>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-21-brijesh.singh@amd.com>
 <20171105113412.2xtuifkbmxwrf3ji@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0065.outbound.protection.outlook.com ([104.47.40.65]:60034
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753043AbdKFQRB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 11:17:01 -0500
In-Reply-To: <20171105113412.2xtuifkbmxwrf3ji@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 11/05/2017 05:34 AM, Borislav Petkov wrote:
...

> 
> Fixes ontop:
> 
> * !input.cert_chain_address test was repeated. I saw that by aligning
> them vertically, i.e., after making it more readable, the repetition
> became obvious.
> 
> * Do the lengths checks first and the access_ok after, in each PDH and
> cert chain test.
> 
> * Do the checks first and the allocations after, not interleaved.
> 
> * Comments are sentences which should end with a '.'
> 
> (hunk below contains also that &psp_master->cmd_buf change but you're going to
>   remove that arg anyway).
> 


I am good with all your fixup, I will apply them in v8.

-Brijesh
