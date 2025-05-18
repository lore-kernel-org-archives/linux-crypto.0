Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1FF18EB0;
	Sun, 18 May 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747575046; cv=none; b=tDCS2lInPTgJlTLN9jdnTg3GqXnd65S40jgs0FSDe65y30OXI33A5PrS3Ho0ROEozsS8F0wJnq4aymOnqfKj7t57b73ja0JPuzTeGT7A/XNqgqIdsh/yMk4IuGs+V6FFsV8TRAPecT03t4w22u6nrgbN+dtkAtSgmR7zvp9EyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747575046; c=relaxed/simple;
	bh=h/mUrVJM7mtzQeRDGH/SX1uV2RaDjsHk4zcwWMiwfOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqkUL4GHFY0Yr65M7Ak55O0sRn0ZRfwhuB1sRa2LR9C2b7e6HRwuAxpS8+nE1YL/a6ConP0MyzU+3mRG6CLbB+04LHBGYF2ZZalsPue48QnUpKe2uBQP8sJ16yfy5q369CRE3T1rQp7uG+q0MPPDaI5cZC8DYGEdTW7CzC2RVIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYCq5DG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYCq5DG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F315C4CEE7;
	Sun, 18 May 2025 13:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747575046;
	bh=h/mUrVJM7mtzQeRDGH/SX1uV2RaDjsHk4zcwWMiwfOw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WYCq5DG7waC2MM6LdpfQvZ8RuyzZWChliLdTuHptF8fsvX/+lsC7rIDg91U9ELOd+
	 jLiVo3Fqut8A8EtLNBh0HbNPL8RXya7DI+uAmwndlz7EP0uJWOtrn+QEZdgtlBpOJN
	 zuvW5eGCsC20fbexfUZHS2S1FfxW07tUMTm3i42NCK9sIKsxks/Hfy8ubYWblFJDXa
	 /AVcvAOd1LlEUZ/NJamI8LMll1sXPhdxL+GVkAruPOSc5jK33DsMLxN3nAqQIKrlSk
	 rLhsyHtcrDE+WHF/bSf0PsOnplhOhoW9tLTTzz60qZ6N6NN85PowpKpnbvQJCQRaSo
	 1WNLtflqtpsnA==
Message-ID: <1f4d4292-fbf9-42db-b4e0-6f9326b937fc@kernel.org>
Date: Sun, 18 May 2025 15:30:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 herbert@gondor.apana.org.au, robh@kernel.org, Ruud.Derwig@synopsys.com,
 Conor Dooley <conor@kernel.org>, davem@davemloft.net,
 linux-kernel@vger.kernel.org, adityak@vayavyalabs.com,
 manjunath.hadli@vayavyalabs.com, Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
 <20250505125538.2991314-2-pavitrakumarm@vayavyalabs.com>
 <5b6c66e8-3fac-408f-980c-f261ccd3fefd@kernel.org>
 <bcf5c5de-e649-491b-9849-21eeaae0b64a@kernel.org>
 <CALxtO0=jB9L4WvaZNjP5qVB1tc9UfhjC5-u7e1dhveaQF=AOEQ@mail.gmail.com>
 <19b1fca7-e1b1-4190-9bcb-7ce36fabd02e@kernel.org>
 <CALxtO0m_iVo4nnfYg5PzL5K0HgG-U2yNVeS3S0hfdXnObbJDJA@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <CALxtO0m_iVo4nnfYg5PzL5K0HgG-U2yNVeS3S0hfdXnObbJDJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/05/2025 08:30, Pavitrakumar Managutte wrote:
