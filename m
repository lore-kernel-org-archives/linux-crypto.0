Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790B19046D;
	Tue,  1 Oct 2024 06:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727763320; cv=none; b=nTkdJSa9nATFCC8wW/FEJ2+itefs4xMlFi5l8jJF7pOJotM36fipny5+ecnwceSy9vUwtsTqQyqh9Im9mwNs2zzGgBTfCv8JJjmzR0+dDUUrg+fnP55AzSJiTQEVG/Fka5BYDcwQtQHiJpXHrsWEM1RCk2EK0bqWiiYjLxi0xvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727763320; c=relaxed/simple;
	bh=OegZC1242Zp7CgKqrvj9akACc0AqF46h+an7DqwsBlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MVLedC5xg7TZnixzCb3yylHFwwGd1JrLHBaj3qeBM9wYG8DfN+2CBMHJdDRJQKf7ggZHrkWUEZNk7WDjxznjuCV784rZV+lTixBN71yrQPmhHLJOB6OiTS6CMgOeSKgzRSg5o/UIGpbhTtzdOeVXshNEd3SXoYtjMRSrmD7UhCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAO3yY/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAO3yY/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC857C4CEC6;
	Tue,  1 Oct 2024 06:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727763319;
	bh=OegZC1242Zp7CgKqrvj9akACc0AqF46h+an7DqwsBlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VAO3yY/jzbn0YIB5e2g1a38pH7KRmQhW1cFjIcekvwz5TnDP6orkqbEE0GaB+X6ea
	 sHaT0dcALPuWVkG7YWQvbZZ3DNb2eK/LeFajfSDmnE9gV+uHyw2/nvEam+At2aQeoF
	 3RCj7dN9kyBF1ujr3HjXQvLJEjHBB4bjxvwUh0hxuPZTXhgPhuY/Nx9Da19uXI71+o
	 uKAm/W7SA1UYe0xrOJ4qhV6567v2aQAog5zM5Hc7U27O4uGUWtDaSytzmEfhEw6ekB
	 1DMkKNZWQdmMGRWneqw+LGanlB6FwFMZeCUEMPimKAB1wYVSewJROX8f+CFuV7YQwx
	 j3I2IYNvBTZ5Q==
Message-ID: <5f3969cb-268e-4383-a6b9-51c169f2e94a@kernel.org>
Date: Tue, 1 Oct 2024 08:15:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 7/7] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, robh@kernel.org, Ruud.Derwig@synopsys.com,
 manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
References: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
 <20240930093054.215809-8-pavitrakumarm@vayavyalabs.com>
 <6ae71793-4188-4356-b314-e2d2db5b3cb1@kernel.org>
 <CALxtO0=7+8sX5LXK0XLjrCJH7P3s9FkKWPGVjp2q_dgq1q2M3g@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <CALxtO0=7+8sX5LXK0XLjrCJH7P3s9FkKWPGVjp2q_dgq1q2M3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 01/10/2024 04:57, Pavitrakumar Managutte wrote:
> Hi Krzysztof,
>    Thanks for the quick review and I do really appreciate everybody's time here.
>    If something got missed, it's just because of the exhaustive
> hardware and the SystemC Model testing.
>    We make minimal/incremental changes and run things in debug mode
> which takes a lot of time,
>    since this is a large code base. Never ignored anything till date.
>    Every single comment has been and will be addressed. We will work
> on code quality as per your inputs.

No, it was not addressed.

Do you want proofs? Look:

1. Drop contains. The list of compatible strings and order must be defined.
Not addressed at all.

2. crypto@40000000
Ignored completely

3.  Generally drivers aren't limited to some number of instances (except...
Also ignored completely

and more..


> 
> Warm regards,
> PK
> 
> 
> On Mon, Sep 30, 2024 at 6:50 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>
>> On 30/09/2024 11:30, Pavitrakumar M wrote:
>>> Add DT bindings related to the SPAcc driver for Documentation.
>>> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
>>> Engine is a crypto IP designed by Synopsys.
>>>
>>> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
>>> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
>>> Co-developed-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
>>> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
>>> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
>>> ---
>>>  .../bindings/crypto/snps,dwc-spacc.yaml       | 71 +++++++++++++++++++
>>>  1 file changed, 71 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
>>
>> Bindings come before users, so please re-order your patches.
> 
> PK: Will re-order
>>
>>
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
>>> new file mode 100644
>>> index 000000000000..6b94d0aa7280
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
>>> @@ -0,0 +1,71 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto Engine
>>> +
>>> +maintainers:
>>> +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
>>> +
>>> +description:
>>> +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine is
>>> +  a crypto IP designed by Synopsys, that can accelerate cryptographic
>>> +  operations.
>>> +
>>> +properties:
>>> +  compatible:
>>> +    contains:
>>
>> Nope, you cannot have contains. From where did you get it? Please use
>> existing, recent bindings as starting point or just use exampl-eschema.
> 
> PK: Will fix that.
>>
>>
>> Eh, you already got this comment and just ignored it.
> 
> PK: It got missed, never ignored. Too valuable to ignore comments from demigods.
>>
>>
>> You ignored all other comments as well. This is quite disappointing to
>> ask us to do the same review over and over.
> 
> PK: That never was the intent nor the impression I wanted to make.
> Appreciate everybody's time here.

Then why do you ignore review?

Best regards,
Krzysztof

