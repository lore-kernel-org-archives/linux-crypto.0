Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596715CD43;
	Wed, 29 May 2024 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959695; cv=none; b=c1nijSAV0FZD/azumsisbj+1PTg9aWWeSl7ecyWss6Ra2k2Uu9FBRv3EoZq2wSWdmYvw1kv7knATY+GdaTA0WMIKjx4Qo0joyPVzf+NkC5usOvtTZ6p9A09R9uKKBk0W8QzkxmCveCf7QPKv8l5bLGQdYTNRVa6i1KJjv4uhs9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959695; c=relaxed/simple;
	bh=R1IWmO+APmHCgSvdQhuAOkBBOYRCLIbvlphe7OPdhq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Oi8Fn0e2Thjy8jIVNxZ+Yiwsl5DOGce8KJn6omEy7qDfxJxd6JSlFXFvR3yTcK0T+TSY5WKBNjb0U2SYMy+rb9qoqXyU82OrGpqwGs0a1/WUnWVFkrRkxMsLCq3umlub7o68c+Mb/pZhSEc1L/M5GxBB5+6ImCKbvTc3xnLP218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Tho0uC1u; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Tho0uC1u"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44T5E6rS040057;
	Wed, 29 May 2024 00:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1716959646;
	bh=+wd2P9cwT2cwmazRiNRg7WHatVuK5D8YXYsDIg7m92U=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=Tho0uC1uQpclgleGyVqNG4PAmZVtUV4LYh0Gsj1aCmEQweHSHyMrX1viPzbK6W5CN
	 368vCOS7jmt3d/6vBs/XtXuEFOE8rMwhsILLrP9YgjTxFgMwlxYo47kaISbL1zkxYl
	 huHYhEILO06blijmO9R+DOIap/Bpb7kKuGZru/WA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44T5E68N015798
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 May 2024 00:14:06 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 29
 May 2024 00:14:05 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 29 May 2024 00:14:05 -0500
Received: from [172.24.227.94] (uda0132425.dhcp.ti.com [172.24.227.94])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44T5E0MG129167;
	Wed, 29 May 2024 00:14:00 -0500
Message-ID: <9e35f4d1-4c69-4fed-bdab-9d39a70d0bf5@ti.com>
Date: Wed, 29 May 2024 10:43:59 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] dt-bindings: crypto: Add Texas Instruments MCRC64
To: Kamlesh Gurudasani <kamlesh@ti.com>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>,
        Conor Dooley <conor@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin
	<mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230719-mcrc-upstream-v2-3-4152b987e4c2@ti.com>
 <20230811-crestless-gratify-21c9bb422375@spud>
 <20230811-imminent-fancied-89663c373ab5@spud>
 <87plt7acgg.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <c5aa0c8b-b2b4-4ad2-a8a8-ab26ee0edd22@linaro.org>
 <87ikyza7iq.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
From: Vignesh Raghavendra <vigneshr@ti.com>
Content-Language: en-US
In-Reply-To: <87ikyza7iq.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Hi Conor/Krzysztof

