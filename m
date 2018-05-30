From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCHv2 0/2] Add new SEV commands
Date: Wed, 30 May 2018 13:44:12 -0500
Message-ID: <79caff3c-1002-9fea-1ab6-954062435633@amd.com>
References: <cover.1527274269.git.Janakarajan.Natarajan@amd.com>
 <20180530162819.4xbwb3jbbx5dey24@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530162819.4xbwb3jbbx5dey24@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/30/2018 11:28 AM, Herbert Xu wrote:
> On Fri, May 25, 2018 at 03:23:28PM -0500, Janakarajan Natarajan wrote:
>> This patchset adds two new SEV commands, introduced in SEV API v0.15
>> and v0.16 respectively.
>>
>> * DOWNLOAD_FIRMWARE allows the SEV firmware to be updated if a blob newer
>>    than or similar to the exisiting build is available.
>>
>> * GET_ID allows to query for a unique ID that can be used to retrieve the
>>    Chip Endorsment Key (CEK) public key signed by the AMD SEV Signing Key
>>    (ASK).
>>
>> v1->v2:
>> * Added cover letter.
>> * Misc changes based on Boris' feedback.
>>
>> Janakarajan Natarajan (2):
>>    crypto: ccp: Add DOWNLOAD_FIRMWARE SEV command
>>    crypto: ccp: Add GET_ID SEV command
>>
>>   drivers/crypto/ccp/psp-dev.c | 143 ++++++++++++++++++++++++++++++++++++++++---
>>   drivers/crypto/ccp/psp-dev.h |   4 ++
>>   include/linux/psp-sev.h      |  23 +++++++
>>   include/uapi/linux/psp-sev.h |  12 ++++
>>   4 files changed, 172 insertions(+), 10 deletions(-)
> 
> All applied.  Thanks.
> 


Huh. Without a Reviewed-by or an Acked-by?
