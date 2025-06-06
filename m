Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F90288CA1;
	Fri,  6 Jun 2025 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749215079; cv=none; b=ZJDzk/DPZk4NihEhADrqsEotFxjoWf4nHJ7aePcdfcBqeGymCCATuIJIm4g3d1cjI4TiKDGFVsLsiFZ0OJdJc1L1kfd/V8gGTLjMrom5BUT2fKD4DD9xdGVRoZwzr0quicWcTrrV1zq+cA2SSCxv4E9G4WQHIqluPeQ16OAWimE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749215079; c=relaxed/simple;
	bh=19Tko733gYHMDfnrQv1Q4FwJ91x3JsEzgx4dOWMr4Bo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YECyscoRwQWMxshUQvXNVVXC7QSBxLd5mAUWpVcN6k+5Db0Y685C9hDC84JI7Mw6iaFFU938LZIU1cZA24a62a7685CCdlhzgN0JcjObzdg+U+yRhmOsTe3JJty65TpA1Vd7miL3YaF8SUt9b3YGp2WWZN8zmsJfMzqLk6QPzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIPZeR4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIPZeR4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A1EC4CEEB;
	Fri,  6 Jun 2025 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749215077;
	bh=19Tko733gYHMDfnrQv1Q4FwJ91x3JsEzgx4dOWMr4Bo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cIPZeR4/g3GjWpgZo/HgiJpA4K9hPy1NBzMxnwDnffyXxAtuw9gp/KRgVHUCQkGDj
	 eryUoDW6DKpA3pK2PTPbZgIRLsgmNcLUli3sC679bCSGVr/JdqK0LZ8/9gPzOoteeV
	 gOn7FvWKN9THKQZv1xvQENNMzh14SKcitL27l0U0xPGupRi4mFu5dkZHjfQJde5hah
	 S7CimZ7kQ0Vca7bw2ZjhV7SjbPkI6hP1yZAkGRlON8ETvjVZhJ6pP4WNVk1Kdrj1Ki
	 CKntD4+Qkouij+dtu66gfhsDBwGQNlmjQETk7OnpTRgpHJAhXMxMMq07eiF6XcZig5
	 5Kg5WeO9Vc40w==