On 27/05/24 15:41, Kamlesh Gurudasani wrote:
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> writes:
> 
>> This message was sent from outside of Texas Instruments. 
>> Do not click links or open attachments unless you recognize the source of this email and know the content is safe. If you wish
>> to report this message to IT Security, please forward the message as an attachment to phishing@list.ti.com 
>>  
>> On 27/05/2024 10:25, Kamlesh Gurudasani wrote:
>>> Conor Dooley <conor@kernel.org> writes:
>>>
>>>> On Fri, Aug 11, 2023 at 04:34:33PM +0100, Conor Dooley wrote:
>>>>> On Fri, Aug 11, 2023 at 12:58:50AM +0530, Kamlesh Gurudasani wrote:
>>>>>> Add binding for Texas Instruments MCRC64
>>>>>>
>>>>>> MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
>>>>>> according to the ISO 3309 standard.
>>>>>>
>>>>>> The ISO 3309 64-bit CRC model parameters are as follows:
>>>>>>     Generator Polynomial: x^64 + x^4 + x^3 + x + 1
>>>>>>     Polynomial Value: 0x000000000000001B
>>>>>>     Initial value: 0x0000000000000000
>>>>>>     Reflected Input: False
>>>>>>     Reflected Output: False
>>>>>>     Xor Final: 0x0000000000000000
>>>>>>
>>>>>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>>>>>> ---
>>>>>>  Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  MAINTAINERS                                             |  5 +++++
>>>>>>  2 files changed, 52 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>>>>>> new file mode 100644
>>>>>> index 000000000000..38bc7efebd68
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>>>>>> @@ -0,0 +1,47 @@
>>>>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>>>>> +%YAML 1.2
>>>>>> +---
>>>>>> +$id: https://urldefense.com/v3/__http://devicetree.org/schemas/crypto/ti,mcrc64.yaml*__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6La54vZo$
>>>>>> +$schema: https://urldefense.com/v3/__http://devicetree.org/meta-schemas/core.yaml*__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6P2LNJCQ$
>>>>>> +
>>>>>> +title: Texas Instruments MCRC64
>>>>>> +
>>>>>> +description: The MCRC64 engine calculates 64-bit cyclic redundancy checks
>>>>>
>>>>> A newline after "description" please.
>>>>>
>>>>>> +  (CRC) according to the ISO 3309 standard.
>>>>>> +
>>>>>> +maintainers:
>>>>>> +  - Kamlesh Gurudasani <kamlesh@ti.com>
>>>>>> +
>>>>>> +properties:
>>>>>> +  compatible:
>>>>>> +    const: ti,am62-mcrc64
>>>>>
>>>>> Is the am62 an SoC or a family of SoCs? I googled a wee bit for am62 &
>>>>> there seems to be an am625 and an am623?
>>>>

Let me put this confusion to rest and clarify the ratioanle of namings
so far.

AM62 is a the name of the SoC variant. AM625/AM623/AM621/AM620 are the
Orderable Part Number (OPNs - full OPN is several digits long), the only
difference b/w them is number of CPU/GPU/PRU cores. At SoC level they
are all same with AM625 being superset.

Similarly AM62A is another SoC variant, with AM62A7 and AM62A3 are OPNs.
AM62P is yet another SoC variant with AM62P5 as OPN

Linux DT is written to support superset part numbers (AM625, AM62A7,
AM62P5) as TI EVMs always have superset parts. Board dts files are named
accordingly (eg.: k3-am625-sk.dts) Bootloader does the appropriate
fixups to disable components for subset devices based on eFUSE
indications when needed.


>>>> Or is it an am62p5, in which case the compatible should contain
>>>> ti,am62p5 I suppose. Sorry for my confusion here, its not really clear
>>>> me too since I've been seeing many different-but-similar product names
>>>> the last few days.
>>>>

MCRC64 is on all K3 platforms.

We have been using ti,am62-xxxx for all modules that were verified (or
first supported) on any of the AM625/3/1/0 SoCs. Last digit really is
represents CPU/GPU numbers, thus not relevant for peripherals and there
should be no change in HW

If peripheral is specific to AM62A (eg.: DSP) or AM62P, then
ti,am62a-xxxx and ti,am62p-xxxx is being used correspondingly.


>>>> Thanks,
>>>> Conor.
>>>>
>>> Hi Conor,
>>>
>>> Thanks for the review.
>>>
>>> am62 is family of SOCs.
>>>
>>> All devices under this family, like am623/5/p5 and etc, have MCRC64.
>>>
>>> I have kept the naming convention similar to SA2UL/SA3UL[0].
>>>
>>> [0] https://urldefense.com/v3/__https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml*L18__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6afCEd8s$
>>
>> Usual answer is: no families. There are exceptions, though, so is this
>> case on the exception list?
> Okay, will use ti,am625-mcrc64 as compatible and as fallback compatible for
> other devices. I hope that is right.

As mentioned above ti,am62-mcrc64 would be better option here and would
be consistent with rest of the peripherals being supported on the SoC.

But if we really want be accurate to exact part number on which Kamlesh
has tested then, perhaps ti,am625-mcrc64 is fine with me.


> 
> Thanks.
> 
> Kamlesh
>>
>> https://urldefense.com/v3/__https://elixir.bootlin.com/linux/v6.10-rc1/source/Documentation/devicetree/bindings/writing-bindings.rst*L42__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6WaRq1VM$
>>
>> P.S. Your email client added some weird subject prefix - please fix it.
> Thanks for bringing this to my notice, Will fix it.
>>
>>
>>
>> Best regards,
>> Krzysztof

-- 
Regards
Vignesh
