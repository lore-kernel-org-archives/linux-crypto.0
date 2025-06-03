Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34942C324C;
	Tue,  3 Jun 2025 12:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748952288; cv=none; b=pjGue9bM/jtcQcul9iVM4KSVxr3NNy8LXRtIyQYsUnEJz1hDonaaIAFvHV3wZ8AEFJ0og15KCEw5K6IrXGFFj9wy/EkHILqNSecti7I5IbioRl0jcHrTzyo4pDDjog6EgdQoSVRBdFXWlzpbDUTDnCURWYyxgIEHn2m7O8Irseo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748952288; c=relaxed/simple;
	bh=ptTi7+/EJsr4D+BMGOOB++Z+H7bm108a90duE/w9wIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g9cFfcDTA0WIW655W9apoakTz/N60OifdLf0csnqGv7zz5QOEYoNPvucHrmB7KvCvk13qOCiMLT3mk3u6JQV6XpE0G3T/UHDMMnZFisQEPBzvENVvDqvagGyex9C1l3ph0clsL3hrmkl5t7h+aptSC9a918WOsVfmDJTEIYoS8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3Y0VTDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3Y0VTDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C65BC4CEED;
	Tue,  3 Jun 2025 12:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748952284;
	bh=ptTi7+/EJsr4D+BMGOOB++Z+H7bm108a90duE/w9wIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T3Y0VTDKr6kot+65/f74CUhQo5Y64HUQBVQOBtbYPOFpJOXqcqROl7qu+RpdGBoI6
	 r7T0VGX/A59JJSBAGQFLNcAfxxJb5UAMVaTf1sy4uPGL3KrTyK1hs8XDyOo+EC99VI
	 HqC7X2H3gzjNKOMpfPcO5h0gKoXwF49bOhWtBNK9tamjIKKbhzz6it8ZgyCapHlQ8o
	 QVzngL39D9n9B6kRZM5oDDZQF2rdDAU4M6Y/E0+PqcCsniXcwZ/H2lJGnXpAjUnUHg
	 9CLsnoY2bYNr4Ow01nBE92ExeM7QdugxC0C3xLdYt2S2u5ZFvpw5PeqTlJaKoeUmME
	 PQgjWwV5TM60Q==
Message-ID: <3570be5b-cb20-4259-9a9b-959098b902d0@kernel.org>
Date: Tue, 3 Jun 2025 14:04:38 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
 manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
 Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com>
 <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
 <CALxtO0mpQtqPB0h_Wff2dLGo=Mxk02JJQkK4rn+=TuScNdSfxQ@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <CALxtO0mpQtqPB0h_Wff2dLGo=Mxk02JJQkK4rn+=TuScNdSfxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/06/2025 13:45, Pavitrakumar Managutte wrote:
> Hi Krzysztof,
>   Thanks for the inputs, my comments are embedded below.
> 
> Warm regards,
> PK
> 
> On Mon, Jun 2, 2025 at 11:28 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>
>> On 02/06/2025 07:32, Pavitrakumar Managutte wrote:
>>> Add DT bindings related to the SPAcc driver for Documentation.
>>> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
>>> Engine is a crypto IP designed by Synopsys.
>>>
>>> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
>>> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
>>> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
>>> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
>>
>> Where was this Ack given? It's not on the lists, it's not public, so it
>> cannot be after your SoB.
> 
> PK: Yes, its not on the mailing list. I will remove that.

If it was given in private, then happened for sure before you sent the
patch, so it should be above your SoB.

...

>>> +
>>> +  snps,vspacc-id:
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    description: |
>>> +      Virtual SPAcc instance identifier.
>>> +      The SPAcc hardware supports multiple virtual instances (determined by
>>> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to identify
>>> +      which virtual instance this node represents.
>>
>> No, IDs are not accepted.
> 
> PK: This represents the specific virtual SPAcc that is being used in
> the current configuration. It is used to index into the register banks
> and the context memories of the virtual SPAcc that is being used. The
> SPAcc IP can be configured as dedicated virtual SPAccs in
> heterogeneous environments.

OK. Why registers are not narrowed to only this instance? It feels like
you provide here full register space for multiple devices and then
select the bank with above ID.


> This was also discssed with Rob Herring and updated from
> "vpsacc-index" to "vspacc-id" based on Rob's inputs
> https://lore.kernel.org/linux-crypto/CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoFDDVmcL15UH_fEZ25w@mail.gmail.com/

Yeah, it is still ID and thus look at his comment about proper
justification.

> 
>>
>>> +    minimum: 0
>>> +    maximum: 7
>>> +
>>> +  snps,spacc-internal-counter:
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    description: |
>>> +      Hardware counter that generates an interrupt based on a count value.
>>> +      This counter starts ticking when there is a completed job sitting on
>>> +      the status fifo to be serviced. This makes sure that no jobs are
>>> +      starved of processing.
>>
>> Not a DT property.
> 
> PK: This is a hardware counter which starts ticking when a processed
> job is sitting on the STAT FIFO. This makes sure a JOB does not stay
> in STATUS FIFO unprocessed.
> 
> This was called watchdog timer - wdtimer, which we renamed to
> "spacc-internal-counter" based on your inputs.
> https://lore.kernel.org/linux-crypto/CALxtO0k4RkopERap_ykrMTZ4Qtdzm8hEPJGLCQ2pknQGjfQ4Eg@mail.gmail.com/

I suggested to use watchdog schema if this device has a watchdog feature.

Why would you configure here different values for the same hardware in
different boards?



Best regards,
Krzysztof
