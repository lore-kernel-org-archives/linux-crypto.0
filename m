From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v7 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 2 Nov 2017 12:32:39 -0500
Message-ID: <1f54e39f-7e2b-26d0-2d22-b8ccbef67c3d@amd.com>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-14-brijesh.singh@amd.com>
 <20171102171017.t7auzgm7zqp4ncjb@pd.tnic>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102171017.t7auzgm7zqp4ncjb@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 11/02/2017 12:10 PM, Borislav Petkov wrote:
...

>>   drivers/crypto/ccp/psp-dev.c | 350 +++++++++++++++++++++++++++++++++++++++++++
>>   drivers/crypto/ccp/psp-dev.h |  24 +++
>>   drivers/crypto/ccp/sp-dev.c  |   9 ++
>>   drivers/crypto/ccp/sp-dev.h  |   4 +
>>   include/linux/psp-sev.h      | 143 ++++++++++++++++++
>>   5 files changed, 530 insertions(+)
> 
> Some more cleanups:
> 
> * If sev_data_init is per psp_device, you can simply embed it in the
> struct psp_device and save yourself the complete allocation.
> 
> * s/sev_ops_init/sev_misc_init/ because it doesn't do anything ops-like
> 
> * save some header lines.
> 


Thanks for the cleanup patch, I will apply these changes. Additionally, 
I will also embed the sev_user_data_platform_status in per psp_device 
struct instead of dvmem_kzalloc().


-Brijesh
