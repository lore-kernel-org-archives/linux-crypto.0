From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Wed, 6 Sep 2017 15:38:38 -0500
Message-ID: <e32a7c0b-5985-e600-6ac2-f6ce48ad530d@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0080.outbound.protection.outlook.com ([104.47.34.80]:28224
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752313AbdIFUio (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 16:38:44 -0400
In-Reply-To: <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Boris,


On 09/06/2017 12:00 PM, Borislav Petkov wrote:

...

> --------------------------
> |diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> |index a017233..d263ba4 100644
> |--- a/drivers/crypto/ccp/sp-dev.c
> |+++ b/drivers/crypto/ccp/sp-dev.c
> --------------------------
> 
> What tree is that against? In any case, it doesn't apply here.
> 
>> This RFC is based on tip/master commit : 22db3de (Merge branch 'x86/mm').
> 

This bit of my struggle -- tip/master is not in sync with cryptodev-2.6 [1].
In order to expand the CCP driver we need the following commits from the
cryptodev-2.6

57de3aefb73f crypto: ccp - remove ccp_present() check from device initialize
d0ebbc0c407a crypto: ccp - rename ccp driver initialize files as sp device
f4d18d656f88 crypto: ccp - Abstract interrupt registeration
720419f01832 crypto: ccp - Introduce the AMD Secure Processor device
970e8303cb8d crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup

I cherry-picked these patches into tip/master before starting the SEV work.

Since these patches were already reviewed and accepted hence I did not include it
in my RFC series. I am not sure what is best way to handle it. Should I include
these patches in the series ? or just mention them in cover letter ? I am looking
for suggestions on how to best communicate it. thanks

[1] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/

My staging tree on github contain these precursor patches.


> $ git show 22db3de
> fatal: ambiguous argument '22db3de': unknown revision or path not in the working tree.
> 
> Do you have updated version of the series which you can send out?
> 
>> @@ -67,6 +74,10 @@ struct sp_device {
>>   	/* DMA caching attribute support */
>>   	unsigned int axcache;
>>   
>> +	/* get and set master device */
>> +	struct sp_device*(*get_psp_master_device)(void);
>> +	void(*set_psp_master_device)(struct sp_device *);
> 
> WARNING: missing space after return type
> #502: FILE: drivers/crypto/ccp/sp-dev.h:79:
> +       void(*set_psp_master_device)(struct sp_device *);
> 
> Don't forget to run all patches through checkpatch. Some of the warnings
> make sense.
> 
> Thx.
> 
