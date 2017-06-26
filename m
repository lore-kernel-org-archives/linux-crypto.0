From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 1/3] crypto: ccp - Use devres interface to allocate
 PCI/iomap and cleanup
Date: Mon, 26 Jun 2017 17:22:10 -0500
Message-ID: <ec17a9f8-0a5b-4d93-ca9c-a3755ff027ec@amd.com>
References: <20170623160630.63292-1-brijesh.singh@amd.com>
 <20170623160630.63292-2-brijesh.singh@amd.com>
 <262828f7-b433-b271-3caf-dbb4a8a7c5dd@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0049.outbound.protection.outlook.com ([104.47.37.49]:45246
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751492AbdFZWWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 18:22:16 -0400
In-Reply-To: <262828f7-b433-b271-3caf-dbb4a8a7c5dd@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 06/26/2017 04:17 PM, Tom Lendacky wrote:
>> +const struct ccp_vdata ccpv3_platform = {
>> +    .version = CCP_VERSION(3, 0),
>> +    .setup = NULL,
>> +    .perform = &ccp3_actions,
>> +    .bar = 2,
> 
> Platform devices don't use BARs so should probably delete this (unless
> you want to make it more generic and then use this value for the
> IORESOURCE_MEM entry).
> 

Yep, we don't need bar for platform device, it was copy paste from existing
ccpv3 structure. I will fix it in v3. thanks

>> +}
>>   #endif
>> +int ccp_dev_init(struct ccp_device *ccp)
>> +{
>> +    if (ccp->vdata->setup)
>> +        ccp->vdata->setup(ccp);
>> +
>> +    ccp->io_regs = ccp->io_map + ccp->vdata->offset;
> 
> This should be before the above call to setup().
> 

Good catch, actually the second patch takes care of it. But I agree with your
feedback, I will make sure that io_regs is set before invoking the setup() in
the first patch itself.


Thanks
Brijesh