Message-ID: <b207cba7-47d3-43f4-8d59-38df9ec4eec2@kernel.org>
Date: Fri, 6 Jun 2025 15:04:32 +0200
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
 <3570be5b-cb20-4259-9a9b-959098b902d0@kernel.org>
 <CALxtO0mH=GwhQxQBsmMQYd+qgAue9WxXN1XWo9BncVJvJk6d8A@mail.gmail.com>
 <cd6e92af-1304-4078-9ed7-de1cb53c66da@kernel.org>
 <CALxtO0mVMTWqidSv7LQSQd-rA_TmJy_0xgBSd=mP27kg=AXQRg@mail.gmail.com>
 <e08b2f76-17b1-4411-a428-b2f0f8a7d7fd@kernel.org>
 <CALxtO0nReqeGKY+BNCBD10KSGttxxCrFzczxPjfrQM0eXv9Eug@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 xsFNBFVDQq4BEAC6KeLOfFsAvFMBsrCrJ2bCalhPv5+KQF2PS2+iwZI8BpRZoV+Bd5kWvN79
 cFgcqTTuNHjAvxtUG8pQgGTHAObYs6xeYJtjUH0ZX6ndJ33FJYf5V3yXqqjcZ30FgHzJCFUu
 JMp7PSyMPzpUXfU12yfcRYVEMQrmplNZssmYhiTeVicuOOypWugZKVLGNm0IweVCaZ/DJDIH
 gNbpvVwjcKYrx85m9cBVEBUGaQP6AT7qlVCkrf50v8bofSIyVa2xmubbAwwFA1oxoOusjPIE
 J3iadrwpFvsZjF5uHAKS+7wHLoW9hVzOnLbX6ajk5Hf8Pb1m+VH/E8bPBNNYKkfTtypTDUCj
 NYcd27tjnXfG+SDs/EXNUAIRefCyvaRG7oRYF3Ec+2RgQDRnmmjCjoQNbFrJvJkFHlPeHaeS
 BosGY+XWKydnmsfY7SSnjAzLUGAFhLd/XDVpb1Een2XucPpKvt9ORF+48gy12FA5GduRLhQU
 vK4tU7ojoem/G23PcowM1CwPurC8sAVsQb9KmwTGh7rVz3ks3w/zfGBy3+WmLg++C2Wct6nM
 Pd8/6CBVjEWqD06/RjI2AnjIq5fSEH/BIfXXfC68nMp9BZoy3So4ZsbOlBmtAPvMYX6U8VwD
 TNeBxJu5Ex0Izf1NV9CzC3nNaFUYOY8KfN01X5SExAoVTr09ewARAQABzSVLcnp5c3p0b2Yg
 S296bG93c2tpIDxrcnprQGtlcm5lbC5vcmc+wsGVBBMBCgA/AhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgBYhBJvQfg4MUfjVlne3VBuTQ307QWKbBQJoF1BKBQkWlnSaAAoJEBuTQ307
 QWKbHukP/3t4tRp/bvDnxJfmNdNVn0gv9ep3L39IntPalBFwRKytqeQkzAju0whYWg+R/rwp
 +r2I1Fzwt7+PTjsnMFlh1AZxGDmP5MFkzVsMnfX1lGiXhYSOMP97XL6R1QSXxaWOpGNCDaUl
 ajorB0lJDcC0q3xAdwzRConxYVhlgmTrRiD8oLlSCD5baEAt5Zw17UTNDnDGmZQKR0fqLpWy
 786Lm5OScb7DjEgcA2PRm17st4UQ1kF0rQHokVaotxRM74PPDB8bCsunlghJl1DRK9s1aSuN
 hL1Pv9VD8b4dFNvCo7b4hfAANPU67W40AaaGZ3UAfmw+1MYyo4QuAZGKzaP2ukbdCD/DYnqi
 tJy88XqWtyb4UQWKNoQqGKzlYXdKsldYqrLHGoMvj1UN9XcRtXHST/IaLn72o7j7/h/Ac5EL
 8lSUVIG4TYn59NyxxAXa07Wi6zjVL1U11fTnFmE29ALYQEXKBI3KUO1A3p4sQWzU7uRmbuxn
 naUmm8RbpMcOfa9JjlXCLmQ5IP7Rr5tYZUCkZz08LIfF8UMXwH7OOEX87Y++EkAB+pzKZNNd
 hwoXulTAgjSy+OiaLtuCys9VdXLZ3Zy314azaCU3BoWgaMV0eAW/+gprWMXQM1lrlzvwlD/k
 whyy9wGf0AEPpLssLVt9VVxNjo6BIkt6d1pMg6mHsUEVzsFNBFVDXDQBEADNkrQYSREUL4D3
 Gws46JEoZ9HEQOKtkrwjrzlw/tCmqVzERRPvz2Xg8n7+HRCrgqnodIYoUh5WsU84N03KlLue
 MNsWLJBvBaubYN4JuJIdRr4dS4oyF1/fQAQPHh8Thpiz0SAZFx6iWKB7Qrz3OrGCjTPcW6ei
 OMheesVS5hxietSmlin+SilmIAPZHx7n242u6kdHOh+/SyLImKn/dh9RzatVpUKbv34eP1wA
 GldWsRxbf3WP9pFNObSzI/Bo3kA89Xx2rO2roC+Gq4LeHvo7ptzcLcrqaHUAcZ3CgFG88CnA
 6z6lBZn0WyewEcPOPdcUB2Q7D/NiUY+HDiV99rAYPJztjeTrBSTnHeSBPb+qn5ZZGQwIdUW9
 YegxWKvXXHTwB5eMzo/RB6vffwqcnHDoe0q7VgzRRZJwpi6aMIXLfeWZ5Wrwaw2zldFuO4Dt
 91pFzBSOIpeMtfgb/Pfe/a1WJ/GgaIRIBE+NUqckM+3zJHGmVPqJP/h2Iwv6nw8U+7Yyl6gU
 BLHFTg2hYnLFJI4Xjg+AX1hHFVKmvl3VBHIsBv0oDcsQWXqY+NaFahT0lRPjYtrTa1v3tem/
 JoFzZ4B0p27K+qQCF2R96hVvuEyjzBmdq2esyE6zIqftdo4MOJho8uctOiWbwNNq2U9pPWmu
 4vXVFBYIGmpyNPYzRm0QPwARAQABwsF8BBgBCgAmAhsMFiEEm9B+DgxR+NWWd7dUG5NDfTtB
 YpsFAmgXUF8FCRaWWyoACgkQG5NDfTtBYptO0w//dlXJs5/42hAXKsk+PDg3wyEFb4NpyA1v
 qmx7SfAzk9Hf6lWwU1O6AbqNMbh6PjEwadKUk1m04S7EjdQLsj/MBSgoQtCT3MDmWUUtHZd5
 RYIPnPq3WVB47GtuO6/u375tsxhtf7vt95QSYJwCB+ZUgo4T+FV4hquZ4AsRkbgavtIzQisg
 Dgv76tnEv3YHV8Jn9mi/Bu0FURF+5kpdMfgo1sq6RXNQ//TVf8yFgRtTUdXxW/qHjlYURrm2
 H4kutobVEIxiyu6m05q3e9eZB/TaMMNVORx+1kM3j7f0rwtEYUFzY1ygQfpcMDPl7pRYoJjB
 dSsm0ZuzDaCwaxg2t8hqQJBzJCezTOIkjHUsWAK+tEbU4Z4SnNpCyM3fBqsgYdJxjyC/tWVT
 AQ18NRLtPw7tK1rdcwCl0GFQHwSwk5pDpz1NH40e6lU+NcXSeiqkDDRkHlftKPV/dV+lQXiu
 jWt87ecuHlpL3uuQ0ZZNWqHgZoQLXoqC2ZV5KrtKWb/jyiFX/sxSrodALf0zf+tfHv0FZWT2
 zHjUqd0t4njD/UOsuIMOQn4Ig0SdivYPfZukb5cdasKJukG1NOpbW7yRNivaCnfZz6dTawXw
 XRIV/KDsHQiyVxKvN73bThKhONkcX2LWuD928tAR6XMM2G5ovxLe09vuOzzfTWQDsm++9UKF a/A=