>>>>>
>>>>> I do not see any improvements. It seems you ignored all comments, not
>>>>> single one was responded to or addressed.
>>>
>>> PK: Addressed all the below
>>>
>>> 1. SoC Bindings: We dont have any SoC bindings since its tested on the
>>> Zynq platform (on FPGA). So I have retained just the Synopsys SPAcc
>>> device here. Also added a detailed description for the same, which
>>> describes how we have tested the SPAcc peripheral on Zynq. This was
>>> based on your inputs to describe the existing hardware.
>>
>> 1. I asked to use SoC specific compatibles and after such explanation
>> that you use it in some different, hardware configuration, I asked to
>> use that.
>>
>> Reflect whatever your hardware is called in the compatible.
> 
> PK: Some context from my side which might clear up things
> 1. We have developed the SPAcc Crypto Linux driver for the Synopsys SPAcc IP.
> 2. Yes, this is technically a soft IP which we test on FPGA (Zynq
> Ultrascale Boards).
> 3. We are NOT evaluating SPAcc IP and thus its not a custom use case
> or a custom hardware.
> 4. Also SPAcc IP is NOT part of any SoC yet, but it may be in future.
> 
> Synopsys Semiconductor IP Business:
> Synopsys develops Semiconductor IPs (aka DesignWare IPs) and provides
> Linux device drivers to the SoC Vendors. We, as partners of Synopsys,
> develop Linux device drivers for the IP, in this case SPAcc. So as of
> now SPAcc is just a semiconductor IP which is not part of any SoC. A
> 3rd party SoC vendor would take this and integrate this as part of
> their upcoming SoC.
> 
> SPAcc Semiconductor IP details:
> https://www.synopsys.com/designware-ip/security-ip/security-protocol-accelerators.html
> 
> Synopsys DesignWare IPs
> 1. DWC MMC Host controller drivers : drivers/mmc/host/dw_mmc.c
> 2. DWC HSOTG Driver : drivers/usb/dwc2, drivers/usb/dwc3
> 3. DWC Ethernet driver : drivers/net/ethernet/synopsys
> 4. DWC DMA driver : drivers/dma/dw/
> 
> Intent of upstreaming IP drivers by Synopsys
> 1. As a Semiconductor IP designer, Synopsys provides Linux device
> drivers with their IPs to the customers.
> 2. These Linux drivers handle all the configurations in those respective IPs.
> 3. At this stage of driver development, the focus is on the Semiconductor IP
> 4. Yes, the IP can be configured differently for different SoCs and
> the driver has to take care of that.
> 5. The driver might need some enhancements based on the SoC
> configurations, which could be done later.
> 6. Its a good approach to upstream IP drivers, so the vendors could
> use/enhance the same open sourced drivers.


Yeah, I am familiar with this...

> 
>>
>> I claim this cannot be used in a SoC without customization. If I
> 
> PK: Synopsys SPAcc is a highly configurable semiconductor IP. I agree
> that it can be customized for the SoC vendors. But I dont understand
> why it can't be used without SoC customizations for a default


Ask hardware team what is necessary to implement given IP in an SoC. SoC
architectures are not that simple, that you copy&paste some piece of
VHDL code and it plugs into existing wiring. You need that wiring, you
need that SoC specific bits in your design.

> configuration. All the IP customizations are handled by the driver.

I don't talk about driver. We talk about hardware and bindings.

> Say, in the case of SPAcc, all the IP customizations are accessible as
> part of the "Version" and "Version Extension-1, 2, 3" registers. So
> the driver uses these IP customizations and nothing gets hardcoded. In
> other cases, those customizations will come as vendor specific DT
> properties.

Do you understand the problem discussed here? There is a long standing
policy, based on actual real hardware and real cases, that you cannot
have generic compatibles for custom IP blocks. That's it.

> 
> As an IP, which can be memory mapped and with interrupt support, it
> works perfectly with a default test configuration. And this is what
> the current driver has.
> 
>> understood correctly this is soft IP in FPGA for evaluation, so no one
>> will be ever able to use it. Therefore this binding makes no sense to me
> 
> PK: No, we are not evaluating, but we have developed a driver for
> SPAcc, which has been tested on a FPGA.

So some sort of FPGA in some sort of setup which you claim with this
patch is exactly the same for every other SoC. That is the meaning of
your patch, to which I objected.

> 
>> in general: you do not add anything any customer could use. It is fine
>> to add something which you use internally only, but again describe the
>> hardware properly.
> 
> PK: Its not an internal use case. We have tested the SPAcc driver on a
> FPGA, as detailed above. We dont have any custom hardware and the
> SPAcc IP is tested in a default configuration.
> 
> Question : Could you help me understand how a semiconductor IP vendor
> like Synopsys, upstream Linux drivers for its IPs? In the current

We are not even talking here about drives. I do not have to provide you
answers for drivers.

I explained already what I expect from bindings: real hardware
description, so either real SoC or whatever you are having there.

> scheme of things, if the SoC bindings are mandatory then we dont have
> them at this stage. Those would have to come from the 3rd party SoC
> vendors.
> 
> As a work around, I could add SPAcc bindings to Synopsys's "nsimosci".
> Please let me know.
> ARC - linux/arch/arc/boot/dts/nsimosci.dts
> 
>>
>> 2. I wrote you entire guide what is wrong with your Cc addresses and
>> this was fully ignored. Neither responded to, nor resolved.
> 
> PK: I have fixed that.


How? How can you fix a sent v2 with the same issues I pointed out before?


Best regards,
Krzysztof
