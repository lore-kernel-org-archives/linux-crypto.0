Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41120 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbeLLGtU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 01:49:20 -0500
Subject: Re: [PATCH] scatterlist: Update size type to support greater then 4GB
 size.
To: David Miller <davem@davemloft.net>, amhetre@nvidia.com
Cc: axboe@kernel.dk, ulf.hansson@linaro.org,
        herbert@gondor.apana.org.au, mmaddireddy@nvidia.com,
        Snikam@nvidia.com, adrian.hunter@intel.com,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        vdumpa@nvidia.com, linux-crypto@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
 <20181211.222950.1995970751331458343.davem@davemloft.net>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <5f70fc16-e3cd-37c1-e7ed-e131ad79d387@grimberg.me>
Date: Tue, 11 Dec 2018 22:49:16 -0800
MIME-Version: 1.0
In-Reply-To: <20181211.222950.1995970751331458343.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>>   struct nvme_sgl_desc {
>>   	__le64	addr;
>> -	__le32	length;
>> +	__le64	length;
>>   	__u8	rsvd[3];
>>   	__u8	type;
>>   };
> 
> Isn't this a device or protocol defined datastructure?  You can't just
> change it like this.

You're correct, we can't...
[Replied before seeing this issue was already highlighted]

The positive side is that it can safely be removed without affecting the
rest of the patch...
