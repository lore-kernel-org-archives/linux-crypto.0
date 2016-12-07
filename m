From: "Rob (William) Rice" <rob.rice@broadcom.com>
Subject: Re: [PATCH 1/3] crypto: brcm: DT documentation for Broadcom SPU
 driver
Date: Wed, 7 Dec 2016 10:46:04 -0500
Message-ID: <930dc7ae-42fe-8945-5b86-db3a4304aa96@broadcom.com>
References: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
 <1480536453-24781-2-git-send-email-rob.rice@broadcom.com>
 <20161206140607.GB24177@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Steve Lin <steven.lin1@broadcom.com>
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:32907 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbcLGPqI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 10:46:08 -0500
Received: by mail-pg0-f54.google.com with SMTP id 3so163288260pgd.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2016 07:46:07 -0800 (PST)
In-Reply-To: <20161206140607.GB24177@leverpostej>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark,

Thanks for your comments. Replies below.

Rob


On 12/6/2016 9:06 AM, Mark Rutland wrote:
> On Wed, Nov 30, 2016 at 03:07:31PM -0500, Rob Rice wrote:
>> Device tree documentation for Broadcom Secure Processing Unit
>> (SPU) crypto driver.
>>
>> Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
>> Signed-off-by: Rob Rice <rob.rice@broadcom.com>
>> ---
>>   .../devicetree/bindings/crypto/brcm,spu-crypto.txt | 25 ++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
>> new file mode 100644
>> index 0000000..e5fe942
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
>> @@ -0,0 +1,25 @@
>> +The Broadcom Secure Processing Unit (SPU) driver supports symmetric
>> +cryptographic offload for Broadcom SoCs with SPU hardware. A SoC may have
>> +multiple SPU hardware blocks.
> Bindings shound describe *hardware*, not *drivers*. Please drop mention
> of the driver, and just decribe the hardware.
Makes sense. I'll change it.
>
>> +Required properties:
>> +- compatible : Should be "brcm,spum-crypto" for devices with SPU-M hardware
>> +  (e.g., Northstar2) or "brcm,spum-nsp-crypto" for the Northstar Plus variant
>> +  of the SPU-M hardware.
>> +
>> +- reg: Should contain SPU registers location and length.
>> +- mboxes: A list of mailbox channels to be used by the kernel driver. Mailbox
>> +channels correspond to DMA rings on the device.
>> +
>> +Example:
>> +	spu-crypto@612d0000 {
>> +		compatible = "brcm,spum-crypto";
>> +		reg = <0 0x612d0000 0 0x900>,    /* SPU 0 control regs */
>> +			<0 0x612f0000 0 0x900>,  /* SPU 1 control regs */
>> +			<0 0x61310000 0 0x900>,  /* SPU 2 control regs */
>> +			<0 0x61330000 0 0x900>;  /* SPU 3 control regs */
> The above didn't mention there were several register sets, and the
> comment beside each makes them sound like they're separate SPU
> instances, so I don't think it makes sense to group them as one node.
>
> What's going on here?
That's right. For the SoC I used as the example, there are four SPU 
hardware blocks. The driver round robins crypto requests to the hardware 
blocks to handle requests in parallel and increase throughput. I want 
one instance of the SPU driver that registers algos once with the crypto 
API and manages all the mailbox channels. Maybe I can achieve that with 
separate device tree entries for each SPU block, I'm not sure. I'll look 
into it.
>
>> +		mboxes = <&pdc0 0>,
>> +			<&pdc1 0>,
>> +			<&pdc2 0>,
>> +			<&pdc3 0>;
> Does each mbox correspond to one of the SPUs above? Or is there a shared
> pool?
Yes, each of these mailbox channels corresponds to a different SPU. PDC 
is a DMA ring manager for DMAs to the SPUs.
>
> Thanks,
> Mark.
