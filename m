From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v6 0/4] Broadcom SBA RAID support
Date: Wed, 15 Mar 2017 13:32:05 +0530
Message-ID: <CAALAos9CsqNGX6-fB6vOWhG_7M2CfGTD1gfp-iLcu39aR4oZzw@mail.gmail.com>
References: <1488793408-25592-1-git-send-email-anup.patel@broadcom.com> <CAPcyv4hGGbhF-g8B__9=rsP+QwR6RBi=WqALLgABNb1M4D3rBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34951 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbdCOICH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2017 04:02:07 -0400
Received: by mail-ua0-f181.google.com with SMTP id q7so4877273uaf.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2017 01:02:06 -0700 (PDT)
In-Reply-To: <CAPcyv4hGGbhF-g8B__9=rsP+QwR6RBi=WqALLgABNb1M4D3rBw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 14, 2017 at 10:26 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Mar 6, 2017 at 1:43 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> The Broadcom SBA RAID is a stream-based device which provides
>> RAID5/6 offload.
>>
>> It requires a SoC specific ring manager (such as Broadcom FlexRM
>> ring manager) to provide ring-based programming interface. Due to
>> this, the Broadcom SBA RAID driver (mailbox client) implements
>> DMA device having one DMA channel using a set of mailbox channels
>> provided by Broadcom SoC specific ring manager driver (mailbox
>> controller).
>>
>> The Broadcom SBA RAID hardware requires PQ disk position instead
>> of PQ disk coefficient. To address this, we have added raid_gflog
>> table which will help driver to convert PQ disk coefficient to PQ
>> disk position.
>>
>> This patchset is based on Linux-4.11-rc1 and depends on patchset
>> "[PATCH v5 0/2] Broadcom FlexRM ring manager support"
>>
>> It is also available at sba-raid-v6 branch of
>> https://github.com/Broadcom/arm64-linux.git
>>
> [..]
>>
>> Anup Patel (4):
>>   lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
>>   async_tx: Fix DMA_PREP_FENCE usage in do_async_gen_syndrome()
>>   dmaengine: Add Broadcom SBA RAID driver
>>   dt-bindings: Add DT bindings document for Broadcom SBA RAID driver
>
> For the dmaengine and async_tx changes:
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>

Thanks Dan ...

Regards,
Anup