In-Reply-To: <CALxtO0nReqeGKY+BNCBD10KSGttxxCrFzczxPjfrQM0eXv9Eug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/06/2025 14:58, Pavitrakumar Managutte wrote:
> On Fri, Jun 6, 2025 at 4:55 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>
>> On 06/06/2025 13:02, Pavitrakumar Managutte wrote:
>>> Hi Krzysztof,
>>>   Appreciate your inputs and feedback. My comments are embedded below.
>>>
>>> Warm regards,
>>> PK
>>>
>>> On Wed, Jun 4, 2025 at 7:37 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>>>
>>>> On 04/06/2025 14:20, Pavitrakumar Managutte wrote:
>>>>>>
>>>>>>>>> +
>>>>>>>>> +  snps,vspacc-id:
>>>>>>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>>>>>>>> +    description: |
>>>>>>>>> +      Virtual SPAcc instance identifier.
>>>>>>>>> +      The SPAcc hardware supports multiple virtual instances (determined by
>>>>>>>>> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to identify
>>>>>>>>> +      which virtual instance this node represents.
>>>>>>>>
>>>>>>>> No, IDs are not accepted.
>>>>>>>
>>>>>>> PK: This represents the specific virtual SPAcc that is being used in
>>>>>>> the current configuration. It is used to index into the register banks
>>>>>>> and the context memories of the virtual SPAcc that is being used. The
>>>>>>> SPAcc IP can be configured as dedicated virtual SPAccs in
>>>>>>> heterogeneous environments.
>>>>>>
>>>>>> OK. Why registers are not narrowed to only this instance? It feels like
>>>>>> you provide here full register space for multiple devices and then
>>>>>> select the bank with above ID.
>>>>>
>>>>> PK: No, we cant narrow the registers to only this instance since its
>>>>> is just a single SPAcc with multiple virtual SPAcc instances. The same
>>>>> set of registers(aka register banks) and context memories are
>>>>> repeated, but sit at different offset addresses (i*4000 +
>>>>> register-offsets). The crypto hardware engine inside is shared by all
>>>>> the virtual SPAccs. This is very much for a heterogeneous computing
>>>>> scenario.
>>>>
>>>> Then maybe you have one crypto engine? You ask us to guess all of this,
>>>> also because you do not upstream the DTS for real product. Any
>>>> mentioning of "virtual" already raises concerns...
>>>
>>> PK: Yes this is a single crypto engine, maybe I should have detailed
>>> that in the cover letter. I will fix that. And what I have pushed in
>>
>> So one node, thus no need for this entire virtual device split.
> 
> PK: Agreed, its one node for our test case.

We do not talk about test case. We talk about this device.
> 
>>
>>> the patch is my complete DTS. It might need updating depending on the
>>
>> If this is complete, then obviously "snps,vspacc-id" is not necessary.
> 
> PK: Yes, its one node, to keep things simple. So we pick a virtual
> spacc with its vspacc-id for testing. That way we could test all the
> virtual spaccs with a single node, on a need basis.
> 
> On the other hand we could create 'n' nodes for 'n' virtual spaccs and

You said it is complete, now you said you have 'n' more.

> register 'n' vspacc devices with the crypto subsystem. And bind the
> individual nodes with unique vspacc-ids. That might depend on the

I don't understand what is "binding" here. Use Linux or DT terminology.

> vendor use case, for which we will add incremental support.

You did not get the point but you keep saying "yes". This discussion is
getting meaningless and you really do not want to listen. You have
either incomplete picture here or you have only one node. In both cases
virtual ID is not necessary. If you claim virtual ID is necessary, I
claim you have here incomplete picture and you are trying to represent
one device in multiple nodes. No.

Typically one device, one node.

NOT one device and 10 virtual nodes representing virtual devices.

Amount of ping pongs here is way beyond my patience, so before you
respond read that carefully and come with full and accurate hardware
description, so we will not have to ping pong trying to get any sort of
details.

Best regards,
Krzysztof
