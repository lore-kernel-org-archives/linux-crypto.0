Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E7213AA4E;
	Mon, 27 May 2024 10:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716804757; cv=none; b=En88YpYQ9X/qFJGnpS46lulUWYwIRjLGqONDy9sjFr4IJeukmqLYFxEURN1bna1/AiCDpnOl1VJRkJ1PthAXBvsInmIf8aUaQdFbJ+AWOBgAB3gn3xDoF2kDdXQjujOXdRDw38oyRJQ/YF2XnBFbxM6S/ZZKQgtPGxycohuKcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716804757; c=relaxed/simple;
	bh=Nu4zFkf+vdG4f/A//Ee3j7+2qsOZTO1MLXeLI38A08U=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=I6sQsajFrsVgILwLtdWQOb/31AIz2dn/QWn/rjmSaUanauT/WqsbhXxeiBOwYL0GhDQJdn2UwSqvsoCe7B8w1ZsFME7wk3fDdbc971j1wKbC6BH9Ob9FcQUZjpcpumRtA6Hki1VfPcKPn3LLPZpbJFH4X4ia/sNgO3gj1qYms/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ck9Kh7DQ; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ck9Kh7DQ"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44RABxF5067492;
	Mon, 27 May 2024 05:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1716804719;
	bh=Oqc/Z6XWmRCD3Quoa8HVoha1OHkZHirIPRb60TQWAz4=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=ck9Kh7DQK8i+/r/GF/AeKcKwodcJ+kzERxRO9A2sBv0kjnvJZBulI6LBVN9bbD2ST
	 fdmB1dBNOXxtHs7Z42BL2sSncP9c0Z0OQ9jD2AEA0nH+0cgs9mLkE7O4MsJii6wA7+
	 LapD8AwpsLx/5vwKvuO3MQD9rZ69lGrVfTDPJhX4=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44RABxLF011380
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 May 2024 05:11:59 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 27
 May 2024 05:11:58 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 27 May 2024 05:11:58 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44RABwvV091740;
	Mon, 27 May 2024 05:11:58 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Conor Dooley
	<conor@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof
 Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
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
Subject: Re: [PATCH v2 3/6] dt-bindings: crypto: Add Texas Instruments MCRC64
In-Reply-To: <c5aa0c8b-b2b4-4ad2-a8a8-ab26ee0edd22@linaro.org>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230719-mcrc-upstream-v2-3-4152b987e4c2@ti.com>
 <20230811-crestless-gratify-21c9bb422375@spud>
 <20230811-imminent-fancied-89663c373ab5@spud>
 <87plt7acgg.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <c5aa0c8b-b2b4-4ad2-a8a8-ab26ee0edd22@linaro.org>
Date: Mon, 27 May 2024 15:41:57 +0530
Message-ID: <87ikyza7iq.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> writes:

> This message was sent from outside of Texas Instruments. 
> Do not click links or open attachments unless you recognize the source of this email and know the content is safe. If you wish
> to report this message to IT Security, please forward the message as an attachment to phishing@list.ti.com 
>  
> On 27/05/2024 10:25, Kamlesh Gurudasani wrote:
>> Conor Dooley <conor@kernel.org> writes:
>> 
>>> On Fri, Aug 11, 2023 at 04:34:33PM +0100, Conor Dooley wrote:
>>>> On Fri, Aug 11, 2023 at 12:58:50AM +0530, Kamlesh Gurudasani wrote:
>>>>> Add binding for Texas Instruments MCRC64
>>>>>
>>>>> MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
>>>>> according to the ISO 3309 standard.
>>>>>
>>>>> The ISO 3309 64-bit CRC model parameters are as follows:
>>>>>     Generator Polynomial: x^64 + x^4 + x^3 + x + 1
>>>>>     Polynomial Value: 0x000000000000001B
>>>>>     Initial value: 0x0000000000000000
>>>>>     Reflected Input: False
>>>>>     Reflected Output: False
>>>>>     Xor Final: 0x0000000000000000
>>>>>
>>>>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>>  MAINTAINERS                                             |  5 +++++
>>>>>  2 files changed, 52 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>>>>> new file mode 100644
>>>>> index 000000000000..38bc7efebd68
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>>>>> @@ -0,0 +1,47 @@
>>>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>>>> +%YAML 1.2
>>>>> +---
>>>>> +$id: https://urldefense.com/v3/__http://devicetree.org/schemas/crypto/ti,mcrc64.yaml*__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6La54vZo$
>>>>> +$schema: https://urldefense.com/v3/__http://devicetree.org/meta-schemas/core.yaml*__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6P2LNJCQ$
>>>>> +
>>>>> +title: Texas Instruments MCRC64
>>>>> +
>>>>> +description: The MCRC64 engine calculates 64-bit cyclic redundancy checks
>>>>
>>>> A newline after "description" please.
>>>>
>>>>> +  (CRC) according to the ISO 3309 standard.
>>>>> +
>>>>> +maintainers:
>>>>> +  - Kamlesh Gurudasani <kamlesh@ti.com>
>>>>> +
>>>>> +properties:
>>>>> +  compatible:
>>>>> +    const: ti,am62-mcrc64
>>>>
>>>> Is the am62 an SoC or a family of SoCs? I googled a wee bit for am62 &
>>>> there seems to be an am625 and an am623?
>>>
>>> Or is it an am62p5, in which case the compatible should contain
>>> ti,am62p5 I suppose. Sorry for my confusion here, its not really clear
>>> me too since I've been seeing many different-but-similar product names
>>> the last few days.
>>>
>>> Thanks,
>>> Conor.
>>>
>> Hi Conor,
>> 
>> Thanks for the review.
>> 
>> am62 is family of SOCs.
>> 
>> All devices under this family, like am623/5/p5 and etc, have MCRC64.
>> 
>> I have kept the naming convention similar to SA2UL/SA3UL[0].
>> 
>> [0] https://urldefense.com/v3/__https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml*L18__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6afCEd8s$
>
> Usual answer is: no families. There are exceptions, though, so is this
> case on the exception list?
Okay, will use ti,am625-mcrc64 as compatible and as fallback compatible for
other devices. I hope that is right.

Thanks.

Kamlesh
>
> https://urldefense.com/v3/__https://elixir.bootlin.com/linux/v6.10-rc1/source/Documentation/devicetree/bindings/writing-bindings.rst*L42__;Iw!!G3vK!Qw75749h2ysFlROkyfLIUT9MGWlHfBEvPAbLVjScJXCPJ7vbwgxH-8hNWlJGBXGwz9Ny47eQi2mPS5R6WaRq1VM$
>
> P.S. Your email client added some weird subject prefix - please fix it.
Thanks for bringing this to my notice, Will fix it.
>
>
>
> Best regards,
> Krzysztof
